<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditForm.aspx.vb" Inherits="Dynamicweb.Admin.BasicForms.EditForm" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Environment" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" runat="server" />
    <style>
        .parent {
            min-height: 20px;
        }

        .label {
            width: 250px;
            vertical-align: text-top;
        }

        .labeloverfield {
            width: 340px;
        }

        .activeFalse .container {
            opacity: 0.25;
        }

        .fieldcell {
        }

        .prepend {
            background-color: #e1e1e1;
            height: 100%;
            height: 16px;
            line-height: 16px;
            padding: 2px;
            padding-top: 2px;
            border: 1px solid #d1d1d1;
            border-right-width: 0px;
            display: none;
        }

        .append {
            background-color: #e1e1e1;
            height: 100%;
            display: inline-block;
            height: 16px;
            line-height: 16px;
            padding: 2px;
            border: 1px solid #d1d1d1;
            border-left-width: 0px;
            display: none;
        }

        a.bold {
        }

        .parent > li {
            border-bottom: 1px dashed #e1e1e1;
        }

        .container .tools {
            color: #e1e1e1;
        }

            .container .tools .toolsinner {
                display: none;
            }

        .parent, .subparent {
            list-style: none;
            padding-left: 10px;
        }

        .parent .container {
            cursor: pointer;
            border: 1px solid transparent;
            padding: 5px;
        }

            .parent .container:hover {
                border: 1px dashed transparent;
                background-color: #fcfcfc;
            }

        .parent textarea, .parent input[type=text], .parent input[type=password], .parent input[type=email], .parent input[type=date], .parent input[type=datetime] {
            width: initial;
            min-width: 300px;
            font-size: 13px !important;
            color: black !important;
            border: 1px solid #333333;
            padding: 4px;
        }
        .parent input[type=file]{
            padding: 4px;
        }

        .parent img {
            max-width: 250px;
        }

        .Example {
            background-color: rgb(232, 232, 220);
            border: 1px solid lightgrey;
            padding: 5px;
        }
    </style>
    <script type="text/javascript">
        function help() {
            <%=Gui.HelpPopup("", "modules.basicforms.edit")%> }

        function saveform() {
            if (document.getElementById("FormName").value.length < 1) {
                alert('<%=Translate.JSTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
                document.getElementById("FormName").focus();
                return;
            }
            overlayShow();
            document.getElementById("form1").submit();
        }

        function resetform() {
            dialog.hide('settingsDialog');
            document.getElementById("form1").reset();
        }

        function overlayShow() {
            showOverlay('wait');
        }

        function getScroll() {
            return "&scroll=" + document.getElementById("main").scrollTop;
        }

        function navigateTo(url) {
            location = url + getScroll();
        }

        function sortdown(fieldId) {
            overlayShow();
            location = 'EditForm.aspx?sort=down&fieldId=' + fieldId;
        }

        function sortup(fieldId) {
            overlayShow();
            location = 'EditForm.aspx?sort=up&fieldId=' + fieldId;
        }

        function editField(fieldId) {
            overlayShow();
            location = "EditField.aspx?ID=" + document.getElementById("formid").value + "&FieldID=" + fieldId;
        }

        function newfield_old(fieldType) {
            overlayShow();
            location = "EditField.aspx?ID=" + document.getElementById("formid").value + "&fieldtype=" + fieldType;
        }

        function newfield(fieldType) {
            dialog.show('newfielddialog');
            document.getElementById("fieldform").reset();
            document.getElementById("FormFieldType").value = fieldType;
            document.getElementById("fieldformid").value = document.getElementById("formid").value;

            var inputPatternRow = document.getElementById("FormFieldInputPatternRow");
            var titleRow = document.getElementById("FormFieldTitleRow");
            var textRow = document.getElementById("formfieldtextrow");
            var imageRow = document.getElementById("FormFieldImageRow");
            var descriptionRow = document.getElementById("FormFieldDescriptionrow");
            var placeholderRow = document.getElementById("placeholderrow");
            var optionsRow = document.getElementById("optionsrow");
            var optionsPreview = document.getElementById("optionsPreview");
            var formFieldRequiredRow = document.getElementById("formfieldrequiredrow");

            inputPatternRow.style.display = "none";
            titleRow.style.display = "";
            textRow.style.display = "none";
            imageRow.style.display = "none";
            descriptionRow.style.display = "";

            if (fieldType == "TextInput" || fieldType == "Textarea" || fieldType == "Password") {
                placeholderRow.style.display = "";
            } else {
                placeholderRow.style.display = "none";
            }

            if (fieldType == "Select" || fieldType == "Radio" || fieldType == "CheckBoxList") {
                optionsRow.style.display = "";
                optionsPreview.style.display = "";
            } else {
                optionsRow.style.display = "none";
                optionsPreview.style.display = "none";
            }

            if (fieldType == "Text") {
                descriptionRow.style.display = "none";
                textRow.style.display = "";
                titleRow.style.display = "none";
            }
            if (fieldType == "Image") {
                descriptionRow.style.display = "none";
                imageRow.style.display = "";
            }
            if (fieldType == "PageShift") {
                descriptionRow.style.display = "none";
                formFieldRequiredRow.style.display = "none";
                titleRow.style.display = "none";
            }
            if (fieldType == "TextInput" || fieldType == "Password") {
                inputPatternRow.style.display = "";
            }

            document.getElementById("FormFieldName").focus();
        }

        function resetfieldform() {
            document.getElementById("fieldform").reset();
            dialog.hide('newfielddialog');
        }

        function savefield() {
            document.getElementById("fieldform").submit();
        }

        function copyfield() {
            var fieldId = ContextMenu.callingID;
            overlayShow();
            location = 'EditForm.aspx?Copy=true&FieldID=' + fieldId
        }

        function addfieldbefore() {
            overlayShow();
            var fieldId = ContextMenu.callingID;
            location = "EditField.aspx?ID=" + document.getElementById("formid").value + "&sortOnNewField=before&relativefield=" + fieldId;
        }

        function addfieldafter() {
            overlayShow();
            var fieldId = ContextMenu.callingID;
            location = "EditField.aspx?ID=" + document.getElementById("formid").value + "&sortOnNewField=after&relativefield=" + fieldId;
        }

        function toggleActive(fieldId) {
            if (!fieldId) {
                var fieldId = ContextMenu.callingID;
            }
            overlayShow();
            navigateTo('EditForm.aspx?Active=true&FieldID=' + fieldId)
        }

        function toggleRequired(fieldId) {
            if (!fieldId) {
                var fieldId = ContextMenu.callingID;
            }
            overlayShow();
            navigateTo('EditForm.aspx?Required=true&FieldID=' + fieldId)
        }

        function toggleEmailfield(fieldId) {
            overlayShow();
            navigateTo('EditForm.aspx?Emailfield=true&FieldID=' + fieldId)
        }

        function sortlistUpdated() {
            poststring = Sortable.serialize('fieldList', { name: 'fields' });
            sortlocation = 'EditForm.aspx?formid=' + document.getElementById("formid").value + '&action=sort&' + poststring;
            ajaxSendRequest(sortlocation, sortlistUpdatedEnd);
        }

        function ajaxSendRequest(url, callbackHandler) {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = callbackHandler;
            xmlhttp.open("GET", url, true);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
            xmlhttp.send('');
        }

        function sortlistUpdatedEnd() {
            var xmlhttp = arguments[0].target;

            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                Effect.Appear('InfoBar_sortupdated', { duration: 0.3 });
                setTimeout("hideSortMessage()", 3000);
            }
        }

        function hideSortMessage() {
            Effect.Fade('InfoBar_sortupdated', { duration: 1.0 });
        }

        function editFieldContext() {
            var fieldId = ContextMenu.callingID;
            editField(fieldId);
        }

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        function deleteField() {
            var fieldId = ContextMenu.callingID;

            var fieldObj = document.getElementById("fieldname" + fieldId);
            var fieldName = ""
            if (fieldObj == null) {
                fieldName = document.querySelectorAll("#row" + fieldId + " td")[1].innerText;
            } else {
                fieldName = fieldObj.innerHTML;
            }
            if (confirm("<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("felt"))%> (" + fieldName + ")")) {
                overlayShow();
                location = 'EditForm.aspx?Delete=true&FieldID=' + fieldId
            }

        }
        function deleteOption() {
            var optionID = ContextMenu.callingID;
            if (confirm("<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("valgmulighed"))%>")) {
                alert(optionID);
            }
        }
        function setlistmode(list) {
            location = "EditForm.aspx?ID=" + document.getElementById("formid").value + "&listmode=" + list;
        }

        function showdata() {
            location = "ListSubmits.aspx?formid=" + document.getElementById("formid").value;
        }
    </script>
