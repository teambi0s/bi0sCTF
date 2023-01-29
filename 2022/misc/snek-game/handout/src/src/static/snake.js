var auto_move;
var direction = "u";
var recvFinished = true;
const interval = 250;


let socket = new WebSocket(`${window.location.href.replace('http', 'ws')}`);
//`${window.location.href.replace('http', 'ws')}ws`


onMessage = e =>{
	console.log(e)
	try {
        game = JSON.parse(e.data);
    } catch (_) {
        err("Invalid game received");
    }
    if (!auto_move) {
        auto_move = window.setInterval(advance, interval);
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
        window.clearInterval(auto_move);
    }
	recvFinished=true
}


advance = () =>{
	if (recvFinished) {
        socket.send(direction);
        //direction = "u";
        recvFinished = false;
    }
}

window.onkeydown = e => {
    //    38
    // 37 40 39
    // if (document.getElementById("err").style.display != "none") {
    //     return true;
    // }
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
    
    if (auto_move) {
        window.clearInterval(auto_move);
    }
    auto_move = window.setInterval(advance, interval);
};


socket.onopen= () =>{
	socket.onmessage=onMessage
	socket.onclose=function(e){console.log("WebSocket Closed: ");window.clearInterval(auto_move);}
	socket.onerror=function(e){alert("Server error");window.clearInterval(auto_move);}
}
// socket.onclose = alert("Websocket Closed");
// socket.onerror = alert("Server error");
//socket.onmessage=onMessage
