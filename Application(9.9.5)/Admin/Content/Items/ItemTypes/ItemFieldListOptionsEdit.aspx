<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemFieldListOptionsEdit.aspx.vb" Inherits="Dynamicweb.Admin.ItemListFieldOptionsEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />

    <dw:ControlResources ID="ControlResources1" CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/Items/js/ItemFieldlistOptionsEdit.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/ItemFieldlistOptionsEdit.css" />
        </Items>
    </dw:ControlResources>
</head>
<body>
    <form id="MainForm" runat="server">
        <div class="form-outer">
            <div class="grid-container">
                <dw:EditableGrid ID="optionsGrid" AllowAddingRows="false" AllowDeletingRows="false" AllowSortingRows="true" runat="server">
                    <Columns>
                        <asp:TemplateField HeaderText="" HeaderStyle-Width="20">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelected" runat="server" />
                                <asp:HiddenField ID="hdnFieldID" runat="server" />
                                <asp:HiddenField ID="hdnFieldName" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Field name" HeaderStyle-Width="225">
                            <ItemTemplate>
                                <asp:Label ID="lblName" Width="200" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </dw:EditableGrid>
            </div>
            <div style="display: none" class="List-container">
                <dw:List ID="optionsList" ShowTitle="false" StretchContent="true" AllowMultiSelect="true" runat="server">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Field name" Width="250"  EnableSorting="true" />
                    </Columns>
                </dw:List>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        Dynamicweb.Items.ItemFieldListOptionsEdit.get_current()._terminology['NoSelectedFields'] = '<%= Translate.Translate("You have to select at least one field")%>';
        Dynamicweb.Items.ItemFieldListOptionsEdit.get_current().initialize();
    </script>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
