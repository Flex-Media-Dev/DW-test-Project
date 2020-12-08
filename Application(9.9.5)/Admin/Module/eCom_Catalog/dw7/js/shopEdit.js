var backend = {
    patterns: null,
    index: 1,
    

    toggleUseAltImage: function () {
        var chk = $("UseAlternativeImages");
        document.getElementById('AlternativeImageSection').style.display = chk.checked ? 'block' : 'none';
    },

    toggleSearchInSubfolders: function () {
        var warning = document.getElementById('PatternsWarningContainer');
        if (warning !== null) {
            warning.style.display = $("ImageSearchInSubfolders").checked ? 'block' : 'none';
        }
    },

    convertImages: function () {
        new overlay('__ribbonOverlay').show();
        var form = document.getElementById("Form1");       
        document.getElementById("ConvertOldImages").value = "true";
        form.submit()
    },
};