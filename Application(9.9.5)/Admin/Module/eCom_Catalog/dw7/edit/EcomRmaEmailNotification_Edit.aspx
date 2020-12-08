<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomRmaEmailNotification_Edit.aspx.vb"
    Inherits="Dynamicweb.Admin.Admin.Module.eCom_Catalog.dw7.edit.EcomRmaEmailNotification_Edit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .form-group-input > .form-control + .help-block.info {
            font-size: inherit;
            color: inherit;
        }

        .form-group-input > .form-control + .help-block.info > .form-group {
            margin: auto;
        }

        .form-group-input > .form-control[disabled] {
            display: none;
        }

        .form-group-input > .form-control[disabled] + .help-block.info {
            margin: auto;
        }
    </style>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <form id="form1" runat="server">
            <input type="hidden" id="Close" name="Close" />
            <div class="card-header">
                <h2 class="subtitle">
                    <dw:TranslateLabel runat="server" Text="Edit email notifications" />
                </h2>
            </div>
            <dw:Toolbar ID="Toolbar" ShowStart="false" ShowEnd="false" runat="server">
                <dw:ToolbarButton ID="ToolbarButton1" Icon="Save" Text="Save" OnClientClick="submitForm(); return false;"
                    runat="server" />
                <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Gem og luk" OnClientClick="submitForm(true); return false;"
                    runat="server" />
                <dw:ToolbarButton ID="cmdCancel" Icon="Remove" Text="Cancel" OnClientClick="closeForm(); return false;"
                    runat="server" />
            </dw:Toolbar>
            <input type="hidden" id="MailsJSON" runat="server" value="[]" />

            <dwc:GroupBox runat="server" ID="notificationsGroupbox">
                <table id="MailsTable"></table>
                <a onclick="addNewMail()" class="btn btn-flat"><i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare, True, Dynamicweb.Core.UI.KnownColor.Success) %>" title="Add email notification"></i> Add email notification</a>
            </dwc:GroupBox>
            
            <dw:Dialog runat="server" ID="EditMailDialog" Size="Medium" Title="Edit email notification" TranslateTitle="true" ShowCancelButton="true" ShowOkButton="true" OkAction="saveMailEdit();">
                <input type="hidden" id="MailIndex" />
                <dwc:GroupBox runat="server" Title="Settings">
                    <dwc:InputText runat="server" ID="MailRecipient" ClientIDMode="Static" Label="Recipient e-mail" />
                    <dwc:InputText runat="server" ID="MailSubject" ClientIDMode="Static" Label="Subject" />
                    <dw:FileManager runat="server" ID="MailTemplate" ClientIDMode="Static" Folder="Templates/eCom/RMA/Mail" FullPath="true" Label="Template" />
                    <dwc:InputText runat="server" ID="MailSenderName" ClientIDMode="Static" Label="Sender name"  />
                    <dwc:InputText runat="server" ID="MailSenderEmail" ClientIDMode="Static" Label="Sender e-mail" />
                </dwc:GroupBox>
            </dw:Dialog>

            <div id="HiddensMails">
            </div>

            <div id="Translate_Customer" style="display: none;">
                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Customer" />
            </div>
            <div id="Translate_No_recipient" style="display: none;">
                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="No recipient" />
            </div>
            <div id="Translate_Edit" style="display: none;">
                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Edit" />
            </div>
            <div id="Translate_Delete" style="display: none;">
                <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="Delete" />
            </div>
        </form>
    </div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
