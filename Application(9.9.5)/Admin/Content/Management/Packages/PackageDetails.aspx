<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="PackageDetails.aspx.vb" Inherits="Dynamicweb.Admin.PackageDetails" EnableEventValidation="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script src="PackageDetails.js"></script>
    </dwc:ScriptLib>
</head>

<body class="area-blue">
    <div class="dw8-container">
        <form method="post" runat="server" enableviewstate="false">
            <input runat="server" type="hidden" name="Referrer" id="ReferrerHidden" value="" />
            <dwc:Card runat="server">
                <dwc:CardHeader ID="cardHeader" runat="server" Title="Package" DoTranslate="false" />
                <dwc:CardBody runat="server">
                    <dw:Infobar runat="server" ID="LicenseWarning" Visible="false" Message="" Type="Information" />
                    <dwc:GroupBox runat="server" ID="PackageDetailsGroupBox" Title="Version">
                        <dwc:InputText runat="server" Disabled="true" ID="InstalledPackageVersion" Label="Installed version" />
                        <dwc:SelectPicker runat="server" ID="PackageVersion" Label="Available version(s)" />
                    </dwc:Groupbox>
                    <dwc:GroupBox runat="server" ID="PackageInformation" Title="Information">
                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Summary" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageSummary" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Author" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageAuthor" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Release notes" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageReleaseNotes" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Tags" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageTags" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Copyright" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageCopyright" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Documentation" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageLicenseUrl" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label">
                                <dw:TranslateLabel runat="server" Text="Dependencies" />
                            </label>
                            <div class="form-group-input">
                                <asp:Literal runat="server" ID="PackageDependencies" />
                            </div>
                        </div>
                                
                        <dw:Infobar runat="server" ID="ActionResultLabel" Type="Information" Visible="false" TranslateMessage="False" Title="" Message="" />
                        <dw:Infobar runat="server" ID="RestoreWarning" Type="Warning" Visible="False" TranslateMessage="True" Title="" Message="Some packages are missing from application. Please, click to restore." />

                        <asp:Literal runat="server" ID="UpdateLink" />
                        <div>
                            <dwc:Button runat="server" ActionType="submit" id="InstallButton" name="InstallButton" onclick="showOverlay()" Title="Install" value="1" />
                            <dwc:Button runat="server" ActionType="submit" id="UpdateButton" name="UpdateButton" onclick="showOverlay()" Title="Update" value="1" />
                            <dwc:Button runat="server" ActionType="submit" id="UninstallButton" name="UninstallButton" onclick="showOverlay()" Title="Uninstall" value="1" />
                            <dwc:Button runat="server" ActionType="submit" id="RestoreButton" visible="false" name="RestoreButton" onclick="showOverlay()" Title="Restore" value="1" />
                        </div>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
    <dw:Overlay ID="ActionOverlay" Message="Please wait" ShowWaitAnimation="true" runat="server"></dw:Overlay>
</body>
</html>
