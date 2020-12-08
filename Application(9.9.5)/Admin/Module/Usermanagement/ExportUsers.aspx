<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ExportUsers.aspx.vb" Inherits="Dynamicweb.Admin.ExportUsers" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" IncludeUIStylesheet="true" />
    <style type="text/css">
        table.JobListTable {
            width: 100%;
            margin-left: 4px;
        }

        td.JobNameTD {
            width: 170px;
        }

        .columnsDiv{
            margin: 5px;position:absolute; right: 3px;top: 180px;bottom: 10px;left: 0px;
        }
        .columnsDiv.top{
            top: 33px !important;
        }
        
    </style>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script type="text/javascript">
        function showOverlay() {
            var o = new overlay('overlay'); o.show();
        }
        function hideOverlay() {
            var o = new overlay('overlay'); o.hide();
        }
        function exportUsers() {

            var rows = List.getSelectedRows('ColumnsList');
            var ret = '', id = '';
            if (rows && rows.length > 0) {
                for (var i = 0; i < rows.length; i++) {
                    id = rows[i].id;
                    if (id != null && id.length > 0) {
                        ret += (id.replace(/row/gi, '') + ',')
                    }
                }
            }
            if (ret.length > 0) {
                ret = ret.substring(0, ret.length - 1);
            }
            //document.location.href = "ExportUsers.aspx?action=exportUsers&jobName=" + jobName + "&ids=" + ret + "&GroupID=" + groupId + "&UseSmartSearch=" + useSmartSearch;
            $("action").value = "exportUsers";
            $("selectedMappings").value = ret;
            $("form1").submit();
        }

        function downloadFile(file) {
            var iframe = document.createElement("iframe");
            iframe.src = file;
            iframe.style.display = "none";
            document.body.appendChild(iframe);
            setTimeout("hideOverlay()", 3000);
        }                
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dw:Overlay ID="overlay" Message="Please wait" runat="server"></dw:Overlay>
        <asp:HiddenField ID="hdGroupID" runat="server" />
        <asp:HiddenField ID="hdUseSmartSearch" runat="server" />
        <input type="hidden" name="action" id="action" value="" />
        <input type="hidden" name="selectedMappings" id="selectedMappings" value="" />

        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton runat="server" ID="btnExport" Icon="SignOut" Text="Export users" OnClientClick="showOverlay();exportUsers();" />
        </dw:Toolbar>

        <div runat="server" id="divExportSettings">
            <dw:GroupBoxStart runat="server" Title="Export settings" />
            <table class="JobListTable">
                <tr>
                    <td class="JobNameTD">
                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Export users activity" />
                    </td>
                    <td>
                        <asp:DropDownList ID="jobsList" runat="server" OnSelectedIndexChanged="jobsList_SelectedIndexChanged" CssClass="NewUIinput" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <dw:GroupBoxEnd ID="GroupBoxEnd1" runat="server" />
        </div>
        <div runat="server" id="divDataColumnMapping">            
            <fieldset id="columnsDiv" class="columnsDiv">
                <script type="text/javascript">
                    if (!document.getElementById("divExportSettings") && document.getElementById("columnsDiv") != null) {
                        document.getElementById("columnsDiv").className = "columnsDiv top";
                    }
                </script>
                <legend class='gbTitle'>Data column mapping&nbsp;</legend>
                <dw:List ID="ColumnsList" runat="server" AllowMultiSelect="true" ShowTitle="false" PageSize="1000" ShowPaging="false" StretchContent="false">
                    <Columns>
                        <dw:ListColumn runat="server" ID="SourceColumn" Name="Source column" />
                        <dw:ListColumn runat="server" ID="DestinationColumn" Name="Destination column" />
                    </Columns>
                </dw:List>
                <dw:StretchedContainer Anchor="columnsDiv" ID="stretchedContainer" runat="server" Scroll="VerticalOnly" />                
            </fieldset>            
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
