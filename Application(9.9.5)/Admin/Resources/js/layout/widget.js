(function ($) {
    function WidgetCard($me) {
        var generateActionsDropDown = function () {
            var cardBody = $me.find(".card-body");
            var dropDown = $('<div class="dropdown">');
            var btn = $('<button class="btn-link pull-right contextTrigger" data-toggle="dropdown" aria-expanded="false"><i class="md md-more-vert"></i></button>').appendTo(dropDown);
            dropDown.appendTo(cardBody);
            attachEventsToChildNodes(this, $me);
        };

        var attachEventsToChildNodes = function (self, cnt) {
            var opts = self.options;
            var reinitializeMenu = true;
            //Trigger the context-menu
            cnt.find('.contextTrigger').on('click', function (e) {
                e.preventDefault();
                if (reinitializeMenu) {
                    $(this).contextmenu({
                        source: opts.actionsDataSource,
                        items: opts.actions,
                        rightAlign: true
                    });
                    reinitializeMenu = !opts.actions;
                }
            }).on('contextmenu', function (e) {
                e.preventDefault();
                $('.dropdown').removeClass('open');
                $(this).closest('.dropdown').addClass('open');
                $(this).trigger("click");
            });

            cnt.on("contextmenu", function (e) {
                e.preventDefault();
                var $el = $(this);
                $el.find('.contextTrigger').trigger("click");
            });
        };

        return {
            init: function (options) {
                var opts = this.options = $.extend({
                    actionsVisible: false,
                    actionsDataSource: null,
                    actions: null
                }, options);
                $.map(opts, function (val, propName) {
                    if (propName == "actions" && val && typeof val == "string") {
                        opts[propName] = JSON.parse(val);
                    }
                    if (val && typeof val == "string") {
                        val = val.toLowerCase();
                        if (val == "true") {
                            opts[propName] = true;
                        } else if (val == "false") {
                            opts[propName] = false;
                        }
                    }
                });
                opts.actionsVisible = !!(opts.actionsVisible && (opts.actionsDataSource || opts.actions));
                if (opts.actionsVisible) {
                    var dataSource = opts.actionsDataSource;
                    var self = this;
                    if (dataSource) {
                        $.get(dataSource, function (data) {
                            opts.actions = data;
                            generateActionsDropDown.apply(self);
                        }, 'json');
                    }
                    else {
                        generateActionsDropDown.apply(self);
                    }
                }
            }
        };
    }

    //TilesView jQuery plugin
    $.fn.widgetCard = function (option) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;

        //All the elements by selector
        return this.each(function () {
            var $this = $(this);
            var apiObj = $this.data("widgetCard");
            if (!apiObj) {
                $this.data("widgetCard", (apiObj = new WidgetCard($this)));
                apiObj.init(option);
            }
            else if (apiObj[option]) {
                return apiObj[option].apply(apiObj, args);
            }
        });
    }

    $(window).on('load.dw.widget.data-api', function () {
        $(".widget.card").each(function () {
            var el = $(this);
            el.widgetCard(el.data());
        });
    });
})(window.jQuery);