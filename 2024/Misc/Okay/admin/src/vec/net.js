const express = require("express");
const network = require("network");

var app = express();

app.get('/native',(req,res)=>{
    network.gateway_ip_for("eth0",  (err,out) => {
        if(out){
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Access-Control-Allow-Origin', '*');
            res.send(out);
        }
        else{
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Access-Control-Allow-Origin', '*');
            res.send('10.113.123.22');
        } 
    });
});

app.get('/custom',(req,res)=>{
    let resp = req.query.interface
    console.log(resp);
    network.gateway_ip_for(resp,(err,out)=>{
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.send(out);
    });
});

app.listen(3000,()=>{
    console.log("Vector listening on port 3000");
});