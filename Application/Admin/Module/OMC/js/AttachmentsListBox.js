
Dynamicweb.Controls.OMC.EditableListBox.prototype.ShowManager = function(cliId) {
    browseFullPath("AttachListBox" + cliId, "/Files");
}

Dynamicweb.Controls.OMC.EditableListBox.prototype.OnAttachSelected = function (cliId) {
    var attchFile = document.getElementById(cliId);
    this.add(attchFile.value);
}