
CKEDITOR.plugins.add('etags',
{
    requires: ['richcombo'],
    init: function(editor)
    {
        var tags = [];

        tags.push(['{{Email:User.UserName||"FALLBACK VALUE"}}', 'User Name', 'User Name']);
        tags.push(['{{Email:User.Name||"FALLBACK VALUE"}}', 'Name', 'Name']);
        tags.push(['{{Email:User.Address||"FALLBACK VALUE"}}', 'Address', 'Address']);
        tags.push(['{{Email:User.Address2||"FALLBACK VALUE"}}', 'Address 2', 'Address 2']);
        tags.push(['{{Email:User.ZipCode||"FALLBACK VALUE"}}', 'Zip Code', 'Zip Code']);
        tags.push(['{{Email:User.City||"FALLBACK VALUE"}}', 'City', 'City']);
        tags.push(['{{Email:User.Country||"FALLBACK VALUE"}}', 'Country', 'Country']);
        tags.push(['{{Email:User.Phone||"FALLBACK VALUE"}}', 'Phone', 'Phone']);
        tags.push(['{{Email:User.PhonePrivate||"FALLBACK VALUE"}}', 'Private Phone', 'Private Phone']);
        tags.push(['{{Email:User.PhoneMobile||"FALLBACK VALUE"}}', 'Mobile Phone', 'Mobile Phone']);
        tags.push(['{{Email:User.Fax||"FALLBACK VALUE"}}', 'Fax', 'Fax']);
        tags.push(['{{Email:User.CustomerNumber||"FALLBACK VALUE"}}', 'Customer Number', 'Customer Number']);
        tags.push(['{{Email:User.Currency||"FALLBACK VALUE"}}', 'Currency', 'Currency']);
        tags.push(['{{Email:User.Image||"FALLBACK VALUE"}}', 'Image', 'Image']);
        tags.push(['{{Email:User.Company||"FALLBACK VALUE"}}', 'Company', 'Company']);
        tags.push(['{{Email:User.Department||"FALLBACK VALUE"}}', 'Department', 'Department']);
        tags.push(['{{Email:User.JobTitle||"FALLBACK VALUE"}}', 'Job Title', 'Job Title']);
        tags.push(['{{Email:User.PhoneBusiness||"FALLBACK VALUE"}}', 'Business Phone', 'Business Phone']);

        if (CKEditorEtagsUserCustomFields) {
            tags = tags.concat(CKEditorEtagsUserCustomFields);
        }

        editor.ui.addRichCombo('etags',
		{
		    label: 'Email values',
		    title: 'Email values',
		    voiceLabel: 'Email values',
		    className: 'cke_format',
		    multiSelect: false,
		    toolbar: 'etags',
		    panel:
			{
			    css: [editor.config.contentsCss, CKEDITOR.skin.getPath('editor')],
			    voiceLabel: editor.lang.panelVoiceLabel
			},

		    init: function()
		    {
		        this.startGroup("Email values");

		        for(i = 0; i < tags.length; i++)
		            this.add(tags[i][0], tags[i][1], tags[i][2]);
		    },

		    onClick: function(value)
		    {
		        editor.focus();
		        editor.fire('saveSnapshot');
		        editor.insertHtml(value);
		        editor.fire('saveSnapshot');
		    }
		});
    }
});
