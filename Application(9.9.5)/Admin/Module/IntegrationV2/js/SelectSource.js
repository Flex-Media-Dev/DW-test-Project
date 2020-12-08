/* File Created: januar 2, 2012 */

function submit() {
    $("form1").submit();
}
function deactivateButtons() {
    if (document.getElementById("forwardButton"))
        document.getElementById("forwardButton").disabled = "disabled";
}
function activateButtons() {
    document.getElementById("forwardButton").disabled = "";
}
