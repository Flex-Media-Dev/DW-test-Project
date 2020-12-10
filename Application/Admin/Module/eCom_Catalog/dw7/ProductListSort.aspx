<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
AutoEventWireup="false" CodeBehind="ProductListSort.aspx.vb" Inherits="Dynamicweb.Admin.ProductListSort" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
	<link rel="Stylesheet" href="/Admin/Images/Ribbon/UI/List/List.css" />
    <script type="text/javascript" src="js/dwsort.js"></script>
    <script type="text/javascript" src="js/ProductListSort.js"></script>
	<style type="text/css">
        .list ul {
	        min-width:640px;
        }
        
        #items li {
	        cursor:default;
	        border-bottom:1px solid #e0e0e0;
            padding-left: 5px;
        }

        .list li.header {
	        border-top:0px solid #e0e0e0;
	        min-width:640px;
        }

        .list li.header .w20px {
            padding-left: 5px;
        }


        #BottomInformationBg {
	        height:30px;
	        width:100%;
            padding-bottom: 26px;
            box-shadow: 0 1px 1px rgba(0,0,0,.15);
            background-color: #f7f7f7;
            vertical-align: top;
            font-size: 12px;
            color: #acacac;
        }

        #BottomInformationBg .label {
	        padding-left:5px;
	        padding-right:5px;
        }
	
        .w225px {
	        white-space:nowrap;
	        overflow:hidden;
	        width:225px;
        }

        .w20px { width:20px; white-space:nowrap;overflow:hidden;}
        .w80px { width:80px; white-space:nowrap;overflow:hidden;}
        .w140px { width:140px; white-space:nowrap;overflow:hidden;}
        .w140px { width:140px; white-space:nowrap;overflow:hidden;}
        .w340px { width:340px; white-space:nowrap;overflow:hidden;}
        .w100px { width:100px; white-space:nowrap;overflow:hidden; }
        
        #items li.selected {
            background-color: #0085CA !important;
            color: #fff;
        }

        @media (max-width: 1030px) {
	        .w100px, .w80px {
		        display:none!important;
	        }
        }
	</style>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <dw:Toolbar ID="toolbar" runat="server" ShowEnd="false">
		<dw:ToolbarButton runat="server" Text="Gem" Icon="Save" OnClientClick="save();" ID="Save" />
		<dw:ToolbarButton runat="server" Text="Annuller" Icon="TimesCircle" OnClientClick="cancel();" ID="Cancel" />        
        <dw:ToolbarButton runat="server" Text="Move to top" Icon="LongArrowUp" OnClientClick="moveToTop();" ID="btnMoveToTop" />
        <dw:ToolbarButton runat="server" Text="Move to bottom" Icon="LongArrowDown" OnClientClick="moveToBottom();" ID="btnMoveToBottom" />        
    </dw:Toolbar>
    <h2 class="subtitle"><%=Translate.Translate("Sort products")%></h2>
    <ecom:Breadcrumb ID="breadcrumb" runat="server" CssClass="breadcrumb" />

    <input type="hidden" id="GroupID" value="<%=GroupID %>" />
    <input type="hidden" id="FromPIM" value="<%=FromPIM %>" />
	<div class="list">
		<ul>
			<li class="header">
				<span class="w20px" style="padding-top: 0px;">
				</span>
				<span class="pipe"></span>
				<span class="w140px">
				    <a href="#" onclick="sorter.sortBy('id'); return false;"><%=Translate.Translate("Number")%></a>
				    <img style="display:none;" id="id_up"   src="/Admin/Images/ColumnSortUp.gif"/>
				    <img style="display:none;" id="id_down" src="/Admin/Images/ColumnSortDown.gif"/>
				</span> 
				<span class="pipe"></span>
				<span class="w340px">
				    <a href="#" onclick="sorter.sortBy('name'); return false;"><%=Translate.Translate("Name")%></a>
				    <img style="display:none;" id="name_up"   src="/Admin/Images/ColumnSortUp.gif"/>
				    <img style="display:none;" id="name_down" src="/Admin/Images/ColumnSortDown.gif"/>
				</span> 
				<span class="pipe"></span>
				<span class="w80px">
				    <a href="#" onclick="sorter.sortBy('stock'); return false;"><%=Translate.Translate("Stock")%></a>
				    <img style="display:none;" id="stock_up"   src="/Admin/Images/ColumnSortUp.gif"/>
				    <img style="display:none;" id="stock_down" src="/Admin/Images/ColumnSortDown.gif"/>
				</span> 
				<span class="pipe"></span>
				<span class="w80px">
				    <a href="#" onclick="sorter.sortBy('price'); return false;"><%=Translate.Translate("Price")%></a>
				    <img style="display:none;" id="price_up"   src="/Admin/Images/ColumnSortUp.gif"/>
				    <img style="display:none;" id="price_down" src="/Admin/Images/ColumnSortDown.gif"/>
				</span> 
				<span class="pipe"></span>
			</li>
		</ul>
	    <dw:StretchedContainer ID="SortingContainer" Scroll="Auto" Stretch="Fill" Anchor="document" runat="server">
		<ul id="items">
		    <asp:Repeater ID="ProductsRepeater" runat="server" enableviewstate="false">
    		    <ItemTemplate>
			    <li id="Product_<%#Eval("ID")%>">
                    <span>
                       <input id="checkBox_<%#Eval("ID")%>" type="checkbox" name="checkBox_<%#Eval("ID")%>" onclick="handleCheckboxes(this);" />
                    </span> 
				    <span class="w140px"><%#Eval("Number")%></span> 
				    <span class="w340px"><%#Eval("Name")%></span>
				    <span class="w80px"><%#Eval("Stock")%></span>
				    <span class="w100px"><%#Eval("Price")%></span>
			    </li></ItemTemplate>
		    </asp:Repeater>
		</ul>
        </dw:StretchedContainer>
        <div id="BottomInformationBg">
            <span class="label"><span id="ProductsCount" runat="server"></span>&nbsp;<dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Products" /></span>
        </table>
        </div>
    </div>
	
	<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
	    
</asp:Content>
