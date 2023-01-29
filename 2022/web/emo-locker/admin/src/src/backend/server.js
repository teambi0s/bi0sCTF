const express = require('express');
const app = express(),
    cookieParser = require('cookie-parser'),
    port = 8080,
    path = require('path'),
    levelup = require('levelup'),
    leveldown = require('leveldown');

let db = levelup(leveldown('./app-db'));

app.use(express.json());
app.use(cookieParser())
app.use('/', express.static(path.join(__dirname, '../frontend/build/')));

const choices = require("./emoji.json");
let admin_pin = [];

const flag = process.env.FLAG || "bi0s{fake_flag_for_you}";

if (process.env.EMOPIN) {
    admin_pin = process.env.EMOPIN.split(' ').map(item => {
        return parseInt(item)
    });
} else {
    admin_pin = (() => {
        return [...new Set(Array.from({
                length: 10
            }, () => Math.floor(Math.random() * 80) + 2))];
    })()
}

const adminpin_buf = Buffer.from(JSON.stringify(admin_pin));
console.log(admin_pin)

app.get('/api/choices', (req, res) => {
    return res.json(choices);
});

app.post('/api/register', async (req, res) => {
    if (req.body.username === "admin" || req.body.username.length < 5) 
        return res.json({status: "No hack"});
     else {
        await db.put(req.body.username, Buffer.from(JSON.stringify(req.body.pin)));
        return res.json({status: "success"})
    }
});

app.post('/api/login', async (req, res) => {
    try {
        const pin = Buffer.from(JSON.stringify(req.body.pin));

        if (req.body.username === "admin") {
            if (Buffer.compare(pin, adminpin_buf) === 0) {
                res.cookie("auth", flag, {httpOnly: true});
                return res.json({status: "Welcome admin !"});
            }
            throw "Unauthorized";
        } else {
            let result = Buffer.from(await db.get(req.body.username));

            if (Buffer.compare(result, pin) === 0) {
                return res.json({
                        status: `Welcome ${
                        req.body.username
                    } !`
                });
            } else {
                return res.json({status: "The emopin that you have entered is incorrect."});
            }
        }


    } catch (ex) {
        console.log(ex)
        return res.json({status: "Pls dont heck"})
    }
});

app.listen(port, () => {
    console.log(`API Server listening on ::${port}`);
});
