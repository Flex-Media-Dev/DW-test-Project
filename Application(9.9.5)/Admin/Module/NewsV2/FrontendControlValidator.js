function IsNotEmpty(field, validator)
{
    SetValidator(validator, GetStrValue(field).length == 0);
}

function IsEMailAddr(field, validator) 
{
    var re = /([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})/;
    var val = GetStrValue(field);
    SetValidator(validator, val.length > 0 && !val.match(re));
}

function ArePasswordsEqual(field, validator) 
{
    SetValidator(validator, GetStrValue(field) != GetStrValue(field + "2"));
}

function IsInteger(field, validator)
{
    var val = GetStrValue(field);
    var isnum = val.length = 0 || (!isNaN(val) && Math.round(val) == val);
    SetValidator(validator, !isnum);
}

function IsDecimal(field, validator)
{
    var val = GetStrValue(field);
    var isnum = val.length = 0 || !isNaN(val);
    SetValidator(validator, !isnum);
}

function GetStrValue(name)
{
    var elem = document.getElementById(name);
    return elem ? elem.value : "";
}

function SetValidator(name, visible)
{
    var validator = document.getElementById(name);
    if (validator)
        validator.style.display = visible ? "" : "none";
    SetResult(!visible);
}

function SetResult(flag)
{
    if (typeof(__isFormValid) != "undefined")
        __isFormValid = __isFormValid && flag;
}

function IsRegExp(field, validator, re) 
{
    var val = GetStrValue(field);
    SetValidator(validator, val.length > 0 && !val.match(re));
}

function HideIncorrectErrorForSpamValidator(validator) 
{ 
	SetValidator(validator, false);
}

/* 
    Checks whether specified LinkManager control contains any input 
    and activates specified validator if not 
*/
function checkLinkSpecified(name, validator) {
    SetValidator(validator, GetStrValue(name).length == 0);
}

/* 
    Checks whether specified FileManager control contains any input 
    and activates specified validator if not 
*/
function checkFileSpecified(name, validator) {
    var lnkDelete = document.getElementById('delete_' + name);
    var hideValidator = lnkDelete != null;

    if (!hideValidator)
        hideValidator = (GetStrValue(name).length > 0);

    SetValidator(validator, !hideValidator);
}

