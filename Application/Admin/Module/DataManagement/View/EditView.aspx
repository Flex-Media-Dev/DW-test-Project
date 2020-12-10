<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditView.aspx.vb" Inherits="Dynamicweb.Admin.EditView" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link rel="Stylesheet" href="/Admin/Module/DataManagement/View/style/EditView.css" />

    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true" />

    <script src="EditView.js" type="text/javascript"></script>
    <script type="text/javascript">
        var id = <%=ViewID%>;
        var cmd = "<%=CMD%>";
        var myBase = -1;
        var isEdit = <%=isEdit %>;
        var txtConvertToSQL = '<%=Translate.JsTranslate("You are in design mode. Convert view to SQL?") %>';
        var txtViewNameMissing = '<%=Translate.JsTranslate("You need to enter a name for the view!") %>';
        var txtConfirmPreview = '<%=Translate.JsTranslate("This will save the view. Are you sure you want to see the preview?") %>';
        var helpLang = "<%=helpLang %>";
    </script>
</head>
<body class="screen-container" onload="javascript:doInit(<%=BaseID %>);" id="viewBody">
    <dwc:Card runat="server">
        <form id="viewForm" runat="server" style="height: 100%;" method="post">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Data list">

                    <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Funktioner">
                        <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();" ID="Save" />
                        <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" ID="SaveAndClose" />
                        <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Type">
                        <dw:RibbonBarRadioButton OnClientClick="ChangeBase(0);" ID="Type_0" Group="type" Text="SQL Statement" RenderAs="Default" Value="0" Checked="true" runat="server" Size="Large" Icon="Edit" />
                        <dw:RibbonBarRadioButton OnClientClick="ChangeBase(1);" ID="Type_1" Group="type" Text="Design wizard" RenderAs="Default" Value="1" runat="server" Size="Large" Icon="Edit" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup4" runat="server" Name="Settings">
                        <dw:RibbonBarButton ID="btnSettings" runat="server" Size="Small" Text="Settings" Icon="Cog" OnClientClick="dialog.show('Settings');" />
                        <dw:RibbonBarCheckbox ID="btnShowSelector" runat="server" Size="Small" Text="Select field(s)" Icon="Search" OnClientClick="toggleDesignerEnabled();" RenderAs="Default"></dw:RibbonBarCheckbox>
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Preview">
                        <dw:RibbonBarCheckbox ID="btnPreview" runat="server" Size="Large" Text="Preview" Icon="Pageview" OnClientClick="Preview();" RenderAs="Default" />
                    </dw:RibbonBarGroup>

                    <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Help">
                        <dw:RibbonBarButton ID="HelpBut" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="help();" />
                    </dw:RibbonBarGroup>

                </dw:RibbonBarTab>
            </dw:RibbonBar>
            <dwc:CardBody runat="server">
                <div id="content">
                    <div id="divSQL" style="display: none;">
                        <dwc:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="SQL Statement">
                            <table class="formsTable">
                                <tr>
                                    <td>
                                        <dw:TranslateLabel runat="server" Text="Statement" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <textarea style="width: 100%" rows="20" name="vwStatement" id="vwStatement" runat="server"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </dwc:GroupBox>
                    </div>

                    <div id="divWiz">
                        <dwc:GroupBox ID="GroupBox3" runat="server" DoTranslation="true" Title="Configure data list">
                            <div id="tablesDiv" style="float: left;">
                                <table class="formsTable">
                                    <tr id="selTR" style="display: none;">
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="Select field(s)" />
                                        </td>
                                        <td>
                                            <div>
                                                <label>
                                                    <input type="radio" value="All" id="useFields_All" name="useFields" onclick="toggleUseAllFields(this);" /><dw:TranslateLabel Text="Use all fields (equivalent to SQL '*')" runat="server" />
                                                </label>
                                                <br />
                                                <label>
                                                    <input type="radio" value="Manual" id="useFields_Manual" name="useFields" onclick="toggleUseAllFields(this);" /><dw:TranslateLabel Text="Select specific fields" runat="server" />
                                                </label>
                                            </div>
                                            <div id="sel">
                                                <dw:SelectionBox ID="SelectionBox1" Height="200" Width="250" runat="server" TranslateNoDataText="true" NoDataTextRight="(All fields selected)"
                                                    TranslateHeaders="true" LeftHeader="Deselected field(s)" RightHeader="Selected field(s)" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="Add condition(s)" />
                                        </td>
                                        <td>
                                            <dw:EditableGrid ID="conds" runat="server" EnableViewState="true">
                                                <Columns>
                                                    <asp:TemplateField ControlStyle-Width="20px">
                                                        <ItemTemplate>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ControlStyle-Width="80px">
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="conditionalOperator" runat="server" class="NewUIinput" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ControlStyle-Width="200px">
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="fields" runat="server" class="NewUIinput" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ControlStyle-Width="100px">
                                                        <ItemTemplate>
                                                            <asp:DropDownList ID="oper" runat="server" class="NewUIinput" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ControlStyle-Width="200px">
                                                        <ItemTemplate>
                                                            <asp:TextBox ID="criteria" runat="server" Text='<%#Eval("value") %>' CssClass="NewUIinput" onkeydown="HandleKeyDown(event, this);"></asp:TextBox>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField ControlStyle-Width="20px">
                                                        <ItemTemplate>
                                                            <div id="buttons" style="visibility: hidden;">
                                                                <i title="<%=Translate.JsTranslate("Query helper") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Pencil) %>" onclick="showHelper(this);"></i>
                                                                <br />
                                                                <i title="<%=Translate.JsTranslate("Slet") %>" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Close) %>" onclick="deleteSelectedRow(this);"></i>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </dw:EditableGrid>
                                            <asp:HiddenField ID="fieldsWithPling" Value="" runat="server" />
                                            <asp:HiddenField ID="fields" Value="" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="Order by" />
                                        </td>
                                        <td>
                                            <div id="orderByDiv"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <dw:TranslateLabel runat="server" Text="Rows to fetch" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="topRows" CssClass="NewUIinput" runat="server">
                                                <asp:ListItem Text="1" Value="1" />
                                                <asp:ListItem Text="10" Value="10" />
                                                <asp:ListItem Text="25" Value="25" />
                                                <asp:ListItem Text="50" Value="50" />
                                                <asp:ListItem Text="100" Value="100" />
                                                <asp:ListItem Text="250" Value="250" />
                                                <asp:ListItem Text="500" Value="500" />
                                                <asp:ListItem Text="1000" Value="1000" />
                                                <asp:ListItem ID="topRowsAll" Selected="True" Text="All" Value="-1" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </dwc:GroupBox>
                    </div>
                </div>

                <div id="PreviewLayer" style="display: none; height: 400px; width: 100%;" runat="server">
                    <div id="PreviewContent" style="height: 100%;">
                        <iframe id="iPreview" width="100%" height="100%"></iframe>
                    </div>
                </div>

                <iframe src="about:blank" id="ContentSaveFrame" name="ContentSaveFrame" width="50%" frameborder="0" height="0" style="height: 0px;"></iframe>
            </dwc:CardBody>

            <dw:Dialog ID="Settings" runat="server" Title="Settings" ShowOkButton="true" ShowClose="false" Size="Medium">
                <dwc:GroupBox ID="GroupBox4" runat="server" DoTranslation="true" Title="Indstillinger">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Name" />
                            </td>
                            <td>
                                <input type="text" name="vwName" id="vwName" runat="server" maxlength="255" class="NewUIinput" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Connection" />
                            </td>
                            <td>
                                <asp:DropDownList name="vwConnection" ID="vwConnection" runat="server" class="NewUIinput">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="tableTR">
                            <td>
                                <dw:TranslateLabel runat="server" Text="Table" />
                            </td>
                            <td>
                                <div id="tableDropdown">
                                </div>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="RequestHelper" runat="server" ShowClose="true" Size="Medium" Title="Request Helper" ShowOkButton="true" ShowCancelButton="true" OkAction="okReq();">
                <dwc:GroupBox ID="GroupBox1" Title="Request/Session" runat="server" DoTranslation="true">
                    <div id="reqBuilder"></div>
                </dwc:GroupBox>

                <dwc:GroupBox ID="GroupBox5" Title="Info" runat="server" DoTranslation="true">
                    <div id="reqInfoPane"></div>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="QueryHelper" runat="server" ShowClose="true" Title="Query Helper" Size="Medium" ShowOkButton="true" ShowCancelButton="true" OkAction="okQuery();">
                <dwc:GroupBox ID="GroupBox6" Title="Info" runat="server" DoTranslation="true">
                    <table class="formsTable">
                        <tr>
                            <td><%=Translate.Translate("Field")%></td>
                            <td>
                                <div id="query_fieldName" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Operator")%></td>
                            <td>
                                <div id="query_operator" />
                            </td>
                        </tr>
                        <tr>
                            <td><%=Translate.Translate("Complete expression")%></td>
                            <td>
                                <div id="expressionDiv"></div>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>

                <dwc:GroupBox ID="GroupBox7" Title="Vælg værdier" runat="server" DoTranslation="true">
                    <div id="query_builder"></div>
                    <div><%=Translate.Translate("Notice that you can use %% to insert an empty string.", "%%", "&lt;!--empty--&gt;")%></div>
                    <div><a href="#" onclick="<%=Gui.Help("", "Modules.DataManagement.View.Edit.QueryHelper", helpLang) %>"><%=Translate.Translate("See the help for more info.")%></a></div>
                </dwc:GroupBox>
            </dw:Dialog>
        </form>
    </dwc:Card>
    <%Translate.GetEditOnlineScript()%>
    <script type="text/javascript">
        hideConditionalOperatorSelector();
        dwGrid_conds.onMouseMoving = hideConditionalOperatorSelector;
    </script>
</body>
</html>
