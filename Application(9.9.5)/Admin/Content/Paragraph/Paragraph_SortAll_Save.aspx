<%@ Page ValidateRequest="false" CodeBehind="Paragraph_SortAll_Save.aspx.vb" Language="vb" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Paragraph_SortAll_Save" %>
<script type="text/javascript">
	if (window.opener) {
	    window.opener.location = '/Admin/Content/ParagraphList.aspx?PageID=<%=PageID%>';
		window.close();
	} else {
	    location = '/Admin/Content/ParagraphList.aspx?PageID=<%=PageID%>';
	}
</script>
<%=Now%>