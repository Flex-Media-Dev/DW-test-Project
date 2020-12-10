<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ItemTypeEdit.aspx.vb" Inherits="Dynamicweb.Admin.ItemTypeEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Content.Items.Metadata" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources CombineOutput="false" IncludePrototype="true" IncludeScriptaculous="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/filemanager/filemanager_browse2.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/Default.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/ItemTypeEdit.js" />
            <dw:GenericResource Url="/Admin/Content/Items/js/ItemTypeEditGroupVisibilityRule.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/RulesEditor/RulesEditor.Model.js" />
            <dw:GenericResource Url="/Admin/Content/Items/css/Default.css" />
            <dw:GenericResource Url="/Admin/Content/Items/css/ItemTypeEdit.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.css" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Ajax.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        Event.observe(document, 'dom:loaded', function () {
            $('cmdUsage').toggleClassName('disabled');
            $('cmdName').toggleClassName('disabled');
            $('myribbon_collapseButton').on('click', function (event) {
                $('items').toggleClassName('colapsed-header');
            });
        });
    </script>
    <%= ConfigurableEditorAddin.Jscripts%>
</head>
<body class="screen-container">
    <form id="MainForm" onsubmit="return  Dynamicweb.Items.ItemTypeEdit.get_current().validateItem();" runat="server" style="overflow: hidden">
        <div class="card">
            <input type="hidden" id="Save" name="Save" value="" />
            <input type="hidden" id="Close" name="Close" value="" />
            <input type="hidden" id="Layout" name="Layout" value="" />
            <input type="hidden" id="AdvancedSettings" name="AdvancedSettings" value="" />
            <input type="hidden" class="editor-types-json" value='<%=RenderEditorTypes()%>' />
            <input type="hidden" id="CustomSmallIcon" value="" runat="server" />
            <input type="hidden" id="Inherits" value="" runat="server" />

            <div style="min-width: 1000px; overflow: hidden">
                <dw:RibbonBar runat="server" ID="myribbon">
                    <dw:RibbonBarTab Active="true" Name="Item type" runat="server">
                        <dw:RibbonBarGroup ID="itemGroup" runat="server" Name="Item type">
                            <dw:RibbonBarButton ID="cmdAddField" runat="server" Size="Small" Text="New field" Icon="PlusSquare" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().add_field();">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdAddGroup" runat="server" Size="Small" Text="New group" Icon="PlusSquare" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().add_group();">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="settingsGroup" runat="server" Name="Settings">
                            <dw:RibbonBarButton ID="cmdRestriction" runat="server" Size="Small" Text="Restrictions" Icon="key" OnClientClick="Dynamicweb.Items.ItemTypeEdit.showRestrictions();">
                            </dw:RibbonBarButton>
                            <dw:RibbonBarButton ID="cmdName" runat="server" Size="Small" Text="Settings" Icon="Gear" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().openGeneralSetting();" Disabled="True">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="usageGroup" runat="server" Name="Usage">
                            <dw:RibbonBarButton ID="cmdUsage" runat="server" Size="Small" Icon="AreaChart" OnClientClick="Dynamicweb.Items.ItemTypeEdit.show_usage();" Text="Item type usage" Disabled="True" />
                        </dw:RibbonBarGroup>
                        <dw:RibbonBarGroup ID="helpGroup" runat="server" Name="Help">
                            <dw:RibbonBarButton ID="cmdHelp" runat="server" Size="Large" Text="Help" Icon="Help" OnClientClick="Dynamicweb.Items.ItemTypeEdit.help();">
                            </dw:RibbonBarButton>
                        </dw:RibbonBarGroup>
                    </dw:RibbonBarTab>
                </dw:RibbonBar>
            </div>
            <div id="breadcrumb" runat="server"></div>
            <dw:Infobar ID="infoCodeFirst" runat="server" Type="Information" Message="This is CodeFirst item. Some properties are not editable" Visible="false" />
            <div class="list">
                <asp:Repeater runat="server" ID="groupsRepeater">
                    <HeaderTemplate>
                        <ul>
                            <li class="header">
                                <span class="C0 text-right">
                                    <dw:CheckBox runat="server" AttributesParm='onclick="Dynamicweb.Items.ItemTypeEdit.get_current().toggleAllSelected(this.checked);"' ID="toggleAllCheckbox" />
                                </span>
                                <span class="C1"><%=Translate.Translate("Name")%></span>
                                <span class="C2"><%=Translate.Translate("System name")%></span>
                                <span class="C3"><%=Translate.Translate("Type")%></span>
                                <span class="C4"><%=Translate.Translate("Inherited from")%></span>
                            </li>
                        </ul>
                        <div id="_contentWrapper" class="<%= If(IsCodeFirst, "source-code-first", "")%>">
                            <ul id="items">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li class="ContainerDummy">
                            <div class="Container" oncontextmenu="return ContextMenu.show(event, 'mnuGroups', this, '<%# DataBinder.Eval(Container.DataItem, "SystemName")%>');">
                                <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openGroupSettings(this);">
                                    <span class="icon">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Assignment, True)%> pull-left"></i>
                                    </span>
                                    <span class="group-name pull-left"><%# DataBinder.Eval(Container.DataItem, "Name")%></span>
                                </a>
                            </div>
                            <input type="hidden" class="group-system-name" value="<%# DataBinder.Eval(Container.DataItem, "SystemName")%>" />
                            <input type="hidden" class="group-collapsible" value="<%# CInt(DataBinder.Eval(Container.DataItem, "CollapsibleState")).ToString().ToLower()%>" />
                            <input type="hidden" class="group-visibility-field" value="<%# DataBinder.Eval(Container.DataItem, "VisibilityField")%>" />
                            <input type="hidden" class="group-visibility-condition" value="<%# DataBinder.Eval(Container.DataItem, "VisibilityCondition")%>" />
                            <input type="hidden" class="group-visibility-condition-value-type" value="<%# DataBinder.Eval(Container.DataItem, "VisibilityConditionValueType")%>" />
                            <input type="hidden" class="group-visibility-condition-value" value="<%# DataBinder.Eval(Container.DataItem, "VisibilityConditionValue")%>" />
                            <ul style="position: relative; min-height: 5px" id="fields_<%# DataBinder.Eval(Container.DataItem, "SystemName")%>">
                                <asp:Repeater ID="groupFieldsRepeater" runat="server" OnItemDataBound="groupFieldsRepeater_ItemDataBound">
                                    <ItemTemplate>
                                        <li class="item-field <%# If(String.Compare(DataBinder.Eval(Container.DataItem, "Parent"), Me.ItemType.SystemName, StringComparison.InvariantCultureIgnoreCase) = 0, "", "inherited")%>" style="position: relative;" oncontextmenu="return ContextMenu.show(event, 'mnuFields', this);">
                                            <span class="C0">
                                                <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);">
                                                    <span class="icon">
                                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.File, True)%>"></i>
                                                    </span>
                                                </a>
                                                <i runat="server" id="itemCheckbox"></i>
                                                <input type="hidden" class="field-advanced-settings" value="<%# GetFieldAdvancedSettings(CType(Container.DataItem, ItemField))%>" />
                                            </span>
                                            <span class="C1">
                                                <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);" title="<%# DataBinder.Eval(Container.DataItem, "Name")%>">
                                                    <span class="inner field-name"><%# DataBinder.Eval(Container.DataItem, "Name")%></span>
                                                </a>
                                            </span>
                                            <span class="C2">
                                                <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);" title="<%# DataBinder.Eval(Container.DataItem, "SystemName")%>">
                                                    <span class="inner field-system-name"><%# DataBinder.Eval(Container.DataItem, "SystemName")%></span>
                                                </a>
                                            </span>
                                            <span class="C3 field-editor-type">
                                                <%# GetFieldType(CType(Container.DataItem, ItemField))%>
                                            </span>
                                            <span class="C4">
                                                <%# GetInheritanceInfo(CType(Container.DataItem, ItemField))%>
                                            </span>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                        <div class="clearfix"></div>
                        <div style="padding: 15px; color: darkGray; position: relative;">
                            <dw:TranslateLabel ID="TranslateLabel6" Text="Hint: Drag rows to change the order of the fields." runat="server" />
                        </div>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <ul id="newGroupTemplate" style="display: none">
                    <li class="ContainerDummy" style="position: relative;">
                        <div class="Container" oncontextmenu="return ContextMenu.show(event, 'mnuGroups', this, '__NewGroupSystemName__');">
                            <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openGroupSettings(this);">
                                <span class="icon">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Assignment, True)%>"></i>
                                </span>
                                <span class="group-name">__NewGroup__</span>
                            </a>
                        </div>
                        <input type="hidden" class="group-system-name" value="__NewGroupSystemName__" />
                        <input type="hidden" class="group-collapsible" value="__NewGroupCollapsible__" />

                        <input type="hidden" class="group-visibility-field" value="__NewVisibilityField__" />
                        <input type="hidden" class="group-visibility-condition" value="__NewVisibilityCondition__" />
                        <input type="hidden" class="group-visibility-condition-value-type" value="__NewVisibilityConditionValueType__" />
                        <input type="hidden" class="group-visibility-condition-value" value="__NewVisibilityConditionValue__" />

                        <ul style="position: relative; min-height: 5px" id="fields___NewGroupSystemName__">
                        </ul>
                    </li>
                </ul>
                <ul id="newFieldTemplate" style="display: none">
                    <li class="item-field" style="position: relative;" oncontextmenu="return ContextMenu.show(event, 'mnuFields', this);">
                        <span class="C0">
                            <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);">
                                <span class="icon">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.File, True)%>"></i>
                                </span>
                            </a>
                            <dw:CheckBox runat="server" AttributesParm=" onclick='Dynamicweb.Items.ItemTypeEdit.get_current().handleCheckboxes(this);' " ID="newFieldCheckbox" />
                            <input type="hidden" class="field-advanced-settings" value="" />
                        </span>
                        <span class="C1">
                            <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);">
                                <span class="inner field-name"></span>
                            </a>
                        </span>
                        <span class="C2">
                            <a href="javascript:void(0);" onclick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(this);">
                                <span class="inner field-system-name"></span>
                            </a>
                        </span>
                        <span class="C3 field-editor-type"></span>
                    </li>
                </ul>
            </div>
            <div class="clearfix"></div>
        </div>

        <div id="BottomInformationBg" class="BottomInformation card-footer" runat="server">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td rowspan="2"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Cube, True) %> size-2x" alt="" onclick="pageProperties2();" class="h" id="icon"></i></td>
                    <td align="right">
                        <span class="label">
                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Navn" />
                            :</span>
                    </td>
                    <td width="150"><span id="_itemName" runat="server"></span></td>
                    <td align="right">
                        <span class="label">
                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Field count" />
                            :</span>
                    </td>
                    <td width="300"><span id="_fieldCount" runat="server"></span></td>
                    <td align="right"></td>
                    <td width="50%"></td>
                    <td></td>
                </tr>
                <tr>
                    <td align="right">
                        <span class="label">
                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="System name" />
                            :</span>
                    </td>
                    <td><span id="_systemName" runat="server"></span>
                    </td>
                    <td align="right"></td>
                    <td><span id="_dateCreated" runat="server"></span></td>
                    <td align="right"></td>
                    <td><span></span></td>
                </tr>
            </table>
        </div>

        <dw:Dialog ID="dlgFieldOptions" Title="Edit field options" HidePadding="true" OkAction="" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" runat="server">
            <iframe id="dlgFieldOptionsFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <dw:Dialog ID="dlgEditRestrictions" Title="Edit restrictions" Width="450" OkAction="Dynamicweb.Items.ItemTypeEdit.get_current().dialogER_Okaction();" ShowOkButton="true" ShowCancelButton="false" runat="server">
            <div class="restrictions-container">
                <dw:GroupBox ID="gbRestrictions" Title="Restrictions" runat="server"></dw:GroupBox>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog ID="dlgIconSettings" Title="Icon Settings" Size="Large" OkAction="Dynamicweb.Items.ItemTypeEdit.get_current().selectIcon();" ShowOkButton="true" ShowCancelButton="false" runat="server">
            <div class="filters">
                <div class="form-group">
                    <label class="control-label"><dw:TransLateLabel runat="server" Text="Color" /></label>
                    <select class="selectpicker" ID="IconColorSelect">
                        <asp:Repeater runat="server" ID="IconColorSelectItems">
                            <ItemTemplate>
                                <option value="<%#CType(Container.DataItem, Core.UI.KnownColor)%>" <%#If(CType(Container.DataItem, Core.UI.KnownColor) = ItemType.IconColor, "selected", "")%> class="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>"><%#CType(Container.DataItem, Core.UI.KnownColor).ToString()%></option>                            </ItemTemplate>
                        </asp:Repeater>
                    </select>
                </div>
                <dwc:InputText Label="Filter" ID="IconSearch" runat="server" />
            </div>
            <div class="icon-settings">
                <asp:Repeater runat="server" ID="IconsRepeater">
                    <ItemTemplate>
                        <div class="icon-block<%#if(CType(Container.DataItem, KnownIcon)=ItemType.Icon, " selected","")%>">
                            <i class="size-3x <%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True, ItemType.IconColor)%>" title="<%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True)%>"></i>
                            <span class="icon-block-label"><%#CType(Container.DataItem, KnownIcon).ToString()%></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog ID="dlgAdvanced" Title="Edit settings" Width="465" OkAction="Dynamicweb.Items.ItemTypeEdit.get_current().saveAdvancedSettings();" ShowOkButton="true" ShowCancelButton="true" runat="server">

            <input type="hidden" id="param-token" value="" />
            <input type="hidden" id="param-parent" value="" />
            <dw:Infobar runat="server" Message="dd" ID="InheritanceInfo" CssClass="hidden"></dw:Infobar>
            <div class="inheritance-info hidden">
            </div>
            <dw:GroupBox Title="General settings" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel Text="Name" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input type="text" class="std" id="param-name" onkeyup="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditFieldName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel Text="System name" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input type="text" class="std" id="param-systemname" onblur="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditSystemName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <label>
                                <dw:TranslateLabel Text="Description" runat="server" />
                            </label>
                        </td>
                        <td>
                            <textarea class="std" id="param-description" rows="5" cols="100"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel Text="Type" runat="server" />
                            </label>
                        </td>
                        <td>
                            <div class="input-group">
                                <div class="form-group-input">
                                    <select id="param-editortype" class="std form-control"></select>
                                </div>
                                <a href="javascript:void(0);" class="input-group-addon" id="edit-options-activator" title="<%=Translate.Translate("Edit field options")%>">
                                    <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Pencil, True)%>" title="<%=Translate.Translate("Edit field options")%>"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <div id="param-editor-configuration">
                <de:AddInSelector runat="server" ID="ConfigurableEditorAddin" AddInParameterWidth="auto" AddInShowSelector="false" AddInShowNothingSelected="false"
                    AddInGroupName="Configurable editor" AddInTypeName="Dynamicweb.Content.Items.Editors.Editor" AddInParameterName="Parameters" onafterUpdateSelection="Dynamicweb.Items.ItemTypeEdit.onEditorChanges()" />
            </div>
            <div class="separator-10">&nbsp;</div>
            <dw:GroupBox Title="Layout" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel Text="Group" runat="server" />
                            </label>
                        </td>
                        <td>
                            <select id="ddGroup" class="std" onchange="Dynamicweb.Items.ItemTypeEdit.get_current()._updatePositionList(this.value)">
                                <option value=""></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="ddPosition">
                                <dw:TranslateLabel Text="Position" runat="server" />
                            </label>
                        </td>
                        <td>
                            <select id="ddPosition" class="std" style="width: 50px">
                                <option value="1">1</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <div class="separator-10">&nbsp;</div>

            <div id="AdvDialog_DataSettings">
                <dw:GroupBox Title="Data" runat="server">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <label for="param-defaultvalue">
                                    <dw:TranslateLabel Text="Default value" runat="server" />
                                </label>
                            </td>
                            <td>
                                <div class="input-group">
                                    <div class="form-group-input">
                                        <input type="text" class="std form-control" id="param-defaultvalue" onblur="Dynamicweb.Items.ItemTypeEdit.get_current()._validateFieldDefaultValue();" />
                                    </div>
                                    <a href="javascript:void(0);" class="input-group-addon" id="validate-defaultvalue-activator" title="<%=Translate.Translate("Validate and update")%>">
                                        <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%>" title="<%=Translate.Translate("Validate and update")%>"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="paramExcludefromsearch">
                                    <dw:TranslateLabel Text="Do not search" runat="server" />
                                </label>
                            </td>
                            <td>
                                <dw:CheckBox runat="server" ID="paramExcludefromsearch" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>
            <div class="separator-10">&nbsp;</div>

            <div id="AdvDialog_ValidationSettings">
                <dw:GroupBox Title="Validation" runat="server">
                    <table border="0" class="formsTable">
                        <tr>
                            <td>
                                <label for="paramRequired">
                                    <dw:TranslateLabel Text="Required" runat="server" />
                                </label>
                            </td>
                            <td>
                                <dw:CheckBox runat="server" ID="paramRequired" OnClick="Dynamicweb.Items.ItemTypeEdit.get_current()._validateFieldDefaultValue();" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="param-validationexpression">
                                    <dw:TranslateLabel Text="Validation expression" runat="server" />
                                </label>
                            </td>
                            <td>
                                <div class="input-group">
                                    <div class="form-group-input">
                                        <input type="text" class="std form-control" id="param-validationexpression" />
                                    </div>
                                    <a href="javascript:void(0);" class="input-group-addon" id="insert-regex-activator" title="<%=Translate.Translate("Choose regular expression")%>">
                                        <i id="insert-regex-image" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Code, True)%>" title="<%=Translate.Translate("Choose regular expression")%>"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="param-errormessage">
                                    <dw:TranslateLabel Text="Error message" runat="server" />
                                </label>
                            </td>
                            <td>
                                <input type="text" class="std" id="param-errormessage" />
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </div>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog ID="dlgGeneralSettings" Title="Settings" Size="Medium" OkAction="Dynamicweb.Items.ItemTypeEdit.get_current().saveGeneralSettings();" ShowOkButton="true" ShowCancelButton="true" runat="server">
            <dw:GroupBox ID="GroupBox2" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel ID="TranslateLabel2" Text="Name" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input id="txName" type="text" class="std name" runat="server" onkeyup="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditItemName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel ID="TranslateLabel4" Text="System name" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input id="txSystemName" type="text" class="std system-name" runat="server" onblur="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditSystemName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel ID="lbDescription" Text="Description" runat="server" />
                            </label>
                        </td>
                        <td>
                            <textarea id="txDescription" class="std" runat="server" rows="5" cols="100" />
                        </td>
                    </tr>
                    <tr id="general-restrictions-row">
                        <td colspan="2">
                            <asp:Literal ID="GeneralRestrictions" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr id="pageViewSelectContainer">
                        <td>
                            <label>
                                <dw:TranslateLabel ID="TranslateLabel9" Text="Default view in page" runat="server" />
                            </label>
                        </td>
                        <td>
                            <select runat="server" id="pageViewSelect" class="std"></select>
                        </td>
                    </tr>
                    <tr id="paragraphViewSelectContainer">
                        <td>
                            <label>
                                <dw:TranslateLabel ID="TranslateLabel10" Text="Module in paragraph" runat="server" />
                            </label>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <div class="hintIcon">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle, True)%> hintImage"></i>
                            </div>
                            <div class="hintText hintTextСontainer">
                                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="The item type is not available until a selection is made" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 8px;" colspan="2"></td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="lbIcon" Text="Icon" runat="server" />
                        </td>
                        <td>
                            <i id="ItemTypeIcon" class="<%=KnownIconInfo.ClassNameFor(ItemType.Icon, True, ItemType.IconColor)%> size-3x" title="<%=KnownIconInfo.ClassNameFor(ItemType.Icon, True, ItemType.IconColor)%>"></i>                            
                            <input type="hidden" id="SmallIcon" name="SmallIcon" value="<%=ItemType.Icon.ToString()%>" />
                            <input type="hidden" id="IconColor" name="IconColor" value="<%=ItemType.IconColor%>" />
                            <dwc:Button runat="server" ID="EditIcon" OnClick="dialog.show('dlgIconSettings');" Title="Edit" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td class="p-b-20">
                            <div class="hintIcon">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle, True)%> hintImage"></i>
                            </div>
                            <div class="hintText hintTextСontainer">
                                <dw:TranslateLabel runat="server" Text="The icon is displayed in all places if set. The icon is not displayed when creating a new page or a new paragraph if Image is set." />
                            </div>
                        </td>
                    </tr>
                    <tr> 
                        <td>
                            <dw:TranslateLabel Text="Image" runat="server" />
                        </td>
                        <td>
                            <div id="imageContainer">
                                <dw:FileManager runat="server" ID="ItemImage" Folder="/images" Extensions="jpg,jpeg,bmp,gif,png,webp" Name="ItemImage" />   
                            </div>                           
                        </td>                      
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <div class="hintIcon">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle, True)%> hintImage"></i>
                            </div>
                            <div class="hintText hintTextСontainer">
                                <dw:TranslateLabel runat="server" Text="The image is displayed when creating a new page or a new paragraph and in Visual editor columns, but is not displayed anywhere else." />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Customized URLs" runat="server" />
                        </td>
                        <td>
                            <dw:CheckBox ID="cbIncludeInUrlIndex" Value="True" runat="server" CssClass="dlgChekboxCustomURLs" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>
                                <dw:TranslateLabel Text="Category" runat="server" />
                            </label>
                        </td>
                        <td>
                            <input type="text" class="std" id="txCategory" autocomplete="false" runat="server" />
                            <div id="txCategoryAutocompleteIndicator" class="autocomplete autocomplete-indicator" style="display: none">
                                <ul>
                                    <li><span><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%> fa-spin"></i></span></li>
                                </ul>
                            </div>
                            <div id="txCategoryAutocompleteMenu" class="autocomplete"></div>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <div class="hintIcon">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle, True)%> hintImage"></i>
                            </div>
                            <div class="hintText hintTextСontainer">
                                <dw:TranslateLabel runat="server" Text="Write path like this: 'folder/sub folder/etc' to create category" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="Use field for title" />
                        </td>
                        <td>
                            <select id="ddFieldForTitle" class="std"></select>
                            <input id="txFieldForTitle" type="hidden" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel8" Text="Title" runat="server" />
                        </td>
                        <td>
                            <input type="text" class="std" id="txTitle" autocomplete="false" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <div class="hintIcon">
                                <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.InfoCircle, True)%> hintImage"></i>
                            </div>
                            <div class="hintText hintTextСontainer">
                                <dw:TranslateLabel runat="server" Text="Define the title by adding parameters like this: {{FieldSystemName}}. When this field is in use then 'Use field for title' will be ignored." />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Inherited from" runat="server" />
                        </td>
                        <td>
                            <select id="txBase" class="std" onchange="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterSelectBase(this);" runat="server"></select>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <input type="hidden" id="SystemNameIsValid" />
            <input type="hidden" id="SystemNameOrigin" />
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog ID="dlgGroupSetting" Title="Group settings" Width="450" OkAction="Dynamicweb.Items.ItemTypeEdit.get_current().init_group();" ShowOkButton="true" ShowCancelButton="true" runat="server">
            <dw:GroupBox Title="Group settings" runat="server">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Name" runat="server" />
                        </td>
                        <td>
                            <input id="GroupName" type="text" class="std name" runat="server" onkeyup="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditGroupName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="System name" runat="server" />
                        </td>
                        <td>
                            <input id="GroupSystemName" type="text" class="std system-name" runat="server" onblur="Dynamicweb.Items.ItemTypeEdit.get_current().onAfterEditSystemName(this);" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Collapsible state" runat="server" />
                        </td>
                        <td>
                            <select id="GroupCollapsibleState" class="std">
                                <option value="0"><%=Translate.Translate("None")%></option>
                                <option value="1"><%=Translate.Translate("Collapsed")%></option>
                                <option value="2"><%=Translate.Translate("Expanded")%></option>
                            </select>
                        </td>
                    </tr>
                    <tr id="visibilitySettingsTab">
                        <td class="visibilitySettings">
                            <label>
                                <dw:TranslateLabel Text="Show only if" runat="server" />
                            </label>
                        </td>
                        <td>
                            <div id="GroupVisibilityField"></div>
                            <div id="GroupVisibilityCondition"></div>
                            <div id="GroupVisibilityConditionValue"></div>
                        </td>
                    </tr>
                </table>
            </dw:GroupBox>
            <div class="separator-10">&nbsp;</div>
        </dw:Dialog>

        <dw:Dialog ID="dlgRegularExpressions" Title="Regular expressions" Width="450" ShowOkButton="true" OkAction="Dynamicweb.Items.ItemTypeEdit.chooseRegexp()" ShowCancelButton="true" ShowClose="true" runat="server">
            <dwc:GroupBox Title="Choose regular expression" runat="server">
                <dwc:RadioGroup runat="server" ID="ChooseRegexp" Label="Expression">
                    <dwc:RadioButton runat="server" ID="regexp1" Label="Numbers" Info="^$|^[0-9]+" FieldValue="^$|^[0-9]+" />
                    <dwc:RadioButton runat="server" ID="regexp2" Label="Alpha-numeric characters" Info="^$|^[a-zA-Z0-9]+" FieldValue="^$|^[a-zA-Z0-9]+" />
                    <dwc:RadioButton runat="server" ID="RadioButton1" Label="Date (MM/DD/YYYY)" Info="^$|^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2}" FieldValue="^$|^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2}" />
                    <dwc:RadioButton runat="server" ID="RadioButton2" Label="Date (YYYY/MM/DD)" Info="^$|^(19|20)?[0-9]{2}[- /.](0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])" FieldValue="^$|^(19|20)?[0-9]{2}[- /.](0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])" />
                    <dwc:RadioButton runat="server" ID="RadioButton3" Label="Email (simplified)" Info="^$|^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" FieldValue="^$|^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" />
                    <dwc:RadioButton runat="server" ID="RadioButton4" Label="Password" Info="^$|^[a-z0-9_-]{6,18}" FieldValue="^$|^[a-z0-9_-]{6,18}" />
                </dwc:RadioGroup>
            </dwc:GroupBox>
        </dw:Dialog>

        <dw:ContextMenu ID="mnuGroups" runat="server" Translate="true">
            <dw:ContextMenuButton ID="btneditgroup" runat="server" DoTranslate="True" Text="Edit group" Icon="Pencil" Divide="After" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().openGroupSettings(ContextMenu.callingID);">
            </dw:ContextMenuButton>
            <dw:ContextMenuButton ID="btnaddfield" runat="server" DoTranslate="True" Text="New field" Icon="PlusSquare" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().add_field(ContextMenu.callingItemID);">
            </dw:ContextMenuButton>
        </dw:ContextMenu>

        <dw:ContextMenu ID="mnuFields" runat="server" Translate="true" OnClientSelectView="Dynamicweb.Items.ItemTypeEdit.onContextMenuView">
            <dw:ContextMenuButton ID="btnViewField" Views="readonly" runat="server" DoTranslate="True" Text="View field" Icon="File" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(ContextMenu.callingID);">
            </dw:ContextMenuButton>
            <dw:ContextMenuButton ID="btneditfield" Views="mixed,common" runat="server" DoTranslate="True" Text="Edit field" Icon="Pencil" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().openAdvancedSettings(ContextMenu.callingID);">
            </dw:ContextMenuButton>
            <dw:ContextMenuButton ID="btndelfield" Views="common" runat="server" DoTranslate="True" Text="Delete field" Icon="Delete" Divide="Before" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().deleteField(ContextMenu.callingID);">
            </dw:ContextMenuButton>
            <dw:ContextMenuButton ID="btnDeleteSelected" Views="mixed,selection" runat="server" DoTranslate="True" Text="Delete selected" Icon="Remove" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().deleteSelectedFields();" />
        </dw:ContextMenu>

        <dwc:ActionBar runat="server">
            <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" KeyboardShortcut="ctrl+s" ID="cmdSave" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().save();">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().save(true);">
            </dw:ToolbarButton>
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="Dynamicweb.Items.ItemTypeEdit.get_current().cancel();" ID="cmdCancel">
            </dw:ToolbarButton>
        </dwc:ActionBar>
    </form>
    <dw:Overlay ID="ItemTypeEditOverlay" runat="server"></dw:Overlay>

    <%Translate.GetEditOnlineScript()%>
</body>
</html>
