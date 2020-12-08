/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.MasterPage = function () {
    /// <summary>Represents a master page of the OMC administration interface.</summary>

    this._controlID = null;
    this._cache = null;
    this._treeCollapsed = false;
    this._contentReadyCallbacks = [];
    this._UIReadyCallbacks = [];
    this._progressSizeAdjusted = false;
    this._beforeUnload = [];
    this._previousContentNodeID = -1;
    this._dialog = null;
    this._terminology = {};
    this._isBasedOnTemplate = false;
    this._isFromParameterEditor = false;
    this._parameterEditorOpenerID = "";
}

OMC.MasterPage.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object that holds all localized strings.</summary>

    if (!this._terminology) {
        this._terminology = {};
    }

    return this._terminology;
}

OMC.MasterPage.BeforeUnloadEventArgs = function () {
    /// <summary>Provides event information on "before unload" event.</summary>

    this._cancel = false;
    this._message = '';
}

OMC.MasterPage.BeforeUnloadEventArgs.prototype.get_cancel = function () {
    /// <summary>Gets value indicating whether to cancel content unloading and stay on the same page.</summary>

    return this._cancel;
}

OMC.MasterPage.BeforeUnloadEventArgs.prototype.set_cancel = function (value) {
    /// <summary>Sets value indicating whether to cancel content unloading and stay on the same page.</summary>
    /// <param name="value">Value indicating whether to cancel content unloading and stay on the same page.</param>

    this._cancel = !!value;
}

OMC.MasterPage.BeforeUnloadEventArgs.prototype.get_message = function () {
    /// <summary>Gets the confirmation message that is displayed if the unload process can't be silently cancelled.</summary>

    return this.message;
}

OMC.MasterPage.BeforeUnloadEventArgs.prototype.set_message = function (value) {
    /// <summary>Sets the confirmation message that is displayed if the unload process can't be silently cancelled.</summary>
    /// <param name="value">The confirmation message that is displayed if the unload process can't be silently cancelled.</param>

    this.message = value + '';
}

OMC.MasterPage.Action = function () {
    /// <summary>Represents a master page action.</summary>

    this._expand = null;
    this._url = null;
}

OMC.MasterPage.Action.getAction = function (name) {
    /// <summary>Retrieves action with the given name.</summary>
    /// <param name="name">Action name.</param>

    var ret = null;
    var mappings = {
        newprofile: {
            expand: function (onComplete) {
                var nodeId = '';
                var parentId = '/Profiles';

                // System Id is defined in Default.aspx.vb (TreeNodeFactory)
                nodeId = parentId + '/sys:newprofile';

                onComplete = onComplete || function () { }

                // Expanding the "Profiles" node, highlighting the "New profile" node and notifying the caller
                OMC.MasterPage.get_current().get_tree().loadTo(nodeId, parentId, nodeId, function () {
                    onComplete(OMC.MasterPage.get_current().get_tree().getNodeByItemID(nodeId));
                });
            },
            url: '/Admin/Module/OMC/Profiles/EditProfile.aspx'
        }
    }

    if (name && name.length) {
        name = name.toString().toLowerCase();

        if (mappings[name] != null) {
            ret = new OMC.MasterPage.Action();

            ret.set_url(mappings[name].url);
            ret.set_expand(mappings[name].expand);
        }
    }

    return ret;
}

OMC.MasterPage.Action.prototype.get_expand = function () {
    /// <summary>Gets the function that expands the tree to a target node.</summary>

    return this._expand;
}

OMC.MasterPage.Action.prototype.set_expand = function (value) {
    /// <summary>Sets the function that expands the tree to a target node.</summary>
    /// <param name="value">The function that expands the tree to a target node.</param>

    this._expand = value;
}

OMC.MasterPage.Action.prototype.get_url = function () {
    /// <summary>Gets the URL of the page to be displayed in the content frame.</summary>

    return this._url;
}

OMC.MasterPage.Action.prototype.set_url = function (value) {
    /// <summary>Sets the URL of the page to be displayed in the content frame.</summary>
    /// <param name="value">The the URL of the page to be displayed in the content frame.</param>

    this._url = value;
}

OMC.MasterPage.Action.prototype.execute = function (onComplete) {
    /// <summary>Executes the given action.</summary>
    /// <param name="onComplete">Function to be called when the action is executed.</param>

    var url = '';
    var self = this;

    onComplete = onComplete || function () { }

    if (this.get_expand() && typeof (this.get_expand()) == 'function') {
        this.get_expand()(function (n) {
            if (self.get_url()) {
                if (typeof (self.get_url()) == 'function') {
                    url = self.get_url()(n);
                } else {
                    url = self.get_url();
                }
            }

            if (n && n.itemID) {
                OMC.MasterPage.get_current().navigate(url, { onTreeReady: null, node: n.itemID });
            } else {
                onComplete();
            }
        });
    }
}

OMC.MasterPage._instance = null;

OMC.MasterPage.get_current = function () {
    /// <summary>Gets the current instance of the master page.</summary>
    /// <returns>The current instnace of the master page.</returns>

    if (OMC.MasterPage._instance == null) {
        OMC.MasterPage._instance = new OMC.MasterPage();
    }

    return OMC.MasterPage._instance;
}

OMC.MasterPage.prototype.get_reportsRoot = function () {
    /// <summary>Gets the root path of the "Reports" section.</summary>

    return '/Reports';
}

OMC.MasterPage.prototype.get_controlID = function () {
    /// <summary>Gets the ID of the corresponding ASP.NET page.</summary>

    return this._controlID;
}

OMC.MasterPage.prototype.set_controlID = function (value) {
    /// <summary>Sets the ID of the corresponding ASP.NET page.</summary>
    /// <param name="value">An ID of the corresponding ASP.NET page.</param>

    this._controlID = value;
}

OMC.MasterPage.prototype.get_dialog = function () {
    /// <summary>Gets the instance of the popup dialog.</summary>

    return this._dialog;
}

OMC.MasterPage.prototype.set_dialog = function (value) {
    /// <summary>Sets the instance of the popup dialog.</summary>
    /// <param name="value">The instance of the popup dialog.</param>

    this._dialog = value;
}

OMC.MasterPage.prototype.set_isBasedOnTemplate = function (value) {
    /// <summary>Sets the instance of the popup dialog.</summary>
    /// <param name="value">The instance of the popup dialog.</param>

    this._isBasedOnTemplate = value;
}

OMC.MasterPage.prototype.get_invalidNameCharacters = function () {
    /// <summary>Gets the list of characters that are not allowed within the entity name.</summary>

    return ['"', '<', '>', '|', '/', ':'];
}

OMC.MasterPage.prototype.get_contentTitle = function () {
    /// <summary>Gets the title of the currently loaded content page.</summary>

    return this.get_contentReady() ? this.get_cache().entryTitle.innerHTML : '';
}

OMC.MasterPage.prototype.set_contentTitle = function (value) {
    /// <summary>Sets the title of the currently loaded content page.</summary>
    /// <param name="value">The title of the currently loaded content page.</param>

    this.get_cache().entryTitle.innerHTML = value;
}

OMC.MasterPage.prototype.get_contentTitleIsVisible = function () {
    /// <summary>Gets value indicating whether content title is visible.</summary>

    return this.get_cache().entryTitle.style.display != 'none';
}

OMC.MasterPage.prototype.set_contentTitleIsVisible = function (value) {
    /// <summary>Sets value indicating whether content title is visible.</summary>
    /// <param name="value">Value indicating whether content title is visible.</param>

    this.get_cache().entryTitle.style.display = (!!value ? 'block' : 'none');
}

OMC.MasterPage.prototype.get_toolbarIsVisible = function () {
    /// <summary>Gets value indicating whether content toolbar is visible.</summary>

    return this.get_cache().entryToolbar.style.display != 'none';
}

OMC.MasterPage.prototype.set_toolbarIsVisible = function (value) {
    /// <summary>Sets value indicating whether content toolbar is visible.</summary>
    /// <param name="value">Value indicating whether toolbar title is visible.</param>

    this.get_cache().entryToolbar.style.display = (!!value ? 'block' : 'none');
}

OMC.MasterPage.prototype.get_contentReady = function () {
    /// <summary>Gets value indicating whether content frame has content and is visible.</summary>

    return this.get_contentUrl() != 'about:blank' && this.get_cache().frame.getStyle('display') != 'none';
}

OMC.MasterPage.prototype.get_contentWindow = function () {
    /// <summary>Gets the reference to content window.</summary>

    return this.get_cache().frame.window || this.get_cache().frame.contentWindow;
}

OMC.MasterPage.prototype.get_tree = function () {
    /// <summary>Gets the reference to the navigation tree.</summary>

    return typeof (t) != 'undefined' ? t : null;
}

OMC.MasterPage.prototype.get_contentNodeId = function () {
    /// <summary>Gets the Id of the currently selected tree node.</summary>

    return this.get_tree() != null ? this.get_tree().selectedNode : -1;
}

