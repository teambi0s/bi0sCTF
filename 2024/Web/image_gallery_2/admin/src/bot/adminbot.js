// image_galler_2
const puppeteer = require('puppeteer');
var queue = require('../redis-controller/queue');
const queueName = __filename.split(".")[0].split("/").pop();

const challName = "image_galler_2"

async function url_visit (url) {
    var quote;
    const FLAG = `flag{test}`
    const APP_HOST = "http://4.240.108.171"
    return new Promise(async function(resolve, reject) {
        if(!url.startsWith(APP_HOST+'/')){
            return;
        }
    
        try{
            browser = await puppeteer.launch({
                pipe: true,
                args: [
                    "--no-sandbox",
                    "--disable-setuid-sandbox",
                    "--js-flags=--noexpose_wasm,--jitless",
                    "--ignore-certificate-errors",
                    `--unsafely-treat-insecure-origin-as-secure=${APP_HOST}`
                ],
                //executablePath: "/home/bot/latest/chrome",
                executablePath: "/usr/bin/google-chrome-stable",
                headless: 'new'
            });
            console.log("lauched br")
    
            let page = await browser.newPage();
            await page.goto(APP_HOST,{ waitUntil: 'domcontentloaded'});
            console.log("first visit")
            await page.evaluate((flag)=>{
                const fileInput = document.querySelector('input[type="file"]');
    
                const myFile = new File([flag], 'flag.png', {
                    type: 'image/png',
                    lastModified: new Date(),
                });
    
                const dataTransfer = new DataTransfer();
                dataTransfer.items.add(myFile);
                fileInput.files = dataTransfer.files;
                document.forms[0].submit()
                        
            },FLAG)
            await page.waitForNavigation({ waitUntil: 'load' })
            console.log("after file upload")
            await page.close()
            page = await browser.newPage();
            await page.goto(url,{'waitUntil':'networkidle0'})
            await new Promise(r=>setTimeout(r,60000));
            console.log("after visit")
    
    
        }catch(e){ 
            console.log(e) 
            
        }
        try{
            await browser.close();
            
        }catch(e){
            console.log(e)
        }
        resolve(quote)
        
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
