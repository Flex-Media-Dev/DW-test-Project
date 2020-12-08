(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    // Picker
    function Picker($me) {
        // Generate list from data
        function OpenDialog($me, title, root, type, callback) {
            window.top.openDialog();
            var dialog = window.top.Dialog.$('body');
            
            //Set The title on the dialog
            dialog.find('.modal-title').text(title);

            //Fill the dialog with content
            if (type == "treeview") {
                dialog.find('.modal-body').append('<div id="modal-treeview" class="treeview tree"></div>');

                $.post('/Admin/Content-Navigator', { Name: null }, function (data) {
                    dialog.find('#modal-treeview').treeView(data, '/Admin/api/navigators/Content/', SelectCloseDialog);
                }, 'json');
            }

            if (type == "tiles") {
                dialog.find('.modal-body').append('<div id="modal-tilesview"></div>');

                $.post('/Admin/Content-Navigator', { Name: null }, function (data) {
                    dialog.find('#modal-tilesview').TilesView(data, '/Admin/api/navigators/Content/', SelectCloseDialog);
                }, 'json');
            }

            if (type == "combi") {
                dialog.find('.modal-body').append('<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12"><div id="modal-treeview" class="treeview tree"></div></div>');

                $.post('/Admin/Content-Navigator', { Name: null }, function (data) {
                    dialog.find('#modal-treeview').treeView(data, '/Admin/Content-Navigator', ShowTiles);
                }, 'json');
            }

            function ShowTiles(title, dataobject) {
                dialog.find('#modal-tilesview').remove();

                dialog.find('.modal-body').append('<div class="col-lg-8 col-md-8 col-sm-6 col-xs-12"><div id="modal-tilesview"></div></div>');

                $.post('/Admin/Content-Navigator', { Name: null }, function (data) {
                    dialog.find('#modal-tilesview').TilesView(data, '/Admin/api/navigators/Content/', SelectCloseDialog);
                }, 'json');
            }

            //modalfooter = $('<div class="modal-footer">').appendTo(modalcontainer);
            //modalfooter.append($('<button type="button" class="btn btn-success">Save changes</button>'));

            /*
            $('body').addClass('modal-open overflow-x');
            $('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');
            */

            $me.find('#modal-close').on('click', function (e) {
                CloseDialog();
            });

            function CloseDialog() {
                window.top.closeDialog();

                $me.find('#picker-modal').remove();

                $('body').removeClass('modal-open overflow-x');
                $('#dark-overlay').remove();
            }

            function SelectCloseDialog(value, dataobject) {
                CloseDialog();

                $me.find('.form-control').val(value);
                $me.find('.form-control').addClass('highlight');
                $me.find('.form-control').css('opacity', '0');
                $me.find('.form-control').animate({ opacity: "1" }, 300);
                $me.find('.form-control').delay(400).animate({ opacity: "0" }, 300);

                setTimeout(function () {
                    $me.find('.form-control').css('opacity', '1');
                    $me.find('.form-control').removeClass('highlight');
                }, 1100);

                if (callback) {
                    callback(dataobject);
                }
            }
        }

        return {
            //Initialize control
            init: function (title, root, type, callback) {
                if (!title) {
                    title = $me.data('title');
                }

                if (!root) {
                    root = $me.data('root');
                }

                if (!type) {
                    type = $me.data('type');
                }

                if (!callback) {
                    callback = $me.data('callback');
                }

                $me.find('.form-control').addClass('picker-highlight');

                //Show the selected item
                $me.find('.form-control').on('click', function (e) {
                    OpenDialog($me, title, root, type, callback);
                });

                $me.find('.btn').on('click', function (e) {
                    OpenDialog($me, title, root, type, callback);
                });
            }
        }
    }

    /*
     * Auto link the plugin to any picker
     */
    $(document).ready(function () {
        (function () {
            $('.picker').Picker();
        })();
    });

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

})(window.jQuery);