/*
* Layout Main
*/

$(document).ready(function () {
    /*
     * Design switcher
     */
    if (getUrlParameter("layout")) {
        $('body').attr("id",(getUrlParameter("layout")+"-layout"));
    } else {
        $('body').attr("id","material-layout");
    }

    $('body').find('.layout-switch-trigger').on('click', function (e) {
        e.preventDefault();
        $('body').attr("id", ($(this).data('layout') + "-layout"));

        SwitchLayout($(this).data('layout'));
    });

    $('body').find('.input-layout-switch-trigger').on('click', function (e) {
        e.preventDefault();
        SwitchInputLayout();
    });

    $('body').find('.columns-switch-trigger').on('click', function (e) {
        e.preventDefault();
        SwitchColumnLayout();
    });

    $('body').find('.label-switch-trigger').on('click', function (e) {
        e.preventDefault();
        SwitchLabelLayout();
    });

    $('#profile-menu').css('display', 'block');


    /*
     * Static Sidebar / Iframe
     */

     //Set default startpage
    $(".static-menu > li > a").removeClass("active");
    $('.static-menu > li > a').filter('[data-target="Home"]').addClass("active");
    $('#Home-iframe').removeClass("iframe-closed");
    $('#Home-iframe').addClass("iframe-open");
    $('#sidebar-trigger').addClass("no-menu");

    /* Click an item in the static sidebar */

    $(document).on('click', '.static-menu > li > a', function (e, targetPageParams) {
        $(".static-menu > li > a").removeClass("active");
        $(this).addClass("active");

        if ($(this).data("target") == "Home") {
            $('#sidebar-trigger').addClass("no-menu");

            try {
                eval('window.Home.nomenu()');
            } catch (e) {

            }
        } else {
            $('#sidebar-trigger').removeClass("no-menu");
        }

        var thisIframe = "#" + $(this).data("target") + "-iframe";
        var thisIframeEl = $(thisIframe);
        //Reset the buttons
        for (var i = 0; i < areas.length; i++) {
            $('#' + areas[i] + '-iframe').removeClass("iframe-open");
            $('#' + areas[i] + '-iframe').addClass("iframe-closed");
        }


        //Load the content if it has not allready been loaded
        if (targetPageParams) {
            var qs = $.param(targetPageParams);
            var ref = thisIframeEl.data("targetpage");
            ref += ref.indexOf("?") > -1 ? "&" : "?" + qs;
            thisIframeEl.attr("src", ref);
        } else if (!thisIframeEl.attr('src')) {
            var ref = thisIframeEl.data("targetpage");
            thisIframeEl.attr('src', ref);
        }

        $(thisIframe).removeClass("iframe-closed");
        $(thisIframe).addClass("iframe-open");

        e.preventDefault();
        $('.dropdown').removeClass('open');
    }).on("contextmenu", function (e) {
        e.preventDefault();
        $('.dropdown').removeClass('open');
        $(e.target).closest('.dropdown').addClass('open');

        var el = $(e.target).closest("a");
        if (el) {
            var actions = el.data('actions');
            if (actions && actions.length) {
                var menu = el.contextmenu({
                    target: el,
                    items: actions,
                    rightAlign: false,
                    styles: { "position": "fixed", "left": el.outerWidth(), "top": el.offset().top }
                });
            }
        }
    });



    var menuItems = $(".static-menu > li > a").dblclick(function () {
        var thisIframe = "#" + $(this).data("target") + "-iframe";
        var thisIframeEl = $(thisIframe);
        thisIframeEl.attr('src', thisIframeEl.data("targetpage"));
    });
    if (menuItems.length > 0) {
        $(menuItems.get(0)).trigger("click");
    }

    $(document).on('click', '.frame-link-trigger', function (e) {
        $(".static-menu > li > a").removeClass("active");
        $('.static-menu > li > a').filter('[data-target="Home"]').addClass("active");

        for (var i = 0; i < areas.length; i++) {
            $('#' + areas[i] + '-iframe').addClass("iframe-closed");
        }

        $('#Home-iframe').removeClass("iframe-closed");
        $('#Home-iframe').addClass("iframe-open");

        $('#Home-iframe').attr('src', $(this).attr("href"));

        e.preventDefault();
    });


    (function(){
        //Toggle
        $('body').on('click', '#sidebar-trigger', function(e){            
            e.preventDefault();
            var x = $(this).data('trigger');
	    
            $(x).toggleClass('toggled');
            $(this).toggleClass('open');

            for (var i = 0; i < areas.length; i++) {
                eval('window.' + areas[i] + '.togglemenu()');
            }
        })
    })();
 
    /*
     * Waves Animation
     */
    (function(){
        var wavesList = ['.btn'];

        for(var x = 0; x < wavesList.length; x++) {
            if($(wavesList[x])[0]) {
                if($(wavesList[x]).is('a')) {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect waves-button');
                }
                else {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect');
                }
            }
        }

        setTimeout(function(){
            if ($('.waves-effect')[0]) {
               Waves.displayEffect();
            }
        });
    })();
});

$(window).resize(function () {
    if ($('body').innerWidth() < 1200) {
        $('#sidebar').removeClass('sw-toggled');
        $('body').removeClass('sw-toggled');
        $('body').addClass('sw-toggled-off');
    } else {
        $('#sidebar').addClass('sw-toggled');
        $('body').addClass('sw-toggled');
        $('body').removeClass('sw-toggled-off');
    }
});

function togglemenu() {
    if (!$(".sw-toggled")[0]) {
        $('#sidebar').addClass('sw-toggled');

        $('body').addClass('sw-toggled');
        $('body').removeClass('sw-toggled-off');
    }
    else {
        $('#sidebar').removeClass('sw-toggled');

        $('body').removeClass('sw-toggled');
        $('body').addClass('sw-toggled-off');
    }
}

