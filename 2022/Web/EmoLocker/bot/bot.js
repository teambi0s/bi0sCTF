// Emo_Locker_v4
const puppeteer = require('puppeteer');
var queue = require('../redis-controller/queue');
const queueName = __filename.split(".")[0].split("/").pop();

const challName = "emolocker"

async function url_visit (url) {
    var quote;
    return new Promise(async function(resolve, reject) {
        // start modification
        
        const browser = await puppeteer.launch({
            executablePath: '/home/bot/latest/chrome', 
            args: ['--ignore-certificate-errors'],
            ignoreHTTPSErrors: true,
            headless: true
        }); 
        const page = await browser.newPage();
        const password = [51,32,73,34,85,126,17,158,79,50];
        
        if (url.startsWith("http://web.chall.bi0s.in:10101/")) { 
            await page.goto("http://web.chall.bi0s.in:10101/", {waitUntil: 'networkidle2'});
            await page.goto(url, {waitUntil: 'networkidle2'});
            await page.focus('input[class="form-control"][type="text"]')
            await page.keyboard.type("admin");
            
            for (let i=0; i < password.length; i++)
            {
                await page.$eval(`span[role=img][aria-label='${password[i]}']`, elem => elem.click());
                try {
                    await page.waitForTimeout(500);
                } catch (e) {
    
                }
            }
                
            try {
                await page.waitForTimeout(1500);
            } catch (e) {

            }
            await page.$eval(`button[class="btn btn-block btn-info"]`, elem => elem.click());
            try {
                await page.waitForTimeout(4000);
                await page.waitForNavigation();
            } catch (e) {
                console.log()
            }
            
        }
             
        await browser.close();

        // end modification
        resolve(quote);
    });
}



function popMe(){
    queue.pop(queueName,sendUrl)
}

async function sendUrl(err, url) {
    if (err) {
        throw err;
    }

    if (!url) {
        setTimeout(popMe, 1e3); // if null is returned, wait for a sec before retrying
    } else {
        console.log(url)
        q = await url_visit(url)
        popMe();
    } 
}

console.log(`Started bot for chall ${challName} with id ${queueName}`)
popMe()

