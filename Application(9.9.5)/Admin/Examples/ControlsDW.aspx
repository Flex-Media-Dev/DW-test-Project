<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ControlsDW.aspx.vb" Inherits="Dynamicweb.Admin.ControlsDW" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.UI.Elements.Displays" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register Src="~/Admin/Examples/InputNumbersDemo.ascx" TagPrefix="uc1" TagName="InputNumbersDemo" %>
<%@ Register Src="~/Admin/Examples/InputTextsDemo.ascx" TagPrefix="uc1" TagName="InputTextsDemo" %>
<%@ Register Src="~/Admin/Examples/SelectorsDemo.ascx" TagPrefix="uc1" TagName="SelectorsDemo" %>

<!DOCTYPE html>
<html>
<head>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeRequireJS="false">
    </dw:ControlResources>
    
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/ItemTypeEdit.js"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>

    <script type="text/javascript">
        save = function (close) {
            document.getElementById("MainForm").submit();
            page.submit();
        }
    </script>
    <style>
        .has-error {
        }

        .ctrl-commands-pane {
            background-color: #cee1e1;
            padding: 10px;
            margin: 10px 0;
        }
        .ctrl-commands-pane label {
            padding: 10px;
        }
    </style>
</head>
<body class="screen-container" data-dwselector-suppress-auto-initialization="true">
    <div class="card">
        <form id="form1" runat="server">
            <div class="card-header">
                <h2 class="subtitle">DW controls</h2>
            </div>

            <dw:Toolbar ID="ListBar1" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="false" Divide="None" Icon="PlusSquare" Text="Add" />
            </dw:Toolbar>
            <div>
                <uc1:SelectorsDemo runat="server" ID="SelectorsDemo" />
                <uc1:InputNumbersDemo runat="server" ID="InputNumbersDemo" />
                <uc1:InputTextsDemo runat="server" id="InputTextsDemo" />
                <dw:GroupBox Title="Badges examples" runat="server" ID="groupbox4" DoTranslation="False">
                    <div style="width: 200px; margin-bottom: 5px;">
                        <%=RenderBadge("10%", BadgeColor.Red) %>
                    </div>
                    <div style="width: 200px; margin-bottom: 5px;">
                        <%=RenderBadge("30%", BadgeColor.Orange) %>
                    </div>
                    <div style="width: 200px; margin-bottom: 5px;">
                        <%=RenderBadge("57%", BadgeColor.Yellow) %>
                    </div>
                    <div style="width: 200px; margin-bottom: 5px;">
                        <%=RenderBadge("100%", BadgeColor.Green) %>
                    </div>
                </dw:GroupBox>

                <dw:GroupBox Title="Controls in table" runat="server" ID="groupbox1" DoTranslation="False">
                    <table class="formsTable">
                        <tbody>
                            <tr>
                                <td>Input type Text class std</td>
                                <td>
                                    <input name="ImagePatternM" type="text" class="std" placeholder="500">
                                </td>
                            </tr>
                            <tr>
                                <td>asp textbox multilie class NewInput</td>
                                <td>
                                    <asp:TextBox ID="MetaKeywords" TextMode="MultiLine" Columns="30" Rows="2" CssClass="NewUIinput" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Input type Text class std</td>
                                <td>
                                    <input name="ImagePatternM" type="text" class="std" value="10.0">
                                </td>
                            </tr>
                            <tr>
                                <td>Radio group(2x radiobuttons)</td>
                                <td>
                                    <dw:RadioButton runat="server" ID="rb1" FieldName="RadioGroup" FieldValue="radio 1" />
                                    <label for="rb1">radio 1</label>
                                    <br />
                                    <dw:RadioButton runat="server" ID="rb2" FieldName="RadioGroup" FieldValue="radio 2" />
                                    <label for="rb2">radio 2</label>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>Checkbox</td>
                                <td>
                                    <dw:CheckBox runat="server" Label="checkbox 1" id="checkboxid" />
                                </td>
                            </tr>
                            <tr>
                                <td>DateSelector</td>
                                <td>
                                    <dw:DateSelector runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>Select class std</td>
                                <td>
                                    <select name="DefaultView" id="DefaultView" class="std">
	                                    <option value="none">option 1</option>
	                                    <option selected="selected" value="orders">option 2</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><dw:Button runat="server"  Name="the button" /></td>
                            </tr>
                        </tbody>
                    </table>
                </dw:GroupBox>

                    <%= addInSelector.Jscripts %>
                    <de:AddInSelector ID="addInSelector" runat="server" AddInGroupName="AddInSelector" AddInShowNothingSelected="false" AddInShowParameters="true" UseLabelAsName="True" AddInShowNoFoundMsg="false"
                                AddInTypeName="Dynamicweb.Admin.ParametersTestAddinBase" />
                    <%= addInSelector.LoadParameters %>
                <dw:GroupBox Title="List" runat="server" ID="groupbox2" DoTranslation="False">
                    <dw:List ID="TheList" ShowFooter="true" runat="server" TranslateTitle="True" PageSize="25" ShowPaging="true" AllowMultiSelect="true" Title="The List">
                        <Columns>
                            <dw:ListColumn ID="colName" runat="server" Name="Name" EnableSorting="true" />
                            <dw:ListColumn ID="colCode" runat="server" Name="Code" EnableSorting="true" />
                        </Columns>
                        <Filters>
                            <dw:ListDateFilter runat="server" ID="CreationDateFilter" Label="Date Filter" />
                            <dw:ListTextFilter runat="server" ID="CodeFilter" Label="Text Filter" ShowSubmitButton="true" Divide="After" />
                        </Filters>
                    </dw:List>
                </dw:GroupBox>

                <dw:GroupBox Title="Pickers in table(do not click on select buttons)" runat="server" ID="groupbox3" DoTranslation="False">
                    <table class="formsTable">
                        <tbody>
                            <tr>
                                <td>LinkManager(no label attibute)</td>
                                <td>
                                    <dw:LinkManager runat="server" ID="link1" Name="LinkManager" />
                                </td>
                            </tr>
                            <tr>
                                <td>FileManager</td>
                                <td>
                                    <dw:FileManager runat="server" ID="filem1" Label="why it's like this?" Folder="/files/attachments" Name="FileManager" />
                                </td>
                            </tr>
                            <tr>
                                <td>FileManager</td>
                                <td>
                                    <dw:FileManager runat="server" ID="FileManager1" Folder="/images" Label="why it's like this? images" Name="FileManagerImages" />
                                </td>
                            </tr>
                            <tr>
                                <td>FileArchive(no label attibute)</td>
                                <td>
                                    <dw:FileArchive runat="server" ID="filea1" />
                                </td>
                            </tr>
                            <tr>
                                <td>FolderManager</td>
                                <td>
                                    <dw:FolderManager runat="server" ID="folderm1" Name="FolderManager" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </dw:GroupBox>
            </div>

            <dwc:ActionBar runat="server" Visible="true">
                <dw:ToolbarButton runat="server" Text="Gem" KeyboardShortcut="ctrl+s" Size="Small" Image="NoImage" OnClientClick="Save();" ID="cmdSave" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
            </dwc:ActionBar>
        </form>
    </div>
</body>
</html>
