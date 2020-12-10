<%@ Page Language="vb" MasterPageFile="~/Admin/Module/eCom_Catalog/dw7/Main.Master" AutoEventWireup="false" CodeBehind="EcomAssortment_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomAssortmentEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<asp:Content ID="Header" ContentPlaceHolderID="HeadHolder" runat="server">
    <script type="text/javascript" language="JavaScript" src="../images/layermenu.js"></script>


    <script type="text/javascript">
        var _tabNum = null;
        var _tabName = null;

        var Tabs =
        {
            tab: function (activeID)
            {
                for(var i = 0; i < 15; i++)
                {
                    if($("Tab" + i))
                        $("Tab" + i).style.display = "none";
                }

                if($("Tab" + activeID))
                    $("Tab" + activeID).style.display = "";
            }
        }

        function ribbonTab(name, num)
        {
            _tabNum = num;
            _tabName = name;

            Tabs.tab(num);
            TabLoader(name);

            $('Tab').value = num;
            $('TabName').value = name;
        }

        function TabLoader(tabName)
        {
            if(tabName == "SHOP" || tabName == "1")
            {
                if($('AssortmentShopData').innerHTML == "")
                {
                    new Ajax.Request("/Admin/module/ecom_catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=GET_SHOP_DATA&ID=<%=Me.AssortmentID%>",
                     {
                         method: 'get',
                         onComplete: function (transport)
                         {
                             $('AssortmentShopData').innerHTML = transport.responseText;
                         }
                     });
                }
            }

            if(tabName == "GROUP" || tabName == "2")
            {
                if($('AssortmentGroupData').innerHTML == "")
                {
                    new Ajax.Request("/Admin/module/ecom_catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=GET_GROUP_DATA&ID=<%=Me.AssortmentID%>",
                     {
                         method: 'get',
                         onComplete: function (transport)
                         {
                             $('AssortmentGroupData').innerHTML = transport.responseText;
                         }
                     });
                }
            }

            if(tabName == "PROD" || tabName == "3")
            {
                if($('AssortmentProductData').innerHTML == "")
                {
                    new Ajax.Request("/Admin/module/ecom_catalog/dw7/edit/EcomAssortment_Edit.aspx?CMD=GET_PROD_DATA&ID=<%=Me.AssortmentID%>",
                     {
                         method: 'get',
                         onComplete: function (transport)
                         {
                             $('AssortmentProductData').innerHTML = transport.responseText;
                         }
                     });
                }
            }
        }

        function save()
        {
            if(validateFields())
                document.getElementById('cmdSave').click();
            else
            {   
                var infobar = document.getElementById('validationSummaryInfo');
                infobar.show();
            }
        }

        function saveAndClose()
        {
            if(validateFields())
                document.getElementById('cmdSaveAndClose').click();
            else
            {   
                var infobar = document.getElementById('validationSummaryInfo');
                infobar.show();
            }
        }

        function cancel()
        {
            document.getElementById('cmdCancel').click();
        }

        function deleteAssortment()
        {
            var relationWarning = '';
            var userAssociationWarning = '';

            <%If Me.HasRelation Then%>
            relationWarning = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("There are shops/groups/products attached to the assortment. ")%>';
            <%End If%>

            <%If Me.HasUserAssotiated Then%>
            userAssociationWarning = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("There are users/userGroups associated with the assortment. ")%>';
            <%End If%>


            if((relationWarning != '' || userAssociationWarning != '') && !confirm(relationWarning + userAssociationWarning + '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Are you sure you want to delete?")%>'))
                return;

            document.getElementById('cmdDelete').click();
        }

        function onHelp()
        {
		<%=Dynamicweb.SystemTools.Gui.Help("", "ecom.assortment.edit", "en") %>
        }

        function Delocalize()
        {
            var Message = '<%=Dynamicweb.SystemTools.Translate.JsTranslate("Delocalize?")%>';

            if(confirm(Message))
                return true;
            else
                return false;
        }

        function validateFields() 
        {
            var isOk = true;
            var nameEl = document.getElementById('<%=Me.tbxAssortmentName.ClientID%>');

            isOk = setErrorMark(nameEl.value != '', "errNameStr");
        
            var infobar = document.getElementById('validationSummaryInfo');

            if (isOk) 
                infobar.hide();
           
            return isOk;
        }

        function DetachItem() 
        {
            return confirm ('<%=Dynamicweb.SystemTools.Translate.JsTranslate("Delete?")%>');         
        }

        function setErrorMark(condition, field) 
        {
            $(field).innerHTML = !condition ? "*" : "";

            return condition;
        }

        document.observe("dom:loaded", function()
        {
            ribbonTab('<%=Me.CurrentTabName%>', <%=Me.CurrentTab%>);
        });
    </script>

