function setNone(id) {
    document.getElementById(id).value = "";
    var el = document.getElementById(id + '_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    var el = document.getElementById(id + '_label_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_list_shop');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_container_list_shop');
    if (el) {
        el.style.display = 'none';
    }
}

function setAll(id) {
    document.getElementById(id).value = '[all]' + '[s:' + document.getElementById(id + '_list_shop').value + ']';
    var el = document.getElementById(id + '_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    var el = document.getElementById(id + '_label_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_list_shop');
    if (el) {
        el.style.display = 'block';
    }
    el = document.getElementById(id + '_container_list_shop');
    if(el) {
        el.style.display = 'block';
    }    
}

function setSome(id) {
    var isSubgroups = document.getElementById(id + '_checkbox_subgroups');
    var value = (isSubgroups && isSubgroups.checked) ? '[someincluded]' : '[some]';
    value += document.getElementById(id + '_some_value').value;
    document.getElementById(id).value = value;
    var el = document.getElementById(id + '_some_main_div');
    if (el) {
        el.style.display = 'block';
    }
    var el = document.getElementById(id + '_label_some_main_div');
    if (el) {
        el.style.display = 'block';
    }
    el = document.getElementById(id + '_list_shop');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_container_list_shop');
    if (el) {
        el.style.display = 'none';
    }
}

function setSubItems(id) {
    document.getElementById(id).value = '[subitems]';
    var el = document.getElementById(id + '_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    var el = document.getElementById(id + '_label_some_main_div');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_list_shop');
    if (el) {
        el.style.display = 'none';
    }
    el = document.getElementById(id + '_container_list_shop');
    if (el) {
        el.style.display = 'none';
    }
}

function deleteSelectedProductsAndGroups(valueFieldID) {
    // Copy-paste from deleteSelectedProducts
    // Only changed the method removing the products and groups from the hidden value
    var selectedItems = getElementsByClass("selected", document, "li");
    var valueObject = document.getElementById(valueFieldID);

    for(var i = 0; i < selectedItems.length; i++) {
        var selectedItem = selectedItems[i];

        var stringToRemove = "";

        stringToRemove = selectedItem.id;

        if (stringToRemove && stringToRemove.startsWith('p_')){
            stringToRemove = stringToRemove.substr(0, 1) + ":" + stringToRemove.substr(2);
        }
        else if (stringToRemove && stringToRemove.startsWith('g_')){
            stringToRemove = stringToRemove.substr(0, 1) + ":" + stringToRemove.substr(2);
        }
        else if (stringToRemove && stringToRemove.startsWith('ss_')){
            stringToRemove = stringToRemove.substr(0, 2) + ":" + stringToRemove.substr(3);
        } else if (stringToRemove && stringToRemove.startsWith('q_')) {
            stringToRemove = stringToRemove.substr(0, 1) + ":" + stringToRemove.substr(2);
        }

        if(stringToRemove != "") {
            // Remove from box
            selectedItem.innerHTML = '';
            selectedItem.outerHTML = '';
            //Remove the last character of the stringToRemove in firefox, since IE removes " from standard attributes, and firefox does not.
            if (stringToRemove.charAt(stringToRemove.length - 1) == '"'){
                stringToRemove = stringToRemove.slice(0, -1);
            }
            // Remove from hidden value
            var newValue = valueObject.value;
            newValue = replaceSubstring(newValue, ";[" + stringToRemove + "]", "");
            newValue = replaceSubstring(newValue, "[" + stringToRemove + "];", "");
            newValue = replaceSubstring(newValue, "[" + stringToRemove + "]", "");
            valueObject.value = newValue;
            valueObject.onchange();
        }
    }
}
