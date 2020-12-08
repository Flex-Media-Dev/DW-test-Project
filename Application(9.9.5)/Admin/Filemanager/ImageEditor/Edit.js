/* prototype.js should be included. */

function initActions(e) {
    // actions enabled only when selection active
    $('cmdCrop', 'cmdResizeSelection').each(function(e) { e.addClassName("imageeditor-onlywhenselected"); });
};

function initAjaxIndicator() {
    Ajax.Responders.register({
        onCreate: function() {
            if (Ajax.activeRequestCount == 1) {
                $('loading').show();
            }
        },
        onComplete: function() {
            if (Ajax.activeRequestCount == 0) {
                $('loading').hide();
            }
        }
    });
};

function initResizeDialog() {
    var w = $("resizeDialogWidth");
    var h = $("resizeDialogHeight");
    var ratio = $("resizeDialogMaintainAspectRatio");
    var image = $("image");
    
    w.observe("keyup", function() {if (ratio.checked) {
            var size = image.getDimensions();
            var width = w.value;
            h.value = Math.round(size.height * width / size.width);
    }});
    
    h.observe("keyup", function() {if (ratio.checked) {
            var size = image.getDimensions();
            var height = h.value;
            w.value = Math.round(size.width * height / size.height);
    }});

    w.observe("focus", function() {w.select();});
    h.observe("focus", function() {h.select();});

};

function initResizeSelectionDialog() {
    var w = $("resizeSelectionWidth");
    var h = $("resizeSelectionHeight");
    w.observe("focus", function() {w.select();});
    h.observe("focus", function() {h.select();});
}

function initColorCorrectionDialog() {
    var sliders = ["brightness", "contrast", "saturation"];
    // sliders
    sliders.each(function(control) {
        var c = $(control + "-value");
        c.value = 0;
        c.slider = new Control.Slider(control + "-slider-thumb", control +  "-slider", {
            axis: 'horizontal',
            range: $R(-100, 100),
            sliderValue: .00001,
            onSlide: function(value) { c.value = Math.round(value); },
            onChange: function(value) { c.value = Math.round(value); }
        });
        
        c.observe("change", function(e) {slider.setValue(c.value); });
        c.observe("focus", function() { c.select(); });
    });
};

function initSaveAsDialog() {
    // hide unrelated options
    $("saveAsDialogType").observe("change", function() {
        var prefix = "saveAsDialogOptions_";
        $A($("saveAsDialogType").options).each(function(o) {
            var elem = $(prefix + o.value);
            elem && elem.hide();
        });
        // show neccessary option
        var elem = $(prefix + $F("saveAsDialogType"));
        elem && elem.show();
    });
};


function resetColorCorrectionSliders() {
    ["brightness", "contrast", "saturation"].each(function(e) {
        var el = $(e + "-value");
        el.value = 0;
        el.slider.setValue(0);
    });
};


/**
 * Utility class to transform coordnates from global to local and vice versa.
 */
var Coordinates = new Object();

/**
 * Converts point {x,y} global coordinates to relative coordinates of the element (element should be $("") - processed).
 * @return point {x,y}
 */
Coordinates.toLocal = function(point, element) {
    var offset = element.cumulativeOffset();
    var scrollOffset = element.cumulativeScrollOffset();
    
    return {x: point.x - offset.left + scrollOffset.left, y: point.y - offset.top + scrollOffset.top };
};

/**
 * Converts event global coordinates to relative coordinates of the element (element should be $("") - processed).
 * @return point {x,y}
 */
Coordinates.eventToLocal = function(event, element) {
    var offset = element.cumulativeOffset();
    var scrollOffset = element.cumulativeScrollOffset();
    
    return {x: event.pointerX() - offset.left + scrollOffset.left, y: event.pointerY() - offset.top + scrollOffset.top };
};

Coordinates.limit = function(value, min, max) {
    return value < min ? min : value > max ? max : value;
}
/**
 * Converts point {x,y} relative coordinates of the element (element should be $("") - processed) to global coordinates.
 * @return point {x,y}
 */
Coordinates.toGlobal = function(point, element) {
    var offset = element.cumulativeOffset();
    var scrollOffset = element.cumulativeScrollOffset();
    return { x: point.x + offset.left - scrollOffset.left, y: point.y + offset.top - scrollOffset.top };
};

/**
 * Creates rectangle from two points.
 * @return rect {left, top, width, height }
 */
