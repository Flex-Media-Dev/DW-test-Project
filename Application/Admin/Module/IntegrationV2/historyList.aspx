<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="historyList.aspx.vb" Inherits="Dynamicweb.Admin.historyList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="uc" TagName="UCHistoryList" Src="~/Admin/Module/IntegrationV2/UCHistoryList.ascx" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">

    <script type="text/javascript">
        function GotoToList() {
            document.getElementById('opType').value = 'GotoToList';
            document.getElementById('historyListForm').submit();
        }
        function GotoToConfig() {
            document.getElementById('opType').value = 'GotoToConfig';
            document.getElementById('historyListForm').submit();
        }

        function SaveLastActive() {
            document.getElementById('tabActive').value = 1;
            SetActiveTab(1);
        }

        function SaveHistoryActive() {
            document.getElementById('tabActive').value = 2;
            SetActiveTab(2);
        }

        function SetActiveTab(activeID) {
            for (var i = 1; i < 15; i++) {
                if (document.getElementById("Tab" + i)) {
                    document.getElementById("Tab" + i).style.display = "none";
                }
                if (document.getElementById("Tab" + i + "_head")) {
                    document.getElementById("Tab" + i + "_head").className = "";
                }

            }
            if (document.getElementById("Tab" + activeID)) {
                document.getElementById("Tab" + activeID).style.display = "";
            }
            if (document.getElementById("Tab" + activeID + "_head")) {
                document.getElementById("Tab" + activeID + "_head").className = "activeitem";
            }
        }
    </script>

    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/DwSimple.min.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/DoMapping.css" type="text/css" />
    <style>
        .title {
            padding: 6px 16px;
            color: #616161;
        }

        .listRow td {
            max-width: initial !important;
        }
    </style>
</head>
<body>
    <div class="screen-container">
        <form id="historyListForm" runat="server">
            <dwc:Card ID="output" runat="server">                
                <uc:UCHistoryList runat="server" ID="HistoryListPlain" /> 
            </dwc:Card>
        </form>
    </div>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
