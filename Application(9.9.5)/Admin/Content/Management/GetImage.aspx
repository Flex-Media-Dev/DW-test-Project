<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GetImage.aspx.vb" Inherits="Dynamicweb.Admin.GetImage" Async="true" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>
<html>
<head>
    <title>Get image</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <script type="text/javascript">
        function formSubmit(targetVal) {
            var form = document.forms[0];
            var hidden = document.createElement("input");
            hidden.type = 'hidden';
            hidden.name = "__EVENTTARGET";
            hidden.value = targetVal;
            form.appendChild(hidden);
            document.forms[0].submit();
        }

        document.observe("dom:loaded", function () {
            $("Format").observe("change", function () {
                formSubmit("Format");
            });
        });

        function showStartFrame() {
            location = '/Admin/Blank.aspx';
        }

        function help() {
            <%= Gui.HelpPopup("", "administration.managementcenter.designer.imagehandler") %>
        }
    </script>
</head>
<body class="area-black screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Image handler"></dwc:CardHeader>
                <input type="hidden" id="DoSaveAndClose" name="DoSaveAndClose" />
                <input type="hidden" id="DoSave" name="DoSave" />
                <dw:Toolbar ID="Toolbar" runat="server" ShowEnd="false">
                    <dw:ToolbarButton ID="ButtonHelp" runat="server" Icon="Help" Text="Help" OnClientClick="help();" />
                </dw:Toolbar>

                <dwc:GroupBox Title="General" runat="server">
                    <dw:FileManager Label="File" ID="Image" ShowPreview="false" Name="fmImage" Extensions="jpg,png,gif,jpeg,bmp,webp" ShowOnlyAllowedExtensions="true" runat="server" FullPath="true" />
                    <div class="form-group">
                        <label class="control-label">&nbsp;</label>
                        <div class="form-group-input">
                            <asp:Label ID="ValidImageFile" runat="server" Text="Specify image file" Style="display: none;"></asp:Label>
                        </div>
                    </div>

                    <dw:FileManager Label="Alternative file" ID="AlternativeImage" ShowPreview="false" Name="altFmImage" Extensions="jpg,png,gif,jpeg,bmp,webp" ShowOnlyAllowedExtensions="true" runat="server" FullPath="true" />
                    <dwc:InputNumber Label="Width" ID="Width" runat="server">
                    <AddOns>
                        <dwc:FieldAddOn Text="px"></dwc:FieldAddOn>
                    </AddOns>
                    </dwc:InputNumber>
                    <dwc:InputNumber Label="Height" ID="Height" runat="server">
                    <AddOns>
                        <dwc:FieldAddOn Text="px"></dwc:FieldAddOn>
                    </AddOns>
                    </dwc:InputNumber>
                </dwc:GroupBox>

                <dwc:GroupBox Title="Image" runat="server">
                    <dwc:SelectPicker Label="Color mode" ID="ColorSpace" runat="server">
                        <asp:ListItem Text="RGB" Value="RGB" />
                        <asp:ListItem Text="CMYK" Value="CMYK" />
                        <asp:ListItem Text="Gray scale" Value="Grayscale" />
                    </dwc:SelectPicker>

                    <dwc:SelectPicker Label="Crop offset" ID="Crop" runat="server">
                        <asp:ListItem Text="Center" Value="0" />
                        <asp:ListItem Text="From lower left" Value="1" />
                        <asp:ListItem Text="From upper left" Value="2" />
                        <asp:ListItem Text="From upper right" Value="3" />
                        <asp:ListItem Text="From lower right" Value="4" />
                        <asp:ListItem Text="Keep aspect ratio" Value="5" />
                        <asp:ListItem Text="Fit image" Value="6" />
                    </dwc:SelectPicker>

                    <dwc:SelectPicker Label="Format" ID="Format" runat="server">
                        <asp:ListItem Text="JPEG" Value="jpg" />
                        <asp:ListItem Text="GIF" Value="gif" />
                        <asp:ListItem Text="PNG" Value="png" />
                        <asp:ListItem Text="TIFF" Value="tiff" />
                        <asp:ListItem Text="BMP" Value="bmp" />
                        <asp:ListItem Text="PSD" Value="psd" />
                        <asp:ListItem Text="PDF" Value="pdf" />
                        <asp:ListItem Text="WEBP" Value="webp" />
                    </dwc:SelectPicker>

                    <div id="rowJPEG" runat="server">
                        <dwc:InputNumber Label="Compression" Info="% (1-99)" ID="Compression" runat="server" />
                    </div>
                    <div id="rowWEBP" runat="server">
                        <dwc:InputNumber Label="Quality" Info="% (1-99)" ID="Quality" runat="server" />
                    </div>
                    <div id="rowGIF" runat="server">
                        <dwc:InputText Label="Colors" ID="Colors" runat="server" />
                    </div>
                    <dwc:InputNumber Label="Resolution" Info="dpi (Recommended: 72-300)" ID="Resolution" runat="server" />
                    <dwc:CheckBox ID="fillcanvas" Name="fillcanvas" Label="Fill canvas" Info="If width and height is specified and the crop mode is set to Keep aspect ratio, the image will be resized to fit in the defined box. If this flag is set, the remainder of the specified view box will be filled with white. Color can be overridden below." runat="server" />
                    <dw:ColorSelect runat="server" ID="Background" Label="Background" Info="Applied to transperent png" />
                    <dwc:CheckBox ID="DoNotUpscale" Name="DoNotUpscale" Label="Do not upscale" Info="" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox Title="Miscellaneous" runat="server">
                    <dwc:InputText ID="Filename" Label="File name" runat="server" />
                    <dwc:CheckBox ID="ForceDownload" Label="Download" Name="ForceDownload" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox Title="Results" runat="server">
                    <dwc:InputText ID="txURL" Label="Image URL" runat="server" />
                    <dwc:InputText ID="txtSRC" Label="Image SRC" runat="server" />
                    <div class="dw-ctrl textbox-ctrl form-group">
                        <label class="control-label">&nbsp;</label>
                        <div class="form-group-input">
                            <div id="imagewrap" runat="server" visible="false" style="border:1px solid #ff6a00;display:inline-block"><asp:Image ID="imgImage" runat="server" Visible="false" /></div>
                        </div>
                    </div>
                    <dwc:Button ID="cmdOK" OnClick="formSubmit('cmdOK');" runat="server" Title="Get image URL" />
                </dwc:GroupBox>
            </dwc:Card>
        </form>
    </div>

    <script type="text/javascript">
        // Do close?
        if ('<%=DoClose %>' == 'True')
            showStartFrame();

        // Init the save-flag
        $('DoSaveAndClose').value = 'False';
        $('DoSave').value = 'False';
    </script>
</body>
</html>
