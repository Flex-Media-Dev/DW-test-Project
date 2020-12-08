/* Namespace creation */

if (typeof (Optimize) == 'undefined') {
    Optimize = new Object();
}

/* End: Namespace creation */

Optimize.StringHelpers = function() {
    /// <summary>Provides methods for manipulating with strings.</summary>
}

Optimize.StringHelpers.getCharsCount = function(value) {
    /// <summary>Retrieves the number of characters of the specified string.</summary>
    /// <param name="value">String to examine.</param>
    
    var ret = 0;

    if (value) {
        ret = value.length;
    }

    return ret;
}

Optimize.StringHelpers.wrap = function(value, wrapStart, wrapEnd) {
    /// <summary>Surrounds the specified string with specified strings.</summary>
    /// <param name="value">String to process.</param>
    /// <param name="wrapStart">Start string.</param>
    /// <param name="wrapEnd">End string. Can be ommited (the resulting string will look like the following: &lt;wrapStart&gt;text&lt;/wrapStart&gt;</param>

    var ret = value;

    if (value && wrapStart) {
        if (typeof (wrapEnd) == 'undefined') {
            ret = '<' + wrapStart + '>' + value + '</' + wrapStart + '>';
        } else {
            ret = wrapStart + value + wrapEnd;
        }
    }

    return ret;
}

Optimize.StringHelpers.getFrequency = function(value, phrase) {
    /// <summary>Calculates the frequencly of the specified phrase within the specified string.</summary>
    /// <param name="value">String to examine.</param>
    /// <param name="phrase">Phrase to search for.</param>

    var ret = 0;
    var m = null;
    var rx = null;
    var encoded = Optimize.StringHelpers.regexEncode(phrase);

    if (value && phrase) {
        rx = new RegExp('\\b' + encoded + '\\b', 'gi');
        m = rx.exec(value);

        if (m != null) {
            ret = m.length;
        }
    }

    return ret;
}

Optimize.StringHelpers.regexEncode = function(value) {
    /// <summary>Encodes special regular expression characters in the specified string.</summary>
    /// <param name="value">String to process.</param>

    var ret = value;

    if (ret) {
        ret = ret.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
    }

    return ret;
}

Optimize.StringHelpers.getProminence = function(value, phrase) {
    /// <summary>Calculates the prominence of the specified phrase within the specified string.</summary>
    /// <param name="value">String to examine.</param>
    /// <param name="phrase">Phrase to search for.</param>

    var ret = 0;
    var m = null;
    var index = 0;
    var rx = null;
    var encoded = Optimize.StringHelpers.regexEncode(phrase);

    if (value && phrase) {
        value = Optimize.StringHelpers.normalize(value);

        if (value.length == phrase.length) {
            ret = (value.toLowerCase() == phrase.toLowerCase() ? 100 : 0);
        } else {
            rx = new RegExp(encoded + '\\b', 'gi');
            m = rx.exec(value);

            if (m) {
                ret = (m.index == 0 ? 100 : 0);
            }
        }
    }

    return ret;
}

Optimize.StringHelpers.getWordsCount = function(value) {
    /// <summary>Retrieves the number of words of the specified string.</summary>
    /// <param name="value">String to examine.</param>

    var ret = 0;

    if (value && value.length > 0) {
        ret = Optimize.StringHelpers.normalize(value).split(' ').length;
    }

    return ret;
}

Optimize.StringHelpers.trim = function(value) {
    /// <summary>Removes any whitespaces from the begining and ending of the specified string.</summary>
    /// <param name="value">String to examine.</param>

    var ret = value;

    if (value) {
        ret = ret.replace(/^\s+|\s+$/g, '');
    }

    return ret;
}

Optimize.StringHelpers.normalize = function(value) {
    /// <summary>Removes any whitespaces from the begining and ending of the specified string. Also replaces multiple spaces with the single ones.</summary>
    /// <param name="value">String to examine.</param>

    var ret = Optimize.StringHelpers.trim(value);

    if (ret) {
        ret = ret.replace(/\s+/g, ' ');
    }

    return ret;
}

Optimize.StringHelpers.htmlEncode = function(value) {
    /// <summary>Performs HTML encoding of the specified string.</summary>
    /// <param name="value">String to examine.</param>

    var ret = '';
    var parent = null;
    var encoder = null;
    var container = null;

    if (value) {
        container = document.createElement('span');
        encoder = document.createTextNode(value);
        container.appendChild(encoder);
        ret = container.innerHTML;

        if (container.parentNode) {
            parent = container.parentNode;
        } else if (container.parentElement) {
            parent = container.parentElement;
        }

        if (parent) {
            parent.removeChild(container);
        }
    }

    return ret;
}

Optimize.StringHelpers.truncate = function(value, maxChars) {
    /// <summary>Truncates specified string according to maximum allowed width.</summary>
    /// <param name="value">String to process.</param>
    /// <param name="maxChars">Maximum number of characters.</param>

    var ret = '';
    var moreText = ' ...';

    if (value && maxChars && value.length > maxChars + moreText.length) {
        ret = value.substr(0, maxChars) + moreText;
    } else {
        ret = value;
    }

    return ret;
}

