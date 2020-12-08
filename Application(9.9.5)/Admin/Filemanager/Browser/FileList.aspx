<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="FileList.aspx.vb" Inherits="Dynamicweb.Admin.FileList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Security.Permissions" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <meta name="pinterest" content="nopin" />
    <link href="EntryContent.css" rel="stylesheet" type="text/css" />
    <link href="/Admin/Filemanager/Upload/dropzone.min.css" rel="stylesheet" />
    <script type="text/javascript"> var ImagesFolderName = '<%=Dynamicweb.Content.Files.FilesAndFolders.GetImagesFolderName()%>';</script>
    <script type="text/javascript" src="EntryContent.js"></script>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script src="/Admin/Resources/js/layout/Actions.js"></script>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <script type="text/javascript">
        function reloadPage(navigatorSync) {
            var loc = location.href;
            if (navigatorSync) {
                location.href = FileManagerPage.updateURLParameter(loc, "NavigatorSync", "parentrefreshandselect");
            } else {
                location.href = loc;
            }
        }

        var __page = new FileManagerPage();

        function showLoading() {
            var __o = new overlay('__fmOverlay');
            __o.message('<%=Translate.JSTranslate("Loading")%>');
            __o.show();
        }

        function hideLoading() {
            var __o = new overlay('__fmOverlay');
            __o.hide();
        }
    </script>
    <script type="text/javascript" src="FileListThumbnailView.js"></script>
    <script type="text/javascript" src="FileList.js"></script>
    <script src="/Admin/Filemanager/Upload/js/dropzone.min.js"></script>
    <script src="/Admin/Resources/js/layout/Notifire.js"></script>
    <script type="text/javascript">
        function applyImageSettings() {
            dialog.hide('ImageSettingsDialog');
        }

        __page.onHelp = function () {
            <%=Gui.HelpPopup("filemanager", "modules.filearchive.general")%>
        }
        __page.folder = '<%=HttpUtility.JavaScriptStringEncode(Request("Folder"))%>';
        __page.deleteMsg = '<%=Translate.JsTranslate("Delete this file")%>';
        __page.restoreMsg = '<%=Translate.JsTranslate("Restore this file")%>';
        __page.deleteSeveralFilesMsg = '<%=Translate.JSTranslate("WARNING!")%>\n<%=Translate.JSTranslate("References to files will not be updated!")%>\n\n<%=Translate.JsTranslate("Delete selected files")%>';
        __page.restoteSeveralFilesMsg = '<%=Translate.JsTranslate("Restore selected files")%>';
        __page.thumbnailView = new ThumbnailView();

        <%  If _listMode = ListMode.Thumbnails Then %>
        __page.thumbnailView.enabled = true;
        <%End If%>
        __page.hasAccessEdit = <%=FolderPermissionLevel.HasPermission(PermissionLevel.Edit).ToString().ToLowerInvariant()%>;
        __page.hasAccessCreate = <%=FolderPermissionLevel.HasPermission(PermissionLevel.Create).ToString().ToLowerInvariant()%>;
        __page.hasAccessDelete = <%=FolderPermissionLevel.HasPermission(PermissionLevel.Delete).ToString().ToLowerInvariant()%>;

        <% If Not String.IsNullOrEmpty(Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower()) Then %>
        var utf8_to_b64 = function (str) {
            return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function(match, p1) {
                return String.fromCharCode('0x' + p1);
            }));
        };

        var getRefreshData = function(level) {
            var ancestors = [];
            var arr = __page.folder.split("/");
            var tempFolder = "";
            ancestors.push("");

            for (var i = 0; i < arr.length; i ++) {
                var item = arr[i];
                if (!item) {
                    continue;
                }
                tempFolder += "/" + item;
                ancestors.push(utf8_to_b64(tempFolder));
            }

            var start = ancestors.length - level;
            start = start < 0 ? 0 : start;

            var toReload = [];
            for (var i = start; i < ancestors.length; i ++) {
                toReload.push(ancestors[i]);
            }
            return {
                ancestors: ancestors,
                toReload: toReload
            };
        };

        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshandselect" Then %>
        var obj = getRefreshData(1);
        dwGlobal.getFilesNavigator().expandAncestors(obj.ancestors, obj.toReload);
        <%ElseIf Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "parentrefreshandselect" Then %>
        var obj = getRefreshData(2);
        dwGlobal.getFilesNavigator().expandAncestors(obj.ancestors, obj.toReload);
        <%End If%>
        <%End If%>

        function onContextMenuView(sender, arg) {
            if (__page.thumbnailView.enabled) {
                var selectedRows = __page.thumbnailView.getSelectedRows();
                if (__page.thumbnailView.rowIsSelected(arg.callingID) && selectedRows.length > 1) {
                    return "thumbnailMultiselect";
                }
                if (__page.isImage(arg.callingItemID)) {
                    return "thumbnailImage";
                }
                if (__page.isEditable(arg.callingItemID)) {
                    return "thumbnailEditable"
                }
                return "thumbnailSimple";
            }

            var selectedRows = List.getSelectedRows('Files');
            var row = List.getRowByID('Files', arg.callingID);
            if (List.rowIsSelected(row) && selectedRows.length > 1) {
                return "multiselect";
            }
            if (__page.isImage(arg.callingItemID)) {
                return "image";
            } 
            if (__page.isEditable(arg.callingItemID)) {
                return "editable"
            }
            return "simple";
        }

        function fileUpload() {
            var folderName = __page.folder.replace("\\", "/");
            dwGlobal.fileUpload(folderName, reloadPage);
        }

        function createFolder() {
            var act = <%=GetCreateFolderAction()%>;
            if (act) {
                Action.Execute(act);
            }
        }

        function renameFolder() {
            var act = <%=GetRenameFolderAction()%>;
            if (act) {
                Action.Execute(act);
            }
        }

        function createFile() {
            var act = <%=GetCreateFileAction()%>;
            if (act) {                
                Action.Execute(act);
            }
        }

        function renameFile() {
            var fileName = ContextMenu.callingItemID;
            var act = <%=GetCustomFileAction()%>;
            if (act) {
                act.Url = "/Admin/Files/Dialogs/RenameFile?File=" + fileName;
                Action.Execute(act);
            }
        }

        function copyFile() {
            var files = __page.GetSelectedFilesRow();
            var act = <%=GetCustomFileAction("{Selected}")%>;
            if (act) {
                act.Url = "/Admin/Files/Dialogs/CopyFile?File=" + files;
                Action.Execute(act);
            }
        }

        function moveFile() {
            var files = __page.GetSelectedFilesRow();
            var act = <%=GetCustomFileAction("{Selected}")%>;
            if (act) {
                act.Url = "/Admin/Files/Dialogs/MoveFile?File=" + files;
                Action.Execute(act);
            }
        }

        function OpenPermissionsDialog(securityFolder) {
            var act = <%=GetEditPermissionsAction()%>;
            if (act) {
                Action.Execute(act);
            }
        }

        function OpenPropertiesDialog() {
            dialog.show("PropertiesDialog", '/Admin/Filemanager/Browser/Properties.aspx?FilePath=' + encodeURIComponent(ContextMenu.callingItemID));
        }

        function showImageSettings() {
            var act = <%=GetEditImageSettingsAction()%>;
            if (act) {
                Action.Execute(act);
            }
        }

        function repeat(str, num) {
            return new Array(num + 1).join(str);
        }

        function fireEvent(element, event) {
            if (document.createEventObject) {
                // dispatch for IE
                var evt = document.createEventObject();
                return element.fireEvent('on' + event, evt)
            } 

            // dispatch for firefox + others
            var evt = document.createEvent("HTMLEvents");
            evt.initEvent(event, true, true);
            return !element.dispatchEvent(evt);
        }

        function btnFileEditClick() {            
            var selectedRows = __page.thumbnailView.getSelectedRows();
            if (selectedRows < 1) {
                selectedRows = List.getSelectedRows('Files');
            }

            var itemId = $(selectedRows[0]).getAttribute('itemid');
            if (selectedRows.length > 0) {
                if (__page.isImage(itemId)) {
                    FileManagerPage.editImage('ImageEditorDialog');
                }  else if (__page.isEditable(itemId)) {
                    __page.edit();
                }
            }
        }

        function SaveImageSettings() {
            var imageSettingsFrame = document.getElementById('ImageSettingsDialogFrame');
            var iFrameDoc = (imageSettingsFrame.contentWindow || imageSettingsFrame.contentDocument);
            
            iFrameDoc.save('saveAndClose');
        }

        function SavePermissionSettings() {
            var permissionsDialogFrame = document.getElementById('PermissionsDialogFrame');
            var iFrameDoc = (permissionsDialogFrame.contentWindow || permissionsDialogFrame.contentDocument);
            
            iFrameDoc.save();
        }

        function SaveMetafields() {
            var metafieldsDialogFrame = document.getElementById('MetafieldsDialogFrame');
            var iFrameDoc = (metafieldsDialogFrame.contentWindow || metafieldsDialogFrame.contentDocument);

            iFrameDoc.save('MetafieldsDialog');
            dialog.hide('MetafieldsDialog');
        }

        function SaveMetadata() {
            var metadataDialogFrame = document.getElementById('MetadataDialogFrame');
            var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);

            iFrameDoc.metaEditor.save();
            dialog.hide('MetadataDialog');
        }
    </script>

    <%If _listMode = ListMode.Thumbnails Then%>
    <style type="text/css">
        .list .container tbody[id] tr.listRow:hover {
            background-color: #ffffff;
        }

        .list .container tbody[id] tr.selected td {
            background-color: #ffffff;
        }

        .header {
            cursor: default;
            width: 100%;
        }

            .header .columnCell {
                width: 100%;
            }

        small {
            color: #999999;
        }
    </style>
    <%End If%>
