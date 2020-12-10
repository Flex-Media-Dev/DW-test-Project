<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RemoteHttp_Edit.aspx.vb" Inherits="Dynamicweb.Admin.RemoteHttp_Edit" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<dw:ModuleHeader runat="server" ModuleSystemName="RemoteHttp" />
<dw:ModuleSettings runat="server" value="RemoteHttpUrl, RemoteHttpSendQueryString, RemoteHttpXSLTTemplate, RemoteHttpCache, RemoteHttpCacheMinutes" ModuleSystemName="RemoteHttp" />

<dw:GroupBox runat="server" Title="Indstillinger">
<table>
	<tr>
		<td width="170"><dw:Label runat="server" doTranslation="true" Title="URL" /></td>
		<td>
			<input id="RemoteHttpUrl" runat="server" class="std" name="RemoteHttpUrl" type="text" /></td>
	</tr>
	<tr>
		<td>
			<dw:Label runat="server" doTranslation="true" Title="Anvend XSLT Template" />
		</td>
		<td>
			<dw:FileManager ID="RemoteHttpXSLTTemplate" runat="server" Extensions="xsl,xslt" Folder="Templates/RemoteHttp" Name="RemoteHttpXSLTTemplate" />
		</td>
	</tr>
	<tr>
		<td>
			<dw:Label runat="server" doTranslation="true" Title="Vidersend Querystring" />
		</td>
		<td>
			<dw:CheckBox ID="RemoteHttpSendQueryString" runat="server" FieldName="RemoteHttpSendQueryString" />
		</td>
	</tr>
	<tr>
		<td valign="top">
			<dw:Label ID="Label1" runat="server" doTranslation="true" Title="Indholdet skal" />
		</td>
		<td>
			<dw:RadioButton runat="server" id="RemoteHttpCache0" FieldName="RemoteHttpCache" FieldValue="0" /><label for="RemoteHttpCache0"><dw:Label ID="Label2" runat="server" doTranslation="true" Title="Aldrig caches (længere ventetid og større serverbelastning!)" /></label>
			<br />
			<dw:RadioButton runat="server" ID="RemoteHttpCache1" FieldName="RemoteHttpCache" FieldValue="1" /><label for="RemoteHttpCache1">
				<dw:Label ID="Label3" runat="server" doTranslation="true" Title="Caches i" /></label>
				<input id="RemoteHttpCacheMinutes" runat="server" class="std" name="RemoteHttpCacheMinutes" type="text" maxlength="4" style="width:30px" />
				<dw:Label ID="Label4" runat="server" doTranslation="true" Title="minutter" />
		</td>
	</tr>
</table>
</dw:GroupBox>