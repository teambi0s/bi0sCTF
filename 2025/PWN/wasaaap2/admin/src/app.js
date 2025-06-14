const express = require('express');
const crypto = require("crypto");
const session = require("express-session");
const path = require('path');  // Add this line
const app = express();
const { visit } = require("./bot");


app.use(express.static(path.join(__dirname, 'static')));


app.use(session({
    cookie: {
        httpOnly: true,
        maxAge: 1000 * 60 * 60 * 24 * 7,
    },
    secret: crypto.randomBytes(32).toString("hex"),
    resave: false,
    saveUninitialized: true,
}));


app.get('/', (req, res) => {
    res.sendFile('index.html');
});
app.get('/bot', (req, res) => {
    visit(req.query.visit);
    res.send('ok');
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