Optimize.getFormElements = function() {
    /// <summary>Retrieves SEO-specific form elements from the parent frame.</summary>

    var ret = [];
    var inputs = null;
    var textareas = null;
    
    if (parent) {
        inputs = parent.document.getElementsByTagName('input');
        textareas = parent.document.getElementsByTagName('textarea');

        if (inputs) {
            for (var i = 0; i < inputs.length; i++) {
                ret[ret.length] = inputs[i];
            }
        }

        if (textareas) {
            for (var i = 0; i < textareas.length; i++) {
                ret[ret.length] = textareas[i];
            }
        }
    }

    return ret;
}

Optimize.getFormMappings = function() {
    /// <summary>Retrieves "CSS-class" -> "SEO field" mappings.</summary>

    return [
        { className: 'product-meta-title', field: 'title' },
        { className: 'product-meta-description', field: 'description' },
        { className: 'product-meta-keywords', field: 'keywords' },
        { className: 'product-meta-url', field: 'url' }
    ];    
}

Optimize.readFromEditForm = function() {
    /// <summary>Reads values from the parent frame and fills the edit form with that values.</summary>

    var ret = [];
    var element = null;
    var elements = Optimize.getFormElements();
    var mappings = Optimize.getFormMappings();
    var productID = document.getElementById('TargetProductID');

    if (productID && productID.value.toLowerCase() == Optimize.getEditFormProductID().toLowerCase()) {
        for (var i = 0; i < mappings.length; i++) {
            element = Optimize.getElementByClassName(mappings[i].className, elements);

            if (element) {
                ret[ret.length] = { name: mappings[i].field, value: element.value };
            }
        }
    }

    return ret;
}

Optimize.writeToEditForm = function(params) {
    /// <summary>Writes values from the edit form into the parent frame's form.</summary>
    /// <param name="params">Function parameters.</param>
    
    var wnd = null;
    var element = null;
    var productID = params.productID;
    var elements = Optimize.getFormElements();
    var mappings = Optimize.getFormMappings();

    if (!productID) {
        productID = '';
    }
    
    if (params && parent) {
        if (productID.toLowerCase() == Optimize.getEditFormProductID().toLowerCase()) {
            for (var i = 0; i < mappings.length; i++) {
                element = Optimize.getElementByClassName(mappings[i].className, elements);

                if (element) {
                    element.value = params[mappings[i].field];
                }
            }
        }

        parent.dialog.hide(Optimize.getDialogId());
    }
    
}

Optimize.getDialogId = function () {
    var frame = window.frameElement;
    var container = $(frame).up('div.sidebox');
    return container.id;
}


Optimize.getElementByClassName = function(className, elements) {
    /// <summary>Filters elements by the specified CSS-class.</summary>
    /// <param name="className">CSS-class to search for.</param>
    /// <param name="elements">Elements to search within.</param>
    
    var ret = null;

    if (className && elements) {
        for (var i = 0; i < elements.length; i++) {
            if (elements[i].className && elements[i].className.indexOf(className) >= 0) {
                ret = elements[i];
                break;
            }
        }
    }

    return ret;
}

Optimize.getEditFormProductID = function() {
    /// <summary>Retrieves an ID of the product which is being edited from the parent frame.</summary>

    var m = null;
    var ret = '';
    
    if (parent) {
        if (typeof (parent._productId) != 'undefined') {
            ret = parent._productId;
        } else {
            m = new RegExp('(\\?|&)ID=(PROD[0-9]+)', 'gi').exec(parent.location.href);
            if (m) {
                ret = m[2];
            }
        }
    }

    return ret;
}

Optimize.PhraseList = function() {
    /// <summary>Represents a list of keywords/phrases.</summary>
}

Optimize.PhraseList.selectPhrase = function(phrase) {
    /// <summary>Selects specified phrase as target phrase.</summary>
    /// <param name="phrase">Phrase to select.</param>

    document.getElementById('SelectedPhrase').value = phrase;
    document.forms[0].submit();
}

Optimize.PhraseList.useCustomPhrase = function() {
    if (Optimize.PhraseList.validateUserInput()) {
        document.forms[0].submit();
    }
}

Optimize.PhraseList.validateUserInput = function() {
    /// <summary>Performs validation of user input.</summary>

    var ret = false;
    var f = document.getElementById('UserDefinedPhrase');

    ret = f.value.length > 0;

    if (!ret) {
        f.focus();
    }

    return ret;
}

Optimize.PhraseList.chooseProduct = function() {
    /// <summary>Opens the new window where user can choose different product to optimize.</summary>

    var caller = 'window.opener.document.MainForm.DW_REPLACE_CustomProductID';
    
    window.open('/Admin/Module/eCom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowProd&invokeOnChangeOnID=true&AddCaller=1&caller=' + caller, '',
        'displayWindow,width=460,height=400,scrollbars=no');
}

