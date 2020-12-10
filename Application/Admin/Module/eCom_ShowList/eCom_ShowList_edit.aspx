<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_ShowList_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_ShowList_edit" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import namespace="Dynamicweb" %>

<input type="hidden" id="eCom_ShowList_settings" name="eCom_ShowList_settings" value="FavListTemplate" />

<dw:ModuleHeader ID="dwHeaderModule" runat="server" ModuleSystemName="eCom_ShowList" />

<dwc:GroupBox Title="Template" runat="server">	
	<dw:FileManager ID="fileFavListTemplate" Name="FavListTemplate" Label="Public list template" runat="server" />
</dwc:GroupBox>