Coordinates.toRect = function(from, to) {
    return {
        left: Math.min(from.x, to.x),
        top: Math.min(from.y, to.y),
        width: Math.abs(from.x - to.x),
        height: Math.abs(from.y - to.y)
    };
};


/**
* Crop area for the image.
*/
var CropArea = Class.create({
    /** create new crop area */
    initialize: function(image) {
        this.image = $(image);
        this.status = $("imagestatus-selection");
        this.status.defaultValue = this.status.innerHTML;

        // initialize events
        this.events = {
            up: this.onMouseUp.bindAsEventListener(this),
            move: this.onMouseMove.bindAsEventListener(this),
            dblClick: this.onMouseDblClick.bindAsEventListener(this),
            down: this.onMouseDown.bindAsEventListener(this)
        };

        // initialize selection div
        this.div = $("image-crop");
        this.div.setOpacity(.2);
        this.div.observe("dblclick", this.events.dblClick);
        this.div.observe("mousedown", this.events.down);
        this.div.observe("mousemove", this.events.move);

        this.emptyMovePolicy = this.updateCursor.bind(this);
    },

    /** check visibility. returns true, if selection visible */
    isActive: function() { return "block" == this.div.getStyle("display"); },

    /** show this crop area */
    showArea: function() {
        this.div.style.display = 'block';
        $$(".imageeditor-onlywhenselected").each(function(e) { e.removeClassName("disabled"); });
    },

    /** hide this crop area */
    hideArea: function() {
        this.div.style.display = 'none';
        $$(".imageeditor-onlywhenselected").each(function(e) { e.addClassName("disabled"); });
        this.status.update(this.status.defaultValue);
    },

    /** returns true, if area is too small, i.e. less then 4 px in any direction */
    isTooSmall: function() {
        var size = this.div.getDimensions();
        return size.width <= 4 || size.height <= 4;
    },

    /** set start position of the div. onMouseDown */
    startCreatingArea: function(point) {
        var that = this;
        var startPoint = point;
        this.movePolicy = function(point) { that.setRectangle(Coordinates.toRect(startPoint, point)); };

        this.setRectangle(Coordinates.toRect(point, point))
        this.showArea();
        this.listenMouseEvents(true);
    },

    /** returns current crop rectangle*/
    getRectangle: function() {
        return this.rect;
    },

    setRectangle: function(rect) {
        var dimensions = this.image.getDimensions();
        if (rect.left < 0) {
            rect.width += rect.left;
            rect.left = 0;
        }
        if (rect.top < 0) {
            rect.height += rect.top;
            rect.top = 0;
        }
        if (rect.left + rect.width > dimensions.width) rect.width = dimensions.width - rect.left;
        if (rect.top + rect.height > dimensions.height) rect.height = dimensions.height - rect.top;
        this.rect = rect;
        this.status.update(rect.width + " x " + rect.height);

        this.div.style.left = rect.left + "px";
        this.div.style.top = rect.top + "px";
        this.div.style.width = rect.width + "px";
        this.div.style.height = rect.height + "px";
    },

    listenMouseEvents: function(listen) {
        var method = listen ? document.observe : document.stopObserving;
        method.call(document, "mouseup", this.events.up);
        method.call(document, "mousemove", this.events.move);
    },

    onMouseUp: function(event) {
        this.listenMouseEvents(false);
        var point = Coordinates.eventToLocal(event, this.image);
        this.movePolicy(point);
        if (this.isTooSmall()) this.hideArea();
        this.movePolicy = this.emptyMovePolicy;
        event.stop();
    },

    onMouseMove: function(event) {
        var point = Coordinates.eventToLocal(event, this.image);
        this.movePolicy(point);
        event.stop();
    },

    onMouseDblClick: function(event) {
        this.hideArea();
        event.stop();
    },

    /**
    * Cursor location is number:
    * 1 2 3
    * 4 5 6
    * 7 8 9
    * bad idea, need to introduce constants or something.
    */
    getCursorLocation: function(point) {
        var dimensions = this.image.getDimensions();
        var rect = this.getRectangle();
        // check where the user clicks in selection area
        var left = Math.abs(point.x - rect.left) <= 4;
        var right = Math.abs(point.x - rect.left - rect.width) <= 4;
        var top = Math.abs(point.y - rect.top) <= 4;
        var bottom = Math.abs(point.y - rect.top - rect.height) <= 4;
        var res = top ? 1 : bottom ? 7 : 4;
        res += left ? 0 : right ? 2 : 1;
        return res;
    },

    updateCursor: function(point) {
        var cursor = "default";
        var location = this.getCursorLocation(point);
        switch (location) {
            case 1: cursor = "nw-resize"; break;
            case 2: cursor = "n-resize"; break;
            case 3: cursor = "ne-resize"; break;
            case 4: cursor = "w-resize"; break;
            case 5: cursor = "move"; break;
            case 6: cursor = "w-resize"; break;
            case 7: cursor = "sw-resize"; break;
            case 8: cursor = "s-resize"; break;
            case 9: cursor = "se-resize"; break;
        }
        this.div.style.cursor = cursor;
    },

    onMouseDown: function(event) {
        if (event.isLeftClick()) {
            var that = this;
            var startPoint = Coordinates.eventToLocal(event, this.image);
            var dimensions = this.image.getDimensions();
            var rect = this.getRectangle();
            // check where the user clicks in selection area
            var location = this.getCursorLocation(startPoint);

            switch (location) {
                case 1: // top left
                    this.movePolicy = function(point) {
                        if (point.y < 0) point.y = 0;
                        if (point.x < 0) point.x = 0;
                        var offset = { x: point.x - startPoint.x, y: point.y - startPoint.y };
                        var r = Object.clone(rect);
                        var bottom = r.top + r.height;
                        var right = r.left + r.width;
                        r.left += offset.x;
                        r.top += offset.y;
                        if (r.left + 4 >= right) r.left = right - 4;
                        if (r.top + 4 >= bottom) r.top = bottom - 4;
                        r.height = bottom - r.top;
                        r.width = right - r.left;
                        that.setRectangle(r);
                    };
                    break;
                case 2: // top
                    this.movePolicy = function(point) {
                        if (point.y < 0) point.y = 0;
                        var offsety = point.y - startPoint.y;
                        var r = Object.clone(rect);
                        var bottom = r.top + r.height;
                        r.top += offsety;
                        if (r.top + 4 >= bottom) r.top = bottom - 4;
                        r.height = bottom - r.top;
                        that.setRectangle(r);
                    };
                    break;
                case 3: // top right
                    this.movePolicy = function(point) {
                        if (point.y < 0) point.y = 0;
                        if (point.x > dimensions.width) point.x = dimensions.width;
                        var offset = { x: point.x - startPoint.x, y: point.y - startPoint.y };
                        var r = Object.clone(rect);
                        var bottom = r.top + r.height;
                        var right = r.left + r.width + offset.x;
                        r.top += offset.y;
                        if (r.top + 4 >= bottom) r.top = bottom - 4;
                        if (right - 4 <= r.left) right = r.left + 4;
                        r.height = bottom - r.top;
                        r.width = right - r.left;
                        that.setRectangle(r);
                    };
                    break;
                case 4: // left
                    this.movePolicy = function(point) {
                        if (point.x < 0) point.x = 0;
                        var offsetx = point.x - startPoint.x;
                        var r = Object.clone(rect);
                        var right = r.left + r.width;
                        r.left += offsetx;
                        if (r.left + 4 >= right) r.left = right - 4;
                        r.width = right - r.left;
                        that.setRectangle(r);
                    };
                    break;
                case 5: // center, move
                    this.movePolicy = function(point) {
                        var offsets = { x: point.x - startPoint.x, y: point.y - startPoint.y };
                        var r = Object.clone(rect);
                        r.left += offsets.x;
                        r.top += offsets.y;
                        if (r.left < 0) r.left = 0;
                        if (r.top < 0) r.top = 0;
                        if (r.left + r.width > dimensions.width) r.left = dimensions.width - r.width;
                        if (r.top + r.height > dimensions.height) r.top = dimensions.height - r.height;
                        that.setRectangle(r);
                    };
                    break;
                case 6: // right
                    this.movePolicy = function(point) {
                        if (point.x > dimensions.width) point.x = dimensions.width;
                        var offsetx = point.x - startPoint.x;
                        var r = Object.clone(rect);
                        var right = r.left + r.width + offsetx;
                        if (right - 4 <= r.left) right = r.left + 4;
                        r.width = right - r.left;
                        that.setRectangle(r);
                    };
                    break;
                case 7: // bottom left
                    this.movePolicy = function(point) {
                        if (point.x < 0) point.x = 0;
                        if (point.y > dimensions.width) point.y = dimensions.width;
                        var offset = { x: point.x - startPoint.x, y: point.y - startPoint.y };
                        var r = Object.clone(rect);
                        var right = r.left + r.width;
                        var bottom = r.top + r.height + offset.y;
                        r.left += offset.x;
                        if (r.left + 4 >= right) r.left = right - 4;
                        if (bottom - 4 <= r.top) bottom = r.top + 4;
                        r.width = right - r.left;
                        r.height = bottom - r.top;
                        that.setRectangle(r);
                    };
                    break;
                case 8: // bottom
                    this.movePolicy = function(point) {
                        if (point.y > dimensions.width) point.y = dimensions.width;
                        var offsety = point.y - startPoint.y;
                        var r = Object.clone(rect);
                        var bottom = r.top + r.height + offsety;
                        if (bottom - 4 <= r.top) bottom = r.top + 4;
                        r.height = bottom - r.top;
                        that.setRectangle(r);
                    };
                    break;
                case 9: // bottom right
                    this.movePolicy = function(point) {
                        if (point.y > dimensions.width) point.y = dimensions.width;
                        if (point.x > dimensions.width) point.x = dimensions.width;
                        var offset = { x: point.x - startPoint.x, y: point.y - startPoint.y };
                        var r = Object.clone(rect);
                        var bottom = r.top + r.height + offset.y;
                        var right = r.left + r.width + offset.x;
                        if (bottom - 4 <= r.top) bottom = r.top + 4;
                        if (right - 4 <= r.left) right = r.left + 4;
                        r.height = bottom - r.top;
                        r.width = right - r.left;
                        that.setRectangle(r);
                    };
                    break;
            }

            this.listenMouseEvents(true);
            event.stop();
        }
    }
});


