<%@ Page Language="vb" AutoEventWireup="false" EnableEventValidation="false" ValidateRequest="false" CodeBehind="FormOptionsGrid.aspx.vb" Inherits="Dynamicweb.Admin.FormOptionsGrid" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin.DataManagement" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
        div.sorting-hint {
            color: #8c8c8c;
            padding: 10px;
            height: 16px;
        }
    </style>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="style/EditableGrid.css" />
            <dw:GenericResource Url="style/EditForm.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var dwGrid_optionsGrid = new EditableGrid('optionsGrid', 'optionsGrid');
    </script>

    <script type="text/javascript">
        var rowId = <%=rowId %>;
        
        function init() {
            if (rowId > -1) {
                var options = parent.getOptions(rowId);
                
                $("Keys").value = options.Keys;
                $("Values").value = options.Values;
                
                document.getElementById('Form1').action = "FormOptionsGrid.aspx?getOptions=False";
                document.getElementById('Form1').submit();
            }

            // Set the onCompleted event
            dwGrid_optionsGrid.onRowAddedCompleted = function(row) {
                var labelBox = row.findControl("oKey");
                labelBox.focus();
            };
            
            dwGrid_optionsGrid.onRowsDeletedCompleted = function(rows) {
                processOptions();
            };
        }

        function deleteOption(obj) {
            var row = dwGrid_optionsGrid.findContainingRow(obj);
            dwGrid_optionsGrid.deleteRows([row]);
        }
    
        function processOptions() {
            var rows = dwGrid_optionsGrid.rows.getAll();
            var rowsValidate = true;
            
            for (var i = 0; i < rows.length; i++) {
                var key = rows[i].findControl("oKey");
                var value = rows[i].findControl("oValue");
                
                if (key.value.indexOf("|") != -1 || value.value.indexOf("|") != -1) {
                    rowsValidate = false;
                }
            }

            if (rowsValidate) {
                parent.handleOptions(rows);
            } else { 
                alert('<%=Translate.JsTranslate("Some labels have not been set or Label/Value contains a '|' character.") %>'); 
        }
    }
        
    function HandleKeyDown(e, obj) {
        // Check if [TAB] or [ENTER] was pressed
        if (!e.shiftKey && (e.keyCode == 9 || e.keyCode == 13)) {
            var allRows = dwGrid_optionsGrid.rows.getAll();
            var lastRow = allRows[allRows.length - 1];
            var thisRow = dwGrid_optionsGrid.findContainingRow(obj);
                
            var isLastRow = (thisRow.ID == lastRow.ID);
                
            if (isLastRow) {
                dwGrid_optionsGrid.addRow();
            }
        }
    }

    function handleRowSelected(obj) {
        row = dwGrid_optionsGrid.findContainingRow(obj);
        if (row) {
            try {
                var rows = dwGrid_optionsGrid.rows.getAll();
                for (var i = 0; i < rows.length; i++) {
                    var currentRow = rows[i];
                    if (currentRow.isSelected) {
                        currentRow.findControl('removeButtons').style.visibility = "visible";
                    } else {
                        currentRow.findControl('removeButtons').style.visibility = "hidden";
                    }
                }
            } catch (e) {
                console.log(e.message);
            }
        }
    }
    </script>
</head>
<body class="edit" onload="init();">
    <form id="Form1" runat="server">
        <asp:HiddenField ID="Keys" runat="server" />
        <asp:HiddenField ID="Values" runat="server" />
        <div>
            <dw:EditableGrid ID="optionsGrid" AllowAddingRows="true" AllowDeletingRows="true" AllowSortingRows="true" runat="server" EnableViewState="true" OnRowDataBound="optionsGrid_OnRowDataBound" DraggableColumnsMode="First" EnableSmartNavigation="false">
                <Columns>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="20px">
                        <ItemTemplate>
                            <!--draggable area-->
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="150px">
                        <ItemTemplate>
                            <asp:TextBox ID="oKey" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="150px">
                        <ItemTemplate>
                            <asp:TextBox ID="oValue" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="16px">
                        <ItemTemplate>
                            <div id="removeButtons" style="visibility: hidden; width: 16px;">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>" onclick="javascript:deleteOption(this);" title="<%=Translate.JsTranslate("Slet") %>"></i>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="70px" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <span style="width: 100%;" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <span style="width: 98%;"></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </dw:EditableGrid>
            <div class="sorting-hint">
                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle) %>"></i>
                <dw:TranslateLabel ID="lbSorting" Text="Hint: you can change options order by dragging rows in the list." runat="server" />
            </div>
        </div>
    </form>
</body>
</html>
<%  
    Translate.GetEditOnlineScript()
%>
