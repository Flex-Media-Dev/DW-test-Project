<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PreviewMailPage.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.PreviewMailPage" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<!DOCTYPE html>

<script type="text/javascript">
    function SelectVariant(variation) {
        document.getElementById("link1").className = "";
        document.getElementById("link2").className = "";

        document.getElementById("link" + variation).className = "active";

        var isVariant = variation == '1' ? false : true;

        var url = document.getElementById("testurl").value + '&variant=' + isVariant;
        document.getElementById("ifSplirPreview").src = url;
    }
</script>

<html>
<head id="Head2" runat="server">
    <title>
        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Preview" />
    </title>
</head>
<body>
    <form action="">
        <input type="hidden" id="testurl" value="/Admin/Module/OMC/Emails/PreviewMailPage.aspx?emailId=<%=Dynamicweb.Context.Current.Request("emailId") %>&userId=<%=Dynamicweb.Context.Current.Request("userId") %>" />
        <input type="hidden" id="hdHasSplitTest" value="False" runat="server" />
    </form>
    <%If Converter.ToBoolean(hdHasSplitTest.Value) Then%>
    <div class="header" id="splitHeader" runat="server">
        <h1 runat="server" id="previewHeading">
        </h1>
        <a href="javascript:SelectVariant('1');" class="active" id="link1"><%= Dynamicweb.SystemTools.Translate.Translate("Original")%></a>
        <a href="javascript:SelectVariant('2');" class="" id="link2"><%= Dynamicweb.SystemTools.Translate.Translate("Variants")%></a>
    </div>
    <%End If%>
    <div style="position: fixed; top: 43px; bottom: 0px; right: 0px; left: 0px;">
        <iframe id="ifSplirPreview" src="/Admin/Module/OMC/Emails/PreviewMailPage.aspx?emailId=<%=Dynamicweb.Context.Current.Request("emailId") %>&userId=<%=Dynamicweb.Context.Current.Request("userId") %>&variant=false" style="border: 0; width: 100%; height: 100%;"></iframe>
    </div>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
