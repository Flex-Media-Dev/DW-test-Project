<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ListSubmits.aspx.vb" Inherits="Dynamicweb.Admin.ListSubmits" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="false" runat="server" />
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            if (List.getSelectedRows('list').length > 0) {
                Toolbar.setButtonIsDisabled('cmdDelete', false);
            } 
        });

        function help() {
		    <%=Gui.HelpPopup("", "modules.basicforms.listsubmits")%>
		}

        function back() {
            overlayShow();
            location = "ListForms.aspx";
        }

        function editsubmit(submitid) {
            if (!submitid) {
                var submitid = ContextMenu.callingID;
            }
            overlayShow();
            location = "EditSubmit.aspx?ID=" + submitid;
        }

        function exportData(format, withHeaders) {
            overlayShow();
            location = "ListSubmits.aspx?action=" + format + "&headers=" + withHeaders + "&formId=" + document.getElementById("formId").value;
            setTimeout(overlayHide, 1000);
        }

        function deleteSubmit(callingId) {
            var submitId = callingId || ContextMenu.callingID;
            if (submitId) {
                var submitName = document.getElementById("submitname" + submitId).innerHTML;
                if (confirm("<%=Translate.JsTranslate("Slet %%?", "%%", Translate.JsTranslate("submit"))%> (" + submitName + ")")) {
                    overlayShow();

                    submitFormValues({
                        "action": "delete",
                        "ID": submitId
                    });
                }
            }
        }

        function deleteSelectedSubmits() {
            var selectedRows = List.getSelectedRows('list');
            if (selectedRows.length == 1) {
                deleteSubmit(selectedRows[0].readAttribute("itemid"));
            } else {
                let msg = "<%=Translate.JsTranslate("Delete selected submits?") %>";
                let len = selectedRows.length;
                if (len > 100) {
                    len = 100;
                    msg = "<%=Translate.JsTranslate("It's not possible to delete more than 100 records at a time.") %>";
                }

                if (confirm(msg)) {
                    var ids = '';
                    for (var i = 0; i < len; i++) {
                        ids += selectedRows[i].readAttribute("itemid") + ",";
                    }

                    overlayShow();

                    submitFormValues({
                        "action": "delete",
                        "ID": ids
                    });
                }
            }
        }

        function submitFormValues(data) {
            var form = document.forms[0];
            for (var key in data) {
                var el = document.getElementById(key);
                if (!el) {
                    var input = document.createElement("input");
                    input.setAttribute("type", "hidden");
                    input.name = key;
                    form.appendChild(input);
                    el = input;
                }
                el.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
            }

            form.submit();
        }

        function submitSelected() {
            if (List.getSelectedRows('list').length > 0) {
                Toolbar.setButtonIsDisabled('cmdDelete', false);
            } else {
                Toolbar.setButtonIsDisabled('cmdDelete', true);
            }
        }
        
        function overlayHide() {
            hideOverlay('wait');
        }

        function overlayShow() {
            showOverlay('wait');
        }
    </script>
</head>
<body class="screen-container">
    <div class="card">
        <div class="card-header">
             <h2 class="subtitle">
                <dw:TranslateLabel ID="lbSetup" Text="Formularer" runat="server" />
                &#187; <span id="breadcrumbText" runat="server"></span>
                &#187;
                <dw:TranslateLabel ID="TranslateLabel1" Text="Submits" runat="server" />
                <span runat="server" id="submitcount"></span>
            </h2>
        </div>

        <form id="form1" runat="server">
            <input type="hidden" name="formId" id="formId" runat="server" />
            <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Divide="None" Icon="TimesCircle" Text="Luk" OnClientClick="back();" />
                <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="FileExelO" Text="Export to excel" OnClientClick="exportData('export', true);" />
                <dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="FileTextO" Text="Export to csv" OnClientClick="exportData('exportcsv', true);" />
                <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="None" Icon="Remove" Text="Delete" OnClientClick="deleteSelectedSubmits();" Disabled="true" />
                <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="help();" />
            </dw:Toolbar>
            
            <dw:List ID="list" ShowPaging="false" PageSize="1000" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" AllowMultiSelect="true" OnClientSelect="submitSelected();" runat="server">
                <Columns>
                    <dw:ListColumn ID="colId" Name="ID" Width="20" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colDate" Name="Dato" Width="60" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colPageId" Name="PageId" Width="60" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colUserName" Name="UserName" Width="120" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colReferer" Name="Referer" Width="120" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colValues" Name="Data" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colFields" Name="Fields" Width="60" runat="server" ItemAlign="Center" HeaderAlign="Center" EnableSorting="true" />
                    <dw:ListColumn ID="colIp" Name="IP" Width="120" runat="server" EnableSorting="true" />
                    <dw:ListColumn ID="colSession" Name="Session" Width="120" runat="server" EnableSorting="true" />
                </Columns>
            </dw:List>
        </form>
    </div>

    <dw:ContextMenu ID="submitContext" runat="server">        
        <dw:ContextMenuButton ID="deleteFieldBtn" runat="server" Text="Slet" Icon="Delete" OnClientClick="deleteSubmit();" Divide="None" />
    </dw:ContextMenu>
    <dw:Overlay ID="wait" runat="server"></dw:Overlay>
    <%  
        Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</body>
</html>
