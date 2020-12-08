<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="eCom_IntegrationCustomerCenter_edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_IntegrationCustomerCenter" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb" %>

<input type="hidden" id="eCom_IntegrationCustomerCenter_settings" name="eCom_IntegrationCustomerCenter_settings" value="NavigationTemplate, ItemsPerPage, PagerNextButtonType, PagerPrevButtonType, PagerNextButtonTypeText, PagerNextButtonTypePicture, PagerPrevButtonTypeText, PagerPrevButtonTypePicture" />

<dw:ModuleHeader ID="dwHeaderModule" runat="server" ModuleSystemName="eCom_IntegrationCustomerCenter" />

<dw:GroupBox Title="Navigation" runat="server">
    <table cellpadding="2" cellspacing="0" width="100%" border="0">
        <colgroup>
            <col width="170px" />
            <col />
        </colgroup>
        <tr style="padding-top: 10px;">
            <td valign="top">
                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Navigation template" />
            </td>
            <td style="white-space: nowrap;">
                <dw:FileManager ID="NavigationTemplate" runat="server" Name="NavigationTemplate" Folder="Templates/eCom/IntegrationCustomerCenter" />
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Pages" DoTranslation="true">
    <!-- table to show pages in -->
    <table id="PagesTable">
    </table>

    <div style="height: 5px;">&nbsp;</div>

    <!-- Add button -->
    <div style="margin: 5px 5px 5px 5px;">
        <a onclick="addNewPage();" title="<%=Dynamicweb.SystemTools.Translate.JsTranslate("Add new page")%>">
            <span
                style="font-style: italic; color: Gray;"
                onmouseover="this.style.textDecoration = 'underline';"
                onmouseout="this.style.textDecoration = 'none';">
                <i class="<%= Core.UI.Icons.KnownIconInfo.ClassNameFor(Core.UI.Icons.KnownIcon.PlusSquare) %>"></i>
                <dw:TranslateLabel runat="server" Text="Add page" />
            </span>
        </a>
    </div>
</dw:GroupBox>

<dw:GroupBox ID="grpboxPaging" Title="Paging" runat="server">
    <table cellpadding="2" cellspacing="0" width="100%" border="0">
        <colgroup>
            <col width="170px" />
            <col />
        </colgroup>
        <tr style="padding-top: 10px;">
            <td valign="top">
                <dw:TranslateLabel ID="dwTransPaging" runat="server" Text="Items per page" />
            </td>
            <td style="padding-left: 2px;"><%=Dynamicweb.SystemTools.Gui.SpacListExt(_intItemsPerPage, "ItemsPerPage", 1, 100, 1, "")%></td>
        </tr>
        <tr style="padding-top: 10px;">
            <td valign="top">
                <dw:TranslateLabel ID="transPagingNext" Text="Next button" runat="server" />
            </td>
            <td><%=Dynamicweb.SystemTools.Gui.ButtonText("PagerNextButtonType", _pagerNextSelectedType, _pagerNextImage, _pagerNextText)%></td>
        </tr>
        <tr style="padding-top: 10px;">
            <td valign="top">
                <dw:TranslateLabel ID="transPagingBack" Text="Prev button" runat="server" />
            </td>
            <td><%= Dynamicweb.SystemTools.Gui.ButtonText("PagerPrevButtonType", _pagerPrevSelectedType, _pagerPrevImage, _pagerPrevText)%></td>
        </tr>
    </table>
</dw:GroupBox>

