<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" CodeBehind="GroupSort.aspx.vb" Inherits="Dynamicweb.Admin.GroupSort" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
	<link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <link rel="Stylesheet" href="css/GroupSort.css" />
    <script type="text/javascript" src="js/dwsort.js"></script>
    <script type="text/javascript" src="js/GroupSort.js"></script>
    <script type="text/javascript">
        var closeActionParams = <%= CloseAction %>;
    </script>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
		<dw:ToolbarButton runat="server" Text="Gem" Icon="Save" OnClientClick="save();" ID="Save" />
		<dw:ToolbarButton runat="server" Text="Annuller" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />        
        <dw:ToolbarButton runat="server" Text="Move to top" Icon="LongArrowUp" OnClientClick="moveToTop();" ID="btnMoveToTop" />
        <dw:ToolbarButton runat="server" Text="Move to bottom" Icon="LongArrowDown" OnClientClick="moveToBottom();" ID="btnMoveToBottom" />    
		<dw:ToolbarButton runat="server" Text="Sorting" Icon="ImportExport" ID="btnSorting" />              
    </dw:Toolbar>
    <h2 class="subtitle"><%=Translate.Translate("Sort product groups")%></h2>
    <ecom:Breadcrumb ID="breadcrumb" runat="server" CssClass="breadcrumb" />

        <input type="hidden" id="group" value="<%=GroupID %>" />
        <input type="hidden" id="shop" value="<%=ShopID %>" />
        <input type="hidden" id="path" value="<%=HttpUtility.HtmlAttributeEncode(Path) %>" />
        <input type="hidden" id="FromPIM" value="<%=FromPIM %>" />
		<div class="list">
			<ul>
				<li class="header">
					<span class="w20px" style="padding-top: 0px;">
					</span>
					<span class="pipe"></span>
					<span>
					    <a href="#" onclick="sorter.sortBy('name'); return false;"><%=Translate.Translate("Name")%></a>
					    <img style="display:none;" id="name_up"   src="/Admin/Images/ColumnSortUp.gif"/>
					    <img style="display:none;" id="name_down" src="/Admin/Images/ColumnSortDown.gif"/>
					</span> 
				</li>
			</ul>
	    <dw:StretchedContainer ID="SortingContainer" Scroll="Auto" Stretch="Fill" Anchor="document" runat="server">
			<ul id="items">
    		    <asp:Repeater ID="GroupsRepeater" runat="server" enableviewstate="false">
	    		    <ItemTemplate>
				    <li id="Group_<%#Eval("ID")%>" class="">
                        <span>
                             <input id="checkBox_<%#Eval("ID")%>" type="checkbox" name="checkBox_<%#Eval("ID")%>" onclick="handleCheckboxes(this);" />
                        </span> 
					    <span><%#Eval("Name")%></span> 
				    </li></ItemTemplate>
    		    </asp:Repeater>
			</ul>
            
        </dw:StretchedContainer>
        <div id="BottomInformationBg">
		       <span class="label"><span id="GroupsCount" runat="server"></span>&nbsp;<dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Groups" /></span>
        </div>
    </div>

    <dw:ContextMenu ID="SortingMenu" runat="server">
        <dw:ContextMenuButton ID="cmdSortAsc" runat="server" Icon="SortAmountAsc" OnClientClick="sortRowsAscending();" Text="Sort ascending" />
         <dw:ContextMenuButton ID="cmdSortDesc" runat="server" Icon="SortAmountDesc" OnClientClick="sortRowsDescending();" Text="Sort descending" />
    </dw:ContextMenu>
</asp:Content>
