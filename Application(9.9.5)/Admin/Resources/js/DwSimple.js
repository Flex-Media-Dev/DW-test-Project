//reloads the element with a GET request for the current page, with current queryparameters.
//<parameter name=elementId>element id</parameter>
//<parameter name=callback>callback method</parameter>
//<Note>callback(document) is the expected callback signature. "document" is the fetched document.</Note>
function reloadElement(elementId, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var doc = document.implementation.createHTMLDocument("DwTemp");
            doc.documentElement.innerHTML = xhr.responseText;

            var fetchedRefreshArea = doc.getElementById(elementId);
            var current = document.getElementById(elementId);
            current.innerHTML = fetchedRefreshArea.innerHTML;

            if (callback !== undefined) {
                callback(doc);
            }
        }
    }

    xhr.open("GET", (location.pathname + location.search), true);
    xhr.setRequestHeader('Content-type', 'text/html');
    xhr.send();
}