<dw:Dialog runat="server" ID="EditPageDialog" Title="Edit page settings" Size="Medium" TranslateTitle="true" ShowCancelButton="true" ShowOkButton="true" OkAction="savePageEdit();">
    <input type="hidden" id="PageIndex" />
    <table>
        <colgroup>
            <col width="170px" />
            <col />
        </colgroup>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Name" />
            </td>
            <td>
                <input type="text" runat="server" id="PageName" name="PageName" class="NewUIinput" /></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Type" />
            </td>
            <td>
                <input type="text" runat="server" id="PageType" name="PageType" class="NewUIinput" />
                <div>
                    <dw:TranslateLabel runat="server" ID="LblSupportedTypes" Text="SupportedTypes" />
                    <dw:Label runat="server" ID="PageTypes" doTranslation="False" />
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="Menu name" />
            </td>
            <td>
                <input type="text" runat="server" id="PageMenuName" name="PageMenuName" class="NewUIinput" /></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Tag name" />
            </td>
            <td>
                <input type="text" runat="server" id="PageTagName" name="PageTagName" class="NewUIinput" /></td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="List Template" />
            </td>
            <td style="white-space: nowrap;">
                <dw:FileManager ID="PageListTemplate" runat="server" Name="PageListTemplate" Folder="Templates/eCom/IntegrationCustomerCenter" FullPath="true" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Item template" />
            </td>
            <td style="white-space: nowrap;">
                <dw:FileManager ID="PageItemTemplate" runat="server" Name="PageItemTemplate" Folder="Templates/eCom/IntegrationCustomerCenter" FullPath="true" />
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="ItemId query string parameter name" />
            </td>
            <td style="white-space: nowrap;">
                <input type="text" runat="server" id="ItemIdParameterName" name="ItemIdParameterName" class="NewUIinput" /></td>
            </td>
        </tr>
    </table>
    <br />
    <br />
</dw:Dialog>

<!-- Div containing the pages values -->
<div id="HiddensPages"></div>
<!-- Translated names -->
<div id="Translate_Edit" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Edit" />
</div>
<div id="Translate_Delete" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Delete" />
</div>
<div id="Translate_No_PageName" style="display: none;">
    <dw:TranslateLabel runat="server" Text="Unnamed" />
</div>

<input type="hidden" runat="server" id="PagesJSON" value="[]" />

