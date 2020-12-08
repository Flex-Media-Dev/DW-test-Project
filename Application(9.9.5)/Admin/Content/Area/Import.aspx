<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Import.aspx.vb" Inherits="Dynamicweb.Admin.Import" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head runat="server">
	<title></title>
	<dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" />
	<style type="text/css">
		.wizardHeader
		{
			height: 20px;
			background-color: #fff;
			font-size: 15px;
			color: #003399;
			padding: 15px;
			border-bottom: 1px solid #828790;
		}
		
		.wizardStep
		{
			padding: 15px;
		}
		
		.wizardButton
		{
			float: right;
		}
	</style>

    <script type="text/javascript">

        function importComplete() {
            var areaID = "<%= NewAreaID %>";
            top.left.location = "/Admin/menu.aspx?AreaID=" + areaID;
        }

	</script>

</head>
<body style="background-color: #F0F0F0;">
	<form id="form1" runat="server" style="margin: 0">
		<div class="wizardHeader">
			<dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Import" />
			:
			<dw:TranslateLabel ID="trnsStepLabel" runat="server" Text="Vælg fil" />
		</div>
		<div id="selectFileStep1" runat="server" class="wizardStep">
			<dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Fil" />
			<dw:FileManager ID="Filemanager1" runat="server" Folder="/System" Name="AreaImport" Extensions="xml" />
			<br />
			<dw:Infobar ID="NotValidInfoBar" runat="server" Message="Import file must be XML." Type="Error" Visible="false">
			</dw:Infobar>
			<dw:Infobar ID="NotValidXmlInfoBar" runat="server" Message="The XML could not be loaded." Type="Error" Visible="false">
			</dw:Infobar>
			<div>
				<asp:Button ID="Button1" runat="server" Text="Næste" UseSubmitBehavior="true" CssClass="wizardButton" /></div>
		</div>
		<div id="analyzeFileStep2" runat="server" class="wizardStep" visible="false">
			<input type="hidden" name="AreaImport2" runat="server" id="AreaImport2" />
			<input type="hidden" name="action" runat="server" id="action" value="runImport" />
			<strong>
				<dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Fil" />
			</strong>:
			<img src="/Admin/Images/Ribbon/Icons/Small/document_ok.png" align="middle" />
			<dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Ok" />
			<br />
			<br />
			<strong>
				<dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Area" />
			</strong>:
			<br />
			<asp:Label ID="labelAreaName" runat="server" Text="Label"></asp:Label>
			<br />
			<br />
			<strong>
				<dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Sider" />
			</strong>:
			<asp:Label ID="labelPageCount" runat="server" Text="Label"></asp:Label><br />
			<strong>
				<dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Fejl" />
			</strong>:
			<asp:Label ID="labelErrorCount" runat="server" Text="Label"></asp:Label><br />

			<div>
				<asp:Button ID="btnImport" runat="server" Text="Importér" UseSubmitBehavior="true" CssClass="wizardButton" OnClientClick="var o = new overlay('Importing');o.show();" /></div>
		</div>
		<div id="runImportStep3" runat="server" class="wizardStep" visible="false">
			<asp:Label ID="resultText" runat="server" Text="Label"></asp:Label><br />
			<button onclick="parent.document.forms[0].submit();">
				<dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Luk" />
			</button>
		</div>
		
	</form>

	<dw:Overlay ID="Importing" runat="server" Message="Importerer" ShowWaitAnimation="True">
		</dw:Overlay>
</body>
</html>
