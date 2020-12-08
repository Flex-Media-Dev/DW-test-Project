<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EditProfile.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Profiles.EditProfile" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        function showHelp() {
            <%=Gui.Help("omc.createtheme", "omc.createtheme")%>
        }
    </script>
</asp:Content>


<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="Header" Title="Edit visitor profile"/>
        <dw:RibbonBar runat="server">
            <dw:RibbonBarTab runat="server" Name="Content">
                <dw:RibbonBarGroup runat="server" Name="General">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save" ID="cmdSave" OnClientClick="currentPage.save(false)" />
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save and close" ID="cmdSave_and_close" OnClientClick="currentPage.save(true)" />
                    <dw:RibbonBarButton runat="server" Icon="Cancel" Size="Small" IconColor="Danger" Text="Cancel" ID="cmdCancel" OnClientClick="currentPage.cancel()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Rules">
                    <dw:RibbonBarButton runat="server" ID="cmdAll_must_apply" Disabled="true" Icon="BorderOuter" Size="Small" Text="All must apply" OnClientClick="currentPage.groupSelected(2)" />
                    <dw:RibbonBarButton runat="server" ID="cmdAny_must_apply" Disabled="true" Icon="BorderVertical" Size="Small" Text="Any must apply" OnClientClick="currentPage.groupSelected(1)" />
                    <dw:RibbonBarButton runat="server" ID="cmdUngroup" Disabled="true" Icon="BorderClear" Size="Small" Text="Ungroup" OnClientClick="currentPage.ungroupSelected()" />
                    <dw:RibbonBarButton runat="server" ID="cmdRemove_selected" Disabled="true" Icon="HighlightRemove" Size="Small" Text="Remove selected" OnClientClick="currentPage.removeSelected()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Help">
                    <dw:RibbonBarButton runat="server" Icon="Help" Size="Large" Text="Help" ID="cmdHelp" OnClientClick="currentPage.help()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="GroupBox1" Title="General" runat="server">
                <dwc:InputText runat="server" ID="txName" Label="Name" ValidationMessage="" />
                <dwc:InputTextArea runat="server" ID="txDescription" Label="Description" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="gbAutomaticRecognition" Title="Recognition rules" Subtitle="Choose recognition rules by dragging items from the list on the left to the area on the right.">
                <omc:RecognitionExpressionEditor ID="editRules" runat="server" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
    <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
</asp:Content>