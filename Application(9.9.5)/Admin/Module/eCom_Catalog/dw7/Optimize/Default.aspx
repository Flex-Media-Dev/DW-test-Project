<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="Default.aspx.vb" Inherits="Dynamicweb.Admin._Default4" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <title>
            <dw:TranslateLabel ID="lbOptimize" Text="Optimize" runat="server" />
        </title>
        
        <dw:ControlResources ID="ctrlResources" runat="server">
            <Items>
                <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/Optimize.css" />
                <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/Optimize.js" />
            </Items>
            <Conditions>
                <dw:ResourceCondition Criteria="Contains" Value="scriptaculous.js" Resolution="Discard" />
            </Conditions>
        </dw:ControlResources>
    </head>
    <body>
        <form id="MainForm" runat="server">
            <input type="hidden" id="ID_CustomProductID" name="CustomProductID" value="" onchange="Optimize.PhraseList.ProductChange();" />
            <input type="hidden" id="Name_CustomProductID" name="CustomProductName" value="" />
            <input type="hidden" id="SelectedPhrase" name="SelectedPhrase" value="" />
            
            <input type="hidden" id="TargetProductID" value="<%=HttpUtility.HtmlAttributeEncode(ProductID)%>" />
            <input type="hidden" id="TargetProductVariantID" value="<%=HttpUtility.HtmlAttributeEncode(ProductVariantID)%>" />
            <input type="hidden" id="TargetProductName" value="<%=HttpUtility.HtmlAttributeEncode(ProductName)%>" />
            
            <dw:Toolbar ID="TopTools" ShowStart="false" ShowEnd="false" runat="server">
                <dw:ToolbarButton ID="cmdChooseProduct" Icon="PlusSquare"
                    Text="Choose product" OnClientClick="Optimize.PhraseList.chooseProduct();" runat="server" />
                <dw:ToolbarButton ID="cmdHelp" Icon="Help" Text="Help" Divide="Before" OnClientClick="Optimize.PhraseList.help();" runat="server" />
            </dw:Toolbar>
			<h2 class="subtitle">
			    <dw:TranslateLabel ID="lbOptimizeSubHeader" runat="server" Text="Choose a phrase or keyword you want to optimize your product for." />
			</h2>
			
			<div class="optimize-phrase-list" runat="server">
			    <table border="0">
			        <tr id="rowNothingFound" runat="server" valign="top">
			            <td class="optimize-no-phrases">
			                <div>
			                    <dw:TranslateLabel ID="lbNothingFound" Text="No phrases found" runat="server" />
			                </div>
			            </td>
			        </tr>
			        <asp:Repeater ID="repRow" OnItemDataBound="repRow_ItemDataBound" EnableViewState="false" runat="server">
			            <ItemTemplate>
			                <tr valign="top">
			                    <asp:Repeater ID="repColumns" EnableViewState="false" runat="server">
			                        <ItemTemplate>
			                            <td>
	                                        <a class="<%=KnownIconInfo.ClassNameFor(KnownIcon.QuoteRight) %>" href="javascript:void(0);" onclick="Optimize.PhraseList.selectPhrase('<%#StringHelper.JSEnable(Container.DataItem.ToString())%>');" 
	                                            title="<%#StringHelper.JSEnable(Container.DataItem.ToString())%>" class="optimize-phrase">
	                                            
	                                            <span> <%#Server.HtmlEncode(Container.DataItem.ToString())%></span>
	                                            <span class="optimize-fade"></span>
	                                        </a>
			                            </td>
			                        </ItemTemplate>
			                    </asp:Repeater>
			                </tr>
			            </ItemTemplate>
			        </asp:Repeater>
			    </table>			                    

                <div class="optimize-phrase-custom">
                    <span>
                        <dw:translatelabel id="lbUserDefined" text="Brugerdefineret" runat="server" />
                    </span>
                    <input type="text" class="std" autocomplete="off" id="UserDefinedPhrase" name="UserDefinedPhrase" onfocus="this.select();" oncontextmenu="return false;" value="" />
                    <i id="cmdSubmitPhrase" class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Plus) %>" onclick="Optimize.PhraseList.useCustomPhrase();" ></i>
                </div>
                
                <span id="jsHelp" style="display: none"><%=Dynamicweb.SystemTools.Gui.Help("ecom.productman.product.optimize")%></span>
                <span id="msgDialogTitle" style="display: none"><dw:TranslateLabel ID="lbOptimizeTitle" Text="Optimize - %%" runat="server" /></span>
			</div>
        </form>
        
    <%Translate.GetEditOnlineScript()%>
    </body>
</html>
