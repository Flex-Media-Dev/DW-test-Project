<%@ Page ValidateRequest="false" Language="vb" AutoEventWireup="false" CodeBehind="Simple.aspx.vb" Inherits="Dynamicweb.Admin.Simple" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
	<dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeScriptaculous="false">
	</dw:ControlResources>
	<title></title>
	<style type="text/css">
		#editorContainer
		{
			position:fixed;
			bottom:0px;
			top:46px;
			right:0px;
			left:0px;
			padding:3px;
		}
		#Text
		{
			position: relative;
			border-style: none;
			font-family: Courier New;
			font-size:13px;
			height:100%;
			width: 100%;
			overflow:scroll;
			white-space:pre;
		}
		html, body, form
		{
			width: 100%;
			height: 100%;
			overflow:hidden;
		}

        .noAccessContainer
        {
	        width: 500px;
	        margin: 0px auto;
	        margin-top: 250px;
	        border: 1px solid #c3c3c3;
        }

        .noAccessContainer .noAccessHeading
        {
	        padding: 5px;
	        font-weight: bold;
	        background-color: #ffcfcf;
	        border-bottom: 1px solid #c3c3c3;
        }

        .noAccessContainer .noAccessText
        {
	        padding: 5px;
	        padding-top: 15px;
	        text-align: center;
	        padding-bottom: 15px;
	        background-color: #FFFFFF;
        }
	</style>
	<script type="text/javascript">
	    /* Save file operation */
	    function save(close) {
	        if (Text.value !== "") {
	            if (close) {
	                document.getElementById("close").value = "true";
	            }
	            document.forms[0].submit();
	            if (close) {
	                parent.reloadPage(true);
	            }
	        }
	    }

        /* Switch to extended editor */
	    function switchView() {
	        document.getElementById('SwitchToExtended').value = 'true';
	        save(false);
	    }
	    try {
	        if (window.opener && window.opener.frames && window.opener.frames["FileManagerListFolder"]) {
	            window.opener.frames.FileManagerListFolder.location.reload();
	        }
	    }
	    catch (e) { }
	    
	    /* SaveAs operation */
	    function saveAs() {
	        var fileName = $('File').value;
	        var dropdownControlId = "FM_" + $('WindowCallerOriginalID').value;
	        var templatePathControlId = $('WindowCallerOriginalID').value + "_path";
	        var templatePath = "/Files/" + $('Folder').value + "/" + fileName;
	        var paragraphEditModule = window.opener;
	        
	        /* Check file for existence in dropdown */
	        var fileExists = paragraphEditModule.checkOption(fileName, dropdownControlId);

	        if (fileExists == true) {
	            var ret = confirm(document.getElementById('mFileExists').innerHTML);
	            if (ret == true) {
	                paragraphEditModule.$(templatePathControlId).value = templatePath;
	                paragraphEditModule.selectNewOption(fileName, dropdownControlId, true);
	                save(true);
	            }
	        } else {
                paragraphEditModule.$(templatePathControlId).value = templatePath;
                paragraphEditModule.selectNewOption(fileName, dropdownControlId, false);
	            save(true);
	        }
	    }

	</script>
</head>
<body>
	    <form id="MainForm" runat="server" enableviewstate="false">
	    <input type="hidden" name="close" id="close" value="" />
	    <input type="hidden" name="SwitchToExtended" id="SwitchToExtended" value="false" />
	    <input type="hidden" name="WindowCallerOriginalID" id="WindowCallerOriginalID" runat="server" />
        <input type="hidden" name="InitialFileName" id="InitialFileName" runat="server" />
        <input type="hidden" name="InitialFileDir" id="InitialFileDir" runat="server" />

		<div>
			<dw:Toolbar ID="Toolbar1" runat="server">
				<dw:ToolbarButton ID="ToolbarButton1" KeyboardShortcut="ctrl+s" runat="server" Divide="None" Icon="Save" Text="Gem" OnClientClick="save(false);">
				</dw:ToolbarButton>
				<dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="Save" Text="Gem og luk" OnClientClick="save(true);">
				</dw:ToolbarButton>
				<dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="None" Icon="Save" Text="Gem som" OnClientClick="dialog.show('SaveAsDialog');">
				</dw:ToolbarButton>
				<dw:ToolbarButton ID="cmdExtendedEditor" Icon="PlusSquare" Divide="Before" Text="Extended editor" OnClientClick="switchView();" runat="server" />
			</dw:Toolbar>
			<h2 class="subtitle">
				<%=Dynamicweb.Context.Current.Request("Folder")%>/<%=Dynamicweb.Context.Current.Request("File")%>
			</h2>
		</div>
		<div id="editorContainer">
		<textarea runat="server" id="Text" name="Text" cols="2500" rows="30" enableviewstate="false"></textarea>
		</div>
		<dw:Dialog ID="SaveAsDialog" runat="server" Title="Gem som" CancelAction="dialog.hide('SaveAsDialog');" ShowCancelButton="true" ShowOkButton="true" OkAction="saveAs();">
			<table>
			<tr>
				<td><dw:TranslateLabel id="lbDirectoryLabel" runat="server" Text="Bibliotek" /></td>
				<td><input type="text" name="Folder" value="<%=Dynamicweb.Context.Current.Request("Folder")%>" id="Folder" class="std" readonly="readonly" /></td>
			</tr>
			<tr>
				<td><dw:TranslateLabel id="lbFileLabel" runat="server" Text="File" /></td>
				<td><input type="text" name="File" value="<%=Dynamicweb.Context.Current.Request("File")%>" id="File" class="std" /></td>
			</tr>
			<tr>
				<td></td>
				<td>
				    <input type="checkbox" id="IsUnicodeChkBox" runat="server" value="True" />
				    <asp:Label ID="lbCheckbox" Text="Unicode" AssociatedControlID="IsUnicodeChkBox" runat="server" />
				</td>
			</tr>
			</table>
		</dw:Dialog>
	</form>
    <div id="noAccessWarning" class="editing-area">
		<div id="rowNoAccess" runat="server" visible="false">
		    <div class="noAccessContainer">
		        <div class="noAccessHeading">
		            <dw:TranslateLabel ID="lbAccessDenied" Text="Adgang_nægtet!" runat="server" />
		        </div>
		        <div class="noAccessText">
		            <dw:TranslateLabel ID="lbAccessDeniedText" Text="You do not have required permissions to edit this file." runat="server" />
		        </div>
		    </div>
		</div>
	</div>

    <!-- Messages -->
    <span id="mFileExists" style="display: none"><dw:TranslateLabel id="lbFileExists" Text="Filen_findes_i_forvejen" runat="server" />.<dw:TranslateLabel id="lbOverwrite" Text="Overskriv?" runat="server" /></span>
    <!-- Messages -->

</body>
</html>

<%  Translate.GetEditOnlineScript() %>