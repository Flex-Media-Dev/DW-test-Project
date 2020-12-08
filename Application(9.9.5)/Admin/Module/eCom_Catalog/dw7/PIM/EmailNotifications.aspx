<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailNotifications.aspx.vb" Inherits="Dynamicweb.Admin.EmailNotifications" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="false" IncludeClientSideSupport="true" IncludeScriptaculous="false" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <dwc:ScriptLib runat="server" ID="ScriptLib1"></dwc:ScriptLib>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    <script type="text/javascript">
        function showAddNotificationDialog() {
            dialog.setTitle('AddNotificationDialog', '<%= Dynamicweb.SystemTools.Translate.Translate("Add notification") %>');
            dialog.show('AddNotificationDialog', '/Admin/Module/eCom_Catalog/dw7/PIM/PimEmailNotificationEdit.aspx');
        }
        function submitForm() {
            var searchWaterMark = document.getElementById('NotificationsList:emailSearch');
            if (searchWaterMark != null && searchWaterMark.value == 'Search emails') {
                searchWaterMark.value = '';
            }
            var theForm = document.forms["form1"];
            theForm.submit();
        }
        function editNotification(id) {
            dialog.setTitle('AddNotificationDialog', '<%= Dynamicweb.SystemTools.Translate.Translate("Edit notification") %>');
            dialog.show('AddNotificationDialog', '/Admin/Module/eCom_Catalog/dw7/PIM/PimEmailNotificationEdit.aspx?ID=' + id);
        }

        function deleteNotifications() {
            var selectedRows = List.getSelectedRows('NotificationsList');
            var ids = getSelectedIDs();
            $("Cmd").value = "Delete";
            $("NotificationIDs").value = ids;
            submitForm();
        }

        getSelectedIDs = function () {
            var rows = List.getSelectedRows('NotificationsList');
            var ret = '', notifcationID = '';

            if (rows && rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    notifcationID = rows[i].id.replace(/row/gi, '');
                    if (notifcationID != null && notifcationID.length > 0) {
                        ret += (notifcationID + ',')
                    }
                }
            }

            if (ret.length > 0) {
                ret = ret.substring(0, ret.length - 1);
            }

            return ret;
        }

        function submitAddNotificationDialog() {
            var metadataDialogFrame = document.getElementById('AddNotificationDialogFrame');
            var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);
            iFrameDoc.submitForm();
        }

        function closeAddNotificationDialog() {
            dialog.hide('AddNotificationDialog');
            submitForm();
        }
    </script>
</head>
<body id="material-layout" class="boxed-fields">
    <div class="dw8-container">
        <form id="form1" runat="server">
            <asp:HiddenField ID="Cmd" runat="server" />
            <asp:HiddenField ID="NotificationIDs" runat="server" />
            <div class="card">
                <div class="card-header">
                    <h2>
                        <dw:TranslateLabel Text="Notifications" runat="server" />
                    </h2>
                </div>
                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton runat="server" Divide="None" Icon="PlusSquare" Text="Add notification" OnClientClick="showAddNotificationDialog();" />
                    <dw:ToolbarButton runat="server" Divide="None" Icon="Delete" Text="Delete notifications" OnClientClick="deleteNotifications();" />
                </dw:Toolbar>

                <dw:List ID="NotificationsList" runat="server" AllowMultiSelect="true" ShowTitle="false" Personalize="true" NoItemsMessage="No notifications"
                    StretchContent="false" UseCountForPaging="true" HandlePagingManually="true">
                    <Filters>
                        <dw:ListTextFilter ID="emailSearch" Width="250" WaterMarkText="Search emails" Priority="1" runat="server" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="50" Label="Show on page" AutoPostBack="true" Priority="2" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="All" Value="" />
                                <dw:ListFilterOption Text="25" Value="25" Selected="true" />
                                <dw:ListFilterOption Text="50" Value="50" />
                                <dw:ListFilterOption Text="100" Value="100" />
                                <dw:ListFilterOption Text="200" value="200" />
                            </Items>
                        </dw:ListDropDownListFilter>
                    </Filters>
                    <Columns>
                        <dw:ListColumn ID="TitleColumn" runat="server" Name="Title" EnableSorting="true" />
                        <dw:ListColumn ID="SubjectColumn" runat="server" Name="Subject" EnableSorting="true" />
                        <dw:ListColumn ID="QueryColumn" runat="server" Name="Query" EnableSorting="true" />
                        <dw:ListColumn ID="RuleColumn" runat="server" Name="Rule" EnableSorting="true" />
                        <dw:ListColumn ID="TemplateColumn" runat="server" Name="Template" EnableSorting="true" />
                        <dw:ListColumn ID="CreatedDate" runat="server" Name="Created" EnableSorting="true" />
                        <dw:ListColumn ID="SendDate" runat="server" Name="Send" EnableSorting="true" />
                    </Columns>
                </dw:List>

                <dw:Dialog runat="server" ID="AddNotificationDialog" Size="Medium" Title="New notification" OkText="Save" ShowCancelButton="true" ShowOkButton="true"
                    OkAction="submitAddNotificationDialog();">
                    <iframe id="AddNotificationDialogFrame"></iframe>
                </dw:Dialog>
            </div>
        </form>
    </div>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
