import { NextResponse } from 'next/server';
import { writeFile } from 'fs/promises';
import path from 'path';
import crypto from 'crypto';
import { mkdir } from 'fs/promises';
import { getServerSession } from 'next-auth/next';
import { authOptions } from '../auth/[...nextauth]/route';
import { prisma } from '@/lib/prisma';

const MAX_FILE_SIZE = 10 * 1024 * 1024;
const MAX_FILENAME_LENGTH = 255;

const ALLOWED_FILE_TYPES = {
  'image/jpeg': { ext: 'jpg' },
  'image/png': { ext: 'png' },
  'image/gif': { ext: 'gif' },
  'text/plain': { ext: 'txt' },
  'audio/mpeg': { ext: 'mp3' },
  'audio/mp4': { ext: 'mp4' },
  'video/mp4': { ext: 'mp4' },
};

const DANGEROUS_PATTERNS = [
  /\.\./,
  /^\.+$/,
  /[<>:"|?*]/,
  /^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$/i,
  /\x00/,
  /[\x00-\x1f\x80-\x9f]/,
];

function sanitizeFilename(originalName) {
  if (!originalName || typeof originalName !== 'string') {
    throw new Error('Invalid filename');
  }

  let sanitized = originalName.trim();
  if (sanitized.length > MAX_FILENAME_LENGTH) {
    const ext = path.extname(sanitized);
    const name = path.basename(sanitized, ext);
    const maxNameLength = MAX_FILENAME_LENGTH - ext.length;
    sanitized = name.substring(0, maxNameLength) + ext;
  }

  for (const pattern of DANGEROUS_PATTERNS) {
    if (pattern.test(sanitized)) {
      throw new Error('Filename contains invalid characters');
    }
  }

  sanitized = sanitized.replace(/[^\w\s.-]/g, '_');
  
  sanitized = sanitized.replace(/[\s_]+/g, '_');
  
  sanitized = sanitized.replace(/^[._]+|[._]+$/g, '');

  if (!sanitized) {
    throw new Error('Filename became empty after sanitization');
  }

  return sanitized;
}

function generateSecureFilename(mimetype) {
  const fileInfo = ALLOWED_FILE_TYPES[mimetype];
  if (!fileInfo) {
    throw new Error('Invalid file type');
  }
  
  const extension = fileInfo.ext;
  const randomName = crypto.randomBytes(16).toString('hex');
  return `${randomName}.${extension}`;
}

function validateFile(file) {
  if (!file) {
    throw new Error('No file provided');
  }
  
  if (file.size > MAX_FILE_SIZE) {
    throw new Error(`File size exceeds ${MAX_FILE_SIZE / (1024 * 1024)}MB limit`);
  }
  
  if (!ALLOWED_FILE_TYPES[file.type]) {
    throw new Error('File type not allowed');
  }
  
  return true;
}

export async function POST(request) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.id) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const userId = session.user.id;
    const formData = await request.formData();
    const file = formData.get('file');
    
    try {
      validateFile(file);
    } catch (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    const originalFilename = file.name;
    let sanitizedFilename;
    try {
      sanitizedFilename = sanitizeFilename(originalFilename);
    } catch (error) {
      return NextResponse.json(
        { error: `Invalid filename: ${error.message}` },
        { status: 400 }
      );
    }
    
    const secureFilename = generateSecureFilename(file.type);
    
    const userUploadDir = path.join(process.cwd(), 'uploads', userId);
    await mkdir(userUploadDir, { recursive: true });
    
    const filePath = path.join(userUploadDir, secureFilename);
    const buffer = Buffer.from(await file.arrayBuffer());
    await writeFile(filePath, buffer);
    
    const fileRecord = await prisma.file.create({
      data: {
        originalName: sanitizedFilename,
        secureFilename: secureFilename,
        mimetype: file.type,
        size: file.size,
        userId: userId,
        uploadedAt: new Date()
      }
    });
    
    const fileUrl = `/api/get-file/${userId}/${secureFilename}`;
    
    return NextResponse.json({ 
      fileUrl,
      fileId: fileRecord.id,
      originalName: sanitizedFilename
    }, { status: 201 });
    
  } catch (error) {
    console.error('Error uploading file:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}