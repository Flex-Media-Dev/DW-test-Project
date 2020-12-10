<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DeliveryProviderEdit.aspx.vb" Inherits="Dynamicweb.Admin.DeliveryProviderEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true"></dw:ControlResources>

    <script type="text/javascript">
        function Save()
        {
            if(!Toolbar.buttonIsDisabled('cmdSave'))
            {
                {
                    if(!ValidateThisForm())
                        return false;

                    if(document.getElementById('Cmd').value == '')
                        document.getElementById('Cmd').value = 'Save';

                    var __o = new overlay('WaitSpinner');

                    __o.show();
                    DeliveryProviderForm.submit();
                }
            }
        }

        function ValidateThisForm()
        {
            var form = document.forms["DeliveryProviderForm"];
            var controlToValidate = form.elements["txProviderName"];

            if(!IsControlValid(controlToValidate, "<%=Translate.JsTranslate("A name is needed")%>")) { return false; }
            if(!IsTypeSelected("<%=Translate.JsTranslate("Please select the type")%>")) { return false; }

            return true;
        }

        function IsTypeSelected(message)
        {
            var e = document.getElementById("Dynamicweb.EmailMessaging.MessageDeliveryProvider_AddInTypes");

            if(e.options[e.selectedIndex].value == '')
            {
                alert(message);

                return false;
            }

            return true;
        }

        function SaveAndClose()
        {
            document.getElementById('Cmd').value = 'Save,Close';
            Save();
        }

        function Cancel()
        {
            location.href = 'DeliveryProviderList.aspx';
        }

        function Delete()
        {
            if(confirm('<%=Translate.JsTranslate("Are you sure you want to delete this?")%>'))
            {
                document.getElementById('Cmd').value = 'Delete,Close';
                DeliveryProviderForm.submit();
            }
        }

        function GetHelp()
        {
            Gui.Help("socialmedia", "modules.omc.emailmarketing.deliveryprovideredit")
        }
    </script>

    <script src="/Admin/Validation.js" type="text/javascript"></script>

</head>
<body>
    <form id="DeliveryProviderForm" runat="server">
        <dw:Toolbar runat="server" ShowEnd="false" ShowStart="False">
            <dw:ToolbarButton ID="cmdSave" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="Save()" Text="Save" />
            <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="SaveAndClose()" Text="Save and close" />
            <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="Cancel()" />
            <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" Text="Delete" OnClientClick="Delete()" />
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="GetHelp()" />
        </dw:Toolbar>

        <input type="hidden" id="Cmd" value="" runat="server" />

        <h2 class="subtitle">
            <dw:TranslateLabel ID="lbSetup" Text="Delivery provider" runat="server" />
        </h2>

        <dw:StretchedContainer runat="server" ID="OuterContainer" Scroll="Auto" Stretch="Fill" Anchor="document">
            <div style="margin-left: 5px; margin-top: 5px">
                <dw:GroupBox ID="gbGeneral" Title="General" runat="server">
                    <table class="tabTable">
                        <tr>
                            <td style="width: 170px;">
                                <dw:TranslateLabel ID="lbProvidername" Text="Name" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox Width="250" ID="txProviderName" runat="server" CssClass="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>

                <de:AddInSelector ID="addInSelector" runat="server" AddInGroupName="Providers" UseLabelAsName="False" AddInBreakFieldsets="False"
                    AddInShowNothingSelected="False" AddInParameterMargin="5px" AddInTypeName="Dynamicweb.EmailMessaging.MessageDeliveryProvider" />
            </div>
        </dw:StretchedContainer>

        <dw:Overlay ID="WaitSpinner" runat="server"></dw:Overlay>
        <asp:Literal ID="addInSelectorScripts" runat="server"></asp:Literal>
        <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
    </form>

    <% Translate.GetEditOnlineScript()%>
</body>
</html>
