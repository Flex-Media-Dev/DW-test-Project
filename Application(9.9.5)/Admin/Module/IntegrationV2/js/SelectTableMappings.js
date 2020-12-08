/* File Created: januar 2, 2012 */
function toggleAll() {
    if ($("checkAll").checked) {
        $$('#tableMappings .checkbox').each(
            function (ele) {
                $(ele).checked = true;
            }
        );
        $$('.destinationTableControl').each(function (select) { select.style.visibility = 'visible' });
    }
    else {
        $$('#tableMappings .checkbox').each(
            function (ele) {
                $(ele).checked = false;
            }
        );
        $$('.destinationTableControl').each(function (select) { select.style.visibility = 'hidden' });

    }
}

document.observe('keydown', function (e) {    
    if (e.keyCode == 13) {
        e.preventDefault();
        var srcElement = e.srcElement ? e.srcElement : e.target;
        if (srcElement.id == 'newJobName') {            
            var buttons = $$("#newJob .dialog-button-ok.btn.btn-clean");
            if (buttons != null && buttons.length > 0) {
                buttons[0].click();
            }
        }
    }
});