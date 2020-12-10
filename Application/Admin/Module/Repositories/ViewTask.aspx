<%@ Page Language="vb" AutoEventWireup="false" EnableEventValidation="false" CodeBehind="ViewTask.aspx.vb" Inherits="Dynamicweb.Admin.ViewTask" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <script>
        function help() {
		    <%=Gui.HelpPopup("repositories", "modules.repositories.task")%>
        }
    </script>
</head>
<body class="area-black screen-container">
    <form id="MainForm" onsubmit="" runat="server">

        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Repository" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="grpTools" Name="Tools">
                        <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" KeyboardShortcut="ctrl+s" ID="cmdSave" OnClientClick="save();" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save" ID="cmdSaveAndClose" OnClientClick="saveAndClose();" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="Cancel" ID="cmdCancel" OnClientClick="cancel();" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="grpHelp" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="breadcrumb">
                <a href="/Admin/Blank.aspx">Management</a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#">Repositories</a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="/Admin/Module/Repositories/ViewRepository.aspx?id=<%=RepositoryId%>"><%=RepositoryId%></a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><b><%= ItemId%></b></a>
            </div>

            <dwc:GroupBox ID="grpTask" runat="server" Title="Task">
                <table class="formsTable">
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Start time" />
                        </td>
                        <td>
                            <dw:DateSelector ID="dateStartTime" AllowNeverExpire="True" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="End time" />
                        </td>
                        <td>
                            <dw:DateSelector ID="dateEndTime" AllowNeverExpire="True" ValidationMessage="" runat="server" />
                            <div class="form-group">
                                <div class="form-group-input">
                                    <small id="helpdateEndTime" class="help-block error"></small>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Repeat interval (minutes)" />
                        </td>
                        <td>
                            <asp:DropDownList ID="repeatInterval" runat="server" CssClass="std" /></td>
                    </tr>
                    <tr>
                        <td class="leftColHigh">
                            <dw:TranslateLabel runat="server" Text="Type" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTypes" runat="server" CssClass="std" onchange="showParameters();" /></td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="grpTypeParameters" runat="server" Title="Type parameters">
                <div id="IndexBuilderParameters">
                    <table class="formsTable">
                        <tr>
                            <td class="leftColHigh">
                                <dw:TranslateLabel runat="server" Text="Index" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlIndexes" runat="server" CssClass="std" onchange="getBuilds();" />
                            </td>
                        </tr>
                        <tr>
                            <td class="leftColHigh">
                                <dw:TranslateLabel runat="server" Text="Build" />
                            </td>
                            <td id="buildsContainer">
                                <asp:DropDownList ID="ddlBuilds" runat="server" ClientIDMode="Static" CssClass="std" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="CustomProviderParameters">
                    <dw:TranslateLabel runat="server" Text="A custom provider type is selected. The user interface does not currently support these." />
                    <br />
                    <dw:TranslateLabel runat="server" Text="Please edit the task directly in the file." />
                </div>
            </dwc:GroupBox>

            <input type="hidden" name="repository" value="<%=RepositoryId%>" />
            <input type="hidden" name="item" value="<%=ItemId%>" />
            <input type="hidden" name="save" id="save" value="" />
            <input type="hidden" name="close" id="close" value="" />
        </div>
    </form>
    <dw:Overlay ID="ItemTypeEditOverlay" runat="server"></dw:Overlay>

    <%Translate.GetEditOnlineScript()%>
</body>

<script type="text/javascript">
    const EndDateLessBeginDateMessage = "<%=Translate.JsTranslate("End date must be grater than begin date")%>";

    function showParameters() {
        var typesSelector = $("<%=TypesSelector%>");
        var selectedValue = typesSelector[typesSelector.selectedIndex].value;

        if (selectedValue === "<%=IndexBuilderType%>") {
                $("IndexBuilderParameters").show();
                $("CustomProviderParameters").hide();
            } else {
                $("IndexBuilderParameters").hide();
                $("CustomProviderParameters").show();
            }
        }

        function getBuilds() {
            var indexSelector = $("<%=IndexSelector%>");
            var selectedValue = indexSelector[indexSelector.selectedIndex].value;
            var url = "ViewTask.aspx?cmd=GetBuilds&repository=<%=RepositoryId%>&index=" + selectedValue;

            new Ajax.Request(url, {
                method: 'get',
                onSuccess: function (response) {
                    $("buildsContainer").innerHTML = response.responseText;
                }
            });
        }

        function cancel() {
            location.href = "ViewRepository.aspx?id=<%=RepositoryId%>";
        }

        function isValid() {
            let result = true;
            dwGlobal.hideAllControlsErrors(null, "");
            let datepicker = Dynamicweb.UIControls.DatePicker.get_current();
            if (datepicker) {
                let startDate = datepicker.GetDate("dateStartTime");
                if (startDate) {
                    let endDate = datepicker.GetDate("dateEndTime");
                    if (endDate) {
                        if (endDate < startDate) {
                            dwGlobal.showControlErrors("helpdateEndTime", EndDateLessBeginDateMessage);
                            result = false;
                        }
                    }
                }
            }
            return result;
        }

        function save(close) {
            if (isValid()) {
                $("save").value = "true";
                $("close").value = close ? "true" : "";
                document.forms["MainForm"].submit();
            }
            return false;
        }

        function saveAndClose() {
            return save(true);
        }

        //getBuilds();
        showParameters();
</script>
</html>