/**
 * Image Editor class.
 */
var ImageEditor = Class.create({
    /** Constructor */
    initialize: function (image) {
        image = image || "image";
        // events binded to this instance.
        this.events = {
            down: this.onMouseDown.bindAsEventListener(this),
            move: this.onMouseMove.bindAsEventListener(this)
        };

        // init status area
        this.status = {
            cursor: $("imagestatus-cursor"),
            size: $("imagestatus-size"),
            fileSize: $("imagestatus-filesize")
        };

        // init image
        this.image = $(image);
        this.image.observe("mousedown", this.events.down);
        this.image.observe("mousemove", this.events.move);
        this.updateDimensionsStatus();
        // init crop area
        this.cropArea = new CropArea(this.image);
    },

    onMouseDown: function (event) {
        if (event.isLeftClick()) {
            this.cropArea.startCreatingArea(Coordinates.eventToLocal(event, this.image));
            event.stop();
        }
    },

    onMouseMove: function (event) {
        this.updateCursorStatus(Coordinates.eventToLocal(event, this.image));
    },

    updateCursorStatus: function (point) {
        this.status.cursor.update(point.x + " x " + point.y);
    },

    updateSizeStatus: function (size) {
        this.status.fileSize.update(size);
    },

    updateDimensionsStatus: function () {
        var that = this;
        var timer = new ImageLoadTimer(this.image);
        timer.onComplete = function () {
            var size = that.image.getDimensions()
            that.status.size.update(size.width + " x " + size.height);
        };
        timer.start();
    },

    /** execute command using ajax. optional params holds additional parameters for the query */
    executeCommand: function (actionName, params, actions) {
        var that = this;
        params = $H(params).merge({ originalImage: $F("originalImage"), editedImage: $F("editedImage"), action: actionName })

        var area = this.cropArea;
        if (area.isActive()) {
            params = params.merge({ x1: area.rect.left, y1: area.rect.top, x2: area.rect.left + area.rect.width, y2: area.rect.top + area.rect.height });
            area.hideArea();
        }

        new Ajax.Request(document.URL + '&timestamp=' + (new Date()).getTime(), {
            method: "post",
            parameters: params,
            onSuccess: function (transport) {
                processed = true;
                var imageInfo = transport.responseJSON;
                that.image.src = imageInfo.src;
                that.updateDimensionsStatus();
                that.updateSizeStatus(imageInfo.size);
                if (!Object.isUndefined(actions)) {
                    actions.success();
                };
            }
        });
    },

    /** resize image. */
    executeResize: function (execute) {
        var size = this.image.getDimensions();
        var area = this.cropArea;
        execute = execute || false;
        if (execute) {
            var newWidth = $("resizeDialogWidth").value;
            var newHeight = $("resizeDialogHeight").value;
            if ((newWidth != size.width || newHeight != size.height) && newWidth > 0 && newHeight > 0) {
                this.executeCommand("resize", {
                    'width': newWidth,
                    'height': newHeight,
                    maintainAspectRatio: $("resizeDialogMaintainAspectRatio").checked
                });
            }
            dialog.hide('resizeDialog');
        } else {
            $("resizeDialogWidth").value = area.isActive() ? area.getRectangle().width : size.width;
            $("resizeDialogHeight").value = area.isActive() ? area.getRectangle().height : size.height;
            $("resizeDialogMaintainAspectRatio").checked = true;
            dialog.show('resizeDialog');
        }
    },

    /** resize selection. */
    executeResizeSelection: function (execute) {
        var area = this.cropArea;
        execute = execute || false;
        if (area.isActive()) {
            var size = area.getRectangle();
            if (execute) {
                try {
                    size.width = parseInt($("resizeSelectionWidth").value, 10);
                    size.height = parseInt($("resizeSelectionHeight").value, 10);
                    area.setRectangle(size);
                } catch (e) { }
                dialog.hide('resizeSelectionDialog');
            } else {
                $("resizeSelectionWidth").value = size.width;
                $("resizeSelectionHeight").value = size.height;
                dialog.show('resizeSelectionDialog');
            }
        } else {
            dialog.hide('resizeSelectionDialog');
        };
    },

    executeEffectColorCorrection: function (execute, isPreview) {
        execute = execute || false;
        isPreview = isPreview || false;
        if (execute) {
            var params = {};
            var brightness = $F("brightness-value");
            var contrast = $F("contrast-value");
            var saturation = $F("saturation-value");
            if (brightness != 0) params.brightness = brightness;
            if (contrast != 0) params.contrast = contrast;
            if (saturation != 0) params.saturation = saturation;
            if (isPreview) {
                params.preview = true;
                this.executeCommand("effectColorCorrection", params);
            } else {
                this.executeCommand("effectColorCorrection", params);
                dialog.hide('colorCorrectionDialog');
            }
        } else {
            resetColorCorrectionSliders();
            dialog.show('colorCorrectionDialog');
        }
    },

    executeSaveAs: function (execute) {
        execute = execute || false;
        if (execute) {
            if (/[\\\\/*?:|\"<>]/.test($F("saveAsDialogFile"))) {
                $("helpsaveAsDialogFile").textContent = "The file name can not contain any of these characters \\/*?:|\"<>";
                $("helpsaveAsDialogFile").style.display = "block";
                return;
            }
            $("originalImage").value = "/Files" +
                    $$("input[name='saveAsDialogDirectory']")[0].value +
                    "/" +
                    $F("saveAsDialogFile");
            var imageType = $F("saveAsDialogType");
            this.executeCommand("save", {
                'compression': imageType === "webP" ? $F("saveAsDialogWebPCompression") : $F("saveAsDialogJpegCompression"),
                'colors': $F("saveAsDialogGifColors"),
                /*'bitdepth': $F("saveAsDialogPngBits"),*/ // no png support right now
                'imageType': imageType
            }, { success: function () {
                try {
                    if (winPreview) {
                        var src = winPreview.location.href;
                        if (src.endsWith('#')) {
                            src = src.substr(0, src.length - 1);
                        }
                        winPreview.location.href = src;
                    }
                }
                catch (err) {}
                try {
                    var src = winOpener.location.href;
                    if (src.endsWith('#')) {
                        src = src.substr(0, src.length - 1);
                    }
                    winOpener.location.href = src;
                }
                catch (err) {}
            }
            });
            dialog.hide('SaveAsDialog');
        } else {
            var fullPath = $F("originalImage");
            var slashPos = fullPath.lastIndexOf("/");
            var directory = fullPath.substring(0, slashPos);
            if (directory.toLowerCase().startsWith("/files"))
                directory = directory.substring(6);

            $$("input[name='saveAsDialogDirectory']")[0].value = directory;
            $("saveAsDialogFile").value = fullPath.substring(slashPos + 1);

            dialog.show('SaveAsDialog');
        }
    },

    executeSaveAndClose: function (doClose) {
        this.executeCommand("save", {}, { success: function () {
            if (doClose == true) {
                parent.reloadPage(true);
            }
        }
        });
    },

    reloadImage: function () {
        this.executeCommand("reset");
    }
});


/** monitores image loading, due to load event is not working in safari */
var ImageLoadTimer = Class.create({
    initialize: function(image) {
        this.image = image;
    },
    
    start: function() {
        this.timer = new PeriodicalExecuter(this.checkImage.bind(this), .5);
    },
    
    checkImage: function() {
        if (this.image.complete) {
            this.timer.stop();
            this.onComplete();
        }
    },
    
    onComplete: function() {}
});
