<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DynamicStructureEdit.aspx.vb" Inherits="Dynamicweb.Admin.DynamicStructureEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeRequireJS="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.css" />
            <dw:GenericResource Url="/Admin/Resources/vendors/slim-select/slimselect.min.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwselector.js" />
        </Items>
    </dw:ControlResources> 
    <script>
        function createEditDynamicStructurePage(opts) {
            var options = opts;
            var dynamicStructureEl = document.getElementById(options.ids.name);
            var querySelectorEl = document.getElementById(options.ids.query);
            var completionRuleIni = dynamicStructureEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                var isValid = true;
                if (!hasValue(dynamicStructureEl)) {
                    dwGlobal.showControlErrors(dynamicStructureEl, options.labels.emptyName);
                    isValid || dynamicStructureEl.focus();
                    isValid = false;
                }
                if (!hasValue(querySelectorEl)) {
                    dwGlobal.showControlErrors(querySelectorEl, options.labels.missingQuery);
                    isValid || querySelectorEl.focus();
                    isValid = false;
                }
                return isValid;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                save: function (close) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('DoClose').value = "true";
                        }
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.close);
                },

                confirmDeleteImageGroup: function (evt) {
                    evt.stopPropagation();
                    var confirmStr = completionRuleIni;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        name: confirmStr
                    });
                },

                storeFields: function () {
                    const fieldsIds = SelectionBox.getElementsRightAsArray(this.options.ids.fieldsSelector);
                    console.log(fieldsIds);
                    const storageEl = document.getElementById(this.options.ids.fieldsStorage);
                    storageEl.value = fieldsIds;
                },

                showUsages: function () {
                    Action.Execute(this.options.actions.usages);
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit Dynamic Structure" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="TimesCircle" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Delete" Text="Delete" runat="server" OnClientClick="currentPage.confirmDeleteImageGroup(event);" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%=GetBreadCrumb()%>
                </div>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="DynamicStructureTitle" runat="server" Label="Name" ValidationMessage="" />
                        <div class="dw-ctrl select-picker-ctrl form-group has-error">
                            <label class="control-label">Query</label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="QuerySelect" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <small class="help-block error" id="helpQuerySelect"></small>
                            </div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbLevel1" Title="Level 1" runat="server">
                        <div class="form-group select-picker-ctrl searchable">
                            <label class="control-label"><%= Translate.Translate("Source") %></label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="DynamicStructureFieldSource1" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <asp:HiddenField runat="server" ID="level1Id" />
                            </div>
                        </div>
                        <dwc:SelectPicker ID="DynamicStructureFieldSorting1" runat="server" Label="Sorting"></dwc:SelectPicker>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbLevel2" Title="Level 2" runat="server">
                        <div class="form-group select-picker-ctrl searchable">
                            <label class="control-label"><%= Translate.Translate("Source") %></label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="DynamicStructureFieldSource2" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <asp:HiddenField runat="server" ID="level2Id" />
                            </div>
                        </div>
                        <dwc:SelectPicker ID="DynamicStructureFieldSorting2" runat="server" Label="Sorting"></dwc:SelectPicker>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbLevel3" Title="Level 3" runat="server">
                        <div class="form-group select-picker-ctrl searchable">
                            <label class="control-label"><%= Translate.Translate("Source") %></label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="DynamicStructureFieldSource3" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <asp:HiddenField runat="server" ID="level3Id" />
                            </div>
                        </div>
                        <dwc:SelectPicker ID="DynamicStructureFieldSorting3" runat="server" Label="Sorting"></dwc:SelectPicker>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbLevel4" Title="Level 4" runat="server">
                        <div class="form-group select-picker-ctrl searchable">
                            <label class="control-label"><%= Translate.Translate("Source") %></label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="DynamicStructureFieldSource4" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <asp:HiddenField runat="server" ID="level4Id" />
                            </div>
                        </div>
                        <dwc:SelectPicker ID="DynamicStructureFieldSorting4" runat="server" Label="Sorting"></dwc:SelectPicker>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="gbLevel5" Title="Level 5" runat="server">
                        <div class="form-group select-picker-ctrl searchable">
                            <label class="control-label"><%= Translate.Translate("Source") %></label>
                            <div class="form-group-input">
                                <dw:GroupDropDownList runat="server" ID="DynamicStructureFieldSource5" CssClass="selectpicker" Label=""></dw:GroupDropDownList>
                                <asp:HiddenField runat="server" ID="level5Id" />
                            </div>
                        </div>
                        <dwc:SelectPicker ID="DynamicStructureFieldSorting5" runat="server" Label="Sorting"></dwc:SelectPicker>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="DoClose" name="DoClose" value="false" />
        </form>
    </div>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            if (dwGlobal.createSelector) {
                document.querySelectorAll('.select-picker-ctrl.searchable').forEach(function (el) {
                    const options = el.dataset;
                    const opts = Object.assign({ container: el, select: el.querySelector('select') }, options);
                    dwGlobal.createSelector(opts);
                });
            }
        });
    </script>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>