Optimize.PhraseList.initialize = function() {
    /// <summary>Performs initialization stage.</summary>

    var id = document.getElementById('TargetProductID').value +
        document.getElementById('TargetProductVariantID').value;

    if (id.length == 0) {
        document.getElementById('UserDefinedPhrase').disabled = true;
        document.getElementById('cmdSubmitPhrase').disabled = true;
    } else {
        Optimize.PhraseList.setTitle();
    }
}

Optimize.PhraseList.setTitle = function() {
    /// <summary>Sets the title of the dialog control.</summary>
    var text = '';
    var msg = document.getElementById('msgDialogTitle');

    if (msg) {
        text = msg.innerHTML.replace(/%%/g, Optimize.StringHelpers.htmlEncode(Optimize.StringHelpers.truncate(document.getElementById('TargetProductName').value, 75)));
        if (parent) {
            parent.dialog.setTitle(Optimize.getDialogId(), text);
        }
    }
}

Optimize.PhraseList.ProductChange = function() {
    /// <summary>Tracks the change of the hidden field representing a product that has been choosen by a user.</summary>
    location.href = '/Admin/Module/eCom_Catalog/dw7/Optimize/Default.aspx?ProductID=' + document.getElementById('ID_CustomProductID').value + '&t=' + (new Date()).getTime();
}

Optimize.PhraseList.help = function() {
    /// <summary>Displays help information.</summary>

    eval(document.getElementById('jsHelp').innerHTML);
    
}

Optimize.OptimizeResults = function() {
    /// <summary>Represents a list of optimize results.</summary> 
}

/* Currently selected field */
Optimize.OptimizeResults._activeField = '';

/* A list of all fields */
Optimize.OptimizeResults._fields = [];

/* The maximum number of conditions that should be satisfied before user riches 100% completion */
Optimize.OptimizeResults._completionMaximumCalculated = 0;

/* Value indicating whether user has made any changes */
Optimize.OptimizeResults._isDirty = false;

/* Represents a validity state */
Optimize.OptimizeResults.OptimizeFieldValidityState = {
    /* Field is valid (ok) */
    invalid: 1,
    
    /* Field is partially valid (warning) */
    partiallyValid: 2,
    
    /* Field is invalid (error) */
    valid: 3
}

Optimize.OptimizeResults.preloadImages = function(containerID) {
    /// <summary>Performs preloading of images for faster execution.</summary>

    var src = null;
    var container = null;
    var images = [
        'optimize-field-gradient.png',
        'optimize-keyword-add.png',
        'optimize-keyword-fade.png',
        'optimize-quote.png',
        '/Admin/Images/Ribbon/Icons/Small/check.png',
        '/Admin/Images/Ribbon/Icons/Small/warning.png',
        '/Admin/Images/Ribbon/Icons/Small/error.png',
        '/Admin/Images/Ribbon/Icons/check.png',
        '/Admin/Images/Ribbon/Icons/warning.png',
        '/Admin/Images/Ribbon/Icons/error.png'
    ];

    container = document.getElementById(containerID);

    if (container) {
        for (var i = 0; i < images.length; i++) {
            if (images[i].indexOf('/') == 0) {
                src = images[i];
            } else {
                src = '/Admin/Module/eCom_Catalog/dw7/images/' + images[i];
            }

            container.innerHTML += '<img src="' + src + '" style="display: none" alt="" />';
        }
    }
}

Optimize.OptimizeResults.save = function() {
    /// <summary>Saves the user input.</summary>

    document.forms[0].submit();
}

Optimize.OptimizeResults.cancel = function() {
    /// <summary>Cancels the user input.</summary>

    var wnd = null;
    var canQuit = true;

    if (Optimize.OptimizeResults._isDirty) {
        canQuit = confirm(document.getElementById('spCancelConfirm').innerHTML);
    }

    if (canQuit) {
        if (parent != null) {
            parent.dialog.hide(Optimize.getDialogId());
        }
    }
}

Optimize.OptimizeResults.reset = function() {
    /// <summary>Resets the user input.</summary>
    
    var canReset = true;

    if (Optimize.OptimizeResults._isDirty) {
        canReset = confirm(document.getElementById('spCancelConfirm').innerHTML);
    }

    if (canReset) {
        location.href = 'Edit.aspx?ProductID=' +
            encodeURIComponent(document.getElementById('TargetProductID').value) + '&Phrase=' +
            encodeURIComponent(document.getElementById('TargetPhrase').value) + '&ProductVariantID=' +
            encodeURIComponent(document.getElementById('TargetProductVariantID').value) + '&t=' + (new Date()).getTime();
    }
}

Optimize.OptimizeResults.changePhrase = function() {
    /// <summary>Redirects user to the phrase list.</summary>

    var canChange = true;

    if (Optimize.OptimizeResults._isDirty) {
        canChange = confirm(document.getElementById('spCancelConfirm').innerHTML);
    }

    if (canChange) {
        location.href = 'Default.aspx?ProductID=' +
        encodeURIComponent(document.getElementById('TargetProductID').value) + '&ForcePhraseSelection=True&t=' + (new Date()).getTime();
    }
}

Optimize.OptimizeResults.nextField = function() {
    /// <summary>Moves the focus to the next field.</summary>

    Optimize.OptimizeResults.moveTo(1);
}

