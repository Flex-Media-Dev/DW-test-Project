<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditPermissions.aspx.vb" Inherits="Dynamicweb.Admin.UserManagement.EditPermissions" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Register Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true"></dw:ControlResources>
    <style type="text/css">
        .radio{
            text-align:center;
            padding-left:5px;
            margin-top: 0px;
        }
        .radio input[type="radio"]:disabled~label:before{
            background-color: #e0e0e0;
        }
        .permissions {
             width: 700px;
             margin-bottom: 24px;
        }
        .permissions td.heading {
            text-align:center;
            font-weight:bold;
            padding: 5px 0px;
        }
        .permissions td{
             padding: 0px;
        }
        .colName {
             width: 180px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="Cmd" name="Cmd" />
        <input type="hidden" id="ChangedPermissions" name="ChangedPermissions" />
        <div>
            <asp:Repeater ID="PermissionAreasRepeater" runat="server" OnItemDataBound="PermissionAreasRepeater_ItemDataBound" EnableViewState="false">
            <ItemTemplate>
                <dw:GroupBox ID="GroupBoxPermissions" runat="server">
                    <table class="permissions">
                        <asp:Repeater ID="PermissionSettingsRepeater" OnItemDataBound="PermissionSettingsRepeater_ItemDataBound" runat="server" EnableViewState="false">
                        <HeaderTemplate>
                            <tr class="row">
                                <td class="colName">
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="None" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Read" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Edit" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Create" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Delete" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Full" />
                                </td>
                                <td class="heading">
                                    <dw:TranslateLabel runat="server" Text="Not set" />
                                </td>
                            </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="row">                            
                                    <td>
                                        <%# Eval("Name") %>
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_None" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_Read" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_Edit" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_Create" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_Delete" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_All" runat="server" />
                                    </td>
                                    <td>
                                        <dwc:RadioButton ID="PermissionLevel_NotSet" runat="server" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            </asp:Repeater>  
                        </table>
                    </dw:GroupBox>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>

    <script type="text/javascript">
        $$('table.permissions input[type="radio"]').each(function(elm) {
            elm.addEventListener('click', function() {
                var changedPermissions = document.getElementById('ChangedPermissions')
                changedPermissions.value += elm.name + ',';
                }, false);
        });

        function saveAndClose() {
            var theForm = document.forms["form1"];
            theForm.Cmd.value = "SaveAndClose";

            if (theForm.onsubmit) theForm.onsubmit();
            theForm.submit();
        }
    </script>
</body>
</html>
