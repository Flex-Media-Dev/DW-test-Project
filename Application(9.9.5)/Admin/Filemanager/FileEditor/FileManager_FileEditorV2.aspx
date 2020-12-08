<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FileManager_FileEditorV2.aspx.vb" Inherits="Dynamicweb.Admin.FileManager_FileEditorV2" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
	<head runat="server">
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 

		<dw:ControlResources IncludePrototype="true" IncludeRequireJS="false" IncludeClientSideSupport="true" runat="server">
		    <Items>		        
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/FileManager_FileEditorV2.css" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.css" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/razor/razor.css" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/addon/dialog/dialog.css" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/lib/codemirror.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/razor/razor.js" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/xml/xml.js" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/javascript/javascript.js" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/css/css.js" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/htmlembedded/htmlembedded.js" />
		        <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/mode/htmlmixed/htmlmixed.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/addon/search/searchcursor.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/addon/search/search.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/addon/dialog/dialog.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/CodeMirror-5.21/addon/mode/loadmode.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/FileManager_FileEditorV2.js" />
                <dw:GenericResource Url="/Admin/Filemanager/FileEditor/FileManager_FileEditorV2_ModalWindow.js" />
            </Items>
		    <Conditions>
		        <dw:ResourceCondition Criteria="Contains" Value="scriptaculous.js" Resolution="Discard" />
		    </Conditions>
		</dw:ControlResources>

        <script type="text/javascript">
            var winOpener = opener;

            function reloadFileList() {
                if (typeof (winOpener) != 'undefined' && winOpener) {
                    var src = winOpener.location.href;
                    if (src.endsWith('#')) {
                        src = src.substr(0, src.length - 1);
                    }
                    winOpener.location.href = src;
                }
            }
        </script>

		<title></title>
	</head>
	<body style="overflow: hidden;" scroll="no" onload="Page.onLoad();">
		
		<!-- Form -->
	
		<form id="MainForm" runat="server">
			<div id="rowRibbon" class="row-ribbon">    
				<dw:Ribbonbar runat="server" DisableAddIns="true" HelpKeyword="modules.filearchive.general.editorNEW.file" ID="Toolbar">
			        <dw:RibbonbarTab ID="TabEditor" Active="true" Name="Editor" runat="server">
			            <dw:RibbonbarGroup ID="GroupFile" Name="File" runat="server">
			                <dw:RibbonbarButton ID="cmdSave" Icon="Save" Size="Small" KeyboardShortcut="ctrl+s" Text="Gem" runat="server" OnClientClick="Editor.save();" />
			                <dw:RibbonbarButton ID="cmdSaveAndClose" Icon="Save" Size="Small" Text="Gem og luk" runat="server" OnClientClick="Editor.saveAndClose();" />
			                <dw:RibbonbarButton ID="cmdSaveAs" Icon="Save" Size="Small" Text="Gem som" runat="server" OnClientClick="Editor.saveAs();" />
			                <dw:RibbonbarButton ID="cmdSimpleEditor" Icon="ListAlt" Size="Large" Text="Simple editor" runat="server" OnClientClick="Editor.simpleEditor();" />
			            </dw:RibbonbarGroup>
			            <dw:RibbonbarGroup ID="GroupEdit" Name="Edit" runat="server">
			                <dw:RibbonbarButton ID="cmdCut" Icon="Cut" Size="Small" Text="Klip" runat="server" OnClientClick="Editor.cut();" />
			                <dw:RibbonbarButton ID="cmdCopy" Icon="Copy" Size="Small" Text="Kopier" runat="server" OnClientClick="Editor.copy();" />
			                <dw:RibbonbarButton ID="cmdPaste" Icon="Paste" Size="Small" Text="Sæt ind" runat="server" OnClientClick="Editor.paste();" />
			                <dw:RibbonbarButton ID="cmdUndo" Icon="Undo" Size="Small" Text="Fortryd" runat="server" OnClientClick="Editor.undo();" />
			                <dw:RibbonbarButton ID="cmdRedo" Icon="Redo" Size="Small" Text="Annuller fortryd" runat="server" OnClientClick="Editor.redo();" />
			                <dw:RibbonbarButton ID="cmdFindReplace" ContextMenuId="cmFind" Icon="FindReplace" Size="Small" Text="Find" runat="server" OnClientClick="FindDialog.show();" />
			            </dw:RibbonbarGroup>
			            <dw:RibbonbarGroup ID="GroupTools" Name="Funktioner" runat="server">
			                <dw:RibbonbarButton ID="cmdCheck" Icon="Check" Size="Small" Text="Fix HTML" runat="server" OnClientClick="Editor.fixHTML();" />
                            <dw:RibbonbarButton ID="blankButton" Visible="false" Size="Small" runat="server"  />
			                <dw:RibbonbarButton ID="cmdConvertToXslt" Icon="Sitemap" Size="Small" Text="Convert to XSLT" runat="server" OnClientClick="Editor.convertToXslt();" />
                            <dw:RibbonbarButton ID="cmdConvertToRazor" Icon="Code" Size="Small" Text="Convert to Razor" runat="server" OnClientClick="Editor.convertToRazor();" />
			            </dw:RibbonbarGroup>
			        </dw:RibbonbarTab>
			    </dw:Ribbonbar>
			</div>
			
			
			<!-- Editing area -->
		    <div id="rowEditingArea" class="editing-area">
		        <textarea style="display:none" id="txText" runat="server"></textarea>
			    <div id="rowNoAccess" runat="server">
		            <div class="noAccessContainer">
		                <div class="noAccessHeading">
		                    <dw:TranslateLabel ID="lbAccessDenied" Text="Adgang_nægtet!" runat="server" />
		                </div>
		                <div class="noAccessText">
		                    <dw:TranslateLabel ID="lbAccessDeniedText" Text="You do not have required permissions to edit this file." runat="server" />
		                </div>
		            </div>
		        </div>	
		    </div>
				
		    <!-- End: Editing area -->
			
			<!-- Status bar -->		
			
			<div id="rowStatus" class="row-status">
			    <span id="pStatus" style="color: #9E9E9E"></span>
			    <div class="btn pull-right"><i id="imgRefresh" class="refresh-icon fa fa-refresh" runat="server"></i></div>
			</div>	
			
			<!-- End: Status bar -->		
			
			<input type="hidden" id="InitialFileName" name="InitialFileName" class="initial-filename" value="" runat="server" />
			<input type="hidden" id="InitialFileDir" name="InitialFileDir" class="initial-directory" value="" runat="server" />
			<input type="hidden" id="InitialFileFullPath" value="" runat="server" />
			<input type="hidden" id="IsXsltFile" name="IsXsltFile" value="false" runat="server" />
			<input type="hidden" id="IsRazorFile" name="IsRazorFile" value="false" runat="server" />
			
			<!-- "Refresh" balloon -->
			
			<div id="refreshBalloon" class="balloon" style="display: none">
			    <div class="balloon-content" onclick="Editor.hideRefreshBalloon();">
			        <table cellspacing="0" cellpadding="0">
			            <tr>
			                <td style="width: 32px" valign="top">
			                    <img src="/Admin/Images/Ribbon/Icons/document_ok.png" alt="" title="" border="0" />
			                </td>
			                <td valign="top" style="padding-left: 5px">
			                    <div class="balloon-title">
			                        <dw:TranslateLabel ID="lbRefreshPageTitle" Text="Please refresh the editor" runat="server" />
			                    </div>
			                    <div class="balloon-text">
			                        <dw:TranslateLabel ID="lbRefreshPage" Text="Please refresh the editor in order to get syntax highlighting for the current file." runat="server" />
			                    </div>
			                </td>
			            </tr>
			        </table>
			    </div>
			</div>
			
			<!-- End: "Refresh" balloon -->
			
			<!-- "Processing..." dialog -->
			
			<div id="LoadingDialog" class="progress-overlay" style="display: none">
			    <div class="progress-overlay-indicator">
			        <i class="fa fa-refresh fa-spin"></i>
			    </div>
			</div>
			
			<!-- End: "Processing..." dialog -->
			
			<!-- "Find/Replace" dialog -->
			
			<dw:ContextMenu ID="cmFind" runat="server" OnShow="FindDialog.initialize(); FindDialog.setSearchText(); FindDialog.updateFindState();" OnHide="FindDialog.finalize();">
			    <div id="pSearch" class="search-panel">
			        <table border="0">
			            <tr>
			                <td class="field-title">
			                    <dw:TranslateLabel ID="lbFindWhat" Text="Find what:" runat="server" />
			                </td>
			                <td>
			                    <input type="text" class="search-box" onkeypress="return FindDialog.searchTextChanged(event.keyCode);" 
			                        onkeyup="FindDialog.updateFindState();" id="txFind" value="" />
			                </td>
			                <td>
			                    <table border="0">
			                        <tr>
			                            <td>
			                                <span class="search-button button-find">
			                                    <dw:Button Name="Find text" OnClick="FindDialog.executeFindNext(true); return false;" runat="server" />
			                                </span>
			                            </td>
			                        </tr>
			                    </table>
			                </td>
			                <td align="right">
			                    <i id="imgClose" class="fa fa-close color-warning" style="cursor: pointer; margin-top: 1px" runat="server"></i>
			                </td>
			            </tr>
			            <tr>
			                <td class="field-title">
			                    <label for="chkMatchCase">
			                        <dw:TranslateLabel ID="lbMatchCase" Text="Match case" runat="server" />
			                    </label>
			                </td>
			                <td>
			                    <input type="checkbox" id="chkMatchCase" style="margin: 0px; padding: 0px; width: 16px" value="True" />
			                </td>
			            </tr>
			            <tr id="pReplaceText">
			                <td colspan="4">
			                    <div class="search-replace-link" onclick="FindDialog.showReplace();">
			                        <dw:TranslateLabel ID="lbReplace" Text="Replace..." runat="server" />
			                    </div>
			                </td>
			            </tr>
			            <tr id="pReplace" style="display: none" valign="top">
			                <td class="field-title" style="padding-top: 4px">
			                    <dw:TranslateLabel ID="lbReplaceWith" Text="Replace with:" runat="server" />
			                </td>
			                <td style="padding-top: 4px">
			                    <input type="text" class="search-box" onkeypress="return FindDialog.replaceTextChanged(event.keyCode);" 
			                        id="txReplace" value="" />
			                </td>
			                <td>
			                    <table border="0">
			                        <tr>
			                            <td>
			                                <span class="search-button button-replace">
			                                    <dw:Button ID="cmdReplace" Name="Replace" OnClick="FindDialog.executeReplace(true); return false;" runat="server" />
			                                </span>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td>
			                                <span class="search-button button-replace-all">
			                                    <dw:Button ID="cmdReplaceAll" Name="Replace all" OnClick="FindDialog.executeReplaceAll(true); return false;" runat="server" />
			                                </span>
			                            </td>
			                        </tr>
			                    </table>
			                </td>
			            </tr>
			        </table>
			    </div>
			</dw:ContextMenu>
			
			<!-- End: "Find/Replace" dialog -->
            
            <dw:Dialog ID="SaveAsDialog" runat="server" Size="Medium" ShowOkButton="true" ShowCancelButton="true" Title="Save as" OkAction="SaveAsDialog.ok();">
                <dwc:GroupBox runat="server" Title="Save as">
                    <div class="form-group">
	                    <label class="control-label"><dw:TranslateLabel runat="server" Text="Folder" /></label>                        
                        <dw:FolderManager ID="txDirectory" Name="txDirectory" Folder="" runat="server" />
	                </div>
                    <dwc:InputText runat="server" Label="File" ID="txFileName" ClientIDMode="Static" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="XsltDialog" runat="server" Size="Medium" ShowOkButton="true" ShowCancelButton="true" Title="XSLT parse error" OkText="Save anyway" OkAction="XsltDialog.ok(); reloadFileList();">
                <dw:Infobar runat="server" Message="Data at the root level is invalid. Line 1, position 1." Type="Error" ID="errorInfobar" TranslateMessage="false"></dw:Infobar>
            </dw:Dialog>
		</form>
		
		<!-- End: Form -->
				
		<!-- Messages -->
		
		<span id="mClipboardNotAllowed" style="display: none"><dw:TranslateLabel id="lbClipboardNotAllowed" runat="server" Text="Clipboard operations are not allowed due to your browser security settings." /></span>
		<span id="mDirectoryDoesNotExist" style="display: none"><dw:TranslateLabel id="lbDirectoryDoesNotExist" runat="server" Text="Directory_does_not_exist." /><dw:TranslateLabel ID="lbDirCreate" runat="server" Text="Opret" />?</span>
		<span id="mFileExists" style="display: none"><dw:TranslateLabel id="lbFileExists" Text="Filen_findes_i_forvejen" runat="server" />.<dw:TranslateLabel id="lbOverwrite" Text="Overskriv?" runat="server" /></span>
		<span id="mAjaxError" style="display: none"><dw:TranslateLabel id="lbAjaxError" runat="server" Text="The current operation could not be completed. Please try again later." /></span>
		<span id="mUnableToSaveFile" style="display: none"><dw:TranslateLabel ID="lbUnableToSave" runat="server" Text="An error occured while saving the file." /></span>
		<span id="mTags" style="display: none"><dw:TranslateLabel id="lbTags" runat="server" Text="Tags" /></span>
		<span id="mNoTagsFound" style="display: none"><dw:TranslateLabel id="lbNoTagsFound" runat="server" Text="Ikke_fundet" /></span>
		<span id="mSearchingDone" style="display: none"><dw:TranslateLabel ID="lbSearchingDone" runat="server" Text="Søgningen_er_udført." /></span>
		<span id="mReplaced" style="display: none"><dw:TranslateLabel ID="lbReplaced" runat="server" Text="Occurrences replaced: %%" /></span>
		<span id="mSaveAsDialogTitle" style="display: none"><dw:TranslateLabel id="lbSaveAsDialogTitle" Text="Save as" runat="server" /></span>
		<span id="mXsltDialogTitle" style="display: none"><dw:TranslateLabel id="lbXsltDialogTitle" Text="XSLT parse error" runat="server" /></span>
		<span id="mSaveOK" style="display: none"><dw:TranslateLabel id="lbSaveOK" Text="OK" runat="server" /></span>
		<span id="mSaveAnyway" style="display: none"><dw:TranslateLabel id="lbSaveAnyway" Text="Save anyway" runat="server" /></span>
		<span id="mNoFile" style="display: none"><dw:TranslateLabel id="lbNoFile" Text="Ny_fil" runat="server" /></span>
		<span id="mPageTitle" style="display: none"><dw:TranslateLabel id="lbPageTitle" Text="Rediger" runat="server" /></span>
		<span id="mConvertConfirm" style="display: none"><dw:TranslateLabel d="lbConvertConfirm" Text="Are you sure you want to convert this file (this operation can not be undone) ?" runat="server" /></span>
		<span id="mConvertResult" style="display: none"><dw:TranslateLabel runat="server" Text="Some tags are not parsed, and needs to be handled by hand" /></span>
		
		<!-- End: Messages  -->
	</body>
</html>

<% Translate.GetEditOnlineScript() %>
