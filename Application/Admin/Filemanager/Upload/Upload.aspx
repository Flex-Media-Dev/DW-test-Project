<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="Upload.aspx.vb" Inherits="Dynamicweb.Admin.Upload" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<!DOCTYPE html>

<html>
    <head runat="server">
       <title>
		    <dw:TranslateLabel ID="lbTitle" runat="server" Text="Upload" />
	    </title>
        <dw:ControlResources runat="server" IncludePrototype="true" IncludeScriptaculous="false" />
        <script type="text/javascript" src="js/dropzone.min.js"></script>
        <script type="text/javascript" src="js/Upload.js"></script> 
        <script src="/Admin/Resources/js/layout/notiFire.js"></script>
        <link type="text/css" rel="stylesheet" href="dropzone.min.css" />
        <link type="text/css" rel="stylesheet" charset="utf-8" href="Upload.css" />
        <link type="text/css" rel="Stylesheet" charset="utf-8" href="/Admin/Images/Ribbon/UI/List/List.css" />

        <script type="text/javascript">

            document.observe('dom:loaded', function () {
                Dropzone.autoDiscover = false;
                uploadManager.init({targetFolder: "<%=Folder%>"});
            });

        </script>

    </head>
    
    <body>
        <dw:Infobar Message="" runat="server" Type="Information" Title="No write permissions" ID="noAccessWarning" Visible="False"></dw:Infobar>
        <form id="MainForm" runat="server" enctype="multipart/form-data">
            <dw:Ribbonbar runat="server" ID="Toolbar" HelpKeyword="module.filemanager.upload">
	            <dw:RibbonbarTab ID="tabEditor" Active="true" Name="Upload" runat="server">
	                <dw:RibbonbarGroup ID="groupFile" Name="Upload" runat="server">
	                    <dw:RibbonbarButton ID="cmdUpload" Icon="Upload" Size="Large" OnClientClick="uploadManager.startUpload();" Disabled="true" Text="Upload" runat="server" />
	                </dw:RibbonbarGroup>
	                <dw:RibbonbarGroup ID="groupUpload" Name="Files" runat="server">
	                    <dw:RibbonBarButton ID="cmdSelectFile" Icon="AttachFile" Size="Large" Text="Vælg fil" runat="server" />
                        <dw:RibbonbarButton ID="cmdRemoveSelected" Icon="TimesCircleO" IconColor="Default" Disabled="true" OnClientClick="uploadManager.removeSelectedFiles();" Size="Small" Text="Remove selected" runat="server" />
                        <dw:RibbonbarButton ID="cmdRemoveAll" Icon="Remove" IconColor="Default" OnClientClick="uploadManager.removeFiles();" Size="Small" Text="Remove all" Disabled="true" runat="server" />
                        <dw:RibbonBarCheckbox ID="chkOverwriteFiles" Text="Overwrite" Size="Small" Icon="CheckCircleO" IconColor="Default" runat="server" RenderAs="FormControl" />
	                </dw:RibbonbarGroup>
	                <dw:RibbonBarGroup ID="grpImageSettings" Name="Billeder" runat="server">
	                    <dw:RibbonBarPanel ID="pImageSettings" ExcludeMarginImage="true" runat="server">
	                        <div id="groupImageSettings">
	                            <table border="0" cellspacing="0" cellpadding="0" style="height: 50px">
	                                <tr valign="top">
	                                    <td>
	                                        <table border="0" style="height: 50px">
	                                            <tr valign="top">
	                                                <td width="100">
	                                                    <dw:TranslateLabel ID="lbQuality" Text="Quality" runat="server" />
	                                                </td>
	                                                <td>
	                                                    <select id="ddQuality" class="std" style="width: 50px">
	                                                        <option value="10">10</option>
	                                                        <option value="20">20</option>
	                                                        <option value="30">30</option>
	                                                        <option value="40">40</option>
	                                                        <option value="50">50</option>
	                                                        <option value="60">60</option>
	                                                        <option value="70">70</option>
	                                                        <option value="80">80</option>
	                                                        <option value="90">90</option>
	                                                        <option value="100" selected="selected">100</option>
	                                                    </select>
	                                                </td>
	                                            </tr>
	                                            <tr valign="top">	                                                
	                                                <td colspan="2">
                                                        <dw:RibbonBarCheckbox runat="server" ID="chkResize" OnClientClick="uploadManager.set_groupIsEnabled('rowDimensions', this.checked);" Text="Resize images" RenderAs="FormControl" Size="Small"></dw:RibbonBarCheckbox>
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </td>
	                                    <td style="width: 25px">
	                                        &nbsp;
	                                    </td>
	                                    <td>
	                                        <table border="0" id="rowDimensions" style="height: 50px">
                                                <tr valign="top">
                                                    <td width="100">
                                                        <dw:TranslateLabel ID="lbWidth" Text="Max width" runat="server" />
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txImageWidth" class="std" style="width: 50px" />
                                                    </td>
                                                </tr>
                                                <tr valign="top">
                                                    <td>
                                                        <dw:TranslateLabel ID="lbHeight" Text="Max height" runat="server" />
                                                    </td>
                                                    <td>
                                                        <input type="text" id="txImageHeight" class="std" style="width: 50px" />
                                                    </td>
	                                            </tr>
	                                        </table>
	                                    </td>
	                                </tr>
	                            </table>
	                        </div>
	                    </dw:RibbonBarPanel>
	                </dw:RibbonBarGroup>
	                <dw:RibbonBarGroup ID="grpArchiveSettings" Name="File archives" runat="server">
	                    <dw:RibbonBarPanel ID="pArchiveSettings" ExcludeMarginImage="true" runat="server">
                            <div id="groupArchiveSettings">
                                <dw:RibbonBarCheckbox ID="chkExtractArchives" OnClientClick="uploadManager.set_groupIsEnabled('rowCreateFolders', this.checked);" RenderAs="FormControl" runat="server" Size="Small" Text="Extract archives">
                                </dw:RibbonBarCheckbox>
                                <div id="rowCreateFolders">
                                    <dw:RibbonBarCheckbox ID="chkCreateFolders" RenderAs="FormControl" runat="server" Size="Small" Text="Create folders"> 
                                    </dw:RibbonBarCheckbox>
                                </div>
                            </div>	                        
	                    </dw:RibbonBarPanel>
	                </dw:RibbonBarGroup>
	            </dw:RibbonbarTab>
            </dw:Ribbonbar>
    	   
    	   <div id="divLocation" runat="server"></div>
        </form>
   	   
    	   <div class="list">
			    <ul id="listHeader">
				    <li class="header">
					    <span class="C1">
					        <input id="chkAll" disabled="disabled" onclick="uploadManager.selectAllFiles(this.checked);" type="checkbox" runat="server" />
					    </span>
                        <span class="pipe"></span><span class="C2"></span> 
					    <span class="pipe"></span><span class="C3"><dw:TranslateLabel ID="lbFileName" Text="Navn" runat="server" /></span> 
					    <span class="pipe"></span><span class="C4"><dw:TranslateLabel ID="lbFileSize" Text="Size" runat="server" /></span>
					    <span class="pipe"></span><span class="C5"><dw:TranslateLabel ID="lbModified" Text="Modified" runat="server" /></span>                         
					    <span class="pipe"></span><span class="C5"><dw:TranslateLabel ID="lbStatus" Text="Status" runat="server" /></span>
					    <span class="pipe"></span><span class="C6"><dw:TranslateLabel ID="lbDelete" Text="Remove" runat="server" /></span> 
				    </li>
			    </ul>
			    
			    <div id="itemsContainer" class="itemsContainer">
			        <div class="itemsWrapper">
		                <ul id="items">
		                    <li id="templateItem">
		                        <span class="C1">
		                            <input type="checkbox" />
		                        </span> 
		                        <span class="C2">
                                    <img data-dz-thumbnail />
		                        </span>
		                        <span class="C3" data-dz-name>
		                        </span>
		                        <span class="C4" data-dz-size>
		                        </span>
		                        <span class="C5" data-dz-modified>
		                        </span>
		                        <span class="C5">
