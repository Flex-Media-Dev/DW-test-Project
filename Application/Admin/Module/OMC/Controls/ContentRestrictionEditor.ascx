<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ContentRestrictionEditor.ascx.vb" Inherits="Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditor" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

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
         .fieldset-radio {
            vertical-align: bottom;
            margin-bottom: 3px;
         }
    </style>

<div id="divSelectContainer" class="omc-restrict-edit" runat="server">
    <input type="hidden" name="ActionType" class="omc-restrict-edit-actiontype" value="" />

    <dw:GroupBox ID="notActiveContainer" runat="server">
        <input type="radio" id="rbNotActive" name="EditType" value="Preset" class="fieldset-radio" />
        <label for="rbNotActive" class="gbTitle">
            <dw:TranslateLabel ID="lbNotActive" Text="Personalization is not active" runat="server" />
        </label>
    </dw:GroupBox>
    <dw:GroupBox ID="presetContainer" runat="server">
        <div>
            <input type="radio" id="rbPreset" name="EditType" value="Preset" class="fieldset-radio" />
            <label for="rbPreset" class="gbTitle">
                <dw:TranslateLabel ID="lbPreset" Text="Use existing preset" runat="server" />
            </label>
        </div>
        <table class="m-t-15">
            <tr>
                <td style="width: 170px;">
                    <label for="ddPresets">
                        <dw:TranslateLabel ID="lbSelectPreset" Text="Preset" runat="server" />
                    </label>
                </td>
                <td>
                    <dw:TemplatedDropDownList ID="ddPresets" Width="250" ExpandableAreaWidth="300" ExpandableAreaHeight="100" CssClass="selectpicker" OnClientDataExchange="Dynamicweb.Controls.OMC.ContentRestrictionEditor._listDataExchange" runat="server">
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
        <div>
            <input type="radio" id="rbCreate" name="EditType" value="Create" class="fieldset-radio" />
            <label for="rbCreate" class="gbTitle">
                <dw:TranslateLabel ID="lbCreate" Text="Specify manually" runat="server" />
            </label>
        </div>
        <div id="divCreateConstraint" class="omc-restrict-edit-constraint" runat="server">
            <p>
                <dw:TranslateLabel ID="lbCreateConstraint" Text="No visitor profiles has been created. Create at least one visitor profile first. Profiles are managed in the administration interface." runat="server" />
                <span style="height: 10px">&nbsp;</span><a id="lnkCreateProfile" href="javascript:void(0);"
                    runat="server"><dw:TranslateLabel ID="lbCreateNotification" Text="Open administration interface" runat="server" />
                </a>
            </p>
        </div>
        <div id="divCreateList" class="m-t-15" runat="server">
            <table class="omc-restrict-edit-form" border="0" cellspacing="0" cellpadding="0">
                <tr class="omc-restrict-edit-form-field">
                    <td class="omc-restrict-edit-form-field-name" valign="top">
                        <dw:TranslateLabel ID="lbEvaluate" Text="Personalize based on" runat="server" />
                    </td>
                    <td class="omc-restrict-edit-form-field-value" valign="top">
                        <ul style="list-style: none" class="omc-restrict-unorderedlist">
                            <li class="omc-restrict-evaluationtype-primary">
                                <input type="radio" id="EvaluationType1" name="EvaluationType" value="1" />
                                <label for="EvaluationType1">
                                    <dw:TranslateLabel ID="lbPrimaryProfile" Text="Primary profile only" runat="server" />
                                </label>
                                <div class="omc-restrict-edit-clear"></div>
                            </li>
                            <li class="omc-restrict-evaluationtype-recognized">
                                <input type="radio" id="EvaluationType0" name="EvaluationType" value="0" />
                                <label for="EvaluationType0">
                                    <dw:TranslateLabel ID="lbRecognizedProfile" Text="Any recognized profile" runat="server" />
                                </label>
                                <div class="omc-restrict-edit-clear"></div>
                            </li>
                        </ul>
                    </td>
                </tr>
                <tr class="omc-restrict-edit-form-field">
                    <td class="omc-restrict-edit-form-field-name" valign="top">
                        <dw:TranslateLabel ID="lbSelectProfile" Text="" runat="server" />
                    </td>
                    <td class="omc-restrict-edit-form-field-value" valign="top">
                        <div id="fApplyModeOptions" class="omc-restrict-edit-apply-mode" runat="server">
                            <ul style="list-style: none" class="omc-restrict-unorderedlist">
                                <li class="omc-restrict-applymode-show">
                                    <input type="radio" id="ApplyMode1" name="ApplyMode" value="1" />
                                    <label for="ApplyMode1">
                                        <dw:TranslateLabel ID="lbApplyMode1" Text="Show to selected profiles" runat="server" />
                                    </label>
                                    <div class="omc-restrict-edit-clear"></div>
                                </li>
                                <li class="omc-restrict-applymode-hide">
                                    <input type="radio" id="ApplyMode2" name="ApplyMode" value="2" />
                                    <label for="ApplyMode2">
                                        <dw:TranslateLabel ID="TranslateLabel2" Text="Hide to selected profiles" runat="server" />
                                    </label>
                                    <div class="omc-restrict-edit-clear"></div>
                                </li>
                            </ul>
                        </div>
                        <div class="omc-restrict-edit-profiles-container">

                            <div class="omc-restrict-edit-clear"></div>

                            <div class="omc-restrict-edit-profiles list">
                                <asp:Repeater ID="repProfiles" EnableViewState="false" runat="server" OnItemDataBound="repProfiles_ItemDataBound">
                                    <HeaderTemplate>
                                        <ul>
                                            <li class="header">
                                                <span class="C1">
                                                    <%=Translate.Translate("Profile name")%>
                                                </span>
                                                <span class="C2">
                                                    <%=If(Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Restrict, Translate.Translate("Visibility"), Translate.Translate("Include"))%>
                                                </span>
                                                <span class="pipe"></span>
                                            </li>
                                        </ul>
                                        <div id="_contentWrapper">
                                            <ul id="items">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li class='<%#If(IsLastProfile(CType(Container.DataItem, Dynamicweb.Analytics.Profiles.Profile)), "omc-restrict-edit-profile-last", String.Empty)%> <%#If(IsSelectedProfile(CType(Container.DataItem, Dynamicweb.Analytics.Profiles.Profile)), "omc-restrict-edit-profile-selected", String.Empty)%>'>
                                            <span class="C1">
                                                <asp:Label ID="lbProfile" CssClass="omc-restrict-edit-profile-name" ToolTip='<%#System.Web.HttpUtility.HtmlAttributeEncode(Converter.ToString(Eval("Description")))%>' Text='<%#Eval("Label")%>' runat="server" />
                                            </span>
                                            <span class="C2">
                                                <div class="omc-restrict-edit-profile-visibility">
                                                    <span id="restrictEditProfileVisibility" runat="server"></span>                                                    
                                                    <asp:DropDownList ID="ddlVisibility" runat="server" DataTextField="Text" DataValueField="Value" Visible="<%#Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Reorder %>" DataSource='<%# GetVisibilityItems(CStr(Eval("Reference")))%>' />
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
                        <div class="omc-restrict-edit-visibility-actions-container" style="display: none">
                            <a class="omc-restrict-edit-visibility-hide-all" title="<%= Translate.Translate(If(Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Reorder, "Default for all profiles", "Click to hide all profiles")) %>" href="javascript:void(0);">
                                <%= Translate.Translate(If(Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Reorder, "Default for all", "Hide for all profiles"))%>
                            </a>
                            <a class="omc-restrict-edit-visibility-show-all" title="<%= Translate.Translate(If(Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Reorder, "Sort on top for all profiles", "Click to show all profiles")) %>" href="javascript:void(0);">
                                <%= Translate.Translate(If(Type = Dynamicweb.Admin.OMC.Controls.ContentRestrictionEditorRestrictionType.Reorder, "Sort on top for all", "Show to all profiles"))%>
                            </a>
                        </div>
                        <div style="height: 5px">&nbsp;</div>
                    </td>
                </tr>
                <tr class="omc-restrict-edit-form-field">
                    <td style="width: 170px;" class="omc-restrict-edit-form-field-name">
                        <dw:TranslateLabel ID="lbSaveAsPreset" Text="Save as new preset" runat="server" />
                    </td>
                    <td>
                        <input type="text" name="NewPreset" value="" class="std omc-restrict-edit-newpreset" />
                    </td>
                </tr>
            </table>
        </div>
    </dw:GroupBox>

    <div style="display: none">
        <asp:Button ID="cmdPostBack" CssClass="omc-restrict-edit-postback" runat="server" />
    </div>

    <input type="hidden" id="hProfiles" class="omc-restrict-edit-profiles" value="" runat="server" />
</div>
