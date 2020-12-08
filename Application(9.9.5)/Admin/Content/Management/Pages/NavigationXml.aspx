<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NavigationXml.aspx.vb"
    Inherits="Dynamicweb.Admin.NavigationXml" %>
<%@ Import namespace="System.Data" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Navigation XML</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <script language="javascript" type="text/javascript">

        function hideSubitem() {
            $('ParentTypesCell').select('[name="ParentType"]').each(function (s) {
                if (s.checked && s.value == "2") {
                    $('TemplateMenuParentIDRow').style.display = '';
                }
                else {
                    $('TemplateMenuParentIDRow').style.display = 'none';
                }
            });
        };


        function showStartFrame() {
            location = '/Admin/Blank.aspx';
        }

        function help() {
            <%=Dynamicweb.SystemTools.Gui.Help("", "administration.managementcenter.designer.navigationxml") %>
        }

        function setParentType(obj){
            hideSubitem();
            $('ParentType').value = obj.value ;
        }

        function setMenuThreadID(obj){
            $('MenuThreadID').value = obj.value;
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <input type="hidden" id="DoGenerateXML" name="DoGenerateXML" />
    <dw:Toolbar ID="Toolbar" runat="server" ShowEnd="false">
        <dw:ToolbarButton ID="ButtonHelp" runat="server" Image="Help" Text="Help" OnClientClick="help();" />
    </dw:Toolbar>
    <h2 class="subtitle">
        <dw:TranslateLabel ID="TranslateLabel1" Text="Navigation XML" runat="server" />
    </h2>
    <div>
    </div>
    <dw:GroupBoxStart doTranslation="False" ID="GroupBoxStart1" Title="Settings" runat="server" />
    <table >
        <tr>
            <td  width="150">
                <dw:TranslateLabel ID="TranslateLabel8" Text="Website" runat="server" />
            </td>
            <td>
                <asp:DropDownList ID="Website" CssClass="std" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
        <tr >
            <td valign="top" width="150"><%=Translate.Translate("Fold ud")%></td>
            <td id="TemplateMenuThreadsCell" runat="server"></td>
            <input type="hidden" id="MenuThreadID" name="MenuThreadID" />
        </tr>
        <tr>
            <td valign="top" id="TemplateMenuThreadParentTxt" width="150"><%=Translate.Translate("Overmenu")%></td>
            <td id="ParentTypesCell" runat="server"> </td>
        </tr>
        <tr id="TemplateMenuParentIDRow" >
            <td width="150">
                <%= Translate.Translate("Underpunkter til side")%>
            </td>
            <td><%=Dynamicweb.SystemTools.Gui.LinkManager(TemplateMenuParentID, "TemplateMenuParentID", "")%></td>
        </tr>
        <tr id="TemplateMenuStartLevelRow" >
            <td width="150">
                <%=Translate.Translate("Første niveau")%>
            </td>
            <td>
                <%=Dynamicweb.SystemTools.Gui.SpacListExt(TemplateMenuStartLevel, "TemplateMenuStartLevel", 1, 15, 1, "", False, 95, 999, "")%>
            </td>
        </tr>
        <tr id="TemplateMenuStopLevelRow">
            <td width="150">
                <%=Translate.Translate("Sidste niveau")%>
            </td>
            <td>
                <%=Dynamicweb.SystemTools.Gui.SpacListExt(TemplateMenuStopLevel, "TemplateMenuStopLevel", 1, 15, 1, "", False, 95, 999, Translate.Translate("Ikke valgt"))%>
            </td>
        </tr>
        <tr id="TemplateMenuXSLTTemplateRow">
            <td  width="150">
                <%=Translate.Translate("XSLT")%>
            </td>
            <td>
                <%=Dynamicweb.SystemTools.Gui.FileManager(TemplateMenuXSLTTemplate, "Templates/Navigation", "TemplateMenuXSLTTemplate", "xsl,xslt", false)%>
            </td>
        </tr>
    </table>
    <dw:GroupBoxEnd ID="GroupBoxEnd1" runat="server" />
    </form>
    <% Translate.GetEditOnlineScript()%>
    <script type="text/javascript">
        // Do close?
        if ('<%=DoClose %>' == 'True')
            showStartFrame();

        // Init the save-flag
        $('DoSaveAndClose').value = 'False';
        $('DoSave').value = 'False';
        $('DoGenerateXML').value = 'False';

        $('TemplateMenuThreadsCell').select('[name="TemplateMenuThread"]').each(function (s) {
            if (s.checked) {
                $('MenuThreadID').value = s.value;
            }
        });

        hideSubitem();
    </script>
</body>
</html>
