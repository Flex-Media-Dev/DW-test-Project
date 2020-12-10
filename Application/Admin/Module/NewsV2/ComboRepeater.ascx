<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComboRepeater.ascx.vb" Inherits="Dynamicweb.Admin.ModulesCommon.ComboRepeater" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<table cellpadding="2" cellspacing="0">
    <tr> 
      <td class="leftCol" runat="server" id="LabelCell"><dw:TranslateLabel id="ComboLabel" runat="server"/></td>
        <td>
            <asp:DropDownList runat="server" ID="Combo" /> 
        </td>
        <td align="right"> 
            <asp:Button runat="server" ID="Add" CssClass="buttonSubmit" Text="Add" CausesValidation="false"/>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <asp:Repeater runat="server" ID="List">
                <HeaderTemplate>
                    <table width="100%" cellpadding="0" cellspacing="0" class="border_bot">
		                <tr> 
                            <td id="SelectedRowsLabel" class="border_bot"><strong><dw:TranslateLabel runat="server" Text="Selected" /></strong></td>
                            <td align="right" id="SelectedRowDeleteLabel" class="border_bot"><strong><dw:TranslateLabel runat="server" Text="Delete" /></strong></td>
		                </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td id='SelectedRow_<%# Eval(DataValueField)%>'><%# Eval(DataTextField)%></td>
                        <td align="right"><asp:ImageButton runat="server" CausesValidation="false" CommandName="DelRow" OnCommand="DelRow" CommandArgument='<%# Eval(DataValueField)%>' ImageUrl="/Admin/Images/Delete.gif" ToolTip='<%#Translate.Translate("Slet")%>'></asp:ImageButton></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </td>
    </tr>
    <tr><td colspan="3">
        <asp:CustomValidator ID="RequiredValidator" runat="server" Display="Dynamic" OnServerValidate="ValidateRequired" EnableClientScript="false"/>
    </td></tr>
</table>