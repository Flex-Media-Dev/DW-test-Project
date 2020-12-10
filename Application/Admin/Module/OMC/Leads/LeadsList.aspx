<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="LeadsList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.LeadsList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dwl" Namespace="Dynamicweb.Admin.OMC.Leads" Assembly="Dynamicweb.Admin" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/LeadsList.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/LeadsList.css" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBRsqyo1ynLUaok8CGuft43G9yyT-ZUfYo"></script>
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.list", "omc.email.list")%>
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <input type="hidden" id="Cmd" name="Cmd" />
            <input type="hidden" id="saveAndClose" name="saveAndClose" />
            <input type="hidden" id="SecondaryLeadsListData" name="SecondaryLeadsListData" runat="server" />
            <input type="hidden" id="AdditionalLeadsListData" name="AdditionalLeadsListData" runat="server" />
            <input type="hidden" id="VisitorsData" name="VisitorsData" />
            <input type="hidden" id="AddedKnownProviders" name="AddedKnownProviders" />
            <dwc:Card runat="server">
                <dw:RibbonBar runat="server" ID="LeadsRbbon">
                    <dw:RibbonBarTab ID="RibbonBarTab1" Name="Content" runat="server">
                        <dw:RibbonBarGroup Name="Leads" runat="server">
                            <dw:RibbonBarButton ID="cmdSave" Icon="Save" Size="Small" Text="Save" OnClientClick="currentPage.save();" runat="server" />
                            <dw:RibbonBarButton ID="cmdSaveAndClose" Icon="Save" Size="Small" Text="Save and close" OnClientClick="currentPage.save(true);" runat="server" />
                            <dw:RibbonBarButton ID="cmdCancel" Icon="Cancel" Size="Small" Text="Cancel" OnClientClick="currentPage.cancel();" runat="server" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="OperatoinsRibbonGroup" Name="Bulk operations" runat="server">
                            <dw:RibbonBarButton ID="cmdMarkAsLeads" Icon="FlagO" IconColor="Success" Size="Small" Text="Mark as leads" OnClientClick="currentPage.markSelected();" Disabled="true" runat="server" />
                            <dw:RibbonBarButton ID="cmdMarkAsNotLeads" Icon="FlagO" IconColor="Danger" Size="Small" Text="Mark as not leads" OnClientClick="currentPage.unmarkSelected();" Disabled="true" runat="server" />
                            <dw:RibbonBarButton ID="cmdIgnoreCompamies" Icon="DndForwardslash" Size="Small" Text="Ignore companies" OnClientClick="currentPage.ignoreSelected();" Disabled="true" runat="server" />
                            <dw:RibbonBarButton ID="cmdSendInMail" Icon="EnvelopeO" Size="Small" Text="Send in mail" OnClientClick="currentPage.sendLeadsAsEmail();" Disabled="true" runat="server" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="StatesRibbonGroup" Name="Lead states" runat="server" Visible="False">
                            <dw:RibbonBarButton ID="StatesRibbonButton" runat="server" Size="Small" Text="Change state to" Icon="FlagCheckered" ContextMenuId="LeadStatesContext" Disabled="true" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="NotificationsRibbonGroup" Name="Email notifications" runat="server" Visible="False">
                            <dw:RibbonBarButton ID="cmdCreateNotification" Icon="Mail" Size="Small" Text="Create notification" OnClientClick="currentPage.createNotification();" Disabled="true" runat="server" />
                            <dw:RibbonBarButton ID="cmdManageNotifications" Icon="Mail" Size="Small" Text="Manage notifications" OnClientClick="currentPage.manageNotifications();" runat="server" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup runat="server" Name="Filters">
                            <dw:RibbonBarButton runat="server" ID="ButtonReset" Text="Reset" Size="Large" Icon="Refresh" OnClientClick="currentPage.resetFilters();" />
                            <dw:RibbonBarButton runat="server" ID="ButtonApplyFilters" Text="Apply" Size="Large" Icon="Check" OnClientClick="currentPage.applyFilters();" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup Name="Help" runat="server">
                            <dw:RibbonBarButton ID="cmdHelp" Icon="Help" Size="Large" Text="Help" OnClientClick="currentPage.help();" runat="server" />
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>
                <dwc:GroupBox runat="server" ID="LeadsListGroupBox" Title="Potential leads">
                    <dw:List runat="server" ID="LeadsList" ShowCollapseButton="true" ShowTitle="false" AllowMultiSelect="true" NoItemsMessage="No visitors found."
                        HandleSortingManually="true" HandlePagingManually="true" UseCountForPaging="true" OnClientSelect="currentPage.visitorSelected('LeadsList', this);">
                        <Filters>
                            <dw:ListDropDownListFilter runat="server" ID="WebsiteFilter" Label="Web site" Width="220"></dw:ListDropDownListFilter>

                            <dw:ListLinkFilter runat="server" ID="PageFilter" Label="Page" AreaID="document.getElementById('LeadsList:WebsiteFilter').value" Value="All" DisableFileArchive="true" DisableParagraphSelector="true"></dw:ListLinkFilter>

                            <dw:ListDropDownListFilter runat="server" ID="PageSizeFilter" Label="Leads per page" Width="220" Divide="After" Visible="False">
                                <Items>
                                    <dw:ListFilterOption Text="10" Value="10" DoTranslate="false" />
                                    <dw:ListFilterOption Text="20" Value="20" DoTranslate="false" Selected="true" />
                                    <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" />
                                    <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                                    <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                                    <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                    <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                                </Items>
                            </dw:ListDropDownListFilter>

                            <dw:ListDateFilter runat="server" ID="FromDateFilter" Label="From" IncludeTime="false" />
                            <dw:ListDateFilter runat="server" ID="ToDateFilter" Label="To" IncludeTime="false" Divide="After" />

                            <dw:ListDropDownListFilter runat="server" ID="CountryFilter" Label="Country" Width="220"></dw:ListDropDownListFilter>

                            <dw:ListDropDownListFilter runat="server" ID="PageviewsFilter" Label="Pageviews" Width="220">
                                <Items>
                                    <dw:ListFilterOption Text="Nothing selected" Value="" Selected="true" />
                                    <dw:ListFilterOption Text=">1" Value="2" DoTranslate="false" />
                                    <dw:ListFilterOption Text=">=5" Value="5" DoTranslate="false" />
                                    <dw:ListFilterOption Text=">=10" Value="10" DoTranslate="false" />
                                    <dw:ListFilterOption Text=">=15" Value="15" DoTranslate="false" />
                                </Items>
                            </dw:ListDropDownListFilter>

                            <dw:ListDropDownListFilter runat="server" ID="ExtranetUsersFilter" Label="Extranet users" Width="220" Divide="After">
                                <Items>
                                    <dw:ListFilterOption Text="Show all" Value="0" Selected="true" />
                                    <dw:ListFilterOption Text="Only show logged in users" Value="1" />
                                    <dw:ListFilterOption Text="Only show not logged in users" Value="2" />
                                </Items>
                            </dw:ListDropDownListFilter>

                            <dw:ListDropDownListFilter runat="server" ID="SourceFilter" Label="Source" Width="220"></dw:ListDropDownListFilter>
                            <dw:ListDropDownListFilter runat="server" ID="ProfileFilter" Label="Profile" Width="220"></dw:ListDropDownListFilter>
                            <dw:ListFlagFilter runat="server" ID="ExcludedCompaniesFilter" Label="Excluded companies" LabelFirst="true" IsSet="true" Divide="After" />
                        </Filters>

                        <Columns>
                            <dw:ListColumn runat="server" ID="TotalVisits" Name="Total visits" EnableSorting="true" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="LastVisit" Name="Last visit" EnableSorting="true" />
                            <dw:ListColumn runat="server" ID="LastVisitPageViews" Name="Pageviews" EnableSorting="true" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="Engagement" Name="EI" EnableSorting="true" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="CartReference" Name="Cart" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="UserName" Name="User" />
                            <dw:ListColumn runat="server" ID="Company" Name="Company" />
                            <dw:ListColumn runat="server" ID="Details" Name="Actions" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="States" Name="Current state" Visible="false" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="SecondaryLeadsListGroupBox" Title="Leads" Expandable="true" IsCollapsed="false">
                    <dw:List runat="server" ID="SecondaryLeadsList" ShowTitle="false" AllowMultiSelect="true" NoItemsMessage="No visitors selected." OnClientSelect="currentPage.visitorSelected('SecondaryLeadsList', this);">
                        <Columns>
                            <dw:ListColumn runat="server" ID="ListColumn1" Name="Total visits" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn2" Name="Last visit" />
                            <dw:ListColumn runat="server" ID="ListColumn3" Name="Pageviews" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn4" Name="EI" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn5" Name="Cart" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn6" Name="User" />
                            <dw:ListColumn runat="server" ID="ListColumn7" Name="Company" />
                            <dw:ListColumn runat="server" ID="ListColumn8" Name="Actions" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn9" Name="Current state" HeaderAlign="Center" ItemAlign="Center" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" ID="AdditionalLeadsListGroupBox" Title="Not leads" Expandable="true" IsCollapsed="true">
                    <dw:List runat="server" ID="AdditionalLeadsList" ShowTitle="false" AllowMultiSelect="true" NoItemsMessage="No visitors selected." OnClientSelect="currentPage.visitorSelected('AdditionalLeadsList', this);">
                        <Columns>
                            <dw:ListColumn runat="server" ID="ListColumn10" Name="Total visits" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn11" Name="Last visit" />
                            <dw:ListColumn runat="server" ID="ListColumn12" Name="Pageviews" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn13" Name="EI" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn14" Name="Cart" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn15" Name="User" />
                            <dw:ListColumn runat="server" ID="ListColumn16" Name="Company" />
                            <dw:ListColumn runat="server" ID="ListColumn17" Name="Actions" HeaderAlign="Center" ItemAlign="Center" />
                            <dw:ListColumn runat="server" ID="ListColumn18" Name="Current state" Visible="false" />
                        </Columns>
                    </dw:List>
                </dwc:GroupBox>
            </dwc:Card>
        </form>
        
        <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>

        <dw:Dialog ID="SendEmailDialog" runat="server" Title="Send lead as email" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" Size="Auto">
            <iframe id="SendEmailDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="pwDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
            <iframe id="pwDialogFrame"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" Title="Email notifications" ID="CreateNotificationDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
            <iframe id="CreateNotificationDialogFrame" src="/Admin/Module/OMC/Leads/EmailNotificationAttach.aspx"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" Title="Email notifications" ID="NotificationsListDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
            <iframe id="NotificationsListDialogFrame" src="/Admin/Module/OMC/Leads/EmailNotificationList.aspx"></iframe>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="VisitorLocationDialog" ShowOkButton="false" ShowCancelButton="false" ShowClose="true" Size="Small">
            <dwc:GroupBox runat="server">
                <div class="form-group">
                    <dw:TranslateLabel runat="server" UseLabel="true" Text="IP-address" />
                    <div>
                        <label id="visitorLocatoinIpAddress"></label>
                    </div>
                </div>
                <div class="form-group">
                    <dw:TranslateLabel runat="server" UseLabel="true" Text="ISP" />
                    <div>
                        <label id="visitorLocatoinISP"></label>
                    </div>
                </div>
                <div class="form-group">
                    <dw:TranslateLabel runat="server" UseLabel="true" Text="Region" />
                    <div>
                        <label id="visitorLocatoinRegion"></label>                        
                    </div>
                </div>
                <div class="form-group">
                    <dw:TranslateLabel runat="server" UseLabel="true" Text="Domain" />
                    <div>
                        <label id="visitorLocatoinDomain"></label> 
                    </div>
                </div>
                <div class="omc-leads-list-visitor-info-map" id="visitorLocationMap"></div>
            </dwc:GroupBox>
        </dw:Dialog>
        
        <dw:ContextMenu runat="server" ID="LeadStatesContext" OnShow="currentPage.leadStatesContextShow(this);">
        </dw:ContextMenu>

    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>

