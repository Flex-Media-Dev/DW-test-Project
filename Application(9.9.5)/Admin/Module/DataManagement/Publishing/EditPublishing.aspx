<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditPublishing.aspx.vb" Inherits="Dynamicweb.Admin.EditPublishing" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="expires" content="Wed, 20 Feb 2000 08:30:00 GMT" />
    <meta http-equiv="Pragma" content="no-cache" />

    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="EditPublishing.js" />
            <dw:GenericResource Url="EditPublishing.css" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var _id = <%=_id%>;
        var doPreview = "<%=doPreview %>" == "True" ? true : false;
        var _cmd = "<%=_cmd%>";
        var _txt1 = '<%=Translate.JsTranslate("Udfyld venligst navn!")%>';
        var _txt2 = '<%=Translate.JsTranslate("This will save the publishing. Are you sure you want to see a preview?")%>';
        var txtConfirmMessage = '<%=Translate.JsTranslate("When saving a publishing, you will overwrite the existing templates.\nTo overwrite and backup click 'OK'.\nTo keep the existing templates click 'Cancel'.") %>';
        var helpLang = "<%=helpLang %>";
        var _alertNoSource = '<%=Translate.JsTranslate("Please, select data list")%>';
    
        InitSettings(_id, _cmd, _txt1, _txt2, _alertNoSource);
    </script>
</head>
<body class="screen-container" onload="doInit();">
    <dwc:Card runat="server">
        <form id="Form1" runat="server">
            <input type="hidden" value="<%=_id%>" name="ID" id="ID" />

            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="XML Publishing">
                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();" ID="Save" />
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="SaveAndClose" />
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup11" runat="server" Name="Preview">
                        <dw:RibbonBarCheckbox OnClientClick="previewPublishing();" ID="preBut1" runat="server" Text="Preview" Icon="PageView" Size="Large" RenderAs="Default" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="HelpBut" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <dwc:CardBody runat="server">
                <div id="SettingLayer">
                    <dwc:GroupBox ID="GroupBox1" runat="server" DoTranslation="true" Title="Indstillinger">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Name" />
                                </td>
                                <td>
                                    <asp:TextBox ID="pubName" runat="server" CssClass="NewUIinput" MaxLength="255"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Data list" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="pubView" runat="server" CssClass="NewUIinput" />
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>

                    <div id="xml_1" style="">
                        <dwc:GroupBox ID="GroupBox3" runat="server" DoTranslation="true" Title="XML">
                            <table class="formsTable">
                                <tr>
                                    <td>
                                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="XSLT" />
                                    </td>
                                    <td>
                                        <dw:FileManager runat="server" Name="pubXSLT" ID="pubXSLT" Folder="Templates/DataManagement/XSLT/Publishing" ShowPreview="false" CssClass="NewUIinput" FullPath="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="URL" />
                                    </td>
                                    <td>
                                        <asp:Literal runat="server" ID="xmlLink"></asp:Literal>
                                        <input type="hidden" id="xmlURL" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </dwc:GroupBox>
                    </div>
                </div>
                <!-- END SETTING -->
            </dwc:CardBody>

            <iframe src="about:blank" id="ContentSaveFrame" name="ContentSaveFrame" width="100%" frameborder="0" height="0" style="height: 0px;"></iframe>
        </form>
    </dwc:Card>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
