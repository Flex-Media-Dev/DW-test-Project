

var Tabs = {
    tab: function (aciveID) {
        for (var i = 1; i < 15; i++) {
            if ($("Tab" + i)) {
                $("Tab" + i).style.display = "none";
            }
        }
        if ($("Tab" + aciveID)) {
            $("Tab" + aciveID).style.display = "";
        }
    }
}

function openAuthorDialog() {
	dialog.show("AuthorDialog");
}

function comments(id) {
	dialog.show('CommentsDialog', '/Admin/Content/Comments/List.aspx?Type=news&ItemID=' + id);
}

function ribbonTab(numTab) {

    //activate button for each tab
    if (numTab == 1 && !Ribbon.isButtonActivate("DetailsRibbon")) {
        Ribbon.radioButton('DetailsRibbon', 'DetailsRibbon', 'newsGroup');
    }
    else if (numTab == 3 && !Ribbon.isButtonActivate("CategoriesRibbon")) {
        Ribbon.radioButton('CategoriesRibbon', 'CategoriesRibbon', 'newsGroup');
    }
    else if (numTab == 2 && !Ribbon.isButtonActivate("MetaRibbon")) {
        Ribbon.radioButton('MetaRibbon', 'MetaRibbon', 'newsGroup');
    }

    Tabs.tab(numTab);
}

function onTemplateSelected(sender, args) {
    $('NewsTemplateID').value = args.selectedTemplateID;
}

function IsContentSubscription() {
    var isContentSubs = Ribbon.isChecked("NewsContentSubscription");

    if (!isContentSubs) {
        if (Ribbon.isChecked("NewsManualProcess")) {
            Ribbon.checkBox("NewsManualProcess");
        }
        Ribbon.disableButton("NewsManualProcess");
    }
    else {
        Ribbon.enableButton("NewsManualProcess");
    }
}

function SelectInvalidTab() {
    var tabVal = document.getElementById('RequiredFieldValidator1').isvalid;
    if (!tabVal) {
        ribbonTab(1);
    }
    else {
        if (!IsValidList("SpecificCustFieldsValidatorList") || !IsValidList("GeneralCustFieldsValidatorList")) {
            ribbonTab(1);
        }
    }
}

function IsValidList(id) {
    var ret = true;
    var list = document.getElementById(id);
    if (list == null || list == 'undefined') return ret;

    var valIds = new Array();
    valIds = list.value.split(',');
    for (var i = 0; i < valIds.length; i++) {
        var validator = document.getElementById(valIds[i]);
        if (validator != null && validator != 'undefined') {
            ret = ret & validator.isvalid;
        }
    }
    return ret;
}

function OnActiveChange() {
    if (!Ribbon.isChecked("NewsActive")) {
        if (Ribbon.isChecked("NewsContentSubscription")) {
            Ribbon.checkBox("NewsContentSubscription");
        }
        Ribbon.disableButton("NewsContentSubscription");
    }
    else {
        Ribbon.enableButton("NewsContentSubscription");
    }

    IsContentSubscription();
}

// Categories selector    
var childWnd = null;
function openCategoriesWindow() {
    childWnd = window.open('CategorySelector.aspx',
                'catSelector',
                'toolbar=0,menubar=0,resizable=0,scrollbars=0,height=400,width=300,directories=0,location=0');
}

function showCategorySelector() {
    var openNew = (childWnd == null);
    if (!openNew) {
        try {
            var frm = childWnd.document.getElementById('form1')
        }
        catch (ex) { openNew = true; }
        if (!openNew) {
            childWnd.focus();
        }
        else {
            openCategoriesWindow();
        }
    }
    else {
        openCategoriesWindow();
    }
}

var previewWnd;
function newsPreview(newsId, tmplId) {
    previewWnd = window.open('/Admin/Module/NewsV2/News_preview.aspx?newsId=' + newsId + "&tmplId=" + tmplId,
                'previewWnd',
                'toolbar=0,menubar=0,resizable=0,scrollbars=0,height=500,width=700,directories=0,location=0');
}

function newsSaveAndPreview(confirmMessage) {
    if (!confirm(confirmMessage)) {
        return;       
    } else {
        $('OpenPreviewAfterSave').value = "true";
        //emilate save button click
        WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions("btnSaveNews", "", true, "", "", false, true));
    }
}

var NewsEdit = {
    Marketing: null,

    openContentRestrictionDialog: function (newsID) {
        this.Marketing.openSettings('ContentRestriction', { data: { ItemType: 'News', ItemID: newsID, Type: 'Reorder' } });
    },

    openProfileDynamicsDialog: function (newsID) {
        this.Marketing.openSettings('ProfileDynamics', { data: { ItemType: 'News', ItemID: newsID } });
    }
}