</head>
<body class="screen-container area-orange">
    <dw:Overlay ID="__fmOverlay" runat="server"></dw:Overlay>
    <div class="card">
        <dw:RibbonBar ID="FilesRibbonBar" runat="server">
            <dw:RibbonBarTab ID="RibbonGeneralTab" Name="Content" runat="server" Visible="true">
                <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                    <dw:RibbonBarButton ID="btnRestore" Text="Restore" Title="Restore" Icon="Undo" Size="Large" DoTranslate="true" runat="server" OnClientClick="__page.restoreFile();" Disabled="true" Visible="false" />
                    <dw:RibbonBarButton ID="btnCopy" Text="Copy" Title="Copy" Icon="Copy" Size="Small" DoTranslate="true" runat="server" OnClientClick="copyFile();" Disabled="true" />
                    <dw:RibbonBarButton ID="btnMove" Text="Move" Title="Move" Icon="ArrowRight" Size="Small" DoTranslate="true" runat="server" OnClientClick="moveFile();" Disabled="true" />
                    <dw:RibbonBarButton ID="btnDelete" Text="Delete" Title="Delete" Icon="Delete" Size="Small" DoTranslate="true" runat="server" OnClientClick="__page.deleteFile();" Disabled="true" />
                    <dw:RibbonBarButton ID="btnMetatags" Text="Metatags" Title="Metatags" Icon="Label" DoTranslate="true" Size="Small" runat="server" OnClientClick="__page.metadata('MetadataDialog');" Disabled="true" />
                    <dw:RibbonBarButton ID="btnFileEdit" Text="Edit" Title="Edit" Icon="Pencil" DoTranslate="true" Size="Small" runat="server" OnClientClick="btnFileEditClick();" Disabled="true" />
                    <dw:RibbonBarButton ID="btnFileRename" Text="Rename" Title="Rename" Icon="Edit" DoTranslate="true" Size="Small" runat="server" OnClientClick="renameFile();" Disabled="true" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroupInsert" Name="Insert" runat="server">
                    <dw:RibbonBarButton ID="btnUploadDialog" Text="Upload" Title="Upload" Icon="Upload" DoTranslate="true" Size="Large" runat="server" OnClientClick="fileUpload();" />
                    <dw:RibbonBarButton ID="btnNewFile" Text="New file" Title="New file" DoTranslate="true" Icon="PlusSquare" Size="Small" runat="server" OnClientClick="createFile();" />
                    <dw:RibbonBarButton ID="btnUpload" Text="Upload manager" Title="Upload" Icon="Upload" DoTranslate="true" Size="Small" runat="server" OnClientClick="__page.upload();" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="View" runat="server">
                    <dw:RibbonBarRadioButton ID="rbDetailsView" Text="Details" Icon="Toc" DoTranslate="true" Size="Small" runat="server" OnClientClick="__page.setListMode('Details');" Group="View" />
                    <dw:RibbonBarRadioButton ID="rbThumbnailsView" Text="Thumbnails" Icon="ThLarge" DoTranslate="true" Size="Small" runat="server" OnClientClick="__page.setListMode('Thumbnails');" Group="View" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup4" Name="Folder" runat="server">
                    <dw:RibbonBarButton ID="btnNewSubfolder" Text="New subfolder" Title="New subfolder" DoTranslate="true" Icon="PlusSquare" IconColor="Default" Size="Small" runat="server" OnClientClick="createFolder();" />
                    <dw:RibbonBarButton ID="btnRename" Text="Omdøb" Title="Omdøb" OnClientClick="renameFolder();" DoTranslate="true" Icon="PencilSquareO" Size="Small" runat="server" />
                    <dw:RibbonBarButton ID="btnPermissions" Text="Permissions" Title="Permissions" Icon="Lock" DoTranslate="true" Size="Small" runat="server" />
                    <dw:RibbonBarButton ID="btnTranslateTemplate" Visible="False" Icon="Language" Size="Small" Text="Oversættelse" runat="server" OnClientClick="__page.translateTemplate();" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup ID="RibbonBarGroup5" Name="Settings" runat="server">
                    <dw:RibbonBarButton ID="btnImageSettings" Text="Image settings" Title="Resize images" Size="Small" Icon="Image" DoTranslate="true" runat="server" OnClientClick="showImageSettings();" />
                    <dw:RibbonBarButton ID="btnMetafields" Text="Metafields" Title="Metafields" Size="Small" Icon="Label" DoTranslate="true" runat="server" OnClientClick="__page.metafields('MetafieldsDialog');" />
                </dw:RibbonBarGroup> 
            </dw:RibbonBarTab>
        </dw:RibbonBar>

        <form id="form1" runat="server">
            <input id="FilesCurentPage" type="hidden" value="<%=pageNumber%>" />
            <input id="FilesSortBy" type="hidden" value="<%=SortBy%>" />
            <input id="FilesSortDir" type="hidden" value="<%=SortDir%>" />

            <asp:HiddenField ID="SortByState" runat="server" />
            <asp:HiddenField ID="SortDirState" runat="server" />

            <div id="listWrapper" class="<%=_listMode.ToString() %>">
                <dw:List runat="server" ID="Files" TranslateTitle="false" AllowMultiSelect="true" ShowPaging="true" OnClientSelect="rowSelected();" 
                    HandlePagingManually="false" HandleSortingManually="true">
                    <Filters>
                        <dw:ListTextFilter runat="server" ID="TextFilter" WaterMarkText="Search" Width="175" ShowSubmitButton="True" Divide="None" />
                        <dw:ListFlagFilter ID="SearchInSubfoldersFilter" runat="server" Label=" Search in subfolders" IsSet="false" Divide="none" LabelFirst="false" AutoPostBack="true" />
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="150" Label="Files per page" AutoPostBack="true" Priority="3" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="30" Value="30" Selected="true" DoTranslate="false" />
                                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                                <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                            </Items>
                        </dw:ListDropDownListFilter>
                    </Filters>
                </dw:List>
            </div>
        </form>

        <div runat="server" id="multiUploaderInlineContainer" style="min-height: 150px; padding: 20px; width: 100%; box-sizing: border-box;">
            <form action="/Admin/Filemanager/Upload/Store.aspx" class="dropzone" id="multiUploaderInline" enctype="multipart/form-data" method="post">
                <input type="hidden" name="TargetLocation" id="inlineTargetLocation" value="/Files<%=Request.QueryString("Folder") %>/" />
                <input type="hidden" name="AllowOverwrite" id="inlineAllowOverwrite" value="False" />
            </form>
        </div>

        <script type="text/javascript">
            Dropzone.options.multiUploaderInline = {
                autoProcessQueue:false,
                uploadMultiple:true,
                parallelUploads:3,
                dictDefaultMessage:"<%=String.Format("<i class='{0}' style='font-size:60px;'></i>", KnownIconInfo.ClassNameFor(KnownIcon.Upload, True))%><br><small><%=Translate.Translate("Drag files or click to upload")%></small>",
                init: function () {
                    var inlineDropzone = this;

                    this.on("queuecomplete", function () {
                        uploadDone();

                        notifire({ msg: 'Upload queue complete' });
                    });

                    this.on("addedfile", function (file) {
                        notifire({ msg: 'Uploading', id: 'upload-message' });
                    });

                    this.on("success", function (file, responseText, e) {
                        notifire({ msg: 'Upload complete', id: 'upload-message' });
                    });

                    this.on("error", function (file, responseText, e) {
                        notifire({ msg: 'Upload: Unhandled error', id: 'upload-message' });
                    });

                    this.on("totaluploadprogress", function (total, totalBytes, totalBytesSent) {
                        if (totalBytesSent > 0) {
                            notifire({ msg: 'Uploading ' + (100 * totalBytesSent / totalBytes), id: 'upload-message' });
                        }
                    });

                    this.on("addedfile", dwGlobal.debounce(function () {
                        checkUploadOverwriting(inlineDropzone, "inlineTargetLocation", "inlineAllowOverwrite");
                    }, 250));

                    this.on("successmultiple", function (file) {
                        this.processQueue();
                    });
                }
            };
        </script>

        <!-- Context menu start -->
        <dw:ContextMenu ID="FilesContext" runat="server" OnClientSelectView="onContextMenuView">
            <dw:ContextMenuButton ID="PreviewButton" runat="server" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                Icon="PageView" OnClientClick="__page.preview('contextmenu', 'PreviewDialog');" Text="Preview" />
            <dw:ContextMenuButton ID="EditImageButton" runat="server" Views="image,thumbnailImage"
                Icon="Pencil" Divide="Before" Text="Edit" OnClientClick="FileManagerPage.editImage('ImageEditorDialog');" />
            <dw:ContextMenuButton ID="EditButton" runat="server" Views="editable,thumbnailEditable"
                Icon="Pencil" Text="Edit" OnClientClick="__page.edit('FileEditorDialog');" />
            <dw:ContextMenuButton runat="server" ID="RenameFileButton" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                DoTranslate="True" Icon="Edit" Text="Omdøb" OnClientClick="renameFile();" />
            <dw:ContextMenuButton ID="CopyButton" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="ContentCopy" OnClientClick="copyFile();" Text="Copy" />
            <dw:ContextMenuButton ID="CopyHereButton" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="ContentCopy" OnClientClick="__page.copyHere();" Text="Copy here" />
            <dw:ContextMenuButton ID="MoveButton" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="ArrowRight" OnClientClick="moveFile();" Text="Move" />
            <dw:ContextMenuButton ID="OpenButton" runat="server" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                Divide="Before" Icon="OpenInNew" OnClientClick="FileManagerPage.open();" Text="Open in browser" />
            <dw:ContextMenuButton ID="DownloadButton" runat="server" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                Icon="Download" OnClientClick="return FileManagerPage.download();" Text="Download" />
            <%If Not SearchInSubfolders Then%>
            <dw:ContextMenuButton ID="MetatagsButton" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="Label" OnClientClick="__page.metadata('MetadataDialog');" Text="Metatags" />
            <%End If%>
            <dw:ContextMenuButton ID="DeleteButton" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="Delete" Divide="Before" Text="Delete" OnClientClick="__page.deleteFile();" />
            <dw:ContextMenuButton ID="PropertiesButton" runat="server" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                Divide="Before" Icon="InfoOutline" OnClientClick="OpenPropertiesDialog();" Text="Properties" />
        </dw:ContextMenu>

        <dw:ContextMenu runat="server" ID="ContextMenuFileTashBin" Translate="true" OnClientSelectView="onContextMenuView">
            <dw:ContextMenuButton ID="ContextMenuButton3" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="Redo" Text="Restore" OnClientClick="__page.restoreFile();" />
            <dw:ContextMenuButton ID="ContextMenuButton1" runat="server" Views="simple,editable,image,multiselect,thumbnailSimple,thumbnailEditable,thumbnailImage,thumbnailMultiselect"
                Icon="Delete" Text="Delete" OnClientClick="__page.deleteFile();" />
            <dw:ContextMenuButton ID="PropertiesButton1" runat="server" Views="simple,editable,image,thumbnailSimple,thumbnailEditable,thumbnailImage"
                Divide="Before" Icon="InfoOutline" OnClientClick="OpenPropertiesDialog();" Text="Properties" />
        </dw:ContextMenu>
        <!-- Context menu end -->

        <dw:Dialog ID="PropertiesDialog" runat="server" Title="Properties" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
            <iframe id="PropertiesDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <asp:Literal runat="server" ID="logContent" EnableViewState="false"></asp:Literal>
    </div>

    <div id="BottomInformationBg" class="card-footer" runat="server">
        <table border="0" cellpadding="0" cellspacing="0">
            <%If _folder <> "/GlobalSearch" Then%>
            <tr>
                <td align="right" width="50px;">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Navn" />
                        :</span>
                </td>
                <td width="150px">
                    <b id="_foldername" runat="server"></b>&nbsp;&nbsp;
                </td>
                <td align="right" width="150px">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Oprettet" />
                        :</span>
                </td>
                <td width="150px">
                    <span id="_created" runat="server"></span>
                </td>
                <td align="right" width="150px">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Resize settings" />
                        :</span>
                </td>
                <td width="150px">
                    <span id="resizeSettings" runat="server"></span>
                </td>
                <td></td>
            </tr>
            <tr>
                <td align="right">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Files" />
                        :</span>
                </td>
                <td>
                    <span id="_filescount" runat="server"></span>
                </td>
                <td align="right">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Redigeret" />
                        :</span>
                </td>
                <td colspan="4">
                    <span id="_edited" runat="server"></span>
                </td>
            </tr>
            <%Else%>
            <tr>
                <td rowspan="2" width="50px;">
                    <%= String.Format("<i class=""{0} fa-size fa-3x""></i>", KnownIconInfo.ClassNameFor(KnownIcon.FolderOpen, True, KnownColor.Folder)) %>                    
                </td>
                <td align="right" width="50px;"></td>
                <td width="150px"></td>
                <td align="right" width="150px"></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td align="right" width="50px;">
                    <span class="label">
                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Files" />
                        :</span>
                </td>
                <td>
                    <span id="_globalfilescount" runat="server"></span>
                </td>
            </tr>
            <%End If%>
        </table>
    </div>

    <dw:Dialog ID="PermissionsDialog" runat="server" Title="Edit permissions" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="SavePermissionSettings(); return false;">
        <iframe id="PermissionsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="PreviewDialog" runat="server" Title="Preview" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="PreviewDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="MetafieldsDialog" runat="server" Title="Metafields" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="SaveMetafields(); return false;">
        <iframe id="MetafieldsDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="MetadataDialog" runat="server" Size="Large" Title="Metadata" HidePadding="true" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" OkAction="SaveMetadata(); return false;">
        <iframe id="MetadataDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="ImageEditorDialog" runat="server" Size="Large" Title="Image editing" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="ImageEditorDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:Dialog ID="FileEditorDialog" runat="server" Size="Large" Title="File editing" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="FileEditorDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <%If _listMode = ListMode.Thumbnails Then%>
    <script type="text/javascript">
        //Remove empty columns and reset style for header 
        $("ListTable").firstDescendant("tr").down("td.columnCell", 1).remove();
        $("ListTable").firstDescendant("tr").down("td.columnCell", 1).remove();
        $("ListTable").firstDescendant("tr").down("td.columnCell", 1).remove();
    </script>
    <%Else%>
    <script type="text/javascript">
        var imgUrl = null;
        var modified = "";
        var imgPreviewObj = imagePopupPreview(400, 400);
        var imgClassName = ".fm_column_smallicon_thumbnail";
        var fn = dwGlobal.debounce(function() {
            if (imgUrl != null) {
                imgPreviewObj.show(imgUrl, modified)
            }
        }, 200);
        
        $("Files_body").on('mouseover', imgClassName, function(e, element) {
            imgPreviewObj.setPosition(e.pageX, e.pageY);
            imgUrl = "/Files" + element.up(".listRow").readAttribute("itemid");
            modified = element.up(".listRow").readAttribute("data-modified")
            fn();
        });

        $("Files_body").on('mouseout', imgClassName, function(e, element) {
            imgUrl = null;
            imgPreviewObj.hide();
        });
    </script>
    <%End If%>

    <script type="text/javascript">
        //Uncheck the checkbox
        var checkAll = $("chk_all_Files");
        if (checkAll) {
            checkAll.checked = false;
        }
        __page.initialize();

        function checkUploadOverwriting(dropzone, targetLocationId, allowOverwriteId) {
            var allowOverwrite = $(allowOverwriteId);
            var fileNames = "";
            var queuedFiles = dropzone.getQueuedFiles();
            var amountOfQueuedFiles = queuedFiles.length;
            queuedFiles.each(function(f){
                fileNames += f.name + "|";
            });

            new Ajax.Request("/Admin/Filemanager/Upload/Store.aspx", {
                parameters: {
                    cmd: "CheckFileIsExist",
                    targetLocation: $(targetLocationId).value,
                    files: fileNames
                },
                method: 'get',
                onSuccess: function (transport) {
                    if (transport.responseText.isJSON()) {
                        var response = transport.responseText.evalJSON();
                        if (response.FileExists) {
                            var hasNewFiles = response.Files.length != amountOfQueuedFiles;
                            var message = "<%=Translate.Translate("These files aready exists. Do you want to overwrite?")%>" + "<br/><ul>";
                            response.Files.each(function(f){ 
                                message += "<li>" + f + "</li>"; 
                            });
                            message += "</ul>";

                            var dlgAction = {
                                Url: "/Admin/CommonDialogs/Confirm?Caption=<%=Translate.Translate("Confirm overwrite")%>&Message=" + message + "&Buttons=3&SubmitOkTitle=Overwrite+files&SubmitCancelTitle=Do+not+overwrite",
                                Name: "OpenDialog",
                                OnSubmitted: {
                                    Name: "ScriptFunction",
                                    Function: function (act, model) {
                                        allowOverwrite.value = true;
                                        dropzone.processQueue();
                                    }
                                },
                                OnCancelled: {
                                    Name: "ScriptFunction",
                                    Function: function (act, model) {
                                        if (hasNewFiles) {
                                            allowOverwrite.value = false;
                                            dropzone.processQueue();
                                        } else {
                                            dropzone.removeAllFiles(true);
                                            notifire({ msg: 'Upload canceled', id: 'upload-message' });
                                        }
                                    }
                                }
                            };
                            Action.Execute(dlgAction);
                        } else {
                            dropzone.processQueue();
                        }
                    }
                }
            });
        }

        function uploadDone() {
            setTimeout(reloadPage, 1000);
        }
    </script>
    <%  Translate.GetEditOnlineScript()%>
</body>
</html>
