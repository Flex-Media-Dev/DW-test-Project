<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Preview.aspx.vb" Inherits="Dynamicweb.Admin.Preview" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><dw:TranslateLabel runat="server" Text="Preview" /></title>
	<dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true"/>
	<link rel="StyleSheet" href="Preview.css" type="text/css" />
	<script type="text/javascript" src="Preview.js">
	</script>
    <script>
      document.addEventListener('DOMContentLoaded', function () {
        window.previewVariation = new PreviewVariation();
    });
    </script>
</head>
<body>
	<form action="">
	<input type="hidden" id="testurl" value="<%=Dynamicweb.Context.Current.Request("original") %>" />
	</form>
    <header id="header" class="preview__header">
            <div class="preview__header-logo">
                <a href="/">
                    <img width="28" src="/Admin/Resources/img/DWLogoStar.svg" alt="Logo" />
                </a>
            </div>
            <div class="preview__content">
		        <div class="preview__variation preview__variation--label" runat="server" id="previewHeading" ></div>
		        <div class="preview__variation"><a href="javascript:window.previewVariation.test('1');" class="active" id="link1"><%= Dynamicweb.SystemTools.Translate.Translate("Original")%></a></div>
		        <div class="preview__variation"><a href="javascript:window.previewVariation.test('2');" class="" id="link2"><%= Dynamicweb.SystemTools.Translate.Translate("Variants")%></a></div>
            </div>
        </header>
	<div style="position:fixed;top:32px;bottom:0px;right:0px;left:0px;">
		<iframe id="previewFrame" src="<%=Dynamicweb.Context.Current.Request("original") %>&variation=1" style="border:0;width:100%;height:100%;">
	</iframe>
	</div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
