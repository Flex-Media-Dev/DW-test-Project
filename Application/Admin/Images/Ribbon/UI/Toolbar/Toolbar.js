var Toolbar = function () {
    /// <summary>Represents a toolbar.</summary>
}

Toolbar.buttonIsDisabled = function (id) {
    /// <summary>Checks whether specified button is in "Disabled" state.</summary>
    /// <param name="id">Button ID.</param>

    return Toolbar._checkClass(id, 'toolbarButtonDisabled');
}

Toolbar.buttonIsActive = function (id) {
    /// <summary>Checks whether specified button is in "Active" state.</summary>
    /// <param name="id">Button ID.</param>

    return Toolbar._checkClass(id, 'toolbar-button-active');
}

Toolbar.setButtonIsDisabled = function (id, isDisabled) {
    /// <summary>Sets specified button into the specified "Disabled" state.</summary>
    /// <param name="id">Button ID.</param>
    /// <param name="isDisabled">Indicates whether button is in "Disabled" state.</param>

    Toolbar._class(id, 'disabled', isDisabled);
    Toolbar._attr(id, 'disabled', isDisabled ? 'disabled' : null);
}

Toolbar.setButtonIsActive = function (id, isActive) {
    /// <summary>Sets specified button into the specified "Active" state.</summary>
    /// <param name="id">Button ID.</param>
    /// <param name="isDisabled">Indicates whether button is in "Active" state.</param>

    Toolbar._class($(id).down('a'), 'toolbar-button-active', isActive);
}

Toolbar._class = function (id, cssClass, setClass) {
    /// <summary>Checks the presence of the specified CSS class and either adds it or removes it.</summary>
    /// <param name="id">Button ID.</param>
    /// <param name="cssClass">Name of the class.</param>
    /// <param name="setClass">Indicates whether the class should be set or removed.</param>

    var hasClass = false;
    var className = cssClass;
    var cmd = document.getElementById(id);
    var rx = new RegExp('\\b' + className + '\\b');

    if (typeof (id.id) != 'undefined') {
        cmd = id;
    }

    if (cmd) {
        if (cmd.className) {
            hasClass = rx.test(cmd.className);

            if (!setClass && hasClass) {
                cmd.className = cmd.className.replace(rx, '');
            } else if (setClass && !hasClass) {
                cmd.className += (' ' + className);
            }
        } else {
            if (setClass)
                cmd.className = className;
        }
    }
}

Toolbar._checkClass = function (id, cssClass) {
    /// <summary>Checks whether specified CSS class is defined on a button.</summary>
    /// <param name="id">Button ID.</param>
    /// <param name="cssClass">Name of the class.</param>

    var ret = false;
    var cmd = document.getElementById(id);
    var rx = new RegExp('\\b' + cssClass + '\\b');

    if (cmd) {
        if (cmd.className) {
            ret = rx.test(cmd.className);
        }
    }

    return ret;
}

Toolbar._attr = function (id, attrName, setVal) {
    var cmd = document.getElementById(id);
    if (typeof (id.id) != 'undefined') {
        cmd = id;
    }

    if (cmd) {
        if (typeof setVal != 'undefined') {
            cmd.setAttribute(attrName, setVal)
        } if (setVal === null) {
            cmd.removeAttribute(attrName, setVal)
        } else {
            setVal = cmd.getAttribute(attrName)
        }
    }
    return setVal;
}