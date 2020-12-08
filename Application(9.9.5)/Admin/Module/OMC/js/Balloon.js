/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.OMC) == 'undefined') {
    Dynamicweb.Controls.OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.OMC.Balloon = function () {
    /// <summary>Represents a balloon.</summary>

    this._title = '';
    this._markup = null;
    this._target = null;
    this._content = null;
    this._hideTimeout = null;
    this._contentChanged = true;
    this._isUserInteracting = false;
    this._isVisibleCached = null;
    this._cssClass = '';
    this._trigger = 0;
}

Dynamicweb.Controls.OMC.BalloonPositionArgs = function () {
    /// <summary>Provides information about balloon position.</summary>

    this._left = 0;
    this._top = 0;
}

Dynamicweb.Controls.OMC.BalloonPositionArgs.prototype.get_left = function () {
    /// <summary>Gets the horizontal offset of the ballon (in pixels) relative to the document.</summary>

    return this._left;
}

Dynamicweb.Controls.OMC.BalloonPositionArgs.prototype.set_left = function (value) {
    /// <summary>Sets the horizontal offset of the ballon (in pixels) relative to the document.</summary>
    /// <param name="value">The horizontal offset of the ballon (in pixels) relative to the document.</param>

    this._left = value || 0;
}

Dynamicweb.Controls.OMC.BalloonPositionArgs.prototype.get_top = function () {
    /// <summary>Gets the vertical offset of the ballon (in pixels) relative to the document.</summary>

    return this._top;
}

Dynamicweb.Controls.OMC.BalloonPositionArgs.prototype.set_top = function (value) {
    /// <summary>Sets the vertical offset of the ballon (in pixels) relative to the document.</summary>
    /// <param name="value">The vertical offset of the ballon (in pixels) relative to the document.</param>

    this._top = value || 0;
}

Dynamicweb.Controls.OMC.BalloonVisibilityTrigger = {
    /// <summary>Represents balloon visibility trigger type.</summary>

    custom: 0,
    /// <summary>Custom trigger.</summary>

    mouseOver: 1,
    /// <summary>Show balloon when user places the mouse over the target element.</summary>

    mouseDown: 2,
    /// <summary>Show balloon when user clicks the target element.</summary>

    keyPress: 3,
    /// <summary>Show balloon when user presses any key on a target element.</summary>

    focus: 4
    /// <summary>Show balloon when user focuses the target element.</summary>
};

/* Inheritance */
Dynamicweb.Controls.OMC.Balloon.prototype = new Dynamicweb.Ajax.Control();

Dynamicweb.Controls.OMC.Balloon.prototype.add_positionChanged = function (handler) {
    /// <summary>Registers new handler which is executed when the position of the balloon changes.</summary>
    /// <param name="handler">Handler to register.</param>

    this.addEventHandler('positionChanged', handler);
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_isUserInteracting = function () {
    /// <summary>Gets value indicating whether user is interacting with the content of the balloon.</summary>

    return this._isUserInteracting;
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_title = function () {
    /// <summary>Gets the balloon title.</summary>

    return this._title;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_title = function (value) {
    /// <summary>Sets the balloon title.</summary>
    /// <param name="value">Balloon title.</param>

    this._title = value;
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_trigger = function () {
    /// <summary>Gets the balloon visibility trigger type.</summary>

    return this._trigger;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_trigger = function (value) {
    /// <summary>Sets the balloon visibility trigger type.</summary>
    /// <param name="value">Balloon visibility trigger type.</param>

    this._trigger = value || 0;
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_cssClass = function () {
    /// <summary>Gets the custom CSS class to be applied to balloon markup.</summary>

    return this._cssClass;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_cssClass = function (value) {
    /// <summary>Sets the custom CSS class to be applied to balloon markup.</summary>
    /// <param name="value">The custom CSS class to be applied to balloon markup.</param>

    var c = null;
    var prev = this._cssClass;

    this._cssClass = value || '';

    if (this._markup) {
        c = $(this._markup.container);

        if (prev && prev.length) c.removeClassName(prev);
        if (this._cssClass && this._cssClass.length) c.addClassName(this._cssClass);
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_target = function () {
    /// <summary>Gets the target element.</summary>

    var ret = null;

    if (this._target) {
        if (typeof (this._target) == 'string') {
            ret = $(this._target);

            if (ret) {
                this._target = ret;
            }
        } else {
            ret = this._target;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_target = function (value) {
    /// <summary>Sets the target element.</summary>
    /// <param name="value">Target element.</param>

    this._target = value;
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_content = function () {
    /// <summary>Gets the content of the balloon.</summary>

    var ret = null;

    if (this._content) {
        if (this._content instanceof Dynamicweb.Ajax.Lazy) {
            this._content = this._content.get_value();
        }

        if (typeof (this._content) == 'string') {
            ret = '';

            if (this._markup) {
                ret = this._markup.content.innerHTML;
            }
        } else if (this._markup) {
            ret = this._markup.content;
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_content = function (value) {
    /// <summary>Sets the content of the balloon.</summary>
    /// <param name="value">The content of the balloon.</param>

    this._content = value;
    this._contentChanged = true;
}

Dynamicweb.Controls.OMC.Balloon.prototype.get_isVisible = function () {
    /// <summary>Gets value indicating whether balloon is visible.</summary>

    var ret = false;

    if (!this.get_isReady()) {
        if (this._isVisibleCached != null) {
            ret = !!this._isVisibleCached;
        }
    } else {
        this._ensureLayout();

        if (this._markup.container) {
            ret = (this._markup.container.getStyle('display') || '') != 'none';
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.Balloon.prototype.set_isVisible = function (value) {
    /// <summary>Sets value indicating whether balloon is visible.</summary>
    /// <param name="value">Value indicating whether balloon is visible.</param>

    var val = !!value;

    if (!this.get_isReady()) {
        this._isVisibleCached = val;
    } else {
        if (val) {
            this.show();
        } else {
            this.hide();
        }
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.show = function () {
    /// <summary>Shows the balloon.</summary>

    this._ensureLayout();

    if (this.get_isEnabled()) {
        if (this._markup.container) {
            this._markup.container.show();

            this.update();
        }
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.hide = function () {
    /// <summary>Hides the balloon.</summary>

    this._ensureLayout();

    if (this._markup.container) {
        this._markup.container.hide();
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.update = function () {
    /// <summary>Updates the state of the balloon.</summary>

    this._ensureLayout();

    if (this.get_isVisible()) {
        this.updateContent();
        this.updatePosition();
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.updatePosition = function () {
    /// <summary>Updates the position of the balloon.</summary>

    var args = null;
    var selfWidth = 0;
    var borderWidth = 38;
    var contentWidth = 0;
    var t = this.get_target();
    var scroll = { top: 0, left: 0 };
    var offset = { top: 0, left: 0 };
    var position = { left: 0, top: 0 };
    var dimensions = { width: 0, height: 0 };

    this._ensureLayout();

    if (t && this._markup) {
        dimensions = t.getDimensions();
        offset = t.viewportOffset();
        scroll = $(document.body).cumulativeScrollOffset();

        $(this._markup.container).setStyle({ 'width': 'auto' });

        selfWidth = $(this._markup.container).getWidth();
        contentWidth = $(this._markup.content).getWidth();

        /* Special case when the container width is too narrow to expose borders */
        if (selfWidth - contentWidth < borderWidth) {
            selfWidth += (borderWidth - (selfWidth - contentWidth));
        }

        position.top = (offset.top + scroll.top) + 3;
        position.left = (offset.left + scroll.left) - selfWidth + dimensions.width + 18;

        if (Prototype.Browser.Gecko) {
            position.top -= 1;
        }

        this._markup.container.setStyle({
            'top': position.top + 'px',
            'left': position.left + 'px',
            'width': selfWidth + 'px'
        });

        args = new Dynamicweb.Controls.OMC.BalloonPositionArgs();

        args.set_left(position.left);
        args.set_top(position.top);

        this.onPositionChanged(args);

        if (args.get_left() != position.left) this._markup.container.setStyle({ 'left': args.get_left() + 'px' });
        if (args.get_top() != position.top) this._markup.container.setStyle({ 'top': args.get_top() + 'px' });
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.updateContent = function () {
    /// <summary>Updates the content of the balloon.</summary>

    var t = null;

    this._ensureLayout();

    if (this._markup) {
        if (this._content && this._contentChanged) {
            this._contentChanged = false;
            this._markup.content.innerHTML = '';

            if (this._content instanceof Dynamicweb.Ajax.Lazy) {
                this._content = this._content.get_value();
            }

            if (typeof (this._content) == 'string') {
                this._markup.content.innerHTML = this._content;
            } else {
                this._markup.content.appendChild(this._content);
            }
        }

        if (this.get_title() && this.get_title().length) {
            this._markup.title.innerHTML = this.get_title();
        } else {
            t = this.get_target();
            if (t) {
                this._markup.title.innerHTML = t.innerHTML || '';
            }
        }
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype.onPositionChanged = function (e) {
    /// <summary>Fires "positionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.raiseEvent('positionChanged', e);
}

Dynamicweb.Controls.OMC.Balloon.prototype.initialize = function () {
    /// <summary>Initializes the control.</summary>

    var self = this;
    var t = this.get_target();
    var interactionTimeout = null;

    if (t) {
        Event.observe(t, 'mouseover', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.mouseOver) {
                self.show();
            }
        });

        Event.observe(t, 'mouseout', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.mouseOver) {
                if (interactionTimeout) {
                    clearTimeout(interactionTimeout);
                    interactionTimeout = null;
                }

                interactionTimeout = setTimeout(function () {
                    if (!self.get_isUserInteracting()) self.hide();
                }, 1);
            }
        });

        Event.observe(t, 'focus', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.focus) {
                self.show();
            }
        });

        Event.observe(t, 'blur', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.mouseOver ||
                self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.keyPress) {

                self.hide();
            }
        });

        Event.observe(t, 'keypress', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.keyPress) {
                self.show();
            }
        });

        Event.observe(t, 'mousedown', function (e) {
            if (self.get_trigger() == Dynamicweb.Controls.OMC.BalloonVisibilityTrigger.mouseDown) {
                self.show();

                Event.stop(e);
            }
        });
    }

    Event.observe(document.body, 'mousedown', function (e) {
        var elm = Event.element(e);
        var container = elm.up('.balloon-overlay');

        if (!container || container.id != ('markup_' + self.get_container().id)) {
            self.hide();
        }
    });

    if (this._isVisibleCached != null) {
        setTimeout(function () {
            if (self._isVisibleCached) {
                self.show();
            } else {
                self.hide();
            }

            self._isVisibleCached = null;
        }, 50);
    }
}

Dynamicweb.Controls.OMC.Balloon.prototype._ensureLayout = function () {
    /// <summary>Ensures that the markup for the balloon has been created.</summary>
    /// <private />

    var tip = null;
    var row = null;
    var self = this;
    var table = null;
    var content = null;
    var container = null;
    var titleTable = null;
    var contentCell = null;
    var titleContent = null;
    var titleTableContainer = null;

    if (!this._markup) {
        this._markup = {};

        container = new Element('div', { 'id': 'markup_' + this.get_container().id, 'class': 'balloon-overlay' + (this.get_cssClass() && this.get_cssClass().length ? ' ' + this.get_cssClass() : '') });
        container.setStyle({ 'display': 'none' });

        /* Title */
        titleTableContainer = new Element('div', { 'class': 'balloon-overlay-title-container' });
        titleTable = new Element('table', { 'class': 'balloon-overlay-title' });

        titleTable.writeAttribute('cellspacing', '0');
        titleTable.writeAttribute('cellpadding', '0');
        titleTable.writeAttribute('border', '0');

        row = new Element('tr');
        titleContent = new Element('span');
        contentCell = new Element('td', { 'class': 'balloon-overlay-title-tm', 'valign': 'top' });

        contentCell.appendChild(titleContent);

        row.appendChild(new Element('td', { 'class': 'balloon-overlay-title-tl', 'valign': 'top' }).update('&nbsp;'));
        row.appendChild(contentCell);
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-title-tr', 'valign': 'top' }).update('&nbsp;'));

        titleTable.appendChild(row);

        titleTableContainer.appendChild(titleTable);
        titleTableContainer.appendChild(new Element('div', { 'class': 'balloon-overlay-clear' }));
        container.appendChild(titleTableContainer);

        /* Main grid */
        table = new Element('table', { 'class': 'balloon-overlay-grid' });

        table.writeAttribute('cellspacing', '0');
        table.writeAttribute('cellpadding', '0');
        table.writeAttribute('border', '0');

        /* Top cells - tl (top left), tm (top middle), tr, (top right) */
        row = new Element('tr');

        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-tl' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-tm' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-tr' }).update('&nbsp;'));

        table.appendChild(row);

        /* Middle cells - ml (middle left), mm (middle middle), mr, (middle right) */

        row = new Element('tr');
        content = new Element('div', { 'class': 'balloon-overlay-content' });
        contentCell = new Element('td', { 'class': 'balloon-overlay-grid-mm' });

        contentCell.appendChild(content);

        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-ml' }).update('&nbsp;'));
        row.appendChild(contentCell);
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-mr' }).update('&nbsp;'));

        table.appendChild(row);

        /* Bottom cells - bl (bottom left), bm (bottom middle), br, (bottom right) */
        row = new Element('tr');

        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-bl' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-bm' }).update('&nbsp;'));
        row.appendChild(new Element('td', { 'class': 'balloon-overlay-grid-br' }).update('&nbsp;'));

        table.appendChild(row);

        container.appendChild(table);

        Event.observe(container, 'mouseover', function (e) {
            if (self._hideTimeout) {
                clearTimeout(self._hideTimeout);
                self._hideTimeout = null;
            }

            self._isUserInteracting = true;
        });

        Event.observe(container, 'mouseout', function (e) {
            if (self._hideTimeout) {
                clearTimeout(self._hideTimeout);
                self._hideTimeout = null;
            }

            self._hideTimeout = setTimeout(function () {
                self._isUserInteracting = false;
                self.hide();
            }, 100);
        });

        this._markup.title = titleContent;
        this._markup.content = content;
        this._markup.container = container;

        this._markup.content.innerHTML = '';

        document.body.appendChild(container);
    }
}

