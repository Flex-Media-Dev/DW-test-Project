<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationAttach.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.EmailNotificationAttach" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="EmailNotificationEditor" Src="~/Admin/Module/OMC/Controls/EmailNotificationEditor.ascx" %>
<%@ Register TagPrefix="omc" TagName="EmailNotificationSelector" Src="~/Admin/Module/OMC/Controls/EmailNotificationSelector.ascx" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />

        <title><dw:TranslateLabel ID="lbTitle" Text="Email notifications" runat="server" /></title>
        <dw:ControlResources ID="ctrlResources" runat="server" />

        <style type="text/css">
            html, body
            {
                margin: 0px;
                padding: 0px;
                background-color: #efefef !important;
                border-right: none !important;
                height: auto;
            }
        </style>
    </head>
    <body>
        <form id="MainForm" runat="server">
            <div id="divHasProfiles" class="omc-notifications-attach" runat="server">
                <input type="hidden" name="ActionType" class="omc-notifications-attach-actiontype" value="" />
                <input type="hidden" name="ActionVisitors" class="omc-notifications-attach-actionvisitors" value="" />

                <fieldset class="omc-notifications-attach-choice-section omc-notifications-attach-choice-attach">
                    <legend>
                        <span>
                            <input type="radio" id="rbAttach" name="CreateType" value="Attach" />
                            <label for="rbAttach"><dw:TranslateLabel ID="lbAttach" Text="Add to existing notification" runat="server" /></label>
                            <span>&nbsp;</span>
                        </span>
                    </legend>
                                        
                    <div class="omc-notifications-attach-choice-content">
                        <omc:EmailNotificationSelector ID="nSelector" runat="server" />
                    </div>
                </fieldset>

                <br />

                <fieldset class="omc-notifications-attach-choice-section omc-notifications-attach-choice-create">
                    <legend>
                        <span>
                            <input type="radio" id="rbCreate" name="CreateType" value="Create" />
                            <label for="rbCreate"><dw:TranslateLabel ID="lbCreate" Text="Create new notification" runat="server" /></label>
                            <span>&nbsp;</span>
                         </span>
                    </legend>

                    <div class="omc-notifications-attach-choice-content">
                        <omc:EmailNotificationEditor ID="nEditor" runat="server" />
                    </div>
                </fieldset>

                <div style="display: none">
                    <asp:Button ID="cmdPostBack" CssClass="omc-notifications-attach-postback" runat="server" />
                </div>
            </div>
            <div id="divEmpty" class="omc-notifications-attach" runat="server">
                <div class="omc-notifications-empty">
                    <dw:TranslateLabel ID="lbEmpty" Text="Please create at least one email notification scheme first." runat="server" />
                </div>
            </div>
        </form>

        <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
    </body>
</html>
