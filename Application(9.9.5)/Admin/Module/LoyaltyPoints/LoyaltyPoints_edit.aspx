<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoyaltyPoints_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_LoyaltyPoints_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import namespace="Dynamicweb" %>

<link rel="stylesheet" href="css/LoyaltyPoints_edit.css" type="text/css" />

<input type="hidden" name="LoyaltyPoints_settings" value="SortBy, SortOrder, TransactionListTemplate, TransactionDetailsTemplate, EmptyListTemplate, ItemsPerPage, PagerNextButtonType, PagerPrevButtonType, BackButtonType, PagerNextButtonTypeText, PagerNextButtonTypePicture, PagerPrevButtonTypeText, PagerPrevButtonTypePicture, BackButtonTypeText, BackButtonTypePicture" />
<dw:ModuleHeader ID="dwHeaderModule" runat="server" ModuleSystemName="LoyaltyPoints" />

<dw:GroupBox ID="grpboxTemplates" Title="Templates" runat="server">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
		<colgroup>
			<col width="170px" />
			<col />
		</colgroup>
		<tr>
			<td><dw:TranslateLabel ID="labelTransactionListTemplate" runat="server" Text="Transactions list" /></td>
			<td><dw:FileManager ID="fileTransactionListTemplate" Extensions="html,cshtml" runat="server" Name="TransactionListTemplate" /></td>
		</tr>				
		<tr>
			<td><dw:TranslateLabel ID="labelTransactionDetailsTemplate" runat="server" Text="Transaction details" /></td>
			<td><dw:FileManager ID="fileTransactionDetailsTemplate" Extensions="html,cshtml" runat="server" Name="TransactionDetailsTemplate" /></td>
		</tr>
	</table>
</dw:GroupBox>

<dw:GroupBox ID="grpboxPaging" Title="Paging" runat="server">
	<table cellpadding="2" cellspacing="0" width="100%" border="0">
		<colgroup>
			<col width="170px" />
			<col />
		</colgroup>
		<tr style="padding-top: 10px;">
			<td valign="top"><dw:TranslateLabel ID="dwTransPaging" runat="server" Text="Items per page" /></td>
			<td style="padding-left: 2px;"><%=Dynamicweb.SystemTools.Gui.SpacListExt(_intItemsPerPage, "ItemsPerPage", 1, 100, 1, "")%></td>
		</tr>
	</table>
</dw:GroupBox>

<dw:GroupBox runat="server" title="Transactions sorting" DoTranslation="true">
	<table cellpadding="2" cellspacing="0" border="0"  width="100%">
		<colgroup>
			<col style="width:170px; " />
			<col />
		</colgroup>
		<tr>
			<td><dw:TranslateLabel id="Translatelabel19" runat="server" text="Sorter efter" /></td>
			<td>								
    			<asp:Literal id="SortEnum" runat="server"></asp:Literal>
			</td>
		</tr>
						

		<tr>
			<td style="vertical-align:top;">
				<dw:TranslateLabel runat="server" text="Sorteringsrækkefølge" />
			</td>
			<td>
				<input type="radio" runat="server" id="SortOrderASC" name="SortOrder" value="ASC" />
				<label for="SortOrderASC"><dw:TranslateLabel runat="server" text="Stigende" /></label><br />
								
				<input type="radio" runat="server" id="SortOrderDESC" name="SortOrder" value="DESC" />
				<label for="SortOrderDESC"><dw:TranslateLabel runat="server" text="Faldende" /></label><br />
			</td>
		</tr>
	</table>
</dw:GroupBox>

