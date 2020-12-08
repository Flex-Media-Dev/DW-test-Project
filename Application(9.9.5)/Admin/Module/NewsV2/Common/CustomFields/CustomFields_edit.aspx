<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CustomFields_edit.aspx.vb" Inherits="Dynamicweb.Admin.ModulesCommon.CustomFields_edit" ClientIDMode="Static" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.News.Common" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title>CustomFields_edit</title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true"></dw:ControlResources>
    <script type="text/javascript">
        document.observe("dom:loaded", function () {
            var name = $("_txName");
            var systemName = $("_txSystemName");
            var typeSelector = $("_lstType");
            var chkDropDown = $("_chkDropDown");

            Event.observe(name, 'keyup', NameChanged);
            Event.observe(systemName, 'keyup', SystemNameChanged);
            Event.observe(typeSelector, 'change', ToggleDropdown);
            Event.observe(chkDropDown, 'ckick', togglePanel);

            $('dropDownValues').on('change', 'input[id^=ddText]', function (e) { DropdownTextChanged(e); });
        });

        function DeleteConfirm() {
            return confirm('<%=Translate.JsTranslate("Delete")%>?');
        }

        var systemName_changed = false;

        function SystemNameChanged() {
            systemName_changed = $("_txSystemName").value !== "";
        }

        function NameChanged() {
            var name = document.getElementById('_txName');
            var sysName = document.getElementById('_txSystemName');
            if (!systemName_changed && !sysName.disabled) {
                sysName.value = name.value.replace(/[ !&"'():,\[\]#$%^*\@\~\`\-\+\=\{\}\\\/\<\>\?\.\;\|]/g, '_');
            }
        }

        function ToggleDropdown() {
            var ftype = $("_lstType");
            var chkDd = document.getElementById("dropdownarea");
            var chk = document.getElementById('_chkDropDown');
            var panel = document.getElementById('pnlDropdown');
            if (ftype.value == "7" || ftype.value == "8" || ftype.value == "9" || ftype.value == "11" || ftype.value == "12") {
                chkDd.style.display = "none";
                panel.style.display = "none";
                chk.checked = false;
            } else {
                chkDd.style.display = "";
            }
        }

        function togglePanel() {
            var chk = document.getElementById('_chkDropDown');
            var panel = document.getElementById('pnlDropdown');

            panel.style.display = chk.checked ? '' : 'none';
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

        function deleteSelectedRowFields(obj) {
            if (DeleteConfirm()) {
                var row = dwGrid_dropDownValues.findContainingRow(obj);
                dwGrid_dropDownValues.deleteRows([row]);
            }
        }

        function DropdownTextChanged(event) {
            var obj = event.target;
            var row = dwGrid_dropDownValues.findContainingRow(obj);
            var ddValue = row.findControl('ddValue');
            var ddText = row.findControl('ddText');
            if (!ddValue.disabled) {
                ddValue.value = ddText.value.replace(/[ !&"'():,\[\]#$%^*\@\~\`\-\+\=\{\}\\\/\<\>\?\.\;\|]/g, '_');
            }
        }

        function changeDefault(obj) {
            var rows = dwGrid_dropDownValues.rows.getAll();
            rows.each(function (row) {
                var ddDefault = row.findControl('ddDefault' + EditableGridRow.getRowIndex(row));
                if (ddDefault && ddDefault.id !== obj.id) {
                    ddDefault.checked = false;
                }
            });
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
                <h2 class="header">Edit field</h2>
            </dwc:CardHeader>
            <dwc:CardBody runat="server">
                <input type="hidden" id="CMD" value="" runat="server" />
                <dw:Toolbar runat="server">
                    <dw:ToolbarButton runat="server" Icon="Save" ID="Save" Text="Save" OnClientClick="save();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="TimesCircle" ID="Cancel" Text="Cancel" OnClientClick="cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="Delete" ID="Remove" Text="Delete field" OnClientClick="deleteField();"></dw:ToolbarButton>
                    <dw:ToolbarButton runat="server" Icon="Help" ID="Help" Text="Help" OnClientClick="help();"></dw:ToolbarButton>
                </dw:Toolbar>

                <dwc:GroupBox runat="server" Title="Generelt">
                    <dwc:InputText ID="_txName" runat="server" onkeyup="NameChanged();" Label="Navn" ValidationMessage=""></dwc:InputText>
                    <dwc:InputText ID="_txSystemName" runat="server" onkeyup="SystemNameChanged();" Label="Systemnavn" ValidationMessage=""></dwc:InputText>
                    <dwc:SelectPicker ID="_lstType" Enabled="False" runat="server" Label="Felttype"></dwc:SelectPicker>
                    <dwc:CheckBox ID="Required" runat="server" Label="Required"></dwc:CheckBox>
                    <div id="dropdownarea" runat="server" style="display: none;">
                        <dwc:CheckBox ID="_chkDropDown" runat="server" OnClick="togglePanel();" Label="Dropdown"></dwc:CheckBox>
                    </div>
                </dwc:GroupBox>

                <asp:Panel ID="pnlDropdown" runat="server">
                    <dwc:GroupBox runat="server" Title="Dropdown">
                        <dw:EditableGrid runat="server" ID="dropDownValues">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:HiddenField runat="server" ID="ddId" />
                                        <dwc:InputText runat="server" ID="ddText" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dwc:InputText runat="server" ID="ddValue" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dw:CheckBox runat="server" ID="ddActive" Checked="true" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dw:CheckBox runat="server" ID="ddDefault" OnClick="changeDefault(this);" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <i title="<%=Translate.Translate("Change position") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.ArrowsV) %>" style="cursor: move;"></i>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <div id="buttons" style="width: 16px;">
                                            <i title="<%=Translate.JsTranslate("Slet") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>" onclick="javascript:deleteSelectedRowFields(this);" style="cursor: pointer;"></i>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </dwc:GroupBox>
                </asp:Panel>
            </dwc:CardBody>
        </dwc:Card>
    </form>
</body>
</html>
<%Translate.GetEditOnlineScript()%>
