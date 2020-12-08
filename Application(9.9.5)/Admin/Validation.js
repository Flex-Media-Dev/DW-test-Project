// Validation.js - backend form validation routines.
// Comments written using "jgrousedoc" (http://code.google.com/p/jgrousedoc/).

/**
@function ValidateForm Validates specified form control.
@param {Object} form - form to be submitted.
@param {Object} controlToValidate - form control to be validated.
@param {String} message - an error message to be displayed if validation failed.
@param {Function} onSuccessMethod - a function to be executed if validation successed.
*/
function ValidateForm(form, controlToValidate, message, onSuccessMethod)
{
	if (controlToValidate != null && controlToValidate.value == "")
	{
		alert(message);
		controlToValidate.focus();
	}
	else
	{
		if (onSuccessMethod != null && typeof (onSuccessMethod) == "function") onSuccessMethod();
		if (form != null) form.submit();
	}
}

/**
@function IsControlValid Determines whether form control is valid (has a value).
@param {Object} controlToValidate - form control to be validated.
@param {String} message - an error message to be displayed if validation failed.
@returns Value indicating whether control is valid (has a value).
*/
function IsControlValid(controlToValidate, message)
{
	if (controlToValidate != null && controlToValidate.value == "")
	{
		alert(message);
		controlToValidate.focus();
		return false;
	}
	return true;
}

/**
@function IsSystemNameExist Determines whether specified system-name exists in a system-name array.
@param {Array} existingNamesArray - array to be checked.
@param {String} nameToValidate - element to be found.
@returns Value indicating whether specified system-name exists in a system-name array.
*/
function IsSystemNameExist(existingNamesArray, nameToValidate)
{
	return IsInArray(existingNamesArray, nameToValidate)
}

/**
@function IsInArray Determines whether specified element presents in array.
@param {Array} array - array to be checked.
@param {String} elementToFind - element to be found.
@returns Value indicating whether specified element presents in array.
*/
function IsInArray(array, elementToFind)
{
	for (var i = 0; i < array.length; i ++)
	{
		if (array[i] == elementToFind) return true;
	}
	return false;
}

/**
@function IsButtonTextControlValid Determines whether specified Gui.ButtonText control is valid.
@param {String} controlName - control name to be validated.
@param {Integer} maxChars - maximum characters allowed in "Text" field.
@param {String} message - an error message to be displayed if validation failed.
@returns Value indicating whether specified Gui.ButtonText control is valid.
*/
function IsButtonTextControlValid(controlName, maxChars, message)
{
	var ret = true;
	
	var sep = _get(controlName + "Text");
	if(sep.value.length > 0 && 
		!(ret = (sep.value.length <= maxChars)))
	{
		alert(message);
		
		if(_get(controlName + "2").checked)
			_get(controlName + "1").click();
		sep.focus();
	}
		
	return ret;
}

/**
@function IsEmailValid Determines whether specified e-mail control is valid.
@param {Object} controlToValidate - e-mail control to be validated.
@param {String} message - an error message to be displayed if validation failed.
@returns Value indicating whether specified e-mail control is valid.
*/
function IsEmailValid(controlToValidate, message)
{
	var ret = false;
	var re = /([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})/;
	
	if(controlToValidate)
	{
		ret = !(controlToValidate.value.length > 0);
		if(!ret)
		{
			ret = (controlToValidate.value.match(re) != null);
			if(!ret)
			{
			    if (message != null) {
			        alert(message);
			    }
				controlToValidate.focus();
			}
		}
	}
	
	return ret;
}

/**
@function ChkInt Determines whether specified value is value of integer type.
@param {String} value - control value to be validated.
@returns Value indicating whether specified value is value of integer type.
*/
function ChkInt(value)
{
	var rg = /[^0-9]/gi
	return !rg.test(value);
}

/**
@function $ Retrieves object by it's ID (or Name).
@param {String} id - ID (or Name) of the control.
@returns Control with specified ID (or first control with name attribute specified by "id" parameter).
*/
function _get(id)
{
	var ret = document.getElementById(id);
	
	if(!ret && document.getElementsByName)
	{
		var elements = document.getElementsByName(id);
		if (elements && elements.length > 0)
			ret = elements[0];
	}
	
	return ret;
}