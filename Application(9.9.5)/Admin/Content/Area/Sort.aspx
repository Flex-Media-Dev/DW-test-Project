<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Sort.aspx.vb" Inherits="Dynamicweb.Admin.AreaSort" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons"%>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true" IncludeScriptaculous="true"></dw:ControlResources>
    <script type="text/javascript" src="Sort.js"></script>
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
	<link rel="Stylesheet" href="List.css" />
</head>
<body onload="sort_init();" class="screen-container">
    <div class="dw8-container">

        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="cardHeader" Title="Sort websites" DoTranslate="true"></dwc:CardHeader>

            <dwc:CardBody runat="server" ID="cardbody">
                <form id="form1" runat="server">
                    <div class="list">
                        <asp:Repeater ID="WebSitesRepeater" runat="server" EnableViewState="false">
                            <HeaderTemplate>
                                <ul>
                                    <li class="header">
					                    <span class="C1"><%=Translate.Translate("ID")%></span>
					                    <span class="pipe"></span>
					                    <span class="C2"><%=Translate.Translate("Website")%></span>
					                    <span class="pipe"></span>
					                    <span class="C3_2"><%=Translate.Translate("Sider")%></span>
					                    <span class="pipe"></span>
					                    <span class="C3_3"><%=Translate.Translate("Aktiv")%></span>
					                    <span class="pipe"></span>
					                    <span class="C3"><%=Translate.Translate("Domains")%></span>
					                    <span class="pipe"></span>
					                    <span class="C4"><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Primær domæne" /></span> 
					                    <span class="pipe"></span>
					                    <span class="C4_1"><%=Translate.Translate("Redigeret")%></span> 
					                    <span class="pipe"></span>
                                    </li>
                                </ul>
                                <ul id="items">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li id="Area_<%# Eval("ID") %>" class="sort-area" data-area-id="<%# Eval("ID") %>">
                                    <div class="drag-holder">
                                        <span class="C1 Show<%#Eval("Active")%>"><%# Eval("ID") %></span>
                                        <span class="C2 Show<%#Eval("Active")%>">
                                            <a href="<%#GetOnclickAction(Core.Converter.ToInt32(Eval("ID")))%>"><%#Eval("Name")%></a>
                                        </span>
                                        <span class="C3_2 Show<%#Eval("Active")%>">
                                            <%#Eval("PageCount")%>
                                        </span>
                                        <span class="C3_3">
                                            <%#ActiveGif(CType(Container.DataItem, Dynamicweb.Content.Area).Active)%>
                                        </span>
                                        <span class="C3 Show<%#Eval("Active")%>">
                                            <%#DomainCount(CType(Container.DataItem, Dynamicweb.Content.Area))%>
                                        </span>
                                        <span class="C4 Show<%#Eval("Active")%>">
                                            <%#Eval("DomainLock")%>
                                        </span>
                                        <span class="C4_1 Show<%#Eval("Active")%>" title="<%=Translate.Translate("Oprettet")%>: <%#Eval("Audit.CreatedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>">
                                            <%#Eval("Audit.LastModifiedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>
                                        </span>
                                    </div>
                                    <asp:Repeater ID="LanguagesRepeater" runat="server" EnableViewState="false">
                                        <HeaderTemplate>
                                            <ul class="language-list">
                                        </HeaderTemplate>
                                        <ItemTemplate>                                            
                                            <li id="Area_<%# Eval("ID") %>" class="sort-area" data-area-id="<%# Eval("ID") %>">
                                                <span class="C1 Show<%#Eval("Active")%>"><%# Eval("ID") %></span>
                                                <span class="C2 Show<%#Eval("Active")%>">
                                                    <%#If(CType(Container.DataItem, Dynamicweb.Content.Area).IsLanguage, "<i class=""" + KnownIconInfo.ClassNameFor(KnownIcon.CaretRight) + """></i> ", "")%><a href="<%#GetOnclickAction(Core.Converter.ToInt32(Eval("ID")))%>"><%#Eval("Name")%></a>
                                                </span>
                                                <span class="C3_2 Show<%#Eval("Active")%>">
                                                    <%#Eval("PageCount")%>
                                                </span>
                                                <span class="C3_3">
                                                    <%#ActiveGif(CType(Container.DataItem, Dynamicweb.Content.Area).Active)%>
                                                </span>
                                                <span class="C3 Show<%#Eval("Active")%>">
                                                    <%#DomainCount(CType(Container.DataItem, Dynamicweb.Content.Area))%>
                                                </span>
                                                <span class="C4 Show<%#Eval("Active")%>">
                                                    <%#Eval("DomainLock")%>
                                                </span>
                                                <span class="C4_1 Show<%#Eval("Active")%>" title="<%=Translate.Translate("Oprettet")%>: <%#Eval("Audit.CreatedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>">
                                                    <%#Eval("Audit.LastModifiedAt", "{0:ddd, dd MMM yyyy HH':'mm}")%>
                                                </span>
                                            </li>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </ul>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>

                        <dw:Infobar ID="infoNoPermissions" Visible="false" Type="Error" Message="You do not have access to this functionality" runat="server" />
                    </div>

                    <dw:Overlay ID="PleaseWait" runat="server" />
                    <dwc:ActionBar runat="server">
                        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" OnClientClick="sortSave(false);" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="sortSave(true);" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="location='List.aspx';" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                    </dwc:ActionBar>
                </form>
            </dwc:CardBody>
        </dwc:Card>
        <div class="card-footer">
	        <table>
		        <tr>
			        <td><span><dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Websites" />:</span></td>
                    <td align="right"><span id="AreaCount" runat="server"></span></td>
		        </tr>
		        <tr>
			        <td></td>
                    <td></td>
		        </tr>
	        </table>
	    </div>        
    </div>
</body>
</html>
