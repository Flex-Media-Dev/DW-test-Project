<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BulkEdit.aspx.vb" Inherits="Dynamicweb.Admin.BulkEdit" %>

<!DOCTYPE html>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript" src="metaEditor.js"></script>
    <script type="text/javascript" src="bulkEdit.js"></script>
    <style type="text/css">
        .hidden {
            display: none;
        }

        td.namecell {
            max-width: 170px;
            overflow-x: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        td.boxcell {
            width: 150px;
        }

            td.boxcell input {
                width: 150px;
            }
        
        td.listcell select {
            width: 100px;
        }

        td.linkmanagercell {
            min-width: 180px;
        }

            td.linkmanagercell input {
                width: 115px;
            }

        td.iconcell {
            width: 20px;
            white-space: nowrap;
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("filemanager", "modules.filemanager.metadata.bulkedit")%>
     }
        <%= js.ToString()%>
    </script>
</head>
<body>
    <dw:Infobar Message="" runat="server" Type="Information" Title="No write permissions" ID="noAccessWarning" Visible="False"></dw:Infobar>
    <form id="form1" runat="server">
        <input type="hidden" id="cmd" name="cmd" value="" />
        <input type="hidden" id="currentEdit" name="currentEdit" value="<% = Me.CurrentEditOutput %>" />
        <input type="hidden" id="summaryEdited" name="summaryEdited" value="<% = Me.SummaryEditedOutput %>" />
        <input type="hidden" id="selectedFiles" name="selectedFiles" value="" />
        <script type="text/javascript">
            if ("<%=HasSelectedFiles() %>" == "False" && parent) {
                if (parent.__page.GetSelectedFilesRow().length > 0) {
                    $("cmd").value = "doRebind";
                    $("selectedFiles").value = parent.__page.GetSelectedFilesRow();
                    window.document.forms[0].submit();
                }
            }
        </script>
        <dw:Infobar ID="nometadataInfo" Type="Warning" Message="No meta data fields have been created" Visible="false" runat="server"></dw:Infobar>
        <dw:GroupBox ID="OuterContainer" runat="server">
            <dw:EditableGrid ID="Edit1" runat="server" EnableViewState="true" OnRowDataBound="Edit1_OnRowDataBound"
                DraggableColumnsMode="First" AllowSorting="true" AllowSortingRows="true" EnableSmartNavigation="True"
                AllowAddingRows="false" AllowDeletingRows="false" AllowPaging="true">
                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="hidden" ItemStyle-CssClass="hidden">
                        <ItemTemplate>
                            <asp:Literal ID="js" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </dw:EditableGrid>
        </dw:GroupBox>
    </form>
</body>
</html>
