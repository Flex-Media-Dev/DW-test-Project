<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditSubmit.aspx.vb" Inherits="Dynamicweb.Admin.EditSubmit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" IncludeScriptaculous="false" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "modules.basicforms.editsubmit")%>
        }

        function back() {
            location = "ListSubmits.aspx?formid=" + document.getElementById("formid").value;
        }
    </script>    
</head>

<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" id="formid" runat="server" />
            <input type="hidden" id="close" runat="server" />

            <div class="card-header">
                <h2>
                    <dw:TranslateLabel runat="server" Text="Submit" />
                </h2>
            </div>
            
            <dw:Toolbar runat="server">
                <dw:ToolbarButton runat="server" Text="Close" Size="Small" Icon="TimesCircle" ID="cmdCancel" OnClientClick="back();" ShowWait="true" WaitTimeout="500"></dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdHelp" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:ToolbarButton>
            </dw:Toolbar>

            <div id="breadcrumb">
                <dw:TranslateLabel Text="Formularer" runat="server" />
                &#187; <span id="breadcrumbTextFormname" runat="server"></span>
                &#187; <span id="breadcrumbTextSubmitdate" runat="server"></span>
            </div>

            <dw:GroupBox ID="GB_settings" runat="server" DoTranslation="True">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Dato" />
                        </td>
                        <td>
                            <span id="date" runat="server"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="IP" />
                        </td>
                        <td>
                            <span id="ip" runat="server"></span>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:GroupBox ID="optionsGroup" runat="server" DoTranslation="True" Visible="true" Title="Værdier">
                <div id="valuesTable" runat="server"></div>
            </dw:GroupBox>
        </form>
    </div>
    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
</body>
</html>
