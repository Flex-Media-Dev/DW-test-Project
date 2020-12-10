<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ParagraphListModules.ascx.vb" Inherits="Dynamicweb.Admin.ParagraphListModules" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>

<script type="text/javascript">
    function <%=Me.ID%>_submitChoice(module) {
        var act = location.href;
        
        act = act.replace(/\?ParagraphModuleSystemName=([^&\?]+)/gi, '');
        act = act.replace(/&ParagraphModuleSystemName=([^&\?]+)/gi, '');
        
        if(act.indexOf('#') >= 0)
            act = act.substring(0, act.indexOf('#'));
        
        act += ((act.indexOf('?') >= 0 ? '&' : '?') + 'ParagraphModuleSystemName=' + module);
        
        window.self.location = act;
    }
</script>

<table style="width:100%">
    <asp:Repeater ID="repRows" runat="server" EnableViewState="false">
        <ItemTemplate>
            <tr>
                <asp:Repeater ID="repColumns" runat="server">
                    <ItemTemplate>
                        <td align="left" width="50%">
                            <asp:Literal ID="icon" runat="server"></asp:Literal>&nbsp;
                            <asp:Literal ID="hLink" runat="server"></asp:Literal>                            
                        </td>
                    </ItemTemplate>
                </asp:Repeater>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    
    <asp:PlaceHolder ID="phNotFound" runat="server">
        <tr>
            <td>
                <dw:TranslateLabel id="lbNotFound" Text="Ikke_fundet" runat="server" />
            </td>
        </tr>
    </asp:PlaceHolder>
</table>
