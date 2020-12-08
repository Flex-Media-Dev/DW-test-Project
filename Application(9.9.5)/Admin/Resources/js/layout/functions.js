/*
* Layout Main
*/

var layoutStatus = localStorage.getItem('menu-layout-status');
if (layoutStatus == 1 || layoutStatus === null) {
    $('#sidebar').addClass('sw-toggled');
    $('body').addClass('sw-toggled');
    $('body').removeClass('sw-toggled-off');
}

$(window).resize(function(){     
    if ($('body').innerWidth() < 1200 ){
        $('#sidebar').removeClass('sw-toggled');
        $('body').removeClass('sw-toggled');
        $('body').addClass('sw-toggled-off');
    } else {
        if (localStorage.getItem('menu-layout-status') == 1 || localStorage.getItem('menu-layout-status') === null) {
            $('#sidebar').addClass('sw-toggled');
            $('body').addClass('sw-toggled');
            $('body').removeClass('sw-toggled-off');
        }
    }
});

function togglemenu() {
    if (!$(".sw-toggled")[0]) {
        $('#sidebar').addClass('sw-toggled');

        $('body').addClass('sw-toggled');
        $('body').removeClass('sw-toggled-off');

        localStorage.setItem('menu-layout-status', 1);
    }
    else {
        $('#sidebar').removeClass('sw-toggled');

        $('body').removeClass('sw-toggled');
        $('body').addClass('sw-toggled-off');

        localStorage.setItem('menu-layout-status', 0);
    }
}

/*
* Layout Site
*/

if (layoutStatus == 1 || layoutStatus === null) {
    $('#sidebar-trigger').addClass("open");
}

$(window).resize(function(){     
    if ($('body').innerWidth() < 1200 ){
        $('#sidebar-trigger').removeClass("open");
    } else {
        if (layoutStatus == 1) {
            $('#sidebar-trigger').addClass("open");
        }
    }
});


