<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ControlsDWC.aspx.vb" Inherits="Dynamicweb.Admin.ControlsDWC" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.UI.Elements.Displays" %>

<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register Src="~/Admin/Examples/InputNumbersDemo.ascx" TagPrefix="uc1" TagName="InputNumbersDemo" %>
<%@ Register Src="~/Admin/Examples/InputTextsDemo.ascx" TagPrefix="uc1" TagName="InputTextsDemo" %>
<%@ Register Src="~/Admin/Examples/SelectorsDemo.ascx" TagPrefix="uc1" TagName="SelectorsDemo" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib">
    </dwc:ScriptLib>

    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/Default.js"></script>
    <script type="text/javascript" src="/Admin/Content/Items/js/ItemTypeEdit.js"></script>

    <script type="text/javascript">
        function save(close) {
            document.getElementById("MainForm").submit();
            page.submit();
        }

        function showInfos() {
            var infos = jQuery("small.help-block.info");
            if (jQuery("small.help-block.info:first").text() == "") {
                jQuery(infos).text("here some additional info");
            } else {
                jQuery(infos).text('');
            }
        }
        var errorsShown = false;
        function showErrors() {
            var groups = document.querySelectorAll(".card-body .form-group");
            for (var i = 0; i < groups.length; i++) {
                if (!errorsShown) {
                    dwGlobal.showControlErrors(groups[i]);
                }
                else {
                    dwGlobal.hideControlErrors(groups[i]);
                }
            }
            errorsShown = !errorsShown;
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

<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server" ID="Blockheader">
        </dwc:BlockHeader>
        <form id="MainForm">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="DWC controls" DoTranslate="False"></dwc:CardHeader>
                <dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="false" Divide="None" Icon="PlusSquare" Text="Add" />
                    <dw:ToolbarButton ID="cmdInfos" runat="server" Disabled="false" Divide="None" Icon="InfoCircle" Text="Toggle infos" Translate="false" OnClientClick="showInfos();" />
                    <dw:ToolbarButton ID="cmdErrors" runat="server" Disabled="false" Divide="None" Icon="Error" Text="Toggle errors" Translate="false" OnClientClick="showErrors();" />
                    <dw:ToolbarButton ID="ToolbarButton1" runat="server" Disabled="false" Divide="None" Icon="Error" Text="first text error" Translate="false" OnClientClick="dwGlobal.showControlErrors('textbox1');" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <form id="Form1" runat="server">
                    <uc1:SelectorsDemo runat="server" ID="SelectorsDemo" />
                    <uc1:InputNumbersDemo runat="server" id="InputNumbersDemo" />
                    <uc1:InputTextsDemo runat="server" id="InputTextsDemo" />
                    <dw:GroupBox Title="Badges examples" runat="server" ID="groupbox4" DoTranslation="False">
                        <div style="width: 200px; margin-bottom: 5px;">
                            <%=Dynamicweb.Admin.ControlsDW.RenderBadge("10%", BadgeColor.Red) %>
                        </div>
                        <div style="width: 200px; margin-bottom: 5px;">
                            <%=Dynamicweb.Admin.ControlsDW.RenderBadge("30%", BadgeColor.Orange) %>
                        </div>
                        <div style="width: 200px; margin-bottom: 5px;">
                            <%=Dynamicweb.Admin.ControlsDW.RenderBadge("57%", BadgeColor.Yellow) %>
                        </div>
                        <div style="width: 200px; margin-bottom: 5px;">
                            <%=Dynamicweb.Admin.ControlsDW.RenderBadge("100%", BadgeColor.Green) %>
                        </div>
                    </dw:GroupBox>

                    <dwc:GroupBox Title="Available channels" runat="server" DoTranslation="False">
                        <dwc:CheckBox runat="server" ID="Channel" Header="Channels:" Label="My facebook music" Info="Facebook" DoTranslate="false" />
                        <dwc:CheckBox runat="server" ID="CheckBox1" Label="My Twitter Posts1" Info="Twitter" DoTranslate="false" />
                        <dwc:CheckBox runat="server" ID="CheckBox2" Label="My Twitter Posts2" Info="Twitter" DoTranslate="false" />
                    </dwc:GroupBox>

                    <dwc:GroupBox Title="Controls with empty validation message" runat="server" DoTranslation="False">

                        <dwc:InputText runat="server" id="textbox1" Name="" Label="InputText" Placeholder="500" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:InputTextArea runat="server" Label="TextArea" Placeholder="area" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:InputNumber runat="server" Label="Number" Placeholder="number" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:RadioGroup runat="server" Name="/Globalsettings/ItemTypes/MetadataSource" Label="RadioGroup" DoTranslate="False" Info="" ValidationMessage="">
                            <dwc:RadioButton runat="server" Label="radio 1" FieldValue="all" DoTranslate="False" Info="" ValidationMessage="" />
                            <dwc:RadioButton runat="server" Label="radio 2" FieldValue="files" DoTranslate="False" Info="" ValidationMessage="" />
                        </dwc:RadioGroup>

                        <dwc:CheckBox runat="server" Label="checkbox 1" Header="checkbox" DoTranslate="False" Info="" ValidationMessage="" />

                        <dw:DateSelector runat="server" Label="DateSelector" Placeholder="date" DoTranslate="False" Info="123" ValidationMessage="13515" />

                        <dwc:SelectPicker runat="server" Label="Selectpicker" Placeholder="selectpicker" DoTranslate="False" Info="" ValidationMessage="">
                            <asp:ListItem Text="asp list item?? 1" Value="1" />
                            <asp:ListItem Text="asp list item?? 2" Value="2" />
                        </dwc:SelectPicker>

                        <dwc:Button Title="the button" ID="Button2" OnClick="alert('button clicked');" runat="server" DoTranslate="False"  />
                    </dwc:GroupBox>
                    <dwc:GroupBox Title="Controls without validation message" runat="server" DoTranslation="False">
                        <dwc:InputText runat="server" Name="" Label="InputText" Placeholder="500" DoTranslate="False" Info="" />

                        <dwc:InputTextArea runat="server" Label="TextArea" Placeholder="area" DoTranslate="False" Info="" />

                        <dwc:InputNumber runat="server" Label="Number" Placeholder="number" DoTranslate="False" Info="" />

                        <dwc:RadioGroup runat="server" Name="/Globalsettings/ItemTypes/MetadataSource" Label="RadioGroup" DoTranslate="False" Info="">
                            <dwc:RadioButton runat="server" Label="radio 1" FieldValue="all" DoTranslate="False" Info="" />
                            <dwc:RadioButton runat="server" Label="radio 2" FieldValue="files" DoTranslate="False" Info="" />
                        </dwc:RadioGroup>

                        <dwc:CheckBox runat="server" Label="checkbox 1" Header="checkbox" DoTranslate="False" Info="" />

                        <dw:DateSelector runat="server" Label="DateSelector" Placeholder="date" DoTranslate="False" Info="" />

                        <dwc:SelectPicker runat="server" Label="Selectpicker" Placeholder="selectpicker" DoTranslate="False" Info="">
                            <asp:ListItem Text="asp list item?? 1" Value="1" />
                            <asp:ListItem Text="asp list item?? 2" Value="2" />
                        </dwc:SelectPicker>

                        <dwc:Button Title="the button" ID="Button4" OnClick="alert('button clicked');" runat="server" DoTranslate="False"  />
                    </dwc:GroupBox>
                    <dwc:GroupBox Title="Controls with validation message" runat="server" DoTranslation="False">
                        <dwc:InputText runat="server" Name="" Label="InputText" Placeholder="500" DoTranslate="False" Info="" ValidationMessage="1" />

                        <dwc:InputTextArea runat="server" Label="TextArea" Placeholder="area" DoTranslate="False" Info="" ValidationMessage="2" />

                        <dwc:InputNumber runat="server" Label="Number" Placeholder="number" DoTranslate="False" Info="" ValidationMessage="3" />

                        <dwc:RadioGroup runat="server" Name="/Globalsettings/ItemTypes/MetadataSource" Label="RadioGroup" DoTranslate="False" Info="" ValidationMessage="4">
                            <dwc:RadioButton runat="server" Label="radio 1" FieldValue="all" DoTranslate="False" Info="" ValidationMessage="5" />
                            <dwc:RadioButton runat="server" Label="radio 2" FieldValue="files" DoTranslate="False" Info="" ValidationMessage="6" />
                        </dwc:RadioGroup>

                        <dwc:CheckBox runat="server" Label="checkbox 1" Header="checkbox" DoTranslate="False" Info="" ValidationMessage="7" />

                        <dw:DateSelector runat="server" Label="DateSelector" Placeholder="date" DoTranslate="False" Info="" ValidationMessage="8" />

                        <dwc:SelectPicker runat="server" Label="Selectpicker" Placeholder="selectpicker" DoTranslate="False" Info="" ValidationMessage="9">
                            <asp:ListItem Text="asp list item?? 1" Value="1" />
                            <asp:ListItem Text="asp list item?? 2" Value="2" />
                        </dwc:SelectPicker>

                        <dwc:Button Title="the button" ID="Button3" OnClick="alert('button clicked');" runat="server" DoTranslate="False"  />
                    </dwc:GroupBox>
                    <dwc:GroupBox Title="Controls" runat="server" DoTranslation="False">
                        <dwc:InputText runat="server" Name="" Label="InputText" Placeholder="500" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:InputTextArea runat="server" Label="TextArea" Placeholder="area" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:InputNumber runat="server" Label="Number" Placeholder="number" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:RadioGroup runat="server" Name="/Globalsettings/ItemTypes/MetadataSource" Label="RadioGroup" DoTranslate="False" Info="" ValidationMessage="">
                            <dwc:RadioButton runat="server" Label="radio 1" FieldValue="all" DoTranslate="False" Info="" ValidationMessage="" />
                            <dwc:RadioButton runat="server" Label="radio 2" FieldValue="files" DoTranslate="False" Info="" ValidationMessage="" />
                        </dwc:RadioGroup>

                        <dwc:CheckBoxGroup runat="server" ID="Channels" Label="CheckBox group">
                            <dwc:CheckBox runat="server" Label="text 1" Info="" DoTranslate="false" />
                            <dwc:CheckBox runat="server" Label="text 2" DoTranslate="false" />
                            <dwc:CheckBox runat="server" Label="text 3" Info="info 3" DoTranslate="false" />
                            <dwc:CheckBox runat="server" Label="text 4" Info="info 4" DoTranslate="false" />
                            <dwc:CheckBox runat="server" Label="text 5" Info="info 5" DoTranslate="false" />
                        </dwc:CheckBoxGroup>

                        <dwc:CheckBox runat="server" Label="checkbox 1" Header="checkbox" DoTranslate="False" Info="" ValidationMessage="" />

                        <dw:DateSelector runat="server" Label="DateSelector" Placeholder="date" DoTranslate="False" Info="" ValidationMessage="" />

                        <dwc:SelectPicker runat="server" Label="Selectpicker" Placeholder="selectpicker" DoTranslate="False" Info="" ValidationMessage="">
                            <asp:ListItem Text="asp list item?? 1" Value="1" />
                            <asp:ListItem Text="asp list item?? 2" Value="2" />
                        </dwc:SelectPicker>

                        <dwc:Button Title="the button" ID="Button1" OnClick="alert('button clicked');" runat="server" DoTranslate="False"  />
                    </dwc:GroupBox>

                    
                    
                    <%= addInSelector.Jscripts %>
                    <de:AddInSelector ID="addInSelector" runat="server" AddInGroupName="AddInSelector"  AddInShowNothingSelected="true" AddInShowParameters="true" UseLabelAsName="True" AddInShowNoFoundMsg="false"
                                AddInTypeName="Dynamicweb.Admin.ParametersTestAddinBase" />
                    <%= addInSelector.LoadParameters %>

                    <dwc:GroupBox Title="List" runat="server" DoTranslation="False">
                        <dw:List runat="server" ID="TheList" PageSize="25" ShowPaging="true" AllowMultiSelect="true" Title="The List">
                            <Columns>
                                <dw:ListColumn runat="server" ID="col1" Name="Column 1" EnableSorting="true" />
                                <dw:ListColumn runat="server" ID="col2" Name="Column 2" EnableSorting="true" />
                            </Columns>
                            <Filters>
                                <dw:ListDateFilter runat="server" id="CreationDateFilter" Label="Date Filter" /> 
                                <dw:ListTextFilter runat="server" id="CodeFilter" Label="Text Filter" ShowSubmitButton="true" Divide="After" />
                            </Filters>
                        </dw:List>
                    </dwc:GroupBox>
                    <dwc:GroupBox Title="Pickers(do not click on select buttons)" DoTranslation="False" runat="server">
                        <dw:LinkManager runat="server" ID="link1" Name="LinkManager" />
                        <dw:FileManager runat="server" id="filem1" Label="FileManager" folder="/files/attachments" Name="FileManager" Info="jhhgjhgjs" />
                        <dw:FileManager runat="server" id="FileManager1" Folder="/images" Label="FileManagerImages" Name="FileManagerImages" />
                        <dw:FileArchive runat="server" id="filea1"/>
                        <dw:FolderManager runat="server" id="folderm1" Name="FolderManager" />
                    </dwc:GroupBox>

                    <% Translate.GetEditOnlineScript() %>
                    </form>
                </dwc:CardBody>
            </dwc:Card>
        </form>

        <dwc:ActionBar runat="server">
            <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Image="NoImage" Text="Save" OnClientClick="save();" ShowWait="True">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Image="NoImage" Divide="None" Text="Save and close" OnClientClick="save(true);" ShowWait="True">
            </dw:ToolbarButton>
            <dw:ToolbarButton ID="cmdCancel" runat="server" Image="NoImage" Divide="None" Text="Cancel" OnClientClick="location.reload();" ShowWait="True">
            </dw:ToolbarButton>
        </dwc:ActionBar>
    </div>
</body>
</html>
