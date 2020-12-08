<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Configuration_Edit.aspx.vb"
    Inherits="Dynamicweb.Admin.Configuration_Edit" CodePage="65001" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <script src="/Admin/Validation.js" type="text/javascript"></script>

    <style>
        .filemanager {
            width: 100%;
            display: block;
        }
        table.addInConfigurationTable div.bootstrap-select{
            width: calc(50% + 85px);
        }
    </style>

    <script type="text/javascript">
	    function init(){
	        try {
	            setTimeout("toggleEditorOptions();", 250);
	            setTimeout("addEditorCheckboxChangeEvt('Configuration_Source_1');", 500);
	            setTimeout("addEditorCheckboxChangeEvt('Configuration_Source_2');", 500);
		        parent.document.getElementById("ListUsers").innerHTML = document.body.innerHTML;
            } catch(e) {
            //Nothing
		    }
	    }
	    function addEditorCheckboxChangeEvt(id) {
	        var el = document.getElementById(id);
            if(el){
                el.addEventListener('change', function (event) { toggleEditorOptions(); });
            }
	    }
	    function toggleEditorOptions() {
	        var show = !(document.getElementById("Configuration_Source_2") != null && document.getElementById("Configuration_Source_2").checked);
	        if (document.getElementsByClassName("addInConfigurationTable").length > 1) {
	            var table = document.getElementsByClassName("addInConfigurationTable")[1];	            
	            if (table && table.rows.length > 3) {
	                for (i = 3; i < table.rows.length; i++) {
	                    table.rows[i].style.display = show ? '' : 'none';
	                }	                
	            }
	        }	        
	    }

	    function ValidateThisForm()
	    {
		    var form = parent.document.getElementById("ConfigurationEdit");
		    var controlToValidate = form.elements["name"];
		    ValidateForm(form, controlToValidate,
			    "<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>");
	    }
	
	    var returnURL = '<%=Dynamicweb.Core.Converter.ToString(Dynamicweb.Context.Current.Request("ReturnURL")) %>';
	    function SaveEvent() 
	    {
		    var form = document.getElementById("ConfigurationEdit");
		    form.target = '';
		    form.action = 'Configuration_Edit.aspx?ReturnURL=' + returnURL;
		
		    var controlToValidate = form.elements["name"];
		    ValidateForm(form, controlToValidate, '<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
	    }
	
	    function CancelEvent() 
	    {
	        location = returnURL;
	    }

	    function save(doClose) {
	        var form = document.getElementById("AddinConfigurationEdit");
	        if (doClose) {
	            form.action = 'Configuration_Edit.aspx?doClose=true';
	        }
	        form.submit();
	    }
	    function cancel() {
	        document.location.href = "../../Content/Management/Pages/EditingConfigurationsSettings_cpl.aspx";
	    }
        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.editing.editorconfiguration.providerbased")%>
        }
    </script>
</head>
<body onload="init();" class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server">
        </dwc:BlockHeader>
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbSubTitle" Title="Editor configuration"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <asp:Literal ID="AddinSelectorScripts" runat="server"></asp:Literal>
                <dw:Infobar runat="server" ID="InfoBarErrorMessages" Visible="False">
                </dw:Infobar>
                <form id="AddinConfigurationEdit" method="post" action="Configuration_Edit.aspx" runat="server">
                    <dwc:GroupBox ID="GroupBox1" runat="server" Title="Generel information" GroupWidth="6">                           
                        <input type="hidden" id="editorConfigurationId" runat="server" />
                        <dwc:InputText label="Configuration Name" ID="ProviderConfigurationName" runat="server" />
                    </dwc:GroupBox>
                    <div runat="server" id="AddinBasedEditorConfigurationDiv">
                        <de:AddInSelector runat="server" ID="addinSelector" AddInTypeName="Dynamicweb.Extensibility.TextEditorAddIn" AddInShowNothingSelected="false" />
                    </div>
                    <asp:Literal ID="AddinSelectorLoadScripts" runat="server"></asp:Literal>
                    <br />
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>

    <dwc:ActionBar runat="server">
        <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Text="Save" OnClientClick="save(false);" ShowWait="True" />                
        <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Text="Save and close" OnClientClick="save(true);" ShowWait="True" />
        <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" OnClientClick="cancel()" ShowWait="True" />
    </dwc:ActionBar>

    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
<%
    Translate.GetEditOnlineScript()
%>