<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LogRetentionSettings.aspx.vb" Inherits="Dynamicweb.Admin.LogRetentionSettings" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <script src="/Admin/Images/Ribbon/UI/EditableGrid/EditableGrid.js"></script>
        <script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Ajax.js" type="text/javascript"></script>
    </dwc:ScriptLib>

    <script type="text/javascript">
        var tableColumnsRelation = [];
        (function ($) {
            Dynamicweb.LogSettings = {

                save: function (close) {
                    document.getElementById('Cmd').value = 'Save' + (close ? ',Close' : '');
                    document.getElementById('MainForm').submit();
                },

                cancel: function () {
                    location.href = '/Admin/Blank.aspx';
                },
            };

            $.expr[':'].valueCaseInsensitive = function (node, stackIndex, properties) {
                return $(node).val().toLowerCase().indexOf(properties[3].toLowerCase()) != -1;
            };

            var filterTables = function (e) {
                var searchText = $('#tablesSearch').val();
                if (searchText) {
                    $('#DatabaseTables tr:not(.header):not(.empty):not(.footer)').hide();
                    $('#DatabaseTables tr:not(.header):not(.empty):not(.footer):has(select[id$="Tables"]:valueCaseInsensitive("' + searchText + '"))').show();
                } else {
                    $('#DatabaseTables tr:not(.header):not(.empty):not(.footer)').show();
                }
            }

            var fillColumns = function (row, table) {
                var list = $(row).find("select[id$='Columns']").empty();
                $.each(tableColumnsRelation.filter(x => x.Key === table)[0].Value, function (index, column) {
                    list.append(new Option(column, column));
                });
                $(list).selectpicker('refresh');
            }

            var updateRow = function (row) {
                fillColumns(row.element, $(row.element).find("select[id$='Tables']").val());
                $(row.element).find("select[id$='Tables']").on('change', function () {
                    fillColumns(row.element, $(this).val());
                });
                $.each($(row.element).find(".selectpicker"),function (i,select) { $(select).selectpicker(); });
            }

            $(function () {
                $('#tablesSearch').on('keyup', filterTables);
                $('#tableFilter').on('click', filterTables);
                dwGrid_DatabaseTables.onRowAddedCompleted = updateRow;
                $("#DatabaseTables").find("select[id$='Tables']").on('change', function () {                    
                    fillColumns($(this).closest("tr[id^='DatabaseTables']"), $(this).val());
                });
            });
        })(jQuery);
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="Logs"></dwc:CardHeader>
            <dwc:CardBody runat="server">
                <form id="MainForm" runat="server">
                    <input type="hidden" id="Cmd" name="Cmd" value="" />
                    <dwc:GroupBox runat="server" Title="Settings">
                        <dwc:CheckBox runat="server" ID="PurgeEnabled" Label="Delete logs automatically" />
                    </dwc:GroupBox>
                    <%--
                    if (Converter.ToBoolean(SystemConfiguration.Instance.GetValue("/Globalsettings/Settings/Logging/FilesRetentionSettings/PurgeEnabled
                        --%>
                    <dwc:GroupBox runat="server" Title="File logs">
                        <dw:EditableGrid runat="server" ID="SelectedFolders" AllowAddingRows="true" AllowDeletingRows="true">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dw:FolderManager runat="server" ID="LogsFolder"></dw:FolderManager>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-CssClass="text-center" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle">
                                    <ItemTemplate>
                                        <dwc:CheckBox runat="server" Indent="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dwc:InputNumber runat="server" ID="Retention" Min="0" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="delete-button text-right p-5">
                                    <ItemTemplate>
                                        <a class="btn btn-link">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="dwGrid_SelectedFolders.deleteRows([dwGrid_SelectedFolders.findContainingRow(this)]);" ></i>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </dwc:GroupBox>
                    <dwc:GroupBox runat="server" Title="Database logs">                        
                        <dw:EditableGrid runat="server" ID="DatabaseTables" AllowAddingRows="true" AllowDeletingRows="true">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <dw:TranslateLabel runat="server"  Text="Table name"/>
                                        <div class="input-group" style="float: right;">
                                            <div class="form-group-input">                                                
                                                <input type="text" class="std  form-control" id="tablesSearch" style="font-weight: normal;" />                                                
                                            </div>
                                            <span class="input-group-addon" id="tableFilter">
                                                <i class="fa fa-search"></i>
                                            </span>
                                        </div>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <dwc:SelectPicker runat="server" ID="Tables"></dwc:SelectPicker>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dwc:SelectPicker runat="server" ID="Columns"></dwc:SelectPicker>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <dwc:InputNumber runat="server" ID="Retention" Min="0" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-CssClass="delete-button text-right p-5">
                                    <ItemTemplate>
                                        <a class="btn btn-link">
                                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="dwGrid_DatabaseTables.deleteRows([dwGrid_DatabaseTables.findContainingRow(this)]);" ></i>
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </dw:EditableGrid>
                    </dwc:GroupBox>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
        
    <dwc:ActionBar runat="server">
        <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Text="Save" OnClientClick="Dynamicweb.LogSettings.save();" ShowWait="True" />                
        <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Image="NoImage" Text="Save and close" OnClientClick="Dynamicweb.LogSettings.save(true);" ShowWait="True" />
        <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Image="NoImage" Text="Cancel" OnClientClick="Dynamicweb.LogSettings.cancel();" ShowWait="True" />
    </dwc:ActionBar>

</body>
</html>
