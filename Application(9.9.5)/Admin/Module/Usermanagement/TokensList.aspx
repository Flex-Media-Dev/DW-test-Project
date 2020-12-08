<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TokensList.aspx.vb" Inherits="Dynamicweb.Admin.TokensList" %>

<!DOCTYPE html>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createTokensListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                showUser: function (evt) {
                    evt.stopPropagation();
                    var userId = parseInt(evt.target.getAttribute("data-user-id"));
                    if (userId > 1) {
                        Action.Execute(this.options.actions.showUserInfo, {
                            userId: userId
                        });
                    }
                },

                editToken: function (evt, tokenId) {
                    Action.Execute(this.options.actions.edit, { TokenId: tokenId });
                },

                tokenSelected: function () {
                    if (List && List.getSelectedRows(this.options.ids.list).length > 0) {
                        Toolbar.setButtonIsDisabled('cmdDelete', false);
                    } else {
                        Toolbar.setButtonIsDisabled('cmdDelete', true);
                    }
                },

                confirmDeleteTokens: function (evt, rowID) {
                    evt.stopPropagation();
                    let tokensIds = [];
                    rowID = rowID || window.ContextMenu.callingID;
                    if (rowID) {
                        let row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                        if (row) {
                            tokensIds.push(rowID);
                        }
                    } else {
                        let ids = window.List.getSelectedRows(this.options.ids.list);
                        for (var i = 0; i < ids.length; i++) {
                            tokensIds.push(ids[i].getAttribute("itemid"));
                        }
                    }
                    Action.Execute(this.options.actions.delete, { ids: tokensIds });
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Tokens" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdDelete" Icon="Remove" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteTokens(event);" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List ID="lstTokens" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" PageSize="25" AllowMultiSelect="true" OnClientSelect="currentPage.tokenSelected();" 
                    UseCountForPaging="true"
                    HandleSortingManually="true"
                    HandlePagingManually="true">
                    <Columns>
                        <dw:ListColumn ID="clmTokenName" TranslateName="True" Name="Name" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmTokenDevice" TranslateName="True" Name="Device" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmUser" TranslateName="True" Name="User" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmDate" TranslateName="True" Name="Date" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
