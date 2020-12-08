<%@ Page Language="vb" AutoEventWireup="false" codePage="65001"%>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Import namespace="Dynamicweb.Content.Files" %>
<%@ Import namespace="Dynamicweb.Core.Helpers" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<%
    Dim tmpHTML As String = String.Empty
    Dim File As String = String.Empty
    Dim c As String = String.Empty
    Dim Folder As String = String.Empty
    Dim wh As String = String.Empty
    Dim size As String = String.Empty
    Dim d As String = String.Empty
    Dim FilePath As String = String.Empty
    Dim FilePathEncode As String = String.Empty
    Dim ext As String = String.Empty
    Dim height As String = String.Empty
    Dim width As String = String.Empty
    Dim documentTitle As String = String.Empty
    Dim blnFileNotFound As Boolean = False
    Dim hasAccessToEdit As Boolean = False

    If Not IsNothing(Request.QueryString("File")) Then
        Session.CodePage = 1252
        File = Request.QueryString("File")
        Folder = Request.QueryString("Folder")
        ext = LCase(IO.Path.GetExtension(File))

        If File.StartsWith("/") Then
            File = File.TrimStart({"/"c})
        End If
        FilePath = "/Files/" & Folder & "/" & File
        FilePathEncode = "/Files/" & Folder & "/" & HttpUtility.UrlEncode(File).Replace("+", " ")
        FilePath = Replace(FilePath, "//", "/")
        FilePathEncode = Replace(FilePathEncode, "//", "/")

        Folder = FilePath.Substring(0, FilePath.LastIndexOf("/"c))
        hasAccessToEdit = Permission.HasWriteAccess(Folder.Substring("/Files".Length))

        If ext = ".gif" Or ext = ".jpg" Or ext = ".jpeg" Or ext = ".png" Or ext = ".bmp" Or ext = ".webp" Then
            tmpHTML = "<img id=""Image"" class=""imageFullSize"" src=""" & FilePathEncode & "?" & Date.Now().Millisecond & """>"
            documentTitle = "Billedpreview"
        ElseIf ext = ".htm" Or ext = ".html" Then
            tmpHTML = TextFileHelper.ReadTextFile(Server.MapPath(FilePath))
            documentTitle = "Document preview"
        ElseIf ext = ".pdf" Then
            tmpHTML = String.Format("<embed id=""Image"" height=""100%"" width=""100%"" pluginspage=""http://www.adobe.com/products/acrobat/readstep2.html"" src=""{0}"" type=""application/pdf"">", FilePathEncode)
            documentTitle = "Document preview"
        ElseIf ext = ".tiff" Or ext = ".tif" Or ext = ".psd" Or ext = ".eps" Or ext = ".ai" Then
            tmpHTML = "<img id=""Image"" class=""imageFullSize"" src=""/Admin/Public/GetImage.ashx?width=10000&amp;height=10000&donotupscale=1&amp;image=" & FilePathEncode & "&amp;modified=" & Date.Now().Millisecond & """>"
            documentTitle = "Billedpreview"
        End If

        If ext = ".gif" Or ext = ".jpg" Or ext = ".jpeg" Or ext = ".png" Or ext = ".bmp" Then
            If IO.File.Exists(Server.MapPath(FilePath)) Then
                Dim imgfullSizeImg As System.Drawing.Image = Nothing
                Try
                    imgfullSizeImg = System.Drawing.Image.FromFile(Server.MapPath(FilePath))
                Catch ex As OutOfMemoryException
                    Response.Write("This file is not an image")
                    Response.End()
                End Try

                height = imgfullSizeImg.Height
                width = imgfullSizeImg.Width
                wh = Translate.Translate("%w% x %h%", "%w%", width, "%h%", height)
                imgfullSizeImg.Dispose()

                Dim image As System.IO.FileInfo = New System.IO.FileInfo(Server.MapPath(FilePath))
                size = Math.Round(image.Length / 1024).ToString()
                d = image.LastWriteTime().ToShortDateString()
            Else
                blnFileNotFound = True
            End If
        ElseIf ext = ".pdf" Then
            width = "800"
            height = "600"
            wh = String.Empty
        Else
            width = "0"
            height = "0"
            wh = String.Empty
        End If

        Session.CodePage = 65001
    End If%>
<%if blnFileNotFound Then%>
<SCRIPT language='JavaScript'>
	alert('<%=Translate.JsTranslate("Filen er ikke fundet")%>');
	window.close();
</SCRIPT>
<%End If%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="FileManager_Preview.css" rel="stylesheet" type="text/css" />
<dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
<title><%=Translate.JsTranslate("FileManager")%></title>
<script type="text/javascript">
var winOpener = opener;
var picWidth = <%=width%>;
var picHeight = <%=height%>;

function ResizeWin() {
	var resWidth = 700;
	var resHeight = 700;
    
	try {
		if (picWidth > resWidth) {
			resWidth = picWidth + 32;
		}
		if (picHeight > resHeight) {
			//resHeight = picHeight;
			resHeight = picHeight + 100;
		}	
	} catch(e) {
		//Nothing
	}	
	
	window.resizeTo(resWidth,resHeight)
}
window.onload= ResizeWin
</script>
</head>
<body style="margin:0px;">
        <%If ext = ".gif" Or ext = ".jpg" Or ext = ".png" Or ext = ".bmp" Or ext = ".pdf" Or ext = ".swf" Or ext = ".webp" Then%>
            <div id="wrapperImage">
		            <div id="imagearea">
			            <%=tmpHTML%>
		            </div>
            </div>
       <%Else %>
            <div id="wrapperFile">
		        <div id="filearea">
			        <%=tmpHTML%>
		        </div>
            </div>
	        <div id="statusBar">
		        <span class="statusBarItem"><span><%= FilePath%></span></span>		
	        </div>
      <%End If%>
</body>
</html>
<%
    Translate.GetEditOnlineScript()
%>