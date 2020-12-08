<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="ParagraphEditModule.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphEditModule" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Security" %>
<%@ Register TagPrefix="modules" TagName="ModulesList" Src="ParagraphListModules.ascx" %>
<%@ Register TagPrefix="modules" TagName="ModuleSettings" Src="ParagraphLoadModule.ascx" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>
        <dw:TranslateLabel Text="Settings" runat="server" UseLabel="false" />
    </title>
    <dw:ControlResources runat="server" IncludePrototype="true"></dw:ControlResources>

    <script src="ParagraphEvents.js" type="text/javascript"></script>
    <script src="ParagraphEditModule.js" type="text/javascript"></script>
    <script type="text/javascript">
        function ok() {
            removeModule(false);
            dialog.hide("ModuleWasNotFoundDialog");
        }
        function cancel() {
            var url = "ParagraphList.aspx?mode=viewparagraphs&PageID=" + document.getElementById("PageID").value;
            if (parent) {
                parent.location = url;
            } else {
                location = url;
            }
        }
    </script>
    <style>
        .icon .fa, .icon .md {
            font-size: 36px;
            margin-right: 20px;
        }

        body {
            overflow: auto;
            overflow-x: hidden;
        }

        .module-list i.fa,
        .module-list i.md {
            width: 15px;
            text-align: center;
        }
    </style>
</head>

<body onload="initForm();">
    <form id="paragraph_edit" runat="server" enableviewstate="false">

        <input type="hidden" id="ParagraphPageID" name="ParagraphPageID" value="" runat="server" />
        <input type="hidden" id="PageID" name="PageID" value="" runat="server" />
        <input type="hidden" id="ParagraphID" name="ParagraphID" value="" runat="server" />
        <input type="hidden" id="ParagraphID2" name="ID" value="" runat="server" />
        <input type="hidden" id="ModuleSystemName" name="ModuleSystemName" value="" runat="server" />

        <!-- Stores module settings passed from the external source (and to be loaded by module) -->
        <input type="hidden" id="ExternalModuleSettings" name="ExternalModuleSettings" value="" runat="server" />

        <!-- Stores module system name for which external settings are loaded -->
        <input type="hidden" id="ExternalModuleSettingsFor" name="ExternalModuleSettingsFor" value="" runat="server" />

        <!-- Parent window functions to be called after settings are saved (or module removed)  -->
        <input type="hidden" id="OnSettingsSaved" name="OnSettingsSaved" value="moduleSaved" runat="server" />
        <input type="hidden" id="OnModuleRemoved" name="OnModuleRemoved" value="" runat="server" />
        <input type="hidden" id="OnLoaded" name="OnLoaded" value="" runat="server" />


        <!-- 'Choose module' step: modules list -->
        <asp:PlaceHolder ID="phChooseModule" runat="server" Visible="false">
            <div class="module-list">
                <dw:GroupBox runat="server" Title="Content">
                    <modules:ModulesList ID="lstModules" runat="server" Columns="2" />
                </dw:GroupBox>
            </div>
            <div class="module-list">
                <dw:GroupBox runat="server" ID="ecomModulesGroupBox" Title="Ecommerce">
                    <modules:ModulesList ID="lstModuleseCom" runat="server" Columns="2" />
                </dw:GroupBox>
            </div>
        </asp:PlaceHolder>
        <!-- End: 'Choose module' step -->

        <!-- 'Configure module' step: change module setting -->
        <asp:PlaceHolder ID="phConfigureModule" runat="server" Visible="false" EnableViewState="false">
            <div style="position:fixed;width:100%;z-index:1001">
                <dw:Toolbar ID="Toolbar" ShowStart="false" ShowEnd="false" runat="server">
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Gem og luk"
                        OnClientClick="submitForm(); return false;" runat="server" />
                    <dw:ToolbarButton ID="cmdRemoveModule" Icon="Remove" Text="Remove"
                        OnClientClick="removeModule(); return false;" runat="server" />
                    <dw:ToolbarButton ID="cmdClose" Icon="Cancel" Text="Close"
                        OnClientClick="closeForm(); return false;" runat="server" />
                </dw:Toolbar>
            </div>
            <table style="width: 100%">
                <tr>
                    <td>
                        <div id="innerContent" class="settingsContent" style="padding: 0; display: none; height: 250px">
                            <modules:ModuleSettings ID="mSettings" runat="server" />
                        </div>
                    </td>
                </tr>
            </table>
        </asp:PlaceHolder>
        <!-- End: 'Configure module' step -->

        <!-- 'Remove module' confirmation message text -->
        <span id="mConfirmRemove" style="display: none">
            <%=Translate.Translate("Remove app?") %>
        </span>


        <asp:Literal ID="ModuleWasNotFound" runat="server"></asp:Literal>
    </form>

    <dw:Dialog ID="ModuleWasNotFoundDialog" ShowClose="false" ShowOkButton="true" ShowCancelButton="true" OkAction="ok();" CancelAction="cancel();" Title="Module not found" runat="server">
        The "<%= _module %>" module has been deprecated or was removed.
            <br />
        Do you want remove it from paragraph?
    </dw:Dialog>

    <dw:Overlay ID="ParagraphEditModuleOverlay" runat="server"></dw:Overlay>

</body>
</html>

<%Translate.GetEditOnlineScript()%>


