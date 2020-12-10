<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BulkDataEditor.aspx.vb" EnableEventValidation="false" Inherits="Dynamicweb.Admin.BulkDataEditor" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bulk data editor</title>
    <dw:ControlResources IncludePrototype="true" IncludeScriptaculous="true" runat="server" CombineOutput="false">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function showModule(pageId, paragraphId) {
            var url = '/Admin/Content/ParagraphEditModule.aspx?ID=' + paragraphId + '&PageID=' + pageId + '&OnCompleteCallback=editModule&OnRemoveCallback=editModule';
            var wnd = window.open(url, 'EditModuleWnd', 'resizable=no,scrollbars=yes,toolbar=no,location=no,directories=no,status=yes,width=900,height=560,modal=yes');
            if (wnd) {
                wnd.focus();
            }
        }

        function editModule(paragraphId, moduleSystemName, moduleSettings) {
            setTimeout(function () {
                new Ajax.Request('/Admin/Content/FrontendEditing/FrontendEdit.aspx', {
                    method: 'post',
                    parameters: {
                        cmd: 'SetModuleSettings',
                        ID: paragraphId,
                        moduleName: moduleSystemName,
                        moduleSettings: moduleSettings
                    },
                    onComplete: function (response) {
                        location.href = location.href;
                    }
                });
            }, 150);

            return true;
        }

        function selectModules() {
            hideAll();
            document.getElementById('ModuleSettingsWrapper').style.display = 'block';
        }

        function selectTasks() {
            hideAll();
            document.getElementById('ScheduledTaskSettingsWrapper').style.display = 'block';
        }

        function hideAll() {
            document.getElementById('ModuleSettingsWrapper').style.display = 'none';
            document.getElementById('ScheduledTaskSettingsWrapper').style.display = 'none';
        }
        function showHideEmptyValues() {
            $('cmd').value = "ShowHideEmptyValues";
            __doPostBack();
        }

        function showHideEmptyTaskValues() {
            $('cmd').value = "ShowHideEmptyTaskValues";
            __doPostBack();
        }

        document.observe("dom:loaded", function () {
            $('SaveModuleSettings').removeClassName('disabled');
            $('SaveTasks').removeClassName('disabled');
        });
    </script>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server">
            <dw:RibbonBar ID="myRibbon" runat="server">
                <dw:RibbonBarTab ID="firstTab" Name="Modules" runat="server" OnClientClick="selectModules()">
                    <dw:RibbonBarGroup Name="Save" runat="server">
                        <dw:RibbonBarButton ID="SaveModuleSettings" EnableServerClick="true" Size="Large" Text="Save" Icon="Save" ShowWait="true" Disabled="true" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RG1" Name="Options" runat="server">
                        <dw:RibbonBarPanel runat="server" ExcludeMarginImage="true">
                            <dw:RibbonBarCheckbox runat="server" Size="Small" ID="ShowHideEmptyValues" RenderAs="FormControl" Text="Hide items with empty values" Checked="true" OnClientClick="showHideEmptyValues()"></dw:RibbonBarCheckbox>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RG2" Name="Filters" runat="server">
                        <dw:RibbonBarPanel runat="server" ExcludeMarginImage="true">
                            <div style="width: 350px;">
                                <div style="margin-bottom: 5px;">
                                    <div style="float: left; width: 60px; line-height: 20px;">
                                        <dw:TranslateLabel runat="server" Text="Module" />
                                    </div>
                                    <asp:DropDownList ID="AvailableModules" CssClass="std" AutoPostBack="True" runat="server" OnSelectedIndexChanged="ModulesFilter_Change"></asp:DropDownList><br />
                                </div>
                                <asp:PlaceHolder runat="server" ID="AreasWrapper">
                                    <div style="float: left; width: 60px; line-height: 20px;">
                                        <dw:TranslateLabel runat="server" Text="Area" />
                                    </div>
                                    <asp:DropDownList ID="AvailableAreas" CssClass="std" DataTextField="Value" DataValueField="Key" AutoPostBack="True" runat="server" OnSelectedIndexChanged="ModulesFilter_Change"></asp:DropDownList>
                                </asp:PlaceHolder>
                            </div>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>

                <dw:RibbonBarTab ID="ScheduledTasks" Name="Scheduled Tasks" runat="server" OnClientClick="selectTasks()">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Save" runat="server">
                        <dw:RibbonBarButton ID="SaveTasks" EnableServerClick="true" Size="Large" Text="Save" Icon="Save" ShowWait="true" Disabled="true" runat="server" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup2" Name="Options" runat="server">
                        <dw:RibbonBarPanel ID="RibbonBarPanel1" runat="server" ExcludeMarginImage="true">
                            <dw:RibbonBarCheckbox runat="server" Size="Small" ID="ShowHideEmptyTaskValues" RenderAs="FormControl" Text="Hide items with empty values" Checked="true" OnClientClick="showHideEmptyTaskValues()"></dw:RibbonBarCheckbox>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="Filters" runat="server">
                        <dw:RibbonBarPanel ID="RibbonBarPanel2" runat="server" ExcludeMarginImage="true">
                            <div style="width: 350px;">
                                <div style="margin-bottom: 5px;">
                                    <div style="float: left; width: 60px; line-height: 20px;">
                                        <dw:TranslateLabel runat="server" Text="Task" />
                                    </div>
                                    <asp:DropDownList ID="AvailableTasks" CssClass="std" DataTextField="Value" DataValueField="Key" AutoPostBack="True" runat="server" OnSelectedIndexChanged="ScheduledTaskFilter_Change"></asp:DropDownList><br />
                                </div>
                                <div style="margin-bottom: 5px;">
                                    <div style="float: left; width: 60px; line-height: 20px;">
                                        <dw:TranslateLabel runat="server" Text="Field" />
                                    </div>
                                    <asp:DropDownList ID="AvailableFields" CssClass="std" AutoPostBack="True" runat="server" OnSelectedIndexChanged="ScheduledTaskFilter_Change"></asp:DropDownList><br />
                                </div>
                            </div>
                        </dw:RibbonBarPanel>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <asp:HiddenField ID="cmd" runat="server" Value="" />

            <div id="ModuleSettingsWrapper" runat="server">
                <dw:List ID="ParagraphModuleSettings" ShowTitle="false" PageSize="1000" runat="server">
                    <Columns>
                        <dw:ListColumn EnableSorting="true" ID="AreaColumn" Name="Area" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="PageColumn" Name="Page" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="ParagraphColumn" Name="Paragraph" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="ModuleColumn" Name="App" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="FieldNameColumn" Name="Field name" runat="server" />
                        <dw:ListColumn EnableSorting="false" ID="FieldValueColumn" Name="Field value" Width="300" CssClass="p-t-5 p-b-5" runat="server" />
                        <dw:ListColumn EnableSorting="false" ID="ViewPageColumn" runat="server" />
                        <dw:ListColumn EnableSorting="false" ID="VievModuleColumn" runat="server" />
                    </Columns>
                </dw:List>
            </div>
            <div id="ScheduledTaskSettingsWrapper" runat="server">
                <dw:List ID="ScheduledTaskSettings" ShowTitle="false" PageSize="1000" runat="server">
                    <Columns>
                        <dw:ListColumn EnableSorting="true" ID="TaskIdColumn" Name="Task ID" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="TaskNameColumn" Name="Task name" runat="server" />
                        <dw:ListColumn EnableSorting="true" ID="TaskFieldNameColumn" Name="Field name" runat="server" />
                        <dw:ListColumn EnableSorting="false" ID="TaskFieldValueColumn" Name="Field value" Width="300" CssClass="p-t-5 p-b-5" runat="server" />
                    </Columns>
                </dw:List>
            </div>
        </form>
    </dwc:Card>
    <dwc:CardFooter runat="server"></dwc:CardFooter>
</body>
</html>
