const items = document.querySelectorAll(".item");;
const links = document.querySelectorAll(".linkword");
const btns = document.querySelectorAll(".enter");

function showItem(){
    items[0].classList.toggle('hidden'); 
    items[1].classList.toggle('hidden');    
}

function banner(e){
    const form = e.currentTarget.parentNode;
    const textAreas = form.querySelectorAll(".textBox");
    for(const textArea of textAreas){
        if (textArea.value=="") {
            alert("Ci sono dei campi vuoti");
            break;
        }
    }
}

links[0].addEventListener('click',showItem);
links[1].addEventListener('click',showItem);

btns[0].addEventListener('click',banner);
btns[1].addEventListener('click',banner);

///////////////////////////////////////////////////////////////////////////

function controlloPassword(event){
    const pswLenght = event.srcElement.value.length;
    const psw = event.srcElement.value;
    const re = /[\$\@\#\!\?\*\+\.\&\%\(\)\_\:\,\;\/\|\=\-\']+/i;
    const avviso = document.getElementById("textBoxId");
    const avviso2 = document.getElementById("errorMessage");
    
    if(pswLenght<=3 || pswLenght>=8){
        avviso.classList.remove('hidden');
    }else{
        avviso.classList.add('hidden');
    }
    
    
    if(re.test(psw)){
        avviso2.classList.remove('hidden');
    }else{
        avviso2.classList.add('hidden');   
    }
    
}


function onResponseJson(response){
    console.log(response);
    if (response.status >= 200 && response.status < 300) {
        return response.json();
    }
    console.error(response.statusText)
}

function fetchControllEmail(event){
    console.log(event.currentTarget);
    console.log(event.target);
    const email = event.currentTarget.value;
    const URL = "query_db.php";
    const queryText = "SELECT email from Studente where email="+"'"+email+"'";
    console.log(queryText);
    const data = {"query": queryText};
    console.log( JSON.stringify(data));
    fetch(URL,{
        method: "POST",
        body: JSON.stringify(data),
        headers: { 'Accept': 'application/json', "Content-type": "application/json; charset=UTF-8"}
    }).then(onResponseJson).then(json => { 
        const avviso = document.getElementById("textBoxIdEmail");
        if(json=="") { // il risultato vuoto di php corrisponde ad una stringa vuota
            avviso.classList.add('hidden');
        }else{
            avviso.classList.remove('hidden');
        }  
    }
    );
}

const textBoxEmail = document.getElementById("textBoxEmail");
const textBoxPassword = document.getElementById("textBoxPassword");
textBoxEmail.addEventListener("keyup",fetchControllEmail);
textBoxPassword.addEventListener('keyup',controlloPassword);