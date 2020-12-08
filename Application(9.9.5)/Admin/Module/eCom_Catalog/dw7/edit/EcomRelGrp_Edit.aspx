<%@ Page Language="vb" AutoEventWireup="false" Codebehind="EcomRelGrp_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomRelGrp_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
  <head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
	<script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript">
        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();
        });

        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteRelation() {
            if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
        }  
    </script>
  </head>
  <body class="area-pink screen-container">
    <div class="card">
	    <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
		    <asp:Literal id="NoRelGrpExistsForLanguageBlock" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Relationsgruppe">
			    <table class="formsTable">
					<tr>
					    <td>
                            <label for="NameStr">
                                <dw:TranslateLabel id="tLabelName" runat="server" Text="Name"></dw:TranslateLabel>
                            </label>
					    </td>
					    <td>
					        <asp:textbox id="NameStr" CssClass="std" runat="server"></asp:textbox>
					        <small class="help-block error" id="errNameStr"></small>
					    </td>
				    </tr>
				</table>
            </dwc:GroupBox>
			<asp:Button id="SaveButton" style="display:none;" runat="server"></asp:Button>
			<asp:Button id="DeleteButton" style="display:none;" runat="server"></asp:Button>
		</form>
	</div>
	<script>
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        activateValidation('Form1');
    </script>
  </body>
</html>