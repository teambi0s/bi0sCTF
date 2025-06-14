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

    const isAdmin = session.user.role === "ADMIN";

    const { conversationId } = params;

    const conversation = await prisma.conversation.findUnique({
      where: { id: conversationId },
      include: {
        memberOne: {
          select: {
            id: true,
            name: true,
            email: true,
            image: true,
            status: true,
          },
        },
        memberTwo: {
          select: {
            id: true,
            name: true,
            email: true,
            image: true,
            status: true,
          },
        },
      },
    });

    if (!conversation) {
      return NextResponse.json({ error: "Conversation not found" }, { status: 404 });
    }

    if (
      !isAdmin &&
      conversation.memberOne.id !== session.user.id &&
      conversation.memberTwo.id !== session.user.id
    ) {
      return new NextResponse("Unauthorized", { status: 401 });
    }

    const participants = [conversation.memberOne, conversation.memberTwo];
    
    return NextResponse.json(participants);
  } catch (error) {
    console.error("Error fetching conversation participants:", error);
    return NextResponse.json(
      { error: "Failed to fetch conversation participants" },
      { status: 500 }
    );
  }
}