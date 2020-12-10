<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GridRowEdit.aspx.vb" Inherits="Dynamicweb.Admin.GridRowEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludePrototype="true" IncludeScriptaculous="true" IncludeUIStylesheet="true" CombineOutput="false">
            <Items>
                <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
                <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
                <dw:GenericResource Url="/Admin/Content/Items/js/Preset.js" />
                <dw:GenericResource Url="/Admin/Link.js" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
                <dw:GenericResource Url="/Admin/Content/JsLib/dw/Validation.js" />
                <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="GridRowEdit.js"></script>
</head>
<body>
    <div class="card">
        <dw:Infobar runat="server" ID="infoGridIssue" DisplayType="Warning" TranslateMessage="false" Visible="false"></dw:Infobar>
        <form id="MainForm" runat="server" action="GridRowEdit.aspx" method="post">
            <input type="hidden" name="cmd" id="cmd" value="" />
            <input type="hidden" name="SelectedItemType" id="SelectedItemType" value="" runat="server" />
            <input type="hidden" name="PageID" value="<%=pageId %>" />
            <input type="hidden" name="ID" value="<%=gridrowId %>" />
            <input type="hidden" name="SortIndex" value="<%=sortIndex %>" />
            <input type="hidden" name="GridId" value="<%=gridId %>" />
            <input type="hidden" name="Container" value="<%=container %>" />
            <input type="hidden" name="VisualEditor" value="<%=Dynamicweb.Context.Current.Request("VisualEditor") %>" />

            <% If Not Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("VisualEditor")) Then %>
            <div style="min-width: 770px; overflow: hidden" id="ribbonContainer">
                <dw:RibbonBar runat="server" ID="myribbon">
                    <dw:RibbonBarTab Active="true" Name="Content" runat="server">
                        <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Funktioner" Visible="true">
                            <dw:RibbonBarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Icon="Save" OnClientClick="document.forms[0].submit();" ID="Save" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" ID="SaveAndClose" OnClientClick="document.forms[0].submit();" ShowWait="true" WaitTimeout="500">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>
            </div>
            <% End If %>

            <dw:GroupBox runat="server" Title="Definition">
                <table id="formTable" class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Definition" />
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlDefinition"></asp:DropDownList>
                            <dw:Label runat="server" ID="StaticDefinitionLabel" ></dw:Label>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <div id="content-item">
                <asp:Literal ID="litFields" runat="server" />
            </div>

            <dwc:GroupBox ID="PublicationGroupBox" runat="server" Title="Publication period" IsCollapsed="true" Expandable="true">    
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="From" runat="server" />
                        </td>
                        <td>
                            <dw:DateSelector runat="server" EnableViewState="false" ID="RowValidFrom" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="To" runat="server" />
                        </td>
                        <td>
                            <dw:DateSelector runat="server" EnableViewState="false" ID="RowValidTo" />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="AccessibilityGroupBox" runat="server" Title="Accessibility" IsCollapsed="true" Expandable="true">
                  <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Devices" />                           
                        </td>
                        <td>
                            <dw:CheckBox runat="server" ID="HideForPhones" />
                            <label for="HideForPhones">
                                <dw:TranslateLabel runat="server" Text="Hide row for phones" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>                            
                            <dw:CheckBox runat="server" ID="HideForTablets" />
                            <label for="HideForTablets">
                                <dw:TranslateLabel runat="server" Text="Hide row for tablets" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="HideForDesktops" />
                            <label for="HideForDesktops">
                                <dw:TranslateLabel runat="server" Text="Hide row for desktops" />
                            </label>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dw:Overlay ID="spinner" runat="server" Message="Please wait..." ShowWaitAnimation="True"></dw:Overlay>
        </form>
    </div>
</body>
</html>
