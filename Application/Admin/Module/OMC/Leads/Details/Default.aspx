<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details._Default" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
        
        <title><dw:TranslateLabel ID="lbTitle" Text="Visitor information" runat="server" /></title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

        <dw:ControlResources ID="ctrlResources" runat="server">
            <Items>
                <dw:GenericResource Url="/Admin/Module/OMC/js/VisitorDetails.js" />
                <dw:GenericResource Url="/Admin/Module/OMC/css/VisitorDetails.css" />
            </Items>
        </dw:ControlResources>
    </head>
    <body>
        <form id="MainForm" runat="server">
            <table id="mainTab" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                    <td id="cellNavigation" style="width: 280px;">
                        <div class="visitor-details-section-title"><dw:TranslateLabel ID="lbNavigation" Text="Navigation" runat="server" /></div>
                        <ul class="visitor-details-navigation">
                            <li>
                                <a class="visitor-details-navigation-basic" data-section="Basic" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Basic);">
                                    <span><dw:TranslateLabel ID="lbBasicInformation" Text="Basic information" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-location" data-section="Location" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Location);">
                                    <span><dw:TranslateLabel ID="lbLocation" Text="Location" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-referer" data-section="Referrer" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Referrer);">
                                    <span><dw:TranslateLabel ID="lbReferrer" Text="Referrer" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-extranet" data-section="Extranet" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Extranet);">
                                    <span><dw:TranslateLabel ID="lbExtranet" Text="Extranet" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-pages" data-section="PageVisits" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.PageVisits);">
                                    <span><dw:TranslateLabel ID="lbPagesVisited" Text="Pages visited" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-files" data-section="FileDownloads" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.FileDownloads);">
                                    <span><dw:TranslateLabel ID="lbFilesDownloaded" Text="Files downloaded" runat="server" /></span>
                                </a>
                            </li>
                            <li id="EcommersTreeLink" runat="server">
                                <a class="visitor-details-navigation-cart" data-section="Cart" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Cart);">
                                    <span><dw:TranslateLabel ID="lbCart" Text="Ecommerce" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-profiles" data-section="Profiles" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Profiles);">
                                    <span><dw:TranslateLabel ID="lbProfiles" Text="Profiles" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-advertising" data-section="Advertising" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Advertising);">
                                    <span><dw:TranslateLabel ID="lbAdvertising" Text="Advertising" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-visits" data-section="Visits" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.Visits, {fullPeriod:1});">
                                    <span><dw:TranslateLabel ID="lbVisits" Text="Visits" runat="server" /></span>
                                </a>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-email" data-section="Sent emails" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.SendEmail);">
                                    <span><dw:TranslateLabel ID="TranslateLabel1" Text="Sent emails" runat="server" /></span>
                                </a>
                            </li>
                            <li class="visitor-details-section-separator">
                                <div></div>
                            </li>
                            <li>
                                <a class="visitor-details-navigation-about" data-section="About" href="javascript:void(0);" onclick="OMC.MasterPage.get_current().set_section(OMC.Section.About);">
                                    <span><dw:TranslateLabel ID="lbAbout" Text="About this page" runat="server" /></span>
                                </a>
                            </li>
                        </ul>
                    </td>
                    <td id="slider">
                        <div id="sliderHandle">&nbsp;</div>
                    </td>
                    <td id="cellContent">
                        <div id="cellContentLoading" style="display: none">
                            <div class="omc-loading-container">
                                <div class="omc-loading-container-inner">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%> fa-spin"></i>
                                    <div class="omc-loading-container-text"><dw:TranslateLabel ID="lbPleaseWait" Text="One moment please..." runat="server" /></div>
                                </div>
                            </div>
                        </div>
                        <div id="entryContainer" style="display: none">
                            <div id="entryTitle" class="visitor-details-section-title"></div>
                            <iframe id="ContentFrame" src="about:blank" frameborder="0" width="100%" scrolling="auto" onload="OMC.MasterPage.get_current().contentLoaded();" 
                                height="100%" marginheight="0" marginwidth="0"></iframe>
                        </div>
                    </td>
                </tr>
            </table>
        </form>

        <script type="text/javascript">
            //<![CDATA[
            $(document.body).observe('unload', function () {
                OMC.MasterPage.get_current().dispose();
            });

            OMC.MasterPage.get_current().set_visitorID('<%=MyBase.Request("ID")%>');
            OMC.MasterPage.get_current().set_orderID('<%=MyBase.Request("orderID")%>');
            OMC.MasterPage.get_current().set_controlID('<%=Me.UniqueID%>');

            <asp:Literal ID="litMasterPageInitialization" runat="server" />

            OMC.MasterPage.get_current().initialize(function () {
                var section = '<%=Dynamicweb.Core.Converter.ToString(MyBase.Request("Section")).Replace("'", "\'")%>';

                if (section && section.length) {
                    OMC.MasterPage.get_current().set_section(OMC.Section[section]);
                } else {
                    OMC.MasterPage.get_current().set_section(OMC.Section.Basic);
                }
            });
            //]]>
        </script>

        <%Translate.GetEditOnlineScript()%>
    </body>
</html>
