<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditEndpoint.aspx.vb" Inherits="Dynamicweb.Admin.EditEndpoint" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
    </dw:ControlResources>
    <script src="/Admin/Resources/js/layout/dwglobal.js" type="text/javascript"></script>
    <script src="/Admin/Resources/js/layout/Actions.js" type="text/javascript"></script>

    <script type="text/javascript">
        isUrlRegExp = /^((((https?|ftp|gopher|telnet|file|notes|ms-help):((\/\/)|(\\\\)))|(\/admin\/public))+[\w\d:#@%/;$()~_?\+-=\\\.&']*)$/i;        
        isValid = function () {
            var result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            var el = document.getElementById("txtName");
            if (!el.value) {
                dwGlobal.showControlErrors("txtName", '<%=Translate.JsTranslate("required")%>');
                result = false;
            }
            el = document.getElementById("txtUrl");
            if (!isUrlRegExp.test(el.value)) {
                dwGlobal.showControlErrors("txtUrl", '<%=Translate.JsTranslate("incorrect URL format")%>');
                result = false;
            }
            return result;
        }

        editSave = function (close) {
            if (!isValid()) {
                return false;
            }
            initiatePostBack("EditEndpoint", close ? "close" : "")
        }

        initiatePostBack = function (action, target) {
            var frm = document.getElementById("EditEndpointForm");
            document.getElementById("PostBackAction").value = (action + ':' + target);
            frm.submit();
        }

        cancel = function () {
            Action.Execute({
                Name: "OpenScreen",
                Url: "<%= GetBackUrl() %>"
            });
        }

        deleteEndpoint = function () {
            if (confirm('<%=Translate.JsTranslate("Are you sure you want to delete this endpoint?")%>')) {
                initiatePostBack('RemoveEndpoint', "");
            }
        }

        testEndpoint = function () {
            var url = "TestEndpoint.aspx?id=<%= If(Not IsNothing(CurrentEndpoint), CurrentEndpoint.Id.ToString, String.Empty) %>&";
            var backUrl = escape("<%= EditUrl() %>");
            url += "backUrl=" + backUrl;
            document.location = url;
        }

        var HeadersList = function () { }

        HeadersList.deleteRow = function (link) {
            var optionName = '';
            var row = dwGrid_headersGrid.findContainingRow(link);
            if (row) {
                optionName = row.findControl('txKey').value;

                if (!optionName || optionName.length == 0) {
                    dwGrid_headersGrid.deleteRows([row]);
                    //optionName = '[' + HeadersList._message('message-not-specified') + ']';
                }

                if (confirm(HeadersList._message('message-delete-row').replace('%%', optionName))) {
                    dwGrid_headersGrid.deleteRows([row]);
                }
            }
        }

        HeadersList._message = function (className) {
            var ret = '';
            var container = null;

            if (className) {
                container = $$('.' + className);
                if (container != null && container.length > 0) {
                    ret = container[0].innerHTML;
                }
            }

            return ret;
        }

        function CheckUniquenessOfKeys() {
            var rows = dwGrid_headersGrid.rows.getAll();
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var valueField = row.findControl('txKey');
                var value = valueField.value;

                for (var j = i + 1; j < rows.length; j++) {
                    var loopRow = rows[j];
                    var loopValueField = loopRow.findControl('txKey');

                    if (loopValueField.value == value) {
                        loopValueField.focus();
                        loopValueField.parentNode.className = "has-error";
                        //alert(HeadersList._message("message-not-unique-values").replace("%%", value));
                    } else {
                        loopValueField.parentNode.className = "";
                    }
                }
            }
            return "";
        }

        function useDynamicwebServiceClick() {
            initiatePostBack("UseDynamicwebService", $('cbDynamicwebService').checked.toString());
        }
    </script>
</head>
<body class="screen-container">
    <form id="EditEndpointForm" runat="server">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="lbHeader" Title="Edit endpoint"></dwc:CardHeader>
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSave')) {{ editSave(false); }}" Text="Save" />
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Icon="Save" Disabled="false" OnClientClick="if(!Toolbar.buttonIsDisabled('cmdSaveAndClose')) {{ editSave(true); }}" Text="Save and close" />
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" Icon="Cancel" ShowWait="true" OnClientClick="cancel();" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Delete" OnClientClick="deleteEndpoint()" Text="Delete" Visible="False" />
                <dw:ToolbarButton ID="cmdTest" runat="server" Divide="None" Icon="User" OnClientClick="testEndpoint()" Text="Test" />
            </dw:Toolbar>
            <dwc:CardBody runat="server">
                <dw:GroupBox runat="server" Title="Endpoint information" ID="GroupBox1">
                    <div class="form-group" runat="server" id="rowId" visible="false">
                        <label class="control-label"><%=Translate.Translate("Id")%></label>
                        <div>
                            <asp:Literal ID="lblId" runat="server" />
                        </div>
                    </div>
                    <dwc:InputText ID="txtName" runat="server" Label="Name" ValidationMessage="" MaxLength="255" />
                    <dwc:InputTextArea ID="txtDescription" Label="Description" runat="server" />
                    <dwc:InputText ID="txtUrl" runat="server" Label="Url" ValidationMessage="" />
                    <dwc:CheckBox runat="server" ID="cbDynamicwebService" Label="Connects to standard Dynamicweb codeunit service" OnClick="useDynamicwebServiceClick()" />
                    <dwc:InputText runat="server" ID="txtDynamicwebRequest" Label="Dynamicweb Codeunit Request" Visible="false" />
                    <dwc:SelectPicker runat="server" ID="spRequestType"  CssClass="selectpicker" Name="spRequestType" Label="Type">
                        <asp:ListItem Text="GET" Value="GET"></asp:ListItem>
                        <asp:ListItem Text="POST" Value="POST"></asp:ListItem>
                    </dwc:SelectPicker>
                    <dwc:CheckBox runat="server" ID="cbUseInLiveIntegration" Label="Use in the Live Integration" />
                </dw:GroupBox>
                <dw:GroupBox runat="server" ID="gbHeaders" Title="Request Headers">
                        <dw:EditableGrid ID="headersGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new header..." ShowHeader="true"
                            NoRowsMessage="No headers found" AllowDeletingRows="true" AllowSortingRows="false" runat="server">
                            <Columns>
                                <asp:TemplateField HeaderText="Key">
                                    <ItemTemplate>
                                        <div style="white-space: nowrap">
                                            <asp:TextBox ID="txKey" CssClass="form-control" Text='<%#Eval("Key")%>' onkeyup="CheckUniquenessOfKeys();" runat="server" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Value">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txValue" CssClass="form-control" Text='<%#Eval("Value")%>' runat="server" />                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete" HeaderStyle-Width="75">
                                    <ItemTemplate>
                                        <div id="headerDel" runat="server"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove)%>" onclick="HeadersList.deleteRow(this);"></i></div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                        <span class="hidden message-delete-row"><dw:TranslateLabel ID="lbDeleteRow" Text="Are you sure you want to delete an option '%%' ?" runat="server" /></span>
                        <span class="hidden message-not-specified"><dw:TranslateLabel ID="lbNotSpecified" Text="Not specified" runat="server" /></span>
                        <span class="hidden message-not-unique-values"><dw:TranslateLabel ID="lbNotUnique" Text="The key is not unique '%%'." runat="server" /></span>
                    </dw:GroupBox>
                <dw:GroupBox runat="server" Title="Request Body">
                    <dwc:InputTextArea runat="server" ID="txtBody" Label="Body" Info="text/xml" Rows="10" />
                </dw:GroupBox>
                <div id="AuthenticationContent">
                    <dw:GroupBox runat="server" Title="Endpoint authentication" ID="AuthenticationGroupBox">
                        <div class="form-group">
                            <label class="control-label"><%= Translate.Translate("Authentication") %></label>
                            <div class="form-group-input">
                                <dwc:SelectPicker runat="server" ID="AuthenticationList" CssClass="selectpicker" Label="">
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </dwc:SelectPicker>
                            </div>
                        </div>
                    </dw:GroupBox>
                </div>
                <asp:HiddenField ID="PostBackAction" runat="server" />
                <asp:HiddenField ID="hdBackUrl" runat="server" />
            </dwc:CardBody>
        </dwc:Card>
    </form>
    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>
</html>
