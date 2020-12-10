<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListUsersSorting.aspx.vb" Inherits="Dynamicweb.Admin.ListUsersSorting" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Translate.Translate("Sort users")%></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />
    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />

    <script type="text/javascript" src="/Admin/Content/JsLib/scriptaculous-js-1.9/src/scriptaculous.js?load=effects,dragdrop,slider,controls"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>

    <link href="../../Content/Page/PageSort.css" rel="stylesheet" />

    <script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/js/dwsort.js"></script>
    <script type="text/javascript" src="ListUsersSorting.js"></script>
    <script type="text/javascript">
        Position.includeScrollOffsets = true;
    </script>
</head>
<body class="area-green">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Sort users" ID="cardTitle"></dwc:CardHeader>
            <div id="breadcrumb" class="breadcrumb">
                <asp:Literal ID="Breadcrumb" runat="server"></asp:Literal>
            </div>
            <dwc:CardBody runat="server">
                <form id="form1" runat="server">
                    <div id="content">
                        <input type="hidden" id="GroupID" value="<%=GroupID %>" />
                        <div class="list">

                            <asp:Repeater ID="UsersRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="list-group">
                                        <li class="list-group-item">
                                            <span class="C2 sort-col">
                                                <a href="#" onclick="sorter.sortBy('name'); return false;"><%=Translate.Translate("Name")%></a>
                                                <i id="name_up" class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                                <i id="name_down" class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                            </span>
                                            <span class="C2 sort-col">
                                                <a href="#" onclick="sorter.sortBy('username'); return false;"><%= Translate.Translate("UserName")%></a>
                                                <i id="username_up" class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                                <i id="username_down" class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                            </span>
                                            <span class="C2 sort-col">
                                                <a href="#" onclick="sorter.sortBy('email'); return false;"><%= Translate.Translate("Email")%></a>
                                                <i id="email_up" class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp, True)%>"></i>
                                                <i id="email_down" class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown, True)%>"></i>
                                            </span>
                                        </li>
                                    </ul>
                                    <ul id="items">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li class="list-group-item" id="User_<%#Eval("ID")%>">
                                        <span class="C2"><%#Eval("Name")%></span>
                                        <span class="C2"><%# Eval("UserName")%></span>
                                        <span class="C2"><%# Eval("Email")%></span>
                                    </li>
                                </ItemTemplate>

                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
                </form>
            </dwc:CardBody>
            <div class="card-footer">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <span>
                                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Users" />
                                :
                            </span>
                        </td>

                        <td align="right">
                            <span style="padding: 0;" id="UsersCount" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </dwc:Card>
        <dw:Overlay ID="actionOverlay" Message="wait" runat="server"></dw:Overlay>
        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Image="NoImage" OnClientClick="save();" ID="Save" ShowWait="False" />
            <dw:ToolbarButton runat="server" Text="Annuller" Image="NoImage" OnClientClick="cancel();" ID="Cancel" ShowWait="true" />
        </dwc:ActionBar>
    </div>
</body>
</html>
