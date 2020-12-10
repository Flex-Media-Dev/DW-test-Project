var mails = new Array();
function Mail(recipient, subject, template, templatePath, senderName, senderMail, isCustomer, isDelivery, encodingCodePage, attachment, attachmentPath, isCustomField, recipientCustomField) {
    this.Recipient = recipient;
    this.RecipientCustomField = recipientCustomField;
    this.Subject = subject;
    this.Template = template;
    this.TemplatePath = templatePath;
    this.SenderName = senderName;
    this.SenderMail = senderMail;
    this.IsCustomer = isCustomer;
    this.IsDelivery = isDelivery;
    this.IsCustomField = isCustomField;
    this.EncodingCodePage = encodingCodePage;
    this.Attachment = attachment;
    this.AttachmentPath = attachmentPath;
}

function editMail(mailIndex) {
    var mail = mails[mailIndex];
    document.getElementById('MailIndex').value = mailIndex;
    document.getElementById('MailRecipient').value = mail.Recipient;
    document.getElementById('MailCustomFields').value = mail.RecipientCustomField;
    document.getElementById('MailSubject').value = mail.Subject;
    document.getElementById('FM_MailTemplate').value = mail.Template;
    document.getElementById('MailTemplate_path').value = mail.TemplatePath;
    document.getElementById('MailSenderName').value = mail.SenderName;
    document.getElementById('MailSenderEmail').value = mail.SenderMail;
    document.getElementById('MailEncoding').value = mail.EncodingCodePage;
    document.getElementById('MailAttachment_path').value = mail.AttachmentPath;

    var attachment = document.getElementById('FM_MailAttachment');
    attachment.value = mail.Attachment;
    if (!attachment.value) {
        var option = document.createElement("option");
        option.text = mail.Attachment;
        option.value = mail.Attachment;
        option.setAttribute('fullPath', mail.AttachmentPath);
        attachment.add(option);
        attachment.selectedIndex = attachment.options.length - 1;
    }

    var isCustomer = document.getElementById('MailIsCustomer');
    isCustomer.checked = mail.IsCustomer;
    var isDelivery = document.getElementById('MailIsDelivery');
    isDelivery.checked = mail.IsDelivery;
    var isCustomField = document.getElementById('MailIsCustomField');
    isCustomField.checked = mail.IsCustomField;

    onCustomerOrDeliveryChecked();
   
    dialog.show('EditMailDialog');
}

function saveMailEdit() {
    var mail = mails[document.getElementById('MailIndex').value];
    mail.Recipient = document.getElementById('MailRecipient').value;
    mail.RecipientCustomField = document.getElementById('MailCustomFields').value;
    mail.Subject = document.getElementById('MailSubject').value;
    mail.Template = document.getElementById('FM_MailTemplate').value;
    mail.TemplatePath = document.getElementById('MailTemplate_path').value;
    mail.SenderName = document.getElementById('MailSenderName').value;
    mail.SenderMail = document.getElementById('MailSenderEmail').value;
    mail.IsCustomer = document.getElementById('MailIsCustomer').checked;
    mail.IsDelivery = document.getElementById('MailIsDelivery').checked;
    mail.IsCustomField = document.getElementById('MailIsCustomField').checked;
    mail.EncodingCodePage = document.getElementById('MailEncoding').value;
    mail.Attachment = document.getElementById('FM_MailAttachment').value;
    mail.AttachmentPath = document.getElementById('MailAttachment_path').value;

    updateMails();
    dialog.hide('EditMailDialog');
}

function deleteMail(mailIndex) {
    mails.splice(mailIndex, 1);
    updateMails();
    dialog.hide('EditMailDialog');
}

function onCustomerOrDeliveryChecked() {
    var isMailCustomFieldsChecked = document.getElementById('MailIsCustomField').checked
    document.getElementById("MailCustomFieldsRow").style.display = isMailCustomFieldsChecked ? "table-row" : "none";
    var isChecked = document.getElementById('MailIsCustomer').checked || document.getElementById('MailIsDelivery').checked || isMailCustomFieldsChecked;
    document.getElementById('MailRecipient').disabled = isChecked;
}
    
function addNewMail() {
    mails.push(new Mail('', '', '', '', '', '', false, false, 65001, '', '', false, '')); // 65001 is the codepage for UTF-8
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

    // Add each step
    for (var i = 0; i < mails.length; i++) {
        var mail = mails[i];
        
        // Add to hidden save values
        addHidden('Mails', 'Mail' + (i + 1) + 'Recipient', mail.Recipient);
        addHidden('Mails', 'Mail' + (i + 1) + 'RecipientCustomField', mail.RecipientCustomField);
        addHidden('Mails', 'Mail' + (i + 1) + 'Subject', mail.Subject);
        addHidden('Mails', 'Mail' + (i + 1) + 'Template', mail.Template);
        addHidden('Mails', 'Mail' + (i + 1) + 'Template_path', mail.TemplatePath, true);
        addHidden('Mails', 'Mail' + (i + 1) + 'SenderName', mail.SenderName);
        addHidden('Mails', 'Mail' + (i + 1) + 'SenderEmail', mail.SenderMail);
        addHidden('Mails', 'Mail' + (i + 1) + 'IsCustomer', mail.IsCustomer);
        addHidden('Mails', 'Mail' + (i + 1) + 'IsDelivery', mail.IsDelivery);
        addHidden('Mails', 'Mail' + (i + 1) + 'IsCustomField', mail.IsCustomField);
        addHidden('Mails', 'Mail' + (i + 1) + 'EncodingCodePage', mail.EncodingCodePage);
        addHidden('Mails', 'Mail' + (i + 1) + 'Attachment', mail.Attachment);
        addHidden('Mails', 'Mail' + (i + 1) + 'Attachment_path', mail.AttachmentPath);

        // Add to table
        var row = table.insertRow(table.rows.length);
        
        var name = '';
        if (mail.IsCustomer) name = document.getElementById('Translate_Customer').innerHTML;
        if (mail.IsDelivery) name += (name ? ', ' : '') + document.getElementById('Translate_Delivery').innerHTML;
        if (mail.IsCustomField) name += (name ? ', ' : '') + document.getElementById('Translate_RecipientCustomField').innerHTML + ' ' + mail.RecipientCustomField;

        if (!name)
        {
            if (mail.Recipient.length > 0)
                name = mail.Recipient;
            else
                name = document.getElementById('Translate_No_recipient').innerHTML;
        }
            
        row.insertCell(row.cells.length).innerHTML = name;
        row.insertCell(row.cells.length).appendChild(createIcon('fa fa-pencil btn btn-flat m-l-5', 'editMail(' + i + ');', 'Edit'));
        row.insertCell(row.cells.length).appendChild(createIcon('fa fa-remove color-danger btn btn-flat m-l-5', 'deleteMail(' + i + ');', 'Delete'));
    }

}
