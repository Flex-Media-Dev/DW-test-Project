<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CustomGroups_edit.aspx.vb" Inherits="Dynamicweb.Admin.ModulesCommon.CustomGroups_edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.News.Common" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title>CustomFields_edit</title>
    <dw:ControlResources IncludePrototype="true" ID="ControlResources1" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function DeleteConfirm() {
            return confirm('<%=Translate.JsTranslate("Delete")%>?');
        }

        function addField() {
            window.location.href = '/Admin/Module/NewsV2/Common/CustomFields/CustomFields_edit.aspx?context=<%= _context %>&groupId=<%= _group.ID %>&BackUrl=<%= _backUrl %>';
        }

        function save() {
            $('CMD').value = 'save';
            $('Form1').submit();
        }

        function cancel() {
            window.location.href = '<%= CommonMethods.GoBackUrl()%>';
        }

        function deleteField() {
            if (DeleteConfirm()) {
                $('CMD').value = 'delete';
                $('Form1').submit();
            }
        }

        function help() {
            <%=HelpHref()%>
        }
    </script>
</head>
<body class="screen-container">
    <form method="post" runat="server" id="Form1" class="formNews">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server">
                <h2 class="header">Group</h2>
            </dwc:CardHeader>
            <dwc:CardBody runat="server">
                <input type="hidden" id="CMD" runat="server" />
                <dw:Toolbar runat="server">
                    <dw:ToolbarButton runat="server" Icon="Save" ID="Save" Text="Save" OnClientClick="save();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="TimesCircle" ID="Cancel" Text="Cancel" OnClientClick="cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="Delete" ID="Remove" Text="Delete group" OnClientClick="deleteField();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="AddBox" ID="AddField" Text="New custom field" OnClientClick="addField();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="Help" ID="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
                </dw:Toolbar>

                <dwc:GroupBox runat="server" Title="Generelt">
                    <dwc:InputText ID="TextName" runat="server" Label="Navn" ValidationMessage=""></dwc:InputText>
                </dwc:GroupBox>

                <asp:Panel ID="FieldsPanel" runat="server">
                    <dwc:GroupBox runat="server" Title="Group fields">
                        <dw:List runat="server" ID="customFields" ShowTitle="false">
                            <Columns>
                                <dw:ListColumn runat="server" Name="Field name" />
                                <dw:ListColumn runat="server" Name="Template tag" />
                                <dw:ListColumn runat="server" Name="Field type" />
                            </Columns>
                        </dw:List>
                    </dwc:GroupBox>
                </asp:Panel>
            </dwc:CardBody>
        </dwc:Card>
    </form>
</body>
</html>
<%  Translate.GetEditOnlineScript()%>
