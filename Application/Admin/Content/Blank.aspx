<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Blank.aspx.vb" Inherits="Dynamicweb.Admin.Blank1" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script>
        <% If Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectpage" Then %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(GetPageAncestorsNodeIds()) %>);
        <% ElseIf Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshandselectpage" Then
            Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
            Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% ElseIf Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "refreshparentandselectpage" Then
            Dim ancestors As IEnumerable(Of String) = GetPageAncestorsNodeIds()
            Dim ancestorsToForceReload As IEnumerable(Of String) = ancestors.Skip(Math.Max(0, ancestors.Count - 2)).Take(1)
            %>
        dwGlobal.getContentNavigator().expandAncestors(<%= Converter.SerializeCompact(ancestors) %>, <%= Converter.SerializeCompact(ancestorsToForceReload) %>);
        <% End If %>
    </script>
</head>
<body>
</body>
</html>
