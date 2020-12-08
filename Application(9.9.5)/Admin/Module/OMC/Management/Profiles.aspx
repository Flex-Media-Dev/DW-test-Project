<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Content/Management/EntryContent2.Master" CodeBehind="Profiles.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.Profiles" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%=Dynamicweb.SystemTools.Gui.WriteFolderManagerScript()%>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            document.frmGlobalSettings.submit();
        }
    </script>

    <!--[if IE]>
    <style type="text/css">
        .omc-account select
        {
            width: 254px;
        }
    </style>
    <![endif]-->
</asp:Content>
<asp:Content  ContentPlaceHolderID="MainContent" runat="server">
    <div id="PageContent" class="omc-control-panel">
        <dw:GroupBox ID="gbProfileDynamics" Title="Profile dynamics" runat="server">
            <div style="height: 10px"></div>
            <table border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td style="width: 170px" valign="top">
                        <dw:TranslateLabel ID="lbProfileCalculation" Text="Add profile points" runat="server" />
                    </td>
                    <td valign="top">
                        <ul class="omc-cpl-list">
                            <li class="omc-cpl-list-field">
                                <input id="chkPerSession" type="radio" name="/Globalsettings/Modules/OMC/ProfileDynamicsRecalculateMode" value="Static" <%=If(HasProfileDynamicsMode("Static", True), "checked=""checked""", String.Empty)%> />
                                <label for="chkPerSession"><dw:TranslateLabel ID="lbPerSession" Text="On every new visitor session" runat="server" /></label>
                                <div class="omc-clear"></div>
                            </li>
                            <li class="omc-cpl-list-field">
                                <input id="chkPerRequest" type="radio" name="/Globalsettings/Modules/OMC/ProfileDynamicsRecalculateMode" value="Cumulative" <%=If(HasProfileDynamicsMode("Cumulative", False), "checked=""checked""", String.Empty)%> />
                                <label for="chkPerRequest"><dw:TranslateLabel ID="lbPerRequest" Text="On every new request" runat="server" /></label>
                                <div class="omc-clear"></div>
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>

</asp:Content>