OMC.MasterPage.prototype.get_previousContentNodeID = function () {
    /// <summary>Gets the ID of the previously selected tree node.</summary>

    return this._previousContentNodeID;
}

OMC.MasterPage.prototype.set_previousContentNodeID = function (value) {
    /// <summary>Sets the ID of the previously selected tree node.</summary>
    /// <param name="value">The ID of the previously selected tree node.</param>

    this._previousContentNodeID = parseInt(value);

    if (this._previousContentNodeID == null || isNaN(this._previousContentNodeID)) {
        this._previousContentNodeID = -1;
    }
}

OMC.MasterPage.prototype.get_contentUrl = function () {
    /// <summary>Gets content Url.</summary>

    return this.get_cache().frame.readAttribute('src');
}

OMC.MasterPage.prototype.set_contentUrl = function (value) {
    /// <summary>Sets content URL.</summary>
    /// <param name="value">Content URL.</summary>

    var node = null;

    if (value && typeof (value.execute) == 'function' && typeof (value.get_url) == 'function') {
        value.execute();
    } else {
        node = this.getNodeByUrl(value) || {};
        this.navigate(value, { onTreeReady: null, node: node.itemID });
    }
}

OMC.MasterPage.prototype.get_cache = function () {
    /// <summary>Gets the cache object.</summary>

    if (!this._cache) {
        this._initializeCache();
    }

    return this._cache;
}

