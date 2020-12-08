<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="MessageEdit.aspx.vb" Inherits="Dynamicweb.Admin.BasicForum.MessageEdit" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ControlResources1" runat="server">
    </dw:ControlResources>
    <link rel="stylesheet" href="css/main.css" />
    <script type="text/javascript" src="js/multiSelector.js"></script>
    <script type="text/javascript" src="js/messageEdit.js"></script>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "modules.dw8.forum.general.post.edit") %>
        }
    </script>
    <style>
        .forum-post-file .file-name {
            float: left;
            white-space: nowrap;
            padding-right: 5px;
        }
    </style>
</head>
<body class="screen-container">
    <dwc:Card runat="server">
        <form id="form1" runat="server" enctype="multipart/form-data">
            <dw:RibbonBar ID="MessageBar" runat="server">
                <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Post" runat="server" Visible="true">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="btnSave" Text="Save" Title="Save" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="Thread_Save" ShowWait="true" WaitTimeout="1000" />
                        <dw:RibbonBarButton ID="btnSaveAndClose" Text="Save and close" Icon="Save" Size="Small" runat="server" EnableServerClick="true" OnClick="Thread_SaveAndClose" ShowWait="true" WaitTimeout="1000" />
                        <dw:RibbonBarButton ID="btnCancel" Text="Close" Icon="TimesCircle" Size="Small" runat="server" EnableServerClick="true" PerformValidation="false" OnClick="Cancel_Click" />
                        <dw:RibbonBarButton ID="btnDelete" Text="Delete" Icon="Delete" Size="Small" runat="server" EnableServerClick="false" PerformValidation="false" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup10" Name="Help" runat="server">
                        <dw:RibbonBarButton ID="Help" Text="Help" Title="Help" Icon="Help" Size="Large" runat="server" OnClientClick="help();" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>

            <div class="list">
                <div id="breadcrumb" class="title" runat="server"></div>
            </div>

            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" ID="SettingsStart" DoTranslation="true" Title="Settings">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Heading" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="Heading" runat="server" MaxLength="250" CssClass="NewUIinput" />
                                <asp:RequiredFieldValidator ID="required1" runat="server" ErrorMessage="*" ControlToValidate="Heading"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Author" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="Author" runat="server" CssClass="NewUIinput" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="E-mail" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="Email" runat="server" CssClass="NewUIinput" />
                                <asp:RegularExpressionValidator runat="server" ID="EmailValidator" ControlToValidate="Email" ErrorMessage="Please specify a correct e-mail address."
                                    ValidationExpression="([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Date" runat="server" />
                            </td>
                            <td>
                                <dw:DateSelector ID="Date" runat="server" />
                            </td>
                        </tr>
                        <tr runat="server" id="StickyTR" visible="false">
                            <td></td>
                            <td>
                                <dw:CheckBox Label="Sticky" ID="Sticky" FieldName="Sticky" runat="server" />
                            </td>
                        </tr>
                        <tr runat="server" id="ActiveTR" visible="false">
                            <td></td>
                            <td>
                                <dw:CheckBox Label="Active" ID="IsActive" FieldName="IsActive" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" ID="GroupBoxStart1" DoTranslation="true" Title="Text">
                    <dw:Editor ID="Text" Height="400" runat="server" />
                </dwc:GroupBox>

                <div id="CategoriesDiv" runat="server">
                    <dwc:GroupBox runat="server" ID="CategoryGroupBoxStart" DoTranslation="true" Title="Category">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel Text="Select category" runat="server" />
                                </td>
                                <td>
                                    <asp:DropDownList ID="CategoriesList" runat="server" CssClass="std" />
                                </td>
                            </tr>
                        </table>
                    </dwc:GroupBox>
                </div>

                <dwc:GroupBox runat="server" ID="GroupBoxStart2" DoTranslation="true" Title="Attachments">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Select file" runat="server" />
                            </td>
                            <td>
                                <div class="forum-post-addfile">
                                    <input type="file" name="Attachment" id="Attachment" style="display: none;" />                                    
                                    <button type="button" class="dialog-button-ok btn btn-clean" id="uploadButton" onclick="document.getElementById('Attachment').click(); return false;" >
                                        <%=Translate.Translate("Choose file") %>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <div class="forum-post-clear"></div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <div id="FilesList" style="display: none"></div>
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
                
                <%= UploadedFilesInputs.ToString()%>
                <script type="text/javascript">
                    /* Create an instance of the multiSelector class, pass it the output target and the max number of files */
                    var multi_selector = new MultiSelector(document.getElementById("FilesList"), -1);

                    /*  Pass in the file element */
                    multi_selector.addElement(document.getElementById('Attachment'));
                    <%= UploadedFilesJS.ToString() %>
                </script>
                <dw:Overlay ID="overlay" runat="server"></dw:Overlay>
            </dwc:CardBody>
        </form>
    </dwc:Card>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
