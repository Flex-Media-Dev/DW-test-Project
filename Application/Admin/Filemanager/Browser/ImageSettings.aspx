<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImageSettings.aspx.vb" Inherits="Dynamicweb.Admin.ImageSettingsForm" ClientIDMode="Static" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Imaging" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel ID="lbTitle" Text="Image settings" runat="server" />
    </title>
    <dwc:ScriptLib ID="ScriptLib1" runat="server">
        <script type="text/javascript" src="/Admin/Resources/Elements/Actions/DialogActions.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Ajax.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js"></script>
        <link rel="stylesheet" href="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.css" />
    </dwc:ScriptLib>

    <style type="text/css">
        html, body {
            overflow: auto;
            border-style: none;
            border-width: 0;
        }

        div.grid-container {
            margin-top: 10px;
            margin-left: 4px;
            margin-right: 4px;
            border: 1px solid #bdcce0;
            height: auto;
            overflow: auto;
            background-color: #ffffff;
            padding: 5px;
        }

        .popup-progress {
            padding-top: 150px !important;
            height: 280px !important;
        }
    </style>

    <script type="text/javascript">
        function onImgOverwriteChecked(sender) {
            $('divNewImagePostfix').style.display = sender.checked ? 'none' : '';

            var isEnable = sender.checked;
            if (isEnable) {
                $('chkOutputFormat').checked = false;
                $('outputFormatContainer').style.display = 'none';
            }
            $('chkOutputFormat').disabled = sender.checked;
        }

        function onOutputFormatChecked(sender) {
            $('outputFormatContainer').style.display = sender.checked ? '' : 'none';
        }

        function onLimitExtensionsChecked(sender) {
            $('divLimitExtensions').style.display = sender.checked ? '' : 'none';
        }

        function validateImgDimensions() {
            var w = parseInt($('txtImgWidth').value);
            var h = parseInt($('txtImgHeight').value);
            var result = true;

            if ($('cboImgCrop').value == '5') {
                if ((isNaN(w) && isNaN(h)) || (w < 1 && h < 1)) {
                    dwGlobal.showControlErrors("txtImgWidth", "<%=Translate.Translate("Specify width or height") %>");
                    dwGlobal.showControlErrors("txtImgHeight", "<%=Translate.Translate("Specify width or height") %>");
                    result = false;
                }
            } else {
                if (isNaN(w) || w < 1) {
                    dwGlobal.showControlErrors("txtImgWidth", "<%=Translate.Translate("Specify width") %>");
                    result = false;
                }

                if (isNaN(h) || h < 1) {
                    dwGlobal.showControlErrors("txtImgHeight", "<%=Translate.Translate("Specify height") %>");
                    result = false;
                }
            }

            return result;
        }

        function delThmb(link) {
            var row = dwGrid_gridThumbnails.findContainingRow(link);
            if (row) {
                if (confirm('<%= Translate.JsTranslate("Do you want to delete this row?") %>')) {
                    dwGrid_gridThumbnails.deleteRows([row]);
                }
            }
        }

        function isValid() {
            var isActive = $("chkImgIsActive").checked;
            dwGlobal.hideAllControlsErrors($("gbResizeImages"), "");
            gbImageResizeSettings.disabled = !isActive;
            if (!isActive) {
                return true;
            }

            result = validateImgDimensions();

            var overwriteOriginal = $("chkImgOverwriteOriginal").checked;
            var imgPostfix = $("txtImgPostfix").getValue();
            if (!overwriteOriginal) {
                if (imgPostfix === "") {
                    dwGlobal.showControlErrors("txtImgPostfix", "<%=Translate.Translate("Required value") %>");
                    result = false;
                } else if (!/[a-zA-Z0-9\-_()]+/.test(imgPostfix)) {
                    dwGlobal.showControlErrors("txtImgPostfix", "<%=Translate.Translate("Value contains invalid characters") %>");
                    result = false;
                }
            }

            var limitExtensions = $("chkLimitExtensions").checked;
            var limitExtensionsText = $("txtLimitExtensions").getValue();
            if (limitExtensions && limitExtensionsText === "") {
                dwGlobal.showControlErrors("txtLimitExtensions", "<%=Translate.Translate("Required value") %>");
                result = false;
            }

            return result;
        }

        function save() {
            if (isValid()) {
                $('cmd').value = 'saveAndClose';
                Action.Execute({ 'Name': 'Submit' });
            }
        }
    </script>
