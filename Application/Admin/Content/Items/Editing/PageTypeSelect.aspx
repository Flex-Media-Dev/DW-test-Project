<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PageTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.PageTypeSelect" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html>
<head>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />

    <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Content/JsLib/require.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/PageTypeSelect.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    <style>
        .large-icon {
            font-size: 64px;
        }

        .paragraphType {
            float: left;
            width: 256px;
            height: 192px;
            overflow: hidden;
            padding: 5px;
            text-align: center;
            cursor: pointer;
        }

            .paragraphType:hover {
                background-color: #f3f3f3;
            }

        .description {
            color: #cccccc;
        }

        .groupbox {
            border: none !important;
        }

        .itemImageContainer {
            align-items: center;
            display: flex;
            height: 140px;
            margin-bottom: 5px;
        }

        .itemImageContainer > img {
            margin: 0 auto;
        }
    </style>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dw:Overlay ID="ribbonOverlay" runat="server" Message="" ShowWaitAnimation="True" />

        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="New page" />

            <dwc:CardBody runat="server">
                <dwc:GroupBox ID="GroupBox1" runat="server" GroupWidth="6">
                    <div id="tabBlankPage" runat="server">
                        <div class="paragraphType" onclick="Dynamicweb.Items.PageTypeSelect.get_current().newPage(0);">
                            <span class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO)%>"></i></span>
                            <div>
                                <dw:TranslateLabel runat="server" Text="Blank page" />
                            </div>

                            <div class="description">
                                <small>
                                    <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Choose this to create a new blank page" />
                                </small>
                            </div>
                        </div>
                    </div>
                    <div id="colPageTemplates" runat="server">
                        <asp:Repeater ID="TemplatesRepeater" runat="server" EnableViewState="false" OnItemDataBound="TemplatesRepeater_ItemDataBound">
                            <ItemTemplate>
                                <div class="paragraphType" onclick="Dynamicweb.Items.PageTypeSelect.get_current().onPageTypeClick(<%#Eval("ID")%>);">
                                    <span id="templateIconSpan" runat="server" class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.FileO)%>"></i></span>
                                    <div id="templateImage" runat="server" class="itemImageContainer"></div>
                                    <div><%#Eval("Menutext")%></div>
                                    <div class="description"><small><%# If(Converter.ToString(Eval("TemplateDescription")).Length > 0, Eval("TemplateDescription"), "")%></small></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <div id="colItemTypes" runat="server">
                        <asp:Repeater ID="ItemTypeRepeater" runat="server" EnableViewState="false" OnItemDataBound="ItemTypeRepeater_ItemDataBound">
                            <ItemTemplate>
                                <div class="paragraphType" onclick="return Dynamicweb.Items.PageTypeSelect.get_current().onPageTypeClick('<%#Eval("SystemName")%>');">
                                    <span id="iconSpan" runat="server" class="large-icon"></span>
                                    <div id="itemImage" class="itemImageContainer" runat="server"></div>
                                    <div><%#Eval("Name")%></div>
                                    <div class="description"><small><%# If(Converter.ToString(Eval("Description")).Length > 0, Eval("Description"), "")%></small></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </dwc:GroupBox>

                <div class="centered-wrapper" id="MessageBlock" visible="False" runat="server">
                    <dw:TranslateLabel Text="No content is available." runat="server" />
                </div>
            </dwc:CardBody>
        </dwc:Card>

        <dw:Dialog ID="NewPageDialog" runat="server" Title="Ny side" ShowOkButton="true" ShowCancelButton="true" ShowClose="false" OkAction="Dynamicweb.Items.PageTypeSelect.get_current().newPageSubmit(); ">
            <div class="form-group">
                <label class="control-label" for="PageName">
                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Sidenavn" />
                </label>
                <div class="form-group-input">
                    <input type="text" runat="server" id="PageName" name="PageName" class="form-control" maxlength="255" />
                    <div id="rowBasedOn" class="m-t-5">
                        <dw:TranslateLabel runat="server" Text="Based on" />
                        <label id="ChosenTemplateName"></label>
                    </div>
                </div>
            </div>
            <dwc:RadioGroup runat="server" ID="PageOptions" Name="PageOptions" Label="Page status">
                <dwc:RadioButton runat="server" FieldValue="Published" Label="Published" />
                <dwc:RadioButton runat="server" FieldValue="Unpublished" Label="Unpublished" />
                <dwc:RadioButton runat="server" FieldValue="HideInMenu" Label="Hide in menu" />
            </dwc:RadioGroup>
        </dw:Dialog>

        <script type="text/javascript">
            Dynamicweb.Items.PageTypeSelect.get_current().set_parentPageId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("ParentPageID")) %>);
            Dynamicweb.Items.PageTypeSelect.get_current().set_areaId(<%=Converter.ToInt32(Dynamicweb.Context.Current.Request("AreaID"))%>);
            Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['SpecifyPageName'] = '<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>';
            Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['ItemType'] = '<%=Translate.JsTranslate("item type")%>';
            Dynamicweb.Items.PageTypeSelect.get_current().get_terminology()['Template'] = '<%=Translate.JsTranslate("page template")%>';
            Dynamicweb.Items.PageTypeSelect.get_current().initialize();
        </script>

        <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
    </div>
</body>
</html>
