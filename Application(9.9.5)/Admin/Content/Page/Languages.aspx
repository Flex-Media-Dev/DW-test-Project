<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Languages.aspx.vb" Inherits="Dynamicweb.Admin.PagesLanguages" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<dw:ControlResources runat="server">
	</dw:ControlResources>
	<style type="text/css">
	.rightCorner
	{
		position:fixed;
		top:-1px;
		right:0px;
	}
	</style>
	<!--[if gt IE 7]>
	<style type="text/css">
	.rightCorner
	{
		position:fixed;
		top:0px;
		right:0px;
	}
	</style>
	<![endif]--> 
	<script type="text/javascript">
		function redoSelected() {
			var rows = List.getSelectedRows("languages");
			var onareas = "";
			for (var i = 0; i < rows.length; i++) {
				if (onareas == "") {
					onareas += rows[i].getAttribute("itemid");
				} else {
					onareas += "," + rows[i].getAttribute("itemid");
				}
			}
			if(onareas.length>0){
				redo(onareas);
			}
		}
		function redo(onAreaID) {
			if (confirm('<%=Dynamicweb.SystemTools.Translate.Translate("Gendan") %>?')) {

				var o = new overlay("copyWait");
				o.show();
				//alert("Languages.aspx?PageID=<%=Dynamicweb.Context.Current.Request("PageID")%>&onAreaID=" + onAreaID);

				location = "Languages.aspx?PageID=<%=Dynamicweb.Context.Current.Request("PageID")%>&onAreaID=" + onAreaID;
			}
		}
	</script>

</head>
<body>
	<form id="form1" runat="server">
		<dw:List ID="languages" runat="server" Title="Sprog" PageSize="100" AllowMultiSelect="true">
			<Columns>
				<dw:ListColumn ID="ListColumn1" runat="server" Name="" Width="25"></dw:ListColumn>
				<dw:ListColumn ID="ListColumn2" runat="server" Name="Sprog" Width="0"></dw:ListColumn>
			</Columns>
		</dw:List>
		<span class="rightCorner">
		<dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowStart="false">
			<dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="PlusSquare" Text="Gendan valgte" OnClientClick="redoSelected();">
			</dw:ToolbarButton>
		</dw:Toolbar>
		</span>
		<dw:Overlay ID="copyWait" runat="server" Message="" ShowWaitAnimation="True">
			<dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Kopierer" />
			...
		</dw:Overlay>
	</form>
</body>
</html>
