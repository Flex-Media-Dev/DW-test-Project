function createSplitTestObj(pageID, noContent) {
    var obj = {
        ExperimentSetup: function () {
            dialog.show('OMCExperimentDialog');
            document.getElementById("OMCExperimentDialogFrame").src = "/Admin/Module/OMC/Experiments/Setup.aspx?ID=" + pageID + "&NoContent=" + noContent;
        },

        ExperimentPreview: function () {
            window.open("/Admin/Module/Omc/Experiments/Preview.aspx?PageID=" + pageID + "&original=" + encodeURIComponent(document.getElementById("showUrl").value), "_blank", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no");
        },

        ExperimentReport: function () {
            dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Report.aspx?ID=" + pageID);
        },

        ExperimentDelete: function () {
            dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Delete.aspx?ID=" + pageID);
        },

        ExperimentPause: function () {
            dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Delete.aspx?ID=" + pageID + "&pause=true");
        },

        ExperimentStart: function() {
            dialog.show('OMCExperimentDialog', "/Admin/Module/OMC/Experiments/Delete.aspx?ID=" + pageID + "&start=true");
        }
    };
    return obj;
}