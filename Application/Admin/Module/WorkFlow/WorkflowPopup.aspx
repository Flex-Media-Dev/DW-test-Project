<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WorkflowPopup.aspx.vb" Inherits="Dynamicweb.Admin.WorkflowPopup" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Cache-control" content="no-cache" />
    <meta http-equiv="Cache-control" content="no-cache" />
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT" />
    <dw:ControlResources ID="ControlResources1" runat="server" />
    <script>
        function myPagesForApprovalSelected() {
            var rows = List.getSelectedRows("MyPagesForApprovalList");
            if (rows.length > 0) {
                $("MyPagesApproveButton").enable();
            }
            else {
                $("MyPagesApproveButton").disable();
            }
        }

        function pagesForApprovalByAdminSelected() {
            var rows = List.getSelectedRows("PagesForApprovalByAdminList");
            if (rows.length > 0) {
                $("NextStepBtn").enable();
                $("PublishBtn").enable();
            }
            else {
                $("NextStepBtn").disable();
                $("PublishBtn").disable();
            }
        }

        function approveSelectedPages(e, rows, publish) {
            var currentFrm = $(e.currentTarget).up("form");

            var publishEl = currentFrm.select(".publish")[0];
            publishEl.value = publish;

            var pagesEl = currentFrm.select(".selected-pages")[0];
            pagesEl.value = rows.map(function (el) { return el.attributes['itemid'].value; }).join(",");
            currentFrm.submit();
        }
        
        if (parent && '<%=Context.Request("DialogID")%>') {
            var container = parent.document.getElementById('DwDialog');
            if (container) {
                var okBtn = parent.dialog.get_okButton(container);
                if (okBtn) {
                    okBtn.style.display = 'none';
                }
                var cancelBtn = parent.dialog.get_cancelButton(container);
                if (cancelBtn) {
                    cancelBtn.style.display = 'none';
                }
            }
        }
    </script>
    <style>
        .btn-action {
            font-size: 20px;
        }
    </style>
</head>
<body class="screen-container">
    <div class="card">
        <form action="WorkflowApprove.aspx" method="get">
            <input type="hidden" class="publish" name="publish" value="false" />
            <input type="hidden" class="selected-pages" name="PageID" value="" />
            <dw:GroupBox runat="server" ID="MyPagesForApprovalGroupBox" Title="Pages awaiting approval">
                <dw:List runat="server" ID="MyPagesForApprovalList" AllowMultiSelect="true" ShowPaging="false" ShowTitle="false" ShowFooter="false" NoItemsMessage="Ingen sider til godkendelse" OnClientSelect="myPagesForApprovalSelected();">
                    <Columns>
                        <dw:ListColumn ID="colPageName" EnableSorting="false" Name="Side" runat="server" />
                        <dw:ListColumn ID="colModifiedDate" EnableSorting="false" Name="Redigeret" Width="250" runat="server" />
                        <dw:ListColumn ID="colModifiedBy" EnableSorting="false" Name="Hvem" Width="150" runat="server" />
                    </Columns>
                </dw:List>
                <p runat="server" id="MyPagesForApprovalCommands" visible="false">
                    <dwc:Button runat="server" ID="MyPagesApproveButton" Title="Godkend" OnClick="approveSelectedPages(event, List.getSelectedRows('MyPagesForApprovalList'), false);" Disabled="true" />
                </p>
            </dw:GroupBox>
        </form>
        <form action="WorkflowApprove.aspx" method="get">
            <input type="hidden" class="publish" name="publish" value="false" />
            <input type="hidden" class="selected-pages" name="PageID" value="" />
            <dw:GroupBox runat="server" ID="PagesForApprovalByAdminGroupBox" Title="Procedureadministration" Visible="false">
                <dw:List runat="server" ID="PagesForApprovalByAdminList" AllowMultiSelect="true" ShowPaging="false" ShowTitle="false" ShowFooter="false" NoItemsMessage="Ingen aktive procedurer"  OnClientSelect="pagesForApprovalByAdminSelected();" >
                    <Columns>
                        <dw:ListColumn ID="ListColumn1" EnableSorting="false" Name="Procedure" Width="150" runat="server" />
                        <dw:ListColumn ID="ListColumn2" EnableSorting="false" Name="Trin" Width="58" runat="server" />
                        <dw:ListColumn ID="ListColumn3" EnableSorting="false" Name="Afventer" Width="100" runat="server" />
                        <dw:ListColumn ID="ListColumn4" EnableSorting="false" Name="Side" runat="server" />
                        <dw:ListColumn ID="ListColumn5" EnableSorting="false" Name="Redigeret" Width="150" runat="server" />
                        <dw:ListColumn ID="ListColumn6" EnableSorting="false" Name="Hvem" Width="150" runat="server" />
                    </Columns>
                </dw:List>
                <p runat="server" id="PagesForApprovalByAdminCommands" visible="false">
                    <dwc:Button runat="server" ID="NextStepBtn" Title="Næste trin" OnClick="approveSelectedPages(event, List.getSelectedRows('PagesForApprovalByAdminList'), false);"  Disabled="true" />
                    <dwc:Button runat="server" ID="PublishBtn" Title="Strakspublicer" OnClick="approveSelectedPages(event, List.getSelectedRows('PagesForApprovalByAdminList'), true);"  Disabled="true" />
                </p>
            </dw:GroupBox>
        </form>
    </div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
