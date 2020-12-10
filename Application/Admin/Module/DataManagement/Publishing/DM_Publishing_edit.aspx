<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DM_Publishing_edit.aspx.vb" Inherits="Dynamicweb.Admin.DataManagement.DM_Publishing_edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<dw:ControlResources ID="cr1" runat="server" IncludePrototype="true" />

<dw:ModuleHeader ID="headerModule" runat="server" ModuleSystemName="DM_Publishing" />
<input type="hidden" name="DM_Publishing_settings" value="ViewID,ShowDetails,ShowHeadings,SortableColumns,IncludeTime,ListFieldsValue,DetailFieldsValue,PubListTemplate,PubDetailTemplate,TemplateType,FormsPage,ShowNewRow,EditThisRow,PagingSetting" />

<script type="text/javascript" src="/Admin/Filemanager/FileManager_browse2.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/images/AjaxAddInParameters.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/images/ObjectSelector.js"></script>
<link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/images/DateSelector.js"></script>

<script type="text/javascript">
    var viewId = <%=viewId %>;

    function showTemplate(radio) {
        var layoutContainer = $("LayoutPlaceholder");
        var templateContainer = $("TemplatesPlaceholder");

        if (radio.id == "TemplateTypeDefault") {
            layoutContainer.show();
            templateContainer.hide();
            dd_ListLayoutSelector.fireEvent("SelectedIndexChanged", null);
            dd_DetailLayoutSelector.fireEvent("SelectedIndexChanged", null);
        }else{
            layoutContainer.hide();
            templateContainer.show();
            $("FM_ListTemplateSelector").onchange(); //This onchange function handles both List and Detail selectors
        }
    }
    
    function getFields() {
        SelectionBox.getListItems("/Admin/Module/DataManagement/Publishing/DM_Publishing_edit.aspx?AJAXCMD=FILL_FIELDS&viewId=" + viewId, "ListFields");
        SelectionBox.getListItems("/Admin/Module/DataManagement/Publishing/DM_Publishing_edit.aspx?AJAXCMD=FILL_FIELDS&viewId=" + viewId, "DetailFields");
    }
    
    function toggleDetailField(chkBox) {
        if (chkBox.checked) {
            $('detailContainer').show();
        }else{
            $('detailContainer').hide();
        }
    }
    
    function changeView() {
        viewId = $("ViewID").value;
        getFields();
        
        if ($("TemplateTypeDefault").checked) {
            showTemplate($("TemplateTypeDefault"));
        }else{
            showTemplate($("TemplateTypeCustom"));
        }
    }
    
    function serializeListFields() {
        var fields = SelectionBox.getElementsRightAsArray("ListFields");
        $("ListFieldsValue").value = fields.toString();
    }
    
    function serializeDetailFields() {
        var fields = SelectionBox.getElementsRightAsArray("DetailFields");
        $("DetailFieldsValue").value = fields.toString();
    }
    
    function ajaxLoader(url,divId) {

        new Ajax.Updater(divId, url, {
            asynchronous: true, 
            evalScripts: true,
            method: 'get',
            
            onSuccess: function(request) {
                $(divId).update(request.responseText);
            }
        } );
    }
    
    function showLayoutListPreview(obj) {
        $("LayoutListPreview").src = obj.value.gsub(".css", ".gif");
    }
    
    function showLayoutDetailsPreview(obj) {
        $("LayoutDetailsPreview").src = obj.value.gsub(".css", ".gif");
    }

    function layoutDataExchange(sender, args) {
        var img = args.dataDestination.select("img")[0];
        var span = args.dataDestination.select("span")[0];
        img.src = args.dataSource.select("img")[0].src;
        span.innerHTML = args.dataSource.select("span")[0].innerHTML;
    }
    
    function fmOnChange() {
        $("PubListTemplate").value = $("FM_ListTemplateSelector").value;
        $("PubDetailTemplate").value = $("FM_DetailTemplateSelector").value;
    }
</script>

<dw:GroupBox DoTranslation="true" runat="server" Title="Publish datalist">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Data list" />
            </td>
            <td>
                <asp:Literal runat="server" ID="ViewSelector" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
    
