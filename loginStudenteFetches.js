//FETCH DI ACCESSO

function onResponseJson(response){
    console.log(response);
    if (response.status >= 200 && response.status < 300) {
        return response.json();
    }
    console.error(response.statusText)
}

function loginFetch(event){
    event.preventDefault();
    const URL = "query_db.php";
    const email = document.getElementById("textBoxEmailLog").value;
    const password = document.getElementById("textBoxPasswordLog").value;
    const queryText = "SELECT * from Studente where email="+"'"+email+"' and password="+"'"+password+"'";
    console.log(queryText);
    const data = {query: queryText, command:"SET_SESSION"};
    console.log( JSON.stringify(data));
    console.log(data);
    fetch(URL,{
        method: "POST",
        body: JSON.stringify(data),
        headers: { 'Accept': 'application/json', "Content-type": "application/json; charset=UTF-8"}
    }).then(onResponseJson).then(json => 
        {
            console.log("JSON"+JSON.stringify(json));
            if (json["result"]=="multiple rows"){
                alert("Accesso effettuato con successo: "+json[0]["email"]);
                window.location.href = "home.php";
            }else {
                alert("Accesso non effettuato");
                window.location.href = "loginStudente.html";
            }
        });
}

const form = document.getElementById("loginForm");
form.addEventListener("submit",loginFetch);


