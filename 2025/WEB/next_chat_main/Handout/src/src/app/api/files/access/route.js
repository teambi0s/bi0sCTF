import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth/next';
import { prisma } from '@/lib/prisma';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';

export async function GET(request) {
  try {
    const session = await getServerSession(authOptions);
    if (!session?.user?.id) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { searchParams } = new URL(request.url);
    const filePath = searchParams.get('path');
    
    if (!filePath) {
      return NextResponse.json(
        { error: 'Missing file path' },
        { status: 400 }
      );
    }
    const pathParts = filePath.split('/').filter(part => part.length > 0);
    if (pathParts.length < 3 || pathParts[0] !== 'api') {
      return NextResponse.json(
        { error: 'Invalid file path' },
        { status: 400 }
      );
    }
    
    const fileOwnerId = pathParts[2];
    
    if (fileOwnerId === session.user.id) {
      return NextResponse.json({ allowed: true });
    }
    
    const directMessageWithFile = await prisma.sentDirectMessage.findFirst({
      where: {
        fileUrl: { contains: filePath },
        OR: [
          { senderId: session.user.id },
          { conversation: {
              OR: [
                { memberOneId: session.user.id },
                { memberTwoId: session.user.id }
              ]
            }
          }
        ]
      }
    });
    
    if (directMessageWithFile) {
      return NextResponse.json({ allowed: true });
    }
    
    return NextResponse.json(
      { error: 'Access denied', allowed: false },
      { status: 403 }
    );
    
  } catch (error) {
    console.error('Error checking file access:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}