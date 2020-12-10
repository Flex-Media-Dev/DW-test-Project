<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditSmartSearch.aspx.vb" Inherits="Dynamicweb.Admin.EditSmartSearch" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ssc" Assembly="Dynamicweb.Admin" Namespace="Dynamicweb.Admin.SmartSearchControls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <!-- Default ScriptLib-->
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Ajax.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/Ribbon.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Observable.js" type="text/javascript"></script>
        <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
        <script src="/Admin/Link.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/SmartSearches/js/SmartSearchRulesEditor.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/SmartSearches/js/SmartSearchRulesEditor.Model.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/SmartSearches/js/EditSmartSearch.js" type="text/javascript"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        var id = <%= Converter.ToInt32(Dynamicweb.Context.Current.Request("ID"))%>;
        var cmd = '<%= Converter.ToString(Dynamicweb.Context.Current.Request("CMD"))%>';
        
        function getContentFrame() {
            return $('ContentFrame') || parent.$('ContentFrame');
        }

        Event.observe(document, 'dom:loaded', function () {
            WaterMark.create(document.getElementById('<%= tbTopRows.ClientID %>'), '<%= StringHelper.JsEnable(Translate.JsTranslate("All"))%>');
        });

        function onKeyPress(evt) {
            var theEvent = evt || window.event;
            var key = theEvent.keyCode || theEvent.which;

            if (key != 35 && key != 36 && key != 37 && key != 38 && key != 39 && key != 40 && key != 46 && key != 8) {
                key = String.fromCharCode(key);
                var regex = /[0-9]|\./;
                if (!regex.test(key)) {
                    theEvent.returnValue = false;
                    if (theEvent.preventDefault) theEvent.preventDefault();
                }
            }
        };     

    </script>

    <style>
        #SelectIndexDialog .boxbody {
            overflow: inherit;
        }

        #SelectIndexDialog .dropdown-menu {
            z-index: 0;
        }
        .align-by-row {
            margin-top: 5px;
        }
    </style>
</head>
<body class="area-blue" style="background-color: #fff">
    <dw:RibbonBar ID="Ribbon" runat="server">
        <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Smart Search">
            <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Rules">
                <dw:RibbonBarRadioButton OnClientClick="onGroupSelected(2);" ID="cmdAll_must_apply" Text="All must apply" runat="server" Size="Small" Icon="Brightness1" />
                <dw:RibbonBarRadioButton OnClientClick="onGroupSelected(1);" ID="cmdAny_must_apply" Text="Any must apply" runat="server" Size="Small" Icon="Brightness2" />
                <dw:RibbonBarRadioButton OnClientClick="onUngroupSelected();" ID="cmdUngroup" Text="Ungroup" runat="server" Size="Small" Icon="Brightness3" />
                <dw:RibbonBarRadioButton OnClientClick="onRemoveSelected();" ID="cmdRemove_selected" Text="Remove selected" runat="server" Size="Small" Icon="Delete" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonbarGroupPreview" runat="server" Name="Show">
                <dw:RibbonBarButton OnClientClick="onPreview();" ID="cmd_Preview" Text="Preview" runat="server" Size="Large" Icon="OpenInNew" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonbarGroupHelp" runat="server" Name="Help">
                <dw:RibbonBarButton OnClientClick="onHelp();" ID="cmd_help" Text="Help" runat="server" Size="Large" Icon="Help" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>
    <dwc:Card runat="server">
        <dwc:CardBody runat="server">
            <form id="viewForm" runat="server" method="post">
                <dwc:GroupBox ID="GroupBox3" runat="server" DoTranslation="true" Title="Configure search">
                    <dwc:InputText ID="txtName" Label="Name" runat="server" />

                    <div class="form-group">
                        <dw:TranslateLabel ID="lbDataProvider" Text="Data provider" runat="server" UseLabel="True" />
                        <b>
                            <dw:TranslateLabel ID="lbDataProviderType" runat="server" />
                        </b>
                    </div>

                    <div class="form-group">
                        <dw:TranslateLabel ID="TranslateLabel1" Text="Edit rules" runat="server" UseLabel="True" />
                        <ssc:SmartSearchRulesEditor runat="server" ID="_EditRules" Height="320" />
                    </div>

                    <dwc:InputText ID="tbTopRows" Label="Rows to fetch" MaxLength="15" onkeypress="onKeyPress();" runat="server" />

                    <dwc:SelectPicker ID="primarySortColumn" runat="server" Label="Select by (primary)"></dwc:SelectPicker>
                    <dwc:SelectPicker ID="primarySortType" runat="server" Label="&nbsp;" DoTranslate="false"></dwc:SelectPicker>

                    <dwc:SelectPicker ID="secondarySortColumn" runat="server" Label="Select by (secondary)" ></dwc:SelectPicker>
                    <dwc:SelectPicker ID="secondarySortType" runat="server" Label="&nbsp;" DoTranslate="false"></dwc:SelectPicker>
                </dwc:GroupBox>

                <iframe src="about:blank" id="ContentSaveFrame" name="ContentSaveFrame" height="0" style="height: 0px; width: 0px;"></iframe>
            </form>
        </dwc:CardBody>
    </dwc:Card>

    <dwc:ActionBar runat="server">
        <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Text="Gem" OnClientClick="onSave();" />
        <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Text="Gem og luk" OnClientClick="onSaveAndClose();" />
        <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Annuller" OnClientClick="onCancel();" />
    </dwc:ActionBar>

    <dw:ContextMenu runat="server" ID="lstTasksContextMenu">
        <dw:ContextMenuButton runat="server" ID="addInLogButton" Text="Log" Icon="InfoCircle">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True"></dw:Overlay>
</body>

<%Translate.GetEditOnlineScript()%>
</html>
