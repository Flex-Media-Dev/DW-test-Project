<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoadBalancing_cpl.aspx.vb" Inherits="Dynamicweb.Admin.LoadBalancing_cpl" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Environment" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Load balancing</title>
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

        .parent textarea, .parent input[type=text], .parent input[type=password] {
            width: initial;
            min-width: 300px;
            font-size: 13px !important;
            color: black !important;
            border: 1px solid #333333;
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
            <%=Dynamicweb.SystemTools.Gui.HelpPopup("", "Load.balancing")%> 
        }

        function saveform() {
            if (document.getElementById("FormName").value.length < 1) {
                alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
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
            location = 'LoadBalancing_cpl.aspx?sort=down&fieldId=' + fieldId;
        }

        function sortup(fieldId) {
            overlayShow();
            location = 'LoadBalancing_cpl.aspx?sort=up&fieldId=' + fieldId;
        }

        function editField(fieldId) {
            overlayShow();
            location = "LoadBalancingEdit.aspx?ID=" + fieldId;
        }

        function newfield_old(fieldType) {
            overlayShow();
            location = "LoadBalancingEdit.aspx";
        }

        function newfield(fieldType){
            dialog.show('newfielddialog');
            document.getElementById("fieldform").reset();
            document.getElementById("FormFieldType").value = fieldType;
            document.getElementById("fieldformid").value = document.getElementById("formid").value;
            if(fieldType=="TextInput" || fieldType=="Textarea" || fieldType=="Password"){
                document.getElementById("placeholderrow").style.display = "";
            }else{
                document.getElementById("placeholderrow").style.display = "none";
            }

            if(fieldType=="Select" || fieldType=="Radio" || fieldType=="CheckBoxList"){
                document.getElementById("optionsrow").style.display = "";
                document.getElementById("optionsPreview").style.display="";
            }else{
                document.getElementById("optionsrow").style.display = "none";
                document.getElementById("optionsPreview").style.display="none";
            }
			
            document.getElementById("formfieldtextrow").style.display = "none";
            document.getElementById("FormFieldImageRow").style.display = "none";
            document.getElementById("FormFieldDescriptionrow").style.display = "";

            if(fieldType=="Text"){
                document.getElementById("FormFieldDescriptionrow").style.display = "none";
                document.getElementById("formfieldtextrow").style.display = "";
            }
            if(fieldType=="Image"){
                document.getElementById("FormFieldDescriptionrow").style.display = "none";
                document.getElementById("FormFieldImageRow").style.display = "";
            }

            document.getElementById("FormFieldName").focus();
        }

        function resetfieldform(){
            document.getElementById("fieldform").reset();
            dialog.hide('newfielddialog');
        }

        function savefield(){
            document.getElementById("fieldform").submit();
        }

        function addNode() {
            overlayShow();
            location = "LoadBalancingEdit.aspx";
        }

        function toggleActive(fieldId) {
            if (!fieldId) {
                var fieldId = ContextMenu.callingID;
            }
            overlayShow();
            navigateTo('LoadBalancing_cpl.aspx?Active=true&FieldID=' + fieldId)
        }

        function toggleRequired(fieldId) {
            if (!fieldId) {
                var fieldId = ContextMenu.callingID;
            }
            overlayShow();
            navigateTo('LoadBalancing_cpl.aspx?Required=true&FieldID=' + fieldId)
        }

        function toggleEmailfield(fieldId) {
            overlayShow();
            navigateTo('LoadBalancing_cpl.aspx?Emailfield=true&FieldID=' + fieldId)
        }

        function sortlistUpdated() {
            poststring = Sortable.serialize('fieldList', { name: 'fields' });
            sortlocation = 'LoadBalancing_cpl.aspx?formid=' + document.getElementById("formid").value + '&action=sort&' + poststring;
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
            var id = ContextMenu.callingID;

            if (confirm("<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("knude"))%>")) {
                overlayShow();
                location = 'LoadBalancingEdit.aspx?action=delete&ID=' + id
            }
        }
    </script>
</head>
<body class="screen-container">
    <div class="card" id="main">
        <dwc:CardHeader runat="server" Title="Load balancing"></dwc:CardHeader>
        <dw:Toolbar runat="server">
            <dw:ToolbarButton runat="server" ID="cmdAdd" Text="Tilføj" Icon="AddBox" OnClientClick="location='LoadBalancingEdit.aspx';"></dw:ToolbarButton>
            <dw:ToolbarButton runat="server" ID="cmdEmailNotifications" Text="Email notifications" Icon="Email" OnClientClick="location='LoadBalancingEmailNotificationEdit.aspx';" />
            <dw:ToolbarButton runat="server" ID="cmdHelp" Text="Help" Icon="Help" OnClientClick="help();"></dw:ToolbarButton>
        </dw:Toolbar>
        <div id="breadcrumb">
            <dw:TranslateLabel Text="Load balancing" runat="server" />
            &#187; <span id="breadcrumbText" runat="server"></span><span id="fieldcount" runat="server"></span>
        </div>

        <dw:Infobar runat="server" ID="feedback" Type="Information" Title="Knuder" Message="Load balancing er ikke slået til" Visible="false"></dw:Infobar>
        <dw:List ID="list" ShowPaging="false" ShowTitle="false" ShowCollapseButton="false" runat="server" StretchContent="false" PageSize="1000">
	        <Columns>
                <dw:ListColumn ID="colName" Name="Machine" Width="150" runat="server" EnableSorting="false" />
                <dw:ListColumn ID="colType" Name="Instance" Width="150" runat="server" ItemAlign="Left" HeaderAlign="Left" />
                <dw:ListColumn ID="colSort" Name="Hostname" Width="80" runat="server" ItemAlign="Left" HeaderAlign="Left" />
                <dw:ListColumn ID="colEmailfield" Name="IP Address" Width="80" runat="server" ItemAlign="Left" HeaderAlign="Left" />                
                <dw:ListColumn ID="colCreated" Name="Started" Width="120" runat="server" />
                <dw:ListColumn ID="colEdited" Name="Updated" Width="120" runat="server" />
                <dw:ListColumn ID="colActive" Name="Aktiv" Width="25" runat="server" ItemAlign="Center" HeaderAlign="Center" />
		    </Columns>
	    </dw:List>
    </div>
    <div class="card-footer" runat="server"></div>
    <div style="position: fixed; right: 25px; bottom: 5px; left: 10px;">
        <dw:Infobar runat="server" ID="sortupdated" Type="Information" Title="Sort" Message="Gemt" Visible="true"></dw:Infobar>
    </div>
    <script>
        Effect.Fade('InfoBar_sortupdated', { duration: 0 });
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
        <form id="fieldform" action="LoadBalancingEdit.aspx" method="post">
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
        <dw:ContextMenuButton ID="editButton" runat="server" Text="Rediger knude" Icon="Edit" OnClientClick="editField();" Divide="After"></dw:ContextMenuButton>
        <dw:ContextMenuButton ID="deleteButton" runat="server" Text="Slet knude" Icon="Delete" OnClientClick="deleteField();" Divide="After"></dw:ContextMenuButton>
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