Optimize.OptimizeResults.previousField = function() {
    /// <summary>Moves the focus to the previous field.</summary>

    Optimize.OptimizeResults.moveTo(-1);
}

Optimize.OptimizeResults.moveTo = function(direction) {
    /// <summary>Moves the focus into the specified direction.</summary>
    /// <param name="direction">Direction to move into.</param>

    var index = 0;
    var field = Optimize.OptimizeResults.get_activeField();
    var navigationName = (direction > 0 ? 'Next' : 'Previous');

    if (navigationName && direction) {
        if (Optimize.OptimizeResults.isNavigationEnabled(navigationName)) {
            index = Optimize.OptimizeResults.getFieldIndex(field.get_name()) + direction;
            if (index >= 0 && index < Optimize.OptimizeResults._fields.length) {
                Optimize.OptimizeResults.set_activeField(Optimize.OptimizeResults._fields[index].get_name());
            }
        }
    }
}

Optimize.OptimizeResults.isNavigationEnabled = function(navigationName) {
    /// <summary>Determines whether specified type of navigation is available.</summary>
    /// <param name="navigationName">Navigation type.</param>

    var cmd = null;
    var ret = true;

    if (navigationName) {
        cmd = $(navigationName.toLowerCase() == 'next' ? 'cmdNext' : 'cmdPrev');
        if (cmd) {
            ret = !cmd.disabled;
        }
    }

    return ret;
}

Optimize.OptimizeResults.setNavigationIsEnabled = function(navigationName, isEnabled) {
    /// <summary>Switches specified navigation type into the specified state.</summary>
    /// <param name="navigationName">Navigation type.</param>
    /// <param name="isEnabled">Value indicating whether specified navigation type is enabled.</param>

    var cmd = null;

    if (navigationName) {
        cmd = $(navigationName.toLowerCase() == 'next' ? 'cmdNext' : 'cmdPrev');
        if (cmd) {
            cmd.disabled = !isEnabled;
        }
    }
}

Optimize.OptimizeResults.validateField = function(text, field, updateCompletion) {
    /// <summary>Validates specified vield.</summary>
    /// <param name="field">Field to validate.</param>
    /// <param name="updateCompletion">Value indicating whether to update completion value.</param>

    var result = null;
    var phrase = document.getElementById('TargetPhrase').value;

    if (!field) {
        field = Optimize.OptimizeResults.get_activeField();
    }

    if (!text) {
        text = document.getElementById('txField').value;
    }

    if (field) {
        /* Updating field value (both hidden field and summary) */
        field.set_value(text);

        /* Validating the field against specified phrase */
        result = field.validate(phrase, updateCompletion);

        /* Updating the result (image next to text input) */
        Optimize.OptimizeResults.updateResult(result, field);

        /* If this is an active field then displaying suggestions */
        if (Optimize.OptimizeResults.isActiveField(field)) {
            Optimize.OptimizeResults.displaySuggestions();
        }

        Optimize.OptimizeResults._isDirty = true;
    }
}

Optimize.OptimizeResults.validateCurrentKey = function(e) {
    /// <summary>Validates currently pressed key.</summary>
    /// <param name="e">Event object.</param>

    if (e) {
        if (e.keyCode == 13) {
            e.stop();
        }
    }
}

Optimize.OptimizeResults.isActiveField = function(field) {
    /// <summary>Determines whether specified field is active.</summary>
    /// <param name="field">Field to examine.</param>

    var ret = false;
    var activeField = Optimize.OptimizeResults.get_activeField();

    if (field && activeField) {
        ret = field.get_name().toLowerCase() == activeField.get_name().toLowerCase();
    }

    return ret;
}

Optimize.OptimizeResults.updateResult = function(result, field) {
    /// <summary>Updates validation results for the specified field.</summary>
    /// <param name="result">Validation result.</param>
    /// <param name="field">Field to update result for.</param>

    var cssClass = '';
    var fieldMark = $('fieldMark');

    if (!field) {
        field = Optimize.OptimizeResults.get_activeField();
    }

    if (!result && field) {
        result = field.get_validationResult();
    }

    if (field && result && Optimize.OptimizeResults.isActiveField(field)) {
        if (result.status == Optimize.OptimizeResults.OptimizeFieldValidityState.valid) {
            cssClass = 'fa fa-lg fa-check-circle-o color-success';
        } else if (result.status == Optimize.OptimizeResults.OptimizeFieldValidityState.partiallyValid) {
            cssClass = 'md md-lg md-warning color-warning';
        } else {
            cssClass = 'fa fa-lg fa-times-circle-o color-danger';
        }
        
        fieldMark.className = cssClass;
    }
}

