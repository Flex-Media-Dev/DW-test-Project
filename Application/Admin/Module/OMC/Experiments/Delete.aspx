<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Delete.aspx.vb" Inherits="Dynamicweb.Admin.Delete1" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="false" />
    <title></title>
    <link rel="StyleSheet" href="Setup.css" type="text/css" />
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript" src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript">

        function deleteExperiment() {
            var o = new overlay('forward');
            o.show();
            if (!document.getElementById("deleteConfirm").checked) {
                alert('<%= Translate.Translate("Please confirm to delete this split test.")%>');
                o.hide();
                return false;
            }
            document.getElementById("deleteForm").submit();
        }

        function close() {
            <%If (Not Converter.toBoolean(Dynamicweb.Context.Current.Request("FromOMC")))Then%>
                var reloadLocation = parent.location.toString().replace("#", "");
                if (reloadLocation.indexOf("omc") < 0) {
                    if (reloadLocation.indexOf("?") < 0) {
                        reloadLocation += "?omc=true";
                    }
                    else {
                        reloadLocation += "&omc=true";
                    }
                    if (reloadLocation.indexOf("NavigatorSync") < 0) {
                        reloadLocation += "&NavigatorSync=refreshandselectpage";
                    }
                }
                parent.location = reloadLocation;
            <% Else %>
                <%=GetRefreshContentAreaAction()%>            
                parent.location.reload();
            <% End If %>
        }
    </script>
</head>
<body>
    <dw:Overlay ID="forward" Message="Please wait" runat="server">
    </dw:Overlay>
    <div runat="server" id="closeJs" visible="false">
        <script type="text/javascript">
            close();
        </script>
    </div>
    <form id="deleteForm" runat="server" action="Delete.aspx" method="post">
        <input type="hidden" runat="server" id="id" name="id" />
        <input type="hidden" id="FromOMC" name="FromOMC" value="<%=Converter.ToBoolean(Dynamicweb.Context.Current.Request("FromOMC"))%>" />
        <div id="step1Delete" class="step">
            <div class="step__content">
                <dwc:GroupBox Title="Stop experiment" runat="server">
                    <dw:Infobar Message="All data on visitors and conversions will be deleted" runat="server" CssClass="p-0"></dw:Infobar>
                    <dw:Infobar Message="Disable the split test instead if data is still needed" runat="server" DisplayType="Information" CssClass="p-0 m-b-15"></dw:Infobar>

                    <dwc:CheckBox Id="deleteConfirm" Label="Yes, stop this split test" runat="server" Header="Confirm stop" />

                    <dwc:RadioGroup Name="WhatToKeep" runat="server" ID="optionsDiv" Label="What do you want to do with your test variations?">
                        <dwc:RadioButton ID="WhatToKeepAll" runat="server" FieldValue="All" SelectedFieldValue="All" Label="Keep all versions, with original published" />
                        <dwc:RadioButton ID="WhatToKeep1" runat="server" FieldValue="All" SelectedFieldValue="1" Label="Keep original and delete variation" />
                        <dwc:RadioButton ID="WhatToKeep2" runat="server" FieldValue="All" SelectedFieldValue="2" Label="Keep variation and delete original" />
                        <dwc:RadioButton ID="WhatToKeep3" runat="server" FieldValue="All" SelectedFieldValue="Best" Label="Keep the best performing version and delete the other" />
                    </dwc:RadioGroup>
                </dwc:GroupBox>
            </div>
            <footer>
                <input type="button" class="btn" value="OK" id="Button1" onclick="deleteExperiment();" />
            </footer>
        </div>
    </form>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
