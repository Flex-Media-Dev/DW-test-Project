var Tabs = {
    tab: function (aciveID) {
        for (var i = 1; i < 15; i++) {
            if ($("Tab" + i)) {
                $("Tab" + i).style.display = "none";
            }
        }
        if ($("Tab" + aciveID)) {
            $("Tab" + aciveID).style.display = "";
        }
    }
}

function ribbonTab(numTab) {

    //activate button for each tab
    if (numTab == 1 && !Ribbon.isButtonActivate("ModuleRibbon")) {
        Ribbon.radioButton('ModuleRibbon', 'ModuleRibbon', 'group1');
    }
    else if (numTab == 2 && !Ribbon.isButtonActivate("SearchRibbon")) {
        Ribbon.radioButton('SearchRibbon', 'SearchRibbon', 'group1');
    }
    else if (numTab == 3 && !Ribbon.isButtonActivate("SecurityRibbon")) {
        Ribbon.radioButton('SecurityRibbon', 'SecurityRibbon', 'group1');
    }

    Tabs.tab(numTab);
}
