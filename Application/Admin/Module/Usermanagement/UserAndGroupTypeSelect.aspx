<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserAndGroupTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.UserAndGroupTypeSelect" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dwc:ScriptLib runat="server">
        <script type="text/javascript" src="/Admin/Content/JsLib/prototype-1.7.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    </dwc:ScriptLib>
    <title></title>
    <style>
        .large-icon {
            font-size: 64px;
        }

        .userType {
            float: left;
            width: 256px;
            height: 192px;
            overflow: hidden;
            padding: 5px;
            text-align: center;
            cursor: pointer;
        }

            .userType:hover {
                background-color: #f3f3f3;
            }

        .description {
            color: #cccccc;
        }
        .groupbox {
            border:none!important;
        }
    </style>
    <script>
        function createRegular() {
            location.href = "<%= GetTargetPath() %>&BasedOn=|regular|";
        }

        function createTypeBased(basedOn) {
            if (!basedOn || typeof (basedOn) != "string" || basedOn.trim().length < 1) {
                createRegular();
                return;
            }

            location.href = "<%= GetTargetPath() %>&BasedOn=" + basedOn;
        }
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" />

            <dwc:GroupBox runat="server" ID="asdf">
                <div onclick="createRegular();" class="userType" id="regularUserOrGroupItem" runat="server">
                    <span id="Span1" class="large-icon"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare)%>"></i></span>

                    <div>
                        <dw:TranslateLabel runat="server" ID="RegularObjectText" />
                    </div>

                    <div class="description">
                        <small>
                            
                        </small>
                    </div>
                </div>
                <asp:Repeater ID="UserAndGroupTypeRepeater" runat="server" EnableViewState="false">
                    <ItemTemplate>
                        <div onclick="createTypeBased('<%# Eval("SystemName") %>');" class="userType">
                            <span id="iconSpan" runat="server" class="large-icon"></span>

                            <div>
                                <%# Eval("Name") %>
                            </div>

                            <div class="description">
                                <small><%# Converter.ToString(Eval("Description")) %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </dwc:GroupBox>

            <div class="m-l-10" id="MessageBlock" runat="server">
                <dw:TranslateLabel Text="No user and group types is available." runat="server" />
            </div>
        </dwc:Card>
    </div>
</body>
</html>
