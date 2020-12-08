$(document).ready(function () {

    /*
     * Text Feild
     */

    //Add blue animated border and remove with condition when focus and blur
    if ($('.form-group-input')[0]) {
        $('body').on('focus', '.form-control', function () {
            $(this).closest('.form-group-input').addClass('fg-toggled');
        })

        $('body').on('blur', '.form-control', function () {
            var p = $(this).closest('.form-group');
            var i = p.find('.form-control').val();

            if (p.hasClass('fg-float')) {
                if (i.length == 0) {
                    $(this).closest('.form-group-input').removeClass('fg-toggled');
                }
            }
            else {
                $(this).closest('.form-group-input').removeClass('fg-toggled');
            }
        });
    }

    //Add blue border for pre-valued fg-flot text feilds
    if ($('.fg-float')[0]) {
        $('.fg-float .form-control').each(function () {
            var i = $(this).val();

            if (!i.length == 0) {
                $(this).closest('.form-group-input').addClass('fg-toggled');
            }

        });
    }

    //Maxcounter on input fields
    $('input[maxlength]').maxlength({
        placement: 'centered-right',
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-danger",
        validate: true
    });

    //Maxcounter on textareas
    $('textarea[maxlength]').maxlength({
        placement: 'centered-right',
        threshold: 10,
        warningClass: "label label-success",
        limitReachedClass: "label label-danger",
        validate: true
    });

    /*
     * Auto Hight Textarea
     */
    if ($('.auto-size')[0]) {
        $('.auto-size').autosize();
    }

    /*
    * Custom Select
    */
    if ($('.selectpickers')[0]) {
        $('.selecstpicker').selectpicker();
    }

    /*
     * Tag Select
     */
    if ($('.tag-select')[0]) {
        $('.tag-select').chosen({
            width: '100%',
            allow_single_deselect: true
        });
    }

    /*
     * Input Slider
     */

    //Range slider with value
    /*
    if ($('.fg-slider')[0]) {
        $('.fg-slider > .input-slider-values').each(function () {
            var preset = $(this).parent().data('start');
            var sliderconnect = "lower";
            var stepsize = 1;

            if ($(this).parent().data('end')) {
                preset = [$(this).parent().data('start'), $(this).parent().data('end')];
                sliderconnect = true;
            }

            if ($(this).parent().data('step')) {
                stepsize = $(this).parent().data('step')
            }

            $(this).noUiSlider({
                start: preset,
                step: stepsize,
                connect: sliderconnect,
                direction: 'ltr',
                behaviour: 'tap-drag',
                range: {
                    'min': $(this).parent().data('min'),
                    'max': $(this).parent().data('max')
                }
            });

            $(this).Link('lower').to($(this).parent().find('.slider-min-text'));

            if (sliderconnect == true) {
                $(this).Link('upper').to($(this).parent().find('.slider-max-text'));
            }
        });
    }
    */

    /*
     * Input Mask
     */
    if ($('input-mask')[0]) {
        $('.input-mask').mask();
    }

    /*
     * HTML Editor
     */
    if ($('.html-editor')[0]) {
        $('.html-editor').summernote({
            height: 150
        });
    }

    if ($('.html-editor-click')[0]) {
        //Edit
        $('body').on('click', '.hec-button', function () {
            $('.html-editor-click').summernote({
                focus: true
            });
            $('.hec-save').show();
        })

        //Save
        $('body').on('click', '.hec-save', function () {
            $('.html-editor-click').code();
            $('.html-editor-click').destroy();
            $('.hec-save').hide();
            notify('Content Saved Successfully!', 'success');
        });
    }

    //Air Mode
    if ($('.html-editor-airmod')[0]) {
        $('.html-editor-airmod').summernote({
            airMode: true
        });
    }

    /*
     * Link prevent
     */
    $('body').on('click', '.a-prevent', function (e) {
        e.preventDefault();
    });

    /*
     * Tooltips
     */
    if ($('[data-toggle="tooltip"]')[0]) {
        $('[data-toggle="tooltip"]').tooltip();
    }

    /*
     * Popover
     */
    if ($('[data-toggle="popover"]')[0]) {
        $('[data-toggle="popover"]').popover();
    }
});