$(window).resize(function () {
    if ($('body').innerWidth() < 1200) {
        $('#sidebar-trigger').removeClass("open");
    } else {
        $('#sidebar-trigger').addClass("open");
    }
});

function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

/*
* Layout switcher
*/

function SwitchLayout(layouttype) {
    /* Set defaults */
    $("#static-sidebar").prependTo("#main");
    $('#header-burger').addClass('hidden');
    $('iframe').css('width', 'calc(100% - 55px)');
    $('#a-content-container').css('padding-left', "58px");
    $("#settings-li").appendTo("#settings-menu");
    $('#static-sidebar').removeClass('hidden');
    $('#static-sidebar').addClass('show');

    localStorage.setItem('interface-layout', 'material');

    for (var i = 0; i < areas.length; i++) {
        eval('window.' + areas[i] + '.ResetSidebar()');
        eval('window.' + areas[i] + '.SwitchLayout("' + layouttype + '")');
        if ($('window.' + areas[i] + '.mainframe').length) {
            eval('window.' + areas[i] + '.mainframe.SwitchLayout("' + layouttype + '")');
        }
    }


    /* Material Layout */
    if ($('body').is("#material-layout")) {
        $('iframe').attr('data-layout', 'material-layout');
    }

    /* Flemming Layout */
    if ($('body').is("#flemming-layout")) {
        localStorage.setItem('interface-layout', 'flemming');
    }

    /* Light Layout */
    if ($('body').is("#light-layout") || $('body').is("#colorize-layout") || $('body').is("#flemming-layout")) {
        $("#static-sidebar").appendTo(".header-inner");
        $("#settings-li").appendTo("#static-menu");

        $('iframe').css('width', '100%');    
        $('#a-content-container').css('padding-left', "0px");
    }

    /* Hax Layout */
    if ($('body').is("#hax-layout")) {
        $("#static-sidebar").prependTo("#main");

        $('iframe').css('width', '100%');
        $('#a-content-container').css('padding-left', "0");

        $('#static-sidebar').addClass('hidden');
        $('#header-burger').removeClass('hidden');

        $("#settings-li").appendTo("#static-menu");

        $('body').on('click', '#header-burger', function (e) {
            ToggleHaxMenu(e);
        });

        /*
        for (var i = 0; i < areas.length; i++) {
            eval('window.' + areas[i] + '.HideSidebar()');
        }
        */

        $(document).on('click', '.static-menu > li > a', function (e) {
            if ($('body').is("#hax-layout")) {
                $('#static-sidebar').removeClass('show');
                $('#static-sidebar').addClass('hidden');

                /*
                for (var i = 0; i < areas.length; i++) {
                    eval('window.' + areas[i] + '.ShowSidebar()');
                }
                */
            }
        });
    }

    /* Metro Layout */
    if ($('body').is("#metro-layout")) {
        $('iframe').css('width', '100%');
        $('#a-content-container').css('padding-left', "0px");

        $("#settings-li").appendTo(".header-inner");
    }
}

/* The special Hax menu */
function ToggleHaxMenu(e) {
    e.preventDefault();

    if ($('#static-sidebar').hasClass('hidden')) {
        $('#static-sidebar').removeClass('hidden');
        $('#static-sidebar').addClass('show');

        /*
        for (var i = 0; i < areas.length; i++) {
            eval('window.' + areas[i] + '.HideSidebar()');
        }
        */
    } else {
        $('#static-sidebar').removeClass('show');
        $('#static-sidebar').addClass('hidden');

        /*
        for (var i = 0; i < areas.length; i++) {
            eval('window.' + areas[i] + '.ShowSidebar()');
        }
        */
    }
}

function SwitchInputLayout() {
    if (localStorage.getItem('input-layout') == "material" || localStorage.getItem('input-layout') == null) {
        localStorage.setItem('input-layout', 'boxed');
    } else {
        localStorage.setItem('input-layout', 'material');
    }

    SetInputLayout();
}

function SetInputLayout() {
    if (localStorage.getItem('input-layout') == "boxed" || localStorage.getItem('input-layout') == null) {
        $('.input-layout-switch-trigger').data('layout', 'boxed');
        $('.input-layout-switch-trigger').html('<i class="fa fa-toggle-off"></i> Boxed Fields');
    } else {
        $('.input-layout-switch-trigger').data('layout', 'material');
        $('.input-layout-switch-trigger').html('<i class="fa fa-toggle-on"></i> Material Fields');
    }

    //for (var i = 0; i < areas.length; i++) {
    //    if (areas[i] != "Home") {
    //        eval('window.' + areas[i] + '.SetInputLayout()');
    //    }
    //}
}
SetInputLayout();




function SwitchColumnLayout() {
    if (localStorage.getItem('columns-layout') == "material" || localStorage.getItem('columns-layout') == null) {
        localStorage.setItem('columns-layout', 'two-columns');
    } else {
        localStorage.setItem('columns-layout', 'material');
    }

    SetColumnLayout();
}

function SetColumnLayout() {
    if (localStorage.getItem('columns-layout') == "material" || localStorage.getItem('columns-layout') == null) {
        $('.columns-switch-trigger').data('layout', 'material');
        $('.columns-switch-trigger').html('<i class="fa fa-toggle-off"></i> Two columns');
    } else {
        $('.columns-switch-trigger').data('layout', 'columns');
        $('.columns-switch-trigger').html('<i class="fa fa-toggle-on"></i> One column');
    }
}
SetColumnLayout();

function SwitchLabelLayout() {
    if (localStorage.getItem('label-layout') == "material" || localStorage.getItem('label-layout') == null) {

    } else {
        localStorage.setItem('label-layout', 'material');
    }
}