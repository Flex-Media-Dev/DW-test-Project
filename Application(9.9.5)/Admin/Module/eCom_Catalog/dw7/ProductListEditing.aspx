<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master"
    AutoEventWireup="false" CodeBehind="ProductListEditing.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.ProductListEditing" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" src="js/ProductListEditing.js"></script>
    <script type="text/javascript">
        var hiddenProductColumns = "productColumns";
        $(document).observe('dom:loaded', productListEditingInit);

	    function help(){
		    <%=Dynamicweb.SystemTools.Gui.Help("", "ecom.productlist.edit.bulk", "en") %>
	    }
    </script>
    <link rel="Stylesheet" href="css/productListEditing.css" />
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <dw:RibbonBar ID="Ribbon" runat="server">
        <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Bulk edit">
            <dw:RibbonBarGroup ID="RibbonbarGroup3" runat="server" Name="Funktioner">
                <dw:RibbonBarButton runat="server" Text="Gem" Size="Small" Icon="Save" ID="RibbonbarButton2"
                    EnableServerClick="true" OnClick="Ribbon_Save"/>
                <dw:RibbonBarButton runat="server" Text="Gem og luk" Size="Small" Icon="Save"
                    EnableServerClick="true" OnClick="Ribbon_SaveAndClose" ID="RibbonbarButton3" />
                <dw:RibbonBarButton runat="server" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();"
                    ID="RibbonbarButton4" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonbarGroup5" runat="server" Name="Help">
                <dw:RibbonBarButton ID="RibbonbarButton6" runat="server" Text="Help" Icon="Help"
                    Size="Large" OnClientClick="help();" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>
    <asp:HiddenField ID="productIds" runat="server" />
    <ecom:Breadcrumb ID="breadcrumb" runat="server" CssClass="breadcrumb" />

	<dw:StretchedContainer ID="ProductEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document" runat="server">
    <asp:Literal ID="errorOutput" runat="server" Text=""></asp:Literal>
    <dw:Infobar ID="errorBar" runat="server" Visible="false">
    </dw:Infobar>
    <div id="gridcontainer" style="overflow: auto;">
        <dw:EditableGrid ID="productFields" runat="server" EnableViewState="true" OnRowDataBound="productFields_OnRowDataBound"
            DraggableColumnsMode="First" EnableSmartNavigation="True" AllowDeletingRows="true" >
        </dw:EditableGrid>
    </div>
    <input type="image" style="width:1px; height:1px; display: none" onfocus="productListAddRow();" tabindex="9999" />
    </dw:StretchedContainer>
	
	<% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>
