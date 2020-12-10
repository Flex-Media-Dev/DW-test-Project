<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewRepository.aspx.vb" Inherits="Dynamicweb.Admin.Repositories.ViewRepository" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <script>
        document.addEventListener('readystatechange', () => Action && Action.showCurrentScreenLoader(document.readyState != 'complete', window));
        function help() {
		    <%=Gui.HelpPopup("repositories", "modules.repositories.repository")%>
        }
    </script>
</head>
<body class="area-black screen-container">
    <form id="MainForm" onsubmit="" runat="server">
        <div class="card">
            <dw:RibbonBar runat="server" ID="myribbon">
                <dw:RibbonBarTab Active="true" Name="Repository" runat="server">
                    <dw:RibbonBarGroup runat="server" ID="grpTools" Name="Tools">
                        <dw:RibbonBarButton runat="server" Text="Save" Size="Small" Icon="Save" KeyboardShortcut="ctrl+s" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Save and close" Size="Small" Icon="Save" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500" OnClientClick="closeRepositories();">
                        </dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Cancel" Size="Small" Icon="Cancel" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="closeRepositories();">
                        </dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup runat="server" ID="grpAdd" Name="Add">
                        <dw:RibbonBarButton runat="server" Text="Add Index" Size="Small" Icon="PlusSquare" ID="cmdNewIndex" OnClientClick="dialog.show('NewIndexDialog');"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Add Query" Size="Small" Icon="PlusSquare" ID="cmdNewQuery" OnClientClick="dialog.show('NewQueryDialog');"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Add Facets" Size="Small" Icon="PlusSquare" ID="cmdNewFacets" OnClientClick="dialog.show('NewFacetsDialog');"></dw:RibbonBarButton>
                        <dw:RibbonBarButton runat="server" Text="Add Task" Size="Small" Icon="PlusSquare" ID="cmdNewTask" OnClientClick="dialog.show('NewTaskDialog');"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="grpHelp" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="RibbonbarButton1" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="help();"></dw:RibbonBarButton>
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div id="breadcrumb">
                <a href="/Admin/Blank.aspx">Settings</a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#">Repositories</a> <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.AngleRight) %> breadcrumb-seperator"></i>
                <a href="#"><b><%=_repository.Name%></b></a>
            </div>

            <dw:StretchedContainer ID="OuterContainer" Scroll="Auto" Stretch="Fill" Anchor="document" runat="server">
                <dw:List runat="server" ID="lstRepositoryElements" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="" Width="16" />
                        <dw:ListColumn runat="server" Name="Name" Width="350" />
                        <dw:ListColumn runat="server" Name="Type" Width="100" />
                    </Columns>
                </dw:List>
            </dw:StretchedContainer>
        </div>

        <dw:Dialog runat="server" ID="NewIndexDialog" Size="Small">
            <dwc:GroupBox runat="server" ID="GroupBox1">
                <table>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Name")%></td>
                        <td>
                            <input type="text" name="indexName" id="newIndexName" value="" class="std" /><br />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="NewQueryDialog" Size="Small">
            <dwc:GroupBox runat="server" ID="GroupBox2">
                <table>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Name")%></td>
                        <td>
                            <input type="text" id="newQueryName" value="" class="std" />
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Data Source")%></td>
                        <td>
                            <%= SelectIndexDataSources()%>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="NewFacetsDialog" Size="Small">
            <dwc:GroupBox runat="server" ID="GroupBox3">
                <table>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Name")%></td>
                        <td>
                            <input type="text" id="newFacetsName" value="" class="std" /><br />
                        </td>
                    </tr>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Query")%></td>
                        <td>
                            <%= SelectQueryDataSources()%>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:Dialog runat="server" ID="NewTaskDialog" Size="Small">
            <dwc:GroupBox runat="server" ID="GroupBox4">
                <table>
                    <tr>
                        <td class="left-label"><%= Dynamicweb.SystemTools.Translate.Translate("Name")%></td>
                        <td>
                            <input type="text" name="taskName" id="newTaskName" value="" class="std" /><br />
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:ContextMenu ID="mnuContext" runat="server">
            <dw:ContextMenuButton Text="Open" Icon="File" OnClientClick="openItem(ContextMenu.callingItemID);" runat="server" />
            <dw:ContextMenuButton Text="Delete" Icon="Delete" OnClientClick="deleteItem(ContextMenu.callingItemID);" runat="server" />
        </dw:ContextMenu>
    </form>
    <dw:Overlay ID="ItemTypeEditOverlay" runat="server"></dw:Overlay>

    <%Translate.GetEditOnlineScript()%>
    <script type="text/javascript">        
        var repositoryName = "<%= _repository.Name%>";
        <% Dim serializer = New System.Web.Script.Serialization.JavaScriptSerializer() %>
        var queryNames = <%= serializer.Serialize(GetQueryNames()) %>;
        function addIndexOkAction() {
            var emptyNameText = "<%= Dynamicweb.SystemTools.Translate.Translate("The name of the index cannot be empty.")%>";

            var indexName = document.getElementById("newIndexName").value;
            if (indexName.length > 0) {
                location.href = "/Admin/Module/Repositories/ViewIndex.aspx?repository=" + repositoryName + "&new=true&item=" + indexName;
            }
            else {
                alert(emptyNameText);
            }
        }

        function addQueryOkAction() {
            var emptyNameText = "<%= Dynamicweb.SystemTools.Translate.Translate("The name of the query cannot be empty.")%>";
            var noDataSourceText = "<%= Dynamicweb.SystemTools.Translate.Translate("Data Source should be selected.")%>";
            var queryNameAlreadyExistsText = "<%= Dynamicweb.SystemTools.Translate.Translate("The query with this name already exists.")%>";

            var queryName = document.getElementById("newQueryName").value;
            var querySource = document.getElementById("newQuerySource").value;

            if (queryName.length == 0) {
                alert(emptyNameText);
                return;
            }

            var invalidQueryNameSymbols = <%= GetInvalidQueryNameSymbols() %>;
            var isNameHasWrongSymbols = false;
            for (var i = 0; !isNameHasWrongSymbols && i < invalidQueryNameSymbols.length; i++) {
                isNameHasWrongSymbols = queryName.indexOf(invalidQueryNameSymbols[i]) > -1;
            }
            if (isNameHasWrongSymbols) {
                var invalidQueryNameSymbolsLabel = invalidQueryNameSymbols.join("\x00").replace(/[^\x20-\x7E]+/g, ''); // remove non printable
                var invalidQueryName = "<%=Translate.JsTranslate("Only use valid characters in query name. Symbols %% are invalid.")%>".replace("%%",  invalidQueryNameSymbolsLabel);
                alert(invalidQueryName);
                return;
            }
            for (var i = 0; i < queryNames.length; i++) {
                if (queryNames[i] == queryName) {
                    alert(queryNameAlreadyExistsText);
                    return;
                }
            }
            if (querySource.length == 0) {
                alert(noDataSourceText);
                return;
            }
            location.href = "/Admin/Module/Repositories/ViewQuery.aspx?repository=" + repositoryName + "&new=true&item=" + queryName + "&source=" + querySource;
        }

        function addFacetsOkAction() {
            var emptyNameText = "<%= Dynamicweb.SystemTools.Translate.Translate("The name of the facets cannot be empty.")%>";
            var noQueryText = "<%= Dynamicweb.SystemTools.Translate.Translate("Query should be selected.")%>";

            var name = document.getElementById("newFacetsName").value;
            var query = document.getElementById("newFacetsQuery").value;

            if (name.length == 0) {
                alert(emptyNameText);
                return;
            }

            if (query.length == 0) {
                alert(noQueryText);
                return;
            }

            location.href = "/Admin/Module/Repositories/ViewFacets.aspx?repository=" + repositoryName + "&new=true&item=" + name + "&query=" + query;
        }

        function addTaskOkAction() {
            var emptyNameText = "<%= Dynamicweb.SystemTools.Translate.Translate("The name of the task cannot be empty.")%>";

            var indexName = document.getElementById("newTaskName").value;
            if (indexName.length > 0) {
                location.href = "/Admin/Module/Repositories/ViewTask.aspx?repository=" + repositoryName + "&new=true&item=" + indexName;
            }
            else {
                alert(emptyNameText);
            }
        }

        function openItem(idString) {
            var elements = idString.split("|");
            location.href = elements[2];
        }

        function deleteItem(idString) {
            var elements = idString.split("|");
            var deleteString = '<%=Translate.Translate("Delete")%>? ' + elements[1];

            if (confirm(deleteString))
                location.href = 'ViewRepository.aspx?CMD=delete&repository=' + elements[0] + "&item=" + encodeURIComponent(elements[1]);
        }

        function closeRepositories(){
            var ancestorsIds = ["Repositories"]; 
            dwGlobal.getSettingsNavigator().expandAncestors(ancestorsIds, null, true);
        }
    </script>
</body>
</html>
