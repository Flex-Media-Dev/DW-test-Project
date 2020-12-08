/*
* Layout Content
*/

$(window).resize(function(){     
    adjustToScreen();
});

function adjustToScreen() {
    if ($('body').innerWidth() < 768) {
        collapseSidebar();
    } else {
        expandSidebar();
    }
}
adjustToScreen();


//$('body').addClass('sw-toggled');


function togglemenu() {
    if (!$(".sw-toggled")[0]) {
        expandSidebar();
    }
    else {
        collapseSidebar();
    }
}

function expandSidebar() {
    $('#sidebar').addClass('sw-toggled');

    $('body').addClass('sw-toggled');
    $('body').removeClass('sw-toggled-off');
}

function collapseSidebar() {
    $('#sidebar').removeClass('sw-toggled');

    $('body').removeClass('sw-toggled');
    $('body').addClass('sw-toggled-off');
}

function nomenu() {
    $('#sidebar').removeClass('sw-toggled');

    $('body').removeClass('sw-toggled');
    $('body').addClass('sw-toggled-off');

    $('#content-container').css('padding-left', '0px');
}

$(document).ready(function () {
    /*
     * Set the deffined input control layout
     */
    SetInputLayout();

    /*
     * Toggle the sidebar
     */
    $('body').on('click', '.sidebar-toggle-btn', function (e) {
        togglemenu();
    });

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

/*
* DW8 Implementer tools
*/
/*
$(document).ready(function () {
    $('#content-container').prepend('<div class="implementer-overlay"></div>');

    $('.implementer-overlay').on('click', function (e) {
        $('.implementer-overlay').remove();
    });
});
*/

/*
* Layout switcher
*/

function SwitchLayout(layouttype) {
    $('body').attr("id", layouttype + "-layout");
    $('#content-container').css('padding-left', '250px');
    $('.sidebar-header-actions').css('display', 'block');

    if ($('body').is("#hax-layout")) { 
        $('#content-container').css('padding-left', '308px');
    }

    if ($('body').is("#metro-layout")) {
        $('.sidebar-header-actions').css('display', 'none');
    }

    /*
    $(document).on('click', '.tree-btn', function (e) {
        if ($('body').is("#hax-layout")) {
            $('#sidebar').removeClass('show');
            $('#sidebar').addClass('hidden');
        }
    });
    */
}

function HideSidebar() {
    $('#sidebar').addClass('hidden');
    $('#sidebar').removeClass('show');

    $('#content-container').css('padding-left', '0');
}

function ShowSidebar() {
    $('#sidebar').addClass('show');
    $('#sidebar').removeClass('hidden');
}

function ResetSidebar() {
    ShowSidebar();
    $('#content-container').css('padding-left', '250px');
}

function SetInputLayout() {
    if (localStorage.getItem('input-layout') == "boxed" || localStorage.getItem('input-layout') == null) {
        $('body').addClass('boxed-fields');
    } else {
        $('body').addClass('material-fields');
    }
}

// TODO: find and change all refs
//function reloadSettingsTreeChildNodes(nodeID) {
//    reloadTreeNode("Settings", "Settings--" + nodeID)
//}