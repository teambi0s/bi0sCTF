import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { prisma } from '@/lib/prisma';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';

export async function GET(req, { params }) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id) {
      return new NextResponse("Unauthorized", { status: 401 });
    }
    
    const { conversationId } = await params;
    const userId = session.user.id;
    const isAdmin = session.user.role === 'ADMIN';

    const conversation = await prisma.conversation.findUnique({
      where: { id: conversationId },
      include: { memberOne: true, memberTwo: true }
    });
    
    if (!conversation) {
      return new NextResponse("Conversation not found", { status: 404 });
    }
    
    if (!isAdmin && conversation.memberOneId !== userId && conversation.memberTwoId !== userId) {
      return new NextResponse("Unauthorized", { status: 401 });
    }
    
    const messages = await prisma.sentDirectMessage.findMany({
      where: { conversationId },
      include: { sender: true },
      orderBy: { createdAt: 'asc' }
    });
    
    return NextResponse.json(messages);
    
  } catch (error) {
    console.error("Error fetching messages:", error);
    return new NextResponse("Internal Error", { status: 500 });
  }
}

export async function POST(req, { params }) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id) {
      return new NextResponse("Unauthorized", { status: 401 });
    }
    
    const { conversationId } = await params;
    const { content, fileUrl } = await req.json();
    const senderId = session.user.id;
    
    if (!content && !fileUrl) {
      return new NextResponse("Content or file required", { status: 400 });
    }
    
    const conversation = await prisma.conversation.findUnique({
      where: {
        id: conversationId
      }
    });
    
    if (!conversation) {
      return new NextResponse("Conversation not found", { status: 404 });
    }
    
    if (conversation.memberOneId !== senderId && conversation.memberTwoId !== senderId) {
      return new NextResponse("Unauthorized", { status: 401 });
    }
    
    const message = await prisma.sentDirectMessage.create({
      data: {
        content: content || "",
        fileUrl,
        senderId,
        conversationId
      },
      include: {
        sender: true
      }
    });
    
    return NextResponse.json(message);
    
  } catch (error) {
    console.error("Error sending message:", error);
    return new NextResponse("Internal Error", { status: 500 });
  }
}