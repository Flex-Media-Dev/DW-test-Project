<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="ProfileUsage.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Profiles.ProfileUsage" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        function showHelp() {
            <%=Gui.Help("omc.createtheme", "omc.createtheme")%>
        }

        function initPage(opts) {
            var options = opts;
            var pageApi = {
                filterApply: function () {
                    List._submitForm('List');
                },

                openPageEdit: function (pageId) {
                    Action.Execute(options.actions.openPage, { id: pageId });
                },

                openParagraphEdit: function (paragraphId, pageId) {
                    Action.Execute(options.actions.openParagraph, { id: paragraphId, pageId: pageId });
                },

                openProduct: function (productId, productCategoryId) {
                    Action.Execute(options.actions.openProduct, { id: productId, groupId: productCategoryId });
                },

                openNews: function (newsId, newsCategoryId) {
                    Action.Execute(options.actions.openNews, { id: newsId, categoryId: newsCategoryId });
                },

                help: showHelp
            };
            return pageApi;
        }
    </script>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Profile Usage"/>
        <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="false">
            <dw:ToolbarButton ID="cmdAply" Icon="Check" Text="Apply" runat="server" OnClientClick="currentPage.filterApply();" />
            <dw:ToolbarButton ID="cmdHelp" Icon="Help" Text="Help" OnClientClick="currentPage.help();" runat="server" Divide="Before" />
        </dw:Toolbar>
        <dw:List runat="server" ID="ProfileUsageList"  ShowTitle="false" NoItemsMessage="No profiles used" PageSize="25"  >
            <Filters>
                <dw:ListDropDownListFilter runat="server" ID="ProfileDropDownListFilter" Label="Select profile" Width="200" ></dw:ListDropDownListFilter>
                <dw:ListDropDownListFilter runat="server" ID="TypeDropDownListFilter" Label="Select type" Width="200"></dw:ListDropDownListFilter>
                <dw:ListDropDownListFilter runat="server" ID="AreaDropDownListFilter" Label="Site" Width="200"></dw:ListDropDownListFilter>
            </Filters>
            <Columns>
                <dw:ListColumn ID="colProfileLinkToPage" EnableSorting="false" runat="server" Name="Link to resource" HeaderAlign="Center" ItemAlign="Center" Width="30" />
                <dw:ListColumn ID="colProfileType" EnableSorting="true" runat="server" Name="Profile Type" HeaderAlign="Center" ItemAlign="Center" Width="50" />
                <dw:ListColumn ID="colProfiledItem" EnableSorting="true" runat="server" Name="Item Profiled" HeaderAlign="Left" ItemAlign="Left" />
                <dw:ListColumn ID="colProfilesUsed" EnableSorting="true" runat="server" Name="Profiles Used" HeaderAlign="Left" ItemAlign="Left" />
            </Columns>
        </dw:List>
    </dwc:Card>
</asp:Content>