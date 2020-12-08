<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConfigurationOptionsEdit.aspx.vb" Inherits="Dynamicweb.Admin.ConfigurationOptionsEdit" %>

<!DOCTYPE html>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<html>
<head id="Head1" runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <script type="text/javascript" src="metaEditor.js"></script>
    <style type="text/css">
        td:first-of-type
        {
            padding-left: 4px;
        }
     </style>
    <script type="text/javascript">
        function onAfterEditValue(input) {
            if (input) {
                input.value = input.value.replace(/^\s+|\s+$/g, ''); 
            }
        }

        function deleteField(link) {
            var row = dwGrid_gridFieldOptions.findContainingRow(link);
            if (row) {
                if (confirm('<%= Translate.JsTranslate("Do you want to delete this row?") %>')) {
                    dwGrid_gridFieldOptions.deleteRows([row]);
                }
            }
        }

        function save() {
            metaEditor.save();            
        }

        function help() {
		    <%=Gui.Help("filemanager", "modules.filemanager.metadata.metafields")%>
	    }

        <%= js.ToString()%>
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <input type="hidden" id="cmd" name="cmd" value="" />
    <input type="hidden" id="makeDefault" name="makeDefault" value="" />
    
    <dwc:GroupBox ID="OuterContainer" runat="server">
            <dw:EditableGrid runat="server" ID="gridFieldOptions" ClientIDMode="AutoID" 
            AllowAddingRows="true" AllowDeletingRows="true" AllowSortingRows="true" AutoGenerateColumns="false">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="fieldValue" onblur="onAfterEditValue(this);" CssClass="std fieldId" style="width: 100px;" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="fieldName" CssClass="std" style="width: 200px;" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox runat="server" ID="fieldDefault" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="20px" >
                        <ItemTemplate>
                            <span runat="server" id="fieldDelete">
                                <a href="javascript:void(0);" onclick="javascript:deleteField(this);" title="<%= Translate.Translate("Delete") %>">
                                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Times, True) %>"></i>
                                </a>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </dw:EditableGrid>
    </dwc:GroupBox>
    </form>
</body>
</html>
