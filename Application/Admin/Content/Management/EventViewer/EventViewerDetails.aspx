<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerDetails.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerDetails" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer details</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerDetails.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerDetails.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <form id="form1" runat="server">
        <dw:Overlay ID="PleaseWait" runat="server" />
        <div class="card">            
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Solution settings"></dwc:CardHeader>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="DatabaseGroupBox" runat="server" Title="Event information" GroupWidth="6">
                        <div class="form-group">
                            <label class="control-label">Id</label>
                            <div><asp:Literal ID="EventId" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Action</label>
                            <div><asp:Literal ID="EventAction" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Category</label>
                            <div><asp:Literal ID="EventCategory" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Level</label>
                            <div><asp:Literal ID="EventLevelName" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">User Id</label>
                            <div><asp:Literal ID="EventUserId" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">User Name</label>
                            <div><asp:Literal ID="EventUserName" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Description</label>
                            <div class="form-group-input" style="white-space:pre;"><asp:Literal ID="EventDescription" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Created</label>
                            <div><asp:Literal ID="EventCreated" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Machine name</label>
                            <div><asp:Literal ID="EventMachineName" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">Exception type</label>
                            <div><asp:Literal ID="EventExceptionType" runat="server" /></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label">File log</label>
                            <div><asp:Literal ID="EventFileLogPath" runat="server" /></div>
                        </div>
                    </dwc:GroupBox>
                    <dwc:GroupBox ID="FileGroupBox" runat="server" Title="FileLog information" GroupWidth="6">
                        <div class="form-group logInfo">
                            <style>
                                textarea{
                                    width:60%;
                                }
                            </style>
                            <label class="control-label">Log content</label>
                            <div><dwc:InputTextArea ID="LogFileContent" runat="server" Disabled="true" Rows="15" Cols="600" /></div>
                        </div>
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <dwc:ActionBar runat="server">
                <dw:ToolbarButton runat="server" Text="Back" Size="Small" Image="NoImage" OnClientClick="EventViewerDetails.cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
            </dwc:ActionBar>
        </div>
    </form>
</body>
</html>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>