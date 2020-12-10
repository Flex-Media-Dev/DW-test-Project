var Tabs = {
	tab: function(aciveID) {
		for (var i = 1; i < 15; i++) {
			if (document.getElementById("Tab" + i)) {
				document.getElementById("Tab" + i).style.display = "none";
			}
			if (document.getElementById("Tab" + i + "_head")) {
				document.getElementById("Tab" + i + "_head").className = "";
			}

		}
		if (document.getElementById("Tab" + aciveID)) {
			document.getElementById("Tab" + aciveID).style.display = "";
		}
		if (document.getElementById("Tab" + aciveID + "_head")) {
			document.getElementById("Tab" + aciveID + "_head").className = "activeitem";
		}
	}
}
function TabClick(elm) {
	var tabid = elm.id.replace('_head', '').replace('Tab', '');
	Tabs.tab(tabid);
}