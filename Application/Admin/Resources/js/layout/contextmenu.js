(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    function buildList(options, data) {
        // Create a node from a node object
        function createNode(nObj, inner, count) {
            var li = "";

            if (nObj.Seperator == null) {
                //Add Action or Line seperator
                if (nObj.Name != "separator") {
                    li = $('<li role="presentation" class="' + (nObj.Enabled ? '' : 'disabled') + '">').appendTo(inner);
                    var a = $('<a href="#" role="menuitem" tabindex="-1" class="context-btn">').appendTo(li);
                    if (nObj.Enabled) {
                        a.on("click", function () {
                            $(this).parent().parent().parent().removeClass("open");
                            Action.Execute(nObj, options.model);
                        });
                    }
                    a.text(nObj.Title);
                } else {
                    li = $('<li class="divider">').appendTo(inner);
                }

                //Add icon
                if (nObj.Icon != null && nObj.Icon != 0) {
                    li.find($('.context-btn')).prepend($('<i class="' + nObj.Icon + ' ' + nObj.IconColor + '"></i>'));
                }

                $(li).delay((20 * count)).animate({ marginLeft: "0px", opacity: "1" }, 300);
            } else {
                li = $('<li>').appendTo(inner);
                li.append($('<hr>'));
            }

            return li;
        }

        var innerList = $('<ul class="dropdown-menu dm-icon" role="menu">').appendTo(options.target.parent());
        innerList.addClass(options.rightAlign ? "pull-right" : "pull-left");
        if (options.styles) {
            innerList.css(options.styles);
        }

        for (var i = 0; i < data.length; i++) {
            createNode(data[i], innerList, i);
        }
        return innerList;
    }

    //When clicking outside
    $(document).on('click', function (e) {
        if (($(e.target).closest(this).length === 0) && ($(e.target).closest('.context-btn').length === 0)) {
            setTimeout(function () {
                $me.removeClass('toggled');
            });
        }
    });

    $.fn.contextmenu = function (options) {
        var opts = $.extend({
            source: "",
            items: null,
            target: $(this),
            model: null,
            rightAlign: true
        }, options);
        var target = opts.target;
        target.parent().find($('ul.dropdown-menu')).remove();
        var buildItems = function (data) {            
            buildList(opts, data);            
        };
        if (opts.items) {
            buildItems(opts.items);
        } else {
            $.getJSON(opts.source, buildItems).fail(function () {
                console.log("context menu load error", opts.source, arguments);
            });
        }
    }

})(window.jQuery);