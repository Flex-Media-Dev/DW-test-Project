<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImportUsers.aspx.vb" Inherits="Dynamicweb.Admin.ImportUsers" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true" />
    <style type="text/css">
        table.JobListTable {
            width: 100%;
            margin-left: 4px;
        }

        td.JobNameTD {
            width: 170px;
        }        

        .columnsDiv{
            margin: 5px;position:absolute; right: 3px;top: 193px;bottom: 10px;left: 0px;
        }      
        .hidden{
            display: none;
        }          
    </style>
    <script type="text/javascript">
        function showOverlay() {
            var o = new overlay('overlay'); o.show();
        }
        function hideOverlay() {
            var o = new overlay('overlay'); o.hide();
        }

        function importUsers() {
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
            $("action").value = "importUsers";
            $("selectedMappings").value = ret;
            $("form1").submit();
        }

        document.addEventListener("DOMContentLoaded", function () {
            hideInfoBar();
            setTimeout(AddFileCheckEvent, 500);
        });

        function AddFileCheckEvent() {
            if ($('Users_input_file_path') == null)
                setTimeout(AddFileCheckEvent, 500);
            else {
                $('Users_input_file_path').onchange = function (event) {
                    CheckCSVEncoding();
                };
            }
        }

        function CheckCSVEncoding() {
            hideInfoBar();            
            var url = "ImportUsers.aspx?cmd=CheckEncoding&File=" + encodeURIComponent($('FM_Users_input_file').getValue());

            new Ajax.Request(url, {
                method: 'get',
                onSuccess: function (response) {
                    if (response.responseText == "false") {
                        $('InfoBar_<%=Me.infoEncoding.ClientID%>').className = "infobar";                        
                    }
                    else {
                        hideInfoBar();
                    }
                }
            });
        }
        
        function hideInfoBar() {            
            $('InfoBar_<%=Me.infoEncoding.ClientID%>').className = "hidden";            
        }
    </script>    
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdGroupID" runat="server" />
        <input type="hidden" name="action" id="action" value="" />
        <input type="hidden" name="selectedMappings" id="selectedMappings" value="" />
        <dw:Overlay ID="overlay" Message="Please wait" runat="server"></dw:Overlay>
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
            <dw:ToolbarButton runat="server" ID="btnImport" Icon="SignIn" Text="Import users" OnClientClick="showOverlay();importUsers();" />
        </dw:Toolbar>

        <dw:Infobar ID="infoEncoding" CssClass="hidden" runat="server" Message="File not in UTF8 encoding." Type="Warning" ClientIDMode="Static" />

        <div>
            <dw:GroupBoxStart ID="GroupBoxStart1" runat="server" Title="Import settings" />
            <table class="JobListTable" runat="server" id="tableImportActivity">
                <tr>
                    <td class="JobNameTD">
                        <dw:TranslateLabel runat="server" Text="Import users activity" />
                    </td>
                    <td>
                        <asp:DropDownList ID="jobsList" runat="server" OnSelectedIndexChanged="jobsList_SelectedIndexChanged" CssClass="NewUIinput" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            <asp:Literal ID="addInSelectorScripts" runat="server"></asp:Literal>
            <de:AddInSelector ID="addInSelector" runat="server" AddInShowParameters="true" UseLabelAsName="True" AddInShowNothingSelected="false"
                AddInShowSelector="false" AddInTypeName="Dynamicweb.DataIntegration.Providers.ModuleSpecificIntegrations.ModuleSpecificIntegrationBase"                                   
                AddInSelectedType="Dynamicweb.DataIntegration.Providers.ModuleSpecificIntegrations.UserImportAddIn.UserImportAddIn" AddInShowFieldset="false" />
            <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
            <dw:GroupBoxEnd ID="GroupBoxEnd1" runat="server" />
        </div>

        <div runat="server" id="divDataColumnMapping">            
            <fieldset id="columnsDiv" class="columnsDiv">                
                <legend class='gbTitle'>Data column mapping&nbsp;</legend>
                <dw:List ID="ColumnsList" runat="server" AllowMultiSelect="true" Title="Data column mapping" PageSize="1000" ShowPaging="false" StretchContent="false">
                    <Columns>
                        <dw:ListColumn runat="server" ID="SourceColumn" Name="Source column" />
                        <dw:ListColumn runat="server" ID="DestinationColumn" Name="Destination column" />
                    </Columns>
                </dw:List>
                <dw:StretchedContainer Anchor="columnsDiv" ID="stretchedContainer" runat="server" Scroll="VerticalOnly" />                
            </fieldset>            
        </div>        

        <dw:Dialog ID="errorLogDialog" runat="server" Size="Large" Title="Import log" TranslateTitle="true">
            <div>
                <dw:List ID="errorList" runat="server" Height="512" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn ID="clmLastTime" runat="server" Name="Time" Width="160" EnableSorting="True"></dw:ListColumn>
                        <dw:ListColumn ID="clmLastMessage" runat="server" Name="Message"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </div>
        </dw:Dialog>        
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
