<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrder_Compare.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrder_Compare" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

	<dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true">
	</dw:ControlResources>

	<script type="text/javascript">
	    var orderID = '<%=Dynamicweb.Context.Current.Request("OrderID")%>';
	    var versionID = <%=Dynamicweb.Context.Current.Request("VersionID")%>;
		
		function changeCompare(version){
		    var loc = 'EcomOrder_Compare.aspx?OrderID=' + orderID + '&VersionID=' + version;
		    location = loc;
		}
	</script>

	<style type="text/css">
		.ci
		{
			background-color: #4CAF50 !important;
		}
		.cd
		{
			background-color: #F44336 !important;
		}
		td
		{
			vertical-align: top;
		}
		.h1
		{
			font-size: 13px;
			font-weight: bold;
		}
		.h2
		{
			font-size: 12px;
			font-weight: bold;
		}
		.h3
		{
			font-size: 11px;
			font-weight: bold;
		}
		.g
		{
			background-color:#e0e0e0;
			white-space:nowrap;
		}
		.t
		{
			right:17px;
			border-collapse:collapse;
		}
		.t td
		{
			border:solid 1px #9E9E9E;
			padding:5px;
		}
		tr.g td
		{
			border-top:solid 0px white;
			background-color: #eeeeee
		}
		.inlineToolbar ul
		{
			border-bottom-style:none;
		}

        .title {
            margin: 5px 15px;
        }
	</style>
</head>
<body class="area-pink" style="overflow: hidden">
    <form id="form1" runat="server">
    <h2 class="title" style="display:inherit;">
	    <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Compare versions" />
    </h2>
    <div style="position: fixed; top: 40px; right: 0px;bottom:0px;left:0px;overflow:auto;">
	<asp:Repeater ID="OrderCoparingsRepeater" runat="server" EnableViewState="false">
		<HeaderTemplate>
            <table class="t">
            <tr class="g">
	            <td width="170">
	            </td>
	            <td width="30%" style="padding:0px;"><strong>
                    <div style="float:left;padding:5px;">
		            <dw:TranslateLabel ID="pubLabel" runat="server" Text="Current" />
                    </div>
	            </strong></td>
	            <td width="30%" style="padding:0px;"><strong>
		            <div style="float:left;padding:5px;">
		            <dw:TranslateLabel ID="compareversionLabel" runat="server" Text="Previous versions" />
		            </div>
	            </strong></td>
	            <td width="30%" style="padding:0px;"><strong>
		            <div style="float:left;padding:5px;">
		            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Compare" />
		            </div>
	            </strong></td>
            </tr>
		</HeaderTemplate>
		<ItemTemplate>
			<tr>
	            <td class="g">
                    <strong><%#Eval("FieldName")%></strong>
	            </td>
	            <td> <%#Eval("OriginalValue")%></td>
	            <td> <%#Eval("OldValue")%></td>
	            <td> <%#Eval("Compare")%></td>
			</tr>
		</ItemTemplate>
		<FooterTemplate>
			</table>
		</FooterTemplate>
	</asp:Repeater>
    </div>
    </form>
</body>
</html>