Optimize.OptimizeResults.formatMessage = function(validationResult, field) {
    /// <summary>Composes validation message.</summary>
    /// <param name="validationResult">Validation result.</param>
    /// <param name="field">Field to compose message for.</param>

    var ret = '';
    var msg = null;
    var characteristic = null;
    var phrase = document.getElementById('TargetPhrase').value


    if (validationResult && field) {
        characteristic = validationResult.get_characteristic();

        if (characteristic) {
            msg = document.getElementById('Message_' + characteristic.get_name() + '_' + validationResult.get_option());
            if (msg) {
                ret = msg.innerHTML;

                ret = ret.replace(/%Field%/gi, Optimize.StringHelpers.wrap(field.get_friendlyName(), 'i'));
                ret = ret.replace(/%Pattern%/gi, Optimize.StringHelpers.wrap(field.get_pattern(), 'i'));
                ret = ret.replace(/%MinimumValue%/gi, Optimize.StringHelpers.wrap(characteristic.get_minimumValue(), 'i'));
                ret = ret.replace(/%MaximumValue%/gi, Optimize.StringHelpers.wrap(characteristic.get_maximumValue(), 'i'));
                ret = ret.replace(/%Value%/gi, Optimize.StringHelpers.wrap(characteristic.get_lastValue(), 'i'));
                ret = ret.replace(/%ValueDelta%/gi, Optimize.StringHelpers.wrap(characteristic.get_lastValueDelta(), 'i'));
                ret = ret.replace(/%Phrase%/gi, Optimize.StringHelpers.wrap(phrase, '&laquo;', '&raquo;'));
            }
        }
    }

    return ret;
}

Optimize.OptimizeResults.displaySuggestions = function() {
    /// <summary>Displays suggestions for the currently active field.</summary>

    var messages = [];
    var result = null;
    var success = true;
    var suggestion = null;
    var field = Optimize.OptimizeResults.get_activeField();
    var container = document.getElementById('lstSuggestion');

    while (container.firstChild) {
        container.removeChild(container.firstChild);
    }

    if (field) {
        result = field.get_validationResult();
        if (result && result.status != Optimize.OptimizeResults.OptimizeFieldValidityState.valid) {
            success = false;

            for (var i = 0; i < result.results.length; i++) {
                messages[messages.length] = Optimize.OptimizeResults.formatMessage(result.results[i], field);
            }

            for (var i = 0; i < messages.length; i++) {
                if (messages[i].length > 0) {
                    suggestion = document.createElement('li');
                    suggestion.innerHTML = messages[i];
                    container.appendChild(suggestion);
                }
            }
        }
    }

    container.style.display = (success ? 'none' : '');
    document.getElementById('divFullyOptimized').style.display = (success ? '' : 'none');
}

Optimize.OptimizeResults.initialize = function() {
    /// <summary>Performs initialization stage.</summary>

    var field = null;
    var formValues = Optimize.readFromEditForm();

    if (formValues && formValues.length > 0) {
        for (var i = 0; i < formValues.length; i++) {
            field = Optimize.OptimizeResults.OptimizeField.getFieldByName(formValues[i].name);

            if (field) {
                field.set_value(formValues[i].value);
            }
        }
    }

    Optimize.OptimizeResults.set_activeField('Title');

    for (var i = 0; i < Optimize.OptimizeResults._fields.length; i++) {
        if (Optimize.OptimizeResults._fields[i] != null) {
            Optimize.OptimizeResults.validateField(Optimize.OptimizeResults._fields[i].get_value(),
            Optimize.OptimizeResults._fields[i], false);
        }
    }

    Optimize.OptimizeResults.setNavigationIsEnabled('Next', true);
    Optimize.OptimizeResults.setNavigationIsEnabled('Previous', false);

    Optimize.OptimizeResults.calculateCompletionMaximum();
    Optimize.OptimizeResults.updateCompletion();

    Optimize.OptimizeResults._isDirty = false;

    $('txField').observe('keypress', Optimize.OptimizeResults.validateCurrentKey);
}

Optimize.OptimizeResults.calculateCompletionMaximum = function() {
    /// <summary>Calculates the maximum number of conditions that should be satisfied before user riches 100% completion.</summary>

    var name = '';
    var total = 0;
    var field = null;
    var characteristics = [];

    for (var i = 0; i < Optimize.OptimizeResults._fields.length; i++) {
        field = Optimize.OptimizeResults._fields[i];
        characteristics = field.get_characteristics();

        for (var j = 0; j < characteristics.length; j++) {
            name = characteristics[j].get_name().toLowerCase();

            if (name == 'presence') {
                total += 4;
            } else if (name == 'prominence') {
                total += 3;
            } else {
                total += 1;
            }
        }
    }

    Optimize.OptimizeResults._completionMaximumCalculated = total;
}

Optimize.OptimizeResults.calculateCompletion = function() {
    /// <summary>Calculates the current number of conditions that are satisfied.</summary>

    var ret = 0;
    var name = '';
    var total = 0;
    var result = null;
    var characteristic = [];

    for (var i = 0; i < Optimize.OptimizeResults._fields.length; i++) {
        result = Optimize.OptimizeResults._fields[i].get_validationResult();

        if (result.status != Optimize.OptimizeResults.OptimizeFieldValidityState.valid) {
            for (var j = 0; j < result.results.length; j++) {
                if (!result.results[j].get_isValid()) {
                    characteristic = result.results[j].get_characteristic();
                    name = characteristic.get_name().toLowerCase();

                    if (name == 'presence') {
                        total += 9;
                        break;
                    } else if (name == 'prominence') {
                        total += 4;
                        break;
                    } else {
                        total += 1;
                    }
                }
            }
        }
    }

    ret = Optimize.OptimizeResults._completionMaximumCalculated - total;

    return ret;
}

