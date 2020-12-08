<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RenameLead.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.Details.RenameLead" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <script type="text/javascript">
        function submitForm(params) {
            if ((params && params.Delete) && !confirm('<%=Translate.JsTranslate("Are you sure you want to delete this renamed lead?")%>')) {
                return;
            }
            $('renameLeadForm').request({
                method: 'post',
                parameters: params,
                onSuccess: function (transport) {
                    if (params) {
                        var company = document.getElementById("name").value;
                        if (params.Delete) {
                            company = document.getElementById("originalName").innerHTML;
                        }
                        if (company && company.length > 0) {
                            if (parent.document.getElementsByClassName("visitor-details-location-field-company").length > 0) {
                                var companyDiv = parent.document.getElementsByClassName("visitor-details-location-field-company")[0];
                                if (companyDiv && companyDiv.firstChild) {
                                    companyDiv.firstChild.innerHTML = company;
                                }
                            }
                        }
                    }                    
                    parent.dialog.hide('RenameLeadDialog');
                }
             });
        }
    </script>
</head>
<body class="screen-container" style="background-color: #fff">
    <form id="renameLeadForm" runat="server">
    <asp:HiddenField ID="hdRenamedLeadID" runat="server" />
    <div>
       <table class="table">
           <tr>
                <td><dw:TranslateLabel runat="server" Text="Name:" /></td>
                <td><label runat="server" id="originalName" /></td>
            </tr>
            <tr>
                <td><dw:TranslateLabel runat="server" Text="New name:" /></td>
                <td><input type="text" class="std" runat="server" id="name" />                   
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <dw:TranslateLabel runat="server" Text="The IP" />
                    <dw:Label ID="lblIP" runat="server" doTranslation="false"  />
                    <dw:TranslateLabel runat="server" Text="will appear in the list with this name in the future" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td align="right">
                    <br />
                    <input type="button" class="btn btn-flat" runat="server" value="Clear" id="btnDelete" onclick="submitForm({ Delete: true });" />
                    <input type="button" class="btn btn-flat" runat="server" value="Save" onclick="submitForm({ Save: true });" />
                </td>
            </tr>
        </table>        
    </div>
    </form>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
