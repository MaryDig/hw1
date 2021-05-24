

function toggleHidden (event){

  const dettail = event.currentTarget;
  const description = dettail.childNodes[1];
  
  if( description.classList.contains('hidden')){
    description.classList.remove("hidden");
  }else{
    description.classList.add("hidden");
  }
}

// add esame in prenotati

function toggle_esame(event){
  const btn = event.currentTarget;
  const esame = event.currentTarget.parentElement;

  if(btn.textContent === "Prenota"){
    esami_prenotati.appendChild(esame);
    btn.textContent = "Rimuovi";
  }else{
    esami_prenotabili.appendChild(esame);
    btn.textContent = "Prenota";
  }
}

// research bar

const searchbar = document.querySelector("#searchbar");
const ricercabili = document.querySelectorAll(".item");
const contenitore_risultati_ricerca = document.querySelector("#ricercati");
const contenitore_esami = document.querySelector("#cont");

function search(event){
  const text = event.currentTarget.value;
  
  if(text !== ""){
    contenitore_esami.classList.add('hidden');
    console.log(contenitore_esami);
    for(const item of ricercabili){
      console.log(item.childNodes[1].textContent);
      if(item.childNodes[1].textContent.includes(text)){
        contenitore_risultati_ricerca.appendChild(item);
      }else{
        contenitore_esami.appendChild(item);
      }
    }
    
  }else{
    contenitore_esami.classList.remove("hidden");
    for(const item of ricercabili){
      contenitore_esami.appendChild(item);
    }
  }

}

searchbar.addEventListener("keyup",search);

// fetch caricamento esami dal database

function caricaEsamiPrenotabili(json){
  console.log(json);
  const n_esami = Object.keys(json).length;
  for (let i=0; i<n_esami-1; i++){
    const div = document.createElement("div");
    div.classList.add("item");

    const h1 = document.createElement("h1");
    h1.id = "materia";
    h1.textContent = json[i].materia;

    const a_btn = document.createElement("a");
    a_btn.classList.add("bottone2");
    a_btn.textContent = "Prenota";

    const a_dettagli = document.createElement("a");
    a_dettagli.classList.add("styleDettagli");
    a_dettagli.textContent = "Dettagli";
    //
    const div_dettagli = document.createElement("div");
    div_dettagli.classList.add("conteiner","hidden");

    const p_data = document.createElement("p");
    p_data.id = "Info";
    p_data.textContent = "Data:"+json[i].data_ora;

    const p_aula = document.createElement("p");
    p_aula.id = "Info";
    p_aula.textContent = "Aula:"+json[i].aula;

    const p_appello = document.createElement("p");
    p_appello.id = "Info";
    p_appello.classList.add("numero_appello");
    p_appello.textContent = "Appello:"+json[i].appello;

    div_dettagli.appendChild(p_data);
    div_dettagli.appendChild(document.createElement("br"));
    div_dettagli.appendChild(p_aula);
    div_dettagli.appendChild(document.createElement("br"));
    div_dettagli.appendChild(p_appello);
    //
    a_dettagli.appendChild(div_dettagli);

    div.appendChild(h1);
    div.appendChild(a_btn);
    div.appendChild(a_dettagli);
    console.log(div);
    esami_prenotabili.appendChild(div);
  }
}

function caricaEsamiPrenotati(json){
  console.log(json);
  const n_esami = Object.keys(json).length;
  for (let i=0; i<n_esami-1; i++){
    const div = document.createElement("div");
    div.classList.add("item");

    const h1 = document.createElement("h1");
    h1.id = "materia";
    h1.textContent = json[i].materia;

    const a_btn = document.createElement("a");
    a_btn.classList.add("bottone2");
    a_btn.textContent = "Rimuovi";

    const a_dettagli = document.createElement("a");
    a_dettagli.classList.add("styleDettagli");
    a_dettagli.textContent = "Dettagli";
    //
    const div_dettagli = document.createElement("div");
    div_dettagli.classList.add("conteiner","hidden");

    const p_data = document.createElement("p");
    p_data.id = "Info";
    p_data.textContent = "Data:"+json[i].data_ora;

    const p_aula = document.createElement("p");
    p_aula.id = "Info";
    p_aula.textContent = "Aula:"+json[i].aula;

    const p_appello = document.createElement("p");
    p_appello.id = "Info";
    p_appello.classList.add("numero_appello");
    p_appello.textContent = "Appello:"+json[i].appello;

    div_dettagli.appendChild(p_data);
    div_dettagli.appendChild(document.createElement("br"));
    div_dettagli.appendChild(p_aula);
    div_dettagli.appendChild(document.createElement("br"));
    div_dettagli.appendChild(p_appello);
    //
    a_dettagli.appendChild(div_dettagli);

    div.appendChild(h1);
    div.appendChild(a_btn);
    div.appendChild(a_dettagli);
    console.log(div);
    esami_prenotati.appendChild(div);
  }
}


