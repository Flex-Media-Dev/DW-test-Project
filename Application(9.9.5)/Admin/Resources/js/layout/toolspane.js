(function ($){
    // Doesn't work without jquery
    if (!$) return;

    function buildList(data) {
        // Create a node from a node object
        function createNode(nObj, $target, count) {
            var li = "";

            if (nObj.Seperator == null) {
                /* Create end nodes with no children */
                li = $('<li style="margin-left: -30px; opacity: 0">').appendTo($target);
                li.append($('<a href=\"' + nObj.DefaultAction + '\" class="pane-btn">').text(nObj.Title));
                                                                   
                //Add icon
                if (nObj.Icon != null && nObj.Icon != 0) {
                    li.find($('.pane-btn')).prepend($('<i class="md ' + nObj.Icon + '"></i>'));
                }

                $(li).delay((20 * count)).animate({ marginLeft: "0px", opacity: "1" }, 300);
            } else {
                li = $('<li>').appendTo($target);
                li.append($('<hr>'));
            }

            return li;
        }

        var innerList = $('<ul class="main-menu">').appendTo($('#toolspane'));

        for (var i = 0; i < data.length; i++) {
            createNode(data[i], innerList, i);
        }
    }

    //When clicking outside
    $(document).on('click', function (e) {
        if (($(e.target).closest('#toolspane').length === 0) && ($(e.target).closest('.btn-link').length === 0)) {
            setTimeout(function () {
                $("#toolspane").removeClass('toggled');
                $('span').removeClass('tree-highlight-micro-on');
                $('.dark-overlay').css({ 'display': "none" });
            });
        }
    });

    //PaneTools jQuery plugin
    $.fn.toolsPane = function (datalink) {
        $('#toolspane').find($('ul')).remove();

        $.getJSON(datalink, function (data) {
            buildList(data);
        });
    }

})(window.jQuery);