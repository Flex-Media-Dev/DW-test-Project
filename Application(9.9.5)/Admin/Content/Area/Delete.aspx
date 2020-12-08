<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Delete.aspx.vb" Inherits="Dynamicweb.Admin.Delete2" %>
<script src="/Admin/Resources/js/layout/dwglobal.js"></script>
<script type="text/javascript">
    var nav = dwGlobal.getContentNavigator();
    if (nav) {
        nav.refreshRootSelector();
    }
    document.location = "/Admin/Content/Area/List.aspx";  // "Area_list.aspx";    
</script>