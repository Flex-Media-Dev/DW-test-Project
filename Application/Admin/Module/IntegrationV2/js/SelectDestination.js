/* File Created: januar 2, 2012 */

function goBack() {
    $("goBack").value = "true";
    $("form1").submit();
}
function submit() {
    $("form1").submit();
}
function deactivateButtons() {
    if (document.getElementById("forwardButton"))
        document.getElementById("forwardButton").disabled = "disabled";
    if (document.getElementById("backButton"))
        document.getElementById("backButton").disabled = "disabled";
}
function activateButtons() {
    document.getElementById("forwardButton").disabled = "";
    document.getElementById("backButton").disabled = "";
}

