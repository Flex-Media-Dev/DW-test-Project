<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FieldOptionsList.ascx.vb" Inherits="Dynamicweb.Admin.eComBackend.FieldOptionsList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<script type="text/javascript">
    FieldOptionsList.EnforceUniqueValues = "<%=EnforceUniqueValues%>".toLowerCase() === "true";
</script>

<div class="grid-container">
    <dw:EditableGrid ID="optionsGrid" AllowAddingRows="true" AddNewRowMessage="Click here to add new option..." 
        NoRowsMessage="No options found" AllowDeletingRows="false" AllowSortingRows="true" runat="server">
        <Columns>
            <asp:TemplateField HeaderText="Name" HeaderStyle-Width="250">
                <ItemTemplate>
                    <div style="white-space: nowrap">
                        <asp:TextBox ID="txName" CssClass="std" Text='<%#TranslatedName(Container.DataItem)%>' runat="server" />
                    </div>
                    <asp:HiddenField ID="hID" Value='<%#Eval("ID")%>' runat="server" />
                    <small class="help-block error"><dw:TranslateLabel Text="Please fill option name." runat="server" /></small>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Value">
                <ItemTemplate>
                    <asp:TextBox ID="txValue" CssClass="std" Text='<%#Eval("Value")%>' runat="server" />
                    <asp:HiddenField ID="hValue" Value='<%#Eval("Value")%>' runat="server" />
                    <small class="help-block error"><dw:TranslateLabel Text="The value is not unique." runat="server" /></small>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Default" HeaderStyle-Width="75" ItemStyle-CssClass="alignedOption">
                <ItemTemplate>
                    <dw:CheckBox ID="chkDefault" Checked='<%#Eval("IsDefault")%>' runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Delete" HeaderStyle-Width="75" ItemStyle-CssClass="alignedOption">
                <ItemTemplate>
                    <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>" onclick="FieldOptionsList.deleteRow(this);"></i>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </dw:EditableGrid>    
    <div class="text-center" runat="server" id="ListViewButtonContainer">
        <dwc:Button runat="server" ID="OpltionsListButton"></dwc:Button>
    </div>
</div>
<dw:Infobar runat="server" ID="lbSorting" Title="Hint: you can change options order by dragging rows in the list." Message="Hint: you can change options order by dragging rows in the list."></dw:Infobar>

<span class="hidden message-delete-row"><dw:TranslateLabel ID="lbDeleteRow" Text="Are you sure you want to delete an option '%%' ?" runat="server" /></span>
<span class="hidden message-not-specified"><dw:TranslateLabel ID="lbNotSpecified" Text="Not specified" runat="server" /></span>
<span class="hidden message-not-unique-values"><dw:TranslateLabel ID="lbNotUnique" Text="The value is not unique '%%'." runat="server" /></span>