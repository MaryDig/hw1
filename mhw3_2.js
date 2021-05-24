// PART 2
//////////////////////////////////////////////////////////////////////////////
// GET https://www.googleapis.com/youtube/v3/videos?part=player&chart=mostPopular&q=YouTube+Data+API&key=AIzaSyB_ytIzB3x30MCmTR5pUMhiV4GowQJPzQc
const googleApiKey = 'AIzaSyB_ytIzB3x30MCmTR5pUMhiV4GowQJPzQc';

function onJson(json){
    console.log(json);
    
    for (const item of json.items){
        const bookContainer = document.getElementById("videosContainer");
        let video = document.createElement('div');
        console.log(item.player.embedHtml);
        video.innerHTML =item.player.embedHtml.trim();
        //console.log(video.innerHTML);
        bookContainer.appendChild(video);
        // bookContainer.appendChild(item.player.embedHtml); non funziona
    }
}

function onResponse(response){
    console.log(response);
    const jsonResp = response.json();
    return jsonResp;
}

document.addEventListener("DOMContentLoaded", function() {
    const rest_url = 'https://www.googleapis.com/youtube/v3/videos?part=player&chart=mostPopular&videoCategoryId=10&q=piano&key=AIzaSyB_ytIzB3x30MCmTR5pUMhiV4GowQJPzQc';
    console.log('Rest URL:' + rest_url);
    fetch(rest_url).then(onResponse).then(onJson);
  });

