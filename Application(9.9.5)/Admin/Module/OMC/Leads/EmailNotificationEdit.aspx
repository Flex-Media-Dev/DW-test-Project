<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailNotificationEdit.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Leads.EmailNotificationEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" TagName="EmailNotificationEditor" Src="~/Admin/Module/OMC/Controls/EmailNotificationEditor.ascx" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />

        <title><dw:TranslateLabel ID="lbTitle" Text="Email notifications" runat="server" /></title>
        <dw:ControlResources ID="ctrlResources" runat="server">
            <Items>
            </Items>
        </dw:ControlResources>

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
            <input type="hidden" name="ActionType" class="omc-notifications-attach-actiontype" value="" />
            <input type="hidden" name="ActionVisitors" class="omc-notifications-attach-actionvisitors" value="" />

            <div class="omc-notifications-edit-visitors">
                <dw:TabStrip ID="stTabs" runat="server">
                    <dw:Tab Name="Settings" Translate="true" Active="true" runat="server">
                       <div class="omc-notifications-attach-choice-content">
                            <omc:EmailNotificationEditor ID="nEditor" runat="server" />
                        </div>
                    </dw:Tab>
                    <dw:Tab Name="Visitors" Translate="true" runat="server">
                        <div class="omc-list-container">
                            <dw:List ID="lstVisitors" PageSize="10" ShowTitle="false" NoItemsMessage="No visitors found." runat="server">
                                <Columns>
                                    <dw:ListColumn ID="colAddress" Name="IP-address" Width="250" EnableSorting="false" runat="server" />
                                    <dw:ListColumn ID="colLastVisit" Name="Last visit" Width="150" EnableSorting="false" runat="server" />
                                    <dw:ListColumn ID="colDelete" Name="Delete" Width="100" EnableSorting="false" HeaderAlign="Center" ItemAlign="Center" runat="server" />
                                </Columns>
                            </dw:List>
                        </div>
                    </dw:Tab>
                </dw:TabStrip>

                <div style="display: none">
                    <asp:Button ID="cmdPostBack" CssClass="omc-notifications-attach-postback" runat="server" />
                </div>
            </div>
        </form>

        <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
    </body>
</html>
