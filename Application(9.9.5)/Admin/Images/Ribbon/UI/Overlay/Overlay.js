var __cancelOverlay = false;
function overlay(id) {
	this.id = id;
	this.overlay = document.getElementById(this.id);

	this.hide = function () {
		this.overlay.style.display = "none";
		__cancelOverlay = false;
	}
	this.show = function () {
		if (!__cancelOverlay) {
			this.overlay.style.display = "block";
		}
		__cancelOverlay = false;
	}
	this.message = function (newMessage) {
		document.getElementById(this.id + "Message").innerHTML = newMessage;
	}
	this.hideById = function (elementId) {
		__cancelOverlay = false;
		document.getElementById(elementId).style.display = "none";
	}
}
function showOverlay(id) {
	var w = new overlay(id); w.show();
}
function hideOverlay(id) {
	var w = new overlay(id); w.hide();
}