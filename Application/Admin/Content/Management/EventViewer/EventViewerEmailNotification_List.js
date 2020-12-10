var EventViewerEmailNotificationList = {
    edit: function (systemName) {
        systemName = systemName || "";
        document.location = "/Admin/Content/Management/EventViewer/EventViewerEmailNotification.aspx?SystemName=" + systemName;
    }
};