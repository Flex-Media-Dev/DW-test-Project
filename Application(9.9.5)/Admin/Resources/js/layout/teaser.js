(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    // Teaser
    function Teaser($me) {

        // Generate list from data
        function generateList(data) {
            var self = this;
            var teaserObj = "";
            teaserObj = $('<div>').appendTo($me);
            
            if (imageExists(data.items[0].Image)) {
                $('<div class="img-responsive"><img src="' + data.items[0].Image + '" class="teaser-image" /></div>').appendTo(teaserObj);
            }

            var text = $('<div class="teaser-text">').appendTo(teaserObj);

            $('<h3 class="teaser-title">' + data.items[0].Title + '</h3>').appendTo(text);
            $('<div class="teaser-description">' + data.items[0].Description + '</div>').appendTo(text);

            $('<button type="button" class="teaser-button btn btn-flat bgm-orange">' + data.items[0]['Link text'] + '</button>').appendTo(text);
        }

        function imageExists(url) {
            var img = new Image();
            img.onload = function() { return true };
            img.onerror = function() { return false };
            img.src = url
        }

        return {
            //Initialize control
            init: function (options) {
                // Handle undefined error
                options = options || {};
                this.options = options;
                this.reload();
            },
            reload: function () {
                var self = this;
                $me.empty();
                $.post(self.options.datasource, { Name: null, format: "json" }, function (data) {
                    if (data != null) {
                        // Generate the list
                        generateList.apply(self, [data]);
                    }
                }, 'jsonp').error(function (response) {
                    if (response != null && response.responseText != null) {
                        var inner = response.responseText.split(/<body[^>]*>|(.*?)<\/body>/igm)[2];
                        $me.html("<div style=\"overflow: scroll;height: 100%;\">" + inner || response.responseText + "</div>");
                    }
                });
            }
        }
    }

    //Teaser jQuery plugin
    $.fn.Teaser = function (options) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;
        var res = [];
        //All the elements by teaser
        this.each(function () {
            var $this = $(this);
            var data = $this.data("teaser");
            if (!data) {
                $this.data("teaser", (data = new Teaser($this)));
                data.init(options);
            }
            else if (options == "get") {
                res.push(data);
            }
            else if (data[options]) {
                data[options].apply(data, args);
            }
        });
        if (options == "get") {
            return res;
        }
        return this;
    }

/*
 * Auto link the plugin to any teaser
 */
    $(document).ready(function () {
        (function () {
            $(".teaser").each(function () {
                var el = $(this);
                if (el.data('datasource')) {
                    el.Teaser(el.data());
                }
            });
        })();
    });
})(window.jQuery);