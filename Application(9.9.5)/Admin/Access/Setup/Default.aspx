<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin._Default3" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
	<title>Setup Dynamicweb
	</title>
	<dw:ControlResources ID="ControlResources1" IncludePrototype="false" IncludeScriptaculous="false" runat="server" CombineOutput="false" />
	<link href="../DefaultNewUI.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		html, body {
			overflow: auto;
		}

		body {
			overflow-y: scroll;
		}
		h1{
			margin-top:10px;
		}

		#header {
			overflow: auto;
			width: 100%;
		}

		#logocontainer {
			text-align: right;
			margin-top: 20px;
			margin-bottom: 20px;
			float: right;
		}

		#numbers {
			float: left;
			margin-top: 20px;
			margin-bottom: 20px;
		}

		.number {
			border: 1px solid #a1a1a1;
			width: 30px;
			height: 30px;
			display: inline-block;
			border-radius: 15px;
			font-family: Ubuntu, sans-serif, Arial;
			font-size: 20px;
			font-weight: bold;
			text-indent: 10px;
			line-height: 30px;
			color: #777777;
			margin-left: 5px;
		}

			.number.active {
				background-color: #0085CA;
				color: white;
			}

		.step {
			display: none;
		}

		#step1 {
			display: inherit;
		}

		#box {
			padding-left: 45px;
			padding-right: 45px;
			margin-top: 2%;
			margin-bottom: 2%;
		}

		#boxinner {
			text-align: left;
			width: 750px;
		}

		.buttonContainer {
			text-align: right;
		}

			.buttonContainer .back {
				color: #bfbfbf;
				margin-right: 30px;
			}

		small {
			color: #a1a1a1;
		}

		label > small {
			padding-left: 23px;
		}

		input[type=text], input[type=password] {
			width: 250px;
		}

		#waitingPlaceholder {
			margin-top: 30%;
			margin-bottom: auto;
		}

		#weecommerce {
			padding-left: 22px;
		}

        .step .groupbox {
			padding-left: 0;
		}

	</style>
	<script type="text/javascript">
		function goToStep(stepNum) {
			var url = "/Admin/access/setup/#step" + stepNum;
			history.pushState(stepNum, '', url);
			setStep(stepNum);
		}

		function setStep(stepNum) {
			var maxSteps = 6;
			for (var i = 1; i < maxSteps; i++) {
				document.getElementById('step' + i).style.display = 'none';
			}
			for (var i = 1; i < maxSteps; i++) {
				document.getElementById('stepNum' + i).className = 'number';
				if (i <= stepNum) {
					document.getElementById('stepNum' + i).className = 'number active';
				}
			}
			document.getElementById('step' + stepNum).style.display = 'inherit';

			if (stepNum == maxSteps - 1)
			{
			    endSetup();
			}
		}

		window.addEventListener("popstate", function (e) {
			navigate()
		});

		function navigate() {
			var step = document.location.hash.replace("#step", "");
			if (step > 0) {
				setStep(step);
			} else {
				setStep(1);
			}
		}

		function filesoptions() {
		    const checkedFileTypeEl = document.querySelector(".radio > input[name=filesoption]:checked");
		    if (checkedFileTypeEl && checkedFileTypeEl.value == "map") {
				document.getElementById("filespathrow").style.display = '';
			} else {
				document.getElementById("filespathrow").style.display = 'none';
			}
		}

		function filessetup() {
			if (document.getElementById("hasfiles").value == "True") {
				document.getElementById("filessetupoptionsDone").style.display = "";
				document.getElementById("filessetupoptions").style.display = "none";
				document.getElementById("filesbutton").innerHTML = "Next";
			} else {
				document.getElementById("filessetupoptionsDone").style.display = "none";
				document.getElementById("filessetupoptions").style.display = "";
				document.getElementById("filesbutton").innerHTML = "Create files";
			}
		}

		function dboptions() {
			if (document.getElementById("dbintegrated").checked || document.getElementById("dboptionmanual").checked) {
				document.getElementById("dbusernamerow").style.display = "none";
				document.getElementById("dbpasswordrow").style.display = "none";
			} else {
				document.getElementById("dbusernamerow").style.display = "";
				document.getElementById("dbpasswordrow").style.display = "";
			}

			if (document.getElementById("dboptionazure").checked || document.getElementById("dboptionmanual").checked) {
				document.getElementById("dbintegratedrow").style.display = "none";
			} else {
				document.getElementById("dbintegratedrow").style.display = "";
			}

            /*
			if (document.getElementById("dboptionazure").checked) {
				document.getElementById("dbcreateazuredatabaserow").style.display = "";
			} else {
				document.getElementById("dbcreateazuredatabaserow").style.display = "none";
			}
            */

			if (document.getElementById("dboptionazure").checked) {
				document.getElementById("dbazurehelp").style.display = "";
				document.getElementById("dbsqlhelp").style.display = "none";
			} else {
				document.getElementById("dbazurehelp").style.display = "none";
				document.getElementById("dbsqlhelp").style.display = "";
			}

			if (document.getElementById("dboptionmanual").checked) {
				document.getElementById("dbserverrow").style.display = "none";
				document.getElementById("dbdatabaserow").style.display = "none";
				document.getElementById("dbconnectionstringrow").style.display = "";
			} else {
				document.getElementById("dbserverrow").style.display = "";
				document.getElementById("dbdatabaserow").style.display = "";
				document.getElementById("dbconnectionstringrow").style.display = "none";
			}

		}				

		function getRadioValue(radioButtonElement) {
			for (var i = 0, length = radioButtonElement.length; i < length; i++) {
				if (radioButtonElement[i].checked) {
					return radioButtonElement[i].value;
				}
			}
		}

		function verifypassword() {
			if (document.getElementById("adminpasswordconfirm").value != document.getElementById("adminpassword").value) {
				document.getElementById("adminpasswordconfirm").style.border = "1px solid red";
				document.getElementById("adminpasswordconfirm").style.padding = "2px";
			} else {
				document.getElementById("adminpasswordconfirm").style.border = "";
			}
		}

		function cansubmituser() {
			if (document.getElementById("adminname").value == "") {
				alert("Please specify your name")
				document.getElementById("adminname").select();
				return false;
			}
			if (document.getElementById("adminemail").value == "") {
				alert("Please specify your email")
				document.getElementById("adminemail").select();
				return false;
			}
			if (document.getElementById("adminusername").value == "") {
				alert("Please specify a username")
				document.getElementById("adminusername").select();
				return false;
			}
			if (document.getElementById("adminpassword").value == "") {
				alert("Please specify a password")
				document.getElementById("adminpassword").select();
				return false;
			}
			if (document.getElementById("adminpasswordconfirm").value != document.getElementById("adminpassword").value) {
				document.getElementById("adminpasswordconfirm").style.border = "1px solid red";
				document.getElementById("adminpasswordconfirm").style.padding = "2px";
				alert("Your passwords do not match. Please verify your password.")
				document.getElementById("adminpasswordconfirm").select();
				return false;
			}
			//goToStep(6);
			return true;
		}

		function createUser() {
			if (cansubmituser()) {
				showOverlay("Creating administrator...")
				var postData = buildUserRequest("createadministrator");
				setTimeout(function () {
					ajaxSendRequest(postData, createUserEnd);
				}, 1000);
			}
		}

		function createUserEnd() {
			var xmlhttp = arguments[0].target;
			
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var result = eval("(" + xmlhttp.responseText + ")");
				ol.hide();
				if (result.Success) {
					alert("User created.");
					goToStep(5);
				} else {
					alert("Could not create user :\n\r\n\r" + result.Message);
				}
			}
		}

		function handleFileStep() {
			if (document.getElementById("hasfiles").value != "True") {
				showOverlay("Copying files...")
				var postData = "action=copyfiles";
				const checkedFileTypeEl = document.querySelector(".radio > input[name=filesoption]:checked");
				postData += "&mapToExistingFolder=" + encodeURIComponent(checkedFileTypeEl && checkedFileTypeEl.value == "map");
				postData += "&newsettings=" + encodeURIComponent(document.getElementById("CreateCleanSettings").checked);				
				postData += "&filespath=" + encodeURIComponent(document.getElementById("filespath").value);
				//postData += "&ImpersonationType=3";
				//postData += "&ImpersonationUsername=" + encodeURIComponent(document.getElementById("ImpersonationUsername").value);
				//postData += "&ImpersonationPassword=" + encodeURIComponent(document.getElementById("ImpersonationPassword").value);
				//postData += "&ImpersonationDomain=" + encodeURIComponent(document.getElementById("ImpersonationDomain").value);
				ajaxSendRequest(postData, handleFileStepEnd);
			} else {
				goToStep(3);
			}
		}

		function handleFileStepEnd() {
			var xmlhttp = arguments[0].target;
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var result = eval("(" + xmlhttp.responseText + ")");
				ol.hide();
				if (result.Success) {
				    document.getElementById("hasfiles").value = "True";
                    filessetup();
                    initDbSettings(result.Data);
				    goToStep(3);
				} else {
					alert("Copy files failed:\n\r" + result.Exception);
				}
			}
		}

		function handleDatabaseSetup() {
			if (document.getElementById("hasdatabaseschema").value == "True") {
				document.getElementById("databasesetupoptionsDone").style.display = "";
				document.getElementById("databasesetupoptions").style.display = "none";
				document.getElementById("dbbuttonnext").style.display = "";
				document.getElementById("dbbutton").style.display = "none";
			} else {
				document.getElementById("databasesetupoptionsDone").style.display = "none";
				document.getElementById("databasesetupoptions").style.display = "";
				document.getElementById("dbbuttonnext").style.display = "none";
				document.getElementById("dbbutton").style.display = "";
			}
			document.getElementById("dbpassword").value = document.getElementById("dbpasswordplaceholder").value;
			//databasesetupoptions
        }

        function initDbSettings(data) {
            if (data) {
                if (data.dbserver) {
                    document.getElementById("dbserver").value = data.dbserver;
                }
                if (data.dbdatabase) {
                    document.getElementById("dbdatabase").value = data.dbdatabase;
                }
                if (data.dbusername) {
                    document.getElementById("dbusername").value = data.dbusername;
                }
                document.getElementById("dbintegrated").Checked = data.dbintegrated;
                if (data.dbconnectionstring) {
                    document.getElementById("dbconnectionstring").value = data.dbconnectionstring;
                }
            }
        }

		function verifyDbFields() {
			if (document.getElementById("dboptionmanual").checked) {
				if (document.getElementById("dbconnectionstring").value == "") {
					alert("Please specify connection string");
					document.getElementById("dbconnectionstring").focus();
					return false;
				}
			}
			if (document.getElementById("dbconnectionstring").value == "") {
				if (document.getElementById("dbserver").value == "") {
					alert("Please specify servername");
					document.getElementById("dbserver").focus();
					return false;
				}
				if (document.getElementById("dbdatabase").value == "") {
					alert("Please specify database name");
					document.getElementById("dbdatabase").focus();
					return false;
				}
				if (!document.getElementById("dbintegrated").checked) {
					if (document.getElementById("dbusername").value == "") {
						alert("Please specify username");
						document.getElementById("dbusername").focus();
						return false;
					}
					if (document.getElementById("dbpassword").value == "") {
						alert("Please specify password");
						document.getElementById("dbpassword").focus();
						return false;
					}
				}
			}
			return true;
		}

		function handleDatabaseSetupStep() {		    
			if (!verifyDbFields()) { return }

				if (testDatabaseConnection()) {
					showOverlay("Saving database settings...");
					var postData = buildDatabaseRequest("setdatabasesettings");

					//alert(postData);
					ajaxSendRequest(postData, handleDatabaseSetupStepEnd);
				}

		}

		function handleDatabaseSetupStepEnd() {
			var xmlhttp = arguments[0].target;
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var result = eval("(" + xmlhttp.responseText + ")");

				ol.hide();
				if (result.Success) {
					document.getElementById("hasdatabase").value = "True";
					handleDatabaseSchemaStep();
				} else {
					alert("Saving database settings failed:\n\r\n\r" + result.Message);
				}
			}
		}

		function handleDatabaseSchemaStep() {
			if (document.getElementById("hasdatabaseschema").value != "True") {
				
				showOverlay("Creating database...");
				var postData = buildDatabaseRequest("createschema");

				//alert(postData);
				ajaxSendRequest(postData, handleDatabaseSchemaStepEnd);
				
			} else {
				goToStep(4);
			}
		}

		function handleDatabaseSchemaStepEnd() {
			var xmlhttp = arguments[0].target;
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var result = eval("(" + xmlhttp.responseText + ")");

				ol.hide();
				if (result.Success) {
					document.getElementById("hasdatabaseschema").value = "True";
					handleDatabaseSetup();
				} else {
					alert("Create database failed:\n\r\n\r" + result.Message + "\n\r\n\r" + result.Exception);
				}
			}
		}

		function testDatabaseConnectionClick() {
			if (!verifyDbFields()) { return }
			showOverlay("Testing database connection...");
			setTimeout(function () {
				if (testDatabaseConnection()) {
					document.getElementById("dbconnectiontestresult").innerHTML = "Dynamicweb connected succesfully.";
				} else {
					document.getElementById("dbconnectiontestresult").innerHTML = "Could not connect to database. Error is: " + testResult.Message;
				}
			}, 1500);
		}

		var testResult = null;
		function testDatabaseConnection() {
			showOverlay("Testing database connection...");
			var postData = buildDatabaseRequest("tryconnectdatabase");
			var connectionok = false;
			//alert(postData);

			var xmlhttp = ajaxSendSyncedRequest(postData);
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				var result = eval("(" + xmlhttp.responseText + ")");
				testResult = result;
				ol.hide();
				if (result.Success) {
					connectionok = true;
				}
			}
			if (!connectionok) {
				//alert("Cannot connect to the database. Check connection settings and permissions. Exception:\n\r\n\r" + result.Message);
			}
			return connectionok;
		}

		function endSetup() {
		    var postData = buildDatabaseRequest("endsetup");
		    ajaxSendRequest(postData, function () { });
		}

		function buildDatabaseRequest(action) {
			var postData = "action=" + action;
			postData += "&server=" + encodeURIComponent(document.getElementById("dbserver").value);
			postData += "&database=" + encodeURIComponent(document.getElementById("dbdatabase").value);
			postData += "&integrated=" + encodeURIComponent(document.getElementById("dbintegrated").checked.toString());
			postData += "&azure=" + encodeURIComponent(document.getElementById("dboptionazure").checked.toString());
			postData += "&createazuredatabase=" + encodeURIComponent(document.getElementById("dbcreateazuredatabase").checked.toString());
			postData += "&username=" + encodeURIComponent(document.getElementById("dbusername").value);
			postData += "&password=" + encodeURIComponent(document.getElementById("dbpassword").value);
			postData += "&connectionString=" + encodeURIComponent(document.getElementById("dbconnectionstring").value);
			return postData;
		}

		function buildUserRequest(action) {
			var postData = "action=" + action;
			postData += "&adminname=" + encodeURIComponent(document.getElementById("adminname").value);
			postData += "&adminemail=" + encodeURIComponent(document.getElementById("adminemail").value);
			postData += "&adminusername=" + encodeURIComponent(document.getElementById("adminusername").value);
			postData += "&adminpassword=" + encodeURIComponent(document.getElementById("adminpassword").value);
			return postData;
		}

		function ajaxTest() {
			showOverlay("Just testing...");
			var postData = "action=justtesting";
			ajaxSendRequest(postData, handleFileStepEnd);
		}

		function ajaxSendRequest(data, callbackHandler) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.onreadystatechange = callbackHandler;
			xmlhttp.open("POST", "Default.aspx", true);
			xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
			xmlhttp.send(data);
		}

		function ajaxSendSyncedRequest(data) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("POST", "Default.aspx", false);
			xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
			xmlhttp.send(data);
			return xmlhttp;
		}

		function showOverlay(message) {
			//var ol = new overlay("setupOverlay")
			ol.message(message);
			ol.show();
			//ol.hide();
		}
	</script>
