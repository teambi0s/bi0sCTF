// bot.js
const puppeteer = require("puppeteer");

async function visit(url, flag_id = "admin-session-placeholder") {
  const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--headless"],
    executablePath: "/usr/bin/google-chrome",
  });

  try {
    const page = await browser.newPage();

    await page.setCookie({
      name: "sid",
      value: "bi0sctf{easy_ruby_challenge_right?_Now_try_SFS_V1:)}",
      domain: "localhost", 
    });

    await page.goto(url, { timeout: 5000 });
    await new Promise((resolve) => setTimeout(resolve, 3000));

    await page.close();
    await browser.close();
  } catch (e) {
    console.error("Bot error:", e);
    await browser.close();
  }
}

if (require.main === module) {
  const url = process.argv[2];
  if (!url) {
    console.error("Usage: node bot.js <url>");
    process.exit(1);
  }
  visit(url);
}

module.exports = { visit };