$(document).ready(function(){
    
    /*
     * Static Sidebar / Iframe
     */

    var currentPage = localStorage.getItem('current-iframe-page');

    if (currentPage === null){
        currentPage = "home";
    }

    $(".static-menu li > a").removeClass("active");
    $('.static-menu li > a').filter('[data-target='+currentPage+']').addClass("active");

    for (var i = 0; i < areas.length; i++) {
        if (currentPage == areas[i])
        {
            $('#' + currentPage + '-iframe').removeClass("iframe-closed");
            $('#' + currentPage + '-iframe').addClass("iframe-open");
        }
    }


    switch (currentPage){

        case "home":
            $('#home-iframe').removeClass("iframe-closed");
            $('#home-iframe').addClass("iframe-open");

            $('#sidebar-trigger').removeClass("open");
            $('#sidebar-trigger').addClass("no-menu");
        break;

        case "content":
            $('#content-iframe').removeClass("iframe-closed");
            $('#content-iframe').addClass("iframe-open");
        break;

        case "filemanager":
            $('#filemanager-iframe').removeClass("iframe-closed");
            $('#filemanager-iframe').addClass("iframe-open");
        break;

        case "ecommerce":
            $('#ecommerce-iframe').removeClass("iframe-closed");
            $('#ecommerce-iframe').addClass("iframe-open");
        break;

        case "users":
            $('#users-iframe').removeClass("iframe-closed");
            $('#users-iframe').addClass("iframe-open");
        break;

        case "marketing":
            $('#marketing-iframe').removeClass("iframe-closed");
            $('#marketing-iframe').addClass("iframe-open");
        break;

        default:
        $('#home-iframe').removeClass("iframe-closed");    
        $('#home-iframe').addClass("iframe-open");

        $('#sidebar-trigger').removeClass("open");
        $('#sidebar-trigger').addClass("no-menu");
    }


    /* Click an item in the static sidebar */

    $(document).on('click', '.static-menu li > a', function() {
       $(".static-menu li > a").removeClass("active");
       $(this).addClass("active");

       if ($(this).data("target") == "home"){
            $('#sidebar-trigger').addClass("no-menu");
        } else {
            $('#sidebar-trigger').removeClass("no-menu");

            if (localStorage.getItem('menu-layout-status') == 1 || localStorage.getItem('menu-layout-status') === null) {
                $('#sidebar-trigger').addClass("open");
            } else {
                $('#sidebar-trigger').removeClass("open");
            }
        }

        var thisIframe = "#"+$(this).data("target")+"-iframe";

        $('#home-iframe').removeClass("iframe-open");
        $('#content-iframe').removeClass("iframe-open");
        $('#filemanager-iframe').removeClass("iframe-open");
        $('#ecommerce-iframe').removeClass("iframe-open");
        $('#users-iframe').removeClass("iframe-open");
        $('#marketing-iframe').removeClass("iframe-open");

        for (var i = 0; i < areas.length; i++) {
            $('#' + areas[i] + '-iframe').addClass("iframe-open");
        }

        $('#home-iframe').addClass("iframe-closed");
        $('#content-iframe').addClass("iframe-closed");
        $('#filemanager-iframe').addClass("iframe-closed");
        $('#ecommerce-iframe').addClass("iframe-closed");
        $('#users-iframe').addClass("iframe-closed");
        $('#marketing-iframe').addClass("iframe-closed");

        for (var i = 0; i < areas.length; i++) {
            $('#' + areas[i]+'-iframe').addClass("iframe-closed");
        }

        $(thisIframe).removeClass("iframe-closed");
        $(thisIframe).addClass("iframe-open");


        localStorage.setItem('current-iframe-page', $(this).data("target"));
    });

    $(".static-menu li > a").dblclick(function() {
        var thisIframe = "#"+$(this).data("target")+"-iframe";
        $(thisIframe).attr('src', $(thisIframe).attr('src'));
    });


    /*
     * Sidebar
     */
    (function(){
        //Toggle

        $('body').on('click', '#sidebar-trigger', function(e){            
            e.preventDefault();
            var x = $(this).data('trigger');
	    
            $(x).toggleClass('toggled');
            $(this).toggleClass('open');

            window.contentmanager.togglemenu();
            window.filemanager.togglemenu();
            window.ecommerce.togglemenu();
            window.users.togglemenu();
            window.marketing.togglemenu();

            for (var i = 0; i < areas.length; i++) {
                eval('window.' + areas[i] + '.togglemenu()');
            }

        })

        $('body').on('click', '.settings-trigger', function(e){            
            e.preventDefault();
            var x = $(this).data('trigger');
        
            $(x).toggleClass('toggled');
            $(this).toggleClass('open');

            if (x == '#settings') {
                $elem = '#settings';
                $elem2 = '.settings-trigger';
            }
            
            //When clicking outside
            $(document).on('click', function (e) {
                if (($(e.target).closest($elem).length === 0) && ($(e.target).closest($elem2).length === 0)) {
                    setTimeout(function(){
                        $($elem).removeClass('toggled');
                        $($elem2).removeClass('open');
                    });
                }
            });
        })

        $('tbody').on('click', '.settings-trigger', function(e){            
            e.preventDefault();
            var x = $(this).data('trigger');
        
            $(x).toggleClass('toggled');
            $(this).toggleClass('open');

            if (x == '#settings') {
                $elem = '#settings';
                $elem2 = '.settings-trigger';
            }
            
            //When clicking outside
            if ($('body').hasClass('sw-toggled')) {
                $(document).on('click', function (e) {
                    if (($(e.target).closest($elem).length === 0) && ($(e.target).closest($elem2).length === 0)) {
                        setTimeout(function(){
                            $($elem).removeClass('toggled');
                            $($elem2).removeClass('open');
                        });
                    }
                });
            }
        })
        
        //Submenu
        $('body').on('click', '.sub-menu > a', function(e){
            e.preventDefault();
            $(this).next().slideToggle(200);
            $(this).parent().toggleClass('toggled');
        });
    })();

    /*
     * Dropdown Menu
     */
    if($('.dropdown')[0]) {
	//Propagate
	$('body').on('click', '.dropdown.open .dropdown-menu', function(e){
	    e.stopPropagation();
	});
	
	$('.dropdown').on('shown.bs.dropdown', function (e) {
	    if($(this).attr('data-animation')) {
		$animArray = [];
		$animation = $(this).data('animation');
		$animArray = $animation.split(',');
		$animationIn = 'animated '+$animArray[0];
		$animationOut = 'animated '+ $animArray[1];
		$animationDuration = ''
		if(!$animArray[2]) {
		    $animationDuration = 500; //if duration is not defined, default is set to 500ms
		}
		else {
		    $animationDuration = $animArray[2];
		}
		
		$(this).find('.dropdown-menu').removeClass($animationOut)
		$(this).find('.dropdown-menu').addClass($animationIn);
	    }
	});
	
	$('.dropdown').on('hide.bs.dropdown', function (e) {
	    if($(this).attr('data-animation')) {
    		e.preventDefault();
    		$this = $(this);
    		$dropdownMenu = $this.find('.dropdown-menu');
    	
    		$dropdownMenu.addClass($animationOut);
    		setTimeout(function(){
    		    $this.removeClass('open')
    		    
    		}, $animationDuration);
    	    }
    	});
    }
    
    /*
     * Auto Hight Textarea
     */
    if ($('.auto-size')[0]) {
	   $('.auto-size').autosize();
    }
    
    /*
     * Custom Scrollbars
     */
    function scrollbar(className, color, cursorWidth) {
        $(className).niceScroll({
            cursorcolor: color,
            cursorborder: 0,
            cursorborderradius: 0,
            cursorwidth: cursorWidth,
            bouncescroll: true,
            mousescrollstep: 100
        });
    }

    //Scrollbar for HTML but not for login page
    if (!$('.login-content')[0]) {
        scrollbar('html', 'rgba(0,0,0,0.3)', '5px');
    }
    
    //Scrollbar Tables
    if ($('.table-responsive')[0]) {
        scrollbar('.table-responsive', 'rgba(0,0,0,0.5)', '5px');
    }
    
    //Scroll bar for Chosen
    if ($('.chosen-results')[0]) {
        scrollbar('.chosen-results', 'rgba(0,0,0,0.5)', '5px');
    }
    
    //Scroll bar for tabs
    if ($('.tab-nav')[0]) {
        scrollbar('.tab-nav', 'rgba(0,0,0,0.2)', '2px');
    }

    //Scroll bar for dropdowm-menu
    if ($('.dropdown-menu .c-overflow')[0]) {
        scrollbar('.dropdown-menu .c-overflow', 'rgba(0,0,0,0.5)', '0px');
    }

    //Scrollbar for rest
    if ($('.c-overflow')[0]) {
        scrollbar('.c-overflow', 'rgba(0,0,0,0.5)', '5px');
    }

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

