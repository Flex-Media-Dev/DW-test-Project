<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ProfileDynamicsEditor.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.ProfileDynamicsEditor" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

    <style id="CH7" type="text/css" runat="server" visible="true">
        .C1
        {
	        vertical-align:middle;
	        width:200px;
        }
	
        .C2
        {
	        white-space:nowrap;
	        overflow:hidden;
	        width:120px;
	        vertical-align:middle;
            align-items:center;
        }

         .C2 > div
         {
             height:inherit;
             width:inherit;
             margin-top:8px;
         }

         .C2 > div > input 
         {
             margin-top: 10px;
             margin-left:20px;
         }
         ul
         {
             padding-left: 0px;
         }
    </style>

<div id="divSelectContainer" class="omc-dynamics-edit" runat="server">
    <input type="hidden" name="ActionType" class="omc-dynamics-edit-actiontype" value="" />
    
    <dw:GroupBox ID="presetContainer" runat="server">
        <span>
            <input type="radio" id="rbPreset" name="EditType" value="Preset" />
            <label for="rbPreset" class="gbTitle">
                <dw:TranslateLabel ID="TranslateLabel1" Text="Use existing preset" runat="server" />
            </label>
        </span>
        <table class="m-t-15">
            <tr>
                <td style="width: 170px;">
                    <label for="ddPresets">
                        <dw:TranslateLabel ID="lbSelectPreset" Text="Preset" runat="server" />
                    </label>
                </td>
                <td>
                    <dw:TemplatedDropDownList ID="ddPresets" Width="250" ExpandableAreaWidth="300" ExpandableAreaHeight="100" CssClass="selectpicker" OnClientDataExchange="Dynamicweb.Controls.OMC.ProfileDynamicsEditor._listDataExchange" runat="server">
                        <BoxTemplate>
                            <span class="omc-restrict-edit-list-item"><%#Eval("Label")%></span>
                        </BoxTemplate>
                        <ItemTemplate>
                            <span class="omc-restrict-edit-list-item"><%#Eval("Label")%></span>
                        </ItemTemplate>
                    </dw:TemplatedDropDownList>
                </td>
            </tr>
        </table>
    </dw:GroupBox>
    <dw:GroupBox ID="createContainer" runat="server">
        <span>
            <input type="radio" id="rbCreate" name="EditType" value="Create" />
            <label for="rbCreate" class="gbTitle">
                <dw:TranslateLabel ID="TranslateLabel2" Text="Specify manually" runat="server" />
            </label>
        </span>
            <div id="divCreateConstraint" class="omc-dynamics-edit-constraint" runat="server">
                <p>
                    <dw:TranslateLabel ID="lbCreateConstraint" Text="No visitor profiles has been created. Create at least one visitor profile first. Profiles are managed in the administration interface." runat="server" /><span style="height: 10px">&nbsp;</span><a id="lnkCreateProfile" href="javascript:void(0);" 
                        runat="server"><dw:TranslateLabel ID="lbCreateNotification" Text="Open administration interface" runat="server" /></a>
                </p>
            </div>

            <div id="divCreateList" runat="server" class="m-t-15">
            <table class="omc-restrict-edit-form" border="0" cellspacing="0" cellpadding="0">
                <tr class="omc-restrict-edit-form-field">
                    <td class="omc-restrict-edit-form-field-name" valign="top">                        
                            <dw:TranslateLabel ID="lbSelectProfile" Text="Add profile points" runat="server" />
                    </td>
                    <td class="omc-restrict-edit-form-field-value" valign="top">
                        <div class="omc-restrict-edit-profiles-container">

                            <div class="omc-restrict-edit-clear"></div>

                            <div class="omc-restrict-edit-profiles list">
                                <asp:Repeater ID="repProfiles" EnableViewState="false" runat="server">
                                    <HeaderTemplate>
                                        <ul>
                                            <li class="header">
                                                <span class="C1">
                                                    <%=Translate.Translate("Profile name")%>
                                                </span>
                                                <span class="C2">
                                                    <%=Translate.Translate("Points")%>
                                                </span>
                                                <span class="pipe"></span>
                                            </li>
                                        </ul>
                                        <div id="_contentWrapper">
                                            <ul id="items">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                                <li id="lstRow" runat="server">
                                                    <span class="C1">
                                                        <span id="spName" class="omc-dynamics-edit-profile-name" runat="server"></span>
                                                    </span>
                                                    <span class="C2">
                                                        <div class="omc-dynamics-edit-profile-points">
                                                            <omc:Slider ID="pSlider" Width="100" MinValue="0" MaxValue="50" FillSelection="true" Mode="Default" runat="server" />
                                                        </div>
                                                    </span>
                                                    <div class="omc-restrict-edit-clear"></div>
                                                </li>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                            </ul>
                                        </div>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <div style="height: 5px">&nbsp;</div>
                    </td>
                </tr>
                    <tr class="omc-dynamics-edit-form-field">
                        <td class="omc-dynamics-edit-form-field-name"  style="width: 170px;">
                            <dw:TranslateLabel ID="lbSaveAsPreset" Text="Save as new preset" runat="server" />
                        </td>
                        <td>
                            <input type="text" name="NewPreset" value="" class="std omc-dynamics-edit-newpreset" />
                        </td>
                    </tr>
            </table>
                </div>
    </dw:GroupBox>

    

    <div style="display: none">
        <asp:Button ID="cmdPostBack" CssClass="omc-dynamics-edit-postback" runat="server" />
    </div>

    <input type="hidden" id="hProfiles" class="omc-dynamics-edit-profiles" value="" runat="server" />
</div>