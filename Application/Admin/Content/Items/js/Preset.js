//presets
var preset = (function Preset(options) {

    function initializeContextMenu(preset, fieldId) {
        var isSelected = dwGlobal.Dom.hasClass(preset, "current") && !!preset.dataset.selected; // preset was selected and saved 
        var btnConfigure = document.getElementById("presetMenu_" + fieldId + "_btnConfigure");
        var btnConfigureAnchore = btnConfigure.querySelector("a");
        if (isSelected) {
            dwGlobal.Dom.removeClass(btnConfigureAnchore, "button-disabled");
            btnConfigureAnchore.setAttribute("title", "");
        }
        else {
            dwGlobal.Dom.addClass(btnConfigureAnchore, "button-disabled");
            var presets = preset.closest(".presets");
            btnConfigureAnchore.setAttribute("title", presets.dataset.configuretitle);
        }

        var btnReset = document.getElementById("presetMenu_" + fieldId + "_btnReset");
        if (isSelected && dwGlobal.Dom.hasClass(preset, "modified")) {
            btnReset.style.display = "block";
        }
        else {
            btnReset.style.display = "none";
        }
    }

    function initializePreset(preset, fieldId, presetId) {

        //Trigger the context-menu
        let btn = preset.querySelector(".contextTrigger");
        if (btn) {
            btn.onclick = function (e) {
                e.preventDefault();
                ContextMenu.show(e, "presetMenu_" + fieldId, fieldId, presetId, 'BottomRightRelative', btn);
                initializeContextMenu(preset, fieldId);
            };
            preset.oncontextmenu = btn.onclick;
        }
        if (dwGlobal.Dom.hasClass(preset, "new")) {
            preset.onclick = function (e) {
                api.create(fieldId);
            };
        }
        else {
            preset.onclick = function (e) {
                selectPresetBox(fieldId, presetId);
            };
        }
    }

    function createNewPresetBox(fieldId, presetId, elementBefore) {
        let presets = document.getElementById("presets_" + fieldId);
        let templatePreset = presets.querySelector(".preset-template");
        let controlId = "preset_" + fieldId + "_" + presetId;

        let newPreset = templatePreset.cloneNode(true);
        newPreset.setAttribute("id", controlId);
        dwGlobal.Dom.removeClass(newPreset, "preset-template");
        dwGlobal.Dom.addClass(newPreset, "preset");
        initializePreset(newPreset, fieldId, presetId);

        if (typeof elementBefore !== 'undefined') {
            presets.insertBefore(newPreset, elementBefore);
        }
        else {
            presets.appendChild(newPreset);
        }
        return newPreset;
    }

    function selectPresetBox(fieldId, presetId) {
        if (presetId) {
            let controlId = "preset_" + fieldId + "_" + presetId;
            var preset = document.getElementById(controlId);

            if (dwGlobal.Dom.hasClass(preset, "current")) {
                //dwGlobal.Dom.removeClass(preset, "current");
            }
            else {
                var ul = preset.closest(".presets");
                var previous = ul.querySelector(".current");
                if (previous) {
                    dwGlobal.Dom.removeClass(previous, "current");
                }
                dwGlobal.Dom.addClass(preset, "current");
            }
        }

        var selectedPreset = document.getElementById(fieldId + "_presetState");
        selectedPreset.value = presetId;
    }

    function openItemDialog(action, fieldId, presetId, onSubmit) {
        let controlId = "preset_" + fieldId + "_" + presetId;
        let presets = document.getElementById("presets_" + fieldId);
        let itemType = presets.dataset.itemtype;
        let itemId = document.getElementById(fieldId).value || ""; 

        let model = {
            Caller: controlId,
            ItemID: itemId,
            ItemType: itemType,
            Preset: presetId,
            Action: action
        };

        var url = "/Admin/Content/Items/Editing/PresetItemEdit.aspx?Caller={Caller}&ItemType={ItemType}&ItemID={ItemID}&Preset={Preset}&Action={Action}";
        Action.Execute({
            'Name': 'OpenDialog',
            'Url': url,
            'OnSubmitted': {
                'Name': 'ScriptFunction',
                'Function': function (act, m) {
                    if (onSubmit) onSubmit(m);
                }
            }
        }, model);
    }

    function openPresetDialog(action, fieldId, presetId, onSubmit) {
        let controlId = "preset_" + fieldId + "_" + presetId;
        let presets = document.getElementById("presets_" + fieldId);
        let itemType = presets.dataset.itemtype;
        let itemId = document.getElementById(fieldId).value || ""; 

        var model = {
            Caller: controlId,
            ItemID: itemId,
            ItemType: itemType,
            Preset: presetId,
            Action: action
        };

        var url = "/Admin/Content/Items/Editing/PresetEdit.aspx?Caller={Caller}&ItemType={ItemType}&ItemID={ItemID}&Preset={Preset}&Action={Action}";
        Action.Execute({
            'Name': 'OpenDialog',
            'Url': url,
            'OnSubmitted': {
                'Name': 'ScriptFunction',
                'Function': function (act, m) {
                    if (onSubmit) onSubmit(m);
                }
            }
        }, model);
    }

    var api = {
        configure: function () {
            let fieldId = ContextMenu.callingID;
            let presetId = ContextMenu.callingItemID;
            let controlId = "preset_" + fieldId + "_" + presetId;
            var preset = document.getElementById(controlId);

            let isSelected = !!preset.dataset.selected;
            if (isSelected) {
                openItemDialog("configure", fieldId, presetId,
                    function (model) {
                        dwGlobal.Dom.addClass(preset, "modified");
                    });
            }
        },
        rename: function () {
            let fieldId = ContextMenu.callingID;
            let presetId = ContextMenu.callingItemID;

            openPresetDialog("Rename", fieldId, presetId,
                function (model) {
                    let controlId = "preset_" + fieldId + "_" + presetId;
                    let preset = document.getElementById(controlId);

                    if (presetId !== model.PresetId) {
                        var newPreset = createNewPresetBox(fieldId, model.PresetId, preset);
                        preset.remove();

                        if (dwGlobal.Dom.hasClass(preset, "current")) {
                            selectPresetBox(fieldId, model.PresetId);
                        }
                        preset = newPreset;
                    }

                    preset.querySelector(".preset-title").innerText = model.PresetName;
                    if (model.PresetImage) {
                        preset.querySelector("img").src = "/Files" + model.PresetImage;
                    }
                    else {
                        let presets = preset.closest(".presets");
                        let presetImage = presets.querySelector(".preset-template img").src;
                        preset.querySelector("img").src = presetImage;
                    }
                });
        },
        edit: function () {
            let fieldId = ContextMenu.callingID;
            let presetId = ContextMenu.callingItemID;

            openItemDialog("edit", fieldId, presetId,
                function (model) {
                    if (model.Result === "newPreset") {
                        createNewPresetBox(fieldId, model.PresetId);
                    }
                });
        },
        reset: function () {
            let fieldId = ContextMenu.callingID;
            let presetId = ContextMenu.callingItemID;

            openPresetDialog("Reset", fieldId, presetId,
                function (model) {
                    let controlId = "preset_" + fieldId + "_" + presetId;
                    var preset = document.getElementById(controlId);

                    dwGlobal.Dom.removeClass(preset, "modified");
                });
        },
        remove: function () {
            let fieldId = ContextMenu.callingID;
            let presetId = ContextMenu.callingItemID;

            openPresetDialog("Remove", fieldId, presetId,
                function (model) {
                    let controlId = "preset_" + fieldId + "_" + presetId;
                    var preset = document.getElementById(controlId);
                    preset.remove();

                    if (dwGlobal.Dom.hasClass(preset, "current")) {
                        selectPresetBox(fieldId, "");
                    }
                });
        },
        create: function (fieldId) {
            openItemDialog("create", fieldId, "",
                function (model) {
                    createNewPresetBox(fieldId, model.PresetId);

                    selectPresetBox(fieldId, model.PresetId);
                });
        },

        initialize: function () {
            let mainBlock = document.getElementById('content-item');
            if (!mainBlock) {
                return;
            }

            mainBlock.querySelectorAll('.presets').forEach((presets) => {
                var items = presets.querySelectorAll(".preset");
                items.forEach((preset) => {
                    initializePreset(preset, presets.dataset.fieldid, preset.dataset.preset);
                });
            });
        }
    }

    window.addEventListener("load", (event) => {
        api.initialize(options);
    });

    return api;
})();