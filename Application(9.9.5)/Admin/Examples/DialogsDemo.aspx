<%@ Page Language="vb" AutoEventWireup="false" ValidateRequest="false" CodeBehind="DialogsDemo.aspx.vb" Inherits="Dynamicweb.Admin.DialogsDemo" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dialogs</title>
    <dw:ControlResources runat="server">
    </dw:ControlResources>

</head>
<body class="screen-container">
    <div class="card area-teal">
        <div class="card-header">
            <h2>Dialogs</h2>
        </div>
        <div class="card">
            <div class="card-body">
                <div class="block m-b-20">
                    <button type="button" class="btn btn-default" onclick="dialog.show('ExtraSmallDialog')">Open xs dialog</button>
                </div>
                <div class="block m-b-20">
                    <button type="button" class="btn btn-default" onclick="dialog.show('SmallDialog')">Open sm dialog</button>
                </div>
                <div class="block m-b-20">
                    <button type="button" class="btn btn-default" onclick="dialog.show('MediumDialog')">Open md dialog</button>
                </div>
                <div class="block m-b-20">
                    <button type="button" class="btn btn-default" onclick="dialog.show('LargeDialog')">Open lg dialog</button>
                </div>
            </div>
        </div>
    </div>

    <div class="card-footer">
    </div>

    <dw:Dialog ID="ExtraSmallDialog" Size="Auto" runat="server" Title="Extra small dialog" TranslateTitle="False">
        <p>To use the extra small dialog size, simply set the "Size" property for the dw:Dialog to ="xs"</p>
        <p>The height is auto adjusted and the with is: <b>320px</b></p>
    </dw:Dialog>

    <dw:Dialog ID="SmallDialog" Size="Small" runat="server" Title="Small dialog" TranslateTitle="False">
        <p>To use the small dialog size, simply set the "Size" property for the dw:Dialog to ="sm"</p>
        <p>The height is auto adjusted and the with is: <b>440px</b></p>
    </dw:Dialog>

    <dw:Dialog ID="MediumDialog" Size="Medium" runat="server" Title="Medium dialog" TranslateTitle="False">
        <p>To use the medium dialog size, simply set the "Size" property for the dw:Dialog to ="md"</p>
        <p>The height is auto adjusted and the with is: <b>660px</b></p>
    </dw:Dialog>

    <dw:Dialog ID="LargeDialog" Size="Large" runat="server" Title="Large dialog" TranslateTitle="False">
        <p>To use the large dialog size, simply set the "Size" property for the dw:Dialog to ="lg"</p>
        <p>The height is auto adjusted and the with is: <b>850px</b></p>
    </dw:Dialog>
</body>
</html>
