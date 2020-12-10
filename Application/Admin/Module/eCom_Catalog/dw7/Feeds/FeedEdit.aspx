<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="FeedEdit.aspx.vb" Inherits="Dynamicweb.Admin.FeedEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Ecommerce.Extensibility.Controls" Assembly="Dynamicweb.Ecommerce" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/NumberSelector.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/Feeds/FeedEdit.js"></dw:GenericResource>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <style type="text/css">
        .hide {
            display: none;
        }

        .query-props-group > div {
            padding-top: 4px;
        }

        .query-props-group .btn.restore {
            cursor: pointer;
            line-height: 20px;
            display: inline-block;
            height: 20px;
            color: #333333;
            border: 1px solid #d7dee8;
            background-color: #fafafa;
            margin-top: 4px;
            padding: 2px 4px;
        }

            .query-props-group .btn.restore:hover {
                background-color: #ddecff;
                border: 1px solid #bdcce0;
            }
    </style>
</head>
<body class="area-red">
    <div class="overlay-container" id="screenLoaderOverlay" style="display: none">
        <div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div>
    </div>
    <div class="screen-container">
        <div class="card">
            <ecom:Form ID="Form1" runat="server">
                <asp:HiddenField ID="viewFields" ClientIDMode="Static" runat="server" />
                <input type="hidden" id="Cmd" name="Cmd" />
                <input type="hidden" id="FeedIdHidden" runat="server" />
                <div class="content">
                    <dw:RibbonBar ID="PCMRibbon" runat="server">
                        <dw:RibbonBarTab ID="TabProducts" Name="Product" runat="server">
                            <dw:RibbonBarGroup Name="Tools" runat="server">
                                <dw:RibbonBarButton ID="btnSaveProduct" Text="Save" Icon="Save" Size="Small" runat="server" OnClientClick="backend.save();" />
                                <dw:RibbonBarButton ID="btnSaveAndCloseProduct" Text="Save and close" Icon="Save" Size="Small" runat="server" OnClientClick="backend.save(true);" />
                                <dw:RibbonBarButton ID="BtnCancel" Text="Cancel" Icon="TimesCircle" IconColor="Default" Size="Small" runat="server" ShowWait="true" OnClientClick="backend.cancel();" />
                                <dw:RibbonBarButton ID="BtnDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup Name="Help" runat="server" Visible="false">
                                <dw:RibbonBarButton runat="server" ID="Help" Text="Help" Size="Large" Icon="Help" OnClientClick="help();" />
                            </dw:RibbonBarGroup>
                        </dw:RibbonBarTab>
                    </dw:RibbonBar>

                    <dw:GroupBox runat="server" Title="Indstillinger" DoTranslation="true">
                        <dwc:InputText runat="server" ID="FeedName" Label="Name" ValidationMessage="" MaxLength="255" />
       <%--                 <dwc:RadioGroup runat="server" ID="FeedSource" Name="FeedSource" Label="Show">
                            <dwc:RadioButton runat="server" ID="IndexSource" Label="Index" FieldValue="Index" OnClick="GetSettings(this);" />
                        </dwc:RadioGroup>--%>
                    </dw:GroupBox>

                    <div id="ChannelsContainer" style="display: block;">
                        <dw:GroupBox runat="server" Title="Visning" DoTranslation="True">
                            <dwc:SelectPicker ID="ChannelsSelector" runat="server" Label="Channel"></dwc:SelectPicker>
                        </dw:GroupBox>
                    </div>

                    <div id="ProductListBox" style="display: none;">
                        <dw:GroupBox runat="server" Title="Grupper" DoTranslation="true">
                            <div class="dw-ctrl form-group radio-group" id="GroupSelector">
                                <label class="control-label"><%=Translate.Translate("Varegrupper")%></label>
                                <div class="form-group-input">
                                    <de:ProductsAndGroupsSelector runat="server" OnlyGroups="true" ShowSearches="true" ID="ProductAndGroupsSelector" CallerForm="Form1" Width="250px" Height="100px" />
                                </div>
                                <br />
                                <br />

                            </div>
                            <dwc:CheckBox runat="server" ID="IncludeSubgroups" Name="IncludeSubgroups" IsChecked="True" Label="Include subgroups" />
                        </dw:GroupBox>
                    </div>

                    <div id="ProductIndexBox" style="display: none;">
                        <dw:GroupBox runat="server" Title="Index">
                            <table class="formsTable">
                                <tr>
                                    <td>
                                        <dw:TranslateLabel runat="server" Text="Query" />
                                    </td>
                                    <td>
                                        <asp:Literal runat="server" ID="QuerySelectLiteral"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dw:TranslateLabel runat="server" Text="Override standard parameters" />
                                    </td>
                                    <td>
                                        <dw:EditableList ID="QueryConditions" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" EnableLegacyRendering="True" AllowAddNewRow="False" AllowDeleteRow="False" OnClientReady="backend.beforeParagraphSave();"></dw:EditableList>
                                        <div style="text-align: right">
                                            <span onclick="loadDefaultQueryParameters()" class="btn restore">
                                                <%=Translate.Translate("Reset")%>
                                            </span>
                                        </div>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dw:TranslateLabel runat="server" Text="Sort By" />
                                    </td>
                                    <td>
                                        <dw:EditableList ID="QuerySortByParams" runat="server" AllowPaging="true" AllowSorting="false" AutoGenerateColumns="false" EnableLegacyRendering="True"></dw:EditableList>
                                        <div style="text-align: right">
                                            <span onclick="loadDefaultSortByParams()" class="btn restore">
                                                <%=Translate.Translate("Reset")%>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </dw:GroupBox>
                    </div>

                    <dw:GroupBox runat="server" Title="Context" DoTranslation="true">
                        <dwc:CheckBoxGroup runat="server" ID="FeedLanguage" Name="FeedLanguage" Label="Language"></dwc:CheckBoxGroup>
                        <dwc:CheckBoxGroup runat="server" ID="FeedCurrency" Name="FeedCurrency" Label="Currency"></dwc:CheckBoxGroup>
                        <dwc:CheckBoxGroup runat="server" ID="FeedShop" Name="FeedShop" Label="Shop"></dwc:CheckBoxGroup>
                        <div class="dw-ctrl input-ctrl form-group">
                            <label class="control-label"><dw:TranslateLabel Text="User" runat="server" ID="userSelectorLabel" /></label>
	                        <div class="form-group-input">
                                <dw:EditableListColumnUserEditor ID="UserID_CustomSelector" runat="server" />
        	                </div>
                        </div>
                    </dw:GroupBox>

                    <dw:GroupBox runat="server" Title="Format" DoTranslation="True">
                        <asp:Literal ID="addInSelectorScripts" runat="server"></asp:Literal>
                        <de:AddInSelector ID="FeedAddInSelector" runat="server" AddInShowParameters="true" UseLabelAsName="True" AddInTypeName="Dynamicweb.Ecommerce.Feeds.FeedProvider" />
                        <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
                    </dw:GroupBox>

                    <dw:GroupBox runat="server" Title="Api Urls" DoTranslation="True">
                        <table id="ApiUrls" runat="server" class="formsTable">
                        </table>
                    </dw:GroupBox>
                </div>
            </ecom:Form>
        </div>
    </div>
</body>
</html>