function onResponseJson(response){
  console.log(response);
  if (response.status >= 200 && response.status < 300) {
      return response.json();
  }
  console.error(response.statusText)
}

function succesOrNot(json){
  console.log(json["result"]);
}

function examFetch(event){
  fetch("session.php").then(response => {return response.json()}).then(json => {
    console.log(json);
    if(json["type"]=="studente"){
      matricola = json["matricola"];
    }
    console.log(matricola);
 }).then(()=>{
  const queryText1 = "SELECT * FROM Corso,Esame WHERE Corso.id_corso = Esame.id_esame";
  const URL1 = "query_db.php?query="+queryText1+"&command=null";
  console.log(queryText1);
  const queryText2 = "SELECT * FROM Corso,Esame WHERE Corso.id_corso = Esame.id_esame AND Esame.appello IN "+'('+
    "SELECT id_prenotazione FROM Prenotazione WHERE portale="+matricola+')';
  const URL2 = "query_db.php?query="+queryText2+"&command=null";
  console.log(queryText1);
  fetch(URL1).then(onResponseJson).then(caricaEsamiPrenotabili).then(addExamsListeners);
  fetch(URL2).then(onResponseJson).then(caricaEsamiPrenotati).then(addExamsListeners);
  }).then(eliminaDuplicati);
  // description toggle
}

// fetch aggiunta esami prenotati nel database
function addPrenotazione_db(event){
  const button = event.currentTarget;
  //console.log(button);
  const parent = button.parentElement;
  //console.log(parent);
  const element = parent.querySelector(".numero_appello");
  //console.log(element);
  //console.log(element.textContent.split(":"));
  const appello = element.textContent.split(":")[1];
  console.log(appello);
  let matricola;

  fetch("session.php").then(response => {return response.json()}).then(json => {
     console.log(json);
     if(json["type"]=="studente"){
       matricola = json["matricola"];
     }
     console.log(matricola);
  }).then(()=>{
    const queryText = "INSERT INTO Prenotazione (id_prenotazione, portale) VALUES ("+appello+","+matricola+")";
    const URL = "query_db.php?query="+queryText+"&command=null";
    console.log(URL);
    fetch(URL).then(response => {return response.json()}).then(json =>{
      console.log(json);
      button.removeEventListener("click",addPrenotazione_db);
      button.addEventListener("click",removePrenotazione);
    })
  })
}

// fetch calcella prenotazione dal database
function removePrenotazione(event){
  const button = event.currentTarget;
  //console.log(button);
  const parent = button.parentElement;
  //console.log(parent);
  const element = parent.querySelector(".numero_appello");
  //console.log(element);
  //console.log(element.textContent.split(":"));
  const appello = element.textContent.split(":")[1];
  console.log(appello);
  let matricola;

  fetch("session.php").then(response => {return response.json()}).then(json => {
     console.log(json);
     if(json["type"]=="studente"){
       matricola = json["matricola"];
     }
     console.log(matricola);
  }).then(()=>{
    const queryText = "DELETE FROM Prenotazione WHERE id_prenotazione="+appello+" AND portale="+matricola;
    const URL = "query_db.php?query="+queryText+"&command=null";
    console.log(URL);
    fetch(URL).then(response => {return response.json()}).then(json =>{
      console.log(json);
      button.addEventListener("click",removePrenotazione);
      button.removeEventListener("click",addPrenotazione_db);
    })
  })
}

///

function addExamsListeners(){
  const dettails = document.querySelectorAll(".styleDettagli");
  
  const btns_prenota = document.querySelectorAll(".bottone2");
  
  for(const dettail of dettails){
    dettail.addEventListener("click",toggleHidden);
  }
  for(const btn of btns_prenota){
    btn.addEventListener("click", toggle_esame);
    if(btn.textContent=="Prenota"){
      btn.addEventListener("click",addPrenotazione_db);
    }else{
      btn.addEventListener("click",removePrenotazione);
    }
  }
}

// DA COMPLETARE PER ELIMINARE I DUPLICATI
/* function eliminaDuplicati(){
  const n = Object.keys(esami_prenotabili).length;
  console.log(n);
  console.log(esami_prenotati.querySelectorAll(".item"));
  const ex_prenotati = esami_prenotati.querySelectorAll(".item");
  const ex_prenotabili = esami_prenotabili.querySelectorAll(".item");
  for(const e in ex_prenotati){
    console.log("a"+e);
    for (const e2 in ex_prenotabili){
      console.log("b"+e2);
      if (e.childNodes[0].textContent==e2.childNodes[0].textContent){
        console.log(e.childNodes[0].textContent+" = "+e2.textContent);
        //e.remove();
      }
    }
  }
} */

const esami_prenotabili = document.querySelector("#cont");
const esami_prenotati = document.querySelector(".preferiti");
examFetch();


