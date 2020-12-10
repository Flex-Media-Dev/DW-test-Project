<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimImportFromExcel.aspx.vb" Inherits="Dynamicweb.Admin.PimImportFromExcel" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludejQuery="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductListEditingExtended.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/EditorWrapper.js" />
        </Items>
    </dw:ControlResources>    
    <script type="text/javascript">
        var controlRows = [];
    </script>
    
    <script type="text/javascript">
        function importFromExcel() {
            var cmdElement = document.getElementById("Cmd");
            if (!cmdElement.value) {
                cmdElement.value = "import";
            }
            if (cmdElement.value != 'importAfterVariantsDialog') {
                document.getElementById("ImportLanguages").value = SelectionBox.getElementsRightAsArray("LanguagesList").join();
            }
            var theForm = document.forms[0];
            theForm.submit();
        }
            
        function previousStep() {
            Action.showCurrentDialogLoader();            
            document.ContentContainer.action = "/Admin/Module/IntegrationV2/Import/DataImport_SelectSource.aspx";
            Action.Execute({
                'Name': 'Submit'
            });
        }
    </script>
</head>

<dwc:DialogLayout runat="server" ID="SourceSettingsDialog" Title="Source" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">            
            <asp:HiddenField ID="HdSelectedFile" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="ImportLanguages" ClientIDMode="Static" runat="server" />
            
            <input type="hidden" id="Cmd" name="Cmd" value="<%=Cmd%>" />
            <input type="hidden" name="GroupId" value="<%=Request("GroupId")%>" />
            <input type="hidden" name="ActivityConfiguration" value="<%=Request("ActivityConfiguration")%>" />
            <input type="hidden" name="PreviewImport" id="PreviewImport" value="<%=Request("PreviewImport")%>" />

            <dw:Infobar runat="server" ID="WarningBar" Visible="false" Type="Error" TranslateMessage="false" />

            <div id="gbSelectFile" runat="server" class="groupbox">
                <fieldset>
                    <div class="form-group">
                        <label class="control-label">
                            <dw:Label runat="server" Title="Select file" />
                        </label>

                        <%=Gui.FileManager(SelectedFile, "Files", "SourceFile", "SourceFile", "xlsx", True, "", False, True)%>
                    </div>
                </fieldset>
            </div>

            <dwc:GroupBox runat="server" ID="gbImportFields" Visible="false">
                <dw:Infobar runat="server" ID="LanguageSelectionWarningBar" Visible="false" Type="Warning" TranslateMessage="false" Message="Select at least one language to import" />

                <div class="form-group">
                    <label class="control-label">
                        <dw:Label runat="server" Title="File" />
                    </label>
                    <div class="form-group-input">
                        <dw:Label runat="server" ID="CurrentFile" doTranslation="false" />
                    </div>
                </div>
                <dw:SelectionBox ID="LanguagesList" runat="server" Width="200" Label="Languages" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" Height="250"></dw:SelectionBox>
                <div class="form-group">
                    <label class="control-label">
                        <dw:Label runat="server" Title="Data validation" />
                    </label>
                    <div class="form-group-input">
                        <dw:List runat="server" ID="FieldsList" ShowTitle="false">
                        </dw:List>
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="gbFailedVariants" DoTranslation="true" Title="Simple variants that need to be extended for import data to" Visible="false">
                <dw:List ID="SimpleVariantsList" runat="server" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn ID="ProductId" Name="Product Id" runat="server" WidthPercent="30" />
                        <dw:ListColumn ID="VariantName" Name="Variant name" runat="server" WidthPercent="40" />
                        <dw:ListColumn ID="VariantLanguages" Name="Languages" runat="server" WidthPercent="60" />
                    </Columns>
                </dw:List>
                <dwc:CheckBox ID="AutoCreateExtendedVariants" runat="server" Label="Create extended variants for the listed simple variants" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="gbImportStatus" DoTranslation="true" Title="Import status" Visible="false">
                <dw:Infobar ID="infoStatus" runat="server" />
            </dwc:GroupBox>
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" runat="server" id="PreviousStepButton" onclick="previousStep();">Previous</button>
        <button class="btn btn-link waves-effect" type="button" runat="server" id="NextStepButton" onclick="importFromExcel();">Next</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'});">Cancel</button>
    </footer>
</dwc:DialogLayout>
</html>
