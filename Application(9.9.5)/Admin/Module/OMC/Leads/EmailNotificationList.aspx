<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationList.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.EmailNotificationList" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="EmailNotificationList" Src="~/Admin/Module/OMC/Controls/EmailNotificationList.ascx" %>

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
            <div id="divHasNotifications" class="omc-list-container" runat="server">
                <omc:EmailNotificationList ID="nList" runat="server" />
            </div>

            <div id="divEmpty" runat="server">
                <div class="omc-notifications-empty">
                    <dw:TranslateLabel ID="lbEmpty" Text="Please create at least one email notification first." runat="server" />
                </div>
            </div>
        </form>
    </body>

    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
