<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoadBalancingEdit.aspx.vb" Inherits="Dynamicweb.Admin.LoadBalancingEdit" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" IncludeScriptaculous="false" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function help() {
		    <%=Dynamicweb.SystemTools.Gui.HelpPopup("", "Load Balancing")%>
        }

        function save(close) {
            if (document.getElementById("InstanceName").value.length < 1) {
                alert('<%=Translate.JSTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
                document.getElementById("InstanceName").focus();
                return;
            }
            overlayShow();
            if (close) {
                document.getElementById("close").value = "True"
            }
            document.getElementById("form1").submit();
        }

        function savelayout() { 
            overlayShow();
            document.getElementById("form1").submit();
        }

        function decode(encoded) {
            if (encoded.length > 0) {
                var div = document.createElement('div');
                div.innerHTML = encoded;
                return div.firstChild.nodeValue;
            }
            return encoded;
        }

        function sortdown(optionId) {
            overlayShow();
            location = 'LoadBalancingEdit.aspx?sort=down&optionId=' + optionId;
        }

        function sortup(optionId) {
            overlayShow();
            location = 'LoadBalancingEdit.aspx?sort=up&optionId=' + optionId;
        }

        function sortbytext(desc) {
            overlayShow();
            var fieldid = document.getElementById("fieldid").value;
            location = 'LoadBalancingEdit.aspx?action=sortbytext&fieldid=' + fieldid + '&desc=' + desc;
        }

        function sortbyvalue(desc) {
            overlayShow();
            var fieldid = document.getElementById("fieldid").value;
            location = 'LoadBalancingEdit.aspx?action=sortbyvalue&fieldid=' + fieldid + '&desc=' + desc;
        }

        function back() {
            location = "LoadBalancing_cpl.aspx";
        }
        function overlayShow() {
            showOverlay('wait');
        }

        function toggleActive(optionId) {
            overlayShow();
            location = 'LoadBalancingEdit.aspx?Active=true&optionId=' + optionId
        }

        function toggleDefault(optionId) {
            overlayShow();
            location = 'LoadBalancingEdit.aspx?Default=true&optionId=' + optionId
        }

        function showlayout() {
            layoutDialog
        }
    </script>
    <style type="text/css">
        div.listcontainer {
            border: 1px solid #ABADB3;
            min-height: 200px;
            overflow-x: hidden;
        }

        #fieldpreview textarea, #fieldpreview input[type=text], #fieldpreview input[type=password] {
            width: initial;
            min-width: 250px;
            font-size: 13px !important;
            color: black !important;
            border: 1px solid #333333;
            padding: 4px;
        }

        #fieldpreview img {
            max-width: 250px;
        }
    </style>
</head>
<body class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" id="fieldid" runat="server" />
            <input type="hidden" id="action" runat="server" value="save" />
            <input type="hidden" id="close" runat="server" />

            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Instance" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Felt">
                        <dw:RibbonBarButton ID="cmdName" runat="server" Size="Small" Text="Gem" Icon="Save" OnClientClick="save(false);"></dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton1" runat="server" Size="Small" Text="Gem og luk" Icon="Save" OnClientClick="save(true);"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" ID="cmdCancel" OnClientClick="back();" ShowWait="true" WaitTimeout="500"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="helpGroup" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="cmdHelp" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="breadcrumb">
                <dw:TranslateLabel Text="Load balancing" runat="server" />
                &#187; <span id="breadcrumbTextName" runat="server"></span>
            </div>

            <dw:GroupBox ID="GB_settings" runat="server" DoTranslation="True" Title="Indstillinger">
                <asp:Literal ID="disabledInformation" runat="server" />
                <table id="informationTable" class="formsTable" runat="server">
                    <tr>
                        <td style="width: 170px; vertical-align: top">
                            <label for="InstanceName">
                                <dw:TranslateLabel runat="server" Text="Instance name" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="InstanceName" name="InstanceName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="IsActive" FieldName="IsActive" />
                            <label for="IsActive">
                                <dw:TranslateLabel runat="server" Text="Aktiv" />
                            </label>
                            <asp:Literal ID="isActiveFeedback" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="MachineName">
                                <dw:TranslateLabel runat="server" Text="Machine name" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="MachineName" name="MachineName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="HostName">
                                <dw:TranslateLabel runat="server" Text="Host name" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="HostName" name="HostName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="IPAddress">
                                <dw:TranslateLabel runat="server" Text="IP address" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="IPAddress" name="HostName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="Created">
                                <dw:TranslateLabel runat="server" Text="Created" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="Created" name="Created" runat="server" maxlength="255" class="std" disabled="disabled" value="Not set" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="Updated">
                                <dw:TranslateLabel runat="server" Text="Updated" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="Updated" name="Updated" runat="server" maxlength="255" class="std" disabled="disabled" value="Not set"/>
                        </td>
                    </tr>
                </table>
                <div id="informationBottom" runat="server" class="information">Note that if the unique idenfier, as defined in the config file, is updated an iisreset is required for the cluster to work again.</div>
            </dw:GroupBox>
        </form>
        <div>&nbsp;</div>
    </div>

    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
</body>
</html>
