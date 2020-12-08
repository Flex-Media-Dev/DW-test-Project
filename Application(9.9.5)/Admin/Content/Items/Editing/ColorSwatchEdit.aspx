<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ColorSwatchEdit.aspx.vb" Inherits="Dynamicweb.Admin.ColorSwatchEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludejQuery="true">
        <Items>          
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" /> 
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Resources/vendors/color-thief/color-thief.min.js" />
        </Items>
    </dw:ControlResources>
    <link rel="stylesheet" href="/Admin/Content/Items/css/ColorSwatchEdit.css" />
    <script type="text/javascript" src="/Admin/Content/Items/js/ColorSwatchEdit.js"></script>
    <script type="text/javascript">
        jQuery.noConflict();
        var currentPage = null;

        document.addEventListener('DOMContentLoaded', function () {
            currentPage = new ColorSwatchEdit({
                BusinessPalettes: <%= BusinessPalettes %>,
                OptionNone: "<%= Translate.Translate("None") %>",
                CountOfColors: <%= CountOfColors %>
            });
        });
    </script>
</head>
<body>
<dwc:DialogLayout runat="server" ID="ColorSwatchEdit" Title="Select colors" Size="Large" HidePadding="True">
    <Content>
        <div class="col-md-0">
            <dwc:GroupBox runat="server" ClassName="m-b-0">
                <div class="row">
                    <div class="col-md-6">
                        <dwc:SelectPicker runat="server" ID="MethodSelectPicker" Label="Method" onchange="currentPage.changeMethod();">
                            <asp:ListItem Text="None" Value="" />
                            <asp:ListItem Text="Color guide" Value="ColorGuide" />
                            <asp:ListItem Text="Based on image" Value="ImageMethod" />
                            <asp:ListItem Text="Business palette" Value="BusinessPalette" />
                        </dwc:SelectPicker>
                    </div>
                </div>
            </dwc:GroupBox>
            <div class="flexbox">
                <div class="flexbox__column flexbox__column--bordered">
                    <dwc:GroupBox runat="server" ClassName="m-b-0">
                        <div id="ColorGuideMethod" class="hidden">
                            <legend class="gbTitle"><dw:TranslateLabel runat="server" Text="Color guide" /></legend> 
                            <dw:ColorSelect ID="BaseColor" runat="server" Label="Set the base color" />
                            <dwc:SelectPicker runat="server" ID="PaletteSelectPicker" Label="Palette" onchange="currentPage.calculateColorGuide();">
                                <asp:ListItem Text="Analogous" Value="Analogous" />
                                <asp:ListItem Text="Monochromatic" Value="Monochromatic" />
                                <asp:ListItem Text="Triad" Value="Triadic" />
                                <asp:ListItem Text="Complementary" Value="Complementary" />
                                <asp:ListItem Text="Compound" Value="Compound" />
                                <asp:ListItem Text="Shades" Value="Shades" />
                            </dwc:SelectPicker>
                        </div>
                        <div id="ColorImageMethod" class="hidden">
                            <legend class="gbTitle"><dw:TranslateLabel runat="server" Text="Based on image" /></legend>  
                            <dw:FileManager runat="server" ID="ImageSelector" Folder="/images" Label="Select an image" />
                        </div>
                        <div id="BusinessPaletteMethod" class="hidden">
                            <legend class="gbTitle"><dw:TranslateLabel runat="server" Text="Business palette" /></legend>  
                            <dwc:SelectPicker runat="server" ID="BusinessPaletteType" Label="Type" onchange="currentPage.changeBusinessPaletteType();"></dwc:SelectPicker>
                            <dwc:SelectPicker runat="server" ID="BusinessPalette" Label="Palettes" onchange="currentPage.calculateBusinessPalette();"></dwc:SelectPicker>
                        </div>
                    </dwc:GroupBox>
                </div>
                <div class="flexbox__column">
                    <dwc:GroupBox runat="server" ClassName="m-b-0" Title="Neutral color guide">
                        <dwc:SelectPicker runat="server" ID="NeutralBaseSelectPicker" Label="Base neutral on">
                            <asp:ListItem Text="None" Value="" />
                        </dwc:SelectPicker>
                    </dwc:GroupBox>
                </div>
            </div>
            <div class="flexbox">
                <div class="flexbox__column flexbox__column--bordered">
                    <dwc:GroupBox runat="server" ID="BrandColorsSection" ClassName="m-b-0 sortable" Title="Suggested brand colors">
                    </dwc:GroupBox>
                </div>
                <div class="flexbox__column">
                    <dwc:GroupBox runat="server" ID="NeutralColorsSection" ClassName="m-b-0 sortable" Title="Suggested neutral colors">
                    </dwc:GroupBox>
                </div>
            </div>
        </div>
    </Content>
    <Footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Submit'})" id="SaveButton" runat="server"><dw:TranslateLabel runat="server" Text="Save" /></button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})"><dw:TranslateLabel runat="server" Text="Cancel" /></button>
    </Footer>
</dwc:DialogLayout>
</body>
</html>
