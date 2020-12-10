/* Namespace definition */

if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

/* End: Namespace definition */

Dynamicweb.Controls.ControlResources = function() {
    /// <summary>Initializes the new instance of an object.</summary>
}

Dynamicweb.Controls.ControlResources.combine = function(params) {
    /// <summary>Register new combine handler on the page.</summary>
    /// <param name="params">Combine parameters.</param>

    var ret = '';
    var outputType = '';
    var filesConcatenated = '';
    var handlerUrl = '/Admin/Public/ControlResourcesHandler.ashx';

    if (!params) params = {};

    /* "outputType" has to be specified - otherwise it not clear what tag (<script> or <link>) to embed */
    if (params.outputType) {
        outputType = params.outputType.toLowerCase().replace(/ /g, '').replace(/\./g, '');

        handlerUrl += '?OutputType=' + outputType;

        /* Processing passed list of files */
        if (params.files && params.files.length > 0) {
        
            /* Passing base path */
            if (params.basePath) {
                handlerUrl += '&BasePath=' + encodeURIComponent(params.basePath);
            }
            
            for (var i = 0; i < params.files.length; i++) {
                filesConcatenated += params.files[i];

                if (i < params.files.length - 1) {
                    filesConcatenated += ',';
                }
            }

            /* Query-string can't be larget then 2000 characters (otherwise it might cause problems in IE) */
            if (filesConcatenated.length > 2000) {
                Dynamicweb.Controls.ControlResources.error('Too much files to combine. Please split one call into several.');
            } else {
                handlerUrl += '&Files=' + filesConcatenated;

                if (outputType == 'js') {
                    ret = '<script type="text/javascript" encoding="utf-8" src="' + handlerUrl + '"></script>';
                } else if (outputType == 'css') {
                    ret = '<link rel="stylesheet" type="text/css" href="' + handlerUrl + '" />';
                }

                /* Embedding resources */
                if (params.embed || typeof(params.embed) == 'undefined') {
                    Dynamicweb.Controls.ControlResources.embed(handlerUrl, { outputType: outputType });
                }
            }
        }
    } else {
        Dynamicweb.Controls.ControlResources.error('Output type has to be specified.');
    }

    return ret;
}

Dynamicweb.Controls.ControlResources.embed = function(url, params) {
    /// <summary>Performs embedding of the specified resource.</summary>
    /// <param name="params">Embedding parameters.</param>

    var child = null;
    var script = null;
    var outputType = '';
    var container = null;
    var context = document;
    var containers = ['head', 'body'];
        
    if (!params) params = {};
    if (params.context) context = params.context;
    if (params.outputType) outputType = params.outputType;

    if (url) {
        /* Creating a new DOM element */
        if ((outputType && outputType == 'js') || url.lastIndexOf('.js') == url.lastIndexOf('.')) {
            script = context.createElement('script');
            script.encoding = 'utf-8';
            script.type = 'text/javascript';
            script.src = url;

        } else if ((outputType && outputType == 'css') || url.lastIndexOf('.css') == url.lastIndexOf('.')) {
            script = context.createElement('link');
            script.rel = 'stylesheet';
            script.type = 'text/css';
            script.href = url;
        }

        /* Trying to determine whether to put the newly created element */
        for (var i = 0; i < containers.length; i++) {
            container = context.getElementsByTagName(containers[i]);
            if (container != null && container.length > 0) {
                container = container[0];

                /* for "head" tag we just append the element */
                if (i == 0) {
                    container.appendChild(script);
                } else {
                    /* Skipping text nodes (FF) */
                    child = container.firstChild;
                    if (child.nodeType) {
                        while (child != null && child.nodeType == 3) {
                            child = child.nextSibling;
                        }
                    }

                    /* First child element has been found - inserting before it */
                    if (child) {
                        container.insertBefore(script, child);
                    } else {
                        /* Appending at the end */
                        container.appendChild(script);
                    }
                }

                break;
            }
        }
    }
}

Dynamicweb.Controls.ControlResources.error = function(message) {
    /// <summary>Sends an error to the client.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw er;
    } else {
        throw message;
    }
}