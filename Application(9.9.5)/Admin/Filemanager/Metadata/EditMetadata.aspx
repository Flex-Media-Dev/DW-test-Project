<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditMetadata.aspx.vb"
    Inherits="Dynamicweb.Admin.EditMetadata" %>

<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" />
    <style type="text/css">
        .editorsList
        {
            width: 100%;
        }
        
        .editorsList tr
        {
            vertical-align: top;
        }
        
        .editorsList tr td.col
        {
            width: 170px;
        }
    </style>
    <script type="text/javascript" src="metaEditor.js"></script>
    <script type="text/javascript">
     function help() {
		    <%=Dynamicweb.SystemTools.Gui.Help("filemanager", "modules.filemanager.metadata.edit")%>
	    }
        <%= js.ToString()%>
    </script>
</head>
<body>
    <dw:Infobar Message="" runat="server" Type="Information" Title="No write permissions" ID="noAccessWarning" Visible="False"></dw:Infobar>
    <form id="form1" runat="server">
    <input type="hidden" id="cmd" name="cmd" value="" />
    <div id="divToolbar">
        <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="Save" runat="server" Divide="None" Icon="Save" Text="Save"
                OnClientClick="metaEditor.save(false, false);">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="Save"
                Text="Save and close" OnClientClick="metaEditor.save();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton2" runat="server" Divide="None" Icon="TimesCircle"
                Text="Close" OnClientClick="metaEditor.close();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="ToolbarButton3" runat="server" Divide="None" Icon="Help" Text="Help"
                OnClientClick="help();">
            </dw:ToolbarButton>
        </dw:Toolbar>
    </div>
    <dw:GroupBox ID="GroupBoxFileProperties" runat="server" Title="Data" DoTranslation="true">
        <%  = EditorsOutput.ToString()%>
    </dw:GroupBox>
    </form>
</body>
</html>
