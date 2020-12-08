function cookieclick() {
    if (document.login.usecookiea && document.login.usecookieb) {
        if (document.login.usecookiea.checked) {
            document.login.usecookieb.checked = true;
            document.login.AutoLogin.checked = true;
        } else {
            document.login.usecookieb.checked = false;
            document.login.AutoLogin.checked = false;
            document.login.AutoLogin.disabled = true;
        }
        if (document.login.usecookiea.checked && document.login.usecookieb.checked) {
            document.login.AutoLogin.disabled = false;
        }
    }
}

function nescafecheck(){
	if (document.login.usecookiea.checked==false){
		document.login.usecookiea.click();
	}
	if (document.login.usecookiea.checked && document.login.usecookieb.checked){
		document.login.AutoLogin.disabled = false;
	}
	else{
		document.login.AutoLogin.checked = false;
		document.login.AutoLogin.disabled = true;
	}
}

function init() {
    document.getElementById("cookieswarning").hidden = navigator.cookieEnabled;

	if (!document.getElementById("login").usecookiea) {
		return;
	}
	document.login.usecookieb.disabled = false;
	if (document.login.usecookiea.checked){
		//document.login.usecookieb.disabled = false;
	}
	if (document.login.usecookieb.checked){
		document.login.AutoLogin.disabled = false;
	}
}

function changePage() {
	if (self.parent.frames.length != 0){
		self.parent.location=document.location;
	}
}
setTimeout ("changePage()", 10);

function start(){
	if (document.login.Username.value == "") {
	    document.login.Username.focus();
	    document.login.Username.select();
	}else{
	    document.login.Password.focus();
	    document.login.Password.select();
    }
}

function ajaxSendRequest(data, callbackHandler) {
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange = callbackHandler;
	xmlhttp.open("POST", "/Admin/Access/Access_User_Login.aspx", true);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	xmlhttp.send(data);
}

function handleTokenGenerationStep() {
	var xmlhttp = arguments[0].target;
	if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		var result = eval("(" + xmlhttp.responseText + ")");

		if (result.Success) {
			document.getElementById("tokenContainer").style.display = "block";
			alert("token set:\n\r" + result.responseText);
		} else {
			document.getElementById("tokenContainer").style.display = "none";
			alert("Failed:\n\r" + result.Exception);
		}
	}
}

function checkInput(FileToHandle){
    var returnVal = true;
    if (use2fa) {
    	var token = document.getElementById("token").value;
    	if (token.length == 5) {
    		alert(token.length);
    		return;
			//submit
    	} else {
    		//try setting token
    		var username = document.getElementById("Username").value;
    		var password = document.getElementById("Password").value;
    		var postData = "username=" + username + "&password" + password;
    		alert('ajax send....' + postData);
    		ajaxSendRequest(postData, handleTokenGenerationStep);
    		
    		return false;
    	}
    }
    cookieclick();

    if (document.login.Username.value == "") {
	    alert(SpecifyUsernameText);
	    showWarning(MissingText);
		document.login.Username.focus();
		returnVal = false;
		return;
	}
	if (document.login.Password.value == ""){
	    alert(SpecifyPasswordText);
	    showWarning(MissingText);
		document.login.Password.focus();
		returnVal = false;
		return;
	}

	document.login.action = FileToHandle;
	document.getElementById("loginBtn").disabled = true;
	document.getElementById("loginBtn").className = document.getElementById("loginBtn").className + " disabled"
    //document.getElementById("loginBtn").style.display = "none";
	document.getElementById("loginBtn").innerText = "";
	document.getElementById("loginBtn").innerHTML = waitMessage;
	document.getElementById("waitingPlaceholder").style.display = "inline";

	if(navigator.userAgent.indexOf("MSIE", 0)>0){
		var markup = document.getElementById("waitingPlaceholder").innerHTML;
		document.login.submit();
		document.getElementById("waitingPlaceholder").innerHTML = markup;
	}
	else{
		document.login.submit();
	}
}

function showWarning(msg) {
    document.getElementById("warning").style.display = '';
    document.getElementById("warningMsg").innerHTML = msg;
}

function catchThatEnter2(e){
	var evt = (window.event)?window.event:e;
	if (evt.keyCode == 13){
		document.login.Password.focus();
	}
}

function catchThatEnter(e){
	var evt = (window.event)?window.event:e;
	if (evt.keyCode == 13){
		checkInput('Access_User_login.aspx');
	}
}

function SetFormPath(laid){
	var action = 'Default.aspx';
	action += '?la=' + laid
	if(document.getElementById('area')){
		action += '&area=' + document.getElementById('area').value;
	}
	document.login.action = action;
	document.login.submit();
}