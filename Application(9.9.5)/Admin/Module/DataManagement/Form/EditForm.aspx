<%@ Page Language="vb" AutoEventWireup="false" EnableEventValidation="false" ValidateRequest="false" CodeBehind="EditForm.aspx.vb" Inherits="Dynamicweb.Admin.DataManagement.EditForm" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin.DataManagement" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server">
        <Items>
            <dw:GenericResource Url="style/EditFormLF.css" />
            <dw:GenericResource Url="style/EditableGrid.css" />
            <dw:GenericResource Url="style/EditForm.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var formId= <%= _id %>;
        var cmd= "<%= _cmd%>";
        var hasOptions = [<%=hasOptions %>];
        var textFieldTypeCode = <%=textFieldTypeCode %>;
        var checkboxTypeCode = <%=checkboxTypeCode %>;
        var radioTypeCode = <%=radioTypeCode %>;
        var textAreaTypeCode = <%=textAreaTypeCode %>;
        var radioNoneSelectedText = "<%=radioNoneSelectedText %>";
        var isEdit = <%=isEdit %>;
        var isView = "<%=isViewBased %>" == "True" ? true : false;
        var helpLang = "<%=helpLang %>";
        
        var txtWidth = '<%=Translate.JsTranslate("Width") %>';
        var txtHeight = '<%=Translate.JsTranslate("Height") %>';
        var txtColumns = '<%=Translate.JsTranslate("Columns") %>';
        var txtRows = '<%=Translate.JsTranslate("Rows") %>';

        var txtNoName = '<%=Translate.JsTranslate("You need to enter a form name.") %>';
        var txtSysNotUnique = '<%=Translate.JsTranslate("Some system names are not unique, missing or invalid. Make sure the name conforms to the naming convention.") %>';
        var txtNoTableName = '<%=Translate.JsTranslate("You need to enter a table name.") %>';
        var txtTableExists = '<%=Translate.JsTranslate("The table already exists. Use the `Create form from table` functionality instead.") %>';
        var txtCreateFailed = '<%=Translate.JsTranslate("The table could not be created. Please try again. Maybe the name does not comform to the naming convention.") %>';
        var txtNoOptionsOnNewType1 = '<%=Translate.JsTranslate("The previous field type allowed you to add field options but the one you have chosen now does not.") %>';
        var txtNoOptionsOnNewType2 = '<%=Translate.JsTranslate("Click 'OK' to change the field to the new type. The previous selected field options will be deleted when the form is saved.") %>';
        var txtNoOptionsOnNewType3 = '<%=Translate.JsTranslate("Click 'Cancel' to change the field to the previous field type.") %>';
    </script>
