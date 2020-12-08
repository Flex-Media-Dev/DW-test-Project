<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LanguageUpdates.aspx.vb" Inherits="Dynamicweb.Admin.LanguageUpdates" %>
<%@ Import Namespace="Dynamicweb.SystemTools"%>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta http-equiv="Content-Type"  content="text/html;charset=utf-8" />
    <title></title>
	<dw:ControlResources ID="ControlResources1" runat="server" ></dw:ControlResources>
	<style type="text/css">
	#BottomInformationBg
{
	height:53px;
	width:100%;
	min-width:818px;
	background-image:url('/Admin/Images/BottomInformationBg.png');
	background-repeat:repeat-x;
	position:fixed;
	bottom:0px;
}

#BottomInformationBg img
{
	margin:10px;
}

#BottomInformationBg .label
{
	color: #5A6779;
	padding-left:5px;
	padding-right:5px;
}
	</style>
	<script type="text/javascript">
		function navigate(pageId) {
			location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageId;
		}
	</script>
</head>
<body>
<form id="form1" runat="server">
	<dw:List ID="List1" runat="server" Title="Vis sidst opdaterede" PageSize="100" ShowPaging="false">
	    <Columns>
		    <dw:ListColumn ID="ListColumn1" runat="server" Name="" Width="25">
		    </dw:ListColumn>
		    <dw:ListColumn ID="ListColumn3" runat="server" Name="Sti" Width="0" EnableSorting="true">
		    </dw:ListColumn>
		     <dw:ListColumn ID="ListColumn2" runat="server" Name="Opdateret" Width="0" EnableSorting="true">
		    </dw:ListColumn>
		</Columns>
	</dw:List>
    </form>
    
    <div id="BottomInformationBg">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td rowspan="2"><img src="/Admin/Images/Ribbon/Icons/document_new.png" alt="" /></td>
			<td align="right"><span class="label"><span id="PageCount" runat="server"></span> <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Sider" /></span></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	</div>
</body>
</html>
