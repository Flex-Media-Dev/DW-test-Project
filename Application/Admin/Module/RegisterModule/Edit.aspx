<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Edit.aspx.vb" Inherits="Dynamicweb.Admin.RegisterModule.Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" runat="server"></dw:ControlResources>
    <script type="text/javascript" src="js/edit.js"></script>
    <script type="text/javascript">
        function save(doClose) {
            objform = document.forms[0];

            if (objform.Name.value == '') {
                alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Navn"))%>');
                objform.Name.focus()
                return false;
            }

            if (objform.SystemName.value == '') {
                alert('<%=Translate.JsTranslate("Der skal angives en værdi i: %%", "%%", Translate.JsTranslate("Systemnavn"))%>');
                objform.SystemName.focus()
                return false;
            }

            if (objform.SystemName.value.search(/[^\w\.]/) > -1) {
                alert("<%=Translate.JSTranslate("Ugyldige tegn i: %%", "%%", Translate.JsTranslate("Systemnavn"))%>");
                objform.SystemName.focus()
                return false;
            }

            document.getElementById("close").value = doClose ? "True" : "False"

            objform.action = "save.aspx";
            objform.__VIEWSTATE.value = "";
            objform.submit();
        }

        function help() {
		    <%=Gui.HelpPopup("registermodule", "modules.registermodule.edit")%>
        }
    </script>
</head>
<body class="area-black screen-container">
    <div class="card">
        <form id="form1" method="post" runat="server">
            <input type="hidden" name="_ID" id="_ID" value="" runat="server" />
            <input type="hidden" name="close" id="close" value="" />
            <dw:RibbonBar ID="ModuleBar" runat="server">
                <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Content" runat="server" Visible="true">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="btnSaveNews" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" OnClientClick="save(false);" />
                        <dw:RibbonBarButton ID="btnSaveAndCloseNews" Text="Save and close" Icon="Save" Size="Small" runat="server" OnClientClick="save(true);" />
                        <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="Cancel" Size="Small" runat="server" PerformValidation="false" OnClientClick="location = 'List.aspx';" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup5" Name="Information" runat="server">
                        <dw:RibbonBarRadioButton ID="ModuleRibbon" Text="Module" OnClientClick="ribbonTab(1);" Checked="true" Group="group1" Icon="InfoCircle" Size="Small" runat="server" />
                        <dw:RibbonBarRadioButton ID="SearchRibbon" Text="Search" OnClientClick="ribbonTab(2);" Group="group1" Icon="Search" Size="Small" runat="server" />
                        <dw:RibbonBarRadioButton ID="SecurityRibbon" Text="Security" Group="group1" OnClientClick="ribbonTab(3);" Icon="Exchange" Size="Small" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Help" runat="server">
                        <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large" runat="server" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="Tab1">
                <dwc:GroupBox runat="server" Title="Indstillinger">
                    <dwc:InputText ID="Name" Label="Navn" runat="server" />
                    <dwc:InputText ID="SystemName" Label="Systemnavn" runat="server" />
                    <dwc:InputText ID="Script" Label="Path to custom admin page" Info="Path should start with CustomModules/" runat="server" />
                    <dwc:InputTextArea ID="Description" Label="Beskrivelse" runat="server" />
                    <dwc:CheckBox ID="Access" Label="Enabled" Indent="true" runat="server" />
                    <dwc:CheckBox ID="Paragraph" Label="Afsnitsmodul" Indent="true" runat="server" />
                </dwc:GroupBox>
            </div>

            <div id="Tab2" style="display: none;">
                <dwc:GroupBox runat="server" Title="System">
                    <dwc:InputText ID="Database" Label="Database" runat="server" />
                    <dwc:InputText ID="ItemTable" Label="Item tabel" runat="server" />
                    <dwc:InputText ID="ItemIDQueryParameterName" Label="Item query parameter" runat="server" />
                    <dwc:InputText ID="CategoryTable" Label="Kategori tabel" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Kategori Felter">
                    <dwc:InputText ID="CategoryIdField" Label="ID" runat="server" />
                    <dwc:InputText ID="CategoryNameField" Label="Navn" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Item Felter">
                    <dwc:InputText ID="ItemIdField" Label="ID" runat="server" />
                    <dwc:InputText ID="ItemCategoryIdField" Label="Kategori ID" runat="server" />
                    <dwc:InputText ID="ItemNameField" Label="Overskrift" runat="server" />
                    <dwc:InputText ID="ItemDateField" Label="Dato" runat="server" />
                    <dwc:InputText ID="ItemLastModifiedDateField" Label="Redigeret dato" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Søgning">
                    <dwc:InputText ID="ItemSearchFields" Label="Søg i" runat="server" />
                    <dwc:InputText ID="ItemTextField" Label="Brødtekst" runat="server" />
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" Title="Publicering">
                    <dwc:InputText ID="ItemActiveField" Label="Aktiv" runat="server" />
                    <dwc:InputText ID="ItemActiveFromDateField" Label="Aktiv fra" runat="server" />
                    <dwc:InputText ID="ItemActiveToDateField" Label="Aktiv til" runat="server" />
                </dwc:GroupBox>
            </div>

            <div id="Tab3" style="display: none;">
                <dwc:GroupBox runat="server" Title="Indstillinger">
                    <dwc:InputText ID="SecDatabase" Label="Database" runat="server" />
                    <dwc:InputText ID="SecTable" Label="Kategori tabel" runat="server" />
                    <dwc:InputText ID="SecFieldID" Label="ID column" runat="server" />
                    <dwc:InputText ID="SecFieldName" Label="Name column" runat="server" />
                    <dwc:InputText ID="SecWhere" Label="Where" runat="server" />
                </dwc:GroupBox>
            </div>

        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