</head>
<body class="screen-container" onload="doInit();">
    <form id="Form1" runat="server">

        <dw:RibbonBar ID="Ribbon" runat="server">
            <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Form">
                <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Funktioner">
                    <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();"
                        ID="RibbonbarButton2" />
                    <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save"
                        OnClientClick="saveAndClose();" ID="RibbonbarButton3" />
                    <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();"
                        ID="RibbonbarButton4" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="Settings">
                    <dw:RibbonBarButton ID="btnSettings" runat="server" Size="Small" Text="Settings"
                        Icon="cog" OnClientClick="openSettings();" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Help">
                    <dw:RibbonBarButton ID="RibbonbarButton6" runat="server" Text="Help" Icon="Help"
                        Size="Large" OnClientClick="help();" />
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>

        <div id="content">
            <div class="formEditContent">
                <div id="FieldsList">
                    <dw:EditableGrid ID="formFields" runat="server" EnableViewState="true" AllowAddingRows="true"
                        AllowDeletingRows="true" AllowSortingRows="true" OnRowDataBound="formFields_OnRowDataBound" DraggableColumnsMode="First" EnableSmartNavigation="false">
                        <Columns>
                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="20px">
                                <ItemTemplate>
                                    <!--dragable area-->
                                    <asp:HiddenField ID="fID" runat="server" />
                                    <asp:HiddenField ID="fSettings" runat="server" />
                                    <asp:HiddenField ID="fOptions" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-Width="150px">
                                <ItemTemplate>
                                    <asp:TextBox ID="fLabel" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width="150px">
                                <ItemTemplate>
                                    <asp:TextBox ID="fSystemname" MaxLength="255" CssClass="NewUIinput" runat="server"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:DropDownList ID="fTypes" runat="server" CssClass="NewUIinput">
                                    </asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width="70px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <dw:CheckBox ID="fRequired" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:TextBox ID="fDescription" Width="100%" CssClass="NewUIinput" runat="server"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-Width="16px">
                                <ItemTemplate>
                                    <div id="buttons" style="visibility: hidden; width: 16px;">
                                        <i class="<%=Core.UI.Icons.KnownIconInfo.ClassNameFor(Core.UI.Icons.KnownIcon.Close) %>" onclick="javascript:deleteThisRow(this);"></i>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>
                </div>
            </div>
        </div>

        <div id="FieldSettings" class="formFieldSettings formHiddenArea">
            <dw:TabControl runat="server" ID="Tabcontrol1" width="100%" TranslateTabs="true">
                <dw:TabPage ID="TabGeneral" Title="General" runat="server">
                    <div class="formSettingsDiv">
                        <table id="settingsTable" class="formSettingsTable formsTable">
                            <tbody>
                                <tr>
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Data type" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <div id="ddlTypes">
                                            <asp:DropDownList ID="dataTypes" runat="server" CssClass="NewUIinput" />
                                        </div>
                                        <span id="dataType"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Default value" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <select id="defaultValueSelector" name="defaultValueSelector" class="NewUIinput" runat="server" style="display: none" onchange="setDefaultValue(this);"></select>
                                        <input id="defaultValue" name="defaultValue" type="text" maxlength="255" class="formFieldInput NewUIinput" value="" />
                                    </td>
                                </tr>
                                <tr id="optionSourceTypeRow" style="display: block;">
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Option source type" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="optionSourceType" onchange="changeOptionSourceType(this);" CssClass="NewUIinput" runat="server" />
                                    </td>
                                </tr>
                                <tr id="maxLengthRow" style="display: block;">
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Max. length" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <input id="maxLength" name="maxLength" type="text" maxlength="255" class="formFieldInput NewUIinput" value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;" id="widthContainer">
                                            <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Width" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <input id='fieldWidth' name='fieldWidth' type="text" maxlength="255" class="formFieldInput NewUIinput" value='' onclick="checkInput(this);" onblur="checkOutput(this);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;" id="heightContainer">
                                            <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Height" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <input id='fieldHeight' name='fieldHeight' type="text" maxlength="255" class="formFieldInput NewUIinput" value='' onclick="checkInput(this);" onblur="checkOutput(this);" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel runat="server" Text="Validation value" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <input id="validationValue" name="validationValue" type="text" class="formFieldInput NewUIinput" value="" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="formLeftLabel"></td>
                                    <td>
                                        <dw:CheckBox ID="fieldActive" FieldName="fieldActive" Value="true" runat="server" />
                                    </td>
                                </tr>
                                <tr id="setCheckedTR" style="display: none;">
                                    <td class="formLeftLabel">
                                        <div class="nobr" style="vertical-align: text-top;">
                                            <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Default selection" />
                                            &nbsp;
                                        </div>
                                    </td>
                                    <td>
                                        <select id='fieldSetChecked' name='fieldSetChecked' runat="server" class="NewUIinput">
                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </dw:TabPage>
                <dw:TabPage ID="TabOptions" Title="Options" runat="server">
                    <div id="options">
                        <iframe id="optionsFrame" name="optionsFrame" height="100%" width="100%"></iframe>
                    </div>
                    <div id="optionSource">
                        <dwc:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="Configure list data source">
                            <table class="formsTable">
                                <tr>
                                    <td>
                                        <div class="nobr">
                                            <dw:TranslateLabel runat="server" Text="List" />
                                        </div>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="listDataSources" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="nobr" style="margin-top: 5px;">
                                            <dw:TranslateLabel runat="server" Text="Key field" />
                                        </div>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="keyField" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="nobr">
                                            <dw:TranslateLabel runat="server" Text="Value field" />
                                        </div>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="valueField" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </dwc:GroupBox>
                    </div>
                </dw:TabPage>
            </dw:TabControl>
        </div>

        <dw:Dialog ID="Settings" runat="server" Title="Settings" ShowOkButton="true" ShowClose="false" OkAction="updateGrid();"
            Width="450" ShowCancelButton="true" CancelAction="cancelSettings();">
            <dwc:GroupBox ID="GroupBox4" runat="server" DoTranslation="true" Title="Indstillinger">
                <table>
                    <tr>
                        <td width="170">
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel" runat="server" Text="Name" />
                            </div>
                        </td>
                        <td>
                            <input type="text" name="Name" id="Name" runat="server" maxlength="255" class="NewUIinput" />
                        </td>
                    </tr>
                    <tr>
                        <td width="170">
                            <div class="nobr">
                                <dw:TranslateLabel runat="server" ID="TranslateLabel25" Text="Connection" />
                            </div>
                        </td>
                        <td>
                            <asp:DropDownList name="fConnection" ID="fConnection" runat="server" class="NewUIinput">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="tableTR">
                        <td width="170">
                            <div class="nobr">
                                <dw:TranslateLabel ID="TranslateLabel30" runat="server" Text="Table" />
                            </div>
                        </td>
                        <td>
                            <div id="tableDropdown" name="tableDropdown">
                            </div>
                        </td>
                    </tr>
                    <asp:HiddenField ID="hiddenTableName" runat="server" Value="" />
                </table>
            </dwc:GroupBox>
        </dw:Dialog>

    </form>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
