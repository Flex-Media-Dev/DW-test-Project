<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Languages.aspx.vb" Inherits="Dynamicweb.Admin.Languages" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>
    <script type="text/javascript">
        function redo(onPageID) {
            if (confirm('<%=Dynamicweb.SystemTools.Translate.Translate("Gendan") %>?')) {
	            location = "Languages.aspx?ParagraphID=<%=Dynamicweb.Context.Current.Request("ParagraphID")%>&onPageID=" + onPageID;
	        }
        }
        function del(languageParagraphID) {
            if (confirm('<%=Dynamicweb.SystemTools.Translate.Translate("Slet") %>?')) {
	            location = "Languages.aspx?ParagraphID=<%=Dynamicweb.Context.Current.Request("ParagraphID")%>&DeleteParagraphID=" + languageParagraphID;
	        }
        }

        <%If converter.toboolean(Request("UpdateParentOnClose")) then%>
        parent.document.getElementById("LanguageDialog").select(".boxhead .close i")[0].on("click",
            function () {
                parent.location.reload();
            });
        <%End if%>
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dw:List ID="List1" runat="server" Title="Sprog" PageSize="20">
            <Columns>
                <dw:ListColumn ID="ListColumn1" runat="server" Name="" Width="25"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn2" runat="server" Name="Sprog" Width="0"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn3" runat="server" Name="Side" Width="0"></dw:ListColumn>
                <dw:ListColumn ID="ListColumn4" runat="server" Name="Slet" Width="0"></dw:ListColumn>
            </Columns>
        </dw:List>
    </form>
</body>
</html>
