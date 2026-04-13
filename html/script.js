let audio = null;

window.addEventListener('message', function(e) {
    if (e.data.action === "open") {
        document.getElementById("carplay").classList.remove("hidden");
    }
    if (e.data.action === "close") {
        document.getElementById("carplay").classList.add("hidden");
        if (audio) audio.pause();
    }
    if (e.data.action === "play") {
        if (audio) audio.pause();
        audio = new Audio(e.data.url);
        audio.volume = 0.5;
        audio.play();
    }
    if (e.data.action === "volume") {
        if (audio) audio.volume = e.data.vol / 100;
    }
});

function playMusic() {
    fetch(`https://${GetParentResourceName()}/playMusic`, {
        method: 'POST',
        body: JSON.stringify({
            url: document.getElementById("musicUrl").value
        })
    });
}

function setVolume(v) {
    fetch(`https://${GetParentResourceName()}/setVolume`, {
        method: 'POST',
        body: JSON.stringify({ vol: v })
    });
}

function closeCarPlay() {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
}