OMC.MasterPage.prototype.containsInvalidNameCharacters = function (value) {
    /// <summary>Determines whether the value contains invalid entity name characters.</summary>
    /// <param name="value">Value to check.</param>

    var ret = false;
    var invalidChars = this.get_invalidNameCharacters();

    if (value && value.length) {
        for (var i = 0; i < invalidChars.length; i++) {
            for (var j = 0; j < value.length; j++) {
                ret = invalidChars[i] == value[j];
                if (ret) {
                    break;
                }
            }

            if (ret) {
                break;
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.navigate = function (url, params) {
    /// <summary>Loads the content frame with the content from the given URL.</summary>
    /// <param name="url">Content URL.</param>
    /// <param name="params">Method parameters.</param>

    var offset = 1;
    var args = null;
    var self = this;
    var components = [];
    var startNode = null;
    var newComponents = [];
    var onTreeReady = null;
    var loadStart = '', loadEnd = '';

    if (!params) {
        params = {};
    }

    onTreeReady = params.onTreeReady || function () { }

    if (url) {
        /* Clearing callbacks */
        this._contentReadyCallbacks = [];
        this._UIReadyCallbacks = [];

        /* Notifying clients that the content is about to be unloaded */
        args = new OMC.MasterPage.BeforeUnloadEventArgs();
        this._notify('beforeUnload', args);

        if (!args.get_cancel()) {
            this.get_cache().frame.writeAttribute('src', url);

            this._setContentIsVisible(false);

            if (params.node) {
                components = this.get_tree().get_dynamic().getPath(params.node);
                if (components && components.length) {
                    offset = 1;

                    do {
                        if ((components.length - offset - 1) < 0) {
                            break;
                        } else {
                            newComponents = [];
                            for (var i = 0; i <= components.length - offset - 1; i++) {
                                newComponents.push(components[i]);
                            }

                            loadStart = this.get_tree().get_dynamic().buildPath(newComponents);
                            if (!loadEnd) {
                                loadEnd = loadStart;
                            }

                            if ((startNode = this.get_tree().getNodeByItemID(loadStart))) {
                                break;
                            } else {
                                offset += 1;
                            }
                        }
                    } while (true);
                }

                if (loadStart == loadEnd) {
                    if (!startNode) {
                        startNode = this.get_tree().getNodeByItemID(loadStart);
                    }

                    if (!!params.force && startNode) {
                        this.get_tree().get_dynamic().removeChildNodes(startNode);

                        this.get_tree().ajax_loadNodes(this.get_tree().nodeIndex(startNode.id), true, function () {
                            self.get_tree().get_dynamic().highlight(params.node);
                            onTreeReady();
                        });
                    } else {
                        self.get_tree().get_dynamic().highlight(params.node);
                        onTreeReady();
                    }
                } else {
                    this.get_tree().loadTo(loadEnd, loadStart, params.node, function () {
                        onTreeReady();
                    })
                }
            }
        } else if (this.get_tree() && this.get_previousContentNodeID() >= 0) {
            this.get_tree().s(this.get_previousContentNodeID());
        }
    }
}

OMC.MasterPage.prototype.reload = function (uniqueID, params) {
    /// <summary>Reloads the given tree node contents (only the first level).</summary>
    /// <param name="uniqueID">Unique ID of the node.</param>
    /// <param name="params">Additional parameters.</param>

    var self = this;
    var node = null;
    var onComplete = null;

    params = params || {};
    onComplete = params.onComplete || function () { }

    if (uniqueID) {
        node = this.get_tree().getNodeByItemID(uniqueID);

        if (node) {
            this.get_tree().ajax_loadNodes(this.get_tree().nodeIndex(node.id), true, function () {
                if (params.highlight) {
                    self.get_tree().get_dynamic().highlight(params.highlight);
                }
                if (params.highlightNode) {
                    self.get_tree().get_dynamic().highlight(node);
                }

                onComplete();
            });
        } else {
            onComplete();
        }
    } else {
        onComplete();
    }
}

OMC.MasterPage.prototype.reloadParent = function (uniqueID, params) {
    /// <summary>Reloads the parent node of the given child node.</summary>
    /// <param name="uniqueID">Unique ID of the child node.</param>
    /// <param name="params">Additional parameters.</param>

    var onComplete = null;

    params = params || {};
    onComplete = params.onComplete || function () { }

    if (uniqueID) {
        this.reload(this.get_tree().get_dynamic().reducePath(uniqueID), params);
    } else {
        onComplete();
    }
}

OMC.MasterPage.prototype.add_contentReady = function (callback) {
    /// <summary>Registers new event handler for "content ready" event.</summary>
    /// <param name="callback">Event handler.</param>

    if (callback) {
        this._contentReadyCallbacks[this._contentReadyCallbacks.length] = callback;
    }
}

OMC.MasterPage.prototype.add_ready = function (callback) {
    /// <summary>Registers new event handler for "ready" event.</summary>
    /// <param name="callback">Event handler.</param>

    if (callback) {
        this._UIReadyCallbacks[this._UIReadyCallbacks.length] = callback;
    }
}

OMC.MasterPage.prototype.add_beforeUnload = function (callback) {
    /// <summary>Registers new event handler for "before content unload" event.</summary>
    /// <param name="callback">Event handler.</param>

    if (callback) {
        this._beforeUnload[this._beforeUnload.length] = callback;
    }
}

OMC.MasterPage.prototype.initialize = function (onComplete) {
    /// <summary>Initializes the master page.</summary>
    /// <param name="onComplete">Callback that fires when initialization process completes.</param>

    var self = this;

    onComplete = onComplete || function () { }

    this._initializeCache();

    this.autoSize();

    window.onresize = function () {
        self.autoSize();
    }

    // Callback behaviour is reserved (in case of loading some resources/APIs asynchronously)
    onComplete();
}

OMC.MasterPage.prototype.autoSize = function () {
    /// <summary>Adjusts tree height according to current window height.</summary>

    var bodyHeight = 0;
    var containerHeight = 0;
    var contentTitleHeight = 0;
    var paddings = 32;

    if (this.get_contentTitleIsVisible()) {
        contentTitleHeight = 57;
    }

    if (this.get_toolbarIsVisible()) {
        contentTitleHeight += this.get_cache().entryToolbar.getHeight();
    }

    bodyHeight = this.get_cache().body.getHeight();
    containerHeight = bodyHeight - this.get_cache().treeTitleOffset.top + 2;
    //2 is diff between real top indent and defined in css rules

    if (containerHeight > 0) {
        this.get_cache().tree.style.height = containerHeight + 'px';
    }

    this.get_cache().frame.style.height = (bodyHeight - contentTitleHeight - paddings - 4) + 'px';
    //4 - magic constant
}

OMC.MasterPage.prototype.dispose = function () {
    /// <summary>Purges all cached data.</summary>

    this._cache = null;
    Dynamicweb.Utilities.ResizeHandle.disposeAll();
}

OMC.MasterPage.prototype.contentLoaded = function () {
    /// <summary>Fires when master page content finished loading.</summary>

    var self = this;

    this._setContentIsVisible(true);

    // Clearing "before unload" event handlers on every page load
    this._beforeUnload = [];

    if (this.get_tree()) {
        this.set_previousContentNodeID(this.get_tree().selectedNode);
    }

    setTimeout(function () {
        for (var i = 0; i < self._contentReadyCallbacks.length; i++) {
            try {
                self._contentReadyCallbacks[i](self, {});
            } catch (ex) { }
        }
    }, 10);

    setTimeout(function () {
        if (!Dynamicweb.Ajax.get_currentControlTicket() || !Dynamicweb.Ajax.get_currentControlTicket().length) {
            self.autoSize();
            self._notify('ready', {});
        }
    }, 100);
}

OMC.MasterPage.prototype.renderControlAsync = function (ticket, container, onComplete) {
    /// <summary>Renders specified control asynchronously.</summary>
    /// <param name="ticket">Control ticket.</param>
    /// <param name="container">Output container.</param>
    /// <param name="onComplete">Callback to be executed when control has been rendered.</param>

    var self = this;
    var renderTimeoutID = null;
    var toolbarLoadingContainer = $('entryToolbarLoading');

    var showProgress = function () {
        renderTimeoutID = setTimeout(function () {
            toolbarLoadingContainer.show();
        }, 500);
    }

    var hideProgress = function () {
        if (renderTimeoutID) {
            clearTimeout(renderTimeoutID);
            renderTimeoutID = null;
        }

        toolbarLoadingContainer.hide();
    }

    Dynamicweb.Ajax.renderControl(ticket, {
        url: '/Admin/Module/OMC/Default.aspx',
        container: container,
        onBeforeLoad: function () {
            showProgress();
        },
        onAfterLoadResources: function () {
            hideProgress();
        },
        onComplete: function (container, content) {
            if (typeof (onComplete) == 'function') {
                onComplete();
            }

            self.autoSize();
            self._notify('ready', {});

            /* 
            Registering an event handler that will allow us to update 
            the height of the content area whenever user expands/collapses the Ribbon.
            */
            if (content.indexOf('Ribbon.js') >= 0) {
                setTimeout(function () {
                    if (typeof (Ribbon) != 'undefined') {
                        Ribbon.add_stateChanged(function (sender, args) {
                            OMC.MasterPage.get_current().autoSize();
                        });
                    }
                }, 100);
            }
        }
    });
}

OMC.MasterPage.prototype.toggleTreeCollapse = function () {
    /// <summary>Toggles the "Collapsed" state of the tree.</summary>

    var elm = null, f = null;

    var toggleElements = [
        { selector: 'cellTreeCollapsed', onExpand: function () { this.hide(); }, onCollapse: function () { this.show(); } },
        { selector: 'cellTree', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
        { selector: 'treeEndMarker', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
        { selector: 'sliderHandle', onExpand: function () { this.show(); }, onCollapse: function () { this.hide(); } },
        { selector: 'cellContent', onExpand: function () { this.removeClassName("tree-collapsed"); }, onCollapse: function () { this.addClassName("tree-collapsed"); } }
    ];

    this._treeCollapsed = !this._treeCollapsed;

    for (var i = 0; i < toggleElements.length; i++) {
        elm = $(toggleElements[i].selector);

        if (elm) {
            if (elm.length > 0) {
                elm = $(elm[0]);
            }

            if (this._treeCollapsed) {
                f = toggleElements[i].onCollapse;
            } else {
                f = toggleElements[i].onExpand;
            }

            f.apply(elm);
        }
    }

    //this.get_cache().loadingIndicator.setStyle({ left: (this._treeCollapsed ? '0' : '0') });

    if (!this._treeCollapsed) {
        this.autoSize();
    }
}

OMC.MasterPage.prototype.getReportID = function (uniqueID) {
    /// <summary>Returns the local of the report based on its unique ID.</summary>
    /// <param name="uniqueID">Unique ID of the report.</param>
    /// <returns>Local identifier of the report.</returns>

    var ret = '';
    var index = 0;
    var components = [];

    if (uniqueID) {
        components = uniqueID.split('/');
        if (components && components.length) {
            index = components.length - 1;

            do {
                if (index < 0) {
                    break;
                } else if (components[index].length) {
                    ret = components[index];
                    break;
                } else {
                    index -= 1;
                }
            } while (true);
        }
    }

    return ret;
}

OMC.MasterPage.prototype.getReportCategoryID = function (uniqueID) {
    /// <summary>Returns the unique of the report category based on the unique ID of the report itself.</summary>
    /// <param name="uniqueID">Unique ID of the report.</param>
    /// <returns>Unique ID of the report category.</returns>

    var ret = '';
    var components = [];
    var newComponents = [];

    if (uniqueID) {
        components = uniqueID.split('/');
        if (components && components.length) {
            for (var i = 0; i < components.length; i++) {
                if (components[i]) {
                    newComponents.push(components[i]);
                }
            }
        }

        if (newComponents && newComponents.length > 1) {
            ret = '/';

            for (var i = 0; i <= newComponents.length - 2; i++) {
                ret += newComponents[i];
                if (i < (newComponents.length - 2)) {
                    ret += '/';
                }
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.confirmDeleteReport = function (msg, reportID) {
    /// <summary>Displays a prompt dialog for deleting report.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="reportID">An ID of the report.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!reportID) {
            reportID = ContextMenu.callingItemID;
            nodeID = ContextMenu.callingID;

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(reportID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (reportID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID && typeof (nodeID) == 'number' ? nodeID : reportID));
            if (confirm(msg)) {
                this.deleteReport(reportID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.confirmDeleteTheme = function (msg, themeID) {
    /// <summary>Displays a prompt dialog for deleting theme.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="themeID">An ID of the theme.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!themeID) {
            themeID = ContextMenu.callingItemID;
            nodeID = ContextMenu.callingID;

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(themeID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (themeID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : themeID));
            if (confirm(msg)) {
                this.deleteTheme(themeID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.confirmDeleteProfile = function (msg, profileID) {
    /// <summary>Displays a prompt dialog for deleting profile.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="profileID">An ID of the profile.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!profileID) {
            profileID = ContextMenu.callingItemID;
            nodeID = ContextMenu.callingID;

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(profileID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (profileID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : profileID));
            if (confirm(msg)) {
                this.deleteProfile(profileID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.deleteReport = function (reportID, onComplete) {
    /// <summary>Sends the request to delete specified report.</summary>
    /// <param name="reportID">An ID of the report.</param>
    /// <param name="onComplete">Callback to be executed when report is deleted.</param>

    var ids = [];
    var n = null;
    var self = this;
    var firstReport = null;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteReport', { ID: reportID }, function (result) {
        if (result && result.length) {
            alert(result);
        } else {
            n = self.get_tree().getNodeByItemID(reportID);
            if (n) {
                self.get_tree().get_dynamic().removeNode(n);

                ids = self.get_tree().aNodesIndex._pids[n.pid];
                if (ids && ids.length) {
                    for (var i = 0; i < ids.length; i++) {
                        if (self.isReportNode(ids[i])) {
                            firstReport = ids[i];
                            break;
                        }
                    }

                    if (firstReport) {
                        self.navigate(self.getNodeUrl(self.get_tree().getNodeByID(firstReport)), {
                            node: self.get_tree().get_dynamic().getNodeItemID(firstReport)
                        });
                    } else {
                        self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
                    }
                } else {
                    self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
                }
            }
        }
    });
}

OMC.MasterPage.prototype.deleteTheme = function (themeID, onComplete) {
    /// <summary>Sends the request to delete specified theme.</summary>
    /// <param name="themeID">An ID of the theme.</param>
    /// <param name="onComplete">Callback to be executed when theme is deleted.</param>

    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteTheme', { ID: themeID }, function (result) {
        if (result && result.length) {
            alert(result);
        } else {
            n = self.get_tree().getNodeByItemID(themeID);
            if (n) {
                self.get_tree().get_dynamic().removeNode(n);
                self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
            }
        }
    });
}

OMC.MasterPage.prototype.deleteProfile = function (profileID, onComplete) {
    /// <summary>Sends the request to delete specified profile.</summary>
    /// <param name="profileID">An ID of the profile.</param>
    /// <param name="onComplete">Callback to be executed when profile is deleted.</param>

    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteProfile', { ID: profileID }, function (result) {
        if (result && result.length) {
            alert(result);
        } else {
            n = self.get_tree().getNodeByItemID(profileID);
            if (n) {
                self.get_tree().get_dynamic().removeNode(n);
                self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
            }
        }
    });
}

OMC.MasterPage.prototype.confirmDeleteReportCategory = function (msg, categoryID) {
    /// <summary>Displays a prompt dialog for deleting report category.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="categoryID">An ID of the report category.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!categoryID) {
            nodeID = ContextMenu.callingID;
            if (nodeID) {
                categoryID = this.get_tree().get_resolver().getNodeItemID(parseInt(nodeID));
            }

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(categoryID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (categoryID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : categoryID));
            if (confirm(msg)) {
                this.deleteReportCategory(categoryID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.deleteReportCategory = function (categoryID, onComplete) {
    /// <summary>Sends the request to delete specified report category.</summary>
    /// <param name="categoryID">An ID of the report category.</param>
    /// <param name="onComplete">Callback to be executed when report category is deleted.</param>

    var ids = [];
    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteReportCategory', { ID: categoryID }, function (result) {
        n = self.get_tree().getNodeByItemID(categoryID);
        if (n) {
            self.get_tree().get_dynamic().removeNode(n);
            self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
        }
    });
}

OMC.MasterPage.prototype.createReport = function (categoryID) {
    /// <summary>Opens "Create report" page with the given category set as selected.</summary>
    /// <param name="categoryID">Unique ID of the report category.</param>

    if (!categoryID) {
        categoryID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    if (categoryID) {
        this.set_contentUrl('/Admin/Module/OMC/Reports/ReportBuilder.aspx?CategoryID=' + encodeURIComponent(categoryID));
    }
}

OMC.MasterPage.prototype.onViewReport = function (nodeID) {
    /// <summary>Occurs when user clicks on a report link within the tree.</summary>
    /// <param name="nodeID">An ID of the tree node.</param>
    ContextMenu.callingID = nodeID;
    this.viewReport();
}

OMC.MasterPage.prototype.getReportInfo = function (n) {
    /// <summary>Returns the report information by examining the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Report node information.</returns>

    var ret = null;
    var parent = null;
    var components = [];

    n = this.get_tree().get_resolver().getNode(n);

    if (n && n.itemID && this.isReportNode(n)) {
        ret = { name: '', category: '', action: '' };
        components = this.get_tree().get_dynamic().getPath(n.itemID);

        if (components && components.length) {
            ret.name = components[components.length - 1];
        }

        ret.category = this.get_tree().get_dynamic().buildPath(this.get_tree().get_dynamic().getPath(n.pid));

        if (n.url && n.url.length) {
            if (n.url.toLowerCase().indexOf('viewreport(' + n.id + ')') > 0) {
                ret.action = 'view';
            }
        }
    }
    return ret;
}


OMC.MasterPage.prototype.viewReport = function (reportID, categoryID) {
    /// <summary>Opens "View report" page.</summary>
    /// <param name="reportID">Local name of the report.</param>
    /// <param name="categoryID">Unique ID of the report category.</param>

    var n = null;
    var info = null;
    var components = [];

    if (!reportID || !categoryID) {
        if (ContextMenu.callingID) {
            info = this.getReportInfo(ContextMenu.callingID);
            if (info != null) {
                reportID = info.name;
                categoryID = info.category;
            }
        }
    } else {
        components = this.get_tree().get_dynamic().getPath(categoryID);
        components.push(reportID);

        n = this.get_tree().get_resolver().getNode(this.get_tree().get_dynamic().buildPath(components));
    }

    this.navigate('/Admin/Module/OMC/Reports/ViewReport.aspx?ID=' + encodeURIComponent(reportID) + '&CategoryID=' +
        encodeURIComponent(categoryID), { node: n })
}

OMC.MasterPage.prototype.editReport = function (reportID, categoryID) {
    /// <summary>Opens "Edit report" page.</summary>
    /// <param name="reportID">Local name of the report.</param>
    /// <param name="categoryID">Unique ID of the report category.</param>

    var n = null;
    var components = [];

    if (!reportID || !categoryID) {
        if (ContextMenu.callingID) {
            info = this.getReportInfo(ContextMenu.callingID);
            if (info != null) {
                reportID = info.name;
                categoryID = info.category;
            }
        }
    } else {
        components = this.get_tree().get_dynamic().getPath(categoryID);
        components.push(reportID);

        n = this.get_tree().get_resolver().getNode(this.get_tree().get_dynamic().buildPath(components));
    }


    this.navigate('/Admin/Module/OMC/Reports/ReportBuilder.aspx?ID=' + encodeURIComponent(reportID) + '&CategoryID=' +
        encodeURIComponent(categoryID), { node: n })
}

OMC.MasterPage.prototype.editTheme = function (themeID) {
    /// <summary>Opens "Edit theme" page.</summary>
    /// <param name="themeID">Local name of the theme.</param>

    var n = null;
    var components = ['Reports', 'Themes'];

    if (!themeID) {
        if (ContextMenu.callingID) {
            info = this.getThemeInfo(ContextMenu.callingID);
            if (info != null) {
                themeID = info.name;
            }
        }
    } else {
        components.push(themeID);
        n = this.get_tree().get_resolver().getNode(this.get_tree().get_dynamic().buildPath(components));
    }

    if (themeID == null) {
        themeID = '';
    }

    this.navigate('/Admin/Module/OMC/Reports/EditTheme.aspx?ID=' + encodeURIComponent(themeID), { node: n })
}

OMC.MasterPage.prototype.editNewsletter = function (newsletterID, folderId, topFolderId, isDrafFolder, isReturnToCaller) {
    if (isDrafFolder && topFolderId.indexOf("top:sys") == -1) {
        var n = this.get_tree().getNodeByItemID(topFolderId);

        if (n != null)
            topFolderId = n._p.itemID;
    }

    var folder = "";

    if (folderId == -1)
        folder = "folderId=" + folderId + "&AllEmails=true&topFolderId=" + topFolderId;
    else if (folderId == -2)
        folder = "folderId=" + folderId + "&AllEmailTemplates=true&topFolderId=" + topFolderId;
    else
        folder = "folderId=" + folderId + "&topFolderId=" + topFolderId;

    if (newsletterID > 0)
        this.navigate("/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterId=" + newsletterID + "&" + folder + "&ReturnToCaller=" + isReturnToCaller);
    else
        this.navigate("/Admin/Module/OMC/Emails/EmailTypeSelect.aspx?" + folder);
}

OMC.MasterPage.prototype.showSplitTestReport = function (newsletterID) {
    if (newsletterID > 0) {
        this.navigate("/Admin/Module/OMC/Emails/SplitTestReport.aspx?newsletterId=" + newsletterID);
    }
}

OMC.MasterPage.prototype.showNewsletterStatistics = function (newsletterID) {
    if (newsletterID > 0)
        this.navigate("/Admin/Module/OMC/Emails/Statistics.aspx?newsletterId=" + newsletterID);
}

OMC.MasterPage.prototype.showRecipientsDialog = function (newsletterID) {
    if (newsletterID > 0){
        document.getElementById('ContentFrame').contentWindow.dialog.show("dlgRecipients", "/Admin/Module/OMC/Emails/SentEmailRecipients.aspx?emailId=" + newsletterID);
    }
}

OMC.MasterPage.prototype.showSplitTestStat = function (newsletterID) {
    if (newsletterID > 0)
        this.navigate("/Admin/Module/OMC/Emails/SplitTestReport.aspx?newsletterID=" + newsletterID);
}

OMC.MasterPage.prototype.ShowExportDialog = function ()
{
    document.getElementById('ContentFrame').contentWindow.dialog.show('exportDialog');
}

OMC.MasterPage.prototype.ShowLogDialog = function () {
    document.getElementById('ContentFrame').contentWindow.dialog.show('LogDialog');
}

OMC.MasterPage.prototype.LoadBounces = function (emailID, title) {
    title = title || 'Failures';
    if (emailID > 0) {
        this.showDialog('/Admin/Module/OMC/Emails/ValidateEmail.aspx?EmailId=' + emailID + '&Failures=true', 800, 420, { title: title, hideCancelButton: true });
    }
}

OMC.MasterPage.prototype.showEmailsList = function (folderId, topFolderID, isTopFolderEmails) {
    var nodePath = '/EmailMarketing/';
    if (folderId && folderId > 0)
        nodePath += 'sys:' + folderId;
    else if (folderId < 0 || topFolderID < 0)
        nodePath += 'sys:' + folderId
    else
        nodePath += 'top-sys:' + topFolderID;

    this.get_tree().get_dynamic().highlight(nodePath);

    var extraParameter = "";
    if (this._isFromParameterEditor)
        extraParameter = "&fromparametereditor=1";

    if (folderId == -1) {
        this.navigate("/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=" + folderId + "&AllEmails=true" + "&topFolderId=" + topFolderID + extraParameter);
        this.reloadNewsletters(null, nodePath);
    } else if (folderId == -2) {
        this.navigate("/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=" + folderId + "&AllEmailTemplates=true&topFolderId=" + topFolderID + extraParameter);
        this.reloadNewsletters(null, nodePath);
    } else if (isTopFolderEmails) {
        this.navigate("/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=" + folderId + "&topFolderId=" + topFolderID + "&isShowTopFolderEmails=true" + extraParameter);
        this.reloadNewsletters(null, nodePath);
    } else {
        this.navigate("/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=" + folderId + "&topFolderId=" + topFolderID + extraParameter);
        //this.reloadNewsletters(null, nodePath);
    }
}

OMC.MasterPage.prototype.setEmailInfoForOpener = function (emailId, emailSubject) {
    opener.document.getElementById(this._parameterEditorOpenerID).value = emailId;
    opener.document.getElementById("Title_" + this._parameterEditorOpenerID).value = emailSubject;
    window.close();
}

OMC.MasterPage.prototype.editTopFolder = function (topFolderID) {
    if (topFolderID) {
        var id = topFolderID.split(":")[1];
        this.navigate("/Admin/Module/OMC/Emails/EditTopFolder.aspx?topFolderId=" + id);
    } else {
        this.navigate("/Admin/Module/OMC/Emails/EditTopFolder.aspx");
    }
}

OMC.MasterPage.prototype.editTopFolderPermissions = function (topFolderID)
{
    if(topFolderID)
    {
        var id = topFolderID.split(":")[1];
        Action.Execute({
            Url: "/Admin/Filemanager/Browser/FileManagerPermissionEdit.aspx?isEmailMarketing=true&AccessElementType=emailfolder&Element=" + id,
            OnSubmitted: null,
            OnCancelled: null,
            Name: "OpenDialog"
        });
    }
}

OMC.MasterPage.prototype.editSocialMessage = function (listType) {

    var self = this;
    var IDs = this.getCheckedRows('lstSocialMessages');
    var row = null;
    var rowID = document.getElementById('ContentFrame').contentWindow.ContextMenu.callingID;

    if (IDs.length != 0) {
        var checkedRows = document.getElementById('ContentFrame').contentWindow.List.getSelectedRows('lstSocialMessages');
        document.getElementById('ContentFrame').contentWindow.location = 'EditMessage.aspx?ID=' + IDs[0];
    }
}


OMC.MasterPage.prototype.confirmDeleteSocialMessage = function (folderId, topFolderId) {

    var self = this;
    var IDs = this.getCheckedRows('lstSocialMessages');
    var row = null;
    var confirmStr = "";
    var rowID = document.getElementById('ContentFrame').contentWindow.ContextMenu.callingID;

    if (rowID && IDs.length == 1 && IDs.length != 0) {
        row = document.getElementById('ContentFrame').contentWindow.List.getRowByID('lstSocialMessages', 'row' + rowID);
        if (row) {
            confirmStr = row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
            confirmStr = confirmStr.replace('&nbsp;', "");
            confirmStr = confirmStr.replace('&qout;', "");
        }
    } else if (IDs.length != 0) {
        var checkedRows = document.getElementById('ContentFrame').contentWindow.List.getSelectedRows('lstSocialMessages');

        if (checkedRows && checkedRows.length > 0) {
            for (var i = 0; i < checkedRows.length; i++) {
                if (i != 0) {
                    confirmStr += " ' , '";
                }
                row = document.getElementById('ContentFrame').contentWindow.List.getRowByID('lstSocialMessages', checkedRows[i].id);
                if (row) {
                    confirmStr += row.children[3].innerText ? row.children[3].innerText : row.children[3].innerHTML;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                }
            }
        }
    }
    var msg = self.get_terminology()['ConfirmationMsgDelete'];
    msg = msg.replace('%%', "'" + confirmStr + "'");

    if (confirm(msg)) {
        this.deleteSocialMessage(null, folderId, topFolderId);
    }
}

OMC.MasterPage.prototype.confirmDeleteNewsletter = function (folderId, topFolderId) {

    var self = this;
    var IDs = this.getCheckedRows('lstEmailsList');
    var row = null;
    var confirmStr = "";
    var rowID = document.getElementById('ContentFrame').contentWindow.ContextMenu.callingID;

    if (rowID && IDs.length == 1 && IDs.length != 0) {
        row = document.getElementById('ContentFrame').contentWindow.List.getRowByID('lstEmailsList', 'row' + rowID);
        if (row) {
            confirmStr = row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
            confirmStr = confirmStr.replace('&nbsp;', "");
            confirmStr = confirmStr.replace('&qout;', "");
        }
    } else if (IDs.length != 0) {
        var checkedRows = document.getElementById('ContentFrame').contentWindow.List.getSelectedRows('lstEmailsList');

        if (checkedRows && checkedRows.length > 0) {
            for (var i = 0; i < checkedRows.length; i++) {
                if (i != 0) {
                    confirmStr += " ' , '";
                }
                row = document.getElementById('ContentFrame').contentWindow.List.getRowByID('lstEmailsList', checkedRows[i].id);
                if (row) {
                    confirmStr += row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                }
            }
        }
    }
    var msg = self.get_terminology()['ConfirmationMsgDelete'];
    msg = msg.replace('%%', "'" + confirmStr + "'");

    if (confirm(msg)) {
        this.deleteNewsletter(null, folderId, topFolderId);
    }
}

OMC.MasterPage.prototype.deleteNewsletter = function (onComplete, folderId, topFolderId) {
    var self = this;
    var IDs = this.getCheckedRows('lstEmailsList');
    var nodeItemID = '/EmailMarketing/top-sys:' + topFolderId;

    var folder = "";
    if (folderId == -1) {
        folder = folderId + "&AllEmails=true";
    } else if (folderId == -2) {
        folder = folderId + "&AllEmailTemplates=true";
    } else {
        folder = folderId;
    }

    onComplete = onComplete || function () { self.set_contentUrl('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + folder + "&topFolderId=" + topFolderId); }

    this.executeTask('DeleteNewsletter', { ID: IDs }, function (result) {
        if (result && result.length) {
            alert(result);
        } else {
            self.reload('/EmailMarketing');
            self.reload(nodeItemID);
            onComplete();
        }
    });
}

OMC.MasterPage.prototype.copyNewsletter = function (onComplete, folderId, topFolderId) {
    var self = this;
    var IDs = this.getCheckedRows('lstEmailsList');
    var nodeItemID = '/EmailMarketing/top-sys:' + topFolderId;

    var folder = "";
    if (folderId == -1) {
        folder = folderId + "&AllEmails=true";
    } else {
        folder = folderId;
    }

    onComplete = onComplete || function () { self.set_contentUrl('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + folder + "&topFolderId=" + topFolderId); }

    this.executeTask('CopyNewsletter', { ID: IDs }, function (result) {
        if (result && result.length)
            alert(result);
        else {
            self.reload('/EmailMarketing');
            self.reload(nodeItemID);
            onComplete();
        }
    });
}

OMC.MasterPage.prototype.moveNewsletter = function (onComplete, folderId, topFolderId) {
    var self = this;
    var IDs = this.getCheckedRows('lstEmailsList');
    var topFolderItemID = '/EmailMarketing/top-sys:' + topFolderId;

    //  now we can't move emails from 'AllEmails' folder to the another folders
    //    var folder = "";
    //    if (folderId == -1) {
    //        folder = folderId + "&AllEmails=true";
    //    } else {
    //        folder = folderId;
    //    }

    this.openWindow("/Admin/Module/OMC/Emails/FoldersTree.aspx?folderId=" + folderId + "&topFolderId=" + topFolderId, "DW_CustomFolderTree_window", 250, 400,
        function (returnValue) {
            if (returnValue) {
                onComplete = onComplete || function () { self.set_contentUrl('/Admin/Module/OMC/Emails/EmailsList.aspx?folderId=' + returnValue.folderId + "&topFolderId=" + returnValue.topFolderId); }

                self.executeTask('MoveNewsletter', { ID: IDs, FolderID: returnValue.folderId, TopFolderID: returnValue.topFolderId }, function (result) {
                    if (result && result.length) {
                        alert(result);
                    } else {
                        var n = self.get_tree().getNodeByItemID(returnValue.parentId);

                        if (n != null) {
                            self.reload(n._p.itemID);
                        }

                        var node = self.get_tree().getNodeByItemID(returnValue.fromFolderId);

                        if (node != null) {
                            self.reload(node._p.itemID);
                        }

                        //self.reload(topFolderItemID);
                        self.reload("/EmailMarketing/top-sys:" + returnValue.topFolderId);
                        self.reload('/EmailMarketing');
                        //self.reloadNewsletters(null, "/EmailMarketing/top-sys:" + returnValue.topFolderId);

                        onComplete();
                    }
                });
            }
        });    
}

OMC.MasterPage.prototype.moveSocialMessage = function (onComplete, folderId, topFolderId) {
    var self = this;
    var IDs = this.getCheckedRows('lstSocialMessages');
    var topFolderItemID = '/SocialMediaPublishing/top-sys:' + topFolderId;

    this.openWindow("/Admin/Module/OMC/SMP/FoldersTree.aspx?folderId=" + folderId + "&topFolderId=" + topFolderId, "DW_CustomFolderTree_window", 250, 400,
        function (returnValue) {
            if (returnValue) {
                onComplete = onComplete || function () { self.set_contentUrl('/Admin/Module/OMC/SMP/MessageList.aspx?folderId=' + returnValue.folderId + "&topFolderId=" + returnValue.topFolderId); }

                self.executeTask('MoveMessage', { ID: IDs, FolderID: returnValue.folderId, TopFolderID: returnValue.topFolderId }, function (result) {
                    if (result && result.length) {
                        alert(result);
                    } else {
                        var n = self.get_tree().getNodeByItemID(returnValue.parentId);

                        if (n != null) {
                            self.reload(n._p.itemID);
                        }

                        var node = self.get_tree().getNodeByItemID(returnValue.fromFolderId);

                        if (node != null) {
                            self.reload(node._p.itemID);
                        }
                        self.reload("/SocialMediaPublishing/top-sys:" + returnValue.topFolderId);
                        self.reload('/SocialMediaPublishing');
                        onComplete();
                    }
                });
            }
        });    
}

OMC.MasterPage.prototype.getCheckedRows = function (listID) {
    var IDs = [];
    var emailID = document.getElementById('ContentFrame').contentWindow.ContextMenu.callingItemID;
    var checkedRows = document.getElementById('ContentFrame').contentWindow.List.getSelectedRows(listID);

    if (checkedRows && checkedRows.length > 0) {
        for (var i = 0; i < checkedRows.length; i++) {
            IDs[i] = checkedRows[i].attributes.itemid.value;
        }
    } else if (emailID) {
        IDs[0] = emailID;
    }
    return IDs;
}

OMC.MasterPage.prototype.openWindow = function (url, windowName, width, height, onPopupClose) {
    if (window.showModalDialog) {
        var returnValue = window.showModalDialog(url, windowName, "dialogWidth:" + width + "px; dialogHeight:" + height + "px");
        if (onPopupClose) {
            onPopupClose(returnValue);
        }
        return returnValue;
    } else {
        var popupWnd = window.open(url, windowName, 'status=0,toolbar=0,menubar=0,resizable=0,directories=0,titlebar=0,modal=yes,width=' + width + ',height=' + height);
        if (onPopupClose) {
            popupWnd.onunload = function () {
                onPopupClose(popupWnd.returnValue);
            }
        }
    }
}

OMC.MasterPage.prototype.reloadNewsletters = function (newsletterID, nodeItemID, navigateTo) {
    var self = this;
    var params = {
        onComplete: function () {
            if (newsletterID != null)
                self.navigate('/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterID=' + newsletterID);
            if (navigateTo)
                self.navigate(navigateTo);
        },
        highlightNode: true
    };

    if (nodeItemID != null) {
        this.reload('/EmailMarketing');
        this.reload(nodeItemID, params);
    } else {
        this.reload('/EmailMarketing', params);
    }
}

OMC.MasterPage.prototype.reloadSocialMediaPublishing = function (messageID, nodeItemID) {
    var self = this;
    var params = {
        onComplete: function () {
            if (messageID != null)
                self.navigate('/Admin/Module/OMC/SMP/EditMessage.aspx?ID=' + messageID);
        },
        highlightNode: true
    };

    if (nodeItemID != null) {
        this.reload('/SocialMediaPublishing');
        this.reload(nodeItemID, params);
    } else {
        this.reload('/SocialMediaPublishing', params);
    }
}

OMC.MasterPage.prototype.reloadTopFolders = function (topfolderID) {
    var self = this;
    var params = {
        onComplete: function () {
            if (topfolderID != null)
                self.navigate('/Admin/Module/OMC/Emails/EditTopFolder.aspx?topFolderId=' + topfolderID);
        }
    }

    this.reload('/EmailMarketing', params);
}

OMC.MasterPage.prototype.editProfile = function (profileID) {
    /// <summary>Opens "Edit profile" page.</summary>
    /// <param name="profileID">Local name of the profile.</param>

    var n = null;
    var components = ['Profiles'];

    if (!profileID) {
        if (ContextMenu.callingID) {
            info = this.getProfileInfo(ContextMenu.callingID);
            if (info != null) {
                profileID = info.name;
            }
        }
    } else {
        components.push(profileID);
        n = this.get_tree().get_resolver().getNode(this.get_tree().get_dynamic().buildPath(components));
    }

    if (profileID == null) {
        profileID = '';
    }

    this.navigate('/Admin/Module/OMC/Profiles/EditProfile.aspx?ID=' + encodeURIComponent(profileID), { node: n })
}

OMC.MasterPage.prototype.showProfileUsage = function () {
    /// <summary>Opens "Profile Usage" page.</summary>
    this.navigate('/Admin/Module/OMC/Profiles/ProfileUsage.aspx');
}

OMC.MasterPage.prototype.beginCreateEmailFolder = function (uniqueID) {
    /// <summary>Triggers creation mode of the new category.</summary>
    /// <param name="uniqueID">Unique ID of the parent category.</param>

    var n = null;
    var self = this;

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    if (n) {
        this.get_tree().get_editor().beginEdit(null, {
            parent: uniqueID,
            createMode: 'reload',
            onCreate: function (sender, args) {
                var n = args.node;

                n.icon = n.iconOpen = n.iconClose = '/Admin/Images/Ribbon/Icons/Small/Folder.png';

                return n;
            },
            onCommit: function (sender, args) {
                self.executeTask('EditEmailFolder', {
                    ParentID: uniqueID,
                    FolderName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.beginCreateAutomationFolder = function (uniqueID) {
    /// <summary>Triggers creation mode of the new category.</summary>
    /// <param name="uniqueID">Unique ID of the parent category.</param>

    var n = null;
    var self = this;

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    if (n) {
        this.get_tree().get_editor().beginEdit(null, {
            parent: uniqueID,
            createMode: 'reload',
            onCreate: function (sender, args) {
                var n = args.node;

                n.icon = n.iconOpen = n.iconClose = '/Admin/Images/Ribbon/Icons/Small/Folder.png';

                return n;
            },
            onCommit: function (sender, args) {
                self.executeTask('EditAutomationFolder', {
                    ParentID: uniqueID,
                    FolderName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.beginEditEmailFolder = function (uniqueID) {
    /// <summary>Triggers editing mode of the given category.</summary>
    /// <param name="uniqueID">Unique ID of the category.</param>

    var n = null;
    var index = 0;
    var self = this;
    var newItemID = '';
    var itemIDComponents = [];

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    // remove count of emails during editing
    var nodeName = document.getElementById('dtn' + n._ai + '_name');
    if (!typeof nodeName.innerText === 'undefined') {
        if (nodeName && nodeName.innerText.indexOf('(') != -1) {
            nodeName.innerText = nodeName.innerText.split('(')[0];
        }
    }
    nodeName.lastChild.tex

    if (n) {
        this.get_tree().get_editor().beginEdit(uniqueID, {
            removeContentWhenEditing: true,
            createMode: 'reload',
            onCommit: function (sender, args) {
                self.executeTask('EditEmailFolder', {
                    ID: uniqueID,
                    FolderName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();
                        var parentNode = self.get_tree().getNodeByID(n.pid);
                        self.reload(parentNode.itemID);
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.beginEditAutomationFolder = function (uniqueID) {
    /// <summary>Triggers editing mode of the given category.</summary>
    /// <param name="uniqueID">Unique ID of the category.</param>

    var n = null;
    var index = 0;
    var self = this;
    var newItemID = '';
    var itemIDComponents = [];

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    // remove count of emails during editing
    var nodeName = document.getElementById('dtn' + n._ai + '_name');
    if (!typeof nodeName.innerText === 'undefined') {
        if (nodeName && nodeName.innerText.indexOf('(') != -1) {
            nodeName.innerText = nodeName.innerText.split('(')[0];
        }
    }
    nodeName.lastChild.tex

    if (n) {
        this.get_tree().get_editor().beginEdit(uniqueID, {
            removeContentWhenEditing: true,
            createMode: 'reload',
            onCommit: function (sender, args) {
                self.executeTask('EditAutomationFolder', {
                    ID: uniqueID,
                    FolderName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();
                        var parentNode = self.get_tree().getNodeByID(n.pid);
                        self.reload(parentNode.itemID);
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.confirmDeleteEmailFolder = function (msg, folderID) {
    /// <summary>Displays a prompt dialog for deleting report category.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="categoryID">An ID of the report category.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!folderID) {
            nodeID = ContextMenu.callingID;
            if (nodeID) {
                folderID = this.get_tree().get_resolver().getNodeItemID(parseInt(nodeID));
            }

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(folderID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (folderID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : folderID));
            if (confirm(msg)) {
                this.deleteEmailFolder(folderID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.confirmDeleteAutomationFolder = function (msg, folderID) {
    /// <summary>Displays a prompt dialog for deleting report category.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="categoryID">An ID of the report category.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!folderID) {
            nodeID = ContextMenu.callingID;
            if (nodeID) {
                folderID = this.get_tree().get_resolver().getNodeItemID(parseInt(nodeID));
            }

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(folderID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (folderID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : folderID));
            if (confirm(msg)) {
                this.deleteAutomationFolder(folderID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.deleteEmailFolder = function (folderID, onComplete) {
    /// <summary>Sends the request to delete specified report category.</summary>
    /// <param name="categoryID">An ID of the report category.</param>
    /// <param name="onComplete">Callback to be executed when report category is deleted.</param>

    var ids = [];
    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteEmailFolder', { ID: folderID }, function (result) {
        n = self.get_tree().getNodeByItemID(folderID);
        if (n) {
            self.get_tree().get_dynamic().removeNode(n);
            self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
        }
    });
}

OMC.MasterPage.prototype.deleteAutomationFolder = function (folderID, onComplete) {
    /// <summary>Sends the request to delete specified report category.</summary>
    /// <param name="categoryID">An ID of the report category.</param>
    /// <param name="onComplete">Callback to be executed when report category is deleted.</param>

    var ids = [];
    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteAutomationFolder', { ID: folderID }, function (result) {
        n = self.get_tree().getNodeByItemID(folderID);
        if (n) {
            self.get_tree().get_dynamic().removeNode(n);
            self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
        }
    });
}

OMC.MasterPage.prototype.confirmDeleteTopFolder = function (msg, folderID) {
    /// <summary>Displays a prompt dialog for deleting report category.</summary>
    /// <param name="message">Message to be displayed to the user.</param>
    /// <param name="categoryID">An ID of the report category.</param>

    var n = null;
    var nodeID = -1;

    if (msg) {
        if (!folderID) {
            nodeID = ContextMenu.callingID;
            if (nodeID) {
                folderID = this.get_tree().get_resolver().getNodeItemID(parseInt(nodeID));
            }

            ContextMenu.hide();
        } else {
            n = this.get_tree().getNodeByItemID(folderID);
            if (n) {
                nodeID = n.id;
            }
        }

        if (folderID) {
            msg = msg.replace('%%', this.get_tree().nodeText(nodeID ? nodeID : folderID));
            if (confirm(msg)) {
                this.deleteTopFolder(folderID, null);
            }
        }
    }
}

OMC.MasterPage.prototype.deleteTopFolder = function (folderID, onComplete) {
    /// <summary>Sends the request to delete specified report category.</summary>
    /// <param name="categoryID">An ID of the report category.</param>
    /// <param name="onComplete">Callback to be executed when report category is deleted.</param>

    var ids = [];
    var n = null;
    var self = this;

    onComplete = onComplete || function () { }

    this.executeTask('DeleteTopFolder', { ID: folderID }, function (result) {
        n = self.get_tree().getNodeByItemID(folderID);
        if (n) {
            self.get_tree().get_dynamic().removeNode(n);
            self.set_contentUrl('/Admin/Module/OMC/Dashboard.aspx');
            self.reload('/EmailMarketing');
        }
    });
}

OMC.MasterPage.prototype.beginCreateReportCategory = function (uniqueID) {
    /// <summary>Triggers creation mode of the new category.</summary>
    /// <param name="uniqueID">Unique ID of the parent category.</param>

    var n = null;
    var self = this;

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    if (n) {
        this.get_tree().get_editor().beginEdit(null, {
            parent: uniqueID,
            createMode: 'reload',
            onCreate: function (sender, args) {
                var n = args.node;

                n.icon = n.iconOpen = n.iconClose = '/Admin/Images/Ribbon/Icons/Small/Folder.png';

                return n;
            },
            onCommit: function (sender, args) {
                self.executeTask('EditReportCategory', {
                    ParentID: uniqueID,
                    CategoryName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.beginEditReportCategory = function (uniqueID) {
    /// <summary>Triggers editing mode of the given category.</summary>
    /// <param name="uniqueID">Unique ID of the category.</param>

    var n = null;
    var index = 0;
    var self = this;
    var newItemID = '';
    var itemIDComponents = [];

    if (!uniqueID) {
        uniqueID = this.get_tree().get_resolver().getNodeItemID(ContextMenu.callingID);
    }

    n = this.get_tree().get_resolver().getNode(uniqueID);

    if (n) {
        this.get_tree().get_editor().beginEdit(uniqueID, {
            createMode: 'reload',
            onCommit: function (sender, args) {
                self.executeTask('EditReportCategory', {
                    ID: uniqueID,
                    CategoryName: args.value
                }, function (result) {
                    if (!result || !result.length) {
                        self.get_tree().get_editor().commit();

                        index = self.get_tree().nodeIndex(args.node.id);
                        if (index && self.get_tree().aNodes[index]) {
                            newItemID = args.node.itemID;
                            itemIDComponents = self.get_tree().get_dynamic().getPath(args.node);
                            if (itemIDComponents) {
                                itemIDComponents[itemIDComponents.length - 1] = args.value;
                                newItemID = self.get_tree().get_dynamic().buildPath(itemIDComponents);
                            }

                            self.get_tree().aNodes[index].itemID = newItemID;
                        }
                    } else {
                        alert(result);
                        self.get_tree().get_editor().abort();
                    }
                });
            }
        });
    }
}

OMC.MasterPage.prototype.isReportNode = function (n) {
    /// <summary>Determines whether specified node is a report node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Value indicating whether specified node is a report node.</returns>

    var ret = false;
    var node = this.get_tree().get_dynamic().getNode(n);

    if (node) {
        ret = node.itemID.toLowerCase().indexOf('/reports') == 0;
        if (ret) {
            ret = node.icon.toLowerCase().indexOf('document_chart_small.png') > 0 ||
                node.icon.toLowerCase().indexOf('document_chart_link_small.png') > 0;
        }
    }

    return ret;
}

OMC.MasterPage.prototype.isThemeNode = function (n) {
    /// <summary>Determines whether specified node is a theme node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Value indicating whether specified node is a theme node.</returns>

    var ret = false;
    var node = this.get_tree().get_dynamic().getNode(n);

    if (node) {
        ret = node.itemID.toLowerCase().indexOf('/reports/themes') == 0;
        if (ret) {
            ret = node.icon.toLowerCase().indexOf('theme_small.png') > 0;
        }
    }

    return ret;
}

OMC.MasterPage.prototype.isProfileNode = function (n) {
    /// <summary>Determines whether specified node is a profile node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Value indicating whether specified node is a profile node.</returns>

    var ret = false;
    var node = this.get_tree().get_dynamic().getNode(n);

    if (node) {
        ret = node.itemID.toLowerCase().indexOf('/profiles') == 0;
        if (ret) {
            ret = node.icon.toLowerCase().indexOf('profile.png') > 0;
        }
    }

    return ret;
}

OMC.MasterPage.prototype.compareTreeNodes = function (x, y) {
    /// <summary>Compares two tree nodes.</summary>
    /// <param name="x">First node ID.</param>
    /// <param name="y">Second node ID.</param>
    /// <returns>Comparison result.</returns>

    var ret = 0;
    var tree = null;
    var n1 = null, n2 = null;
    var icon1 = '', icon2 = '';

    if (typeof (this.get_tree) == 'undefined') {
        if (typeof (t) != 'undefined') {
            tree = t;
        }
    }

    if (x != y) {
        n1 = tree.aNodesIndex.selectById(x);
        n2 = tree.aNodesIndex.selectById(y);

        if (n1 && n2) {
            if (n1.itemID.toLowerCase().indexOf(OMC.MasterPage.get_current().get_reportsRoot().toLowerCase()) == 0 &&
                n2.itemID.toLowerCase().indexOf(OMC.MasterPage.get_current().get_reportsRoot().toLowerCase()) == 0) {

                icon1 = n1.icon.toLowerCase();
                icon2 = n2.icon.toLowerCase();

                if (icon1.indexOf('folder_theme.png') > 0 && icon2.indexOf('folder_theme.png') < 0) {
                    ret = -1;
                } else if (icon2.indexOf('folder_theme.png') > 0 && icon1.indexOf('folder_theme.png') < 0) {
                    ret = 1;
                } else {
                    if (icon1.indexOf('folder.png') > 0 && icon2.indexOf('folder.png') < 0) {
                        ret = -1;
                    } else if (icon2.indexOf('folder.png') > 0 && icon1.indexOf('folder.png') < 0) {
                        ret = 1;
                    } else {
                        ret = n1.name.localeCompare(n2.name);
                    }
                }
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.showDialog = function (url, width, height, params, okAction)
{
    /// <summary>Shows the popup dialog.</summary>
    /// <param name="url">Content URL.</param>
    /// <param name="width">Dialog width.</param>
    /// <param name="height">Dialog height.</param>
    /// <param name="params">Additional parameters.</param>

    var dialogId = null;

    params = params || {};

    if (url && url.length)
    {
        dialogId = this.get_dialog();

        if (params.title) dialog.setTitle(dialogId, params.title);

        var okBtn = dialog.get_okButton(dialogId);
        if (okAction != null && okBtn) {
            okBtn.on("click", okAction);
        } else if (okBtn) {
            okBtn.hide();
        }
        var size = null;
        switch (true) {
            case (height <= 350): {
                size = dialog.sizes.small;
                break;
            }
            case (height < 500): {
                size = dialog.sizes.medium;
                break;
            }
            case (height >= 500): {
                size = dialog.sizes.large;
                break;
            }
        }
        dialog.show(dialogId, url, size);
    }
}

OMC.MasterPage.prototype.hideDialog = function () {
    /// <summary>Hides the popup dialog.</summary>

    dialog.hide(this.get_dialog());
}

OMC.MasterPage.prototype.executeTask = function (name, parameters, onComplete, silentMode) {
    /// <summary>Exeuctes specified server task.</summary>
    /// <param name="name">Name of the task.</param>
    /// <param name="parameters">Object containing task parameters.</param>
    /// <param name="onComplete">Callback to be executed when task completes.</param>
    /// <param name="silentMode">Value indicating whether not to perform any UI updates (such as disabling of UI elements) while the task is executing.</param>

    var url = '';
    var ret = null;
    var self = this;

    onComplete = onComplete || function () { }

    if (!parameters) {
        parameters = {};
    }

    if (name) {
        if (typeof (silentMode) == 'undefined' || silentMode == null || !silentMode) {
            this.get_tree().get_dynamic().set_isProgress(true);
        }

        url = '/Admin/Module/OMC/Task.ashx?Name=' + encodeURIComponent(name) + '&timestamp=' + (new Date()).getTime();

        ret = Dynamicweb.Ajax.doPostBack({
            url: url,
            explicitMode: true,
            parameters: parameters,
            onComplete: function (transport) {
                if (typeof (silentMode) == 'undefined' || silentMode == null || !silentMode) {
                    self.get_tree().get_dynamic().set_isProgress(false);
                }

                onComplete(transport.responseText);
            }
        });
    } else {
        onComplete('');
    }

    return ret;
}

OMC.MasterPage.prototype.getNodeByUrl = function (url) {
    /// <summary>Returns the URL of the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Node instance.</returns>

    var ret = null;
    var nodes = this.get_tree().aNodes;

    if (url) {
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].url == url || nodes[i].url.indexOf('\'' + url + '\'') >= 0) {
                ret = nodes[i];
                break;
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.getNodeUrl = function (n) {
    /// <summary>Returns the URL of the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>URL of the given node.</returns>

    var m = null;
    var ret = '';
    var node = null;
    var info = null;
    var pattern1 = /navigate\('([^']+)\)?/gi;
    var pattern2 = /set_contentUrl\('([^']+)\)?/gi;

    if (typeof (n) != 'undefined') {
        if (typeof (n.id) != 'undefined') {
            node = n;
        } else if (typeof (n) == 'number') {
            node = this.get_tree().getNodeByID(n);
        } else if (typeof (n) == 'string') {
            node = this.get_tree().getNodeByItemID(n);
            if (!node) {
                node = this.get_tree().getNodeByID(parseInt(n));
            }
        }

        if (node) {
            ret = node.url + '';
            if (ret.toLowerCase().indexOf('omc.masterpage.') >= 0) {
                if ((m = pattern1.exec(ret)) != null) {
                    ret = m[1];
                } else if ((m = pattern2.exec(ret)) != null) {
                    ret = m[1];
                } else {
                    ret = '';
                }
            }

            if (!ret) {
                info = this.getReportInfo(node);
                if (info) {
                    if (info.action == 'edit') {
                        ret = '/Admin/Module/OMC/Reports/ReportBuilder.aspx?ID=' + encodeURIComponent(info.name) +
                            '&CategoryID=' + encodeURIComponent(info.category);
                    } else {
                        ret = '/Admin/Module/OMC/Reports/ViewReport.aspx?ID=' + encodeURIComponent(info.name) +
                            '&CategoryID=' + encodeURIComponent(info.category);
                    }
                }
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.getReportInfo = function (n) {
    /// <summary>Returns the report information by examining the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Report node information.</returns>

    var ret = null;
    var parent = null;
    var components = [];

    n = this.get_tree().get_resolver().getNode(n);

    if (n && n.itemID && this.isReportNode(n)) {
        ret = { name: '', category: '', action: '' };
        components = this.get_tree().get_dynamic().getPath(n.itemID);

        if (components && components.length) {
            ret.name = components[components.length - 1];
        }

        ret.category = this.get_tree().get_dynamic().buildPath(this.get_tree().get_dynamic().getPath(n.pid));

        if (n.url && n.url.length) {
            if (n.url.toLowerCase().indexOf('viewreport(' + n.id + ')') > 0) {
                ret.action = 'view';
            }
        }
    }
    return ret;
}

OMC.MasterPage.prototype.getThemeInfo = function (n) {
    /// <summary>Returns the theme information by examining the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Theme information.</returns>

    var ret = null;
    var parent = null;
    var components = [];

    n = this.get_tree().get_resolver().getNode(n);

    if (n && n.itemID && this.isThemeNode(n)) {
        ret = { name: '', action: '' };
        components = this.get_tree().get_dynamic().getPath(n.itemID);

        if (components && components.length) {
            ret.name = components[components.length - 1];
        }

        if (n.url && n.url.length) {
            if (n.url.indexOf('viewtheme(' + n.id + ')') > 0) {
                ret.action = 'view';
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype.getProfileInfo = function (n) {
    /// <summary>Returns the profile information by examining the given tree node.</summary>
    /// <param name="n">Node reference.</param>
    /// <returns>Profile information.</returns>

    var ret = null;
    var parent = null;
    var components = [];

    n = this.get_tree().get_resolver().getNode(n);

    if (n && n.itemID && this.isProfileNode(n)) {
        ret = { name: '', action: '' };
        components = this.get_tree().get_dynamic().getPath(n.itemID);

        if (components && components.length) {
            ret.name = components[components.length - 1];
        }

        if (n.url && n.url.length) {
            if (n.url.indexOf('viewprofile(' + n.id + ')') > 0) {
                ret.action = 'view';
            }
        }
    }

    return ret;
}

OMC.MasterPage.prototype._setContentIsVisible = function (isVisible) {
    /// <summary>Changes the content frame's "visible" state.</summary>
    /// <param name="isVisible">Indicates whether content frame is visible.</param>
    /// <private />

    var width = 0;
    var containerWidth = 0;

    this.get_cache().entryContainer.setStyle({ display: (isVisible ? '' : 'none') });
    this.get_cache().loadingIndicator.setStyle({ display: (isVisible ? 'none' : '')/*, left: (this._treeCollapsed ? '0' : '0')*/ });

    if (!isVisible && !this._progressSizeAdjusted) {
        width = this.get_cache().loadingIndicatorText.getWidth();
        containerWidth = this.get_cache().loadingIndicatorContainer.getWidth();

        if (width < containerWidth / 2) {
            this.get_cache().loadingIndicatorContainer.setStyle({ 'marginLeft': (parseInt((containerWidth - width) / 2) + 10) + 'px' });
        }

        this._progressSizeAdjusted = true;
    }
}

OMC.MasterPage.prototype._notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>
    /// <private />

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        if (eventName.toLowerCase() == 'contentready') {
            callbacks = this._contentReadyCallbacks;
        } else if (eventName.toLowerCase() == 'ready') {
            callbacks = this._UIReadyCallbacks;
        } else if (eventName.toLowerCase() == 'beforeunload') {
            callbacks = this._beforeUnload;
        }

        if (callbacks && callbacks.length) {
            if (typeof (args) == 'undefined' || args == null) {
                args = {};
            }

            for (var i = 0; i < callbacks.length; i++) {
                callbackException = null;

                try {
                    callbacks[i](this, args);
                } catch (ex) {
                    callbackException = ex;
                }

                /* Preventing "Unable to execute code from freed script" errors to raise */
                if (callbackException && callbackException.number != -2146823277) {
                    this.error(callbackException.toString());
                }
            }
        }
    }
}

OMC.MasterPage.prototype.error = function (message) {
    /// <summary>Displays an error message.</summary>
    /// <param name="message">Error message.</param>

    var er = null;

    if (typeof (Error) != 'undefined') {
        er = new Error();

        er.message = message;
        er.description = message;

        throw (er);
    } else {
        throw (message);
    }
}

OMC.MasterPage.prototype._initializeCache = function () {
    /// <summary>Initializes cache objects.</summary>

    this._cache = {};

    this._cache.entryTitle = $('entryTitle');
    this._cache.entryToolbar = $('entryToolbar');
    this._cache.entryContainer = $('entryContainer');
    this._cache.loadingIndicator = $('cellContentLoading');
    this._cache.loadingIndicatorText = $($$('#cellContentLoading .omc-loading-container-text')[0]);
    this._cache.loadingIndicatorContainer = $($$('#cellContentLoading .omc-loading-container')[0]);
    this._cache.frame = $('ContentFrame');
    this._cache.body = $(document.body);
    this._cache.tree = $($$('div.tree')[0]);
    this._cache.treeTitleOffset = $('treeEndMarker').cumulativeOffset();
}

OMC.MasterPage.prototype.showAllAutomationsList = function () {
    this.navigate('/Admin/Module/OMC/Automations/AutomationsList.aspx?AllAutomations=true');
}
OMC.MasterPage.prototype.showFolderAutomationsList = function (folderID) {
    this.navigate('/Admin/Module/OMC/Automations/AutomationsList.aspx?FolderId=' + folderID);
}

OMC.MasterPage.prototype.resendEmail = function (emailResendProvider) {
    var params = {};
    var self = this;
    var IDs = this.getCheckedRows('lstEmailsList');

    if (IDs.length > 1) {
        alert('You should select only one item to resend')
        return false;
    }

    params["AjaxCmd"] = "ResendEmail";
    params["EmailID"] = IDs[0];
    params["ResendProvider"] = emailResendProvider;

    new Ajax.Request("/Admin/Module/OMC/Emails/EmailsList.aspx", {
        parameters: params,
        onComplete: function (response) {
            if (response.responseText == null) {
                alert("A resend of type '" + emailResendProvider + "' could not be created");
            } else if (response.status == 200 && response.responseText != null) {
                var parameters = response.responseText.split(",");
                var nodePath = '/EmailMarketing/top-sys:'+parameters[1];
                self.reloadNewsletters(parameters[0], nodePath);
            }
        }
    });
}
