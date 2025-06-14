import puppeteer from "puppeteer";
import { Filter } from "bad-words";
import { prisma } from "@/lib/prisma";

export async function POST(req) {
  const body = await req.json();
  const { chatId, userEmail } = body;

  const adminPassword = process.env.ADMIN_PASSWORD;

  if (!adminPassword) {
    return new Response(JSON.stringify({ error: "Admin password not configured" }), { status: 500 });
  }

  if (!chatId || !userEmail) {
    return new Response(JSON.stringify({ error: "Missing fields" }), { status: 400 });
  }

  const conversation = await prisma.conversation.findUnique({
    where: { id: chatId },
    include: {
      memberOne: true,
      memberTwo: true,
      messages: {
        include: {
          sender: true
        }
      }
    }
  });

  if (!conversation) {
    return new Response(JSON.stringify({ error: "Chat not found" }), { status: 404 });
  }

  const filter = new Filter();

  let browser;
  try {
    browser = await puppeteer.launch({
      headless: true,
      executablePath: process.env.PUPPETEER_EXECUTABLE_PATH,
      args: [
        "--no-sandbox",
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-gpu",
        "--disable-extensions",
        "--js-flags=--no-expose-wasm,--jitless",
      ]
    });
    
    const page = await browser.newPage();
    
    await page.setUserAgent('Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36');
    
    await page.goto("http://localhost:3000/auth/login", { 
      waitUntil: "networkidle2",
      timeout: 30000 
    });
    
    await page.type("input[name=\"email\"]", "admin@localhost.com");
    await page.type("input[name=\"password\"]", adminPassword);
    
    await Promise.all([
      page.click("button[type=\"submit\"]"),
      page.waitForNavigation({ waitUntil: "networkidle2", timeout: 30000 }),
    ]);

    await page.goto(`http://localhost:3000/chat/${chatId}`, { 
      waitUntil: "networkidle2",
      timeout: 30000 
    });
    
    await new Promise(r => setTimeout(r, 3000));

    const messages = await page.$$eval(".message", els => els.map(el => el.textContent.trim()));
    const abusiveMessages = messages.filter(msg => filter.isProfane(msg));

    if (abusiveMessages.length > 0) {
      return Response.json({ 
        success: true, 
        abusive: true, 
        abusiveMessages,
        participants: {
          sender: conversation.memberOne.id,
          receiver: conversation.memberTwo.id
        } 
      });
    }

    return Response.json({ success: true, abusive: false });

  } catch (err) {
    console.error("Puppeteer error:", err);
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });

  } finally {
    if (browser) {
      await browser.close();
    }
  }
}