<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ScheduledTask_Sort.aspx.vb" Inherits="Dynamicweb.Admin.ScheduledTask_Sort" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Scheduled tasks sorting</title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />
    <script type="text/javascript" src="/Admin/Content/JsLib/scriptaculous-js-1.9/src/scriptaculous.js?load=effects,dragdrop,slider,controls"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>

    <script type="text/javascript">
        close = false;

        function sort_init() {
            Position.includeScrollOffsets = true;
            Sortable.create("items", {
                onUpdate: function (element) { }
            });
        }

        function sortSave(close) {
            this.close = close;
            var sortedTasksIds = $$(".list-group-item").zip(function (tuple) {
                return tuple[0].readAttribute("data-task-id");
            });
            var sortedTasksNames = $$(".list-group-item").zip(function (tuple) {
                return tuple[0].readAttribute("data-task-name");
            });
            new Ajax.Request("/Admin/Content/Management/Pages/ScheduledTask_Sort.aspx", {
                method: 'get',
                parameters: {
                    "sort": sortedTasksIds.join(','),
                    "sortNames": sortedTasksNames.join(';'),
                    "dt": new Date().getTime()
                },
                onComplete: function (transport) {
                    if (this.close) {
                        location = "ScheduledTasks_cpl.aspx";
                    }
                }
            });
        }
    </script>
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link href="../../Page/PageSort.css" rel="stylesheet" />
</head>
<body onload="sort_init();" class="area-blue">
    <div class="dw8-container">

        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="cardHeader" Title="Sort scheduled tasks" DoTranslate="true"></dwc:CardHeader>

            <form id="form1" runat="server">
                <div id="content">
                    <div class="list">
                        <asp:Repeater ID="TasksRepeater" runat="server" EnableViewState="false">
                            <HeaderTemplate>
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <span class="C2"><%=Translate.Translate("Name")%></span>
                                        <span class="C3"><%=Translate.Translate("Active")%></span>
                                    </li>
                                </ul>
                                <ul id="items">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li id="Task_<%# Eval("ID") %>" class="list-group-item" data-task-id="<%# Eval("ID") %>" data-task-name="<%# Eval("Name") %>">
                                    <div class="drag-holder">
                                        <span class="C2"><%# Eval("Name") %></span>
                                        <span class="C3"><%#ActiveGif(CType(Container.DataItem, Dynamicweb.Scheduling.Task).Enabled)%></span>
                                    </div>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <dw:Overlay ID="PleaseWait" runat="server" />
                    <dwc:ActionBar runat="server">
                        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" OnClientClick="sortSave(false);" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="sortSave(true);" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="location='ScheduledTasks_cpl.aspx';" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                    </dwc:ActionBar>
                </div>
            </form>
        </dwc:Card>
        <div class="card-footer">
            <table>
                <tr>
                    <td><span><dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Scheduled tasks" />:</span></td>
                    <td align="right"><span id="TasksCount" runat="server"></span></td>
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
