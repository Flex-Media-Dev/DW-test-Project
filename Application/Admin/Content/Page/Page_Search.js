//taken from DW8 menu.js and converted to one-page setup
function DoSearch() {
    var myForm = document.getElementsByName('SearchForm')[0];
    myForm.submit();
}

//new in DW9
function GetHiddenPostbackCheckBoxValue(element) {
    var val = (element.value + "");
    return (val !== '');
}

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById("ModuleSearch").value = document.getElementById("hiddenModuleSearch").value;
    var isPostback = document.getElementById("hiddenIsPostback").value.toLowerCase();
    if (isPostback === 'true') {
        document.getElementById("PageSearchIn_Page").checked = GetHiddenPostbackCheckBoxValue(document.getElementById("hiddenPageSearchIn_Page"));
        document.getElementById("PageSearchIn_Paragraph").checked = GetHiddenPostbackCheckBoxValue(document.getElementById("hiddenPageSearchIn_Paragraph"));
        document.getElementById("PageSearchIn_WebsiteOnly").checked = GetHiddenPostbackCheckBoxValue(document.getElementById("hiddenPageSearchIn_WebsiteOnly"));
    }
});