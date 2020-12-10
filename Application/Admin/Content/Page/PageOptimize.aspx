<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PageOptimize.aspx.vb" Inherits="Dynamicweb.Admin.PageOptimize" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />   
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/List/List.css" />              
        </Items>
    </dw:ControlResources>
    <style>
        .groupbox {
            padding-top: 0px;
            padding-bottom: 0px;
        }

        .groupbox.header {
            padding-top: 16px;
        }

        .analysis-list {
            padding-left: 8px;
            margin: 0;
            list-style: none;
        }

        .analysis-list li {
            margin: 0px 0px 8px 0px;
        }

        .analysis-list-info {
            padding-left: 8px;
        }
    </style>
    <script type="text/javascript">
        function analizeKeyphraze() {
            (new overlay("wait")).show();
            form1.submit();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dwc:Card runat="server">
            <dwc:CardBody runat="server">
                <dw:TabStrip ID="MainTabs" runat="server">
                    <dw:Tab Name="Content & metadata" Translate="true" Active="true" runat="server" ID="ContentTab">
                        <dw:Infobar ID="errorMessage" runat="server" Message="Page template is broken" DisplayType="Error" Visible="false"></dw:Infobar>
                        <dwc:GroupBox Title="Warnings:" ID="errorBox" runat="server">
                            <asp:Repeater ID="errorRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="analysis-list analysis-list-error">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li>
                                        <span class="analysis-list-icon">
                                            <%= KnownIconInfo.GetIconHtml(KnownIcon.TimesCircleO, True, KnownColor.Danger) %>
                                        </span>
                                        <span class="analysis-list-info">
                                            <%# Container.DataItem %>
                                        </span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </dwc:GroupBox>
                        <dwc:GroupBox Title="Recommendations:" ID="warningBox" runat="server">
                            <asp:Repeater ID="warningRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="analysis-list analysis-list-warning">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li>
                                        <span class="analysis-list-icon">
                                            <%= KnownIconInfo.GetIconHtml(KnownIcon.ExclaminationCircle, True, KnownColor.Warning) %>
                                        </span>
                                        <span class="analysis-list-info">
                                            <%# Container.DataItem %>
                                        </span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </dwc:GroupBox>
                        <dwc:GroupBox Title="Optimized:" ID="goodBox" runat="server">
                            <asp:Repeater ID="successRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="analysis-list analysis-list-warning">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li>
                                        <span class="analysis-list-icon">
                                            <%= KnownIconInfo.GetIconHtml(KnownIcon.CheckCircleO, True, KnownColor.Success) %>
                                        </span>
                                        <span class="analysis-list-info">
                                            <%# Container.DataItem %>
                                        </span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </dwc:GroupBox>               
                    </dw:Tab>
                    <dw:Tab Name="Keyphraze analysis" Translate="true" runat="server" ID="KeyphrazeTab">
                        <dwc:GroupBox ClassName="header" runat="server">
                            <div class="dw-ctrl textbox-ctrl form-group">
		                        <label class="control-label"><dw:TranslateLabel runat="server" Text="Keyphraze" /></label>	
		                        <div class="input-group">
                                    <div class="form-group-input">
				                        <input class="form-control" type="text" id="keyphrazeText" name="keyphrazeText" runat="server" list="suggestedWords" autocomplete="off" />
                                        <datalist id="suggestedWords" runat="server"></datalist>
                                        <span class="help-block info"><%= Translate.Translate("Choose the phrase or keyword that you want to optimize this page for")%></span>
			                        </div>
                                    <span class="input-group-addon" title="<%= Translate.Translate("Analyze") %>" onclick="analizeKeyphraze();"><i class="fa fa-refresh"></i></span>
		                        </div>
                            </div>
                        </dwc:GroupBox>
                        <dwc:GroupBox Title="Warnings:" ID="keyWarningBox" runat="server">
                            <asp:Repeater ID="keyWarningRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="analysis-list analysis-list-error">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li>
                                        <span class="analysis-list-icon">
                                            <%= KnownIconInfo.GetIconHtml(KnownIcon.TimesCircleO, True, KnownColor.Danger) %>
                                        </span>
                                        <span class="analysis-list-info">
                                            <%# Container.DataItem %>
                                        </span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </dwc:GroupBox>
                        <dwc:GroupBox Title="Optimized:" ID="keyOptimizedBox" runat="server">
                            <asp:Repeater ID="keyOptimizedRepeater" runat="server" EnableViewState="false">
                                <HeaderTemplate>
                                    <ul class="analysis-list analysis-list-warning">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li>
                                        <span class="analysis-list-icon">
                                            <%= KnownIconInfo.GetIconHtml(KnownIcon.CheckCircleO, True, KnownColor.Success) %>
                                        </span>
                                        <span class="analysis-list-info">
                                            <%# Container.DataItem %>
                                        </span>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ul>
                                </FooterTemplate>
                            </asp:Repeater>
                        </dwc:GroupBox>       
                    </dw:Tab>
                </dw:TabStrip>
            </dwc:CardBody>
        </dwc:Card>
        <dw:Overlay ID="wait" runat="server" ShowWaitAnimation="True">
        </dw:Overlay>
    </form>
</body>
</html>
