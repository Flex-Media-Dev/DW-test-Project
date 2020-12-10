<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomOrderState_ListSort.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomOrderState_ListSort" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeScriptaculous="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <link rel="Stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link rel="stylesheet" href="../css/sort.css" />
    <script type="text/javascript" src="../js/dwsort.js"></script>
    <script type="text/javascript">

        var sorter;

        Event.observe(window, 'load', function () {
            Position.includeScrollOffsets = true;
            sorter = new DWSortable('items',
                {
                    name: function (s) { return ("" + s.children[0].innerHTML).toLowerCase(); }
                }
            );
        });

        function save() {
            new Ajax.Request("/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderState_ListSort.aspx", {
                method: 'post',
                parameters: {
                    "OrderStates": Sortable.sequence('items').join(','),
                    "Save": "save"
                },
                onSuccess: cancel
            });
        }

        function cancel() {
            window.location.href = "/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderState_List.aspx?flowId=<%=FlowId%>&OrderType=<%=OrderType%>";
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle"><dw:TranslateLabel ID="CardHeaderText" runat="server" /></h2>
        </div>
        <form id="form1" runat="server">
            <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
                <dw:ToolbarButton runat="server" Text="Gem" Icon="Save" OnClientClick="save();" ID="Save" />
                <dw:ToolbarButton runat="server" Text="Annuller" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />
            </dw:Toolbar>
            <div class="list">
                <asp:Repeater ID="OrderStatesRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>
                        <ul class="list-group">
                            <li class="list-group-item">
                                <span class="sort-col w100">
                                    <a href="#" onclick="sorter.sortBy('name'); return false;"><%=Translate.Translate("Name")%></a>
                                    <i id="name_up" style="display: none" class="sort-selector up <%=KnownIconInfo.ClassNameFor(KnownIcon.SortUp)%>"></i>
                                    <i id="name_down" style="display: none" class="sort-selector down <%=KnownIconInfo.ClassNameFor(KnownIcon.SortDown)%>"></i>
                                </span>
                            </li>
                        </ul>
                        <ul id="items">
                    </HeaderTemplate>

                    <ItemTemplate>
                        <li class="list-group-item" id="OrderState_<%#Eval("ID")%>">
                            <span class="w100"><%#Eval("Name")%></span>
                        </li>
                    </ItemTemplate>
                    
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </form>
    </div>
</body>
</html>
<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
