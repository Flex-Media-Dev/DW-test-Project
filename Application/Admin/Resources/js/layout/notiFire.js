/*
 * notiFire - Extra Simplifyed and customized by Dynamicweb
 * by @dongzhang
 */

var wrapper = document.createElement('div');
wrapper.className = 'notifire-frame';

document.addEventListener('DOMContentLoaded', function () {
    document.body.appendChild(wrapper);
}, false);


// helper function to extend obj1 by obj2
function extend(obj1, obj2) {
    for (var property in obj2) {
        obj1[property] = obj2[property];
    }
}

// notifire
function notifire(config) {
    // initialize default object
    var defaults = {
        width: 200,
        height: 50,
        position: 'right',
        id: '',
        msg: '',
        timeout: 5000,
        callback: null
    };

    // check input config validation
    for (prop in config) {
        switch (prop) {
            case 'width':
                if (typeof (config.width) !== 'number') console.error('Notifire: Invalid input width');
                break;
            case 'height':
                if (typeof (config.height) !== 'number') console.error('Notifire: Invalid input height');
                break;
            case 'position':
                if (config.position !== 'left' && config.position !== 'right') console.error('Notifire: Invalid input position');
                break;
            case 'id':
                if (typeof (config.id) !== 'string') console.error('Notifire: Invalid id');
                break;
            case 'msg':
                if (typeof (config.msg) !== 'string') console.error('Notifire: Invalid input msg');
                break;
            case 'timeout':
                if (typeof (config.timeout) !== 'number' && config.timeout !== 'false') console.error('Notifire: Invalid input timeout');
                break;
            case 'callback':
                if (typeof (config.callback) !== 'function' && config.callback !== null) console.error('Notifire: Invalid input callback');
                break;
            default:
                console.error('invalid input');
                break;
        }
    }
    // extend defaults with config
    extend(defaults, config);

    // check other config options
    if (typeof defaults.callback !== 'function') {
        defaults.callback = null;
    }

    if (defaults.width === '100%') {
        defaults.width = screen.width;
    }

    // create message element and append to body
    if (!document.getElementById(defaults.id)) {
        var div = document.createElement('div');
        var span = document.createElement('span');
        div.className = 'notifire';

        if (defaults.id != "") {
            span.id = defaults.id;
        }

        span.innerHTML = defaults.msg;
        div.appendChild(span);

        wrapper.appendChild(div);

        // modify notifire div by config
        div.style.width = defaults.width + 'px';
        div.style.height = defaults.height + 'px';

        // modify notifire div by customized position option
        switch (defaults.position) {
            case 'right':
                div.style['margin-left'] = document.documentElement.clientWidth - 23 + 'px';
                div.style['margin-right'] = '-' + (defaults.width - 6) + 'px';
                div.style['transition'] = 'transform 0.5s';
                div.style['transform'] = 'translateX(-' + defaults.width + 'px)';
                div.style['-webkit-transition'] = 'transform 0.5s';
                div.style['-webkit-transform'] = 'translateX(-' + defaults.width + 'px)';
                break;
            case 'left':
                div.style['margin-left'] = '-' + (defaults.width - 6) + 'px';
                div.style['transition'] = 'transform 0.5s';
                div.style['transform'] = 'translateX(' + defaults.width + 'px)';
                div.style['-webkit-transition'] = 'transform 0.5s';
                div.style['-webkit-transform'] = 'translateX(' + defaults.width + 'px)';
                break;
        }

        if (defaults.callback !== null) {
            defaults.timeout = 'false';
        }
        if (!isNaN(defaults.timeout)) {
            var timeout = notifireDismiss(div, defaults);
        }

        div.addEventListener('click', function () {
            if (timeout) {
                clearTimeout(timeout);
            }
            defaults.timeout = 0;
            notifireDismiss(div, defaults);
        });
    } else {
        document.getElementById(defaults.id).innerHTML = defaults.msg;
    }
}

// dismiss notifire
function notifireDismiss(div, defaults) {
    if (defaults.callback !== null) {
        defaults.callback();
    }
    var timeout = setTimeout(function () {
        div.style['transform'] = '';
        div.style['-webkit-transform'] = '';
        setTimeout(function () {
            wrapper.removeChild(div);
        }, 500);
    }, defaults.timeout);
    return timeout;
}