</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="ContentHolder" runat="server">
    <link rel="Stylesheet" type="text/css" href="../css/productEdit.css" />

    <dw:RibbonBar ID="Ribbon" runat="server">
        <dw:RibbonBarTab ID="RibbonbarTab1" runat="server" Active="true" Name="Assortment">
            <dw:RibbonBarGroup ID="RibbonbarGroup1" runat="server" Name="Funktioner">
                <dw:RibbonBarButton runat="server" ID="rbbSave" Text="Gem" Size="Small" Icon="Save" OnClientClick="save();" />
                <dw:RibbonBarButton runat="server" ID="rbbSaveAndClose" Text="Gem og luk" Size="Small" Icon="Save" OnClientClick="saveAndClose();" />
                <dw:RibbonBarButton runat="server" ID="rbbCancel" Text="Annuller" Size="Small" Icon="TimesCircle" OnClientClick="cancel();" />
                <dw:RibbonBarButton runat="server" ID="rbbDelete" Text="Delete" Size="Small" Icon="Delete" OnClientClick="deleteAssortment();" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonBarGroupOptions" Name="Information" runat="server" DoNotSetActive="True">
                <dw:RibbonBarRadioButton ID="rbbDetailButton" Checked="False" Text="Details"
                    Size="Small"
                    runat="server" Icon="InfoCircle"
                    OnClientClick="ribbonTab('DETAIL', 0);" Group="attachTabs" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonBarGroup3" Name="Attachments" runat="server" DoNotSetActive="True">
                <dw:RibbonBarRadioButton ID="rbbAttachedShopsButton" Checked="False" Text="Attached shops"
                    Size="Small"
                    runat="server" Icon="Shop"
                    ContextMenuId="ShopContext" SplitButton="true"
                    OnClientClick="ribbonTab('SHOP', 1);" Group="attachTabs" />
                <dw:RibbonBarRadioButton ID="rbbAttachedGroupsButton" Checked="False" Text="Attached groups"
                    Size="Small"
                    runat="server" Icon="Sitemap"
                    ContextMenuId="GroupContext" SplitButton="true"
                    OnClientClick="ribbonTab('GROUP', 2);" Group="attachTabs" />
                <dw:RibbonBarRadioButton ID="rbbAttachedProdButton" Checked="False" Text="Attached products" Size="Small"
                    runat="server" Icon="Gift"
                    ContextMenuId="ProductContext" SplitButton="true"
                    OnClientClick="ribbonTab('PROD', 3);" Group="attachTabs" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonGroupLanguage" Name="Language" runat="server">
                <ecom:LanguageSelector ID="langSelector" OnClientSelect="selectLang" TrackFormChanges="true" runat="server" />
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonBarGroup23" Name="Delocalize" runat="server">
                <dw:RibbonBarButton ID="RibbonDelocalizeButton" Text="Delocalize" Icon="NotInterested" Size="Large"
                    runat="server" EnableServerClick="true" OnClick="RibbonDelocalizeButton_Click" OnClientClick="if(!Delocalize()) {return;};">
                </dw:RibbonBarButton>
            </dw:RibbonBarGroup>
            <dw:RibbonBarGroup ID="RibbonbarGroup2" runat="server" Name="Help">
                <dw:RibbonBarButton ID="cmd_help" runat="server" Text="Help" Icon="Help" Size="Large" OnClientClick="onHelp();" />
            </dw:RibbonBarGroup>
        </dw:RibbonBarTab>
    </dw:RibbonBar>
    <dw:ContextMenu ID="ShopContext" runat="server" MaxHeight="650">
        <dw:ContextMenuButton
            ID="ShopContextButton"
            runat="server"
            Icon="Check"
            IconColor="Default"
            Text="Add shops" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="GroupContext" runat="server" MaxHeight="650">
        <dw:ContextMenuButton
            ID="GroupContextButton"
            runat="server"
            Icon="Check"
            IconColor="Default"
            Text="Add groups" />
    </dw:ContextMenu>
    <dw:ContextMenu ID="ProductContext" runat="server" MaxHeight="650">
        <dw:ContextMenuButton
            ID="ProductContextButton"
            runat="server"
            Icon="Check"
            IconColor="Default"
            Text="Add products" />
    </dw:ContextMenu>
    <dw:StretchedContainer ID="AssortmentEditScroll" Stretch="Fill" Scroll="Auto" Anchor="document" runat="server">
        <div id="breadcrumb">
            <asp:Literal ID="Breadcrumb" runat="server" />
        </div>
        <dw:Infobar runat="server" ID="ibAssortDisabled" Type="Warning" Message="Assortments is not activated in frontend" />
        <div id="validationSummaryInfo" style="display: none;">
            <dw:Infobar runat="server" ID="ibError" Type="Error" Message="Please fill out all required fields" />
        </div>
        <div id="content" style="position: relative; overflow: auto;">
            <div id="Tab0" class="Tab0Div">
                <div id="PageContent0">
                    <dw:GroupBox Title="Settings" DoTranslation="True" runat="server">
                        <table cellpadding="0" cellspacing="0" class="tabTable100">
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                    <dw:TranslateLabel runat="server" Text="Name" />
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="tbxAssortmentName" CssClass="std" MaxLength="255"></asp:TextBox>
                                    <span id="errNameStr" style="color: Red;"></span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                    <dw:TranslateLabel runat="server" Text="Number" />
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="tbxAssortmentNumber" CssClass="std" MaxLength="255"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                    <dw:TranslateLabel runat="server" Text="Id" />
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="tbxAssortmentId" CssClass="std" ReadOnly="True" Enabled="False"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" ID="cbActive" />
                                        <label for="cbActive">
                                            <dw:TranslateLabel runat="server" Text="Active" />
                                      </label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" ID="cbIncludeSubgroups" />
                                        <label for="cbIncludeSubgroups">
                                            <dw:TranslateLabel runat="server" Text="Include subgroups" />
                                      </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
