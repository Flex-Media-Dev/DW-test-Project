function elementSelected() {
    var rows = List.getSelectedRows('RecycleList');

    if (rows.length > 0) {
        $("cmdDelete").enable(); 
        $("cmdRestore").enable();
    }
    else {
        $("cmdDelete").disable(); 
        $("cmdRestore").disable(); 
    }
}

function restoreElements(id) {
    var rows = List.getSelectedRows('RecycleList');
    if (id || rows.length > 0)
    {
        $("selectedElement").value = id || rows.map(function (el) {return el.attributes['itemid'].value;}).join("|");                
        submitForm("Restore");
    }
}
        
function newSubpage() {
           
}

function submitForm(cmd){
    $("cmd").value = cmd;
    $("MainForm").submit();
}

document.observe('dom:loaded', function () {
    $("cmdDelete").disable();
    $("cmdRestore").disable();
    if ($("cmd").value) {
        dwGlobal.getContentNavigator().reload();
    }
    $("cmd").value = "";
});