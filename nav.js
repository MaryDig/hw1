function onResponseJson(response){
    console.log(response);
    if (response.status >= 200 && response.status < 300) {
        return response.json();
    }
    console.error(response.statusText)
}

function fetchLogout(){
    const URL = "logout.php";
    console.log(URL);
    fetch(URL).then(response =>{ return response.json() }).then( json => {
        console.log(JSON.stringify(json));
        console.log(json["result"]);
        if(json["result"]==1){
            alert("Disconnesione avvenuta con successo");
        }else{
            alert("Errore nella disconnessione");
        }
    })
}

function getSession(){
    const URL = "session.php";
    fetch(URL).then(response => {return response.json()}).then(json => {
        console.log(JSON.stringify(json));
        const logoutLink = document.getElementById("logoutLink");
        console.log(logoutLink);
        console.log(json["result"]=="");
        if (json["result"]==""){
            logoutLink.style.display= "none"; // da risolvereee
        }else{
            logoutLink.style.display= "block";
        }
    })
}

const logoutLink = document.getElementById("logoutLink");
logoutLink.addEventListener("click",fetchLogout);
getSession();