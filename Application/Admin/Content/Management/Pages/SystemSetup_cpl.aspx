<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="SystemSetup_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemSetup_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
	    var page = SettingsPage.getInstance();
	    page.onSave = function () {
	        document.getElementById('MainForm').submit();	        
	    };
	    (function ($) {
	        var fnAjaxPost = function (xref, dataObj, fnResponse) {
	            var loader = new overlay("__ribbonOverlay");
	            loader.message("");
	            $.ajax(xref, {
	                type: "POST",
	                data: dataObj,
	                dataType: "json",
	                cache: false,

	                beforeSend: function () {
	                    loader.show();
	                },
	                success: function (data) {
	                    loader.hide();
	                    fnResponse(data);
	                },
	                error: function () {
	                    loader.hide();
	                }
	            });
	        };

	        var fnAjaxRequest = function (xref, dataObj, hideCnt, showCnt) {
	            fnAjaxPost(xref, dataObj, function (data) {
	                if (data.success) {
	                    hideCnt.toggleClass("hide");
	                    showCnt.toggleClass("hide");
	                }
	                if (data.error) {
	                    alert(data.error)
	                }
	            });
	        };
	        $(function () {
	            $("#DomainMoreThan255").on("click", function () {
	                fnAjaxRequest($(this).prop("href"), null, $("#cnt-DomainMoreThan255-ready-to-activate"), $("#cnt-DomainMoreThan255-activated"));
	                return false;
	            });

	            $("#FixExtendedNewsletterStat").on("click", function () {
	                fnAjaxRequest($(this).prop("href"), null, $("#cnt-FixExtendedNewsletterStat-ready-to-activate"), $("#cnt-FixExtendedNewsletterStat-activated"));
	                return false;
	            });

	            $("#TestSmtpSettings").on("click", function () {
	                var smtpSettingsOkInfoBox = $(".test-smtp-settings-ok");
	                var smtpSettingsFailInfoBox = $(".test-smtp-settings-fail");
	                smtpSettingsOkInfoBox.addClass("hide");
	                smtpSettingsFailInfoBox.addClass("hide");
	                var data = {
	                    Action: "SMTP-CHECK",
	                    Server: $("#MailServerName").val(),
	                    port: $("#<%=MailServerPort.ClientID%>").val(),
	                    User: $("#MailServerUsername").val(),
	                    Password: $("#MailServerPassword").val(),
	                    UseSSL: $("#MailServerUseSll").is(":checked"),
	                };

	                if (!data.Server) {
	                    smtpSettingsFailInfoBox.text("<%= Translate.Translate("Mail Server required")  %>")
	                    smtpSettingsFailInfoBox.removeClass("hide");
	                }
	                fnAjaxPost(window.location.href, data, function (res) {
	                    if (res.Succeeded) {
	                        smtpSettingsOkInfoBox.removeClass("hide");
	                    } else {
	                        smtpSettingsFailInfoBox.find(".msg").html("<%= Translate.Translate("Mail settings test failed with the following error message:") %>" + "<div>{0}</div><div>{1}</div>".format(res.Message || "", (res.Data || "").replace(/(?:\r\n|\r|\n)/g, '<br />')));
	                        smtpSettingsFailInfoBox.removeClass("hide");
	                    }
	                });
	                return false;
	            });
	        });
	    })(jQuery);	    
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active"><%= Translate.Translate("System setup") %></li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Smtp" />
        <dwc:CardBody runat="server">


            <dwc:GroupBox runat="server" ID="groupbox2" Title="Mailserver">
                <dwc:InputText runat="server" ID="MailServerName" Name="/Globalsettings/System/MailServer/Server" Label="Server" MaxLength="255" />
                <dwc:InputNumber runat="server" ID="MailServerPort" Name="/Globalsettings/System/MailServer/Port" Label="Port" Placeholder="25" Value="25" />

                <div style="height: 0px; width: 0px; overflow: hidden">
                    <!--Avoid autofill from Chrome-->
                    <input type="text" name="fakeusernameremembered" id="fakeusernameremembered" style="height: 1px; width: 1px; line-height: 1px; border: none" />
                    <input type="password" name="fakepasswordremembered" id="fakepasswordremembered" style="height: 1px; width: 1px; line-height: 1px; border: none" />
                </div>
                <dwc:InputText runat="server" ID="MailServerUsername" Name="/Globalsettings/System/MailServer/Username" Label="Brugernavn" MaxLength="255" autocomplete="off" />
                <dwc:InputText runat="server" ID="MailServerPassword" Name="/Globalsettings/System/MailServer/Password" Label="Kodeord" MaxLength="255" Password="True" autocomplete="off" />
                <dwc:CheckBox runat="server" ID="MailServerUseSll" Name="/Globalsettings/System/MailServer/UseSll" Label="SSL" />
                <dwc:CheckBox runat="server" ID="MailServerDoNotUsePickup" Name="/Globalsettings/System/MailServer/DoNotUsePickup" Label="Do not use SMTP pickup directory" />
                <div class="form-group">
                    <dwc:Button runat="server" ID="TestSmtpSettings" Title="Test mail settings" />
                </div>
                <div class="form-group">
                    <label class="control-label">&nbsp;</label>
                    <div class="form-group-input">
                        <dw:Infobar runat="server" CssClass="test-smtp-settings-ok hide" Title="Mail settings test passed" TranslateMessage="true" Type="Information">
                            <span class="msg"><%=Translate.Translate("Mail settings test passed")%></span>
                        </dw:Infobar>

                    </div>
                </div>
                <dw:Infobar runat="server" CssClass="test-smtp-settings-fail hide" Title="Mail settings test failed" TranslateMessage="true" Type="Error">
                    <span class="msg"></span>
                </dw:Infobar>
                
                <dwc:CheckBox runat="server" ID="SaveAllMailsToDisk" Name="/Globalsettings/System/MailServer/SaveAllMailsToDisk" Label="Save all emails to disk" Info="Check to save a copy of all emails to /Files/System/Log/EmailHandler/" />
                <dwc:CheckBox runat="server" ID="ByPassRecipients" Name="/Globalsettings/System/MailServer/ByPassRecipients" Label="Enable test mode" Info="Check to forward all emails to test account" />
                <dwc:InputText runat="server" ID="ByPassRecipientsSendTo" Name="/Globalsettings/System/MailServer/ByPassRecipientsSendTo" Label="Forward emails to" MaxLength="255" autocomplete="off" Info="Email address to forward all mails to. If left empty and test mode enabled, no mails will be send." />
                <dwc:InputText runat="server" ID="ByPassMailFrom" Name="/Globalsettings/System/MailServer/ByPassMailFrom" Label="Mail from" MaxLength="255" autocomplete="off" Info="Use this email address in mail from when in test mode. If not specified, the Forward emails to is used" />
            </dwc:GroupBox>

            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>


</asp:Content>
