// PART ONE
//////////////////////////////////////////////////////////////////////////////
// GET https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=yourAPIKey

const googleBooksApiKey = 'AIzaSyB_ytIzB3x30MCmTR5pUMhiV4GowQJPzQc';
const subject = 'music';
function onJson(json){
    console.log(json);
    //console.log(json.items[0]);
    //console.log(json.items[0].volumeInfo.title);
    for (let i=0; i<10; i++){
        const title = json.items[i].volumeInfo.title;
        const thumbnail = json.items[i].volumeInfo.imageLinks.thumbnail;
        
        const book = document.createElement('div');
        const img = document.createElement('img');
        const caption = document.createElement('span');

        img.src = thumbnail;
        caption.textContent = title;
        book.appendChild(img);
        book.appendChild(caption);
        const bookContainer = document.getElementById("bookContainer");
        bookContainer.appendChild(book);
    }
}
function onResponse(response){
    console.log(response);
    const jsonResp = response.json();
    return jsonResp;
}
function getElements(event){
    event.preventDefault();
    const search = document.getElementById('searchText').value;
    console.log(search);
    const rest_url = 'https://www.googleapis.com/books/v1/volumes?q='+search+'+subject:'+subject+'&key='+googleBooksApiKey;
    console.log('Rest URL:' + rest_url)
    fetch(rest_url).then(onResponse).then(onJson);
}
const form = document.getElementById("booksearch");
form.addEventListener('submit',getElements);