<dw:GroupBox DoTranslation="true" runat="server" Title="Edit data" ID="editData">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Forms page" />
            </td>
            <td>
                <%=Gui.LinkManager(_prop.Value("FormsPage"), "FormsPage", String.Empty)%>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="ShowNewRow" runat="server" FieldName="ShowNewRow" Label="Display 'add row' link" /> (<dw:TranslateLabel runat="server" Text="Only works with views created using 'Design mode'" />)
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox ID="EditThisRow" runat="server" FieldName="EditThisRow" Label="Display 'edit row' link" /> (<dw:TranslateLabel runat="server" Text="Only works with views created using 'Design mode'" />)
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox ID="GroupBox1" DoTranslation="true" runat="server" Title="Layout">
    <input type="hidden" id="PubListTemplate" name="PubListTemplate" value="" />
    <input type="hidden" id="PubDetailTemplate" name="PubDetailTemplate" value="" />
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Choose layout" />
            </td>
            <td>
                <input type="radio" name="TemplateType" id="TemplateTypeDefault" onclick="showTemplate(this);" value="Default" runat="server" /><%=Translate.Translate("Default layouts")%><br />
                <input type="radio" name="TemplateType" id="TemplateTypeCustom" onclick="showTemplate(this);" value="Custom" runat="server" /><%=Translate.Translate("Custom layouts")%><br />
            </td>
        </tr>
        <tr id="LayoutPlaceholder">
            <td colspan="2">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="List template" />
                        </td>
                        <td>
                            <dw:TemplatedDropDownList ID="ListLayoutSelector" Width="200" Height="32" runat="server">
                                <BoxTemplate>
                                    <div style="height: 32px;">
                                        <img src="<%#Eval("ImagePath") %>" height="28" width="28" border="0" style="float: left; margin-right: 5px; margin-bottom: 2px; margin-top: 2px; margin-left: 2px;" alt="" /><span style="line-height: 32px; display: block; float: left;"><%#Eval("FileName")%></span>
                                    </div>
                                </BoxTemplate>
                                <ItemTemplate>
                                    <div style="height: 47px;">
                                        <img src="<%#Eval("ImagePath") %>" height="43" width="47" border="0" style="float: left; margin-right: 5px; margin-bottom: 2px; margin-top: 2px; margin-left: 2px;" alt="" /><span style="line-height: 48px; display: block; float: left;"><%#Eval("FileName")%></span>
                                    </div>
                                    <input type="hidden" id="ListLayout" name="ListLayout" value="<%#Eval("FilePath") %>" />
                                </ItemTemplate>
                            </dw:TemplatedDropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Details template" />
                        </td>
                        <td>
                            <dw:TemplatedDropDownList ID="DetailLayoutSelector" Width="200" Height="32" runat="server">
                                <BoxTemplate>
                                    <div style="height: 32px;">
                                        <img src="<%#Eval("ImagePath") %>" height="28" width="28" border="0" style="float: left; margin-right: 5px; margin-bottom: 2px; margin-top: 2px; margin-left: 2px;" alt="" /><span style="line-height: 32px; display: block; float: left;"><%#Eval("FileName")%></span>
                                    </div>
                                </BoxTemplate>
                                <ItemTemplate>
                                    <div style="height: 47px;">
                                        <img src="<%#Eval("ImagePath") %>" height="43" width="47" border="0" style="float: left; margin-right: 5px; margin-bottom: 2px; margin-top: 2px; margin-left: 2px;" alt="" /><span style="line-height: 48px; display: block; float: left;"><%#Eval("FileName")%></span>
                                    </div>
                                    <input type="hidden" id="ListLayout" name="ListLayout" value="<%#Eval("FilePath") %>" />
                                </ItemTemplate>
                            </dw:TemplatedDropDownList>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr id="TemplatesPlaceholder" style="display: none;">
            <td colspan="2">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="List template" />
                        </td>
                        <td>
                            <dw:FileManager ID="ListTemplateSelector" Folder="/Templates/DataManagement/Publishings/Custom/" Extensions="html,xslt,cshtml" FullPath="true" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Details template" />
                        </td>
                        <td>
                            <dw:FileManager ID="DetailTemplateSelector" Folder="/Templates/DataManagement/Publishings/Custom/" Extensions="html,xslt,cshtml" FullPath="true" runat="server" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</dw:GroupBox>
    
