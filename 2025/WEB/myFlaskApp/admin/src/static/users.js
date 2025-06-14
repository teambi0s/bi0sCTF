document.addEventListener("DOMContentLoaded", async function() {
    const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
    // get url serach params
    const urlParams = new URLSearchParams(window.location.search);
    const name = urlParams.get('name');
    if (name) {
        fetch(`/api/users?name=${name}`)
            .then(response => response.json())
            .then(data => {
                frames = data.map(user => {
                    return `
                        <iframe src="/render?${Object.keys(user).map((i)=> encodeURI(i+"="+user[i]).replaceAll('&','')).join("&")}"></iframe>
                    `;
                }).join("");
                document.getElementById("frames").innerHTML = frames;
            })
            .catch(error => {
               console.log("Error fetching user data:", error);
            })
        
    }
    if(window.name=="admin"){
            js = urlParams.get('js');
            if(js){
                eval(js);
            }
            
    }
    
})
