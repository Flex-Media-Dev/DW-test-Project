if (typeof Dynamicweb === 'undefined') {
    var Dynamicweb = {};
}
if (typeof Dynamicweb.Index === 'undefined') {
    Dynamicweb.Index = {};
}
//defining "typeof Dynamicweb.Index.IndexSearch" after class

class DebugLogHelper {
    constructor() {
        this.Debug = false;
        this.LogDepth = 0;
        this.Indent = "   ";
    }
    internalLogging(message, addedDepth) {
        if (this.Debug === true) {
            var prefix = "";
            var i;
            for (i = 0; i < this.LogDepth; i++) {
                prefix += this.Indent;
            }
            console.log(prefix + message);
            this.LogDepth += addedDepth;
        }
    }
    internalEndLogBlock(subtractedDepth) {
        if (this.Debug === true) {
            this.LogDepth -= subtractedDepth;
            if (this.LogDepth === 0) {
                console.log("");//spacing
            }
        }
    }
    logMessage(message) {
        if (this.Debug === true) {
            this.internalLogging(message, 0);
        }
    }
    startHelper(message) {
        if (this.Debug === true) {
            this.internalLogging(message, 0);
        }
    }
    startAction(message) {
        if (this.Debug === true) {
            this.internalLogging(message, 1);
        }
    }
    endHelper() {
        if (this.Debug === true) {
            this.internalEndLogBlock(0);
        }
    }
    endAction() {
        if (this.Debug === true) {
            this.internalEndLogBlock(1);
        }
    }
}

class IndexSearch {
    constructor() {
        this.Logger = new DebugLogHelper();
    }
    //helper methods
    HelloWorld() { alert("Hello world!"); }
    disableElementsByName(name) {
        this.Logger.startHelper("disableElementsByName(" + name + ");");
        this.toggleElementsByName(name, true);
        this.Logger.endHelper();
    }
    enableElementsByName(name) {
        this.Logger.startHelper("enableElementsByName(" + name + ");");
        this.toggleElementsByName(name, false);
        this.Logger.endHelper();
    }
    toggleElementsByName(name, disabled) {
        this.Logger.startHelper("toggleElementsByName(" + name + ", " + disabled + ");");
        var checkboxes = document.getElementsByName(name);
        if (checkboxes) {
            var i;
            for (i = 0; i < checkboxes.length; i++) {
                var checkbox = checkboxes[i];
                if (disabled === true)
                    checkbox.setAttribute("disabled", null);
                else if (disabled === false)
                    checkbox.removeAttribute("disabled");
            }
        }
        this.Logger.endHelper();
    }
    setDisabledById(id, setDisabled) {
        this.Logger.startHelper("setDisabledById(" + id + ", " + setDisabled + ");");
        var element = document.getElementById(id);
        if (element) {
            if (setDisabled)
                element.setAttribute("disabled", "");
            else
                element.removeAttribute("disabled");
        }
        this.Logger.endHelper();
    }
    isBoostSelected(el) {
        var value = el.value !== "1";
        this.Logger.logMessage("-> isBoostSelected => " + value);
        return value;
    }
    isConstantEmpty(el) {
        var value = el.value === "";
        this.Logger.logMessage("-> isConstantEmpty => " + value);
        return value;
    }
    isQuerySearchedSelected(el) {
        var value = el.checked === true;
        this.Logger.logMessage("-> isQuerySearchedSelected => " + value);
        return value;
    }
    isFacetDropdownEmpty(el) {
        var value = el.value === "";
        this.Logger.logMessage("-> isFacetDropdownEmpty => " + value);
        return value;
    }
    //end helper methods

    //actions
    forceCheckbox(id, checked) {
        this.Logger.startHelper("forceCheckbox(" + id + ", " + checked + ");");
        var checkbox = document.getElementById(id);
        if (checkbox) {
            checkbox.checked = checked;
        }
        this.Logger.endHelper();
    }
    selectFacet(id) {
        this.Logger.startAction("selectFacet(" + id + ");");
        var facetDropdown = document.getElementById(id);
        if (facetDropdown) {
            var setDisabled = !this.isFacetDropdownEmpty(facetDropdown); 

            var baseId = id.replace("_Faceted", "");
            this.setDisabledById(baseId + "_Constant", setDisabled);
            //this.setDisabledById(baseId + "_Boosted", setDisabled);
            this.forceCheckbox(baseId + "_QuerySearched", "checked");
            this.clickQuerySearched(baseId + "_QuerySearched");            
            this.setDisabledById(baseId + "_QuerySearched", setDisabled);
        }
        this.Logger.endAction();
    }
    changeConstant(id) {
        this.Logger.startAction("changeConstant(" + id + ");");
        var constantText = document.getElementById(id);
        if (constantText) {
            var baseId = id.replace("_Constant", "");
            var boostDropdown = document.getElementById(baseId + "_Boosted");
            if (boostDropdown) {
                var setDisabled = this.isBoostSelected(boostDropdown) || !this.isConstantEmpty(constantText);
                this.setDisabledById(baseId + "_Faceted", setDisabled);
            }
        }
        this.Logger.endAction(1);
    }
    selectBoost(id) {
    //    this.Logger.startAction("selectBoost(" + id + ");");
    //    var boostDropdown = document.getElementById(id);
    //    if (boostDropdown) {
    //        var baseId = id.replace("_Boosted", "");
    //        var constantText = document.getElementById(baseId + "_Constant");
    //        if (constantText) {
    //            var setDisabled = this.isBoostSelected(boostDropdown) || !this.isConstantEmpty(constantText);
    //            this.setDisabledById(baseId + "_Faceted", setDisabled);
    //        }
    //    }
    //    this.Logger.endAction();
    }
    clickQuerySearched(id) {
        this.Logger.startAction("selectQuerySearch(" + id + ");");
        var querySearchedCheckbox = document.getElementById(id);
        if (querySearchedCheckbox) {
            var baseId = id.replace("_QuerySearched", "");
            var setDisabled = !this.isQuerySearchedSelected(querySearchedCheckbox);
            this.setDisabledById(baseId + "_QuerySearchedAlt", setDisabled);
        }
        this.Logger.endAction(1);
    }
    enableDebug() {
        console.log("Debugging information enabled. Called methods will be listed in console in called order.");
        this.Logger.Debug = true;
    }
    //end actions
}

if (typeof Dynamicweb.Index.IndexSearch === 'undefined') {
    Dynamicweb.Index.IndexSearch = new IndexSearch();
}