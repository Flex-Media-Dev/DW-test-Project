<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="List.aspx.vb" Inherits="Dynamicweb.Admin.List3" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeScriptaculous="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Area/List.js" />
            <dw:GenericResource Url="/Admin/Content/Area/List.css" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.css" />
        </Items>
    </dw:ControlResources>

    <asp:Literal ID="litPermissionsScript" runat="server" />

    <script type="text/javascript">
        allowedPageCount = <%=GetMaxNumberOfPages()%>;
        numberOfPagesInSolution = <%=Services.Pages.GetWebpageCount%>;
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <dw:RibbonBar ID="areaRibbon" runat="server">
            <dw:RibbonBarTab ID="RibbonBarTab1" runat="server" Name="Website">
                <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Website">

                    <dw:RibbonBarButton ID="btnNewWebsite" runat="server" OnClientClick="newArea();" Icon="PlusSquare" Disabled="false" Size="Small" Text="New website">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btnNewLanguage" runat="server" OnClientClick="newLanguageDialog();" Icon="PlusSquare" Disabled="false" Size="Small" Text="Nyt sprog" Visible="false">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="View">
                    <dw:RibbonBarButton ID="cmdShowWebsite" runat="server" Icon="PageView" Size="Large" Text="Vis" OnClientClick="showBtn();">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>

                <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Sort">
                    <dw:RibbonBarButton ID="cmdSortAreas" runat="server" OnClientClick="location='Sort.aspx';" Icon="Sort" Text="Sort">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroupPermissions" runat="server" Name="Permissions" Visible="false">
                    <dw:RibbonBarButton ID="cmdPermissions" runat="server" Size="Large" Icon="Lock" Text="All websites">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Help">
                    <dw:RibbonBarButton ID="RibbonbarButton10" runat="server" Size="Large" Icon="Help" Text="Help" OnClientClick="help();">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>

        <form id="form1" runat="server">

            <div class="list">
                <asp:Repeater ID="PagesRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>

                        <ul>
                            <li class="header">
                                <span class="C0" style="padding-top: 0px;"></span>
                                <span class="pipe"></span>
                                <span class="C1"><%=Translate.Translate("ID")%></span>
                                <span class="pipe"></span>
                                <span class="C2"><%=Translate.Translate("Website")%></span>
                                <span class="pipe"></span>
                                <span class="C3_1"><%=Translate.Translate("Sprog")%></span>
                                <span class="pipe"></span>
                                <span class="C3_2"><%=Translate.Translate("Sider")%></span>
                                <span class="pipe"></span>
                                <span class="C3_3"><%=Translate.Translate("Aktiv")%></span>
                                <span class="pipe"></span>
                                <span class="C3"><%=Translate.Translate("Domains")%></span>
                                <span class="pipe"></span>
                                <span class="C4">
                                    <dw:TranslateLabel ID="tl5" runat="server" Text="Primær domæne" />
                                </span>
                                <span class="pipe"></span>
                                <span class="C4_1"><%=Translate.Translate("Redigeret")%></span>
                                <span class="pipe"></span>
                            </li>
                        </ul>

                        <ul id="items">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li id="Area_<%# Eval("ID") %>" oncontextmenu="<%#ContextAction(CType(Container.DataItem, Dynamicweb.Content.Area)) %>" onclick="<%#ClickAction(CType(Container.DataItem, Dynamicweb.Content.Area))%>" class="<%#GetItemCssClass(CType(Container.DataItem, Dynamicweb.Content.Area))%>">
                            <span class="C0" style="padding: 0px; padding-top: 0; padding-left: 5px; overflow: hidden;">
                                <span style="padding: 0; padding-top: 0;" class="Show<%#Eval("Active")%>"><a href="/Default.aspx?AreaID=<%#Eval("ID")%>" target="_blank"><i class="Hide<%#CType(Container.DataItem, Dynamicweb.Content.Area).IsLanguage %> <%=KnownIconInfo.ClassNameFor(KnownIcon.Globe, True, KnownColor.Primary) %>" title="<%#Eval("ID")%>" /></i><div style="width: 16px; height: 16px" class="Show<%#CType(Container.DataItem, Dynamicweb.Content.Area).IsLanguage %>"></div>
                                </a>&nbsp;</span>
                                <input id="A<%# Eval("ID") %>" type="radio" <%#IIf(CType(Container.DataItem, Dynamicweb.Content.Area).id=1, "checked='checked'", "") %> name="Area" value="<%# Eval("ID") %>" <%#IIf(Not IsAccessibleArea(CType(Container.DataItem, Dynamicweb.Content.Area)), " disabled='disabled' ", "")%> />
                            </span>
                            <span class="C1 Show<%#Eval("Active")%>"><%# Eval("ID") %></span>
                            <span class="C2 Show<%#Eval("Active")%>">
                                <a <%#EditAction(CType(Container.DataItem, Dynamicweb.Content.Area)) %>>
						<img src="/Admin/Images/Ins.gif" style="vertical-align:middle;margin-left:12px;" alt="" class="Show<%#CType(Container.DataItem, Dynamicweb.Content.Area).LanguageDepth > 1 %>" /> 
						<img src="/Admin/Images/Ins.gif" style="vertical-align:middle;margin-left:3px;" alt="" class="Show<%#CType(Container.DataItem, Dynamicweb.Content.Area).LanguageDepth = 1 %>" />
						<%#If(CType(Container.DataItem, Dynamicweb.Content.Area).IsLanguage, "<i class=""" + KnownIconInfo.ClassNameFor(KnownIcon.CaretRight) + """></i> ", "")%><font id="AreaName<%# Eval("ID") %>"><%#Eval("Name")%></font></a>
                            </span>
                            <span class="C3_1 Show<%#Eval("Active")%>" id="AreaCulture<%# Eval("ID") %>"><i class="<%#GetAreaCountryFlag(CType(Container.DataItem, Dynamicweb.Content.Area)) %>"></i> <%#Eval("Culture")%></span>
                            <span class="C3_2 Show<%#Eval("Active")%>" id="AreaPagecount<%# Eval("ID") %>">
                                <%# Services.Pages.GetWebpageCount(CType(Container.DataItem, Dynamicweb.Content.Area).ID) %>
                            </span>
                            <span class="C3_3">
                                <a href="javascript:toggleActive(<%# Eval("ID") %>, '<%# Eval("Active") %>');" class="browseHide"><%# ActiveGif(CType(Container.DataItem, Dynamicweb.Content.Area))%></a>
                                <span id="AreaActive<%# Eval("ID") %>" style="display: none;"><%#Eval("Active")%></span>
                            </span>
                            <span class="C3 Show<%#Eval("Active")%>" title="<%#DomainList(CType(Container.DataItem, Dynamicweb.Content.Area), False)%>">
                                <%#DomainCount(CType(Container.DataItem, Dynamicweb.Content.Area))%>
                            </span>
                            <span class="C4 Show<%#Eval("Active")%>" style="padding-left: 0;">
                                <%#Eval("DomainLock")%>
                            </span>
                            <span class="C4_1 Show<%#Eval("Active")%>" title="<%=Translate.Translate("Oprettet")%>: <%#Eval("Audit.CreatedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>">
                                <%#Eval("Audit.LastModifiedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>
                            </span>
                            <span id="IsLanguage<%# Eval("ID") %>" style="display: none;"><%#Eval("IsLanguage")%></span>
                            <span id="LanguageDepth<%# Eval("ID") %>" style="display: none;"><%#Eval("LanguageDepth")%></span>

                            <span id="UserPermissions<%# Eval("ID") %>" style="display: none;"><%#Eval("UserPermissions")%></span>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
				
                    </FooterTemplate>
                </asp:Repeater>
                <dw:Infobar ID="infoNoPermissions" Visible="false" Type="Error" Message="You do not have access to this functionality" runat="server" />

            </div>

        </form>

        <dw:Dialog ID="dialogDelete" runat="server" Title="Slet" TranslateTitle="false" ShowOkButton="true" ShowCancelButton="true" OkAction="deleteArea();" CancelAction="dialog.hide('dialogDelete');">
            <span class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Warning) %>"></span>
            <%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("website"))%>
            <br />
            <b id="areaNameb" style="display: block; text-align: center;"></b>
            <br />
            <br />
            <b><%=Translate.JsTranslate("ADVARSEL!")%><br />
            </b>
            <div id="multipleLanguageVersionsWarning" style="display: none;"><%=Translate.JsTranslate("Alle sprog %% vil blive slettet!", "%%", Translate.JsTranslate("websites"))%></div>
            <div><%=Translate.JsTranslate("Alle %% og indhold vil blive slettet!", "%%", Translate.JsTranslate("sider"))%></div>
        </dw:Dialog>

        <dw:Dialog ID="dialogCannotDelete" runat="server" Title="Cannot delete" ShowOkButton="true" OkAction="dialog.hide('dialogCannotDelete');">
            <b><%=Translate.JsTranslate("ADVARSEL!")%><br />
                <br />
            </b>
            <div><%=Translate.JsTranslate("You cannot delete a website with languages, please delete language versions first.")%></div>
        </dw:Dialog>

        <dw:Dialog ID="ImportDialog" runat="server" Title="Import" ShowClose="true" Width="500">
            <iframe id="ImportDialogFrame" runat="server" frameborder="0"></iframe>
        </dw:Dialog>

        <dw:Dialog ID="dialogCopy" runat="server" Title="Copy website?" CancelAction="dialog.hide('dialogCopy');" ShowOkButton="true" ShowCancelButton="true" OkAction="copy();" HidePadding="false" Size="Medium">
            <form id="copyform">
                <input type="hidden" name="isLanguage" id="isLanguage" value="false" />
                <dw:GroupBox ID="GbSettings" runat="server" Title="Settings">
                    <table class="formsTable">
                        <tr>
                            <td class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="Kopier fra" />
                            </td>
                            <td>
                                <input type="text" id="areaNamebCopy" maxlength="255" class="std" readonly="readonly" disabled="disabled" />
                            </td>
                        </tr>
                        <tr id="NewAreaNameRow">
                            <td class="nobr">
                                <dw:TranslateLabel ID="tl1" runat="server" Text="Name" />
                            </td>
                            <td>
                                <input type="text" id="AreaName" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td class="nobr">
                                <dw:TranslateLabel ID="tl2" runat="server" Text="Regionale indstillinger" />
                            </td>
                            <td>
                                <%=CultureList("", "AreaCulture", True)%>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <div id="copySettings">
                    <dw:GroupBox ID="GroupBox1" runat="server" Title="Kopier" DoTranslation="true">
                        <table>
                            <tr>
                                <td>
                                    <dw:RadioButton runat="server" FieldName="CopyWhat" FieldValue="2" SelectedFieldValue="2" />
                                    <label for="CopyWhat2">
                                        <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Structure and paragraphs" />
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:RadioButton runat="server" FieldName="CopyWhat" FieldValue="1" />
                                    <label for="CopyWhat1">
                                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Structure only" />
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:RadioButton runat="server" FieldName="CopyWhat" FieldValue="3" />
                                    <label for="CopyWhat3">
                                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Website settings" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                    <dw:GroupBox ID="updateLinksGroup" runat="server" Title="Links" DoTranslation="true">
                        <table>
                            <tr>
                                <td>
                                    <dw:CheckBox ID="updateContentLinks" runat="server" Value="1" FieldName="updateContentLinks" SelectedFieldValue="1" />
                                    <label for="updateContentLinks">
                                        <dw:TranslateLabel ID="TranslateLabel13" runat="server" Text="Indhold" />
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:CheckBox ID="updateShortcuts" runat="server" Value="1" FieldName="updateShortcuts" SelectedFieldValue="1" />
                                    <label for="updateShortcuts">
                                        <dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="Genvej" />
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:CheckBox ID="updateGlobalparagraphs" runat="server" Value="1" FieldName="updateGlobalparagraphs" SelectedFieldValue="1" />
                                    <label for="updateGlobalparagraphs">
                                        <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Global element" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
                <dw:GroupBox ID="GroupBox2" runat="server" Title="Rettigheder" DoTranslation="true">
                    <table>
                        <tr>
                            <td>
                                <dw:CheckBox ID="CopyPermissions" runat="server" Value="1" FieldName="CopyPermissions" SelectedFieldValue="1" />
                                <label for="CopyPermissions"><%=Translate.JsTranslate("Kopier %%?", "%%", Translate.JsTranslate("rettigheder"))%></label>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

            </form>
        </dw:Dialog>

    </div>
    <div class="card-footer">
        <table>
            <tr>
                <td align="right"><span id="AreaCount" runat="server" class="label"></span></td>
                <td><span class="label">
                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Items" />
                </span></td>
            </tr>
            <tr>
                <td align="right"><span id="PageCount" runat="server" class="label"></span></td>
                <td><span class="label">
                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Sider" />
                </span></td>
            </tr>
        </table>
    </div>

    <dw:ContextMenu ID="AreaContext" OnClientSelectView="onContextMenuSelectView" runat="server">
        <dw:ContextMenuButton ID="cmdView" runat="server" Divide="None" Icon="Pageview" Text="Vis" OnClientClick="showC();" />
        <dw:ContextMenuButton ID="cmdEdit" runat="server" Divide="None" Icon="Pencil" Text="Rediger" OnClientClick="edit();" />
        <dw:ContextMenuButton ID="cmdActive" runat="server" Divide="None" Icon="Check" Text="Activate" OnClientClick="toggleActive(ContextMenu.callingID, 'False');" />
        <dw:ContextMenuButton ID="cmdInactive" runat="server" Divide="None" Icon="Close" Text="Deactivate" OnClientClick="toggleActive(ContextMenu.callingID, 'True');" />
        <dw:ContextMenuButton ID="cmdCopy" runat="server" Divide="Before" Icon="ContentCopy" Text="Kopier" OnClientClick="copyDialog();" />
        <dw:ContextMenuButton ID="cmdDelete" runat="server" Divide="Before" Icon="Delete" Text="Slet" OnClientClick="deleteAreaDialog();" />
        <dw:ContextMenuButton ID="cmdAreaPermissions" runat="server" Divide="Before" Icon="Lock" Text="Permissions" OnClientClick="openAreaPermissions();" />
    </dw:ContextMenu>

    <span style="display: none">
        <span id="CantDisplayNoPagesMessage"><dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="A website with no pages cannot be shown." /></span>
        <span id="CantDisplayNotActiveMessage"><dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Inactive websites cannot be shown" /></span>
        <span id="CopyDialogTitle"><dw:TranslateLabel ID="TranslateLabel213" runat="server" Text="Kopier sproglaget?" /></span>
        <span id="NewLanguageDialogTitle"><dw:TranslateLabel ID="TranslateLabel212" runat="server" Text="Nyt sprog" /></span>
        <span id="CopyText"><dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Kopi" /></span>
        <span id="CopySpecifyName"><%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Navn"))%></span>
        <span id="CopySpecifyCulture"><%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.Translate("Regionale indstillinger"))%></span>
        <span id="ExceedAllowedPageCount"><%= Translate.JsTranslate("This will exceed the allowed number of pages! Allowed number of page is - %%", "%%", GetMaxNumberOfPages().ToString())%></span>
    </span>
    <script type="text/javascript">
        <% If Services.Areas.GetAreas.Any() %>
        selectRow(<%=Services.Areas.GetAreas().First().ID%>);
        <% End If %>
    </script>

    <dw:Dialog runat="server" ID="AreaPermissionDialog" Width="500" Title="Website permissions" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" OkAction="savePermission();">
        <iframe id="AreaPermissionDialogFrame" src="" style="width: 531px; border: solid 0px black;"></iframe>
    </dw:Dialog>

    <dw:Overlay ID="copyWait" runat="server" Message="" ShowWaitAnimation="True">
        <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Kopierer" />
        ...
    </dw:Overlay>
    <iframe src="about:blank" id="copyframe" style="display: none; position: fixed; bottom: 0px; right: 0px; width: 500px; z-index: 10000;"></iframe>
    <%Translate.GetEditOnlineScript()%>

    <!-- Help button start-->
    <script type="text/javascript">
        function help(){
		<%=Gui.HelpPopup("", "modules.area.general") %>
        }
    </script>
    <!-- Help button end-->
</body>
</html>
