<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfigurationEdit.aspx.vb" Inherits="Dynamicweb.Admin.ConfigurationEdit" %>

<!DOCTYPE html>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/StretchedContainer/StretchedContainer.js"></script>
    <script type="text/javascript" src="/Admin/Filemanager/Upload/js/EventsManager.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="metaEditor.js"></script>

    <style type="text/css">
        body {
            border-style: none;
            border-width: 0;
        }

        td:first-of-type {
            padding-left: 4px;
        }
    </style>

    <script type="text/javascript">
        function onAfterEditSystemName(input) {
            if (input) {
                input.value = metaEditor.makeSystemName(input.value);
            }
        }

        function fieldTypeChange(link) {
            var row = dwGrid_gridMetaFields.findContainingRow(link);
            if (row) {
                if (link.value == "list" || link.value == "radiobuttonlist" || link.value == "checkboxlist")
                    row.findControl("fieldEdit").show();
                else
                    row.findControl("fieldEdit").hide();
            }
        }

        function editField(link) {
            var row = dwGrid_gridMetaFields.findContainingRow(link);
            if (row) {
                var options = row.findControl("fieldOptions");

                var qs = Object.toQueryString({
                    'options': encodeURIComponent(row.findControl("fieldOptions").value),
                    'caller': options.getAttribute("id")
                });

                dialog.show('OptionsEditDialog', "/Admin/Filemanager/Metadata/ConfigurationOptionsEdit.aspx?" + qs);
            }
        }

        function editFieldSave() {
            var optionsEditDialogFrame = document.getElementById('OptionsEditDialogFrame');
            var iFrameDoc = (optionsEditDialogFrame.contentWindow || optionsEditDialogFrame.contentDocument);

            iFrameDoc.save();
            dialog.hide('OptionsEditDialog');
        }

        function deleteField(link) {
            var row = dwGrid_gridMetaFields.findContainingRow(link);
            if (row) {
                if (confirm('<%= Translate.JsTranslate("Do you want to delete this row?") %>')) {
                    dwGrid_gridMetaFields.deleteRows([row]);
                }
            }
        }

        function validate() {
            var inputs = $$('#gridMetaFields input.fieldId[type="text"]');
            for (var i = 0; i < inputs.length; i++) {
                var currentId = inputs[i].value;
                if (currentId.match(/^[0-9]/)) {
                    alert('<%= Translate.JsTranslate("Meta field id is incorrect: ") %>' + currentId);
                    return false;
                }
                for (var j = 0; j < i; j++) {
                    if (currentId == inputs[j].value) {
                        alert('<%= Translate.JsTranslate("Meta field id should be unique: ") %>' + currentId);
                        return false;
                    }
                }
            }

            return true;
        }

        function save() {
            document.getElementById('cmd').value = "saveAndClose";
            metaEditor.save(validate);
        }

        function cancel() {
            var url = new URL(window.location.href);
            var dialogId = url.searchParams.get('dialogId');

            if (parent && dialogId) {
                parent.dialog.hide(dialogId);
            } else {
                window.location = "/Admin/Module/Filemanager_cpl.aspx";
            }
        }

        //function help() {
        //    <%=Gui.Help("filemanager", "modules.filemanager.metadata.metafields")%>
        //}
        <%= js.ToString()%>
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header" id="CardHeader" runat="server">
            <h2 class="subtitle">
                <asp:Label ID="ConfigurationEdit" runat="server" />
            </h2>
        </div>
        <dw:Toolbar ID="ConfigurationEditToolbar" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="save();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="cancel()">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <form id="form1" runat="server">
            <input type="hidden" id="cmd" name="cmd" value="" />
            <input type="hidden" id="makeDefault" name="makeDefault" value="" />

            <dw:Infobar Message="" runat="server" Type="Information" Title="No write permissions" ID="noAccessWarning" Visible="False"></dw:Infobar>

            <dw:EditableGrid runat="server" ID="gridMetaFields" ClientIDMode="AutoID" AllowAddingRows="true" AllowDeletingRows="true" AutoGenerateColumns="false" OnRowDataBound="gridMetaFields_OnRowDataBound">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <input type="text" runat="server" id="fieldId" class="std fieldId" onfocusout="onAfterEditSystemName(this);" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <input type="text" runat="server" id="fieldLabel" class="std" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <select runat="server" onchange="fieldTypeChange(this)" class="std" id="fieldEditor" style="width: 130px">
                                <option value="text">Text</option>
                                <option value="link">Link</option>
                                <option value="checkbox">Checkbox</option>
                                <option value="list">List box</option>
                                <option value="radiobuttonlist">Radiobutton list</option>
                                <option value="checkboxlist">Checkbox list</option>
                            </select>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="20px">
                        <ItemTemplate>
                            <span runat="server" id="fieldEdit" style="display: none">
                                <a href="javascript:void(0);" onclick="javascript:editField(this);">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Pencil, True) %>" title="<%= Translate.Translate("Edit")%>"></i>
                                </a>
                                <input type="hidden" runat="server" id="fieldOptions" name="fieldOptions" />
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="20px">
                        <ItemTemplate>
                            <span runat="server" id="fieldDelete">
                                <a href="javascript:void(0);" onclick="javascript:deleteField(this);">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Times, True) %>" title="<%= Translate.Translate("Delete")%>"></i>
                                </a>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </dw:EditableGrid>


            <dw:Dialog ID="OptionsEditDialog" runat="server" ShowCancelButton="true" ShowClose="true" HidePadding="true" ShowOkButton="true" Size="Medium" Title="Edit options" OkAction="editFieldSave(); return false;">
                <iframe id="OptionsEditDialogFrame" frameborder="0"></iframe>
            </dw:Dialog>
        </form>

        <%Translate.GetEditOnlineScript()%>
    </div>
</body>
</html>
