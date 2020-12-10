var EventViewerEmailNotification = {
    terminology: {
        ConfirmDelete: "Do you want to delete?"
    },
    save: function () {        
        document.getElementById('MainForm').submit();
    },
    saveAndClose: function () {
        document.getElementById('cmdValue').value = "SaveAndClose";
        this.save();
    },
    cancel: function () {
        location = '/Admin/Content/Management/EventViewer/EventViewerEmailNotification_List.aspx';
    },
    delete: function () {
        if (confirm(EventViewerEmailNotification.terminology.ConfirmDelete)) {
            location = location + '&DeleteNotification=True';
        }
    },
    onChangeNotificationDestination: function () {
        var destination = document.getElementById("Destination");

        if (destination.value === "MonitoringService") {
            this.hide("NotifiedEmails");
            this.show("NotificationUri");
        }
        else {
            this.show("NotifiedEmails");
            this.hide("NotificationUri");
        }
    },
    hide: function (id) {
        var ctl = document.getElementById(id).closest(".form-group");
        if (ctl) dwGlobal.Dom.addClass(ctl, "hidden");
    },
    show: function (id) {
        var ctl = document.getElementById(id).closest(".form-group");
        if (ctl) dwGlobal.Dom.removeClass(ctl, "hidden");
    }
}

document.addEventListener('DOMContentLoaded', function () {
    EventViewerEmailNotification.onChangeNotificationDestination();
});