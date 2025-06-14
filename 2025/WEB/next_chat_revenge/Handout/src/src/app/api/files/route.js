import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth/next';
import { prisma } from '@/lib/prisma';
import { authOptions } from '../auth/[...nextauth]/route';

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
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '20');
    const skip = (page - 1) * limit;

    const personalFiles = await prisma.sentDirectMessage.findMany({
      where: {
        fileUrl: { not: null },
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
      },
      select: {
        id: true,
        fileUrl: true,
        createdAt: true,
        sender: {
          select: {
            id: true,
            name: true,
            image: true
          }
        },
        conversation: {
          select: {
            id: true,
            memberOne: { select: { id: true, name: true } },
            memberTwo: { select: { id: true, name: true } }
          }
        }
      },
      orderBy: { createdAt: 'desc' },
      skip: skip,
      take: limit
    });

    const files = personalFiles.map(file => ({
      id: file.id,
      fileUrl: file.fileUrl,
      createdAt: file.createdAt,
      type: 'direct_message',
      sender: file.sender,
      conversationId: file.conversation.id,
      conversationWith: file.sender.id === session.user.id 
        ? (file.conversation.memberOne.id === session.user.id 
          ? file.conversation.memberTwo 
          : file.conversation.memberOne)
        : file.sender
    }));

    return NextResponse.json({
      files,
      page,
      limit,
      hasMore: files.length === limit
    });
    
  } catch (error) {
    console.error('Error retrieving files:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}