<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Category_edit.aspx.vb" Inherits="Dynamicweb.Admin.NewsV2.Category_edit" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Edit_category</title>
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
    </dw:ControlResources>

    <link rel="Stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/main.js"></script>
    <script type="text/javascript" src="js/category.js"></script>
    <script type="text/javascript">
        function Reload(categoryID) {
            var newwin = window.open("TreeView.aspx?categoryID=" + categoryID, "ContentCell");
            var newwin = window.open("News_list.aspx?categoryID=" + categoryID, "ListRight");
        }

        function Subm() {
            var gc = '<%=Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Configuration.SystemConfiguration.Instance.GetValue("/Globalsettings/Modules/Users/UseExtendedComponent"))%>';
            if (gc == "" || gc == "False") {
                if ($('AccessUserGroups')) {
                    for (i = 0; i < $('AccessUserGroups').options.length; i++) {
                        $('AccessUserGroups').options[i].selected = true;
                    }
                }
            }
        }

        function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("newsv2", "modules.newsv2.general.category.edit")%>
        }
    </script>
</head>
<body class="area-deeppurple screen-container">
    <form method="post" runat="server" id="Form1" class="formNews">
        <div style="min-width: 500px; overflow: hidden;">
            <dw:RibbonBar ID="NewsBar" runat="server">
                <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Content" runat="server" Visible="true">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="btnSaveCategory" Text="Save" Title="Save" Icon="Save"
                            Size="Small" runat="server" EnableServerClick="true" OnClientClick="Subm();"
                            OnClick="Category_Save" />
                        <dw:RibbonBarButton ID="btnSaveAndCloseCategory" Text="Save and close" OnClientClick="Subm();"
                            Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="Category_SaveAndClose" />
                        <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server"
                            EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                        <dw:RibbonBarButton ID="DeleteButton" Text="Delete" Icon="Delete"
                            Size="Small" runat="server" PerformValidation="false" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="SettingsGroup" Name="Settings" runat="server">
                        <dw:RibbonBarButton ID="Permissions" Text="Permissions" Title="Permissions" Icon="Lock"
                            Size="Large" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Help" runat="server">
                        <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large"
                            runat="server" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <div class="card">
                <div class="list">
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="title">
                                <%=GetBreadcrumb() %>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="Tab1">
                    <table border="0" cellpadding="2" cellspacing="0">
                        <tr valign="top">
                            <td colspan="2">
                                <dw:GroupBoxStart runat="server" ID="Gb1" Title="Settings" />
                                <table border="0" cellpadding="2" cellspacing="0">
                                    <tr>
                                        <td class="leftCol">
                                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Name" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="NameCat" CssClass="std" MaxLength="255" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:RequiredFieldValidator ID="NameValidator" runat="server" ErrorMessage="required"
                                                ControlToValidate="NameCat"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="leftColHigh">
                                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Description" />
                                        </td>
                                        <td>
                                            <asp:TextBox ID="DescriptionCat" CssClass="std" TextMode="MultiLine" Rows="3" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="leftColHigh">
                                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Fields group" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="DropDownGroup" CssClass="std" runat="server">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                                <dw:GroupBoxEnd ID="EndGb1" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <% Translate.GetEditOnlineScript()%>
    </form>
</body>
</html>
