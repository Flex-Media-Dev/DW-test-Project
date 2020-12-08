function initLogPage(opts) {
    var obj = {
        init: function () {
            this.terminology = opts.terminology;
        }
    };
    obj.init();
    return obj;
}

function Submit() {
    var formElement = document.getElementById("form1");
    formElement.submit();
}

function DeleteActivity() {
    var activityElement = document.getElementById("action");
    activityElement.value = "delete";

    var jobsToDelete = GetSelectedJobsNames('activityList');
    var selectedJob = document.getElementById("selectedJob");
    if (jobsToDelete.length == 0) {
        selectedJob.value = ContextMenu.callingItemID;
        List.setAllSelected('activityList', false);
    } else {
        selectedJob.value = jobsToDelete;
    }
    Submit();
}

function DeleteLogs() {
    var confirmMassage = currentPage && currentPage.terminology && currentPage.terminology.confirmDeleteMessage ? currentPage.terminology.confirmDeleteMessage : "All logs older than a week will be deleted. Do you want to continue?";
    if (confirm(confirmMassage)) {
        var o = new overlay('forward');
        o.show();
        var actionElement = document.getElementById("action");
        actionElement.value = 'deleteLogs';
        Submit();
    };
}

function GetSelectedJobsNames(listId) {
    var ret = '';
    var jobs = List.getSelectedRows(listId);
    if (jobs != null) {
        var len = jobs.toArray().length;
        for (i = 0; i < len; i++) {
            if (i > 0)
                ret += ';';
            ret += jobs[i].readAttribute("itemid");
        }
    }
    return ret;
}

function OnSelectCtxView(sender, args) {
    var ret = ['activityListContextMenu'];
    var jobs = List.getSelectedRows('activityList');
    if (jobs != null && jobs.toArray().length > 1)
        ret.push('DeleteActivityButton');
    else {
        ret.push('LogButton');
        ret.push('DeleteActivityButton');
    }
    return ret;
}