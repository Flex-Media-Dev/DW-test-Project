//dialogs            
function showDelete() {
    var element = document.getElementById("warningMessageUrl");
    element.innerHTML = $('row' + ContextMenu.callingID).select("td:first")[0].innerText;
    dialog.show("confirmDeleteDialog");
}
//actions
function deleteDestination() {
    location.href = "DestinationListEdit.aspx?action=delete&destinationId=" + ContextMenu.callingItemID;
}
function editDestination() {
    location.href = "DestinationListEdit.aspx?action=save&destinationId=" + ContextMenu.callingItemID;
}
function createDestination() {
    location.href = "DestinationListEdit.aspx?action=save";
}
function clickDestination(destinationId) {
    location.href = "DestinationListEdit.aspx?action=save&destinationId=" + destinationId;
}

function verifyConnection(name, url, username, password) {
    var connectionok = false;

    var data = "destinationurl=" + encodeURIComponent(url);
    data += "&destinationusername=" + encodeURIComponent(username);
    data += "&destinationpassword=" + encodeURIComponent(password);
    data += "&destinationname=" + encodeURIComponent(name);
    
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.open("POST", "DestinationListEdit.aspx?action=verifyconnection", false);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
    xmlhttp.send(data);

    var result;
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        result = eval("(" + xmlhttp.responseText + ")");
    }

    return result || { Success: false, Message: '' };
}

function verifyConnectionClick() {
    var verifyconnectionresult = document.getElementById("verifyconnectionresult");
    verifyconnectionresult.innerHTML = 'Testing connection...';
    verifyconnectionresult.className = '';
    
    showOverlay("destinationOverlay");

    setTimeout(function () {
        var name = document.getElementById("destinationName").value;
        var url = document.getElementById("destinationUrl").value;
        var username = document.getElementById("destinationUsername").value;
        var password = document.getElementById("destinationPassword").value;

        var result = verifyConnection(name, url, username, password);
        hideOverlay("destinationOverlay");

        if (result.Success) {
            verifyconnectionresult.className = 'color-success';
            verifyconnectionresult.innerHTML = "Connected succesfully.";
        } else {
            verifyconnectionresult.className = 'color-danger';
            verifyconnectionresult.innerHTML = "Could not connect.";
            if (result.Message)
                verifyconnectionresult.innerHTML += " " + result.Message;
        }
    }, 1500);
}