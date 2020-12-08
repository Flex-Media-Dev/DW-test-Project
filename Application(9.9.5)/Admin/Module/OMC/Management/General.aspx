<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Content/Management/EntryContent2.Master" CodeBehind="General.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Management.General" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript">
        var page = SettingsPage.getInstance();

        page.onSave = function () {
            document.frmGlobalSettings.submit();
        }
        function deleteSelectedRowFields(obj) {
            var row = dwGrid_gridProfiles.findContainingRow(obj); 
            dwGrid_gridProfiles.deleteRows([row]);            
        }
    </script>
    <!--[if IE]>
    <style type="text/css">
        .omc-account select
        {
            width: 254px;
        }
    </style>
    <![endif]-->
</asp:Content>
<asp:Content  ContentPlaceHolderID="MainContent" runat="server">
    <div id="PageContent" class="omc-control-panel">
        <dw:GroupBox ID="gbEmailNotifications" Title="E-mail notification schemes" runat="server">
            <div class="omc-control-panel-conditional-hide">
                <div class="omc-cpl-hint" style="width: 750px;">
                <dw:TranslateLabel ID="lbEmailProfilesExplained" Text="Here you can configure email notification schemes used to send notifications throughout the system." runat="server" />
            </div>
            </div>

            <div class="omc-control-panel-grid-container">
                <div class="omc-control-panel-serverform-container">
                    <form runat="server">
                    <dw:EditableGrid ID="gridProfiles" AllowAddingRows="true" AllowDeletingRows="true" NoRowsMessage="No schemes found" AllowSortingRows="false" runat="server">
                        <Columns>
                            <asp:TemplateField HeaderText="Sender" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="270">
                                <ItemTemplate>
                                        <asp:HiddenField ID="hProfileID" Value='<%#Eval("ID")%>' runat="server" />
                                        &nbsp;<asp:TextBox ID="txSender" CssClass="std" Width="250" Text='<%#Eval("Sender")%>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Subject" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="270">
                                <ItemTemplate>
                                    <asp:TextBox ID="txSubject" CssClass="std" Width="250" Text='<%#Eval("Subject")%>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Template" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="250">
                                <ItemTemplate>                                    
                                    <dw:FileManager id="fmTemplate" Folder="Templates/OMC/Notifications" ClientIDMode="Static" FullPath="false" runat="server" />                                        
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Delete" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="60">
                                <ItemTemplate>
                                    <span class="omc-control-panel-grid-delete-offset">
                                        <a class="omc-control-panel-grid-noselect" href="javascript:void(0);" onclick="deleteSelectedRowFields(this);">
                                            <i class="<%= KnownIconInfo.ClassNameFor(KnownIcon.Remove) %>"></i>
                                        </a>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </dw:EditableGrid>

                    <input type="hidden" id="SaveEmailProfiles" name="SaveEmailProfiles" value="False" />
                    </form>
                </div>
            </div>
        </dw:GroupBox>
    </div>

    <script type="text/javascript">OMC.ControlPanel.getInstance().initialize();</script>


    <%Translate.GetEditOnlineScript()%>
</asp:Content>