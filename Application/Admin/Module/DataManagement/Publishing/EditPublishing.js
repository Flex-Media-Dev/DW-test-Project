var id = null;
var cmd = null;
var txt_alertNoName = "";
var txt_alertNoSource = "";
var txt_confirmPreview = "";
var p = 0;

function InitSettings(_id, _cmd, txt1, txt2, txtAlertNoSource) {
    id = _id;
    cmd = _cmd;
    txt_alertNoName = txt1;
    txt_confirmPreview = txt2;
    txt_alertNoSource = txtAlertNoSource;
}

function doInit() {    
    document.body.style.height = parent.getContentFrameHeight() - 1 + 'px';
    
    if (doPreview) {
        window.open($("xmlURL").value, "Preview");
    }
}

function help() {
    window.open('http://manual.net.dynamicweb.dk/Default.aspx?ID=1&m=keywordfinder&keyword=modules.datamanagement.general.publishing.edit&LanguageID=' + helpLang, 'dw_help_window', 'location=no,directories=no,menubar=no,toolbar=yes,top=0,width=1024,height=' + (screen.availHeight-100) + ',resizable=yes,scrollbars=yes');
}

function save(isPreview) {
    var action = "EditPublishing.aspx?ID=" + id + "&CMD=SAVE_PUBLISHING&OnSave=Nothing";
    
    if (isPreview) {
        action += "&preview=preview";
    }
    
    saveForm(action);       
}
function saveAndClose() {
    var action = "EditPublishing.aspx?ID=" + id + "&CMD=SAVE_PUBLISHING&OnSave=Close";
    
    saveForm(action);
}

function validate() {
    var name = document.getElementById("pubName");
    var selectedSource = document.getElementById("pubView");

    if (name.length == 0) {
        alert(txt_alertNoSource);
        return false;
    }

    if (selectedSource.selectedIndex == 0) {
        alert(txt_alertNoSource);
        return false;
    }

    return true;
}

function saveForm(action) {
    if (!validate()) {
        return false;
    }
    document.getElementById('Form1').action = action;
    document.getElementById('Form1').submit();
}

function cancel() {
    document.getElementById('Form1').action = "EditPublishing.aspx?CMD=CANCEL";
    document.getElementById('Form1').submit();
}

function previewPublishing() {
    if (confirm(_txt2)) {
        save(true);
    }
}