<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SystemFieldEdit.aspx.vb" Inherits="Dynamicweb.Admin.SystemFields.SystemFieldEdit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.eCommerce.UserPermissions" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>System fields</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    
    <script type="text/javascript" src="SystemField.js"></script>
    <script type="text/javascript" language="javascript">
        var txtSysNotUnique = '<%=Translate.JsTranslate("Some system names are not unique, missing or invalid. Make sure the name conforms to the naming convention.") %>';
        var helpLang = "<%=helpLang %>";
        var optionsDataTypeID = "<%=OptionsDataType.clientID %>";
        var typesWithOptions = <%=typesWithOptions %>;
        var optionRowValues = new Array;
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dw:Toolbar ID="SystemFieldToolbar" runat="server" ShowEnd="false">
            <dw:ToolbarButton ID="cmdSave" runat="server" Visible="false" Divide="None" Image="Save" Text="Save" OnClientClick="save();">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="Cancel" Text="Cancel" OnClientClick="cancel()">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="None" Image="Help" Text="Help" OnClientClick="help();">
            </dw:ToolbarButton>
        </dw:Toolbar>
        <h2 class="subtitle">
            <asp:Label ID="SystemFieldModule" runat="server" />
        </h2>
        
        <dw:GroupBox ID="GroupBox1" runat="server" Title="System Fields" DoTranslation="true">
            <table>
                <tr>
	                <td style="width: 600px; border: 1px solid #6593CF;">
                        <dw:EditableGrid ID="SystemFieldsList" Enabled="false" runat="server" EnableViewState="true" Width="592px" clientidmode="AutoID">
                            <Columns>
                                <asp:TemplateField ControlStyle-Width="195px" >
                                    <ItemTemplate>
                                        <asp:TextBox ID="SystemFieldName" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                        <asp:HiddenField runat="server" ID="SystemFieldSettings" Value="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-Width="195px" >
                                    <ItemTemplate>
                                        <asp:TextBox ID="SystemFieldSystemNameText" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                        <asp:HiddenField ID="SystemFieldSystemName" runat="server" Value="" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-Width="179px" >
                                    <ItemTemplate>
                                        <asp:DropDownList ID="SystemFieldTypeDrop" Visible="true" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                        <asp:TextBox ID="SystemFieldTypeText" Visible="false" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                        <asp:HiddenField ID="SystemFieldType" Value="" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
<%--                            
                                <asp:TemplateField ControlStyle-Width="17px">
                                    <ItemTemplate>
                                        <div id="buttons" style="visibility: hidden; width: 16px;">
                                            <img alt="<%=Translate.JsTranslate("Slet") %>" src="/Admin/images/Delete_small.gif" onclick="javascript:deleteSelectedRowFields(this);" style="cursor: pointer;" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
--%>
                            </Columns>
                        </dw:EditableGrid>
                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
    
    <div id="options" style="display: none;">
        <dw:GroupBox ID="GroupBox2" runat="server" Title="Options">
	        <table cellpadding="1" cellspacing="1">        
		        <tr>
			        <td width="170" style="vertical-align: top;">
				        <div style="display: inline;"><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Data type" /></div>
			        </td>
			        <td>
			            <asp:DropDownList runat="server" ID="OptionsDataType" CssClass="NewUIinput"></asp:DropDownList>
			        </td>
		        </tr>			    
                <tr>
	                <td style="width: 592px; border: 1px solid #6593CF;" colspan="2">
                        <dw:EditableGrid ID="SystemFieldOptions" Enabled="false" runat="server" EnableViewState="true" Width="592px" DraggableColumnsMode="First" EnableSmartNavigation="false" clientidmode="AutoID">
                            <Columns>
                                <asp:TemplateField ControlStyle-Width="19px" >
                                    <ItemTemplate>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-Width="275px" >
                                    <ItemTemplate>
                                        <asp:TextBox ID="SystemFieldOptionKey" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ControlStyle-Width="275px" >
                                    <ItemTemplate>
                                        <asp:TextBox ID="SystemFieldOptionValue" runat="server" CssClass="NewUIinput" style="margin-left: 2px;" />
                                    </ItemTemplate>
                                </asp:TemplateField>
<%--
                                <asp:TemplateField ControlStyle-Width="17px">
                                    <ItemTemplate>
                                        <div id="buttons" style="visibility: hidden; width: 16px;">
                                            <img alt="<%=Translate.JsTranslate("Slet") %>" src="/Admin/images/Delete_small.gif" onclick="javascript:deleteSelectedRowOptions();" style="cursor: pointer;" />
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
--%>
                            </Columns>
                        </dw:EditableGrid>

                    </td>
                </tr>
            </table>
        </dw:GroupBox>
    </div>
    
    <asp:HiddenField ID="DoSave" runat="server" Value="True" />
    <asp:HiddenField ID="TableName" runat="server" />
    <asp:HiddenField ID="ModuleName" runat="server" />
    <asp:HiddenField ID="RedirectUrl" runat="server" />
    </form>
    
    <script language="javascript" type="text/javascript">
        // Set the onCompleted events
        dwGrid_SystemFieldsList.onRowAddedCompleted = function (row) {
            $("options").hide();
            var nameBox = row.findControl("SystemFieldName");
            nameBox.focus();
        };
        dwGrid_SystemFieldOptions.onRowAddedCompleted = function (row) {
            var keyBox = row.findControl("SystemFieldOptionKey");
            keyBox.focus();

            var rowData;
            if (optionRowValues.length > 1) {
                rowData = optionRowValues[0];
                optionRowValues = optionRowValues.slice(1);
                dwGrid_SystemFieldOptions.addRow();
            } else if (optionRowValues.length = 1) {
                rowData = optionRowValues[0];
                optionRowValues = [];
            } else {
                return;
            }
            row.findControl("SystemFieldOptionKey").value = rowData[0];
            row.findControl("SystemFieldOptionValue").value = rowData[1];
        };
    </script>
</body>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>
