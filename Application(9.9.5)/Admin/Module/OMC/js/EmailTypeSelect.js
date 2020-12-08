function createEmailTypeSelectorPage(opts)
{
    const options = opts;
    return {
        createEmail: function (tplId) {
            showOverlay("wait");
            document.getElementById("templateId").value = tplId ? tplId : "";
            const frm = document.forms[0];
            frm.submit();
        }
    };
}