<dw:GroupBox DoTranslation="true" runat="server" Title="Publishing options">
    <table class="formsTable">
        <tr>
            <td></td>
            <td>
                <dw:Checkbox FieldName="ShowDetails" ID="ShowDetails" AttributesParm="onclick='toggleDetailField(this);'" value="true" runat="server" Label="Show link to detail view" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:Checkbox FieldName="ShowHeadings" ID="ShowHeadings" value="true" runat="server" Label="Show headings" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:Checkbox FieldName="SortableColumns" ID="SortableColumns" value="true" runat="server" Label="Sortable columns" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:Checkbox FieldName="IncludeTime" ID="IncludeTime" value="true" runat="server" Label="Show time in datetime columns" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
    
<dw:GroupBox DoTranslation="true" runat="server" Title="List data">
    <table>
        <tr>
            <td>
                <dw:SelectionBox ID="ListFields" runat="server" />
                <input type="hidden" name="ListFieldsValue" id="ListFieldsValue" value="" runat="server" />
            </td>
        </tr>
    </table>
</dw:GroupBox>
    
<div id="detailContainer" style="display: none;">
    <dw:GroupBox DoTranslation="true" runat="server" Title="Detail data">
        <table>
            <tr>
                <td>
                    <dw:SelectionBox ID="DetailFields" runat="server" />
                    <input type="hidden" name="DetailFieldsValue" id="DetailFieldsValue" value="" runat="server" />
                </td>
            </tr>
        </table>
    </dw:GroupBox>
</div>
    
<dw:PagingSettings ID="PagingSetting" runat="server" />

<script language="javascript" type="text/javascript">
    if ($("ShowDetails").checked) {
        $("detailContainer").style.display = "block";
    }

    funcList = function() {
        var selectedItem = dd_ListLayoutSelector.get_selectedItem();
        var elementArr = selectedItem.select("input");
        if (elementArr != null && elementArr.length > 0) {
            var pathElement = elementArr[0];
            $("PubListTemplate").value = pathElement.value;
        }
    }
    dd_ListLayoutSelector.add_selectedIndexChanged(funcList);
    dd_ListLayoutSelector.add_dataExchange(layoutDataExchange);

    funcDetail = function() {
        var selectedItem = dd_DetailLayoutSelector.get_selectedItem();
        var elementArr = selectedItem.select("input");
        if (elementArr != null && elementArr.length > 0) {
            var pathElement = elementArr[0];
            $("PubDetailTemplate").value = pathElement.value;
        }
    }
    dd_DetailLayoutSelector.add_selectedIndexChanged(funcDetail);
    dd_DetailLayoutSelector.add_dataExchange(layoutDataExchange);
            
    $("FM_ListTemplateSelector").onchange = fmOnChange;
    $("FM_DetailTemplateSelector").onchange = fmOnChange;

    if ($("TemplateTypeDefault").checked) {
        $("TemplateTypeDefault").onclick();
    }else{
        $("TemplateTypeCustom").onclick();
    }
    
    SelectionBox.setNoDataLeft("ListFields");
    SelectionBox.setNoDataRight("ListFields");
    SelectionBox.setNoDataLeft("DetailFields");
    SelectionBox.setNoDataRight("DetailFields");
    
    var myTextField = document.getElementById('Link_FormsPage');
	if(myTextField != null)
    {
        $("Link_FormsPage").observe('change', function() {
         if ($F("FormsPage") === '') {
                $("ShowNewRow").checked = false;
                $("ShowNewRow").disabled = true;
                $("EditThisRow").checked = false;
                $("EditThisRow").disabled = true;
            } else {
                $("ShowNewRow").disabled = false;
                $("EditThisRow").disabled = false;
        }
    });
    }
</script>
