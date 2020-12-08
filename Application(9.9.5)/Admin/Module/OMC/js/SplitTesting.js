function OMCExperimentReport(pageID) {
    dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Report.aspx?ID=" + pageID);
}

function OMCExperimentDelete(pageID) {
    dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Delete.aspx?FromOMC=true&ID=" + pageID);
}

function OMCExperimentPause(pageID) {
    document.getElementById("OMCExperimentDialogFrame").src = "/Admin/Module/OMC/Experiments/Delete.aspx?ID=" + pageID + "&pause=true";
}

function OMCExperimentStart(pageID) {
    document.getElementById("OMCExperimentDialogFrame").src = "/Admin/Module/OMC/Experiments/Delete.aspx?ID=" + pageID + "&start=true";
}

var menuActions = {
    contextMenuView: function (sender, args) {
        /// <summary>Determines the contents of the context-menu.</summary>
        /// <param name="sender">Event sender.</param>
        /// <param name="args">Event arguments.</param>

        var ret = '';
        var row = null;

        row = List.getRowByID('lstExperiments', args.callingID);

        if (row.readAttribute('__active') == 'true') {
            ret = 'pause_exp';
        } else {
            ret = 'start_exp';
        }
        return ret;
    }
}

