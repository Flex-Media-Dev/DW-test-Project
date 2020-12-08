<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SystemUserInterface_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemUserInterface_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
	<title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib"></dwc:ScriptLib>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server" IncludeRequireJS="false">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/WaterMark.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
        </Items>
    </dw:ControlResources>
    <style>
        .area-black .container {
            padding-left: 0;
            padding-right: 0;
        }
    </style>
    <script>
        var availableLanguages = <%=Newtonsoft.Json.JsonConvert.SerializeObject(availableLanguages)%>;

        function addTranslationKey() {
            showTerminologyEditDialog(null);
        }

        function reloadTranslations() {
            $("ActionType").value = "ReloadTranslations";
            $("Tab").value = "terminology";
            document.forms[0].submit();
        }

        function reloadSettingsNavigator(){
            var ancestorsIds = ["System", "SystemUserInterface"]; 
            var tree = dwGlobal.getSettingsNavigator();
            tree.reload(function(){tree.expandAncestors(ancestorsIds, null, false)});
        }

        function showTerminologyEditDialog(listRowId) {
            var keyName = $("KeyName");

            if (!listRowId || listRowId < 1) {
                keyName.value = "";
                var translations = $("KeyEditDialog").select("textarea[name^=KeyTranslation]")
                for (var i = 0; i < translations.length; i++) {
                    translations[i].value = "";
                }
            } else {
                var listRow = List.getRowByID("TerminologiesList", listRowId);
                if (!listRow) {
                    return;
                }
                keyName.value = $(listRow).select("td")[0].textContent;
                waitOverlay.show();

                new Dynamicweb.Ajax.doPostBack({
                    parameters: {
                        IsAjax: "true"
                    },
                    onComplete: function(response) {
                        waitOverlay.hide();

                        var data = JSON.parse(response.responseText);
                        if (typeof (data) == "object") {
                            for (var item in data) {
                                $(item).value = data[item];
                            }
                        }
                    }
                });
            }

            dialog.show('KeyEditDialog');
        }

        function deleteTerminology(listRowId) {
            if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("Ord"))%>')) {
                var listRow = List.getRowByID("TerminologiesList", listRowId);
                if (!listRow) {
                    return;
                }

                let keyId = $(listRow).select("td")[0].textContent;
                document.location = "?Type=DeleteTerminology&KeyId=" + keyId;
            }
        }

        function saveTerminology() {
            var keyName = $("KeyName");
            if (keyName.value.trim() == '') {
                alert("Key name cannot be empty.");
                keyName.value = "";
                keyName.focus();
                return;
            }

            $("ActionType").value = "SaveTerminology";
            $("Tab").value = "terminology";
            document.forms[0].submit();
        }

        function showLanguageEditDialog(langId) {
            var langObj = availableLanguages[langId];
            showLanguageEditDlg("<%=Translate.JsTranslate("Edit language")%>", langObj);
        }

        function showLanguageCreateDialog() {
            showLanguageEditDlg("<%=Translate.JsTranslate("Add new language")%>");
        }

        function showLanguageEditDlg(dlgTitle, langObj) {
            langObj = langObj || {};
            (function($) {
                $("#LanguageId").val(langObj.Id || "");
                $("#LanguageName").val(langObj.Name || "");
                $("#LanguageLocale").val(langObj.Locale || "");
                $("#LanguageDateFormatShort").val(langObj.DateFormatShort || "");
                $("#LanguageDateFormatShortAndTime").val(langObj.DateFormatShortAndTime || "");
                $("#LanguageDateFormatMedium").val(langObj.DateFormatMedium || "");
                $("#LanguageDateFormatMediumAndTime").val(langObj.DateFormatMediumAndTime || "");
                $("#LanguageDateFormatLong").val(langObj.DateFormatLong || "");
                $("#LanguageDateFormatLongAndTime").val(langObj.DateFormatLongAndTime || "");
                $("#LanguageDateFormatDropDown").val(langObj.DateFormatDropDown || "");
                $("#LanguageDateFormatDropDownAndTime").val(langObj.DateFormatDropDownAndTime || "");
                dialog.setTitle("LanguageEditDialog", dlgTitle);
                dialog.show("LanguageEditDialog");
            })(jQuery);
        }
        
        function saveLanguageEdit() {
            (function($) {
                var langNameEl = $("#LanguageName");
                if (langNameEl.val()) {
                    var frm = langNameEl.closest("form");
                    $("#ActionType").val("EditLanguage");
                    $("#Tab").val("language");
                    frm.submit();
                } else {
                    alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
            }
            })(jQuery);
        }

        function activateLanguage(ID, Active) {
            document.location = "?Type=ActivateLanguage&Tab=language&ID=" + ID + "&Active=" + Active;
        }

        function deleteLanguage(ID) {
            if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("sprog"))%>')) {
                document.location = "?Type=DeleteLanguage&Tab=language&ID=" + ID;
            }
        }
        
        function showEncodingSchemaEditDialog(id) {
            (function($) {
                var rowEl = $("#" + id);
                var obj = {
                    charSet: id,
                    name: $(".encoding-schema-name", rowEl).text(),
                    codePage: $(".encoding-schema-code-page", rowEl).text()
                };
                showEncodingSchemaEditDlg("<%=Translate.JsTranslate("Edit encoding schema")%>", true, obj);
            })(jQuery);
        }

        function showEncodingSchemaCreateDialog() {
            showEncodingSchemaEditDlg("<%=Translate.JsTranslate("Add new encoding schema")%>", false);
        }

        function showEncodingSchemaEditDlg(dlgTitle, isEditOrCreate, obj) {
            obj = obj || {};
            (function($) {
                $("#EncodingSchemaEditId").val(isEditOrCreate ? obj.charSet : "");
                $("#EncodingSchemaEditCharSet").val(obj.charSet || "").prop("readonly", isEditOrCreate);
                $("#EncodingSchemaEditName").val(obj.name || "");
                $("#EncodingSchemaCodePage").val(obj.codePage || "");
                dialog.setTitle("EncodingSchemaEditDialog", dlgTitle);
                dialog.show("EncodingSchemaEditDialog");
            })(jQuery);
        }

        function saveEncodingSchemaEdit() {
            (function($) {
                var charSetEl = $("#EncodingSchemaEditCharSet");
                var nameEl = $("#EncodingSchemaEditName");
                if (charSetEl.val() && nameEl.val()) {
                    var frm = nameEl.closest("form");
                    $("#ActionType").val("EditEncodingSchema");
                    $("#Tab").val("encodings");
                    frm.submit();
                } else {
                    alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("%0% og %1%", "%0%", Translate.JsTranslate("Charset"), "%1%", Translate.JsTranslate("Navn")))%>');
                }
            })(jQuery);
        }

        function deleteEncodingSchema(id) {
            if (confirm('<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("encoding"))%>')) {
                document.location = "?Type=DeleteEncodingSchema&Tab=encodings&ID=" + id;
            }
        }

        function onTabClick(tab) {
            document.getElementById("Tab").value = tab;
        }

        function startExport() {
            dialog.show("ExportDialog");
        }

        function startImport() {
            dialog.show("ImportDialog");
        }

        function postForm(cmd) {
            document.getElementById("CMD").value = cmd;
            document.forms[0].submit();
        }
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="User interface" />
        <form runat="server">
            <input type="hidden" id="ActionType" name="Type" />
            <input type="hidden" id="Tab" name="Tab" runat="server" />
            <input type="hidden" id="CMD" name="CMD" runat="server" />
            <ul class="tab-nav" role="tablist" data-tab-color="green">
                <li role="presentation" class="<%=GetTabActiveStateClass("terminology", True) %>" onclick="onTabClick('terminology');"><a href="#terminology" role="tab" data-toggle="tab"><%= Translate.Translate("Ord") %></a></li>
                <li role="presentation" class="<%=GetTabActiveStateClass("language") %>"><a href="#language" role="tab" data-toggle="tab"><%= Translate.Translate("Sprog") %></a></li>
                <li role="presentation" class="<%=GetTabActiveStateClass("encodings") %>"><a href="#encodings" role="tab" data-toggle="tab"><%= Translate.Translate("Encodings") %></a></li>
            </ul>

            <dwc:CardBody runat="server">            
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane <%=GetTabActiveStateClass("terminology", True) %>" id="terminology">
                        <dwc:GroupBox runat="server" Title="Translations">
                            <dwc:Button runat="server" OnClick="addTranslationKey();" Title="Add translation key" ClientIDMode="Static" />
                            <dwc:Button runat="server" OnClick="reloadTranslations();" Title="Reload translations" />
                            <dwc:Button runat="server" ID="ExportButton" OnClick="startExport();" Title="Export" />
                            <dwc:Button runat="server" ID="ImportButton" OnClick="startImport();" Title="Import" />
                            <div class="m-b-10"></div>
                            <dw:List ID="TerminologiesList" ShowPaging="true" NoItemsMessage="Ikke_fundet" ShowTitle="false" runat="server" PageSize="50">
                                <Filters>
                                    <dw:ListTextFilter runat="server" ID="textFilter" Label="Search keys" WaterMarkText="Search" />
                                    <dw:ListDropDownListFilter runat="server" ID="pageSizeFilter" Label="Keys per page" AutoPostBack="true">
                                        <Items>
                                            <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                                            <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                            <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                                            <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" />
                                        </Items>
                                    </dw:ListDropDownListFilter>
                                </Filters>
                            </dw:List>
                        </dwc:GroupBox>
                    </div>
                    <div role="tabpanel" class="tab-pane <%=GetTabActiveStateClass("language") %>" id="language">
                        <dwc:GroupBox runat="server" Title="Sprog liste">
                            <dwc:Button runat="server" OnClick="showLanguageCreateDialog()" Title="Add new language" ClientIDMode="Static" />
                            <div class="m-b-10"></div>
                            <dw:List ID="LanguagesList" ShowPaging="false" NoItemsMessage="Ikke_fundet" ShowTitle="false" ShowCollapseButton="false" runat="server">
                                <Columns>
                                    <dw:ListColumn ID="colName" Name="Navn" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colUntranslated" Name="Untranslated keys" Width="120" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colISActive" Name="Aktiv" HeaderAlign="Center" ItemAlign="Center" Width="60" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colDelete" Name="Slet" HeaderAlign="Center" ItemAlign="Center" Width="60" runat="server" TranslateName="true" />
                                </Columns>
                            </dw:List>
                            <div class="form-group">
		                        <label class="control-label"><dw:Label Title="Total number of keys" runat="server" /></label>	
                                <div class="form-group-input">
				                    <asp:Literal ID="TotalNumberOfKeys" runat="server"></asp:Literal>
			                    </div>
		                    </div>
                        </dwc:GroupBox>
                    </div>
                    <div role="tabpanel" class="tab-pane <%=GetTabActiveStateClass("encodings") %>" id="encodings">
                        <dwc:GroupBox runat="server" Title="Encoding liste">
                            <dwc:Button runat="server" OnClick="showEncodingSchemaCreateDialog()" Title="Add new encoding schema" ClientIDMode="Static" />
                            <div class="m-b-10"></div>
                            <dw:List ID="EncodingSchemasList" ShowPaging="true" NoItemsMessage="Ikke_fundet" ShowTitle="false" ShowCollapseButton="false" runat="server">
                                <Columns>
                                    <dw:ListColumn ID="colEncCharset" Name="Charset" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colEncName" Name="Navn" Width="300" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colEncCodePage" Name="CodePage" HeaderAlign="Center" ItemAlign="Center" Width="60" runat="server" TranslateName="true" />
                                    <dw:ListColumn ID="colEncDelete" Name="Slet" HeaderAlign="Center" ItemAlign="Center" Width="60" runat="server" TranslateName="true" />
                                </Columns>
                            </dw:List>
                        </dwc:GroupBox>
                    </div>
                </div>
            </dwc:CardBody>
            
            <dw:Dialog ID="ExportDialog" runat="server" Title="Export translations" OkAction="postForm('Export');" OkText="Export" Size="Medium" ShowOkButton="true" ShowCancelButton="true">
                <dwc:GroupBox Title="Export settings" runat="server">
                    <dwc:SelectPicker ID="ExportLanguages" Label="Select language" Container="body" runat="server" />
                    <dwc:InputText ID="ExportFileName" Label="Save as" runat="server" />
                    <dwc:SelectPicker ID="ExportSeparator" Label="Select CSV value separator" runat="server">
                        <asp:ListItem Text="," Value="," />
                        <asp:ListItem Text=";" Value=";" />
                    </dwc:SelectPicker>
                    <dwc:CheckBox ID="ExportFileOverwrite" Label="Overwrite if file exist" Checked="false" runat="server" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="ImportDialog" runat="server" Title="Import translations" OkAction="postForm('Import');" OkText="Import" Size="Medium" ShowOkButton="true" ShowCancelButton="true">
                <dwc:GroupBox Title="Import settings" runat="server">
                    <dw:FileManager ID="ImportTranslationsFile" runat="server" Label="Load from" Folder="Files" ShowNothingSelectedOption="false" ShowPreview="false" AllowUpload="true" Extensions="csv" />
                    <dwc:SelectPicker ID="ImportSeparator" Label="Select CSV value separator" runat="server">
                        <asp:ListItem Text="," Value="," />
                        <asp:ListItem Text=";" Value=";" />
                    </dwc:SelectPicker>
                    <dwc:CheckBox ID="ImportValueOverwrite" Label="Overwrite existing translations" Checked="true" runat="server" />
                    <script>
                        document.getElementById("FM_ImportTranslationsFile").classList.remove("std");
                        document.getElementById("FM_ImportTranslationsFile").setAttribute("data-container", "body");
                    </script>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="KeyEditDialog" runat="server" Title="Translation key edit" TranslateTitle="true" Size="Large" OkAction="saveTerminology();" OkText="Save" ShowCancelButton="true" ShowClose="true" ShowOkButton="true">
                <dwc:GroupBox runat="server" Title="Key">
                    <dwc:InputText runat="server" Autofocus="true" Label="Name" ID="KeyName" />
                </dwc:GroupBox>
                <dwc:GroupBox runat="server" Title="Translations">
                    <asp:Repeater runat="server" ID="KeyTranslations"></asp:Repeater>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="LanguageEditDialog" runat="server" Title="Opret/Edit" Width="450" ShowOkButton="true" OkText="Save" OkAction="saveLanguageEdit();" ShowCancelButton="true" ShowClose="false" >
                <input type="hidden" id="LanguageId" name="LanguageId" />
                <dwc:InputText runat="server" ID="LanguageName" ClientIDMode="Static" Label="Sprognavn" />
                <dwc:InputText runat="server" ID="LanguageLocale" ClientIDMode="Static" Label="Landestandard ID" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatShort" ClientIDMode="Static" Label="Kort datoformat" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatShortAndTime" ClientIDMode="Static" Label="Kort datoformat med tid" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatMedium" ClientIDMode="Static" Label="Mellem datoformat" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatMediumAndTime" ClientIDMode="Static" Label="Mellem datoformat med tid" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatLong" ClientIDMode="Static" Label="Langt datoformat" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatLongAndTime" ClientIDMode="Static" Label="Langt datoformat med tid" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatDropDown" ClientIDMode="Static" Label="Datoformat til drop down" MaxLength="250" />
                <dwc:InputText runat="server" ID="LanguageDateFormatDropDownAndTime" ClientIDMode="Static" Label="Datoformat til drop down med tid" MaxLength="250" />
            </dw:Dialog>

            <dw:Dialog ID="EncodingSchemaEditDialog" runat="server" Title="Opret/Edit" Width="450" ShowOkButton="true" OkText="Save" OkAction="saveEncodingSchemaEdit();" ShowCancelButton="true" ShowClose="false">
                <input type="hidden" id="EncodingSchemaEditId" name="EncodingSchemaEditId" />
                <dwc:InputText runat="server" ID="EncodingSchemaEditCharSet" ClientIDMode="Static" Label="Charset" />
                <dwc:InputText runat="server" ID="EncodingSchemaEditName" ClientIDMode="Static" Label="Navn" />
                <dwc:InputNumber runat="server" ID="EncodingSchemaCodePage" ClientIDMode="Static" Label="CodePage" />
            </dw:Dialog>

            <dw:Overlay runat="server" ID="waitOverlay" Message="Please wait" ShowWaitAnimation="true"></dw:Overlay>
            <script type="text/javascript">
                var waitOverlay = new overlay("waitOverlay");
            </script>
        </form>
    </dwc:Card>
</body>
</html>