</head>
<body class="screen-container">
    <div class="card" id="main">
        <dw:RibbonBar runat="server" ID="myribbon">
            <dw:RibbonBarTab Active="true" Name="Formular" runat="server">
                <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Formular">
                    <dw:RibbonBarButton ID="cmdName" runat="server" Size="Small" Text="Settings" Icon="Cog" OnClientClick="dialog.show('settingsDialog');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton runat="server" Text="Luk" Size="Small" Icon="TimesCircle" ID="cmdCancel" OnClientClick="location='ListForms.aspx';" ShowWait="true" WaitTimeout="1500">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="addFieldGroup" runat="server">
                    <dw:RibbonBarButton ID="cmdRestriction" runat="server" Size="Small" Icon="pencil" Text="Tekst" OnClientClick="newfield('TextInput');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton1" runat="server" Size="Small" Icon="ListAlt" Text="Notat-felt" OnClientClick="newfield('Textarea');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton3" runat="server" Size="Small" Icon=" CheckSquareO" Text="CheckBox" OnClientClick="newfield('CheckBox');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton5" runat="server" Size="Small" Icon="eyeSlash" Text="Skjult" OnClientClick="newfield('Hidden');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton9" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Password)_16x16.png" Text="Kodeord" OnClientClick="newfield('Password');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton8" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (File)_16x16.png" Text="File" OnClientClick="newfield('File');">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="addListGroup" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton2" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Select Single)_16x16.png" Text="Select" OnClientClick="newfield('Select');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton4" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Radio)_16x16.png" Text="Radio-knap" OnClientClick="newfield('Radio');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton13" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Checkbox)_16x16.png" Text="Checkbox list" OnClientClick="newfield('CheckBoxList');">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="addButtonGroup" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton6" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Button OK)_16x16.png" Text="Send" OnClientClick="newfield('Submit');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton7" runat="server" Size="Small" ImagePath="/Admin/Images/Ribbon/Icons/Small/Form Input (Button Cancel)_16x16.png" Text="Reset" OnClientClick="newfield('Reset');">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="addElementGroup" runat="server">
                    <dw:RibbonBarButton ID="RibbonBarButton12" runat="server" Size="Small" Icon="Dashboard" Text="Brødtekst" OnClientClick="newfield('Text');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton10" runat="server" Size="Small" Icon="Image" Text="Billede" OnClientClick="newfield('Image');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton14" runat="server" Size="Small" Icon="ContentCut" Text="Page shift" OnClientClick="newfield('PageShift');">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="RibbonBarButton11" runat="server" Size="Small" Icon="Label" Text="Mellemrum" OnClientClick="newfield('Divider');" Visible="false">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" ID="RibbonBarGroup1" Name="Vis">
                    <dw:RibbonBarButton ID="btnform" runat="server" Size="Small" Text="Formular" Icon="Assignment" OnClientClick="setlistmode(false);" ShowWait="true" WaitTimeout="1500">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btnlist" runat="server" Size="Small" Text="Liste" Icon="List" OnClientClick="setlistmode(true);" ShowWait="true" WaitTimeout="1500">
                    </dw:RibbonBarButton>
                    <dw:RibbonBarButton ID="btndata" runat="server" Size="Small" Text="Form data" Icon="Database" OnClientClick="showdata();" ShowWait="true" WaitTimeout="1500">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="helpGroup" runat="server" Name="Help">
                    <dw:RibbonBarButton ID="cmdHelp" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();">
                    </dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
        <div id="breadcrumb">
            <dw:TranslateLabel Text="Formularer" runat="server" />
            &#187; <span id="breadcrumbText" runat="server"></span><span id="fieldcount" runat="server"></span>
        </div>

        <dw:Infobar runat="server" ID="noelements" Type="Information" Title="Felter" Message="" Visible="false"></dw:Infobar>
        <dw:List ID="list" ShowPaging="false" ShowTitle="false" ShowCollapseButton="false" runat="server" StretchContent="false" AllowMultiSelect="true" Visible="false" PageSize="1000">
            <Columns>
                <dw:ListColumn ID="colName" Name="Name" Width="150" runat="server" EnableSorting="false" />
                <dw:ListColumn ID="colSystemname" Name="System name" Width="120" runat="server" ItemAlign="Left" HeaderAlign="Left" />
                <dw:ListColumn ID="colType" Name="Type" Width="120" runat="server" ItemAlign="Left" HeaderAlign="Left" />
                <dw:ListColumn ID="colAutomaticValue" Name="Automatisk værdi" Width="60" runat="server" ItemAlign="Left" HeaderAlign="Center" />
                <dw:ListColumn ID="colOptions" Name="Valgmuligheder" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colSort" Name="Sortering" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colActive" Name="Aktiv" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colRequired" Name="Krævet" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colEmailfield" Name="E-mail felt" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colHideInReceipt" Name="Hide in receipt" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                <dw:ListColumn ID="colCreated" Name="Edited" Width="120" runat="server" />
                <dw:ListColumn ID="colEdited" Name="Bruger" Width="120" runat="server" />
            </Columns>
        </dw:List>

        <div id="previewformcontainer" runat="server">
            <form id="previewform" onsubmit="return false;" style="margin:0">
                <ul id="fieldList" class="parent" runat="server">
                    <li id="f1">
                        <div class="container">
                            <table>
                                <tr>
                                    <td style="width: 170px;">
                                        <label><a href="javascript:alert('Clicked');">Name</a></label></td>
                                    <td>
                                        <input type="text" readonly="readonly" placeholder="Placeholder text" /></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><small>This is the help text</small></td>
                                </tr>
                            </table>
                            <div style="position: absolute; top: 0px; right: 0px;">
                                <img src="/Admin/images/Minus.gif" />
                            </div>
                        </div>
                        <ul class="subparent">
                        </ul>
                    </li>
                    <li id="f2">
                        <div class="container">
                            <table>
                                <tr>
                                    <td style="width: 170px; vertical-align: top">
                                        <label><a href="javascript:alert('Clicked');">Field name</a></label></td>
                                    <td>
                                        <input type="checkbox" disabled="disabled" /><label>Label name</label><br />
                                        <input type="checkbox" disabled="disabled" /><label>Label name</label><br />
                                        <input type="checkbox" disabled="disabled" /><label>Label name</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><small>This is the help text</small></td>
                                </tr>
                            </table>
                        </div>
                        <ul class="subparent">
                        </ul>
                    </li>
                    <li id="f3">
                        <div class="container">
                            <table>
                                <tr>
                                    <td style="width: 170px; vertical-align: top">
                                        <label>Field name</label></td>
                                    <td>
                                        <input type="radio" disabled="disabled" /><label>Label name</label><br />
                                        <input type="radio" disabled="disabled" /><label>Label name</label><br />
                                        <input type="radio" disabled="disabled" /><label>Label name</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><small>This is the help text</small></td>
                                </tr>
                            </table>
                        </div>
                        <ul id="subparent1" class="subparent">
                            <%--<li id="sf1">
						<div class="container">SubField 1</div>
					</li>
					<li id="sf2">
						<div class="container">SubField 2</div>
					</li>
					<li id="sf3">
						<div class="container">SubField 3</div>
					</li>--%>
                        </ul>
                    </li>
                    <li id="f4">
                        <div class="container">
                            <table>
                                <tr>
                                    <td style="width: 170px; vertical-align: top">
                                        <label>Field name</label></td>
                                    <td>
                                        <textarea readonly="readonly"></textarea></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><small>This is the help text</small></td>
                                </tr>
                            </table>
                        </div>
                        <ul class="subparent">
                        </ul>
                    </li>
                    <li id="f5">
                        <div class="container">
                            <table>
                                <tr>
                                    <td style="width: 170px;">
                                        <label>Field name</label></td>
                                    <td>
                                        <input type="text" readonly="readonly" /></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><small>This is the help text</small></td>
                                </tr>
                            </table>
                        </div>
                        <ul class="subparent">
                            <li>
                                <text>Test</text>
                            </li>
                        </ul>
                    </li>
                </ul>
            </form>
            <div>&nbsp;</div>
        </div>
    </div>
    <div class="card-footer" runat="server"></div>
    <div style="position: fixed; right: 25px; bottom: 5px; left: 10px;">
        <dw:Infobar runat="server" ID="sortupdated" Type="Information" Title="Sort" Message="Gemt" Visible="true"></dw:Infobar>
    </div>
    <script>
        Position.includeScrollOffsets = true;

        Sortable.create('fieldList', { only: "field-row", delay: 20, tag: 'li', onUpdate: sortlistUpdated });

        Effect.Fade('InfoBar_sortupdated', { duration: 0 });
        //Sortable.create('subparent1', { containment: ['subparent1', 'subparent2'], dropOnEmpty: true });
        //Sortable.create('subparent2', { containment: ['subparent1', 'subparent2'], dropOnEmpty: true });
    </script>

    <dw:Dialog ID="settingsDialog" runat="server" Size="Medium" ShowOkButton="true" OkAction="saveform();" OkText="Gem" ShowCancelButton="true" CancelAction="resetform();" ShowClose="true" Title="Indstillinger">
        <form id="form1" runat="server" method="post" enableviewstate="false">
            <input type="hidden" id="formid" runat="server" />
            <input type="hidden" id="action" runat="server" value="save" />
            <dw:GroupBox ID="GB_settings" runat="server" DoTranslation="True" Title="Indstillinger">
                <table>
                    <tr>
                        <td width="170" valign="top">
                            <label for="FormName">
                                <dw:TranslateLabel runat="server" Text="Navn" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormName" name="FormName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormEmailFieldID">
                                <dw:TranslateLabel runat="server" Text="E-mail felt" />
                            </label>
                        </td>
                        <td>
                            <select runat="server" id="FormEmailFieldID" class="std">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormDefaultTemplate">
                                <dw:TranslateLabel runat="server" Text="Default template" />
                            </label>
                        </td>
                        <td>
                            <dw:FileManager ID="FormDefaultTemplate" Name="FormDefaultTemplate" runat="server" DisableFileArchive="False" DisableParagraphSelector="True" Folder="Templates/Forms/Form" FullPath="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormMaxSubmits">
                                <dw:TranslateLabel runat="server" Text="Max submits" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormMaxSubmits" name="FormMaxSubmits" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormCssClass">
                                <dw:TranslateLabel runat="server" Text="Css Class" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormCssClass" name="FormCssClass" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormFieldSize">
                                <dw:TranslateLabel runat="server" Text="Input field size" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldSize" name="FormFieldSize" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <dw:GroupBox ID="GroupBox1" runat="server" DoTranslation="True" Title="Avanceret">
                <table>
                    <tr>
                        <td width="170" valign="top">
                            <label for="FormLabelRequired">
                                <dw:TranslateLabel runat="server" Text="Ikon ved krævet felt" />
                            </label>
                        </td>
                        <td>
                            <dw:FileManager ID="FormLabelRequired" Name="FormLabelRequired" runat="server" DisableFileArchive="False" DisableParagraphSelector="True" FullPath="true" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="FormColumnShiftFormFieldID">
                                <dw:TranslateLabel runat="server" Text="Kolonneskift efter" />
                            </label>
                        </td>
                        <td>
                            <select runat="server" id="FormColumnShiftFormFieldID" name="FormColumnShiftFormFieldID" class="std">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="FormLabelOverField" FieldName="FormLabelOverField" />
                            <label for="FormLabelOverField">
                                <dw:TranslateLabel runat="server" Text="Felt under navn" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" Value="1" ID="FormLabelBold" FieldName="FormLabelBold" />
                            <label for="FormLabelBold">
                                <dw:TranslateLabel runat="server" Text="Feltnavn med fed" />
                            </label>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
        </form>
    </dw:Dialog>

    <dw:Dialog ID="newfielddialog" runat="server" Size="Medium" ShowOkButton="true" OkAction="savefield();" OkText="Gem" ShowCancelButton="true" CancelAction="resetfieldform();" ShowClose="true" Title="New field">
        <form id="fieldform" action="EditField.aspx" method="post">
            <input type="hidden" name="formid" id="fieldformid" value="" />
            <input type="hidden" name="fieldid" id="fieldid" value="0" />
            <input type="hidden" name="action" id="fieldaction" value="save" />
            <input type="hidden" name="close" id="close" value="True" />
            <input type="hidden" name="FormFieldType" id="FormFieldType" />
            <input type="hidden" name="FormFieldActive" id="FormFieldActive" value="True" />
            <dw:GroupBox ID="GroupBox2" runat="server" DoTranslation="True" Title="Indstillinger">
                <table>
                    <tr>
                        <td width="170" valign="top">
                            <label for="FormFieldName">
                                <dw:TranslateLabel runat="server" Text="Tekst/Label" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldName" name="FormFieldName" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr id="placeholderrow" style="display: none;">
                        <td>
                            <label for="FormFieldPlaceholder">
                                <dw:TranslateLabel runat="server" Text="Placeholder" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldPlaceholder" name="FormFieldPlaceholder" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr id="formfieldrequiredrow">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" Value="1" ID="FormFieldRequired" FieldName="FormFieldRequired" />
                            <label for="FormFieldRequired">
                                <dw:TranslateLabel runat="server" Text="Obligatorisk" />
                            </label>
                        </td>
                    </tr>
                    <tr id="FormFieldDescriptionrow">
                        <td valign="top">
                            <label for="FormFieldDescription">
                                <dw:TranslateLabel runat="server" Text="Beskrivelse" />
                            </label>
                        </td>
                        <td>
                            <textarea name="FormFieldDescription" id="FormFieldDescription" runat="server" cols="25" maxlength="255" class="std"></textarea>
                        </td>
                    </tr>
                     <tr id="FormFieldTitleRow">
                        <td>
                             <label for="FormFieldTitle">
                                <dw:TranslateLabel runat="server" Text="Title" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldTitle" name="FormFieldTitle" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                    <tr id="FormFieldInputPatternRow">
                        <td>
                             <label for="FormFieldInputPattern">
                                <dw:TranslateLabel runat="server" Text="Input pattern" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldInputPattern" name="FormFieldInputPattern" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>

                    <tr id="formfieldtextrow">
                        <td valign="top">
                            <label for="FormFieldText">
                                <dw:TranslateLabel runat="server" Text="Tekst" />
                            </label>
                        </td>
                        <td>
                            <textarea name="FormFieldText" id="FormFieldText" runat="server" cols="25" maxlength="255" class="std"></textarea>
                        </td>
                    </tr>
                    <tr id="FormFieldImageRow">
                        <td>
                            <dw:TranslateLabel runat="server" Text="Billede" />
                        </td>
                        <td>
                            <dw:FileManager ID="FormFieldImage" Name="FormFieldImage" runat="server" />
                        </td>
                    </tr>
                    <tr id="optionsrow">
                        <td valign="top">
                            <dw:TranslateLabel runat="server" Text="Valgmuligheder" />
                        </td>
                        <td>
                            <textarea class="std" rows="6" id="FormOptionsMany" name="FormOptionsMany"></textarea>
                        </td>
                    </tr>

                </table>

            </dw:GroupBox>

            <table>
                <tr id="optionsPreview">
                    <td>
                        <fieldset>
                            <legend class="gbTitle">Example</legend>
                            <table class="Example">
                                <tbody>
                                    <tr>
                                        <td width="170">
                                            <label name="Name">Value;Label Text</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="170">
                                            <label name="Description">Value2</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="170">
                                            <label name="Options">Value3;Label 3</label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </dw:Dialog>

    <dw:ContextMenu ID="EditField" runat="server">
        <dw:ContextMenuButton ID="ContextMenuButton3" runat="server" Text="Rediger" Icon="Pencil" OnClientClick="editFieldContext();" Divide="After">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextMenuButton4" runat="server" Text="Aktiv" Icon="Check" OnClientClick="toggleActive();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextMenuButton5" runat="server" Text="Krævet" Icon="Check" OnClientClick="toggleRequired();" Divide="After">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextMenuButton1" runat="server" Text="Insert before" Icon="VerticalAlignTop" OnClientClick="addfieldbefore();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="ContextMenuButton2" runat="server" Text="Insert after" Icon="VerticalAlignBottom" OnClientClick="addfieldafter();">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="copyFieldBtn" runat="server" Text="Kopier felt" Icon="ContentCopy" OnClientClick="copyfield();" Divide="Before">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton ID="deleteFieldBtn" runat="server" Text="Slet felt" Icon="Delete" OnClientClick="deleteField();" Divide="None">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
    <script>
<%If Dynamicweb.Context.Current.Request.GetInt32("scroll") > 0 Then%>
        document.getElementById("main").scrollTop = <%=Dynamicweb.Context.Current.Request.GetInt32("scroll")%>;
<%End If%>
</script>
<%  
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
</body>
</html>