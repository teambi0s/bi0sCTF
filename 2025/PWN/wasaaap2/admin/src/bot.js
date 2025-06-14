const puppeteer = require("puppeteer");
const crypto = require("crypto");

const FLAG = process.env.FLAG;


async function visit(id) {
  const browser = await puppeteer.launch({
    args: [
        "--no-sandbox",
        "--headless"
    ],
    executablePath: "/usr/bin/google-chrome",
  });

  try {

    let page = await browser.newPage();

    await page.setCookie({
			httpOnly: false,
			name: 'Flag',
			value: FLAG,
			domain: 'localhost',
		});

		page = await browser.newPage();
    
    await page.goto(
      `http://localhost:3000/?s=${encodeURIComponent(id)}`,
      { timeout: 7000,
        waituntil: 'networkidle0'
       }
    );

    await new Promise((resolve) => setTimeout(resolve, 3000));
    
    await page.close();
    await browser.close();

  } catch (e) {
    console.log(e);
    await browser.close();
  }
}

module.exports = { visit };
