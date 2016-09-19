// Wait till the browser is ready to render the game (avoids glitches)
window.requestAnimationFrame(function () {
  new GameManager(4, KeyboardInputManager, HTMLActuator, LocalStorageManager);
});

function httpGet(url) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    return xmlHttp.responseText;
}

function setContainerID() {
    var hostname = httpGet("http://" + window.location.hostname + ":8888");
    var container = document.getElementsByClassName("container")[0];
    var tmp = document.createElement('div');
    tmp.innerHTML = '<p  style="position:absolute;left:60px;top:100px;">ContainerID: ' + hostname + "</p>";
    container.insertBefore(tmp, container.children[0]);
}

setContainerID();
