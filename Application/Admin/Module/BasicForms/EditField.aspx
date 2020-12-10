<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditField.aspx.vb" Inherits="Dynamicweb.Admin.EditField" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" IncludeScriptaculous="false" runat="server"></dw:ControlResources>
    <script type="text/javascript">
        function help() {
		    <%=Gui.HelpPopup("", "modules.basicforms.editfield")%>
        }

        function updatePreview() {
            var previewGroupBox = document.getElementById("previewGroup");
            if (previewGroupBox) {
                var elem = document.getElementById("fieldpreview").getElementsByTagName("input")[0];
                if (null != document.getElementById("FormFieldPlaceholder")) {
                    if (elem != null) {
                        ele.setAttribute("placeholder", document.getElementById("FormFieldPlaceholder").value);
                    } else {
                        elem = document.getElementById("fieldpreview").getElementsByTagName("textarea")[0];
                        if (elem != null) {
                            ele.setAttribute("placeholder", document.getElementById("FormFieldPlaceholder").value);
                        }
                    }
                }

                document.getElementById("fieldpreviewlabel").innerHTML = document.getElementById("FormFieldName").value;
                document.getElementById("fielddescription").innerHTML = document.getElementById("FormFieldDescription").value;
            }
        }

        function savefield(close) {
            if (document.getElementById("FormFieldName").value.length < 1) {
                alert('<%=Translate.JSTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
                document.getElementById("FormFieldName").focus();
                return;
            }
            overlayShow();
            if (close) {
                document.getElementById("close").value = "True"
            }
            document.getElementById("form1").submit();
        }

        function savelayout() {
            overlayShow();
            document.getElementById("form1").submit();
        }

        function newoption(many) {
            editoption(0, "", "", true, false);
            if (many) {
                document.getElementById("manyoptions").style.display = "block";
                document.getElementById("singleoption").style.display = "none";
                document.getElementById("FormOptionsMany").focus();
            }
        }

        function editoption(optionid, text, value, include, isdefault) {
            document.getElementById("manyoptions").style.display = "none";
            document.getElementById("singleoption").style.display = "block";
            document.getElementById("FormOptionsID").value = optionid;
            document.getElementById("FormOptionsText").value = decode(text);
            document.getElementById("FormOptionsValue").value = decode(value);
            document.getElementById("FormOptionsActive").checked = include;
            document.getElementById("FormOptionsDefaultSelected").checked = isdefault;
            dialog.show('optionsettings');
            document.getElementById("FormOptionsText").focus();
        }

        function decode(encoded) {
            if (encoded.length > 0) {
                var div = document.createElement('div');
                div.innerHTML = encoded;
                return div.firstChild.nodeValue;
            }
            return encoded;
        }

        function saveoption() {
            if (document.getElementById("manyoptions").style.display == "block") {
                if (document.getElementById("FormOptionsMany").value.length < 1) {
                    alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Valgmuligheder"))%>');
                    document.getElementById("FormOptionsMany").focus();
                    return false;
                }
            } else {
                if (document.getElementById("FormOptionsText").value.length < 1) {
                    alert('<%=Translate.JSTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Tekst"))%>');
                    document.getElementById("FormOptionsText").focus();
                    return false;
                }
            }

            document.getElementById("optionform").submit();
        }

        function sortdown(optionId) {
            overlayShow();
            location = 'EditField.aspx?sort=down&optionId=' + optionId;
        }

        function sortup(optionId) {
            overlayShow();
            location = 'EditField.aspx?sort=up&optionId=' + optionId;
        }

        function sortbytext(desc) {
            overlayShow();
            var fieldid = document.getElementById("fieldid").value;
            location = 'EditField.aspx?action=sortbytext&fieldid=' + fieldid + '&desc=' + desc;
        }

        function sortbyvalue(desc) {
            overlayShow();
            var fieldid = document.getElementById("fieldid").value;
            location = 'EditField.aspx?action=sortbyvalue&fieldid=' + fieldid + '&desc=' + desc;
        }

        function back() {
            location = "EditForm.aspx?ID=" + document.getElementById("formid").value;
        }
        function overlayShow() {
            showOverlay('wait');
        }

        function toggleActive(optionId) {
            overlayShow();
            location = 'EditField.aspx?Active=true&optionId=' + optionId
        }

        function toggleDefault(optionId) {
            overlayShow();
            location = 'EditField.aspx?Default=true&optionId=' + optionId
        }

        function deleteOption(optionId) {
            if (confirm("<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("valgmulighed"))%>")) {
                overlayShow();
                location = 'EditField.aspx?Delete=true&optionId=' + optionId
            }
        }

        function showlayout() {
            layoutDialog
        }

        function fieldTypeChanged() {
            var e = document.getElementById("FormFieldType");
            var fieldtype = e.options[e.selectedIndex].value;
            if (confirm("<%=Translate.JsTranslate("Unsaved changes will be lost when changing field type. Continue?")%>")) {
                location = "EditField.aspx?ID=" + document.getElementById("formid").value + "&FieldID=" + document.getElementById("fieldid").value + "&fieldtype=" + fieldtype;
            }
        }
    </script>
    <style type="text/css">
        div.listcontainer {
            border: 1px solid #ABADB3;
            min-height: 200px;
            overflow-x: hidden;
        }

        #fieldpreview textarea, #fieldpreview input[type=text], #fieldpreview input[type=password] {
            width: initial;
            min-width: 250px;
            font-size: 13px !important;
            color: black !important;
            border: 1px solid #333333;
            padding: 4px;
        }

        #fieldpreview img {
            max-width: 250px;
        }

        #cke_FormFieldText {
            box-sizing: border-box;
        }
    </style>
