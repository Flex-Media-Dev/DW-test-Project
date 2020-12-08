<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="ExcludedCompanies.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.ExcludedCompanies" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/LeadsList.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/LeadsList.css" />
            <dw:GenericResource Url="/Admin/Resources/css/dw8omcstylefix.min.css" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        function save(close) {

            /* Show spinning wheel*/
            var o = new overlay('wait');
            o.show();

            if (close) {
                document.getElementById('saveAndClose').value = 'True';
            }

            document.getElementById('cmdSubmit').click();
        }
        function cancel() {
            <%=GetNavigateToDashboardAction.ToString()%>
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <input type="hidden" id="Cmd" name="Cmd" />
            <asp:HiddenField ID="AddedKnownProviders" ClientIDMode="Static" runat="server" Value="" />
            <dwc:Card runat="server">                    
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="save(true);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" Text="Cancel" runat="server" OnClientClick="cancel();" />
                </dw:Toolbar>
                <dwc:GroupBox ID="gbIgnoreProviders" Title="Excluded companies" runat="server">
                    <table class="formsTable">
                        <tr>
                            <td colspan="2" class="omc-cpl-hint">
                                <dw:TranslateLabel ID="lbIgnoreListCalculation" Text="Here you can specify company names that can be applied as filter in Lead Management tool." runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 170px" valign="top" style="padding-top: 4px">
                                <dw:TranslateLabel ID="lbISPList" Text="Companies" runat="server" />
                            </td>
                            <td>
                                <omc:EditableListBox ID="excludedCompanies" RequestKey="/Globalsettings/Modules/OMC/IgnoreProviders"
                                    SelectedItems="<%$ GS: (System.String[]) /Globalsettings/Modules/OMC/IgnoreProviders  %>" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
                <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
                <input type="hidden" id="saveAndClose" name="saveAndClose" value="" />

                <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
