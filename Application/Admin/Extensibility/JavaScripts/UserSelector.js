function userSelectorSetDivVisibility(doShow, id) {
    var div = document.getElementById(id + '_container_div');
    if (doShow)
        div.style.display = "";
    else
        div.style.display = "none";
        
}