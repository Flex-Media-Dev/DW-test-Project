/* ++++++ Registering namespace ++++++ */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.RoundedFrame = function () {
    /// <summary>Represents a rounded frame.</summary>

    this._container = null;
    this._containerID = null;

    this._cache = null;
}

Dynamicweb.Controls.RoundedFrame.prototype.get_container = function () {
    /// <summary>Gets the reference to DOM element holding control's contents.</summary>

    if (this._container == null || typeof (this._container) == 'string') {
        this._container = $(this._containerID);
    }

    return this._container;
}

Dynamicweb.Controls.RoundedFrame.prototype.set_container = function (value) {
    /// <summary>Sets the reference to DOM element holding control's contents.</summary>
    /// <param name="value">The reference to DOM element holding control's contents.</param>

    this._container = value;

    if (typeof (value) == 'string') {
        this._containerID = value;
    } else {
        this._containerID = '';
    }
}

Dynamicweb.Controls.RoundedFrame.prototype.get_title = function () {
    /// <summary>Gets frame title.</summary>

    var ret = '';

    if (this._ensureCache() && this._cache.title) {
        ret = this._cache.title.innerHTML;
    }

    return ret;
}

Dynamicweb.Controls.RoundedFrame.prototype.set_title = function (value) {
    /// <summary>Sets frame title.</summary>
    /// <param name="value">Frame title.</param>

    if (this._ensureCache() && this._cache.title) {
        if (value && value.length) {
            this._cache.title.innerHTML = value;
        } else {
            this._cache.title.innerHTML = '';
        }
    }
}

Dynamicweb.Controls.RoundedFrame.prototype.get_hint = function () {
    /// <summary>Gets frame title hint.</summary>

    var ret = '';

    if (this._ensureCache() && this._cache.titleHint) {
        ret = this._cache.titleHint.innerHTML;
    }

    return ret;
}

Dynamicweb.Controls.RoundedFrame.prototype.set_hint = function (value) {
    /// <summary>Sets frame title.</summary>
    /// <param name="value">Frame title hint.</param>

    if (this._ensureCache() && this._cache.titleHint) {
        if (value && value.length) {
            this._cache.titleHint.innerHTML = '&nbsp;(' + value + ')';
        } else {
            this._cache.titleHint.innerHTML = '';
        }
    }
}

Dynamicweb.Controls.RoundedFrame.prototype.get_isCollapsed = function () {
    /// <summary>Gets value indicating whether frame content is collaped.</summary>

    var ret = false;

    this._ensureCache();

    if (this._cache != null && this._cache.contentContainer != null) {
        ret = this._cache.contentContainer.style.display == 'none';
    }

    return ret;
}

Dynamicweb.Controls.RoundedFrame.prototype.set_isCollapsed = function (value) {
    /// <summary>Sets value indicating whether frame content is collaped.</summary>
    /// <param name="value">Value indicating whether frame content is collaped.</param>

    value = !!value;

    this._ensureCache();

    if (this._cache != null && this._cache.contentContainer != null) {
        this._cache.contentContainer.style.display = (value ? 'none' : '');

        if (this._cache.container) {
            if (value) {
                this._cache.container.addClassName('dw-rc-collapsed');
                if (this._cache.footer) {
                    this._cache.footer.addClassName('dw-rc-footer-collapsed');
                }
            } else {
                this._cache.container.removeClassName('dw-rc-collapsed');
                if (this._cache.footer) {
                    this._cache.footer.removeClassName('dw-rc-footer-collapsed');
                }
            }
        }
    }
}

Dynamicweb.Controls.RoundedFrame.prototype._ensureCache = function () {
    /// <summary>Initializes the cache (if needed).</summary>
    /// <private />

    var c = null;
    var ret = false;

    if (this._cache == null) {
        this._cache = {};
        c = this.get_container();

        if (c != null && typeof (c) != 'string') {
            this._cache.container = c;
            this._cache.titleContainer = $(c.select('.dw-rc-tt')[0]);
            this._cache.title = $(c.select('.dw-rc-tt .dw-rc-ttext')[0]);
            this._cache.titleHint = $(c.select('.dw-rc-tt .dw-rc-thint')[0]);
            this._cache.contentContainer = $(c.select('.dw-rc-c .dw-rc-c-content')[0]);
            this._cache.footer = $(c.select('.dw-rc-footer')[0]);

            ret = true;
        } else {
            this._cache = null;
        }
    } else {
        ret = true;
    }

    return ret;
}