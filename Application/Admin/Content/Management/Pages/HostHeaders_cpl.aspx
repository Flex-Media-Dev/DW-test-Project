<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="HostHeaders_cpl.aspx.vb" Inherits="Dynamicweb.Admin.HostHeaders_cpl" %>

<%@ Register TagPrefix="management" TagName="ImpersonationDialog" Src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.ascx" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.Management.Common.Dialogs" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <script src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.js" type="text/javascript"></script>
    <script src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js"></script>
    <script src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        (function($) {
            $.extend(page,
                {
                    hosts: <%= InitHostsJS() %>,

                    onSave: function(currentPageObj, args) {
                        var msg = '<% =Translate.Translate("After applying changes you will be logged out! Continue?")%>';
                        page.showConfirm(msg, function() { __doPostBack("", "ApplyChanges"); });
                    },

                    resetApplicationPool: function(currentPageObj, args) {
                        var msg = '<% =Translate.Translate("After resetting you will be logged out! Continue?")%>';
                        page.showConfirm(msg, function() { __doPostBack("", "ResetPool"); });
                    },
                    
                    showConfirm: function(message, onConfirmed, onCancel) {
                        var action = <%=GetConfirmAplyChangesMessageDialog()%>;
                        action.OnSubmitted.Function = onConfirmed;
                        var buttons = <%=ConfirmDialogButtons.SubmitOk Or ConfirmDialogButtons.Cancel%>;
                        if (onCancel) {
                            buttons += <%=ConfirmDialogButtons.SubmitCancel%>;
                            action.Url += '&SubmitOkTitle=' +
                                'Create both' +
                                '&SubmitCancelTitle=' +
                                'Create only one';
                        }
                        onCancel = onCancel || function() {};
                        action.OnCancelled = {
                            Name: "ScriptFunction",
                            Function: onCancel
                        }
                        Action.Execute(action, {Message:message, Buttons:buttons});
                        return false;
                    },

                    showImpersonationDialog: function() {
                        <%= dlgImpersonation.ClientInstanceName %>.show();
                    },
                    
                    showAddHostHeaderDialog: function() {
                        var title = <%= System.Web.Helpers.Json.Encode(Translate.Translate("Add host header")) %>;
                        this._showEditHostHeaderDlg(title);
                    },

                    showEditHostHeaderDialog: function(obj) {
                        var title = <%= System.Web.Helpers.Json.Encode(Translate.Translate("Edit host header")) %>;
                        this._showEditHostHeaderDlg(title, obj);
                    },

                    _showEditHostHeaderDlg: function(title, hostHeaderObj) {
                        this._resetChecking();
                        hostHeaderObj = hostHeaderObj || {
                            host: "",
                            address: "0",
                            port: 80
                        };
                    
                        $("#OriginalHost").val(hostHeaderObj.host);
                        $("#OriginalAddress").val(hostHeaderObj.address);
                        $("#OriginalPort").val(hostHeaderObj.port);

                        $("#txHostName").val(hostHeaderObj.host);
                        $("#lstAddresses").selectpicker("val", hostHeaderObj.address);
                        $("#txPort").val(hostHeaderObj.port);
                        $("#dlgAddHeader .error-block").removeClass("has-error");
                        dialog.setTitle("dlgAddHeader", title);
                        dialog.show("dlgAddHeader");
                    },

                    _resetChecking: function() {
                        $("#CheckBeforeUnload").val("");
                    },

                    _submitHostHeader: function() {
                        this._showWait();
                        if ($("#OriginalHost").val()) {
                            __doPostBack("", "EditHostHeader");
                        } else {
                            __doPostBack("", "NewHostHeader");
                        }
                    },

                    addHostHeaderToList: function() {
                        var self = this;
                        if (self._isFormValid()) {
                            var hostNameEl = $("#txHostName");
                            var hostName = hostNameEl.val();
                            var altHost = self.getAlternativeHost(hostName);
                            var fillAltHostName = false;
                            if (altHost) {
                                var msg = '';
                                if (hostName.indexOf('www.') != -1) {
                                    msg =
                                        '<%= Dynamicweb.SystemTools.Translate.Translate("Should we also create the %host% (without WWW) and with the same settings as the one that you typed in?")%>'.replace('%host%', altHost);
                                } else {
                                    msg =
                                        '<%= Dynamicweb.SystemTools.Translate.Translate("Should we also create the %host% (with WWW) and with the same settings as the one that you typed in?")%>'.replace('%host%', altHost);
                                }
                                this.showConfirm(msg,
                                    function() {
                                        $("#altHostName").val(altHost);
                                        self._submitHostHeader();
                                    },
                                    function() {
                                        $("#altHostName").val("");
                                        self._submitHostHeader();
                                    });
                            } else {
                                $("#altHostName").val("");
                                self._submitHostHeader();
                            }
                        
                    }
                    return false;
                },

                    getAlternativeHost: function(hostName) {
                        var result = '';

                        if (hostName && hostName!='') {
                            hostName = hostName.replace(/^\s+|\s+$/g, '').toLowerCase();
                            var isFound = false;
                            var isHaveW3Preffix = (hostName.indexOf('www.') != -1);
                            var findPattern = isHaveW3Preffix ? hostName.replace('www.', '') : ('www.' + hostName);
                    
                            for (var i = 0; i < this.hosts.length; i++) {
                                isFound =  (this.hosts[i].replace(/^\s+|\s+$/g, '').indexOf(findPattern) == 0);
                                if (isFound) break;
                            }
                            if (!isFound) {
                                result = findPattern;
                            }
                        }

                        return result;
                    },
 
                    _showWait: function(){
                        var o = new overlay('wait');
                        o.show();
                    },
                
                    _isFormValid: function() {
                        var elHost = $("#txHostName");
                        elHost.val(elHost.val() ? elHost.val().replace(/^\s+|\s+$/g, "") : "");
                        var msg = "";
                        if (!elHost.val()) {
                            msg = "<%=Translate.JsTranslate("Please input host header name!") %>";
                        }
                        dwGlobal.controlErrors("txHostName", !!msg, msg);

                        msg = "";
                        var elPort = $("#txPort");
                        if (!elPort.val()) {
                            msg = "<%=Translate.JsTranslate("Please input port!") %>";
                        }
                        dwGlobal.controlErrors("txPort", !!msg, msg);
                        
                        return elHost.val() && elPort.val();
                    },

                    removeHostHeader: function(hostName) {
                        var self = this;
                        var msg = '<%= Translate.JsTranslate("Are you sure you want To delete this host header ?")%>';
                        this.showConfirm(msg, function() { 
                            self._showWait();
                            __doPostBack("", "RemoveHostHeader:" + hostName);
                        });
                    }
                });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Header">
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Host headers" />
        <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
            <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="true" Divide="None" Icon="PlusSquare" Text="Add" OnClientClick="SettingsPage.getInstance().showAddHostHeaderDialog(); return false;" />
            <dw:ToolbarButton ID="cmdResetPool" runat="server" Disabled="true" Divide="Before" Icon="AutoRenew" Text="Reset application pool" OnClientClick="SettingsPage.getInstance().resetApplicationPool(); return false;" />
            <dw:ToolbarButton ID="cmdImpersonate" runat="server" Divide="Before" Icon="RemoveRedEye" Text="Impersonation" OnClientClick="SettingsPage.getInstance().showImpersonationDialog(); return false;" />
        </dw:Toolbar>
        <dw:List ID="lstHeaders" ShowPaging="true" NoItemsMessage="No host headers found" ShowTitle="false" runat="server" PageSize="25">
            <Columns>
                <dw:ListColumn ID="colHostName" Name="Hostname" Width="300" runat="server" />
                <dw:ListColumn ID="colIPAddr" Name="IP address" Width="150" runat="server" />
                <dw:ListColumn ID="colPort" Name="Port" Width="75" runat="server" />
                <dw:ListColumn ID="colRemove" Name="Remove" Width="75" runat="server" />
                <dw:ListColumn ID="colState" Name="State" Width="300" runat="server" />
            </Columns>
        </dw:List>
        <dw:Infobar ID="infoResult" Visible="false" runat="server" />
        <management:ImpersonationDialog ID="dlgImpersonation" DefaultType="BackendUser" runat="server" ClientIDMode="Static" />

        <dw:Dialog ID="dlgAddHeader" Title="Edit host header" ShowOkButton="true" OkAction="SettingsPage.getInstance().addHostHeaderToList();" Size="Medium" ShowCancelButton="true" runat="server">
            <dwc:GroupBox runat="server">
                <asp:HiddenField ID="altHostName" runat="server" Value="" ClientIDMode="Static" />
                <dwc:InputText runat="server" ID="txHostName" Label="Hostname" ValidationMessage="" ClientIDMode="Static" />
                <dwc:SelectPicker ID="lstAddresses" Label="IP_address" runat="server" ClientIDMode="Static" />
                <dwc:InputNumber ID="txPort" Value="80" Label="Port" runat="server" ValidationMessage="" ClientIDMode="Static" />
            </dwc:GroupBox>
        </dw:Dialog>

        <input type="hidden" id="OriginalHost" name="OriginalHost" />
        <input type="hidden" id="OriginalAddress" name="OriginalAddress" />
        <input type="hidden" id="OriginalPort" name="OriginalPort" />
        <input type="hidden" id="HandleOnUnload" name="HandleOnUnload" />
        <input type="hidden" id="CheckBeforeUnload" name="CheckBeforeUnload" clientidmode="Static" runat="server" />

        <dw:Overlay ID="wait" runat="server" Message="" ShowWaitAnimation="True">
            <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Opdatering" />
            ...
        </dw:Overlay>
        <% Translate.GetEditOnlineScript() %>
    </dwc:Card>
</asp:Content>