</html>
<script type="text/javascript">
    var mails = new Array();
    function Mail(recipient, subject, template, templatePath, senderName, senderEmail, ForCustomer, SenderNameForCustomer, SenderEmailForCustomer, id) {
        this.Recipient = recipient;
        this.Subject = subject;
        this.Template = template;
        this.SenderName = senderName;
        this.SenderEmail = senderEmail;
        this.ForCustomer = ForCustomer;
        this.SenderNameForCustomer = SenderEmailForCustomer;
        this.SenderEmailForCustomer = SenderEmailForCustomer;
        this.Id = id;
    }

    function editMail(mailIndex) {
        var mail = mails[mailIndex];
        document.getElementById('MailIndex').value = mailIndex;
        document.getElementById('MailRecipient').value = mail.Recipient;
        document.getElementById('MailSubject').value = mail.Subject;
        document.getElementById('FM_MailTemplate').value = mail.Template;
        document.getElementById('MailTemplate_path').value = mail.TemplatePath;
        document.getElementById('MailSenderName').value = mail.SenderName;
        document.getElementById('MailSenderEmail').value = mail.SenderEmail;

        var ForCustomer = document.getElementById('MailForCustomer');
        ForCustomer.checked = mail.ForCustomer;
        document.getElementById('MailRecipient').disabled = ForCustomer.checked;

        var senderEmailForCustomer = document.getElementById('MailSenderEmailForCustomer');
        senderEmailForCustomer.checked = mail.SenderEmailForCustomer;
        document.getElementById('MailSenderEmail').disabled = senderEmailForCustomer.checked;

        var senderNameForCustomer = document.getElementById('MailSenderNameForCustomer');
        senderNameForCustomer.checked = mail.SenderNameForCustomer;
        document.getElementById('MailSenderName').disabled = senderNameForCustomer.checked;

        dialog.show('EditMailDialog');
    }

    function saveMailEdit() {
        var mail = mails[document.getElementById('MailIndex').value];
        mail.Recipient = document.getElementById('MailRecipient').value;
        mail.Subject = document.getElementById('MailSubject').value;
        mail.Template = document.getElementById('FM_MailTemplate').value;
        mail.TemplatePath = document.getElementById('MailTemplate_path').value;
        mail.SenderName = document.getElementById('MailSenderName').value;
        mail.SenderEmail = document.getElementById('MailSenderEmail').value;
        mail.ForCustomer = document.getElementById('MailForCustomer').checked;
        mail.SenderEmailForCustomer = document.getElementById('MailSenderEmailForCustomer').checked;
        mail.SenderNameForCustomer = document.getElementById('MailSenderNameForCustomer').checked;
        updateMails();
        dialog.hide('EditMailDialog');
    }

    function deleteMail(mailIndex) {
        mails.splice(mailIndex, 1);
        updateMails();
        dialog.hide('EditMailDialog');
    }


    function addNewMail() {
        mails.push(new Mail('', '', '', '', '', '', false, false, false, -1)); // 65001 is the codepage for UTF-8
        updateMails();
        editMail(mails.length - 1);
    }
    function updateMails() {
        // Clear table
        var table = document.getElementById('MailsTable');
        while (table.rows.length > 0)
            table.deleteRow(0);

        // Clear hidden values
        clearHidden('Mails');

        if (mails.length == 0) {
            var row = table.insertRow(table.rows.length);
            row.insertCell(row.cells.length).innerHTML = "None";


        }
        // Add each step
        for (var i = 0; i < mails.length; i++) {
            var mail = mails[i];

            // Add to hidden save values
            if (mail.Id > -1) {
                addHidden('Mails', 'Mail' + (i + 1) + 'Id', mail.Id);
            } else {
                addHidden('Mails', 'Mail' + (i + 1) + 'Id', -1);
            }
            addHidden('Mails', 'Mail' + (i + 1) + 'Recipient', mail.Recipient);
            addHidden('Mails', 'Mail' + (i + 1) + 'Subject', mail.Subject);
            addHidden('Mails', 'Mail' + (i + 1) + 'Template', mail.Template);
            addHidden('Mails', 'Mail' + (i + 1) + 'Template_path', mail.TemplatePath, true);
            addHidden('Mails', 'Mail' + (i + 1) + 'SenderName', mail.SenderName);
            addHidden('Mails', 'Mail' + (i + 1) + 'SenderEmail', mail.SenderEmail);
            addHidden('Mails', 'Mail' + (i + 1) + 'ForCustomer', mail.ForCustomer);
            addHidden('Mails', 'Mail' + (i + 1) + 'SenderEmailForCustomer', mail.SenderEmailForCustomer);
            addHidden('Mails', 'Mail' + (i + 1) + 'SenderNameForCustomer', mail.SenderNameForCustomer);

            // Add to table
            var row = table.insertRow(table.rows.length);

            var name;
            if (mail.ForCustomer)
                name = document.getElementById('Translate_Customer').innerHTML;
            else if (mail.Recipient.length > 0)
                name = mail.Recipient;
            else
                name = document.getElementById('Translate_No_recipient').innerHTML;

            row.insertCell(row.cells.length).innerHTML = name;
            row.insertCell(row.cells.length).appendChild(createIcon('fa fa-pencil btn btn-flat m-l-5', 'editMail(' + i + ');', 'Edit'));
            row.insertCell(row.cells.length).appendChild(createIcon('fa fa-remove color-danger btn btn-flat m-l-5', 'deleteMail(' + i + ');', 'Delete'));
        }

    }
    function submitForm(close) {
        if (close) {
            document.getElementById('Close').value = 'true';
        }
        $('form1').submit();
    }
    function closeForm() {
        location.href = '../Lists/EcomRmaEmailConfiguration_List.aspx';
    }




    //    var hiddenSettingNames = new Object;
    //    hiddenSettingNames.Steps = new Array();
    //    hiddenSettingNames.Mails = new Array();

    function addHidden(settingName, name, value, excludeInSettings, excludeInHiddens) {
        // Add to hiddens
        if (!excludeInHiddens) {
            var hiddenDiv = document.getElementById('Hiddens' + settingName);
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.value = value;
            hidden.name = name;
            hiddenDiv.appendChild(hidden);
        }
    }

    function clearHidden(settingName) {
        // Clear the hidden inputs
        if (document.getElementById('Hiddens' + settingName))
            document.getElementById('Hiddens' + settingName).innerHTML = '';
    }

    function createIcon(iconString, onclick, titleName) {
        var icon = document.createElement('i');
        icon.className = iconString;
        icon.alt = '';
        icon.onclick = new Function(onclick);
        icon.title = document.getElementById('Translate_' + titleName).innerHTML;
        return icon;
    }

    // init
    mails = eval(document.getElementById('MailsJSON').value);
    updateMails();

</script>