</head>
<body>
    <dwc:DialogLayout runat="server" ID="ImageSettingsEdit" Title="Edit image settings" HidePadding="True">
        <Content>
            <div class="col-md-0">
                <dw:Infobar Message="" runat="server" Type="Information" Title="No write permissions" ID="noAccessWarning" Visible="False"></dw:Infobar>
                <input type="hidden" id="cmd" name="cmd" />
                <dwc:GroupBox ID="gbResizeImages" Title="Resize images in folder" runat="server" ClassName="gb-resize-images">
                    <dwc:CheckBox ID="chkImgIsActive" runat="server" OnClick="isValid();" Label="Active" />
                    <fieldset id="gbImageResizeSettings" runat="server">
                        <dwc:InputNumber ID="txtImgWidth" MaxLength="5" runat="server" Label="Width" ValidationMessage="" />
                        <dwc:InputNumber ID="txtImgHeight" MaxLength="5" runat="server" Label="Height" ValidationMessage="" />
                        <dwc:SelectPicker ID="cboImgCrop" runat="server" Label="Crop offset">
                            <asp:ListItem Text="Center" Value="0" />
                            <asp:ListItem Text="From upper left" Value="1" />
                            <asp:ListItem Text="From lower left" Value="2" />
                            <asp:ListItem Text="From lower right" Value="3" />
                            <asp:ListItem Text="From upper right" Value="4" />
                            <asp:ListItem Text="Keep aspect ratio" Value="5" Selected="True" />
                            <asp:ListItem Text="Fit image" Value="6" />
                        </dwc:SelectPicker>
                        <dwc:SelectPicker runat="server" ID="cboImgQuality" Label="Quality">
                            <asp:ListItem Value="10"></asp:ListItem>
                            <asp:ListItem Value="20">20</asp:ListItem>
                            <asp:ListItem Value="30">30</asp:ListItem>
                            <asp:ListItem Value="40">40</asp:ListItem>
                            <asp:ListItem Value="50">50</asp:ListItem>
                            <asp:ListItem Value="60">60</asp:ListItem>
                            <asp:ListItem Value="70">70</asp:ListItem>
                            <asp:ListItem Value="80">80</asp:ListItem>
                            <asp:ListItem Value="90">90</asp:ListItem>
                            <asp:ListItem Value="100" Selected="True">100</asp:ListItem>
                        </dwc:SelectPicker>
                        <dwc:CheckBox ID="chkImgOverwriteOriginal" runat="server" OnClick="onImgOverwriteChecked(this);" Label="Overwrite original" />
                        <div id="divNewImagePostfix" <%=If(chkImgOverwriteOriginal.Checked, "style='display:none'", "")%>>
                            <dwc:InputText ID="txtImgPostfix" runat="server" Label="Resized image postfix" ValidationMessage="" />
                        </div>
                        <dwc:CheckBox ID="chkOutputFormat" runat="server" OnClick="onOutputFormatChecked(this);" Label="Enforce output format" />
                        <div id="outputFormatContainer" <%=If(chkOutputFormat.Checked AndAlso Not chkOutputFormat.Disabled, "", "style='display:none'") %>>
                            <dwc:SelectPicker ID="cboOutputFormat" runat="server" Label=""></dwc:SelectPicker>
                        </div>
                        <dwc:CheckBox ID="chkLimitExtensions" runat="server" OnClick="onLimitExtensionsChecked(this);" Label="Limit to these extensions" />
                        <div id="divLimitExtensions" <%=If(Not chkLimitExtensions.Checked, "style='display:none'", "")%>>
                            <dwc:InputText ID="txtLimitExtensions" runat="server" ValidationMessage="" Label="" Info="Use comma as separator (.png, .gif, e.t.c.)" />
                        </div>
                        <dwc:CheckBox ID="chkApplySettingsToSubfolders" runat="server" Label="Apply to subfolders" />
                    </fieldset>
                </dwc:GroupBox>

                <dwc:GroupBox ID="gbThumbnails" Title="Thumbnails" runat="server">
                    <div class="grid-container">
                        <dw:EditableGrid runat="server" ID="gridThumbnails" ClientIDMode="AutoID" AllowAddingRows="True" AutoGenerateColumns="false">
                            <Columns>
                                <asp:TemplateField ItemStyle-HorizontalAlign="center">
                                    <ItemTemplate>
                                        <dw:CheckBox ID="chkSelected" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="70px">
                                    <HeaderStyle Width="70px" />
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="txtWidth" Text="" CssClass="std" Style="width: 100%;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="70px">
                                    <HeaderStyle Width="70px" />
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="txtHeight" Text="" CssClass="std" Style="width: 100%;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderStyle Width="140px" />
                                    <ItemTemplate>
                                        <select runat="server" class="std" id="cboCrop" style="width: 100%; min-width: 140px;">
                                            <option value="0">Center</option>
                                            <option value="1">From upper left</option>
                                            <option value="2">From lower left</option>
                                            <option value="3">From lower right</option>
                                            <option value="4">From upper right</option>
                                            <option value="5" selected="selected">Keep aspect ratio</option>
                                            <option value="6">Fit image</option>
                                        </select>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderStyle Width="60px" />
                                    <ItemTemplate>
                                        <select runat="server" class="std" id="cboQuality" style="width: 100%; min-width: 60px;">
                                            <option value="10">10</option>
                                            <option value="20">20</option>
                                            <option value="30">30</option>
                                            <option value="40">40</option>
                                            <option value="50">50</option>
                                            <option value="60">60</option>
                                            <option value="70">70</option>
                                            <option value="80">80</option>
                                            <option value="90">90</option>
                                            <option value="100" selected="selected">100</option>
                                        </select>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-Width="20">
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="txtPostfix" Text="" CssClass="std" Style="width: 100%;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox runat="server" ID="txtSubfolder" Text="" CssClass="std" Style="width: 100%;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="20px">
                                    <HeaderStyle Width="20px" />
                                    <ItemTemplate>
                                        <i class="md md-error" style="display: none;" id="imgError" runat="server" title=""></i>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Width="20px">
                                    <HeaderStyle Width="20px" />
                                    <ItemTemplate>
                                        <span>
                                            <a href="javascript:void(0);" onclick="javascript:delThmb(this);">
                                                <i class="fa fa-times color-danger" title="<%= Translate.Translate("Delete")%>"></i>
                                            </a>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </div>
                </dwc:GroupBox>
                <%Translate.GetEditOnlineScript()%>
            </div>
        </Content>
        <Footer>
            <button class="btn btn-link waves-effect" type="button" onclick="save()">OK</button>
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Cancel</button>
        </Footer>
    </dwc:DialogLayout>
</body>
</html>
