const WebSocket = require("ws")
const express = require("express")
const handlebars=require("ejs")

app=express()
app.set('view engine','ejs')
app.use('/static',express.static('static'))

let size=31
const flag = process.env.FLAG || "bi0sctf{test}";

app.get("/",(req,res) => {
    res.render('index',{size:size})
})



let allowed_directions = ["u","d","l","r"]
let offset=3
let all_points=[]
for(let i=offset;i<size-offset;i++){
    for(let j=offset;j<size-offset;j++){
        all_points.push([i,j])
    }
}


function movement(game,directions){
    for(var ch=0;ch<directions.length;ch++){
        var old_head=game.head.slice();
        var old_tail=game.body[game.body.length-1].slice()
        var direction=directions[ch];
        if (allowed_directions.includes(direction)){
            if (direction == "u"){
                game.head[1] -= 1;
                for(var i=game.body.length-1;i>0;i--){
                    game.body[i] = game.body[i-1];
                }
                game.body[0]=old_head;
            }
            else if (direction == "l"){
                game.head[0] -= 1
                for(var i=game.body.length-1;i>0;i--){
                    game.body[i] = game.body[i-1];
                }
                game.body[0]=old_head
            }
            else if (direction == "r"){
                game.head[0] += 1
                for(var i=game.body.length-1;i>0;i--){
                    game.body[i] = game.body[i-1];
                }
                game.body[0]=old_head
            }
            else if (direction == "d"){
                game.head[1] += 1
                for(var i=game.body.length-1;i>0;i--){
                    game.body[i] = game.body[i-1];
                }
                game.body[0]=old_head
            }
            else{
                game["error"] = "ERROR - Invalid input"
            }
            if(game.head[0]<0 || game.head[0]>=size || game.head[1]<0 || game.head[1]>=size){
                game["head"]=old_head
                game["error"]="ERROR - Crashed into wall"
                return
            }

            game.body.forEach((point) => {
                if(point.toString()===game.head.toString()){
                    console.log(point.toString(),game.head.toString(),direction)
                    game["error"]="ERROR - Crashed into body"
                    return;
                }
            })
            if(JSON.stringify(game["head"])===JSON.stringify(game["cherry"])){
                var body_temp=game.body.slice();
                body_temp.push(game.head);
                var body=[]
                body_temp.forEach((point) => {body.push(JSON.stringify(point))})
                var del_temp=new Set(body)
                var valid_points = all_points.filter((point) => {
                    return !del_temp.has(JSON.stringify(point));
                });
                if(valid_points.length==0){
                    game["error"] = "ERROR - No space for cherry to spawn"
                    return
                }
                game["score"]+=1
                if(game["score"]==size*size-2){
                    game["flag"]=flag
                }
                game["cherry"]=valid_points[Math.floor(Math.random()*valid_points.length)]
                game["body"].push(old_tail)
            }
            //console.log(JSON.stringify(valid_points).includes(JSON.stringify([25,25])))
        }
        else{
            game["error"]="ERROR - Invlaid input"
        }
    }
}


let WSServer = WebSocket.Server;
let server = require('http').createServer();

let wss = new WSServer({
  server: server,
  perMessageDeflate: false
})
server.on('request', app);

wss.on('connection', (ws) => {
     
    ws.send(JSON.stringify({"size": size, "score": 0, "cherry": [7, 7], "head": [26, 26], "body": [[26,27]]}))
    ws.game = {"size": size, "score": 0, "cherry": [7, 7], "head": [26, 26], "body": [[26,27]]}
    //console.log(game.body.length);
    ws.on('message', (messageAsString) => {
        movement(ws.game,messageAsString.toString());
        ws.send(JSON.stringify(ws.game))
        if(ws.game.hasOwnProperty('error') || ws.game.hasOwnProperty('flag')){
            console.log("Closed:",ws.game,ws.flag)
            ws.close()
        }
    })
})

server.listen(7000, function() {
    console.log(`Listening on port 7000`);
});
