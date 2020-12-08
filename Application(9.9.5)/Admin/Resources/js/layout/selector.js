(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    // Selector
    function Selector($me) {

        // Generate list from data
        function generateList(data) {
            var self = this;
            // Create a node from a node object
            function createNode(nObj, $target) {
                var opt = "";                
                var icon = "";
                var flag = "";
                if (nObj.Icon != "" && nObj.Icon != null) {
                    icon = "<i class=\"" + nObj.Icon + "\"></i>";
                }

                if (nObj.Country != "" && nObj.Country != null) {
                    flag = "<i class=\"flag-icon flag-icon-" + nObj.Country + "\"></i>";
                }

                /* Create end nodes with no children */
                opt = $('<option>').appendTo($target);
                opt.append(icon);
                opt.append(flag);
                if (nObj.Attributes) {
                    for (var attributeName in nObj.Attributes) {
                        opt.attr(attributeName, nObj.Attributes[attributeName]);
                    }
                }
                opt.append(nObj.Title);

                /* Create the action data object */
                opt.data('dataobject', nObj.Id);
                opt.val(nObj.Id);
                return opt;
            }

            //Enable search if there is more than 10 items
            var innerList = "";
            if (data.length <= 10) {
                innerList = $('<select class="selectpicker">').appendTo($me);
            } else {
                innerList = $('<select class="selectpicker" data-size="8" data-live-search="true">').appendTo($me);
            }

            innerList.attr('name', $me.attr('name'));

            if ($me.attr('disabled') == 'disabled')
            {
                innerList.attr('disabled', 'disabled');
            }

            //Enable multi-select
            if (self.options.type == true) {
                innerList.attr('multiple', 'true');
            }

            //Create the all option
            if (self.options.selectall) {
                var opt = "";
                opt = $('<option id="selector-all">').appendTo(innerList);
                opt.append("All");
                opt.data('dataobject', '');
                opt.val("");
            }

            //Create the options
            let optGroup = null;
            for (var i = 0; i < data.length; i++) {
                var nObj = data[i];
                if (nObj.IsOptGroup) {
                    optGroup = $('<optgroup>').appendTo(innerList);
                    optGroup.attr('label', nObj.Title);
                } else {
                    if (!self.options.showOnlyHasnodes || data[i].HasNodes == true) {
                        createNode(nObj, optGroup || innerList);
                    }
                } 
            }

            //initial select
            var optionDataObj = self.options.dataobject;
            var selOptions = $me.find('option');
            if (!optionDataObj || !selOptions.filter("[value=" + optionDataObj + "]").length) {
                optionDataObj = selOptions.first().data("dataobject");
                self.options.dataobject = optionDataObj;
            }

            var sp = $('.selectpicker', $me);
            sp.val(optionDataObj);
            if (self.options.itemchanged) {
                self.options.itemchanged(optionDataObj, true);
            }
            sp.selectpicker('render');

            //Show the selected item
            innerList.on('change', function (e) {
                var dataObject = this.value;
                self.options.dataobject = dataObject;
                if (self.options.itemchanged) {
                    self.options.itemchanged(dataObject);
                }
            });
        }

        return {
            //Initialize control
            init: function (options) {
                // Handle undefined error
                options = options || {};
                if (options.itemchanged) {
                    if (typeof options.itemchanged != "function") {
                        options.itemchanged = window[options.itemchanged];
                    }
                    if (typeof options.itemchanged != "function") {
                        options.itemchanged = function () { };
                    }
                }
                this.options = options;

                this.reload();

            },
            select: function (val, forceSelect) {
                var defer = $.Deferred();
                var curVal = $('.selectpicker').selectpicker("val");
                if (curVal == val && !forceSelect) {
                    defer.resolve();
                }
                else {
                    $('.selectpicker').selectpicker("val", val);
                    this.options.dataobject = val;
                    this.options.itemchanged(val, function () {
                        defer.resolve();
                    });
                }
                return defer.promise();
            },
            reload: function (afterLoadCallback) {
                var self = this;
                $me.find('div.dropdown-menu').removeClass("open");
                $me.empty();
                $.post(self.options.datasource, { Name: null }, function (data) {
                    if (data != null) {
                        // Generate the list
                        generateList.apply(self, [data]);
                    }
                    if (afterLoadCallback) {
                        afterLoadCallback();
                    }
                }, 'json');
            }
        }
    }

    //Selector jQuery plugin
    $.fn.Selector = function (options) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;
        var res = [];
        //All the elements by selector
        this.each(function () {
            var $this = $(this);
            var data = $this.data("selector");
            if (!data) {
                $this.data("selector", (data = new Selector($this)));
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
 * Auto link the plugin to any selector
 */
    $(document).ready(function () {
        (function () {
            $(".selector").each(function () {
                var el = $(this);
                if (el.data('datasource')) {
                    el.Selector(el.data());
                }
            });
        })();
    });
})(window.jQuery);