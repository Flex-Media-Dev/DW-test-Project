var dialog = function () {
    this.tmpDialog = "";
    this.previousDialogIds = "";
	this._contentUrl = "";
};

var dialog = {
    sizes: { auto: "", extraSmall: "dialog-xs", small: "dialog-sm", medium: "dialog-md", large: "dialog-lg" },
    hide: function (dialogId) {
        var dialogElement = document.getElementById(dialogId);
        if (dialogElement) {
            document.getElementById(dialogId).style.display = "none";  
            //if size changed on dialog open
            if (dialogElement.hasAttribute('data-previous-size')) {
                //remove all size classes
                for (var index in this.sizes) {
                    var size = this.sizes[index];
                    if (size != this.sizes.auto && dialogElement.classList.contains(size)) {
                        dialogElement.classList.remove(size);
                    }
                }
                var previousSize = dialogElement.getAttribute('data-previous-size');
                //check if previous size not auto(string empty)
                if (previousSize) {
                    //restore size
                    dialogElement.classList.add(previousSize);
                }                
            }
        }

        if (dialog.previousDialogId && dialog.previousDialogId != dialogId) {
            dialog._getModalOverlay().style.zIndex = 899;
        } else {
            dialog.previousDialogId = '';
            dialog._hideElement(dialog._getModalOverlay());
            dialog.tmpDialog = "";
        }

		document.body.style.overflow = 'auto';		
	},

	show: function (dialogId, url, size) {
		if (url) {
			dialog.set_contentUrl(dialogId, url);
		}

		for (var index in this.sizes) {
		    if (this.sizes[index] === size) {
		        this.changeSize(dialogId, size);
		    }
		}
		document.getElementById(dialogId).style.display = "block";

		var okButton = dialog.get_okButton(dialogId);
		if (okButton != null)
			okButton.focus();
        
		dialog.floatTop(dialogId);
		dialog._showElement(dialog._getModalOverlay());

		//window.scrollTo(0, 0);
		document.body.style.overflow = 'hidden';

		if (document.getElementById("B_" + dialogId)) {
			//document.getElementById("B_" + dialogId).scrollTop = 0;
		}

		return false;
	},

	floatTop: function (dialogId) {
		if (document.getElementById(dialog.tmpDialog)) {
		    document.getElementById(dialog.tmpDialog).style.zIndex = 900;
		}
		if (dialog.tmpDialog && dialog.tmpDialog != dialogId && dialog.previousDialogId != dialogId) {
		    dialog.previousDialogId = dialog.tmpDialog;
		    dialog._getModalOverlay().style.zIndex = 999;
		}
		dialog.tmpDialog = dialogId;
		document.getElementById(dialogId).style.zIndex = 1000;
	},

	setTitle: function (dialogId, newTitle) {
		if (document.getElementById('T_' + dialogId))
			document.getElementById('T_' + dialogId).innerHTML = newTitle;
	},

	changeSize: function (dialogId, newSize) {
	    var dialogElement = document.getElementById(dialogId);
	    if (dialogElement && dialogElement.getAttribute('data-previous-size') != newSize) {
	        var previousSize = this.sizes.auto;
	        //remove all size classes and get previous size
	        for (var index in this.sizes) {
	            var size = this.sizes[index];
	            if (size != this.sizes.auto && dialogElement.classList.contains(size)) {
	                previousSize = size;	                
	                dialogElement.classList.remove(size);	                
	            }
	        }
            //store previous size
	        dialogElement.setAttribute('data-previous-size', previousSize);
            //apply new size
	        dialogElement.classList.add(newSize);
	    }
	},

	getTitle: function (dialogId) {
		var ret = '';
		var o = document.getElementById('T_' + dialogId);

		if (o) {
			ret = o.innerHTML;
		}

		return ret;
	},

	_getModalOverlay: function () {
		var ret = null;
		var overlayId = 'DW_Dialog_ModalOverlay';
		ret = document.getElementById(overlayId);
		if (!ret) {
			ret = document.createElement('div');
			ret.setAttribute("id", overlayId);
			ret.className = 'dialog-modal-overlay';
            ret.style.display = 'none';
			document.body.insertBefore(ret, document.body.firstChild);
		}

		return ret;
	},

	_hideElement: function (el) {
		el.style.display = 'none';
	},

	_showElement: function (el) {
		el.style.display = '';
	},

    set_contentUrl: function (dialogId, url) {
		let frame = document.getElementById(dialogId + "Frame");
        if (frame) {
            let dlg = dialog;
            dlg.showLoader(dialogId);
            frame.setAttribute('src', url);
            frame.onload = () => {
                dlg.hideLoader(dialogId);
            };
		}
    },

    showLoader: function (dialogId) {
        let dialogElement = document.getElementById(dialogId);
        let loader = dialogElement.querySelector(".content-loader");
        if (!loader) {
            loader = document.createElement("div");
            loader.classList.add('overlay-container', 'content-loader');
            loader.innerHTML = '<div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div>';
            dialogElement.insertAdjacentElement("afterbegin", loader);
        } else {
            dialog._showElement(loader);
        }
        return loader;
    },

    hideLoader: function (dialogId) {
        let dialogElement = document.getElementById(dialogId);
        let loader = dialogElement.querySelector(".content-loader");
        if (loader) {
            dialog._hideElement(loader);
        }
        return loader;
    },

	set_okButtonOnclick: function (dialog, onclick) {
		var okButton = this.get_okButton(dialog);
		if (okButton) {
		    okButton.addEventListener("click", onclick);
		}
	},

	get_okButton: function (dialog) {
		var okButton = null;
		if (typeof (dialog) == "string") {
			dialog = document.getElementById(dialog);
		}
		if (dialog) {
			okButton = dialog.getElementsByClassName("dialog-button-ok")[0];
		}
		return okButton;
	},

	set_cancelButtonOnclick: function (dialog, onclick) {
	    var cancelButton = this.get_cancelButton(dialog);
	    if (cancelButton) {
	        cancelButton.addEventListener("click", onclick);
	    }
	},

	get_cancelButton: function (dialog) {
	    var cancelButton = null;
	    if (typeof (dialog) == "string") {
	        dialog = document.getElementById(dialog);
	    }
	    if (dialog) {
	        cancelButton = dialog.getElementsByClassName("dialog-button-cancel")[0];
	    }
	    return cancelButton;
	}
}

function hasClass(elem, klass) {
	return (" " + elem.className + " ").indexOf(" " + klass + " ") > -1;
}