<%--                    <dw:GroupBox Title="Activate assortment" DoTranslation="True" runat="server">
                        <table cellpadding="0" cellspacing="0" class="tabTable100">
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                    <dw:TranslateLabel runat="server" Text="Campaign" />
                                </td>
                                <td>
                                    <td>
                                        <asp:DropDownList ID="ddlPeriodId" CssClass="NewUIinput" runat="server"></asp:DropDownList>
                                    </td>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>--%>
                    <dw:GroupBox Title="Frontend group(s) and user(s)" DoTranslation="True" runat="server">
                        <table cellpadding="0" cellspacing="0" class="tabTable100">
                            <tr>
                                <td style="width: 170px; padding: 5px; vertical-align:top;">
                                    <%=Translate.Translate("Users")%>
                                </td>
                                <td>
                                    <dw:UserSelector runat="server" ID="usUsers" NoneSelectedText="No one users have permission" Width="250" HideAdmins="True" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 170px; padding: 5px;">
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" ID="cbAllowAnonymousUsers" />
                                    <label for="cbAllowAnonymousUsers">
                                        <dw:TranslateLabel runat="server" Text="Anonymous users" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </div>
            <div id="Tab1" class="Tab1Div" style="display: none">
                <div id="PageContent1">
                    <div id="AssortmentShopData"></div>
                </div>
            </div>
            <div id="Tab2" class="Tab2Div" style="display: none">
                <div id="PageContent2">
                    <div id="AssortmentGroupData"></div>
                </div>
            </div>
            <div id="Tab3" class="Tab3Div" style="display: none">
                <div id="PageContent3">
                    <div id="AssortmentProductData"></div>
                </div>
            </div>
        </div>
    </dw:StretchedContainer>
    <input type="hidden" id="Tab" name="Tab" />
    <input type="hidden" id="TabName" name="TabName" />
    <input type="hidden" name="AssortmentID" id="AssortmentID" value="<%=Me.AssortmentID%>" />
    <input type="hidden" name="GroupAdded" id="GroupAdded" value="" />
    <input type="hidden" name="GroupRemoved" id="GroupRemoved" value="" />
    <input type="hidden" name="ShopAdded" id="ShopAdded" value="" />
    <input type="hidden" name="ShopRemoved" id="ShopRemoved" value="" />
    <input type="hidden" name="ProdAdded" id="ProdAdded" value="" />
    <input type="hidden" name="ProdRemoved" id="ProdRemoved" value="" />
    <input type="submit" name="cmdSave" id="cmdSave" value="True" style="display: none;" />
    <input type="submit" name="cmdSaveAndClose" id="cmdSaveAndClose" value="True" style="display: none;" />
    <input type="submit" name="cmdCancel" id="cmdCancel" value="True" style="display: none;" />
    <input type="submit" name="cmdDelete" id="cmdDelete" value="True" style="display: none;" />

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</asp:Content>

