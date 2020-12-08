//window.onload = load;
function load() {
    if (top.dwtop.document.getElementById("top")) {
        //alert(document.getElementById("theRibbon").innerHTML);
        top.dwtop.document.getElementById("top").innerHTML = document.getElementById("theRibbon").innerHTML;
        document.getElementById("theRibbon").innerHTML = "";
    }

    for (var i = 1; i < 15; i++) {
        document.getElementById("tabarea" + i).style = ""; // Overrides the previous way to toggle the tabs
    }
}

function isIE() {
    var agt = navigator.userAgent.toLowerCase();
    if (agt.indexOf("msie") != -1) {
        return true;
    }
    else {
        return false;
    }
}

var Ribbon = {
    load: function () {
        if (top.dwtop.document.getElementById("top")) {

        }
    },

    tab: function (activeID, ribbonID) {
        document.getElementById(ribbonID).className = 'Ribbon';

        if (isIE()) {
            btnNavigation = true;
        }
        var state = null;
        var wasCollapsed = Ribbon.isCollapsed(ribbonID);

        for (var i = 1; i < 15; i++) {
            if (document.getElementById("tabarea" + i)) {
                document.getElementById("tabarea" + i).className = "tabarea hide-ribbon-tab";
            }
            if (document.getElementById("tabitem" + i)) {
                document.getElementById("tabitem" + i).className = "";
            }
        }
        if (document.getElementById("tabarea" + activeID)) {
            document.getElementById("tabarea" + activeID).className = "tabarea show-ribbon-tab";
            document.getElementById("tabarea" + activeID).style = ""; // Overrides the previous way to toggle the tabs
        }
        if (document.getElementById("tabitem" + activeID)) {
            document.getElementById("tabitem" + activeID).className = "activeitem";
        }

        if (ribbonID) {
            state = document.getElementById(ribbonID + '_activeTab');

            if (state) {
                state.value = activeID;
            }
        }

        Ribbon._setCollapseButtonState(ribbonID, false);

        if (wasCollapsed) {
            Ribbon.notify('stateChanged', { state: 'expanded' });
        }
    },

    checkBox: function (id) {
        if (id.length < 1) {
            alert("Button ID not specified");
            return false;
        }
        if (document.getElementById("chk_" + id)) {
            if (document.getElementById("chk_" + id).value.toLowerCase() == "true")
                document.getElementById("chk_" + id).value = "false";
            else
                document.getElementById("chk_" + id).value = "true";

            this.toggleActive(id);
        }
    },

    isChecked: function (id) {
        var ret = false;
        var elm = document.getElementById('chk_' + id);

        if (elm) {
            ret = (elm.type == "checkbox") ? elm.checked : elm.value.toLowerCase() == 'true';
        }
        return ret;
    },

    radioButton: function (id, uniqueID, group) {
        if (!Ribbon.buttonIsEnabled(id)) {
            return;
        }

        var selected = document.getElementById('radio_' + group + '_selected');
        var currentValue = document.getElementById('radio_' + group);
        var newValue = document.getElementById('radio_' + uniqueID).value;

        if (currentValue) {
            if (newValue != currentValue.value) {
                currentValue.value = newValue;
                this.activateButton(id);

                if (selected) {
                    this.deactivateButton(selected.value);
                    selected.value = id;
                }
            }
        }
    },

    splitButtonMouseOver: function (id, e) {
        var t = $(e.srcElement || e.target);
        if (t && t.id == id + "_splitRight") {
            Ribbon.splitButtonHoverRight(id);
        }
        else {
            Ribbon.splitButtonHoverLeft(id);
        }
    },

    splitButtonUnhover: function (id) {
        if (Ribbon.splitButtonSize(id) == "small") {
            //$(id + "_splitRight").src = "/admin/images/ribbon/images/SmallSplitRibbonButtonRight.gif";
            document.getElementById(id).removeClassName('smallSplitLeftButtonHoverInactive');

            if (document.getElementById(id + "_start")) {
                document.getElementById(id + "_start").removeClassName('smallSplitRibbonButtonLeftStartHoverInactive');
            }
        }
    },

    splitButtonHoverRight: function (id) {
        if (Ribbon.splitButtonSize(id) == "small") {
            //document.getElementById(id + "_splitRight").src = "/admin/images/ribbon/images/SmallSplitRibbonButtonRightHover.gif";
            document.getElementById(id).addClassName('smallSplitLeftButtonHoverInactive');

            if (document.getElementById(id + "_start")) {
                document.getElementById(id + "_start").addClassName('smallSplitRibbonButtonLeftStartHoverInactive');
            }
        }
    },

    splitButtonHoverLeft: function (id) {
        if (Ribbon.splitButtonSize(id) == "small") {
            //document.getElementById(id + "_splitRight").src = "/admin/images/ribbon/images/SmallSplitRibbonButtonRightHoverInactive.gif";
            document.getElementById(id).removeClassName('smallSplitLeftButtonHoverInactive');

            if (document.getElementById(id + "_start")) {
                document.getElementById(id + "_start").removeClassName('smallSplitRibbonButtonLeftStartHoverInactive');
            }
        }
    },

    splitButtonSize: function (id) {
        return document.getElementById(id + "_size").value;
    },

    toggleActive: function (id) {
        if (document.getElementById(id)) {
            if (document.getElementById(id).classList.contains('active')) {
                this.deactivateButton(id);
            } else {
                this.activateButton(id);
            }
        }
    },

    isButtonActivate: function (id) {
        return document.getElementById(id).classList.contains('active');
    },

    activateButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.classList.add('active');
        }
    },

    deactivateButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.classList.remove('active');
        }
    },

    hoverButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.classList.add('hover');
        }
    },

    unhoverButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.classList.remove('hover');
        }
    },

    toggleEnable: function (id) {
        if (document.getElementById(id).classList.contains('disabled')) {
            this.enableButton(id);
        } else {
            this.disableButton(id);
        }
    },

    enableButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.removeClassName('disabled');
            btn.writeAttribute("href", "#");
        }
    },

    disableButton: function (id) {
        var btn = document.getElementById(id);
        if (btn) {
            btn.addClassName('disabled');
            btn.writeAttribute("href", value = false);
        }
    },

    buttonIsEnabled: function (id) {
        var btn = document.getElementById(id);
        var ret = true;

        if (btn) {
            ret = !btn.hasClassName('disabled');
        }

        return ret;
    },

    buttonClick: function (e, id, contextMenuId, splitButton, btnClick) {
        var isEnabled = true;
        try {
            isEnabled = Ribbon.buttonIsEnabled(id);
        } catch (ex) { }
        if (isEnabled) {
            if (splitButton) {
                var t = $(e.srcElement || e.target);
                if (contextMenuId != null && contextMenuId.length > 0 && (t.id == id + "_splitRight" || t.hasClassName("ribbonButtonOptionsDiv"))) {

                    if (!document.getElementById(id).hasClassName('active')) {
                        btnClick();
                    }

                    Ribbon.showOptions(e, contextMenuId, id, splitButton);
                }
                else {
                    btnClick();
                }
            }
            else if (contextMenuId != null && contextMenuId.length > 0) {
                Ribbon.showOptions(e, contextMenuId, id, false);
            }
            else if (btnClick != null) {
                btnClick();
            }
        }
        if (isIE()) {
            btnNavigation = true;
        }
        return false;
    },

    checkboxClick: function (e, id, onClientClick) {
        /// <summary>Handles "click" event of the checkbox button.</summary>
        /// <param name="e">Event object.</param>
        /// <param name="id">Button identifier.</param>
        /// <param name="onClientClick">User-defined "click" event handler.</param>

        var isEnabled = true;

        try {
            isEnabled = Ribbon.buttonIsEnabled(id);
        } catch (ex) { }

        if (isEnabled) {
            Ribbon.checkBox(id);

            if (onClientClick) {
                if (typeof (onClientClick) == 'function') {
                    onClientClick();
                } else if (typeof (onClientClick) == 'string') {
                    eval(onClientClick);
                }
            }
        }
    },

    radioButtonClick: function (id, uniqueID, groupName, onClientClick) {
        /// <summary>Handles "click" event of the radio button.</summary>        
        /// <param name="id">Button identifier.</param>
        /// <param name="uniqueID">Button unique identifier.</param>
        /// <param name="groupName">Button group.</param>
        /// <param name="onClientClick">User-defined "click" event handler.</param>

        var isEnabled = true;

        try {
            isEnabled = Ribbon.buttonIsEnabled(id);
        } catch (ex) { }

        if (isEnabled) {
            Ribbon.radioButton(id, uniqueID, groupName);

            if (onClientClick) {
                if (typeof (onClientClick) == 'function') {
                    onClientClick();
                } else if (typeof (onClientClick) == 'string') {
                    eval(onClientClick);
                }
            }
        }
    },

    set_imagePath: function (ribbonID, buttonID, imagePath) {
        var img = $$('div[id="' + ribbonID + '"] img[id="rbImg_' + buttonID + '"]');

        if (img && img.length > 0) {
            img[0].src = imagePath;
        }
    },

    get_imagePath: function (ribbonID, buttonID) {
        var ret = '';
        var img = $$('div[id="' + ribbonID + '"] img[id="rbImg_' + buttonID + '"]');

        if (img && img.length > 0) {
            ret = img[0].src;
        }

        return ret;
    },

    get_defaultImagePath: function (ribbonID, buttonID) {
        var ret = '';
        var img = $$('div[id="' + ribbonID + '"] img[id="rbImg_' + buttonID + '"]');

        if (img && img.length > 0) {
            ret = $(img[0]).readAttribute('_src');
        }

        return ret;
    },

    get_buttonText: function (buttonID) {
        /// <summary>Returns the text of a given button.</summary>
        /// <param name="buttonID">Button identifier.</param>

        var ret = '';
        var children = [];
        var cmd = $$('a[id="' + buttonID + '"]');

        var reduce = function (str) {
            return trim(str).replace(/\n|\r/g, '');
        }

        var trim = function (str) {
            var ret = str.replace(/^\s+/, '');

            for (var i = ret.length - 1; i >= 0; i--) {
                if (/\S/.test(ret.charAt(i))) {
                    ret = ret.substring(0, i + 1);
                    break;
                }
            }

            return ret;
        }

        if (cmd && cmd.length) {
            cmd = cmd[0];

            children = cmd.childNodes || cmd.childElements;

            if (children && children.length) {
                for (var i = 0; i < children.length; i++) {
                    if (children[i].nodeType != 3) {
                        // A check for large button
                        if ((children[i].tagName || children[i].tagName.nodeName).toLowerCase() == 'span' &&
                            children[i].className && children[i].className.toLowerCase().indexOf('ribbonitem') >= 0) {

                            children = children[i].childNodes || children[i].childElements;
                            break;
                        }
                    }
                }
            }

            if (children && children.length) {
                for (var i = 0; i < children.length; i++) {
                    if (children[i].nodeType == 3) { // Text node
                        ret = typeof (children[i].innerText) != 'undefined' ? children[i].innerText : children[i].textContent;
                        if (typeof (ret) == 'undefined') {
                            ret = typeof (children[i].nodeValue) != 'undefined' ? children[i].nodeValue : children[i].data;
                        }

                        ret = reduce(ret);

                        break;
                    }
                }
            }
        }

        return ret;
    },

    set_buttonText: function (buttonID, text) {
        /// <summary>Updates the text of a given button.</summary>
        /// <param name="buttonID">Button identifier.</param>
        /// <param name="text">Button text.</param>

        var node = null;
        var children = [];
        var isLastChild = false;
        var cmd = $$('a[id="' + buttonID + '"]');

        var reduce = function (str) {
            return trim(str).replace(/\n|\r/g, '');
        }

        var trim = function (str) {
            var ret = str.replace(/^\s+/, '');

            for (var i = ret.length - 1; i >= 0; i--) {
                if (/\S/.test(ret.charAt(i))) {
                    ret = ret.substring(0, i + 1);
                    break;
                }
            }

            return ret;
        }

        if (cmd && cmd.length) {
            cmd = cmd[0];

            children = cmd.childNodes || cmd.childElements;

            if (children && children.length) {
                for (var i = 0; i < children.length; i++) {
                    if (children[i].nodeType != 3) {
                        // A check for large button
                        if ((children[i].tagName || children[i].tagName.nodeName).toLowerCase() == 'span' &&
                            children[i].className && children[i].className.toLowerCase().indexOf('ribbonitem') >= 0) {

                            cmd = children[i];
                            children = children[i].childNodes || children[i].childElements;
                            break;
                        }
                    }
                }
            }

            if (children && children.length) {
                for (var i = 0; i < children.length; i++) {
                    if (children[i].nodeType == 3) {
                        node = document.createTextNode(' ' + reduce(text));
                        isLastChild = (i == children.length - 1);

                        cmd.removeChild(children[i]);

                        if (!isLastChild) {
                            cmd.insertBefore(node, children[i]);
                        } else {
                            cmd.appendChild(node);
                        }

                        break;
                    }
                }
            }
        }
    },

    showButton: function (id) {
        document.getElementById(id).show();
    },

    hideButton: function (id) {
        document.getElementById(id).hide();
    },

    optionsObserved: false,
    optionsShowing: false,
    optionsButtonId: '0',
    optionsContextMenuId: '',
    splitButton: false,

    showOptions: function (event, contextMenuId, buttonId, splitButton) {
        if (ContextMenu.menuElement) {
            Ribbon.optionsShowing = !(ContextMenu.menuElement.class == 'none' || ContextMenu.menuElement.style.left == '-1000px')
        }
        Ribbon.optionsButtonId = buttonId;
        Ribbon.splitButton = splitButton;

        //alert(Ribbon.optionsObserved);
        if (!Ribbon.optionsObserved) {
            document.body.addEventListener('click', Ribbon.optionsObserver, false);
            document.body.addEventListener('contextmenu', Ribbon.optionsObserver, false);
        }

        document.getElementById(contextMenuId).onmouseover = function () {
            if (Ribbon.splitButton) {
                Ribbon.splitButtonHoverRight(Ribbon.optionsButtonId);
            }
            else {
                Ribbon.hoverButton(buttonId);
            }
        }

        if (ContextMenu.menuElement) {
            if (Ribbon.optionsShowing) {
                ContextMenu.hide(Ribbon.optionsContextMenuId);
                //return false;
            }
        }
        //event = (window.event?window.event:ev);
        Ribbon.optionsContextMenuId = contextMenuId;
        return ContextMenu.show(event, contextMenuId, '', '', 'BottomLeft', document.getElementById(buttonId));
    },

    optionsObserver: function () {
        if (ContextMenu.menuElement) {
            Ribbon.optionsShowing = !(ContextMenu.menuElement.style.display == 'none' || ContextMenu.menuElement.style.left == '-1000px')
        }
        Ribbon.optionsObserved = true;
        //alert("2: " + Ribbon.optionsButtonId);
        if (Ribbon.optionsShowing) {
            if (Ribbon.splitButton) {
                Ribbon.splitButtonUnhover(Ribbon.optionsButtonId);
            }
            else {
                Ribbon.unhoverButton(Ribbon.optionsButtonId);
            }
        }
    },

    enableEditing: function (controlID) {
        /// <summary>Enables the ability for the user to interact with Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        Ribbon.setEditingIsEnabled(controlID, true);
    },

    disableEditing: function (controlID) {
        /// <summary>Disables the ability for the user to interact with Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        Ribbon.setEditingIsEnabled(controlID, false);
    },

    isEditingEnabled: function (controlID) {
        /// <summary>Gets value indicating whether user can interact with Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        var ret = true;
        var overlay = null;

        if (controlID && controlID.length) {
            overlay = document.getElementById(controlID + '_disabledOverlay');
            ret = !overlay || overlay.style.display == 'none';
        }

        return ret;
    },

    setEditingIsEnabled: function (controlID, isEnabled) {
        /// <summary>Set value indicating whether user can interact with Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>
        /// <param name="value">Value indicating whether user can interact with Ribbon.</param>

        var offset = null;
        var overlay = null;
        var overlayID = '';
        var container = null;

        if (controlID && controlID.length) {
            isEnabled = !!isEnabled;

            overlayID = controlID + '_disabledOverlay';
            if (isEnabled) {
                overlay = document.getElementById(overlayID);
                if (overlay) {
                    overlay.style.display = 'none';
                }
            } else {
                overlay = document.getElementById(overlayID);
                container = document.getElementById(controlID);

                if (container) {
                    if (!overlay) {
                        overlay = document.createElement('DIV');

                        overlay.id = overlayID;
                        overlay.className = 'ribbon-disabled-overlay';

                        container.insertBefore(overlay, container.firstChild);
                    }

                    if (overlay && container) {
                        offset = Ribbon._offset(container);

                        overlay.style.display = 'block';

                        overlay.style.left = offset.left + 'px';
                        overlay.style.top = offset.top + 'px';
                    }
                }
            }
        }
    },

    collapse: function (controlID) {
        /// <summary>Collapses Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        Ribbon.setIsCollapsed(controlID, true);
    },

    expand: function (controlID) {
        /// <summary>Expands Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        Ribbon.setIsCollapsed(controlID, false);
    },

    isCollapsed: function (controlID) {
        /// <summary>Gets value indicating whether Ribbon is collapsed.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        var t = null;
        var ret = true;
        var maxTabs = 15; /* Should be enough for any complex UI */
        var hasTabs = false;

        for (var i = 1; i <= maxTabs; i++) {
            t = document.getElementById('tabarea' + i);
            if (t) {
                if (!hasTabs) {
                    hasTabs = true;
                }

                if (document.getElementById(controlID).className != 'Ribbon collapsed') {
                    ret = false;
                    break;
                }
            }
        }

        if (!hasTabs) {
            ret = false;
        }

        return ret;
    },

    toggleCollapsed: function (controlID, controlUniqueID) {
        /// <summary>Toggles the "collapsed" state of the Ribbon.</summary>
        /// <param name="controlID">Ribbon control ID.</param>

        Ribbon.setIsCollapsed(controlID, !Ribbon.isCollapsed(controlID), controlUniqueID);
    },

    setIsCollapsed: function (controlID, isCollapsed, controlUniqueID) {
        /// <summary>Sets the "collapsed" state of the Ribbon to the given value.</summary>
        /// <param name="controlID">Ribbon control ID.</param>
        /// <param name="isCollapsed">Value indicating whether Ribbon should be collapsed.</param>

        var t = null;
        var maxTabs = 15; /* Should be enough for any complex UI */
        var header = null;

        if (isCollapsed) {
            document.getElementById(controlID).className = 'Ribbon collapsed';

            for (var i = 0; i <= maxTabs; i++) {
                t = document.getElementById('tabarea' + i);
                header = document.getElementById('tabitem' + i);

                /* Hiding tab area */
                if (t) {
                    t.className = 'tabarea hide-ribbon-tab'
                }

                /* Setting the corresponding tab header to "inactive" state */
                if (header) {
                    header.className = 'tabitem';
                }
            }
        } else {
            document.getElementById(controlID).className = 'Ribbon';

            /* Picking up the first area/header pair */
            t = document.getElementById('tabarea1')
            header = document.getElementById('tabitem1');

            /* Showing the tab area */
            if (t) {
                t.className = 'tabarea show-ribbon-tab'
            }

            /* Setting the corresponding tab header to "active" state */
            if (header) {
                header.className = 'activeitem tabitem';
            }
        }

        Ribbon._setCollapseButtonState(controlID, isCollapsed);

        Ribbon.notify('stateChanged', { state: isCollapsed ? 'collapsed' : 'expanded' });

        // Save collapsed state to PersonalSettings        
        Dynamicweb.Ajax.doPostBack({
            eventTarget: controlUniqueID || "",
            eventArgument: "Collapsed:" + isCollapsed,
        });
    },

    handlers: { stateChanged: [] },

    add_stateChanged: function (callback) {
        /// <summary>Registers a new callback that is executed whenever the state of the Ribbon changes.</summary>
        /// <param name="callback">Callback to register.</param>

        callback = callback || function () { }

        Ribbon.handlers.stateChanged[Ribbon.handlers.stateChanged.length] = callback;
    },

    notify: function (eventName, args) {
        /// <summary>Notifies clients about specified event.</summary>
        /// <param name="eventName">Event name.</param>
        /// <param name="args">Event arguments.</param>

        var callbacks = [];

        if (eventName && eventName.length) {
            if (!args) {
                args = {};
            }

            callbacks = Ribbon.handlers[eventName];

            if (callbacks && callbacks.length) {
                for (var i = 0; i < callbacks.length; i++) {
                    if (callbacks[i]) {
                        callbacks[i](Ribbon, args);
                    }
                }
            }
        }
    },

    _setCollapseButtonState: function (controlID, isCollapsed) {
        /// <summary>Updates the visual state of the "collapse" button.</summary>
        /// <param name="controlID">Ribbon control ID.</param>
        /// <param name="isCollapsed">Value indicating whether Ribbon is collapsed.</param>
        /// <private />

        var tag = '';
        var link = null;
        var children = [];

        if (controlID) {
            link = document.getElementById(controlID + '_collapseButton');
            if (link) {
                children = link.childNodes || link.childElements;

                if (children && children.length) {
                    for (var i = 0; i < children.length; i++) {
                        tag = children[i].tagName || children[i].nodeName;
                        if (tag) {
                            tag = tag.toLowerCase();

                            if (tag == 'i') {
                                //children[i].className = isCollapsed ? 'fa fa-chevron-up' : 'fa fa-chevron-down';
                                break;
                            }
                        }
                    }
                }
            }
        }
    },

    _offset: function (element) {
        /// <summary>Calculates the top and left offset (in pixels) of the given element relative to the document.</summary>
        /// <param name="element">Element which offset needs to be calculated.</param>
        /// <private />

        var left = 0, top = 0;
        var ret = { left: 0, top: 0 };

        if (element) {
            do {
                left += element.offsetLeft;
                top += element.offsetTop;
            } while (element = element.offsetParent);

            ret.left = left;
            ret.top = top;
        }

        return ret;
    },

    _scrollOffset: function () {
        /// <summary>Calculates the top and left scroll offset (in pixels) of the document.</summary>
        /// <private />

        var left = 0, top = 0;
        var ret = { left: 0, top: 0 };

        if (typeof (window.pageYOffset) == 'number') {
            left = window.pageXOffset;
            top = window.pageYOffset;
        } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop)) {
            left = document.documentElement.scrollLeft;
            top = document.documentElement.scrollTop;
        } else if (document.body && (document.body.scrollLeft || document.body.scrollTop)) {
            left = document.body.scrollLeft;
            top = document.body.scrollTop;
        }

        ret.left = left;
        ret.top = top;

        return ret;
    }
}