import { NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";

const publicPaths = ["/auth/login", "/auth/register", "/auth/verify", "/auth/verify-request"];

export async function middleware(req) {
  try {
    const pathname = req.nextUrl.pathname;

    const isPublicPath = publicPaths.some(path => pathname.startsWith(path));

    const token = await getToken({ req, secret: process.env.NEXTAUTH_SECRET });

    if (isPublicPath && token) {
      return NextResponse.redirect(new URL("/", req.url));
    }

    if (!isPublicPath && !token) {
      return NextResponse.redirect(new URL("/auth/login", req.url));
    }

    return NextResponse.next();
  } catch (error) {
    console.error("Middleware error:", error);

    return new NextResponse("Internal server error", { status: 500 });
  }
}

export const config = {
  matcher: ["/((?!api|uploads|_next/static|_next/image|favicon.ico|images).*)"],
};