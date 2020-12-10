document.addEventListener('DOMContentLoaded', () => {
    start();
    document.getElementById('ExperimentName').onkeyup = validateName;
});

function start() {
    var savedStep = document.getElementById("StepName").value;

    if (savedStep == "") {
        if (parseInt(document.getElementById("ExperimentID").value) > 0) showStep("step4Settings", true);
        else showStep("step1ChooseType");
    }
    else {
        showStep(savedStep);
        enable('step3ChooseGoalNext');
    }
}

function close() {
    var reloadLocation = parent.location.toString();
    if (reloadLocation.indexOf("omc") < 0) {
        reloadLocation += "&omc=true";
    }
    if (reloadLocation.indexOf("NavigatorSync") < 0) {
        reloadLocation += "&NavigatorSync=refreshandselectpage";
    }
    parent.location = reloadLocation;
}

function setType(type) {
    document.getElementById("ExperimentType").value = type;
    hideAll();
    if (type == 1) {
        showStep("step2ChooseAlternatePage");
        document.getElementById("ShowToSearchEngineBotsSettings").style.display = "none";
    }
    if (type == 2) {
        showStep("step3ChooseGoal")
        document.getElementById("ShowToSearchEngineBotsSettings").style.display = "";
    }
}

function showStep2() {
    if (document.getElementById("ExperimentType").value == "1") {
        showStep("step2ChooseAlternatePage");
    } else {
        showStep("step3ChooseGoal");
    }
}

function validateName() {
    if (document.getElementById("ExperimentName").value.length > 0) {
        enable("SettingNextBtn");
    } else {
        disable("SettingNextBtn");
    }
}

function saveExperiment() {
    if (!document.getElementById("ExperimentName").value.length > 0) {
        alert("Please specify an split test name");
        document.getElementById("ExperimentName").focus();
        return false;
    }
    if (!getSelectedRadioValue("ExperimentGoalType")) {
        alert("Please set a goal");
        showStep("step3ChooseGoal");
        return false;
    }

    var type = parseInt(document.getElementById("ExperimentType").value)
    if (type == 1) {
        if (!document.getElementById("ExperimentAlternatePage").value.length > 0) {
            alert("Please specify an alternate page");
            showStep("step2ChooseAlternatePage");
            return false;
        }
    }

    document.getElementById("StepName").value = "saveExpirement";
    document.getElementById("experimentSetupForm").submit();
}

function hideAll() {
    document.getElementById("step1ChooseType").style.display = "none";
    document.getElementById("step2ChooseAlternatePage").style.display = "none";
    document.getElementById("step3ChooseGoal").style.display = "none";
    document.getElementById("step4Settings").style.display = "none";
    document.getElementById("step5ExperimentEnding").style.display = "none";
}

function showStep(stepid, isSettings) {
    hideAll();
    document.getElementById(stepid).style.display = "";

    document.getElementById("StepName").value = stepid;

    if (stepid == 'step5ExperimentEnding') {
        var type = parseInt(document.getElementById("ExperimentType").value);
        if (type == 1) {
            document.getElementById("TranslatelabelType").innerHTML = PageBasedSplitTestTranslated;
            $('divKeepVersions').style.display = 'none';
        }
        else if (type == 2) {
            document.getElementById("TranslatelabelType").innerHTML = ContentBasedSplitTestTranslated;
            $('divKeepVersions').style.display = '';
        }
    }

    if (stepid == 'step3ChooseGoal' || stepid == 'step4Settings') {
        var goalID = getSelectedRadioValue("ExperimentGoalType");
        switch (goalID) {
            case "Page":
                if (isSettings != true) {
                    document.getElementById("TranslatelabelGoal").innerHTML = OpenAnotherPageAsConversionPage + "(" + document.getElementById("Link_ExperimentGoalTypePageValue").value + ")";
                }
                showContent('inputAlternativePage');
                break;
            case "Item":
                if (isSettings != true) {
                    document.getElementById("TranslatelabelGoal").innerHTML = SubmittingAnItemFromTheItemCreatorModule + "(" + getItemName() + ")";
                }
                showContent('inputItemType');
                break;
            case "Form":
                if (isSettings != true) {
                    document.getElementById("TranslatelabelGoal").innerHTML = SubmittingAFormFromTheFormsModule + "(" + getFormName() + ")";
                }
                showContent('inputForm');
                break;
            case "Cart": document.getElementById("TranslatelabelGoal").innerHTML = AddingProductsToCart;
                break;
            case "Order": document.getElementById("TranslatelabelGoal").innerHTML = PlacingAnOrder;
                break;
            case "File":
                if (isSettings != true) {
                    if (document.getElementById("FM_ExperimentGoalTypeFileValue").value != "") {
                        document.getElementById("TranslatelabelGoal").innerHTML = DownloadingFile + "(" + document.getElementById("FM_ExperimentGoalTypeFileValue").value + ")";
                    }
                    else {
                        document.getElementById("TranslatelabelGoal").innerHTML = DownloadingFile + "(" + document.getElementById("FM_ExperimentGoalTypeFileValue")[0].innerHTML + ")";
                    }
                }
                showContent('inputDownloadFile');
                break;
            case "Newsletter":
                document.getElementById("TranslatelabelGoal").innerHTML = SigningUpForNewsletter;
                break;
            case "CustomGoalProviderType":
                showContent('inputCustomGoalProvider');
                break;
            case "Timespent":
                document.getElementById("TranslatelabelGoal").innerHTML = MaximizeTimeSpentOnSite;
                break;
            case "HighestAverageValueOrder":
                document.getElementById("TranslatelabelGoal").innerHTML = HighestAverageOrderValueGoalProvider;
                break;
            case "HighestAverageMarkupOrder":
                document.getElementById("TranslatelabelGoal").innerHTML = HighestAverageMarkupGoalProvider;
                break;
            case "Bounce":
                document.getElementById("TranslatelabelGoal").innerHTML = MinimizeBounceRate;
                break;
            case "Pageviews":
                document.getElementById("TranslatelabelGoal").innerHTML = MaximizePageViews;
                break;
        }
        document.getElementById("ExperimentGoalTypeFormValueHidden").value = "";
    }

    if (isSettings) {
        disable("SaveExperimentBtn");
        disableInputs(true);
    }

}