</head>
<body onload="document.getElementById('FormFieldName').select();" class="screen-container">
    <div class="card">
        <form id="form1" runat="server" enableviewstate="false">
            <input type="hidden" id="formid" runat="server" />
            <input type="hidden" id="fieldid" runat="server" />
            <input type="hidden" id="action" runat="server" value="save" />
            <input type="hidden" id="close" runat="server" />
            <input type="hidden" id="newfieldsort" runat="server" />

            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Felt" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="toolsGroup" Name="Felt">
                        <dw:RibbonBarButton ID="cmdName" runat="server" Size="Small" Text="Gem" Icon="Save" OnClientClick="savefield(false);">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton1" runat="server" Size="Small" Text="Gem og luk" Icon="Save" OnClientClick="savefield(true);">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="Cancel" ID="cmdCancel" OnClientClick="back();" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="settingsGroup" runat="server" Name="Indstillinger">
                        <dw:RibbonBarButton ID="cmdRestriction" runat="server" Size="Small" Icon="Laptop" Text="Layout" OnClientClick="dialog.show('layoutDialog');">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton2" runat="server" Size="Small" Icon="Code" Text="Værdier" OnClientClick="dialog.show('valuesDialog');">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="optionSortGroup" runat="server" Name="Valgmuligheder" Visible="false">
                        <dw:RibbonBarButton ID="RibbonBarButton3" runat="server" Size="Small" Icon="SortAlphaAsc" Text="Sort by text" OnClientClick="sortbytext(false);">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton4" runat="server" Size="Small" Icon="SortAlphaDesc" Text="Sort by text (descending)" OnClientClick="sortbytext(true);">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton7" runat="server" Size="Small" Text="hidden" Visible="false">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton5" runat="server" Size="Small" Icon="SortAlphaAsc" Text="Sort by value" OnClientClick="sortbyvalue(false);">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton ID="RibbonBarButton6" runat="server" Size="Small" Icon="SortAlphaDesc" Text="Sort by value (descending)" OnClientClick="sortbyvalue(true);">
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
                &#187; <span id="breadcrumbTextFormname" runat="server"></span>
                &#187; <span id="breadcrumbTextFieldname" runat="server"></span>
                <span id="optioncount" runat="server"></span>
            </div>


            <dw:GroupBox ID="GB_settings" runat="server" DoTranslation="True" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td style="width: 170px; vertical-align:top">
                            <label for="FormFieldName">
                                <dw:TranslateLabel runat="server" Text="Tekst/Label" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldName" name="FormFieldName" runat="server" maxlength="255" class="std" onblur="updatePreview();" />
                        </td>
                    </tr>
                    <tr id="placeholderrow" runat="server" visible="false">
                        <td>
                            <label for="FormFieldPlaceholder">
                                <dw:TranslateLabel runat="server" Text="Placeholder" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldPlaceholder" name="FormFieldPlaceholder" runat="server" maxlength="255" class="std" onblur="updatePreview();" />
                        </td>
                    </tr>
                    <tr runat="server" id="formfieldrequiredrow" visible="true">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" Value="1" ID="FormFieldRequired" FieldName="FormFieldRequired" />
                            <label for="FormFieldRequired">
                                <dw:TranslateLabel runat="server" Text="Obligatorisk" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="FormFieldActive" FieldName="FormFieldActive" />
                            <label for="FormFieldActive">
                                <dw:TranslateLabel runat="server" Text="Aktiv" />
                            </label>
                        </td>
                    </tr>
                    <tr runat="server" id="FormFieldHideInReceiptRow">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="FormFieldHideInReceipt" FieldName="FormFieldHideInReceipt" />
                            <label for="FormFieldHideInReceipt">
                                <dw:TranslateLabel runat="server" Text="Hide field in receipt" />
                            </label>
                        </td>
                    </tr>
                    <tr runat="server" id="FormFieldDescriptionRow">
                        <td valign="top">
                            <label for="FormFieldDescription">
                                <dw:TranslateLabel runat="server" Text="Beskrivelse" />
                            </label>
                        </td>
                        <td>
                            <textarea name="FormFieldDescription" id="FormFieldDescription" runat="server" cols="25" class="std" onblur="updatePreview();"></textarea>
                        </td>
                    </tr>    
                    <tr runat="server" id="FormFieldTitleRow">
                        <td>
                            <label for="FormFieldTitle">
                                <dw:TranslateLabel runat="server" Text="Title" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldTitle" name="FormFieldTitle" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>    
                    <tr>
                        <td>
                            <label for="FormFieldType">
                                <dw:TranslateLabel runat="server" Text="Type" />
                            </label>
                        </td>
                        <td>
                            <dw:GroupDropDownList runat="server" ID="FormFieldType" CssClass="std"></dw:GroupDropDownList>
                        </td>
                    </tr>                    
                    <tr runat="server" id="FormFieldEmailFieldRow" visible="false">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" Value="1" ID="FormFieldEmailField" FieldName="FormFieldEmailField" />
                            <label for="FormFieldEmailField">
                                <dw:TranslateLabel runat="server" Text="E-mail felt" />
                            </label>
                        </td>
                    </tr>
                    <tr runat="server" id="formfieldtextrow" visible="false">
                        <td valign="top">
                            <label for="FormFieldText">
                                <dw:TranslateLabel runat="server" Text="Tekst" />
                            </label>
                        </td>
                        <td>
                            <div style="width: 60%">
                                <dw:Editor runat="server" ID="FormFieldText" />
                            </div>
                        </td>
                    </tr>
                    <tr runat="server" id="FormFieldActivityRow" visible="false">
                        <td>
                            <dw:TranslateLabel runat="server" Text="Consent" />
                        </td>
                        <td>
                            <select id="FormFieldActivity" name="FormFieldActivity" runat="server" class="std">
                            </select>
                        </td>
                    </tr>
                    <tr runat="server" id="FormFieldImageRow">
                        <td>
                            <dw:TranslateLabel runat="server" Text="Billede" />
                        </td>
                        <td>
                            <dw:FileManager ID="FormFieldImage" Name="FormFieldImage" runat="server" />
                        </td>
                    </tr>
                    <tr runat="server" id="FormFieldInputPatternRow" visible="false">
                        <td>
                             <label for="FormFieldInputPattern">
                                <dw:TranslateLabel runat="server" Text="Input pattern" />
                            </label>
                        </td>
                        <td>
                            <input type="text" id="FormFieldInputPattern" name="FormFieldInputPattern" runat="server" maxlength="255" class="std" />
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <a name="options"></a>
            <dw:GroupBox ID="optionsGroup" runat="server" DoTranslation="True" Visible="false" Title="Valgmuligheder">
                <table class="formsTable">
                    <tr>
                        <td style="width: 170px;"></td>
                        <td>
                            <div class="listcontainer" style="width: 60%;">
                                <dw:List ID="optionslist" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server" StretchContent="false" PageSize="500">
                                    <Columns>
                                        <dw:ListColumn ID="colText" Name="Tekst" Width="250" runat="server" EnableSorting="false" />
                                        <dw:ListColumn ID="colValue" Name="Værdi" Width="150" runat="server" ItemAlign="Left" HeaderAlign="Left" />
                                        <dw:ListColumn ID="colSort" Name="Sortering" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                                        <dw:ListColumn ID="colActive" Name="Aktiv" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                                        <dw:ListColumn ID="colDefault" Name="Default" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                                        <dw:ListColumn ID="colDelete" Name="Slet" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" />
                                    </Columns>
                                </dw:List>
                            </div>
                            <br />
                            <button onclick="newoption();return false;" class="btn"><%=Translate.Translate("Tilføj %%", "%%", Translate.Translate("valgmulighed"))%></button>
                            <button onclick="newoption(true);return false;" class="btn"><%=Translate.Translate("Tilføj %%", "%%", Translate.Translate("valgmuligheder")) %></button>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:GroupBox ID="previewGroup" runat="server" DoTranslation="True" Title="Preview" Visible="false">
                <table>
                    <tr>
                        <td style="width: 170px;"></td>
                        <td>
                            <table>
                                <tr>
                                    <td width="170" valign="top">
                                        <span runat="server" id="fieldpreviewlabel"></span>
                                    </td>
                                    <td>
                                        <div runat="server" id="fieldpreview"></div>
                                        <div><small runat="server" id="fielddescription"></small></div>
                                    </td>
                                </tr>
                                <tr runat="server" visible="true">
                                    <td width="170" valign="top"></td>
                                    <td>
                                        <pre runat="server" id="fieldhtml" style="color: #d3d3d3; font-family: 'Courier New'; font-size: 12px;"></pre>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>

            <dw:Dialog ID="valuesDialog" runat="server" Size="Medium" ShowOkButton="true" Title="Værdier">
                <dw:GroupBox ID="GroupBox5" runat="server" DoTranslation="True" Title="Værdier">
                    <table>
                        <tr>
                            <td width="170">
                                <label for="FormFieldDefaultValue">
                                    <dw:TranslateLabel runat="server" Text="Standard værdi" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldDefaultValue" name="FormFieldDefaultValue" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="FormFieldAutoValue">
                                    <dw:TranslateLabel runat="server" Text="Automatisk værdi" />
                                </label>
                            </td>
                            <td>
                                <%=FormFieldAutoValueSelect(FormFieldAutoValue, "FormFieldAutoValue")%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="FormFieldMaxLength">
                                    <dw:TranslateLabel runat="server" Text="Max længde" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldMaxLength" name="FormFieldMaxLength" runat="server" size="25" maxlength="255" class="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="layoutDialog" runat="server"  Size="Medium" ShowOkButton="true" OkAction="savelayout();" Title="Layout">
                <dw:GroupBox ID="GroupBox6" runat="server" DoTranslation="True" Title="Felter">
                    <table>

                        <tr>
                            <td width="170">
                                <label for="FormFieldPrepend">
                                    <dw:TranslateLabel runat="server" Text="Prepend" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldPrepend" name="FormFieldPrepend" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="FormFieldAppend">
                                    <dw:TranslateLabel runat="server" Text="Append" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldAppend" name="FormFieldAppend" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox2" runat="server" DoTranslation="True" Title="Layout">
                    <table>
                        <tr>
                            <td width="170">
                                <label for="FormFieldCssClass">
                                    <dw:TranslateLabel runat="server" Text="Css Class" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldCssClass" name="FormFieldCssClass" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="FormFieldSize">
                                    <dw:TranslateLabel runat="server" Text="Størrelse (i px)" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldSize" name="FormFieldSize" runat="server" size="25" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr runat="server" id="FormFieldTextareaHeightRow">
                            <td>
                                <label for="FormFieldTextareaHeight">
                                    <dw:TranslateLabel runat="server" Text="Højde (Linier)" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldTextareaHeight" name="FormFieldTextareaHeight" runat="server" size="25" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr runat="server" visible="false">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Farve" />
                            </td>
                            <td>
                                <dw:ColorSelect runat="server" ID="FormFieldColor" Name="FormFieldColor" />
                            </td>
                        </tr>

                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox1" runat="server" DoTranslation="True" Title="Avanceret">
                    <table>
                        <tr>
                            <td width="170">
                                <label for="FormFieldSystemName">
                                    <dw:TranslateLabel runat="server" Text="Systemnavn" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormFieldSystemName" name="FormFieldSystemName" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>
        </form>
        <div>&nbsp;</div>
    </div>
    <dw:Dialog ID="optionsettings" runat="server"  Size="Medium" ShowOkButton="true" ShowCancelButton="true" Title="Valgmulighed" OkAction="saveoption();">
        <form action="EditField.aspx" method="post" id="optionform">
            <input type="hidden" name="editoption" value="true" />
            <input type="hidden" name="FormOptionsID" id="FormOptionsID" />
            <input type="hidden" name="FormOptionsFieldID" id="FormOptionsFieldID" runat="server" />
            <div id="manyoptions" style="display: none;">
                <dw:GroupBox ID="GroupBox7" runat="server" DoTranslation="True" Title="Valgmuligheder">
                    <table>
                        <tr>
                            <td>
                                <textarea style="width: 490px;" rows="6" id="FormOptionsMany" name="FormOptionsMany"></textarea><br />
                                <input type="checkbox" value="true" id="FormOptionsManyDelete" name="FormOptionsManyDelete" /><label for="FormOptionsManyDelete"><dw:TranslateLabel runat="server" Text="Delete existing options" />
                                </label>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox8" runat="server" DoTranslation="True" Title="Eksempel">
                    <table>

                        <tr>
                            <td>
                                <textarea readonly="readonly" style="width: 490px;" rows="4" disabled="disabled">Value;Label text
