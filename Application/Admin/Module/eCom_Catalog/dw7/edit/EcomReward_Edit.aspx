<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomReward_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomReward_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Module/OMC/js/NumberSelector.js" />
            <dw:GenericResource Url="/Admin/Module/OMC/css/NumberSelector.css" />
        </Items>
    </dw:ControlResources>

    <link rel="Stylesheet" type="text/css" href="../css/EcomReward_Edit.css" />
    <script type="text/javascript" src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript" src="/Admin/FormValidation.js"></script>
    <script type="text/javascript" src="../js/EcomReward_Edit.js"></script>
</head>
<body>
    <div class="card">
        <ecom:Toolbar ID="Toolbar" runat="server"></ecom:Toolbar>
        <form id="Form1" method="post" runat="server" style="padding: 1px;">
            <input id="Close" type="hidden" name="Close" value="0" />
            <dw:Infobar runat="server" Visible="false" ID="NotLocalizedInfo" Type="Warning" Message="The reward is not localized to this language. Save the reward to localize it." />
            <dw:Infobar runat="server" Visible="false" ID="NotDefaultInfo" Type="Information" Message="To edit the reward details you need to edit the reward in the default language" />
            <dwc:GroupBox runat="server" Title="Indstillinger" ClassName="props-group">
                <table class="formsTable">
                    <tr>
                        <td class="rewardField">
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="NewUIinput" runat="server" />
                            <span id="errNameStr" style="display: none" class="error"><%=Translate.Translate("Name of reward can't be empty. Please specify name of reward")%></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="rewardField"></td>
                        <td>
                            <dw:CheckBox ID="activeBox" runat="server" />
                            <label for="activeBox">
                                <dw:TranslateLabel ID="tActive" runat="server" Text=" Active" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td class="rewardField">
                            <dw:TranslateLabel ID="tRewardType" runat="server" Text="Reward type" />
                        </td>
                        <td>
                            <div id="errType" class="error" style="display: none"><%=Translate.Translate("Select reward type")%></div>
                            <label for="rFixed" class="radio-inline">
                                <asp:RadioButton ID="rFixed" GroupName="rewardType" runat="server" onclick='javascript:Dynamicweb.eCommerce.Loyalty.Reward.rFixed_CheckedChanged();' />
                                <%= Translate.JsTranslate("Fixed")%>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <label for="rPercent" class="radio-inline">
                                <asp:RadioButton ID="rPercent" GroupName="rewardType" runat="server" onclick='javascript:Dynamicweb.eCommerce.Loyalty.Reward.rFixed_CheckedChanged();' />
                                <%= Translate.JsTranslate("Percentage")%>
                            </label>
                        </td>
                    </tr>
                    <tr class="fix hidden">
                        <td>
                            <dw:TranslateLabel Text="Points" runat="server" />
                        </td>
                        <td>
                            <dwc:InputNumber ID="pointsNum" runat="server"></dwc:InputNumber>
                            <div id="errpointsNum" class="error"></div>
                        </td>
                    </tr>
                    <tr class="percent hidden">
                        <td>
                            <dw:TranslateLabel Text="Value" runat="server" />, %
                        </td>
                        <td>                            
                            <dwc:InputNumber ID="pointsPercent" runat="server"></dwc:InputNumber>
                            <div id="errpointsPercent" class="error"></div>                            
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Currency" runat="server" />
                        </td>
                        <td>                            
                            <asp:DropDownList CssClass="NewUIinput" ID="ddCurrency" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel Text="Rounding" runat="server" />
                        </td>
                        <td>                            
                            <asp:DropDownList CssClass="NewUIinput" ID="ddRounding" runat="server"></asp:DropDownList>                        
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox Title="Rules" runat="server">
                <div style="padding-bottom: 4px;">
                    <dw:TranslateLabel ID="RulesHint" runat="server" Text="The reward is applied if at least one of these rules are met." />
                </div>
                <dw:EditableList ID="Rules" runat="server" AllowPaging="true" AllowSorting="true" AddNewRowCaption="Add rule" AutoGenerateColumns="false"></dw:EditableList>
            </dwc:GroupBox>

            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>

            <dw:Dialog runat="server" ID="UsageDialog" OkAction="dialog.hide('UsageDialog');" ShowCancelButton="false" ShowClose="false" ShowOkButton="true" Title="Usage" TranslateTitle="true">
                <div>
                    <asp:Literal runat="server" ID="UsageContent" />
                </div>
            </dw:Dialog>
        </form>
    </div>
</body>
</html>