Optimize.OptimizeResults.updateCompletion = function() {
    /// <summary>Updates completion label.</summary>

    var percent = 0;
    var progressContainer = $('divProgress');
    var completion = Optimize.OptimizeResults.calculateCompletion();

    if (Optimize.OptimizeResults._completionMaximumCalculated <= 0) {
        percent = 100;
    } else {
        if (completion >= Optimize.OptimizeResults._completionMaximumCalculated) {
            percent = 100;
        } else if (completion < 0) {
            percent = 0;
        } else {
            percent = parseInt(Math.floor(completion * 100 / Optimize.OptimizeResults._completionMaximumCalculated));
        }
    }

    document.getElementById('spProgress').innerHTML = percent + '%';
}

Optimize.OptimizeResults.addField = function(name, params) {
    /// <summary>Adds new field.</summary>
    /// <param name="name">The system name of the field.</param>
    /// <param name="params">Field parameters.</param>

    if (Optimize.OptimizeResults.getFieldIndex(name) < 0) {
        Optimize.OptimizeResults._fields[Optimize.OptimizeResults._fields.length] =
            new Optimize.OptimizeResults.OptimizeField(name, params);
    }
}

Optimize.OptimizeResults.createCharacteristic = function(name, params) {
    /// <summary>Creates characteristics for the specified field.</summary>
    /// <param name="name">The system name of the field.</param>
    /// <param name="params">Parameters.</param>

    return new Optimize.OptimizeResults.OptimizeFieldCharacteristic(name, params);
}

Optimize.OptimizeResults.getFieldIndex = function(name) {
    /// <summary>Retrieves zero-based index of the specified field.</summary>
    /// <param name="name">The system name of the field.</param>

    var ret = -1;

    if (name) {
        name = name.toLowerCase();
        for (var i = 0; i < Optimize.OptimizeResults._fields.length; i++) {
            if (Optimize.OptimizeResults._fields[i].get_name().toLowerCase() == name) {
                ret = i;
                break;
            }
        }
    }

    return ret;
}

Optimize.OptimizeResults.get_activeField = function() {
    /// <summary>Gets currently active field.</summary>

    return Optimize.OptimizeResults.OptimizeField.getFieldByName(Optimize.OptimizeResults._activeField);
}

Optimize.OptimizeResults.set_activeField = function(name) {
    /// <summary>Sets currently active field.</summary>
    /// <param name="value">System name of the field.</param>

    var index = 0;
    var legend = $$('div.optimize-edit-box legend');
    var previousActive = Optimize.OptimizeResults._activeField;

    if (legend && legend.length > 0) {
        legend = legend[0];
    }

    Optimize.OptimizeResults._activeField = name;

    if (previousActive) {
        $(previousActive + '_Summary').removeClassName('optimize-summary-active');
    }

    $(name + '_Summary').addClassName('optimize-summary-active');
    document.getElementById('txField').value = Optimize.OptimizeResults.get_activeField().get_value();

    if (legend) {
        legend.innerHTML = Optimize.OptimizeResults.get_activeField().get_friendlyName() + '&nbsp';
    }

    Optimize.OptimizeResults.updateResult();
    Optimize.OptimizeResults.displaySuggestions();

    index = Optimize.OptimizeResults.getFieldIndex(Optimize.OptimizeResults.get_activeField().get_name());

    Optimize.OptimizeResults.setNavigationIsEnabled('Previous', (index > 0));
    Optimize.OptimizeResults.setNavigationIsEnabled('Next', (index < Optimize.OptimizeResults._fields.length - 1));
}

Optimize.OptimizeResults.CharacteristicValidationResult = function(characteristic, isValid, option) {
    /// <summary>Represents a validation result of a single field characteristic.</summary>
    /// <param name="characteristic">Associated characteristic.</param>
    /// <param name="isValid">Value indicating whether condition is satisfied.</param>
    /// <param name="option">Message option (used to distinguish between different sub-types of the common message type).</param>

    this._characteristic = characteristic;
    this._isValid = isValid;
    this._option = option;
}

Optimize.OptimizeResults.CharacteristicValidationResult.prototype.get_characteristic = function() {
    /// <summary>Gets the associated characteristic.</summary>

    return this._characteristic;
}

Optimize.OptimizeResults.CharacteristicValidationResult.prototype.get_option = function() {
    /// <summary>Gets the message option (used to distinguish between different sub-types of the common message type).</summary>

    return this._option;
}

