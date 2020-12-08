<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="Sitemap_cpl.aspx.vb" Inherits="Dynamicweb.Admin.Sitemap_cpl" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="DynamicWeb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="DynamicWeb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript" language="javascript">
	    (function ($) {
	        $(function () {
	            var infoBar = $("#InfoBar_infoSuccess");

	            var applySitemap = function () {
	                $.ajax({
	                    url: "Sitemap_cpl.aspx",
	                    method: "POST",
	                    data: { applySiteMap: 1 }
	                }).done(function () {
	                    $("#sitemapAction").hide(); 
	                    infoBar.show();
	                });
	            };
	            infoBar.hide();
	            $("#btnApplySitemap").click(applySitemap);
	        });
	    })(jQuery);
	</script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">Control panel</a></li>
            <li class="active">Sitemap</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Sitemap" />

        <dwc:CardBody runat="server">
	        <dwc:GroupBox ID="Settings" runat="server" Title="Advanced settings">
                <div id="sitemapAction">
                    <dwc:Button ID="btnApplySitemap" Title="Enable &#x22;Show in sitemap&#x22; for all pages" runat="server" />
                </div>
                <dw:Infobar ID="infoSuccess" runat="server" Message="Sitemap has been applied to all pages" Type="Information" ClientIDMode="Static" ></dw:Infobar>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>

<%  Translate.GetEditOnlineScript()%>
</asp:Content>