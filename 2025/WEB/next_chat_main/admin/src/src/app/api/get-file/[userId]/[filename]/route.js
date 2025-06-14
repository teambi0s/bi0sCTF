import { NextResponse } from 'next/server';
import fs from 'fs/promises';
import path from 'path';
import mime from 'mime-types';
import { getServerSession } from 'next-auth/next';
import { prisma } from '@/lib/prisma';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';

export async function GET(req, { params }) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.id) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { userId, filename } = await params;
    if (!userId || !filename) {
      return NextResponse.json({ error: 'Missing parameters' }, { status: 400 });
    }

    const filePath = `uploads/${userId}/${filename}`;
    const dbPath = `/api/get-file/${userId}/${filename}`;
    const fullPath = path.join(process.cwd(), filePath);

    const currentUser = session.user.id;

    if (userId !== currentUser) {
      const isAllowedInDM = await prisma.sentDirectMessage.findFirst({
        where: {
          fileUrl: { contains: dbPath },
          OR: [
            { senderId: currentUser },
            {
              conversation: {
                OR: [
                  { memberOneId: currentUser },
                  { memberTwoId: currentUser }
                ]
              }
            }
          ]
        }
      });

      if (!isAllowedInDM) {
        return NextResponse.json({ error: 'Access denied' }, { status: 403 });
      }
    }

    const fileBuffer = await fs.readFile(fullPath);
    const contentType = mime.lookup(filename) || 'application/octet-stream';

    return new NextResponse(fileBuffer, {
      status: 200,
      headers: {
        'Content-Type': contentType,
        'Content-Disposition': `inline; filename="${filename}"`,
        'Accept-Ranges': 'bytes',
        'Content-Length': fileBuffer.length.toString(),
      }
    });

  } catch (err) {
    console.error('File read error:', err);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}