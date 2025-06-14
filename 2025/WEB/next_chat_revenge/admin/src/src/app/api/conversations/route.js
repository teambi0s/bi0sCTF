import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { prisma } from '@/lib/prisma';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id) {
      return new NextResponse("Unauthorized", { status: 401 });
    }

    const userId = session.user.id;
    const isAdmin = session.user.role === 'ADMIN';

    const whereClause = isAdmin
      ? {}
      : {
          OR: [
            { memberOneId: userId },
            { memberTwoId: userId }
          ]
        };

    const conversations = await prisma.conversation.findMany({
      where: whereClause,
      include: {
        memberOne: true,
        memberTwo: true,
        messages: {
          orderBy: {
            createdAt: 'desc'
          },
          take: 1
        }
      },
      orderBy: {
        messages: {
          _count: 'desc'
        }
      }
    });

    const formattedConversations = conversations.map(conversation => {
      let otherMember;

      if (isAdmin) {
        otherMember = conversation.memberTwo;
      } else {
        otherMember = conversation.memberOneId === userId 
          ? conversation.memberTwo 
          : conversation.memberOne;
      }

      const lastMessage = conversation.messages[0];
      
      return {
        id: conversation.id,
        name: otherMember?.name || 'Unknown User',
        email: otherMember?.email,
        image: otherMember?.image,
        initials: otherMember?.name ? otherMember.name.charAt(0).toUpperCase() : 'U',
        lastMessage: lastMessage?.content || 'No messages yet',
        timestamp: lastMessage?.createdAt || conversation.createdAt,
        unread: 0,
        pinned: false,
        members: 1,
        color: `bg-${['blue', 'green', 'pink', 'violet', 'amber', 'indigo', 'teal']
          [Math.floor(Math.random() * 7)]}-500`
      };
    });
    
    return NextResponse.json(formattedConversations);
    
  } catch (error) {
    console.error("Error fetching conversations:", error);
    return new NextResponse("Internal Error", { status: 500 });
  }
}

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id) {
      return new NextResponse("Unauthorized", { status: 401 });
    }
    
    const { memberTwoId } = await req.json();
    const memberOneId = session.user.id;
    
    if (!memberTwoId) {
      return new NextResponse("Member ID required", { status: 400 });
    }
    
    if (memberOneId === memberTwoId) {
      return new NextResponse("Cannot create conversation with yourself", { status: 400 });
    }
    
    const existingConversation = await prisma.conversation.findFirst({
      where: {
        OR: [
          {
            memberOneId,
            memberTwoId,
          },
          {
            memberOneId: memberTwoId,
            memberTwoId: memberOneId,
          }
        ]
      }
    });
    
    if (existingConversation) {
      return NextResponse.json(existingConversation);
    }
    
    const conversation = await prisma.conversation.create({
      data: {
        memberOneId,
        memberTwoId,
      },
      include: {
        memberOne: true,
        memberTwo: true,
      }
    });
    
    return NextResponse.json(conversation);
    
  } catch (error) {
    console.error("Error creating conversation:", error);
    return new NextResponse("Internal Error", { status: 500 });
  }
}