</head>
<body class="area-blue">
    <div class="dw8-container">
	    <form id="setupForm" runat="server" enableviewstate="false">
		    <input type="hidden" name="hasfiles" id="hasfiles" runat="server" />
		    <input type="hidden" name="hasdatabase" id="hasdatabase" runat="server" />
		    <input type="hidden" name="hasdatabaseschema" id="hasdatabaseschema" runat="server" />
            <dwc:CardBody runat="server">
		        <div id="container">
			    <div id="box">
				    <div id="boxinner">
					    <div id="header">
						    <div id="numbers">
							    <span class="number active" id="stepNum1">1</span>
							    <span class="number" id="stepNum2">2</span>
							    <span class="number" id="stepNum3">3</span>
							    <span class="number" id="stepNum4">4</span>
							    <span class="number" id="stepNum5">5</span>							
						    </div>

						    <div id="logocontainer">
							    <img src="../../Resources/img/DW_logo_200.png" style="width: 200px;" alt="Dynamicweb 9" />
						    </div>
					    </div>

					    <div id="step1" class="step">
						    <h1>1. Welcome to Dynamicweb setup guide!
						    </h1>
						    <h2>This guide will help you set up Dynamicweb for the first time.</h2>
						    <ul>
							    <li>Create files repository</li>
							    <li>Setup database</li>							
							    <li>Set administrator password</li>
						    </ul>
						    <p>Read the installation guide at <a href="https://doc.dynamicweb.com/get-started/introduction/installation/installing-dynamicweb" target="_blank">https://doc.dynamicweb.com/</a></p>
						    <div class="buttonContainer"><a class="button orange" href="javascript:goToStep(2);">Start</a></div>
					    </div>

					    <div id="step2" class="step">
						    <h1>2. Create files repository</h1>
						    <div id="filessetupoptionsDone">
							    <h2>Your /Files is set up and ready to use...</h2>
						    </div>
						    <div id="filessetupoptions" class="dw8-container">
							    <h2>This step will help setting up a files repository for storing images, documents and other files.</h2>

                                <dwc:GroupBox Title="Create or attach /Files" runat="server" DoTranslation="False">
                                    <dwc:RadioGroup runat="server" ID="filesoption" Name="filesoption" Label="" DoTranslate="False" Info="" SelectedValue="create" >
                                        <dwc:RadioButton runat="server" id="filesoptioncreate" Label="Create a new /Files folder" FieldValue="create" DoTranslate="False" Info="" OnClick="filesoptions()" />
                                        <dwc:RadioButton runat="server" id="filesoptionmap" Label="Map to an existing /Files folder" FieldValue="map" DoTranslate="False" Info="" OnClick="filesoptions()" />
                                    </dwc:RadioGroup>
							    
                                    <div id="filespathrow">
                                        <dwc:GroupBox Title="" runat="server" DoTranslation="False">
                                            <dwc:InputText runat="server" ID="filespath" Name="" Label="Full path to files"  DoTranslate="False" Info="I.e: c:\projects\dynamicweb\mysolution.dynamicweb-cms.com\files" />
                                            <dwc:CheckBox runat="server" ID="CreateCleanSettings" Label="Use clean configuration" Info="Recomended" Checked="true" Indent="true" />
                                        </dwc:GroupBox>
  <%--                                      <dwc:GroupBox Title="Impersonation Credentials" runat="server" DoTranslation="False">
                                            <dwc:InputText runat="server" ID="ImpersonationUsername" Label="User name" DoTranslate="False" />
                                            <dwc:InputText runat="server" ID="ImpersonationPassword" Label="Password" Password="true" DoTranslate="False" />
                                            <dwc:InputText runat="server" ID="ImpersonationDomain" Label="Domain" DoTranslate="False" />
                                        </dwc:GroupBox>--%>
							        </div>
                                </dwc:GroupBox>
						    </div>

						    <div class="buttonContainer"><a href="javascript:goToStep(1);" class="back">Back</a> <a class="button orange" href="javascript:handleFileStep()" id="filesbutton">Create files</a></div>
					    </div>

					    <div id="step3" class="step">
						    <h1>3. Setup database
						    </h1>
						    <div id="databasesetupoptionsDone">
							    <h2>Your database is set up and ready to use...</h2>
						    </div>
						    <div id="databasesetupoptions">
							    <h2>Set up database to use or install a new Dynamicweb database.</h2>
							    <p>Before you can complete this step, you need a blank database or an existing Dynamicweb database.</p>
							    <p><strong>Choose your database type</strong></p>
							    <div>
								    <label>
									    <input type="radio" name="dboption" id="dboptionsql" value="sql" checked="checked" onchange="dboptions()" />SQL-Server database (2012 or newer)<br />
									    <small>Use this option if you have created a blank database. The setup will create all the tables and data needed.</small></label><br />
								    <label>
									    <input type="radio" name="dboption" id="dboptionazure" value="azure" onchange="dboptions()" />Azure database<br />
									    <small>Use this option if you have created a blank database on Azure. The setup will create all the tables and data needed.</small></label><br />
								    <label>
									    <input type="radio" name="dboption" id="dboptionmanual" value="manual" onchange="dboptions()" />Manually specify connection string<br />
									    <small>Use this option if you want to specify your own connection string (Advanced).</small></label>
							    </div>
							    <p><strong>Connection settings</strong></p>
							    <div>
								    <table>
									    <tr id="dbserverrow">
										    <td style="width: 120px;">Server</td>
										    <td>
											    <input type="text" name="dbserver" id="dbserver" runat="server" />
											    <small id="dbazurehelp">I.e: tcp:w99echxnd1.database.windows.net,1433</small>
											    <small id="dbsqlhelp">I.e: localhost\SQLEXPRESS</small></td>
									    </tr>
									    <tr id="dbdatabaserow">
										    <td>Database</td>
										    <td>
											    <input type="text" name="dbdatabase" id="dbdatabase" runat="server" />
										    </td>
									    </tr>
									    <tr id="dbcreateazuredatabaserow">
										    <td></td>
										    <td>
											    <input type="checkbox" name="dbcreateazuredatabase" id="dbcreateazuredatabase" value="True" checked="checked" runat="server" />
											    <label for="dbcreateazuredatabase">Create database if it does not exist.<br />
                                                    <small>The specified user must have permission to create a database on the server.</small>
											    </label>
										    </td>
									    </tr>
									    <tr id="dbintegratedrow">
										    <td></td>
										    <td>
											    <input type="checkbox" name="dbintegrated" id="dbintegrated" value="True" onchange="dboptions()" runat="server" /><label for="dbintegrated">Integrated mode</label></td>
									    </tr>
									    <tr id="dbusernamerow">
										    <td>Username</td>
										    <td>
											    <input type="text" name="dbusername" id="dbusername" runat="server" /></td>
									    </tr>
									    <tr id="dbpasswordrow">
										    <td>Password</td>
										    <td>
											    <input type="hidden" id="dbpasswordplaceholder" runat="server" />
											    <input type="password" name="dbpassword" id="dbpassword" autocomplete="off" value="setup" runat="server" /></td>
									    </tr>
									    <tr id="dbconnectionstringrow">
										    <td style="width: 120px; vertical-align: text-top;">Connection string</td>
										    <td>
											    <input type="text" name="dbconnectionstring" id="dbconnectionstring" style="width: 500px;" runat="server" /><br />
											    <small>Server=myServerAddress;Database=myDataBase;User Id=myUsername;Password=myPassword;</small></td>
									    </tr>
									    <tr>
										    <td></td>
										    <td><button onclick="testDatabaseConnectionClick();return false;">Test connection</button> <span id="dbconnectiontestresult"></span></td>
									    </tr>
								    </table>
								
							    </div>
						    </div>
						    <div class="buttonContainer"><a href="javascript:goToStep(2);" class="back">Back</a> <a class="button orange" href="javascript:handleDatabaseSetupStep();" id="dbbutton">Install database</a> <a class="button orange" href="javascript:goToStep(4);" id="dbbuttonnext">Continue</a></div>
					    </div>

					    <div id="step4" class="step">
						    <h1>4. Configure administrator
						    </h1>
						    <h2>Specify a username and password for the administrator account.</h2>
						    <p><strong>User information</strong></p>
						    <div>
							    <table>
								    <tr>
									    <td style="width: 120px;">Name</td>
									    <td>
										    <input type="text" name="adminname" id="adminname" /></td>
								    </tr>
								    <tr>
									    <td>Email</td>
									    <td>
										    <input type="text" name="adminemail" id="adminemail" /></td>
								    </tr>
								    <tr>
									    <td>User name</td>
									    <td>
										    <input type="text" name="adminusername" id="adminusername" value="administrator" /></td>
								    </tr>
								    <tr>
									    <td>Password</td>
									    <td>
										    <input type="password" name="adminpassword" id="adminpassword" autocomplete="off" onchange="verifypassword();" /></td>
								    </tr>
								    <tr>
									    <td>Confirm password</td>
									    <td>
										    <input type="password" name="adminpasswordconfirm" id="adminpasswordconfirm" autocomplete="off" onchange="verifypassword();" onkeyup="verifypassword();" /></td>
								    </tr>
							    </table>
						    </div>
						    <div class="buttonContainer"><a href="javascript:goToStep(3);" class="back">Back</a> <a href="javascript:goToStep(5);" class="back">Skip</a> <a class="button orange" onclick="createUser()" id="userbutton">Create administrator</a></div>
					    </div>

					    <div id="step5" class="step">
						    <h1>5. Congratulations! 
						    </h1>
						    <h2>Setup is completed. Your Dynamicweb installation is now setup and ready to make awesome websites and Ecommerce solutions.</h2>
						    <p>You are now ready to go. Click the button to start the administration of Dynamicweb and login with the user just created.</p>
						    <div class="buttonContainer"><a class="button orange" href="/Admin/Access">Go to login</a></div>
					    </div>
				    </div>
			    </div>
		    </div>
            </dwc:CardBody>
	    </form>
    </div>
	<dw:Overlay ID="setupOverlay" Message="wait" runat="server"></dw:Overlay>
	<script>
		if (location.hash != '') {
			navigate()
			//location = "/Admin/access/setup/";
		}
		filesoptions();
		filessetup();
		dboptions();
		handleDatabaseSetup();
		var ol = new overlay("setupOverlay");

	</script>

</body>
</html>
