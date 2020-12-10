<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Dashboard" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls.Charts" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-main">
        <dw:RoundedFrame id="frmPageViews" Width="1140" runat="server">
            <dw:Chart ID="cPageViews" Type="Line" Width="1115" Height="200" GridlineColor="#e1e1e1" PointSize="4" Legend="none" AutoDraw="true" runat="server" />
        </dw:RoundedFrame>

        <div class="dashboard-separator"></div>

        <div class="dashboard-split">   
            <div class="dashboard-left">
                <dw:RoundedFrame id="frmMostPageViews" Width="240" runat="server">
                    <dw:Chart ID="cSources" Type="Pie" Width="200" Height="200" Legend="none" AutoDraw="true" runat="server" />
                </dw:RoundedFrame>
            </div>

            <div class="dashboard-middle">
                <dw:RoundedFrame ID="frmInfo" Width="400" runat="server">
                    <div class="dashboard-info" style="height: 190px">
                        <h3><dw:TranslateLabel ID="lbLegend" Text="Legend" runat="server" /></h3>
                        <ul class="dashboard-legend">
                            <li><div class="dashboard-legend-item" id="legendDirect" runat="server" />&nbsp;<dw:TranslateLabel ID="lbLegendDirect" Text="Direct traffic" runat="server" /></li>
                            <li><div class="dashboard-legend-item" id="legendLink" runat="server" />&nbsp;<dw:TranslateLabel ID="lbLegendLink" Text="Referring sites" runat="server" /></li>
                            <li><div class="dashboard-legend-item" id="legendSearch" runat="server" />&nbsp;<dw:TranslateLabel ID="lbLegendSearch" Text="Search engines" runat="server" /></li>
                        </ul>

                        <div class="dashboard-clear"></div>

                        <h3><dw:TranslateLabel ID="lbInNumbers" Text="Visits" runat="server" /></h3>

                        <div class="dashboard-stats-row">
                            <span id="spTotalVisits" class="dashboard-number" runat="server"></span>&nbsp;-&nbsp;<dw:TranslateLabel ID="lbTotalVisits" Text="unique visits for a given time frame" runat="server" />
                        </div>

                        <div class="dashboard-stats-row">
                            <span id="spUniquePages" class="dashboard-number" runat="server"></span>&nbsp;-&nbsp;<dw:TranslateLabel ID="lbUniquePagesVisited" Text="unique pages visited" runat="server" />
                        </div>

                        <div class="dashboard-stats-row">
                            <span id="spAverageTime" class="dashboard-number" runat="server"></span>&nbsp;-&nbsp;<dw:TranslateLabel ID="lbAveargeTime" Text="average time spent on web site" runat="server" />
                        </div>
                    </div>
                </dw:RoundedFrame>
            </div>
        </div>

        <div class="dashboard-right">
            <dw:RoundedFrame ID="frmMostVisits" Width="500" runat="server">
                <asp:Panel ID="pList" runat="server">
                    <div class="dashboard-info">
                        <asp:Repeater ID="repMostVisits" runat="server">
                            <HeaderTemplate>
                                <table class="dashboard-most-visits" cellspacing="0" cellpadding="2" border="0">
                                    <tr>
                                        <th class="dashboard-page-name"><dw:TranslateLabel ID="lbPage" Text="Page name" runat="server" /></th>
                                        <th class="dashboard-page-visits"><dw:TranslateLabel ID="lbVisits" Text="Visits" runat="server" /></th>
                                        <th class="dashboard-page-percentage"><dw:TranslateLabel ID="lbPercentage" Text="Percentage" runat="server" /></th>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Name")%></td>
                                    <td><%# Eval("Visits")%></td>
                                    <td><%# CType(Eval("Percentage"), Double).ToString("0.0") & "%"%></td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="dashboard-row-alternative">
                                    <td><%# Eval("Name")%></td>
                                    <td><%# Eval("Visits")%></td>
                                    <td><%# CType(Eval("Percentage"), Double).ToString("0.0") & "%"%></td>
                                </tr>
                            </AlternatingItemTemplate>
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pEmptyList" runat="server">
                    <div class="dashboard-no-data">
                        <dw:TranslateLabel ID="lbNothingFound" Text="Nothing to display" runat="server" />
                    </div>
                </asp:Panel>
            </dw:RoundedFrame>
        </div>

        <div class="dashboard-clear"></div>
    </div>
</asp:Content>