Value2
Value3;Label 3</textarea>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>
            <div id="singleoption">
                <dw:GroupBox ID="GroupBox3" runat="server" DoTranslation="True" Title="Valgmulighed">
                    <table>
                        <tr>
                            <td width="170" valign="top">
                                <label for="FormOptionsText">
                                    <dw:TranslateLabel runat="server" Text="Text" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormOptionsText" name="FormOptionsText" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="FormOptionsValue">
                                    <dw:TranslateLabel runat="server" Text="Værdi" />
                                </label>
                            </td>
                            <td>
                                <input type="text" id="FormOptionsValue" name="FormOptionsValue" runat="server" maxlength="255" class="std" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox4" runat="server" DoTranslation="True" Title="Indstillinger">
                    <table>
                        <tr>
                            <td width="170" valign="top"></td>
                            <td>
                                <dw:CheckBox runat="server" ID="FormOptionsActive" FieldName="FormOptionsActive" />
                                <label for="FormOptionsActive">
                                    <dw:TranslateLabel runat="server" Text="Aktiv" />
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <dw:CheckBox runat="server" Value="1" ID="FormOptionsDefaultSelected" FieldName="FormOptionsDefaultSelected" />
                                <label for="FormOptionsDefaultSelected">
                                    <dw:TranslateLabel runat="server" Text="Default" />
                                </label>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>
        </form>
    </dw:Dialog>

    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
    <script>
        document.getElementById("FormFieldType").onchange = fieldTypeChanged;
    </script>
</body>
</html>