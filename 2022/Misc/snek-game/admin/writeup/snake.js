let recvFinished=true;

let socket = new WebSocket('ws://localhost:7000/');
const sleep=ms=>new Promise(res=>setTimeout(res,ms)); 
one=true;
index=0;
let path1 = "";
let path2 = ""
num1=29
num2=30
path1+="D"
for(i=0;i<9;i++){
    path1+='D'.repeat(num1);
    path1+='R'.repeat(num2);
    path1+="U"
    num1--;
    num2--;
    path1+='L'.repeat(num2);
    path1+='U'.repeat(num1);
    path1+='R'
    num1--;
    num2--;
}
num1--;
num2--;
for(i=0;i<5;i++){
    path1+="D".repeat(num1)
    path1+='R'.repeat(1)
    path1+='D'.repeat(1);
    path1+="R".repeat(num2);
    path1+="U"
    num1--;
    num2--;
    path1+="L".repeat(num2);
    path1+="U".repeat(1);
    path1+="L".repeat(1);
    path1+="U".repeat(num1);
    path1+="R";
    num1--;
    num2--;
}
path1+="RDRUU";
path1+="L".repeat(30);

num1=29;
num2=30;
path2+="D"
for(i=0;i<8;i++){
    path2+='D'.repeat(num1);
    path2+='R'.repeat(num2);
    path2+="U";
    num1--;
    num2--;
    path2+='L'.repeat(num2);
    path2+='U'.repeat(num1);
    path2+='R'
    num1--;
    num2--;
}
path2+="D".repeat(num1);
path2+="R".repeat(num2);
path2+="U";
num1--;
num2--;
path2+="L".repeat(num2-1);
path2+="U".repeat(1);
path2+="L".repeat(1);
path2+="U".repeat(num1-1);
path2+="R";
num1--;
num2--;
for(i=0;i<5;i++){
    path2+="D".repeat(num1-1);
    path2+='R'.repeat(1);
    path2+='D'.repeat(1);
    path2+="R".repeat(num2-1);
    path2+="U";
    num1--;
    num2--;
    path2+="L".repeat(num2-1);
    path2+="U".repeat(1);
    path2+="L".repeat(1);
    path2+="U".repeat(num1-1);
    path2+="R";
    num1--;
    num2--;
}
path2+="RDRUU";
path2+="L".repeat(30);

sendDirection = async(direction) => {
    new Promise(res => {
        socket.send(direction.toLowerCase());
        res();
    });
}

loop = async() => {
    for(var i=0;i<150;i++){
        await sendDirection(path1);
        await sendDirection(path2);
    }
}

start = async()=> {
    temp='U'.repeat(26)+'L'.repeat(26);
    await sendDirection(temp);
    await loop();
}

onMessage = e =>{
	try {
        game = JSON.parse(e.data);
        console.log(game);
    } catch (_) {
        err("Invalid game received");
    }
    document.getElementById("score").innerText = game.score;
    let els = document.getElementsByClassName("element");
    for (let i = 0; i < game.size; ++i) {
        for (let j = 0; j < game.size; ++j) {
            els[j * game.size + i].className = "element";
        }
    }
    if (game.cherry) {
        els[game.cherry[1] * game.size + game.cherry[0]].className = "element t";
    }
    if (game.head) {
        els[game.head[1] * game.size + game.head[0]].className = "element h";
    }
    for(let i=0;i<game.body.length;i++){
    	els[game.body[i][1]*game.size+game.body[i][0]].className="element s"
    }
    if (game.error) {
        alert(game.error);
    }
    if(game.flag){
        alert(game.flag);
    }
	recvFinished=true;
}


advance = () =>{
	if (recvFinished) {
        socket.send(direction);
        recvFinished = false;
    }
}

window.onkeydown = e => {
    if (e.keyCode == 38) {
        direction = "u";
        advance();
    }
    else if (e.keyCode == 37) {
        direction = "l";
        advance();
    }
    else if (e.keyCode == 40) {
        direction = "d";
        advance();
    }
    else if (e.keyCode == 39) {
        direction = "r";
        advance();
    }
};


socket.onopen= () =>{
	socket.onmessage=onMessage
	socket.onclose=function(e){alert("WebSocket Closed: ");}
	socket.onerror=function(e){alert("Server error");}
    start();
}