<%--		                            <span class="uploadStatusCustom"></span>--%>
		                            <span class="progressBackground">
		                                <span class="progressFill" style="width:0%;" data-dz-uploadprogress></span>
		                            </span>
		                            <i class="uploadStatus"></i>
		                        </span>
		                        <span class="C6">
                                    <i data-dz-remove class="fa fa-times color-danger" style="cursor: pointer" ></i>
		                        </span>
		                    </li>
		                </ul>
		            </div>
		        </div>
    	    </div>
  
	    
            <div id="statusBar">
		       <span class="statusBarItem">
                    <i class="<% KnownIconInfo.ClassNameFor(KnownIcon.FileO, True) %>"></i>
		            <span id="uploadstatus-filecount">0</span>
                    <dw:TranslateLabel runat="server" Text="Files" />
		        </span>
		        <img src="/Admin/Images/Nothing.gif" class="seperator" alt="" />
		        <span class="statusBarItem">
                    <i class="<% KnownIconInfo.ClassNameFor(KnownIcon.Settings, True) %>"></i>
	                <span id="uploadstatus-size">0&nbsp;kb</span>
		        </span>
		        <img src="/Admin/Images/Nothing.gif" class="seperator" alt="" />
		        <span id="progressGlobal" class="statusBarItem">
		            <span class="progressBackground">
                        <span class="progressFill" style="width: 0px"></span>
                    </span>
		        </span>
	        </div>

	        <span id="alreadyExistsLabel" style="display: none"><dw:TranslateLabel ID="lbAlreadyExists" Text="Filen_findes_i_forvejen" runat="server" /></span>
	        <span id="Message_Error_100" style="display: none"><dw:TranslateLabel id="lbError100" Text="You cannot add more files to the upload queue" runat="server" /></span>
	        <span id="Message_Error_110" style="display: none"><dw:TranslateLabel id="lbError110" Text="The file is too large" runat="server" /></span>
	        <span id="Message_Error_120" style="display: none"><dw:TranslateLabel id="lbError120" Text="The file cannot be added because it has a zero-byte size" runat="server" /></span>
	        <span id="Message_Error_130" style="display: none"><dw:TranslateLabel id="lbError130" Text="The file cannot be added because it is of an invalid type" runat="server" /></span>
            <span id="Message_FileWarning_1" style="display: none"><dw:TranslateLabel id="lbFileWarning1" Text="Warning! The file '%%' containing ',' character. You can't move or rename such files through the file manager. This file will be renamed." runat="server"/></span>
	        <span id="Message_FileWarning_2" style="display: none"><dw:TranslateLabel id="lbFileWarning2" Text="Warning! The file '%%' containing ';' character. You can't move or rename such files through the file manager. This file will be renamed." runat="server"/></span>
            <span id="Message_FileWarning_3" style="display: none"><dw:TranslateLabel id="lbFileWarning3" Text="Warning! The file '%%' containing '+' character. This file will be renamed." runat="server"/></span>
            <span id="Message_FileWarning_4" style="display: none"><dw:TranslateLabel id="lbFileWarning4" Text="Warning! The option {Replace spaces with '-'} set 'on'.The '%%' file will be renamed." runat="server"/></span>
            <span id="Message_FileWarning_5" style="display: none"><dw:TranslateLabel id="lbFileWarning5" Text="Warning! The option {Normalize latin characters} set 'on'.The '%%' file will be renamed." runat="server"/></span>
            <span id="Message_FileWarning_6" style="display: none"><dw:TranslateLabel id="lbFileWarning6" Text="Warning! The file '%%' containing ' character. This file will be renamed." runat="server"/></span>
            <span id="Message_FileWarning_7" style="display: none"><dw:TranslateLabel id="lbFileWarning7" Text="Warning! The file '%%' containing '#' character. This file will be renamed." runat="server"/></span>
            <span id="Message_Validate_1" style="display: none"><dw:TranslateLabel id="lbValidate1" Text="Must specify max width or max height" runat="server"/></span>
	        
	        <input type="hidden" id="statePreviousLocation" value="" />
	        <input type="hidden" id="stateIsAllowedToOverwriteFiles" value="" runat="server" />
	        <input type="hidden" id="stateIsAllowedToChangeLocation" value="" runat="server" />
	        <input type="hidden" id="stateIsUploading" value="false" />
	        <input type="hidden" id="stateTotalUploaded" value="0" />
	        <input type="hidden" id="stateCurrentlyUploaded" value="0" />
	        <input type="hidden" id="stateCurrentlyMaximumToUpload" value="0" />
	        <input type="hidden" id="stateOnLoad" value="" runat="server" />
	        <input type="hidden" id="fileSizeLimit" value="500" />


        <script type="text/javascript" language="javascript">
            var winOpener = opener;
            function reloadFileList() {
                if (typeof (winOpener) != 'undefined' && winOpener) {
                    if (Ribbon.isChecked('chkExtractArchives')) {
                        winOpener.reloadPage(true);
                    }
                    else winOpener.reloadPage();
                }
            }

            <% If Request("refresh-content") = "1" Then%>
            reloadFileList();
            window.close();
            <% End If %>
        </script>
    </body>
    
    <%Translate.GetEditOnlineScript()%>
</html>
