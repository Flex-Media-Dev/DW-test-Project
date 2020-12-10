<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SplitTestsList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.SplitTestsList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title>Webpage analysis</title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" runat="server" />
    <link rel="Stylesheet" href="/Admin/Content/PageTemplates/Reports/PagePerformanceReport.css" type="text/css" />
</head>
<body>
    <form id="listForm" name="listForm" runat="server">
        <dw:List ID="lstExperiments" runat="server" Title="All split tests" ShowPaging="false"  AllowMultiSelect="true">
                <Columns>
                    <dw:ListColumn ID="ExperimentNameColumn" EnableSorting="true" runat="server" Name="Split tests name"></dw:ListColumn>
                    <dw:ListColumn ID="PageColumn" EnableSorting="true" runat="server" Name="Page"></dw:ListColumn>
                    <dw:ListColumn ID="WebsiteColumn" EnableSorting="true" runat="server" Name="Website"></dw:ListColumn>
                    <dw:ListColumn ID="TypeColumn" EnableSorting="true" runat="server" Name="Type"></dw:ListColumn>
                    <dw:ListColumn ID="GoalColumn" EnableSorting="true" runat="server" Name="Goal"></dw:ListColumn>
                    <dw:ListColumn ID="StateColumn" EnableSorting="true" runat="server" Name="State"></dw:ListColumn>
                </Columns>
        </dw:List>
        <div style="text-align:right; bottom: 0; position: absolute; width:100%; right: 0;"> 
            <input style="margin-right:3px; min-width:50px; text-align:center;" type="submit" id="okSubmit" name="okSubmit" value="Ok" onclick="parent.dialog.hide('SelectSplitTestsDialog')"/>
        </div>
    </form> 
  </body>
    <%If isCheckedAll Then%>
    <script type="text/javascript">
        var selectAll = document.getElementById('chk_all_lstExperiments');
        if(selectAll != null){ 
            selectAll.checked = true;
        }
    </script>
    <%End If%>
<%  Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
