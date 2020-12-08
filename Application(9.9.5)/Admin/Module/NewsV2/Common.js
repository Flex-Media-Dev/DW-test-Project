function SetVisibleById(elmID, visible)
{
    SetVisible(document.getElementById(elmID), visible);
}

function SetVisible(elm, visible)
{
    if (elm) elm.style.display = visible ? "" : "none";
}

function ValidateEmailRegExp(email)
{
	var email = email.replace(" ","");
	var re = new RegExp(/^[\w-\.]{1,}\@([\w-]{1,}\.){1,}[\w]{2,3}$/);
	var ret = re.test(email);
	return ret;
}