var LevelValueID;
var InstanceID;
var ClickToChangeString;
var openState;
var openIndex;
var AllowPermissionChange;

function PermissionTreeResizeTimeout() {
    setTimeout(PermissionTreeResize, 50);
}

function InitTreeCSS() {
    if (AllowPermissionChange) {
	    document.getElementById('subtitle' + InstanceID).onclick = ChangePermissionLevel;
	    document.getElementById('subtitle' + InstanceID).style.cursor = 'pointer';
	}

	document.getElementById('title' + InstanceID).style.position = 'relative';
	document.getElementById('subtitle' + InstanceID).style.position = 'relative';
	document.getElementById('tree1').style.position = 'relative';

	document.getElementById('nav' + InstanceID).style.padding = '0px 0px 0px 0px';
	document.getElementById('subtitle' + InstanceID).style.top = '0px';
	document.getElementById('tree1').style.top = '0px';

	document.getElementById('title' + InstanceID).style.borderTop = 'solid 1px #9FAEC2';
	document.getElementById('title' + InstanceID).style.borderLeft = 'solid 1px #9FAEC2';
	document.getElementById('subtitle' + InstanceID).style.borderLeft = 'solid 1px #9FAEC2';
	document.getElementById('tree1').style.borderLeft = 'solid 1px #9FAEC2';
	document.getElementById('tree1').style.borderBottom = 'solid 1px #9FAEC2';
}

function PermissionTreeResize() {
    var h = Tree.getHeightAfterResize();
    h -= 165;
    Tree.setHeightOnDivs(h);
}


function ChangePermissionLevel() {
    var currentLevel = document.getElementById(LevelValueID).value;
    var otherLevel = currentLevel == 'Backend' ? 'Frontend' : 'Backend';
    document.getElementById(LevelValueID).value = otherLevel;
    
    SetPermissionLevel(otherLevel)
}

function SetPermissionLevel(level) {

    document.getElementById('subtitle' + InstanceID).innerHTML = level
    if (AllowPermissionChange)
    document.getElementById('subtitle' + InstanceID).innerHTML += ' - ' + ClickToChangeString;

    // Save open-state of the tree
    openState = [];
    for (var i = 1; i < t.aNodes.length; i++) {
        if (t.aNodes[i]._io) {
            openState[openState.length] = i;
        }
    }

    // Reset loaded nodes and reload level 0
    t.loadedNodes = [];
    openIndex = 0;
    
    
    t.ajax_loadNodes(0, false, onLoaded, level);

}

function onLoaded(nodeIndex) {
    if (openIndex < openState.length)
        t.ajax_loadNodes(openState[openIndex++], false, onLoaded);
    //else
        //document.getElementById('tree1').style.display = '';

}

