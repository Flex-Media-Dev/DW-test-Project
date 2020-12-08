<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AdapterSort.aspx.vb" Inherits="Dynamicweb.Admin.AdapterSort" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeScriptaculous="true" IncludeUIStylesheet="true" runat="server"></dw:ControlResources>
    <link rel="Stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link rel="stylesheet" href="/Admin/Module/eCom_Catalog/dw7/css/sort.css" />
    <link href="../../Content/Page/PageSort.css" rel="stylesheet" />
    <script src="/Admin/Module/eCom_Catalog/dw7/js/dwsort.js"></script>
    <script type="text/javascript">

        var sorter;

        Event.observe(window, 'load', function () {
            Position.includeScrollOffsets = true;
            sorter = new DWSortable('items',
                {
                    name: function (s) { return ("" + s.children[1].innerHTML).toLowerCase(); }
                }
            );
        });

        function save() {
            new Ajax.Request("/Admin/Module/IntegrationV2/AdapterSort.aspx", {
                method: 'post',
                parameters: {
                    "Adapters": Sortable.sequence('items').join(','),
                    "Save": "save"
                },
                onSuccess: cancel
            });
        }

        function cancel() {
            window.location.href = "/Admin/Module/IntegrationV2/DoMapping.aspx";
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header">
            <h2 class="subtitle"><%=Translate.Translate("Sort adapters")%></h2>
        </div>
        <form id="form1" runat="server">
            <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
                <dw:ToolbarButton runat="server" Text="Save" Icon="Save" OnClientClick="save();" ID="Save" />
                <dw:ToolbarButton runat="server" Text="Cancel" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />
            </dw:Toolbar>
            <div class="list">
                <asp:Repeater ID="AdaptersRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>
                        <ul class="list-group">
                            <li class="list-group-item">
                                <span class="C2 sort-col">
                                    <a href="#"><%=Translate.Translate("Name")%></a>                                    
                                </span>                                
                            </li>
                        </ul>
                        <ul id="items">
                    </HeaderTemplate>

                    <ItemTemplate>                        
                        <li class="list-group-item" id="Adapter_<%#Eval("Id")%>">
                            <span class="C2"><%#Eval("Name")%></span>                            
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