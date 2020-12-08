<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CategoryEdit.aspx.vb" Inherits="Dynamicweb.Admin.BasicForum.CategoryEdit1" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link rel="stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript" src="js/message.js"></script>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "modules.dw8.forum.general.category.edit") %>
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dw:RibbonBar ID="CategoryBar" runat="server">
                <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Category" runat="server" Visible="true">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="btnSave" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="Category_Save" ShowWait="true" WaitTimeout="1000" />
                        <dw:RibbonBarButton ID="btnSaveAndClose" Text="Save and close" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="Category_SaveAndClose" ShowWait="true" WaitTimeout="1000" />
                        <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                        <dw:RibbonBarButton ID="btnDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="SettingsGroup" Name="Settings" runat="server">
                        <dw:RibbonBarButton ID="btnModerators" Text="Moderators" Title="Moderators" Icon="user" IconColor="Users" Size="Large" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Help" runat="server">
                        <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large" runat="server" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div class="list">
                <div id="breadcrumb" class="title" runat="server"></div>
            </div>

            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" ID="SettingsStart" DoTranslation="true" Title="Settings">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Navn" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="Name" runat="server" MaxLength="250" CssClass="NewUIinput" />
                                <asp:RequiredFieldValidator ID="required1" runat="server" ErrorMessage="*" ControlToValidate="Name"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Beskrivelse" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="Descr" runat="server" TextMode="MultiLine" Rows="6" CssClass="NewUIinput" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <dw:CheckBox Label="Active" FieldName="IsActive" ID="IsActive" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
