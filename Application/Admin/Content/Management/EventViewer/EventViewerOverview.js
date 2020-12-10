var EventViewerOverview = {
    listId : "eventList",
    logLevel : function() {
        var dropDownLevel = document.getElementById(this.listId + ":LogEventLevelFilter");
        return dropDownLevel.options[dropDownLevel.selectedIndex].value;
    },
    filterText : function () {
        var filterInput = document.getElementById(this.listId + ":TextFilter");
        return filterInput.value;
    },
    pagingSize : function () {
        var dropDownLevel = document.getElementById(this.listId + ":PageSizeFilter");
        return dropDownLevel.options[dropDownLevel.selectedIndex].value;
    },
    showDetails : function (id) {
        location = '/Admin/Content/Management/EventViewer/EventViewerDetails.aspx?Id=' + id +
            '&PagingSize=' + this.pagingSize() +
            '&LogLevel=' + this.logLevel() +
            '&FilterText=' + this.filterText();
    },
    showEmailNotification: function () {
        location = '/Admin/Content/Management/EventViewer/EventViewerEmailNotification_List.aspx';
    },
    showWaitSpinner: function () {
        var spinnerControl = document.getElementById("PleaseWait");
        spinnerControl.style = "";
    },
    reload: function () {
    	location = '/Admin/Content/Management/EventViewer/EventViewerOverview.aspx' + location.search;
    }
}