<script type="text/javascript">
    function addHidden(settingName, name, value, excludeInSettings, excludeInHiddens) {
        // Add to hiddens
        if (!excludeInHiddens) {
            var hiddenDiv = document.getElementById('Hiddens' + settingName);
            var hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.value = value;
            hidden.name = name;
            hiddenDiv.appendChild(hidden);
        }

        // Add to settings
        if (!excludeInSettings) {
            var settings = document.getElementById('eCom_IntegrationCustomerCenter_settings');
            settings.value = settings.value + (settings.value.toString().length > 0 ? ',' : '') + name;
            hiddenSettingNames[settingName].push(name);
        }
    }

    function clearHidden(settingName) {
        // Clear the hidden inputs
        if (document.getElementById('Hiddens' + settingName))
            document.getElementById('Hiddens' + settingName).innerHTML = '';

        // Remove previously inserted settings
        var settings = $('eCom_IntegrationCustomerCenter_settings');
        var settingsValues = settings.value.split(',');
        var newSettings = '';
        for (var j = 0; j < settingsValues.length; j++) {
            var found = false;
            for (var i = 0; i < hiddenSettingNames[settingName].length; i++) {
                if (hiddenSettingNames[settingName][i] == settingsValues[j]) {
                    found = true;
                    break;
                }
            }
            if (!found)
                newSettings += (newSettings.length > 0 ? ',' : '') + settingsValues[j];
        }
        settings.value = newSettings;
        hiddenSettingNames[settingName].length = 0;
    }

    function createIcon(iconString, onclick, titleName) {
        var icon = document.createElement('i');
        icon.className = iconString;
        icon.alt = '';
        icon.onclick = new Function(onclick);
        icon.title = document.getElementById('Translate_' + titleName).innerHTML;
        return icon;
    }

    //Page functions
    function Page(name, type, menuName, tagName, listTemplate, itemTemplate, itemIdParameterName) {
        this.Name = name;
        this.Type = type;
        this.MenuName = menuName;
        this.TagName = tagName;
        this.ListTemplate = listTemplate;
        this.ItemTemplate = itemTemplate;
        this.ItemIdParameterName = itemIdParameterName;
    }

    function editPage(pageIndex) {
        var page = pages[pageIndex];
        document.getElementById('PageIndex').value = pageIndex;
        document.getElementById('PageName').value = page.Name;
        document.getElementById('PageName').disabled = isMainPage(page);
        document.getElementById('PageType').value = page.Type;
        document.getElementById('PageMenuName').value = page.MenuName;
        document.getElementById('PageTagName').value = page.TagName;
        document.getElementById('FM_PageListTemplate').value = page.ListTemplate;
        document.getElementById('FM_PageItemTemplate').value = page.ItemTemplate;
        document.getElementById('ItemIdParameterName').value = page.ItemIdParameterName;
        dialog.show('EditPageDialog');
    }

    function savePageEdit() {
        var page = pages[document.getElementById('PageIndex').value];
        page.Name = document.getElementById('PageName').value;
        page.Type = document.getElementById('PageType').value;
        page.MenuName = document.getElementById('PageMenuName').value;
        page.TagName = document.getElementById('PageTagName').value;
        page.ListTemplate = document.getElementById('FM_PageListTemplate').value;
        page.ItemTemplate = document.getElementById('FM_PageItemTemplate').value;
        page.ItemIdParameterName = document.getElementById('ItemIdParameterName').value;
        updatePages();
        dialog.hide('EditPageDialog');
    }

    function deletePage(pageIndex) {
        pages.splice(pageIndex, 1);
        updatePages();
        dialog.hide('EditPageDialog');
    }

    function addNewPage() {
        pages.push(new Page('', '', '', '', '', '', 'itemID'));
        updatePages();
        editPage(pages.length - 1);
    }

    function updatePages() {
        var table = document.getElementById('PagesTable');
        while (table.rows.length > 0)
            table.deleteRow(0);
        // Clear hidden values
        clearHidden('Pages');
        // Add each page
        for (var i = 0; i < pages.length; i++) {
            var page = pages[i];
            // Add to hidden save values
            addHidden('Pages', 'Page' + (i + 1) + 'Name', page.Name);
            addHidden('Pages', 'Page' + (i + 1) + 'Type', page.Type);
            addHidden('Pages', 'Page' + (i + 1) + 'MenuName', page.MenuName);
            addHidden('Pages', 'Page' + (i + 1) + 'TagName', page.TagName);
            addHidden('Pages', 'Page' + (i + 1) + 'ListTemplate', page.ListTemplate);
            addHidden('Pages', 'Page' + (i + 1) + 'ItemTemplate', page.ItemTemplate);
            addHidden('Pages', 'Page' + (i + 1) + 'ItemIdParameterName', page.ItemIdParameterName);
            // Add to table
            var row = table.insertRow(table.rows.length);
            var name = document.getElementById('Translate_No_PageName').innerHTML;
            if (page.Name.length > 0)
                name = page.Name;
            row.insertCell(row.cells.length).innerHTML = name;
            row.insertCell(row.cells.length).appendChild(createIcon('fa fa-pencil btn btn-flat m-l-5', 'editPage(' + i + ');', 'Edit'));
            if (!isMainPage(page)) {
                row.insertCell(row.cells.length).appendChild(createIcon('fa fa-remove color-danger btn btn-flat m-l-5', 'deletePage(' + i + ');', 'Delete'));
            }
        }
    }

    function isMainPage(page) {
        if (page != null && page.Name == '<%= Dynamicweb.eCommerce.Integration.CustomerCenter.Consts.MainPageName%>') {
            return true;
        }
        return false;
    }
    //End Page functions        

    var hiddenSettingNames = new Object;
    hiddenSettingNames.Pages = new Array();

    var pages = new Array();
    pages = eval(document.getElementById('PagesJSON').value);
    updatePages();

</script>
