/* Represents a watermark that can be applied to the text-box field */
var WaterMark = new Object();

WaterMark.pasteTimer = null;

/* Shows the watermark */
WaterMark.show = function(element) {
    var textField = null;

    if (element && element.id) {
        textField = $(element.id + '_watermark');

        if (textField) {
            element.value = textField.value;

            $(element).setStyle({
                '_prevColor': $(element).getStyle('color'),
                'color': '#abaaaa'
            });
        }
    }
}

/* Hides the watermark */
WaterMark.hide = function(element) {
    if (element) {
        element.value = '';

        $(element).setStyle({
            'color': $(element).getStyle('_prevColor')
        });
    }
}

/* Sets value indicating whether text-box value is watermark text */
WaterMark.set_emptyState = function(element, isEmpty) {
    if (element) {
        element = $(element);
        element.writeAttribute('__isWatermark', (isEmpty ? 'true' : 'false'));
    }
}

/* Gets value indicating whether text-box value is watermark */
WaterMark.get_emptyState = function(element) {
    var ret = false;
    var attributeValue = '';

    if (element) {
        element = $(element);
        attributeValue = element.readAttribute('__isWatermark');

        if (attributeValue != null && attributeValue.length > 0)
            ret = (attributeValue == 'true');
        else
            ret = element.value.length == 0;
    }

    return ret;
}

/* Creates a new watermark for specified text-box */
WaterMark.create = function(element, text) {
    var textField = null;

    if (element && element.id) {
        element = $(element);

        textField = document.getElementById(element.id + '_watermark');

        if (!textField) {
            textField = new Element('input', {
                'type': 'hidden',
                'id': element.id + '_watermark',
                '_watermarkFor': element.id,
                'value': text
            });

            element.up().appendChild(textField);
        }

        textField.value = text;

        WaterMark.attachEvents(element);

        if (element.value == '') {
            WaterMark.show(element);
            WaterMark.set_emptyState(element, true);
        }
    }
}

WaterMark.proccessPaste = function(elm) {
    var val = elm.value;
    if (val && val.length > 0) {
        WaterMark.set_emptyState(elm, val.length == 0);
        if (WaterMark.pasteTimer != null) {
            clearTimeout(WaterMark.pasteTimer);
            WaterMark.pasteTimer = null;
        }
        return;
    }

    WaterMark.pasteTimer = setTimeout(function() { WaterMark.proccessPaste(elm); }, 20);
}

/* Assigns events listeners to enable watermark switching */
WaterMark.attachEvents = function(element) {
    var eventsAttribute = null;
    var form = null;

    if (element) {
        element = $(element);

        /* element.onfocus - hiding watermark if it's shown */
        element.observe('focus', function(event) {
            var elm = Event.element(event);

            if (WaterMark.get_emptyState(elm))
                WaterMark.hide(elm);
        });

        /* element.onkeyup - changing empty state */
        var inputChanged = function (event) {
            var elm = Event.element(event);
            WaterMark.set_emptyState(elm, elm.value.length == 0);
        };
        element.observe('keyup', inputChanged);
        element.observe("input", inputChanged);

        element.observe('paste', function(event) {
            var elm = Event.element(event);
            WaterMark.pasteTimer = setTimeout(function() { WaterMark.proccessPaste(elm); }, 5);
        });

        /* element.onblur - showing wwatermark if nothing was entered into text-box */
        element.observe('blur', function(event) {
            var elm = Event.element(event);

            if (WaterMark.pasteTimer != null) {
                clearTimeout(WaterMark.pasteTimer);
                WaterMark.pasteTimer = null;
                WaterMark.set_emptyState(elm, elm.value.length == 0);
            }

            if (WaterMark.get_emptyState(elm))
                WaterMark.show(elm);
        });

        /* selecting FORM element which contains current text-box */
        form = element.up('form');

        if (form) {
            form = $(form);
            eventsAttribute = form.readAttribute('_watermarksEventsInitialized');

            if (!eventsAttribute || eventsAttribute.length == 0) {
                /* we need to hide all watermarks before the form data is sent to the server
                so these watermarks won't be treated as an actual values */
                form.observe('submit', function(event) {
                    WaterMark.hideAll();
                });

                /* Marking current form as initialized */
                form.writeAttribute('_watermarksEventsInitialized', 'true');
            }
        }
    }
}

/* Hides all watermark texts from all text-boxes */
WaterMark.hideAll = function() {
    WaterMark.setVisibleAll(false);
}

WaterMark.setVisibleAll = function(areVisible) {
    var inputs = $$('input[_watermarkFor]');
    var textField = null;

    if (inputs && inputs.length > 0) {
        for (var i = 0; i < inputs.length; i++) {
            textField = $($(inputs[i]).readAttribute('_watermarkFor'));

            if (textField && WaterMark.get_emptyState(textField)) {
                if (!areVisible) {
                    WaterMark.hide(textField);
                } else {
                    WaterMark.show(textField);
                }
            }
        }
    }
}

WaterMark.showAll = function() {
    WaterMark.setVisibleAll(true);
}