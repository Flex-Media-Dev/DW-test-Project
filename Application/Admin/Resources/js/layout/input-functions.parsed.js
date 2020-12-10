jQuery(document).ready(function () {

    /*
     * Text Feild
     */

    //Add blue animated border and remove with condition when focus and blur
    if (jQuery('.form-group-input')[0]) {
        jQuery('body').on('focus', '.form-control', function () {
            jQuery(this).closest('.form-group-input').addClass('fg-toggled');
        })

        jQuery('body').on('blur', '.form-control', function () {
            var p = jQuery(this).closest('.form-group');
            var i = p.find('.form-control').val();

            if (p.hasClass('fg-float')) {
                if (i.length == 0) {
                    jQuery(this).closest('.form-group-input').removeClass('fg-toggled');
                }
            }
            else {
                jQuery(this).closest('.form-group-input').removeClass('fg-toggled');
            }
        });
    }

    //Add blue border for pre-valued fg-flot text feilds
    if (jQuery('.fg-float')[0]) {
        jQuery('.fg-float .form-control').each(function () {
            var i = jQuery(this).val();

            if (!i.length == 0) {
                jQuery(this).closest('.form-group-input').addClass('fg-toggled');
            }

        });
    }

    //Maxcounter on input fields
    jQuery('input[maxlength]').maxlength({
        placement: 'centered-right',
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-danger",
        validate: true
    });

    //Maxcounter on textareas
    jQuery('textarea[maxlength]').maxlength({
        placement: 'centered-right',
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-danger",
        validate: true
    });

    /*
     * Auto Hight Textarea
     */
    if (jQuery('.auto-size')[0]) {
        jQuery('.auto-size').autosize();
    }

    /*
    * Custom Select
    */
    if (jQuery('.selectpickers')[0]) {
        jQuery('.selecstpicker').selectpicker();
    }

    /*
     * Tag Select
     */
    if (jQuery('.tag-select')[0]) {
        jQuery('.tag-select').chosen({
            width: '100%',
            allow_single_deselect: true
        });
    }

    /*
     * Input Slider
     */

    //Range slider with value
    /*
    if (jQuery('.fg-slider')[0]) {
        jQuery('.fg-slider > .input-slider-values').each(function () {
            var preset = jQuery(this).parent().data('start');
            var sliderconnect = "lower";
            var stepsize = 1;

            if (jQuery(this).parent().data('end')) {
                preset = [jQuery(this).parent().data('start'), jQuery(this).parent().data('end')];
                sliderconnect = true;
            }

            if (jQuery(this).parent().data('step')) {
                stepsize = jQuery(this).parent().data('step')
            }

            jQuery(this).noUiSlider({
                start: preset,
                step: stepsize,
                connect: sliderconnect,
                direction: 'ltr',
                behaviour: 'tap-drag',
                range: {
                    'min': jQuery(this).parent().data('min'),
                    'max': jQuery(this).parent().data('max')
                }
            });

            jQuery(this).Link('lower').to(jQuery(this).parent().find('.slider-min-text'));

            if (sliderconnect == true) {
                jQuery(this).Link('upper').to(jQuery(this).parent().find('.slider-max-text'));
            }
        });
    }
    */

    /*
     * Input Mask
     */
    if (jQuery('input-mask')[0]) {
        jQuery('.input-mask').mask();
    }

    /*
     * HTML Editor
     */
    if (jQuery('.html-editor')[0]) {
        jQuery('.html-editor').summernote({
            height: 150
        });
    }

    if (jQuery('.html-editor-click')[0]) {
        //Edit
        jQuery('body').on('click', '.hec-button', function () {
            jQuery('.html-editor-click').summernote({
                focus: true
            });
            jQuery('.hec-save').show();
        })

        //Save
        jQuery('body').on('click', '.hec-save', function () {
            jQuery('.html-editor-click').code();
            jQuery('.html-editor-click').destroy();
            jQuery('.hec-save').hide();
            notify('Content Saved Successfully!', 'success');
        });
    }

    //Air Mode
    if (jQuery('.html-editor-airmod')[0]) {
        jQuery('.html-editor-airmod').summernote({
            airMode: true
        });
    }

    /*
     * Link prevent
     */
    jQuery('body').on('click', '.a-prevent', function (e) {
        e.preventDefault();
    });

    /*
     * Tooltips
     */
    if (jQuery('[data-toggle="tooltip"]')[0]) {
        jQuery('[data-toggle="tooltip"]').tooltip();
    }

    /*
     * Popover
     */
    if (jQuery('[data-toggle="popover"]')[0]) {
        jQuery('[data-toggle="popover"]').popover();
    }
});
