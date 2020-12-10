<%@ Page CodeBehind="RmaList.aspx.vb" Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" Inherits="Dynamicweb.Admin.Admin.Module.eCom_Catalog.dw7.RmaList"
    Async="true" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="js/queryString.js"></script>
    <script type="text/javascript" src="js/RmaList.js"></script>
    <link rel="Stylesheet" type="text/css" href="/Admin/Images/Ribbon/UI/List/List.css" />
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <asp:Panel runat="server" ID="ContentPanel">
        <!-- Ribbon bar start -->
        <div style="min-width: 832px; overflow: hidden;">
            <dw:RibbonBar ID="Ribbon" runat="server">
                <dw:RibbonBarTab ID="RibbonBarTab1" Name="RMAs" runat="server">
                    <dw:RibbonBarGroup ID="RibbonBarGroup1" Name="Tools" runat="server">
                        <dw:RibbonBarButton ID="ButtonDelete" Icon="Delete" Size="Small" Text="Delete"
                            OnClientClick="if(!confirm(_deleteQuestion)) {return false;} else{ deleteRmas();}" runat="server" Disabled="true" />
                    </dw:RibbonBarGroup>
                   <%-- <dw:RibbonBarGroup ID="OrderStateButtonView" Name="Set RMA state" runat="server">
                        <dw:RibbonBarPanel ID="RibbonBarPanel1" runat="server">
                            <asp:DropDownList runat="server" ID="StatesDropDownList" class="NewUIinput InputBoxWidth"  >
                            </asp:DropDownList>
                        </dw:RibbonBarPanel>
                            <dw:RibbonBarButton runat="server" Image="Check" Size="Small" ID="ButtonChangeState" OnClientClick="changeState()" 
                                                Text="Set" Disabled="True" />
                    </dw:RibbonBarGroup>--%>
                    <dw:RibbonBarGroup ID="RibbonBarGroup2" runat="server" Name="Filters">
                        <dw:RibbonBarButton runat="server" ID="ButtonReset" Text="Reset" Size="Large" Icon="Refresh" OnClientClick="ResetFilters();" Disabled="true" />
                        <dw:RibbonBarButton runat="server" ID="ButtonApplyFilters" Text="Apply" Size="Large" Icon="Check" OnClientClick="javascript:List._submitForm('List');" />
                    </dw:RibbonBarGroup>
                    <dw:RibbonBarGroup ID="RibbonBarGroup4" Name="Help" runat="server">
                        <dw:RibbonBarButton ID="ButtonHelp" Icon="Help" Size="Large" Text="Help" OnClientClick="help();"
                            runat="server" />
                    </dw:RibbonBarGroup>
                </dw:RibbonBarTab>
            </dw:RibbonBar>
        </div>
        <!-- Ribbon bar end -->
        <!-- List start -->
        <input type="hidden" runat="server" id="SelectedRmas" value="" />
        <input type="hidden" runat="server" id="Action" value="" />
        <div id="ListContent" class="content" style="overflow: auto;" >
            <dw:List runat="server" ID="ListOfRmas" AllowMultiSelect="true" Title="RMAs" UseCountForPaging="true"
                HandlePagingManually="true" ShowCollapseButton="true" OnClientSelect="rowSelected();"
                Personalize="true">
                <Filters>
                    <dw:ListDropDownListFilter runat="server" ID="RmaStateFilter" Label="RMA state" Width="220"
                        OnClientChange="enableResetButton();">
                        <Items>
                        </Items>
                    </dw:ListDropDownListFilter>
                    <dw:ListDropDownListFilter runat="server" ID="OpenClosedDeletedFilter" Width="220"
                        Label="Activity status" OnClientChange="enableResetButton();">
                        <Items>
                            <dw:ListFilterOption Text="Open" Value="Open" selected="true" />
                            <dw:ListFilterOption Text="Closed" Value="Closed" />
                            <dw:ListFilterOption Text="Deleted" Value="Deleted" />
                            <dw:ListFilterOption Text="All" Value="All" />
                        </Items>
                    </dw:ListDropDownListFilter> 
                    <dw:ListDropDownListFilter runat="server" ID="TypeFilter" Width="220"
                        Label="Type" OnClientChange="enableResetButton();">
                        <Items>
                        </Items>
                    </dw:ListDropDownListFilter>

                    <dw:ListTextFilter runat="server" ID="TextSearchFilter" Label="Search" Width="220" Divide="After"
                        ShowSubmitButton="false" OnClientChange="enableResetButton();" />
                </Filters>
                <Columns>
                    <dw:ListColumn runat="server" ID="rmaId" Name="RMA ID" EnableSorting="true" />
                    <dw:ListColumn runat="server" ID="OrderNumber" Name="Order number"  EnableSorting="true" HideOnTablet="true" />
                    <dw:ListColumn runat="server" ID="CustomerName" Name="Customer name" EnableSorting="true" HideOnTablet="true" />
                    <dw:ListColumn runat="server" ID="openedClosedDeleted" Name="Activity status" />
                    <dw:ListColumn runat="server" ID="Type" Name="Type" EnableSorting="true" />
                    <dw:ListColumn runat="server" ID="state" Name="State" EnableSorting="true"/>
                    <dw:ListColumn runat="server" ID="LastChange" Name="Last change" EnableSorting="true" HideOnTablet="true" />
                    <dw:ListColumn runat="server" ID="CreationDate" Name="Creation date" EnableSorting="true" HideOnTablet="true" />
                </Columns>
            </dw:List>
        </div>
        <!-- List end -->
        
         <%--   <dw:ContextMenu runat="server" ID="RmaContext">
        <dw:ContextMenuButton ID="ContextShowRma" Image="EditDocument" Text="Show Rma" OnClientClick="showRma();" runat="server" />
        <dw:ContextMenuButton ID="ContextDeleteRma" Image="DeleteDocument" Text="Delete" OnClientClick="deleteRma();" runat="server" />
    </dw:ContextMenu>
--%>
    </asp:Panel>
    <script language="javascript">
        var selectedRmas = $('<%=selectedRmas.ClientID %>');
        var action = $('<%=Action.ClientID %>');
        var _deleteQuestion = "<%= _deleteQuestion %>";

    </script>
    
<!-- Help button start-->
	<script type="text/javascript">
	function help(){
		<%=Dynamicweb.SystemTools.Gui.Help("", "ecom.RmaNEW", "en") %>
	}

	window.onload = function () { resizeContentPane("ListContent", "Ribbon"); };
	window.onresize = function() { resizeContentPane("ListContent", "Ribbon"); };

	</script>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>

</asp:Content>

