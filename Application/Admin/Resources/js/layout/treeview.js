(function ($) {
    // Doesn't work without jquery
    if (!$) {
        return;
    }

    // TreeView
    function TreeView($me) {
        var escapeQuotes = function (str) {
            return str.replace(/'/g, "&#39;").replace(/"/g, "&#34;");
        };

        var recreateNode = function (self, nodeObj, nodeEl, $target) {
            var newNodeEl = createNode(self, nodeObj, $target);
            $(nodeEl).replaceWith(newNodeEl);
            return newNodeEl;
        };

        var createElement = function (tagName, className, attributes) {
            var el = document.createElement(tagName);
            if (className) {
                el.className = className;
            }
            if (attributes) {
                for (const [key, value] of Object.entries(attributes)) {
                    el.setAttribute(key, value);
                }
            }
            return el;
        }

        var createNode = function (self, nodeObj, $target, count) {
            var li = null;
            var liBtnsWrap = null;
            var opts = self.options;
            var multiSelectCheckboxEl = null;
            var hasNodeAction = !!nodeObj.DefaultAction;
            if (nodeObj.HasNodes) {
                /* Create special node with children */
                var liEl = createElement("li", "list parent", { 'data-childlist': nodeObj.Id });
                var liBtnsWrapEl = createElement("div", "btn-wrap");
                liEl.appendChild(liBtnsWrapEl);
                liBtnsWrap = $(liBtnsWrapEl);
                li = $(liEl);
                li.appendTo($target);

                //Add the action/context menu button
                if (opts.enableMenus && nodeObj.HasActions) {
                    var dropdownEl = createElement("div", "dropdown");
                    liBtnsWrapEl.appendChild(dropdownEl);
                    var btnLinkEl = createElement("button", "btn btn-link contextTrigger waves-effect", { "data-toggle": "dropdown", "aria-expanded": "false" });
                    var iconVert = createElement("i", "md md-more-vert");
                    btnLinkEl.appendChild(iconVert);
                    dropdownEl.appendChild(btnLinkEl);
                }
                var btnEl = createElement("i", "fa fa-caret-right open-btn");
                var btn = $(btnEl);
                liBtnsWrap.append(btn);
                if (nodeObj.HasNodesLoadOnDemand) {
                    btn.addClass("on-demand");
                }
                if (opts.multiSelect && hasNodeAction) {
                    var chbName = "checkbox-" + nodeObj.Id;
                    var treeviewCheckboxEl = createElement("div", "treeview-checkbox");
                    var chbEl = createElement("input", "checkbox", { "type": "checkbox", "id": chbName });
                    treeviewCheckboxEl.appendChild(chbEl);
                    treeviewCheckboxEl.appendChild(createElement("label", null, { "for": chbName }));
                    liBtnsWrapEl.appendChild(treeviewCheckboxEl);
                    multiSelectCheckboxEl = $(dwGlobal.jqIdSelector(chbName), liBtnsWrap);
                }
            } else {
                var liEl = createElement("li", "list");
                var liBtnsWrapEl = createElement("div", "btn-wrap");
                liBtnsWrapEl.appendChild(createElement("i", "tree-indent"));
                liEl.appendChild(liBtnsWrapEl);
                liBtnsWrap = $(liBtnsWrapEl);
                li = $(liEl);
                li.appendTo($target);

                if (opts.multiSelect && hasNodeAction) {
                    var chbName = "checkbox-" + nodeObj.Id;
                    var treeviewCheckboxEl = createElement("div", "treeview-checkbox");
                    var chbEl = createElement("input", "checkbox", { "type": "checkbox", "id": chbName });
                    treeviewCheckboxEl.appendChild(chbEl);
                    treeviewCheckboxEl.appendChild(createElement("label", null, { "for": chbName }));
                    liBtnsWrapEl.appendChild(treeviewCheckboxEl);
                    multiSelectCheckboxEl = $(dwGlobal.jqIdSelector(chbName), liBtnsWrap);
                }
                //Add the action/context menu button
                if (opts.enableMenus && nodeObj.HasActions) {
                    var dropdownEl = createElement("div", "dropdown");
                    liBtnsWrapEl.appendChild(dropdownEl);
                    var btnLinkEl = createElement("button", "btn btn-link contextTrigger waves-effect", { "data-toggle": "dropdown", "aria-expanded": "false" });
                    var iconVert = createElement("i", "md md-more-vert");
                    btnLinkEl.appendChild(iconVert);
                    dropdownEl.appendChild(btnLinkEl);
                }
            }
            li.prop("id", nodeObj.Id);
            li.data("node-info", nodeObj);

            //Add adornments
            var adornments = "";
            if (opts.enableAdornments && nodeObj.Adornments != null) {
                for (var i = 0; i < nodeObj.Adornments.length; i++) {
                    var adornment = nodeObj.Adornments[i];
                    var adornmentTitle = adornment.Tooltip;
                    if (adornment.Type === "NavigationTag") {
                        adornmentTitle = nodeObj.NavigationTag;
                    }
                    adornments += "<i class=\"" + adornment.ClassName + " adornment\" title=\"" + adornmentTitle + "\"></i>";
                }
            }

            var inactiveClass = '';
            if (!nodeObj.Enabled) {
                inactiveClass = " inactive";
            }

            //Add ID for hover
            var idtext = "<span class=\"id\">" + ((nodeObj && nodeObj.Hint) ? nodeObj.Hint : '') + "</span>";

            //Add the default action
            if (hasNodeAction) {
                if (opts.defaultTrigger) {
                    var action = eval("(" + opts.defaultTrigger + ")");
                    var treeBtn = $(createElement("button", "tree-btn waves-effect " + inactiveClass, { "type": "button", "title": nodeObj.Title }));
                    liBtnsWrap
                        .append(treeBtn
                            .html(nodeObj.Title + "&nbsp;&nbsp;&nbsp;" + adornments))
                        .on("click", "button", function () {
                            Action.Execute(action, {
                                id: nodeObj.Id,
                                type: nodeObj.Type,
                                title: nodeObj.Title
                            });
                        });
                } else {
                    var treeBtn = $(createElement("button", "tree-btn waves-effect " + inactiveClass, { "type": "button", "title": nodeObj.Title }));
                    liBtnsWrap.append(treeBtn
                        .html(nodeObj.Title + "&nbsp;&nbsp;&nbsp;" + adornments + idtext)
                        .on("click", function () {
                            Action.Execute(nodeObj.DefaultAction)
                        }));
                }
                if (multiSelectCheckboxEl != null && multiSelectCheckboxEl.length) {
                    liBtnsWrap.off("click", ".tree-btn").on("click", ".tree-btn", function () {
                        multiSelectCheckboxEl.trigger("click");
                    });
                    var action = eval("(" + opts.defaultTrigger + ")");
                    multiSelectCheckboxEl.on("change", function () {
                        var selectedNodes = $me.find(".checkbox:checked").map(function () {
                            var nodeInfo = $(this).closest(".list").data("node-info");
                            return {
                                Id: nodeInfo.Id,
                                Type: nodeInfo.Type,
                                Title: nodeInfo.Title
                            };
                        });

                        var types = selectedNodes.map(function () { return this.Type }).get().join(",");
                        var titles = selectedNodes.map(function () { return this.Title }).get().join(",");
                        Action.Execute(action, {
                            id: JSON.stringify(selectedNodes.get()),
                            type: types,
                            title: titles
                        });
                    });
                }
            }
            else {
                var btnEl = createElement("button", "tree-btn waves-effect" + inactiveClass, { "title": nodeObj.Title, "onclick": "return false;" });
                btnEl.textContent = nodeObj.Title;
                liBtnsWrap.append($(btnEl));
            }
            //Add icon
            if (nodeObj.Icon != null && nodeObj.Icon != 0) {
                nodeObj.IconColor = nodeObj.IconColor || '';
                liBtnsWrap.find('.tree-btn').prepend($(createElement("i", `md ${nodeObj.Icon} ${nodeObj.IconColor}`)));
            } else if (nodeObj.Image != null && nodeObj.Image != "") {
                var iEl = createElement("i");
                iEl.appendChild(createElement("img", null, { "src": nodeObj.Image }));
                liBtnsWrap.find('.tree-btn').prepend($(iEl));
            }

            //Add highlight container
            liBtnsWrap.append($(createElement("span", "tree-highlight")));

            return li;
        }

        var attachEventsToChildNodes = function (self, nodesCnt) {
            var items = nodesCnt.find("> ul > .list > .btn-wrap");
            attachEventsToNodes(self, items);
        }

        var attachEventsToNodes = function (self, items) {
            var opts = self.options;
            // Expand items which have something
            items.find('.open-btn').on('click', function (event) {
                var treeNodeEl = $(this).closest(".list");
                self._toggleNode(treeNodeEl);
                //Important! Stop propagation of inner elements
                event.stopImmediatePropagation();
            });

            //Trigger the context-menu
            items.find('.contextTrigger').on('click', function (e) {
                e.preventDefault();
                var obj = $(this).closest(".list").data("node-info");
                $(this).contextmenu({
                    source: opts.onContextMenu(obj.Id),
                    model: obj
                });
            }).on('contextmenu', function (e) {
                e.preventDefault();
                $('.dropdown').removeClass('open');
                $(this).closest('.dropdown').addClass('open');
                var obj = $(this).closest(".list").data("node-info");
                $(this).contextmenu({
                    source: opts.onContextMenu(obj.Id),
                    model: obj
                });
            }).on('keydown', function (e) {
                if (e.which == 27) {
                    e.stopPropagation();
                    $('.dropdown').removeClass('open');
                }
            });

            items.on("click", function (e) {
                var $el = $(e.target);
                if ($el.hasClass("btn-wrap")) {
                    $el.find('.tree-btn').trigger("click");
                }
            }).on("contextmenu", function (e) {
                e.preventDefault();
                var $el = $(e.target);
                if ($el.hasClass("btn-wrap")) {
                    $el.find('.tree-btn').trigger("contextmenu");
                }
            });

            //Mark the selected item
            items.find('.tree-btn').on('click', function (event) {
                self._highlightNode($(this));
                self.expandNode($(this).closest(".list").prop("id"));

                //if (opts.callback) {
                //    opts.callback($(this).text(), $(this).data("dataobject"));
                //}
            }).on('contextmenu', function (e) { //Trigger the context-menu on right click
                e.preventDefault();
                var dd = $(this).closest(".btn-wrap").find(' > .dropdown');
                if (dd.length) {
                    var thecontextbtn = dd.find('.contextTrigger');
                    thecontextbtn.trigger("click");
                }
            });
        };

        var getChildListUrl = function (opts, nodeId, aditionalParams) {
            var xref = opts.source;
            if (nodeId) {
                if (xref.lastIndexOf("/") != xref.length - 1) {
                    xref += "/";
                }
                xref += nodeId;
            }
            var params = $.extend({}, opts.sourceParameters, aditionalParams);
            var qs = $.param(params);
            if (qs) {
                xref += "?" + qs;
            }
            return xref;
        }

        var fetchChildNodes = function (self, treeNodeEl, openBtnEl, afterLoadCallback) {
            var opts = self.options;
            if (openBtnEl.hasClass('fa-caret-right')) {
                openBtnEl.removeClass('fa-caret-right');
                openBtnEl.removeClass('no-anim');
                openBtnEl.addClass('fa-refresh');
                openBtnEl.addClass('fa-spin');
            }

            openBtnEl.removeClass('fa-exclamation color-danger');
            // Secures that double clicking is not possible
            openBtnEl.attr('disabled', 'disabled');
            openBtnEl.addClass('disabled');

            var childlist = treeNodeEl.data("childlist") || "";
            treeNodeEl.find(">ul").remove();

            fetch(getChildListUrl(opts, childlist), {
                method: 'GET',
                credentials: 'same-origin'
            }).then(function (response) {
                if (response.status >= 200 && response.status < 300) {
                    return response.json();
                }
                else {
                    var error = new Error(response.statusText);
                    error.response = response;
                    throw error;
                }
            }).then(function (nodes) {
                var nodeInfo = $(treeNodeEl).data("node-info") || {};
                var loadOnDemand = nodeInfo.HasNodesLoadOnDemand
                if (nodeInfo.HasNodesLoadOnDemand) {
                    delete nodeInfo.HasNodesLoadOnDemand;
                }
                if (nodes && nodes.length) {
                    var docFragment = document.createDocumentFragment();
                    var innerList = $('<ul>').appendTo(docFragment);

                    for (let i = 0; i < nodes.length; i++) {
                        let nodeObj = nodes[i];
                        createNode(self, nodeObj, innerList, i);
                    }
                    treeNodeEl.append(docFragment);
                    treeNodeEl.addClass("loaded");
                    innerList.hide();
                    // Slide effect
                    innerList.slideDown(200);
                    attachEventsToChildNodes(self, treeNodeEl);
                }
                else if (loadOnDemand) {
                    nodeInfo.HasNodes = false;
                    var innerList = treeNodeEl.closest("ul");
                    treeNodeEl = recreateNode(self, nodeInfo, treeNodeEl, innerList);
                    var nodeEl = treeNodeEl.find(" > .btn-wrap");
                    attachEventsToNodes(self, nodeEl);
                }

                if (afterLoadCallback && typeof afterLoadCallback === "function") {
                    afterLoadCallback();
                }
            }).catch(function (error) {
                treeNodeEl.append($('<ul class="treeview has-error">').append(error.message));
                openBtnEl.removeClass('fa-refresh');
                openBtnEl.removeClass('fa-spin');
                openBtnEl.addClass('no-anim');
                openBtnEl.addClass('fa-exclamation color-danger');
            }).finally(function () {
                setTimeout(function () {
                    openBtnEl.removeAttr('disabled');
                    openBtnEl.removeClass('disabled');
                    openBtnEl.removeClass('fa-refresh');
                    openBtnEl.removeClass('fa-spin');
                    openBtnEl.removeClass('on-demand');
                    openBtnEl.addClass('no-anim');
                    openBtnEl.addClass('fa-caret-down');
                }, 200);
            });
        };

        return {
            //Initialize control
            init: function (options) {
                var opts = this.options = $.extend({
                    source: "",
                    enableMenus: true,
                    enableAdornments: true,
                    enableRootSelector: false,
                    rootNode: "",
                    multiSelect: false,
                    defaultTrigger: null,
                    onContextMenu: function (nodeId) {
                        return getChildListUrl(this, nodeId, { command: "actions" })
                    }
                }, options);
                $.map(opts, function (val, propName) {
                    if (propName == "sourceParameters" && val && typeof val == "string") {
                        opts[propName] = JSON.parse(val);
                    }
                    if (val && typeof val == "string") {
                        val = val.toLowerCase();
                        if (val == "true") {
                            opts[propName] = true;
                        } else if (val == "false") {
                            opts[propName] = false;
                        }
                    }
                });
                var selectedNodePath = opts.selectedNodePath;
                delete opts.selectedNodePath;
                var fn = null;
                var self = this;
                if (selectedNodePath) {
                    var execNodeActionWhenSelect = opts.executeDefaultTriggerSelectedNodePath !== false;
                    fn = function () {
                        self.expandNodes(execNodeActionWhenSelect, selectedNodePath);
                    }
                }

                if (opts.enableRootSelector) {
                    var selectorContainer = $('<div class="sidebar-header-actions"><div class="selector"></div></div>');
                    selectorContainer.insertBefore($me);
                    var selectorEl = selectorContainer.find("div");
                    selectorEl.Selector({
                        dataobject: opts.rootNode,
                        datasource: opts.source,
                        selectall: false,
                        itemchanged: function (rootNode) {
                            opts.rootNode = rootNode;
                            $me.data("childlist", rootNode).prop("id", rootNode);
                            self.reload(fn);
                        }
                    });
                }
                else {
                    if (opts.rootNode) {
                        $me.data("childlist", opts.rootNode);
                    }
                    this.reload(fn);
                }
            },

            _highlightNode: function (treeBtnEl) {
                $('span').removeClass('tree-highlight-on');
                $('.btn-wrap').removeClass('tree-btn-highlight-on');
                treeBtnEl.siblings('.tree-highlight').addClass('tree-highlight-on');
                treeBtnEl.parent('.btn-wrap').addClass('tree-btn-highlight-on');
            },

            _reloadChildNodes: function (nodeEl, forceLoad, afterLoadCallback) {
                var btnOpenEl = null;
                if (nodeEl && nodeEl.length) {
                    btnOpenEl = nodeEl.find(">.btn-wrap .open-btn");
                } else {
                    nodeEl = $me;
                    btnOpenEl = $([]);
                }
                if (nodeEl.hasClass('loaded') || forceLoad) {
                    fetchChildNodes(this, nodeEl, btnOpenEl, afterLoadCallback);
                }
            },

            reloadChildNodes: function (nodeInfo, afterLoadCallback) {
                var obj = $.extend({
                    nodeId: "",
                    forceLoad: false
                }, nodeInfo);
                var nodeEl = $(dwGlobal.jqIdSelector(obj.nodeId), $me);
                if (nodeEl.length) {
                    this._reloadChildNodes(nodeEl, obj.forceLoad, afterLoadCallback);
                }
            },

            reload: function (afterLoadCallback) {
                this._reloadChildNodes(null, true, afterLoadCallback);
            },

            refreshNode: function (nodeInfo, afterRefreshCallback) {
                var obj = $.extend({
                    nodeId: "",
                    forceExpandNode: false,
                    childNodeToSelect: null,
                    execActionBySelect: false
                }, nodeInfo);
                var self = this;
                var selectFn = function () {
                    if (obj.childNodeToSelect) {
                        self.selectNode(obj.childNodeToSelect);
                        if (obj.execActionBySelect) {
                            self.executeDefaultNodeAction(obj.childNodeToSelect);
                        }
                    }
                };
                var selectAndExecCallbackFn = function () {
                    selectFn();
                    if (afterRefreshCallback) {
                        afterRefreshCallback();
                    }
                };

                if (!obj.nodeId) { /*reload tree*/
                    self.reload(selectAndExecCallbackFn);
                } else { /*refresh node*/
                    var nodeEl = $(dwGlobal.jqIdSelector(obj.nodeId), $me);
                    if (nodeEl.length) {
                        var parentEl = nodeEl.parent().closest(".parent");
                        var needExpandNode = obj.forceExpandNode || nodeEl.hasClass('loaded');
                        self._reloadChildNodes(parentEl, true, function () {
                            if (obj.nodeId == obj.childNodeToSelect) {
                                selectFn();
                            }
                            var el = $(dwGlobal.jqIdSelector(obj.nodeId), $me);
                            if (needExpandNode && el.hasClass("parent")) {
                                self.expandNode(obj.nodeId, selectAndExecCallbackFn);
                            } else {
                                selectAndExecCallbackFn();
                            }
                        });
                    } else if (obj.nodeId == $me.prop("id")) {
                        self.reload(selectAndExecCallbackFn);
                    }
                }
            },

            selectNode: function (nodeId) {
                var nodeEl = $(dwGlobal.jqIdSelector(nodeId), $me);
                var el = $(">.btn-wrap > .tree-btn", nodeEl);
                if (el.length) {
                    this._highlightNode(el);
                    el.focus();
                }
            },

            _expandNode: function (treeNodeEl, openBtnEl, nodeExpandedFn) {
                if (!treeNodeEl.hasClass('loaded')) {
                    fetchChildNodes(this, treeNodeEl, openBtnEl, nodeExpandedFn);
                } else {
                    // The inner list
                    var $a = treeNodeEl.find('>ul');

                    // Slide effect
                    $a.slideToggle(200);

                    //Toggle the folder icon
                    if (openBtnEl.hasClass('fa-caret-right')) {
                        openBtnEl.removeClass('fa-caret-right');
                        openBtnEl.addClass('fa-caret-down');
                    }
                    if (nodeExpandedFn) {
                        nodeExpandedFn();
                    }
                }
            },

            _collapseNode: function (treeNodeEl, openBtnEl) {
                // The inner list
                var $a = treeNodeEl.find('>ul');

                // Slide effect
                $a.slideToggle(200);

                openBtnEl.addClass('fa-caret-right');
                openBtnEl.removeClass('fa-caret-down');
            },

            _toggleNode: function (treeNodeEl) {
                var openBtnEl = treeNodeEl.find(">.btn-wrap > .open-btn");
                if (treeNodeEl.hasClass('parent') && !openBtnEl.hasClass('disabled')) {
                    var isNodeCollapsed = openBtnEl.hasClass("fa-caret-right");
                    if (isNodeCollapsed) {
                        this._expandNode(treeNodeEl, openBtnEl);
                    }
                    else {
                        this._collapseNode(treeNodeEl, openBtnEl);
                    }
                }
            },

            expandNode: function (nodeId, fn) {
                var treeNodeEl = $(dwGlobal.jqIdSelector(nodeId), $me);
                var openBtnEl = treeNodeEl.find(">.btn-wrap > .open-btn");
                if (treeNodeEl.hasClass('parent') && !openBtnEl.hasClass('disabled') && openBtnEl.hasClass("fa-caret-right")) {
                    this._expandNode(treeNodeEl, openBtnEl, fn);
                }
                else if (fn) {
                    fn();
                }
            },

            executeDefaultNodeAction: function (nodeId) {
                var nodeEl = $(dwGlobal.jqIdSelector(nodeId), $me);
                var nodeInfo = nodeEl.data("node-info");
                if (nodeInfo && nodeInfo.DefaultAction) {
                    $(">.btn-wrap > .tree-btn", nodeEl).trigger("click");
                    return true;
                }
            },

            expandNodes: function (execNodeActionWhenSelect, ancestorsIds, ancestorsIdsToForceReload) {
                if (!ancestorsIds || !ancestorsIds.length) {
                    return;
                }
                ancestorsIdsToForceReload = ancestorsIdsToForceReload || [];
                ancestorsIdsToForceReload = ancestorsIdsToForceReload.reduce(function (obj, val, idx) {
                    obj[val] = true;
                    return obj;
                }, {});
                var tree = this;
                var expandTreeNodes = function (treeNodes) {
                    if (!treeNodes || !treeNodes.length) {
                        return;
                    }
                    var nodeId = treeNodes.shift();
                    if (treeNodes.length) {
                        if (ancestorsIdsToForceReload[nodeId]) {
                            tree.refreshNode({
                                nodeId: nodeId,
                                forceExpandNode: true,
                                childNodeToSelect: treeNodes[treeNodes.length - 1]
                            }, function () {
                                tree.expandNode(nodeId, function () {
                                    expandTreeNodes(treeNodes);
                                });
                            });
                        }
                        else {
                            tree.expandNode(nodeId, function () {
                                expandTreeNodes(treeNodes);
                            });
                        }
                    }
                    else {
                        tree.selectNode(nodeId);
                        if (execNodeActionWhenSelect) {
                            tree.executeDefaultNodeAction(nodeId);
                        }
                    }
                };

                expandTreeNodes(ancestorsIds);
            },

            getSelected: function () {
                var result = [];
                var selected = $me.find(".tree-btn-highlight-on");
                if (selected.length < 1) {
                    return result;
                }

                var parent = $(selected).closest("li.list");
                if (parent.length > 0) {
                    result.push(parent.get(0));
                }
                return result;
            },

            getAncestors: function (element) {
                var result = [];
                if (!element) {
                    return result;
                }
                $(element).parents("li.list").map(function (index, item) {
                    result.unshift(item);
                });

                return result;
            },

            getNodeInfos: function (elements) {
                var result = [];
                for (var i = 0; i < elements.length; i++) {
                    var nodeEl = $me.find(elements[i]);
                    if (nodeEl.length < 1) {
                        continue;
                    }
                    var nodeInfo = nodeEl.data("node-info");
                    if (nodeInfo) {
                        result.push(nodeInfo);
                    }
                }
                return result;
            },

            clear: function () {
                $me.removeClass('loaded');
                $me.find(">ul").remove();
            },

            destroy: function () {
                this.clear();
                $me.removeData("treeview")
            }
        };
    }

    //TreeView jQuery plugin
    $.fn.treeView = function (option) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;
        if (option == "get") {
            return $(this).map(function (index, element) {
                return $(element).data("treeview");
            }).filter(function (index, element) {
                return !!element;
            });
        }
        //All the elements by selector
        return this.each(function () {
            var $this = $(this);
            var data = $this.data("treeview");
            if (!data) {
                $this.data("treeview", (data = new TreeView($this)));
                data.init(option);
            }
            else if (data[option]) {
                return data[option].apply(data, args);
            }
        });
    }

    $(window).on('load.dw.treeview.data-api', function () {
        $(".treeview").each(function () {
            var el = $(this);
            el.treeView(el.data());
        });
    });
})(window.jQuery);