<%@ Page Language="vb" AutoEventWireup="false" Codebehind="ParagraphVersions.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphVersions" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import namespace="System.Data" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>

<html>
<head>
    <title></title>
	<dw:ControlResources runat="server">
	</dw:ControlResources>
	<script type="text/javascript">
		function restore(VersionID) {
			var loc = "ParagraphEdit.aspx?ID=" + document.getElementById("pid").value + "&PageID=" + parent.pageID + "&VersionID=" + VersionID;
			parent.location = loc.toString();
		}
		function compare(VersionID) {
			var loc = "ParagraphCompare.aspx?ID=" + document.getElementById("pid").value + "&PageID=" + parent.pageID + "&VersionID=" + VersionID;
			window.open(loc, "", "width=855,height=550,toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no");
			//parent.location = loc.toString();
		}
		function modalWin(location) {
			if (window.showModalDialog) {
				window.showModalDialog(location, "compare", "dialogWidth:855px;dialogHeight:550px");
			} else {
				window.open(location, 'compare', 'height=855,width=550,toolbar=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,modal=yes');
			}
		} 
	</script>
	</head>
<body>
<form id="form1" runat="server">
	<input type="hidden" name="ParagraphID" runat="server" id="pid" />
	<dw:List ID="Versions" runat="server" Title="Versioner" PageSize="10">
	    <Columns>
		    <dw:ListColumn runat="server" Name="" Width="25" ItemAlign="Center" HeaderAlign="Center">
		    </dw:ListColumn>
		    <dw:ListColumn runat="server" Name="Version" Width="0" ItemAlign="Center" HeaderAlign="Center">
		    </dw:ListColumn>
		    <dw:ListColumn runat="server" Name="Sidst redigeret" Width="0">
		    </dw:ListColumn>
		    <dw:ListColumn ID="ListColumn1" runat="server" Name="Publiceret" Width="0">
		    </dw:ListColumn>
		    <dw:ListColumn ID="ListColumn2" runat="server" Name="Status" Width="0">
		    </dw:ListColumn>
		    <dw:ListColumn ID="ListColumn3" runat="server" Name="Gendan" Width="0" ItemAlign="Center" HeaderAlign="Center">
		    </dw:ListColumn>
		    <dw:ListColumn ID="ListColumn4" runat="server" Name="Compare" Width="0" ItemAlign="Center" HeaderAlign="Center">
		    </dw:ListColumn>
		</Columns>
	</dw:List>
</form>
</body>
</html>