function getItemName() {
    var item = document.getElementById("ItemTypeSelect_selectboxcontent");
    if (item) {
        var itemName = item.getElementsByClassName("wide-field name");
        return (itemName && itemName.length > 0) ? itemName[0].innerHTML : AnyItemType;
    }
    return "";
}

function getFormName() {
    var itemId = parseInt(document.getElementById("ExperimentGoalTypeFormValue").value);
    var formID = document.getElementById("ExperimentGoalTypeFormValueHidden").value;
    if (isNaN(itemId) && formID == "") {
        return document.getElementById("ExperimentGoalTypeFormValue")[0].innerHTML;
    }
    else {
        var itemValue = document.getElementById("ExperimentGoalTypeFormValue").value
        if (itemValue == "") {
            itemValue = formID
        }
        let length = document.getElementById("ExperimentGoalTypeFormValue").children.length;
        for (var i = 1; i < length; i++) {
            let length = document.getElementById("ExperimentGoalTypeFormValue").children[i].children.length;
            for (var j = 0; j < length; j++) {
                if (itemValue == document.getElementById("ExperimentGoalTypeFormValue").children[i].children[j].value) {
                    return document.getElementById("ExperimentGoalTypeFormValue").children[i].children[j].innerHTML;
                }
            }
        }
    }
}

function enable(elmId) {
    document.getElementById(elmId).disabled = false;
}

function disable(elmId) {
    document.getElementById(elmId).disabled = true;
}

function disableInputs(excludeButtons) {
    var inputs = document.getElementsByTagName("input");
    for (var i = 0; i < inputs.length; i++) {

        if (excludeButtons && (inputs[i].type == "button" || inputs[i].type == "submit" || inputs[i].type == "reset"))
            continue;

        inputs[i].disabled = true;
    }
}

function observerAlternateLink() {
    if (document.getElementById("ExperimentAlternatePage").value != "") {
        enable("step2ChooseAlternatePageforwardButton");
    }
    else {
        setTimeout('observerAlternateLink()', 500);
    }
}


function getSelectedRadioValue(radioGroupName) {
    var buttonGroup = document.getElementsByName(radioGroupName);

    for (var i = 0, length = buttonGroup.length; i < length; i++) {
        if (buttonGroup[i].checked) {
            return buttonGroup[i].value;
        }
    }

    return "";
} // Ends the "getSelectedRadioValue" function

function verifyGoal() {
    if (document.getElementById("ExperimentGoalTypePage").checked) {
        if (document.getElementById("ExperimentGoalTypePageValue").value == "") {
            alert("Please select a page to use for conversion goal");
            return false;
        }
    }
    if (document.getElementById("ExperimentGoalTypeFile").checked) {
        if (document.getElementById("FM_ExperimentGoalTypeFileValue").value == "") {
            alert("Please select a file to use for conversion goal");
            return false;
        }
    }
    return true;
}

function showContent(elementId) {
    document.querySelectorAll('#goalsList .hidden-content').forEach((el) => {
        el.style.display = "none";
    });

    if (document.getElementById(elementId) != null) {
        document.getElementById(elementId).style.display = "block";
    }

    enable('step3ChooseGoalNext');
}

function showEndingTypeParams(inputId) {
    document.getElementById('divAtGivenTime').style.display = "none";
    document.getElementById('divAfterXViews').style.display = "none";
    document.getElementById('divActionAndNotification').style.display = "none";

    if (inputId != null && inputId != "" && document.getElementById(inputId) != null) {
        if (inputId != 'divActionAndNotification') {
            document.getElementById(inputId).style.display = "";
            document.getElementById('divActionAndNotification').style.display = "";
        } else {
            document.getElementById('divActionAndNotification').style.display = "none";
        }
    } else {
        document.getElementById('divActionAndNotification').style.display = "";
    }
}
