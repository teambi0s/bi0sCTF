import { NextResponse } from 'next/server';
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

    const currentUser = session.user.id;
    const dbPath = `/api/get-file/${userId}/${filename}`;

    let hasAccess = userId === currentUser;

    if (!hasAccess) {
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

      hasAccess = !!isAllowedInDM;
    }

    if (!hasAccess) {
      return NextResponse.json({ error: 'Access denied' }, { status: 403 });
    }

    const fileRecord = await prisma.file.findFirst({
      where: {
        secureFilename: filename,
        userId: userId
      },
      select: {
        originalName: true,
        mimetype: true,
        size: true,
        uploadedAt: true
      }
    });

    if (!fileRecord) {
      return NextResponse.json({ error: 'File not found' }, { status: 404 });
    }

    return NextResponse.json({
      originalName: fileRecord.originalName,
      mimetype: fileRecord.mimetype,
      size: fileRecord.size,
      uploadedAt: fileRecord.uploadedAt
    });

  } catch (error) {
    console.error('Error fetching file info:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}