/*
 *  Javascript file to handle PagingSettings
 */

var controlNamespace;

function DWPagingSetControlIDs(id, ns) {
    controlNamespace = ns;
}

function DWPagingFillControl(controlID) {
    if ($F(controlID) != "") {
        var values = $F(controlID).split(",");
        
        //Set results per page count
        $(controlNamespace + "Results_" + controlID).value = values[0] != "" ? values[0] : "15";
        
        //Set Previous button type
        var previousButton;
        if (values[1] != "") {
            previousButton = $(controlNamespace + "PreviousButton_Type_" + controlID + "_" + values[1]);
        }else{
            previousButton = $(controlNamespace + "PreviousButton_Type_" + controlID + "_Text");
        }
        DWPagingSetButtonType(previousButton, controlID);
        
        //Set Previous button values
        if (values[2] != "") {
            $(controlNamespace + "PreviousButton_Text_" + controlID).value = values[2];
        }
        if (values[3] != "") {
            $(controlNamespace + "PreviousButton_Image_" + controlID).value = values[3];
        }

        //Set Next button type
        var nextButton;
        if (values[4] != "") {
            nextButton = $(controlNamespace + "NextButton_Type_" + controlID + "_" + values[4]);
        }else{
            nextButton = $(controlNamespace + "NextButton_Type_" + controlID + "_Text");
        }
        DWPagingSetButtonType(nextButton, controlID);
        
        //Set Next button values
        if (values[5] != "") {
            $(controlNamespace + "NextButton_Text_" + controlID).value = values[5];
        }
        if (values[6] != "") {
            $(controlNamespace + "NextButton_Image_" + controlID).value = values[6];
        }
        
        //Set activated status
        if (values[7] == "Activated" || values[7] == "") {
            $(controlNamespace + "_Activated_" + controlID).checked = true;
            DWPagingToggleActive($(controlNamespace + "_Activated_" + controlID), controlID);
        } else {
            $(controlNamespace + "_Deactivated_" + controlID).checked = true;
            DWPagingToggleActive($(controlNamespace + "_Deactivated_" + controlID), controlID);
        }
    }else{
        DWPagingSetButtonType($(controlNamespace + "PreviousButton_Type_" + controlID + "_Text"), controlID);
        DWPagingSetButtonType($(controlNamespace + "NextButton_Type_" + controlID + "_Text"), controlID);

        $(controlNamespace + "_Activated_" + controlID).checked = true;
        DWPagingToggleActive($(controlNamespace + "_Activated_" + controlID), controlID);

        DWPagingSerializeValues(controlID);
    }
}

function DWPagingSerializeValues(controlID) {
    var values;

    //Retrieve the values
    values = $F(controlNamespace + "Results_" + controlID) + ",";
    var previousSelectors = document.getElementsByName(controlNamespace + "PreviousButton_Type_" + controlID);
    for (var i = 0; i < previousSelectors.length; i++) {
        if (previousSelectors[i].checked) {
            values += $F(previousSelectors[i]) + ",";
            DWPagingSetButtonType($(previousSelectors[i]), controlID);
        }
    }
    
    values += $F(controlNamespace + "PreviousButton_Text_" + controlID) + ",";

    values += $F(controlNamespace + "PreviousButton_Image_" + controlID) + ",";

    var nextSelectors = document.getElementsByName(controlNamespace + "NextButton_Type_" + controlID);
    for (var i = 0; i < nextSelectors.length; i++) {
        if (nextSelectors[i].checked) {
            values += $F(nextSelectors[i]) + ",";
            DWPagingSetButtonType($(nextSelectors[i]), controlID);
        }
    }
    
    values += $F(controlNamespace + "NextButton_Text_" + controlID) + ",";

    values += $F(controlNamespace + "NextButton_Image_" + controlID) + ",";

    var activatedSelectors = document.getElementsByName(controlNamespace + "_Status_" + controlID);
    for (var i = 0; i < activatedSelectors.length; i++) {
        if (activatedSelectors[i].checked) {
            values += $F(activatedSelectors[i])
        }
    }
    //Save the values to the hidden field
    $(controlID).value = values;
}

function DWPagingSetButtonType(typeSelector, controlID) {
    typeSelector.checked = true;

    var stringArray = typeSelector.id.split("_");
    if (stringArray[stringArray.length - 1] == "Text") {
        $(stringArray[0] + "_Text_TR_" + controlID).show()
        $(stringArray[0] + "_Image_TR_" + controlID).hide();
    } else if (stringArray[stringArray.length - 1] == "Image") {
        $(stringArray[0] + "_Text_TR_" + controlID).hide()
        $(stringArray[0] + "_Image_TR_" + controlID).show();
    }else{
        $(stringArray[0] + "_Text_TR_" + controlID).show()
        $(stringArray[0] + "_Image_TR_" + controlID).show();
    }
}

function DWPagingToggleActive(obj, controlID) {
    if (obj.id.indexOf("_Activated") != -1) {
        $("DWPagingControlContainer_" + controlID).show();
    }else if(obj.id.indexOf("_Deactivated") != -1) {
        $("DWPagingControlContainer_" + controlID).hide();
    }

    DWPagingSerializeValues(controlID);
}

function DWPagingProcessFileArchive(fileArchiveID) {
    var stringArray = fileArchiveID.split("_");
    DWPagingSerializeValues(stringArray[stringArray.length - 1]); 
}


function fileArchiveOnKeyUp(obj) { DWPagingProcessFileArchive(obj.id); }
function fileArchiveOnPaste(obj) { DWPagingProcessFileArchive(obj.id); }
function fileArchiveOnChange(obj) { DWPagingProcessFileArchive(obj.id); }