<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Category_sort.aspx.vb"
    Inherits="Dynamicweb.Admin.NewsV2.Category_sort" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeScriptaculous="true"
        runat="server">
    </dw:ControlResources>
    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="/admin/module/ecom_catalog/dw7/js/dwsort.js"></script>
    <script type="text/javascript" src="js/categorySort.js"></script>
    <style type="text/css">
        .breadcrumb {
            background-color: #fff;
        }

        #items li:hover {
            cursor: move;
        }

        .w20px {
            vertical-align: middle;
            padding: 0px;
            width: 20px;
        }
    </style>
    <script type="text/javascript">
        function help() {
		<%=Dynamicweb.SystemTools.Gui.Help("newsv2", "modules.newsv2.general.categories.sorting")%>
        }
    </script>
</head>
<body class="area-deeppurple">
    <div class="screen-container">
        <form id="form1" runat="server">
            <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
                <dw:ToolbarButton runat="server" Text="Gem" Icon="Save" OnClientClick="save();"
                    ID="Save" />
                <dw:ToolbarButton runat="server" Text="Annuller" Icon="TimesCircle" OnClientClick="category.list();"
                    ID="Cancel" />
                <dw:ToolbarButton ID="help" runat="server" OnClientClick="help();" Icon="Help" Text="Help">
                </dw:ToolbarButton>
            </dw:Toolbar>
            <div id="breadcrumb" class="breadcrumb" runat="server">
            </div>
            <div class="list">
                <ul>
                    <li class="header"><span class="w20px" style="padding-top: 0;"></span><span class="pipe"></span><span><a href="#" onclick="sorter.sortBy('name'); return false;">
                        <%=Translate.Translate("Name")%></a>
                        <i style="display: none;" id="name_up" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp)%>"></i>
                        <i style="display: none;" id="name_down" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown)%>"></i>
                    </span></li>
                </ul>
                <dw:StretchedContainer ID="SortingContainer" Scroll="Auto" Stretch="Fill" Anchor="document"
                    runat="server">
                    <ul id="items">
                        <asp:Repeater ID="GroupsRepeater" runat="server" EnableViewState="false">
                            <ItemTemplate>
                                <li id="Group_<%#Eval("ID")%>"><span class="w20px" style="padding-top: 2px; padding-left: 5px; overflow: hidden;">
                                    <i class="fa fa-file"></i></span><span>
                                        <%#Eval("NewsCategoryName")%></span> </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </dw:StretchedContainer>
            </div>
            <div id="BottomInformationBg" class="card-footer">
                <span class="label"><span id="GroupsCount" runat="server"></span>
                    &nbsp;<dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Categories" />
                </span>
            </div>
            <% Translate.GetEditOnlineScript()%>
        </form>
    </div>
</body>
</html>
