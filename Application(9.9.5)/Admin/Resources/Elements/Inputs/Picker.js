(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    // Picker
    function Picker($me) {
        // Generate list from data

        function defaultTrigger($me) {
        }

        return {
            //Initialize control
            init: function (title, root, type, callback) {

                $me.find('.form-control').addClass('picker-highlight');


                    // Execute Default Action
                $me.find('.form-control').on('click', function (e) {

                        if ($me.attr("default-trigger")) {
                            eval("Action.Execute(" + $me.attr("default-trigger") + ", {});");
                        }
                        else if ($me.attr("dialog-source")) {
                            Action.Execute({
                                "Name": "OpenDialog",
                                "Url": $me.attr("dialog-source"),
                                "Title": $me.attr("dialog-title"),
                                "OnSubmitted": {
                                    "Name": "SetValue",
                                    "Target": $me.find('.form-control').attr("id"),
                                    "Value": "{Selected}"
                                }
                            }, {});
                        }

                    });

                    $me.find('.btn').on('click', function (e) {
                        eval("Action.Execute(" + $me.attr("default-trigger") + ", {});");
                    });
                }
            }
    }



    //Picker jQuery plugin
    $.fn.Picker = function (options, title, root, type, callback) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;

        //All the elements by Picker
        return this.each(function () {
            var instance = new Picker($(this));

            if (instance[options]) {

                //Has requested method
                return instance[options](args);
            } else {

                //No method requested, so initialize
                instance.init(options, title, root, type, callback);
            }
        });
    }

    $(function () {
        $('.picker').Picker();
    });
})(window.jQuery);