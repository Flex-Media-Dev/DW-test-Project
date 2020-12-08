var Action = Action || {};
(function () {
    Action.Transform = Action.Transform || function (template, data, isUrl) {
        if (data) {
            return template.replace(/\{([\w\.]*)\}/g, function (str, key) {
                var keys = key.split("."), v = data[keys.shift()];
                for (var i = 0, l = keys.length; i < l; i++) v = v[keys[i]];
                v = isUrl ? encodeURIComponent(v) : v;
                return (typeof v !== "undefined" && v !== null) ? v : "";
            });
        }
        return template;
    }

    Action.Execute = Action.Execute || function (action, model) {
        this[action.Name].apply(this, arguments);
        return false;
    };

    Action._getCurrentDialogLevel = Action._getCurrentDialogLevel || function () {
        var win = window.top;
        var frm = window.frameElement;
        var dlgToOpenLevel = 0;
        if (frm) {
            if (privateMethods.dom.hasClass(frm.parentNode, "boxbody")) { //old dialog
                frm = parent.window.frameElement || frm;
            }
            if (privateMethods.dom.hasClass(frm, "dialog")) {
                dlgToOpenLevel = parseInt(frm.parentNode.getAttribute("data-dialog-level"));
            }
        }
        return dlgToOpenLevel;
    };

    Action._getCurrentDialogAction = Action._getCurrentDialogAction || function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var opener = privateMethods.cache(win, "dialog-" + level + "_action");
        return opener;
    };

    Action._getCurrentDialogModel = Action._getCurrentDialogModel || function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var model = privateMethods.cache(win, "dialog-" + level + "_model");
        return model;
    };

    Action._getCurrentDialogOpener = Action._getCurrentDialogOpener || function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var opener = privateMethods.cache(win, "dialog-" + level + "_opener");
        return opener;
    };

    Action.showCurrentDialogLoader = Action.showCurrentDialogLoader || function () {
        var level = Action._getCurrentDialogLevel();
        privateMethods.dialog.showLoader(level, true);
    };

    Action.hideCurrentDialogLoader = Action.hideCurrentDialogLoader || function () {
        var level = Action._getCurrentDialogLevel();
        privateMethods.dialog.showLoader(level, false);
    };

    Action.OpenDialog = Action.OpenDialog || function (action, model) {
        var dlgToOpenLevel = Action._getCurrentDialogLevel() + 1;
        privateMethods.dialog.open(dlgToOpenLevel, Action.Transform(action.Url, model, true), !action.HideDialogLoader);
        var win = window.top;
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_action", action);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_model", model);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_opener", window);
        return false;
    };

    Action.OpenDialogWithPost = Action.OpenDialogWithPost || function (action, urlModel, postModel) {
        var dlgToOpenLevel = Action._getCurrentDialogLevel() + 1;
        var url = Action.Transform(action.Url, urlModel, true);
        privateMethods.dialog.openWithPost(dlgToOpenLevel, url, !action.HideDialogLoader, postModel);
        var win = window.top;
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_action", action);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_model", postModel);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_opener", window);
        return false;
    };

    Action.CloseDialog = Action.CloseDialog || function (action) {
        var dlgToOpenLevel = Action._getCurrentDialogLevel();
        if (dlgToOpenLevel > 0) {
            privateMethods.dialog.close(dlgToOpenLevel);
        }
    };

    Action.CloseAllDialogs = Action.CloseAllDialogs || function () {
        var dlgToOpenLevel = Action._getCurrentDialogLevel();
        if (dlgToOpenLevel > 0) {
            for (var i = 0; i < dlgToOpenLevel; i++) {
                privateMethods.dialog.close(i + 1);
            }
        }
    };


    Action.OpenScreen = Action.OpenScreen || function (action, model) {
        var url = Action.Transform(action.Url, model, true);        
        if (action.TargetArea) {
            var targetArea = Action.Transform(action.TargetArea, model);
            window.top.$(".static-menu li > a[data-target='" + targetArea + "']").trigger("click", { defaultAreaAction: url });
        }
        else if (window.top != window.self) {
            if (window.dwGlobal && action.Ancestors && action.Ancestors.length > 0) {
                var navWnd = window.parent.name ? window.dwGlobal.getNavigatorWindow(window.parent.name) : window;
                navWnd.dwGlobal.currentNavigator.expandAncestors(action.Ancestors);
            }
            var mainWnd = window.mainframe || window;
            if (!mainWnd.location) {
                mainWnd = mainWnd.contentWindow;
            }
            Action.showCurrentScreenLoader(true, mainWnd);
            mainWnd.location.href = url;
        }
        else if (!window.areas || window.areas.length == 0) {
            window.location.href = url;
        }
        else {

            for (var i = 0; i < window.areas.length; i++) {
                $('#' + window.areas[i] + '-iframe').addClass("iframe-closed");
            }
            $('#' + window.areas[0] + '-iframe')
                .removeClass("iframe-closed")
                .addClass("iframe-open")
                .attr('src', url);
        }

        return false;
    };

    Action.showCurrentScreenLoader = Action.showCurrentScreenLoader || function (showOrHide, currentWnd) {
        let mainWnd = currentWnd || window;
        var screenLoader = mainWnd.document.getElementById("screenLoaderOverlay");
        if (showOrHide) {
            if (!screenLoader) {
                var cnt = mainWnd.document.body;
                if (cnt) {
                    var overlayHtml = '<div class="overlay-container" id="screenLoaderOverlay"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> ';
                    cnt.insertAdjacentHTML("afterbegin", overlayHtml);
                }
            } else {
                screenLoader.style.display = "block";
            }
        } else if (screenLoader) {
            screenLoader.style.display = "none";
        }

    }

    Action.OpenWindow = Action.OpenWindow || function (action, model) {
        action.Url = Action.Transform(action.Url, model, true);
        var win = window.top;
        if (action.currentWindowAsOpener) {
            win = window;
        }
        var hasVerb = !!action.ActionVerb && action.ActionVerb != "GET";
        startUrl = hasVerb ? '' : action.Url;

        // Screen center
        var x = screen.width / 2 - 800 / 2;
        var y = screen.height / 2 - 600 / 2;
        var width = action.Width || 800;
        var height = action.Height || 600;
        var target = "_blank";
        
        if (action.OpenInNewTab) {
            win.open(startUrl, target);
            win.focus();
        } else {
            target = "dwpopup";
            win.open(startUrl, target, 'width=' + width + ',height=' + height + ',resizable=yes,scrollbars=yes,status=yes,left=' + x + ',top=' + y);
        }

        if (hasVerb) {
            Action.openWindowWithVerb(action.ActionVerb, action.Url, model, target);
        }
        return false;
    };

    // Arguments :
    //  verb : 'GET'|'POST'
    //  target : an optional opening target (a name, or "_blank"), defaults to "_self"
    Action.openWindowWithVerb = Action.openWindowWithVerb || function(verb, url, data, target) {
        var form = document.createElement("form");
        form.action = url;
        form.method = verb;
        form.target = target || "_self";
        if (data) {
            for (var key in data) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.name = key;
                input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
                form.appendChild(input);
            }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
        return form;
    };

    Action.OpenHelp = Action.OpenHelp || function (action) {
        var win = window.top;
        win.open(action.Url, "dwpopup", 'width=800,height=600,resizable=yes,scrollbars=yes,status=yes,left=' + x + ',top=' + y);
        return false;
    };

    Action.ShowMessage = Action.ShowMessage || function (action, model) {
        model = model || {};
        model.Caption =  Action.Transform(model.Caption || action.Caption || model.Title || "", model);
        model.Message = Action.Transform(model.Message || action.Message || "", model);
        Action.OpenDialog({
            Url: "/Admin/CommonDialogs/Confirm?Buttons=Close&Caption={Caption}&Message={Message}",
            HideDialogLoader: true,
            Buttons: "Close"
        }, model);

        return false;
    };

    Action.ShowPermissions = Action.ShowPermissions || function (action, model) {
        model = model || {};
        model.Key = model.Key || action.PermissionKey || "";
        model.Name = model.Name || action.PermissionName || "";
        model.SubName = model.SubName || action.PermissionSubName || "";
        model.Title = model.Title || action.PermissionTitle || "";
        model.AvailableLevels = model.AvailableLevels || action.AvailableLevels || "";
        model.ManagementArea = model.ManagementArea || action.ManagementArea || "";

        Action.OpenDialog({
            Url: "/Admin/Content/Permissions/PermissionEdit.aspx?Key={Key}&Name={Name}&SubName={SubName}&Title={Title}&AvailableLevels={AvailableLevels}&ManagementArea={ManagementArea}",
            OnSubmitted: action.OnSubmitted
        }, model);

        return false;
    };

    Action.Script = Action.Script || function (action, model) {
        if (action.Script) window.eval(action.Script);
    };

    Action.SetValue = Action.SetValue || function (action, model) {
        if (action.scope === "opener") {
            var opener = Action._getCurrentDialogOpener();
            if (action.Value) {
                if (model) {
                    opener.document.getElementById(action.Target).value = Action.Transform(action.Value, model);
                }
                else {
                    opener.document.getElementById(action.Target).value = action.Value;
                }
            } else {
                opener.document.getElementById(action.Target).value = encodeURIComponent(JSON.stringify(model));
            }
        }
        else {
            if (action.Value) {
                if (model) {
                    document.getElementById(action.Target).value = Action.Transform(action.Value, model);
                }
                else {
                    document.getElementById(action.Target).value = action.Value;
                }
            } else {
                document.getElementById(action.Target).value = encodeURIComponent(JSON.stringify(model));
            }

        }
    };

    Action.ConfirmMessage = Action.ConfirmMessage || function (action, model) {
        if (confirm(action.Message)) {
            Action.Execute(action.OnConfirm, model);
        }

        return false;
    }

    Action.ScriptFunction = Action.ScriptFunction || function (action, model) {
        var context = window;
        if (action.Context) {
            if (typeof action.Context === 'string') {
                context = window[action.Context];
            } else if (typeof action.Context === 'object') {
                context = action.Context;
            }
        }
        var opts = {};
        for (var propertyName in action) {
            if (propertyName != "Name" && propertyName != "Context" && propertyName != "Function") {
                var val = action[propertyName];
                if (typeof val == 'string' && model) {
                    val = Action.Transform(val, model);
                }
                opts[propertyName] = val;
            }
        }

        if (action.Function) {
            var fn = typeof action.Function !== 'function' ? context[action.Function] : action.Function;
            if (typeof fn !== 'function') {
                fn = eval(action.Function);
            }
            if (typeof fn == 'function') {
                fn.apply(context, [opts, model]);
            }
        }
        return false;
    }

    var execAjaxRequest = function (action, model) {
        action.Url = Action.Transform(action.Url, model, true)
        var params = {};
        for (var propertyName in action.Parameters) {
            var val = action.Parameters[propertyName];
            if (typeof val == 'string' && model) {
                val = Action.Transform(val, model);
            }
            params[propertyName] = val;
        }        
        var heads = {};
        for (var header in action.Headers) {
            var key = action.Headers[header].Key;
            var value = action.Headers[header].Value;
            if (key.length > 0 && value.length > 0) {
                if (key in heads) {
                    heads[key] = heads[key] + ',' + value;
                } else {
                    heads[key] = value;
                }
            }
        }
        var ajaxFn = $.ajax || window.top.$.ajax;
        var ajaxRequest = ajaxFn({
            url: action.Url,
            type: action.Type || action.ActionType,
            data: params,
            headers: heads
        });
        return ajaxRequest;
    };

    Action.AjaxAction = Action.AjaxAction || function (action, model) {
        var ajaxRequest = execAjaxRequest(action, model);
        if (action.OnSuccess) {
            ajaxRequest.done(function (result, textStatus) {
                Action.Execute(action.OnSuccess, result, textStatus);
            });
        }
        if (action.OnFail || action.ShowError) {
            ajaxRequest.fail(function (jqXHR, textStatus, textStatusDescription) {
                if (action.ShowError) {
                    alert(textStatusDescription);
                    console.log(jqXHR.responseText);
                }
                if (action.OnFail) {
                    Action.Execute(action.OnFail, model, textStatus);
                }
            });
        }
        return false;
    }

    Action.ApplicationResponseAjaxAction = Action.ApplicationResponseAjaxAction || function (action, model) {
        var ajaxRequest = execAjaxRequest(action, model);
        if (action.OnSuccess) {
            ajaxRequest.done(function (responseModel, textStatus) {
                if (responseModel.Succeeded) {
                    Action.Execute(action.OnSuccess, responseModel.Data);
                }
                else if (action.OnFail) {
                    Action.Execute(action.OnFail, responseModel);
                }
            });
        }
        ajaxRequest.fail(function (jqXHR, textStatus, textStatusDescription) {
            // something wrong
            console.error("Abnormal behavior", action, model, jqXHR);
            if (action.OnFail) {
                Action.Execute(action.OnFail, {
                    Message: textStatusDescription
                }, textStatus);
            }
        });

        return false;
    }

    Action.Composite = Action.Composite || function (action, model) {
        if (action.Actions) {
            for (var i = 0; i < action.Actions.length; i++) {
                Action.Execute(action.Actions[i], model);
            };
        }
        return false;
    }

    Action.Empty = Action.Empty || function (action, model) { } // Empty action do nothing
    Action[""] = Action[""] || Action.Empty // Empty action fallback
    Action[null] = Action[null] || Action.Empty // Empty action fallback

    var privateMethods = {
        dom: {
            hasClass: function (el, className) {
                if (el.classList)
                    return el.classList.contains(className);
                else
                    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
            }
        },

        dialog: {
            open: function (dlgLevel, url, showScreenLoader) {
                var dlgObj = this.getDialog(dlgLevel, true, showScreenLoader);
                var win = window.top;
                var frm = win.document.getElementById(dlgObj.frame);
                var backDrop = win.document.getElementById(dlgObj.backdrop);
                if (backDrop) {
                    backDrop.style.display = "block";
                }
                frm.className = "dialog iframe-open inprogress";
                frm.setAttribute("src", url);
                if (dlgLevel == 1) {
                    dlgObj.topWndStyle = win.document.body.style;
                    win.document.body.style.overflow = "hidden";
                }
            },

            openWithPost: function (dlgLevel, url, showScreenLoader, model) {
                var dlgObj = this.getDialog(dlgLevel, true, showScreenLoader);
                var win = window.top;
                var frm = win.document.getElementById(dlgObj.frame);
                var backDrop = win.document.getElementById(dlgObj.backdrop);
                if (backDrop) {
                    backDrop.style.display = "block";
                }
                frm.className = "dialog iframe-open inprogress";
                var postForm = null;
                frm.addEventListener('load', () => {
                    if (postForm && postForm.parentNode) {
                        postForm.remove();
                    }
                });
                postForm = Action.openWindowWithVerb('POST', url, model, frm.id);
                
                if (dlgLevel == 1) {
                    dlgObj.topWndStyle = win.document.body.style;
                    win.document.body.style.overflow = "hidden";
                }
            },

            getDialog: function (dlgLevel, create, showScreenLoader) {
                var win = window.top;
                var dlgObj = privateMethods.cache(win, "dialog-" + dlgLevel + "_def");
                if (dlgObj || !create) {
                     return dlgObj || null;
                }
                var dlgHtml = '<div class="dialog-iframe-container" data-dialog-level="' + dlgLevel + '" id="dialog-cnt-' + dlgLevel + '"> \
                                <iframe src="" class="dialog iframe-closed" id="dialog-frame-' + dlgLevel + '" name="dialog-frame-' + dlgLevel + '" onload="this.classList.remove(\'inprogress\')"></iframe>';
                dlgHtml += '<div class="modal-backdrop overlay-container" id="dialog-backdrop-' + dlgLevel + '"><div class="overlay-panel">';
                if (showScreenLoader) {
                    dlgHtml += '<i class="fa fa-refresh fa-3x fa-spin"></i>';
                }
                dlgHtml += '</div></div></div>';
                dlgObj = {
                    container: "dialog-cnt-" + dlgLevel,
                    frame: "dialog-frame-" + dlgLevel,
                    backdrop: "dialog-backdrop-" + dlgLevel
                };

                var dlgDoc = win.document;
                dlgDoc.body.insertAdjacentHTML("afterbegin", dlgHtml);
                privateMethods.cache(win, "dialog-" + dlgLevel + "_def", dlgObj);
                return dlgObj;
            },

            close: function (dlgLevel) {
                var dlgObj = this.getDialog(dlgLevel, false);
                if (dlgObj) {
                    var win = window.top;
                    var frm = win.document.getElementById(dlgObj.frame);
                    var backDrop = win.document.getElementById(dlgObj.backdrop);
                    if (backDrop) {
                        backDrop.style.display = "none";
                    }
                    frm.className = "dialog iframe-closed";
                    frm.setAttribute("src", "about:blank");
                    if (dlgLevel == 1 && dlgObj.topWndStyle) {
                        win.document.body.style = dlgObj.topWndStyle;
                    }
                }
            },

            showLoader: function (dlgLevel, showScreenLoader) {
                let frameId = "dialog-frame-" + dlgLevel;
                var win = window.top;
                var frm = win.document.getElementById(frameId);
                if (frm) {
                    if (showScreenLoader) {
                        frm.classList.add("inprogress");
                    } else {
                        frm.classList.remove("inprogress");
                    }
                }
            }
        },

        cache: function (win, key, val) {
            win.g_actions_cache = win.g_actions_cache || {};
            if (val === undefined) {
                return win.g_actions_cache[key] || null;
            }
            if (val === null) {
                if (win.g_actions_cache[key] !== undefined) {
                    delete win.g_actions_cache[key];
                }
                return null;
            }
            win.g_actions_cache[key] = val;
            return val
        }
    };
})();