Optimize.OptimizeResults.CharacteristicValidationResult.prototype.get_isValid = function() {
    /// <summary>Gets the value indicating whether condition is satisfied.</summary>

    return this._isValid;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic = function(name, params) {
    /// <summary>Represents a single field characteristic.</summary>
    /// <param name="name">System name of the characteristic.</param>
    /// <param name="params">Object parameters.</param>

    if (!params) {
        params = {};
    }

    this._name = name;
    this._minimumValue = params.minimumValue;
    this._maximumValue = params.maximumValue;
    this._transformCallback = params.transformCallback;
    this._lastValue = 0;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_name = function() {
    /// <summary>Gets the system name of the characteristic.</summary>

    return this._name;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.set_name = function(value) {
    /// <summary>Sets the system name of the characteristic.</summary>
    /// <param name="value">System name of the characteristic.</param>

    this._name = value;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_minimumValue = function() {
    /// <summary>Gets the minimum value for this characteristic.</summary>

    return this._minimumValue;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.set_minimumValue = function(value) {
    /// <summary>Sets the minimum value for this characteristic.</summary>
    /// <param name="value">The minimum value for this characteristic.</param>

    this._minumumValue = value;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_maximumValue = function() {
    /// <summary>Gets the maximum value for this characteristic.</summary>

    return this._maximumValue;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.set_maximumValue = function(value) {
    /// <summary>Sets the maximum value for this characteristic.</summary>
    /// <param name="value">The maximum value for this characteristic.</param>

    this._maximumValue = value;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_lastValue = function() {
    /// <summary>Gets the last value associated with this characteristic.</summary>

    return this._lastValue;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.set_lastValue = function(value) {
    /// <summary>Sets the last value associated with this characteristic.</summary>
    /// <param name="value">The last value associated with this characteristic.</param>

    this._lastValue = value;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_blocksNext = function() {
    /// <summary>Gets value indicating whether this characteristic blocks any other checks if it's invalid.</summary>

    var name = this.get_name().toLowerCase();

    return name == 'presence' || name == 'prominence';
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.get_lastValueDelta = function() {
    /// <summary>Gets the delta between the last value associated with this characteristic and the nearest validity bound.</summary>

    var ret = 0;

    if (this.get_maximumValue() && this.get_lastValue() > this.get_maximumValue()) {
        ret = this.get_lastValue() - this.get_maximumValue();
    } else if (this.get_minimumValue() && this.get_lastValue() < this.get_minimumValue()) {
        ret = this.get_minimumValue() - this.get_lastValue();
    }

    return ret;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.transformValue = function(value, phrase) {
    /// <summary>Transforms the string representation of the specified phrase into the numeric value representation which is accepted by validation procedure.</summary>
    /// <param name="value">Field value.</param>
    /// <param name="phrase">Target phrase.</param>

    var ret = 0;

    if (this._transformCallback) {
        ret = this._transformCallback(value, phrase);
    }

    return ret;
}

Optimize.OptimizeResults.OptimizeFieldCharacteristic.prototype.isValid = function(value, phrase, fieldName) {
    /// <summary>Determines whether specified characteristic is valid.</summary>
    /// <param name="value">Field value.</param>
    /// <param name="phrase">Target phrase.</param>
    /// <param name="fieldName">Name of the field.</param>

    var option = '';
    var isValid = true;
    var val = this.transformValue(value, phrase);

    this.set_lastValue(val);

    /* Checking only prasence for the "URL" field - this already gives a good result */
    if (fieldName && fieldName.toLowerCase() == 'url') {
        if (this.get_name().toLowerCase() == 'presence') {
            isValid = Optimize.StringHelpers.getFrequency(value, phrase) > 0;
            if (!isValid) {
                option = 'More';
            }
        } 
    } else {
        if (typeof (this.get_minimumValue()) != 'undefined') {
            isValid = val >= this.get_minimumValue();
            option = 'More';
        }

        if (isValid && typeof (this.get_maximumValue()) != 'undefined') {
            isValid = val <= this.get_maximumValue();
            option = 'Less';
        }
    }

    if (isValid) {
        option = '';
    }

    return new Optimize.OptimizeResults.CharacteristicValidationResult(this, isValid, option);
}

Optimize.OptimizeResults.OptimizeField = function(name, params) {
    /// <summary>Represents and optimize field.</summary>
    /// <param name="name">System name of the field.</param>
    /// <param name="params">Parameters.</param>

    if (!params) {
        params = {};
    }

    this._name = name;
    this._friendlyName = params.friendlyName;
    this._value = params.value;
    this._pattern = params.pattern;
    this._characteristics = params.characteristics;
    this._validationResult = null;
    
    if (!this._characteristics) {
        this._characteristics = [];
    }
}

Optimize.OptimizeResults.OptimizeField.getFieldByName = function(name) {
    /// <summary>Retrieves field by its system name.</summary>
    /// <param name="name">System name of the field.</param>

    var index = Optimize.OptimizeResults.getFieldIndex(name);
    return (index >= 0 ? Optimize.OptimizeResults._fields[index] : null);
}

Optimize.OptimizeResults.OptimizeField.prototype.addCharacteristic = function(characteristic) {
    /// <summary>Adds new characteristic to the current field.</summary>
    /// <param name="characteristic">Characteristic to add.</param>

    if (characteristic) {
        if (!this._characteristics) {
            this._characteristics = [];
        }

        this._characteristics[this._characteristics.length] = characteristic;
    }
}

Optimize.OptimizeResults.OptimizeField.prototype.validate = function(phrase, updateCompletion) {
    /// <summary>Performs validation of the specified field.</summary>
    /// <param name="phrase">Phrase to validate field against.</param>
    /// <param name="updateCompletion">Value indicating whether to update completion label.</param>

    var result = null;
    var validCharacteristics = 0;
    var isPartiallyValid = true;

    var ret = { status: Optimize.OptimizeResults.OptimizeFieldValidityState.invalid, results: [] };

    for (var i = 0; i < this.get_characteristics().length; i++) {
        result = this.get_characteristics()[i].isValid(this.get_value(), phrase, this.get_name());

        ret.results[ret.results.length] = result;

        if (result.get_isValid()) {
            validCharacteristics++;
        }

        if (!result.get_isValid()) {
            /* Phrase MUST present as well as MUST be in the begining of the field text. Otherwise the field is invalid. */
            if (result.get_characteristic().get_name().toLowerCase() == 'presence' ||
                result.get_characteristic().get_name().toLowerCase() == 'prominence') {

                isPartiallyValid = false;
            }

            if (result.get_characteristic().get_blocksNext()) {
                break;
            }
        }
    }

    if (validCharacteristics == this.get_characteristics().length) {
        ret.status = Optimize.OptimizeResults.OptimizeFieldValidityState.valid;
    } else if (isPartiallyValid) {
        ret.status = Optimize.OptimizeResults.OptimizeFieldValidityState.partiallyValid;
    }

    this.updateResult(ret);

    if (updateCompletion || typeof(updateCompletion) == 'undefined') {
        Optimize.OptimizeResults.updateCompletion();
    }

    return ret;
}

Optimize.OptimizeResults.OptimizeField.prototype.updateResult = function(result) {
    /// <summary>Updates validation result for the current field.</summary>
    /// <param name="result">Validation result.</param>
    
    var cssClass = '';

    if (result) {
        if (result.status == Optimize.OptimizeResults.OptimizeFieldValidityState.valid) {
            cssClass = 'fa fa-lg fa-check-circle-o color-success';
        } else if (result.status == Optimize.OptimizeResults.OptimizeFieldValidityState.partiallyValid) {
            cssClass = 'md md-lg md-warning color-warning';
        } else {
            cssClass = 'fa fa-lg fa-times-circle-o color-danger';
        }

        document.getElementById(this.get_name() + '_ResultMark').className = cssClass;
    }

    this.set_validationResult(result);
}

Optimize.OptimizeResults.OptimizeField.prototype.get_name = function() {
    /// <summary>Gets the system name of the field.</summary>

    return this._name;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_name = function(value) {
    /// <summary>Sets the system name of the field.</summary>
    /// <param name="value">The system name of the field.</param>
    
    this._name = value;
}

Optimize.OptimizeResults.OptimizeField.prototype.get_friendlyName = function() {
    /// <summary>Gets the user-friendly name of the field.</summary>

    return this._friendlyName;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_friendlyName = function(value) {
    /// <summary>Sets the user-friendly name of the field.</summary>
    /// <param name="value">The user-friendly name of the field.</param>

    this._friendlyName = value;
}

Optimize.OptimizeResults.OptimizeField.prototype.get_value = function() {
    /// <summary>Gets the field value.</summary>

    return this._value;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_value = function(value) {
    /// <summary>Sets the field value.</summary>
    /// <param name="value">Field value.</param>

    var processedValue = '';
    var presentation = document.getElementById(this.get_name() + '_ValuePresentation');

    this._value = value;

    processedValue = value;
    if (processedValue) {
        processedValue = processedValue.replace(/</g, '&lt;');
        processedValue = processedValue.replace(/>/g, '&gt;');
    }

    presentation.innerHTML = processedValue;
    
    if (value.length == 0) {
        presentation.innerHTML = document.getElementById('spNoContent').innerHTML;
    }

    document.getElementById(this.get_name() + '_Value').value = value;
}

Optimize.OptimizeResults.OptimizeField.prototype.get_pattern = function() {
    /// <summary>Gets the field pattern.</summary>

    return this._pattern;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_pattern = function(value) {
    /// <summary>Sets the field pattern.</summary>
    /// <param name="value">The field pattern.</param>

    this._pattern = value;
}

Optimize.OptimizeResults.OptimizeField.prototype.get_characteristics = function() {
    /// <summary>Gets characteristics associated with this field.</summary>

    return this._characteristics;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_characteristics = function(value) {
    /// <summary>Sets characteristics associated with this field.</summary>
    /// <param name="value">Characteristics associated with this field.</param>

    this._characteristics = value;
}

Optimize.OptimizeResults.OptimizeField.prototype.get_validationResult = function() {
    /// <summary>Gets the last validation result.</summary>

    return this._validationResult;
}

Optimize.OptimizeResults.OptimizeField.prototype.set_validationResult = function(value) {
    /// <summary>Sets the last validation result.</summary>
    /// <param name="value">The last validation result.</param>

    this._validationResult = value;
}