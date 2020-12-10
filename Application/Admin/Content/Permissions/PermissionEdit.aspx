<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PermissionEdit.aspx.vb" Inherits="Dynamicweb.Admin.PermissionEdit" ClientIDMode="Static" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.Security.Permissions" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <dw:ControlResources runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        #GroupBoxPermissions .row{
            margin-bottom: 5px;
        }
        .radio{
            margin-top: 0px;
            margin-bottom: 0px;
        }
        .colRemove {
            padding-left: 16px !important;
        }
        .colRemove > i{
            cursor: pointer;
        }
        .serverrole {
            font-style: italic;
        }
        .row > div{
            padding:2px 0!important;
        }
        .heading, .colRemove{
            text-align:center;
            font-weight:bold;
        }

        .col-sm-1 .radio{
            text-align:center;
            padding-left:5px;
        }

        .radio label.disabledCursor {
            cursor: not-allowed;
        }

        .radio input {
            left: 15px;
        }
    </style>
</head>
<body>
<dwc:DialogLayout runat="server" ID="PermissionEdit" Title="Permissions" HidePadding="True">
    <Content>
        <div class="col-md-0">
            <dw:Infobar runat="server" ID="AccessDeniedMessage" Visible="false" Type="Error" Message="You do not have rights to manage permissions for this object!"></dw:Infobar>

            <dw:GroupBox runat="server" ID="GroupBoxPermissions" Title="Permissions" DoTranslation="false">
                <asp:Repeater ID="PermissionsRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>
                        <div class="row">
                            <div class="col-sm-4">
                                <strong><dw:TranslateLabel runat="server" Text="Groups" /></strong>
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="None" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Read" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Edit" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Create" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Delete" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Full" />
                            </div>
                            <div class="col-sm-2 heading">
                                <dw:TranslateLabel runat="server" Text="Remove" />
                            </div>
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="row">                            
                            <div class="col-sm-4" title="Group">
                                <%# GetUserName(CType(Container.DataItem, UnifiedPermission).UserId) %>
                                <input type="hidden" name="permissionUserId" value="<%# CType(Container.DataItem, UnifiedPermission).UserId %>" />
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">                                    
                                    <input type="radio" value="<%# PermissionLevel.None %>" id="<%# "None_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.None, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.None) %> /><label for="<%# "None_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" value="<%# PermissionLevel.Read %>" id="<%# "Read_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.Read, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.Read) %> /><label for="<%# "Read_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" value="<%# PermissionLevel.Edit %>" id="<%# "Edit_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.Edit, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.Edit) %> /><label for="<%# "Edit_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" value="<%# PermissionLevel.Create %>" id="<%# "Create_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.Create, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.Create) %> /><label for="<%# "Create_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" value="<%# PermissionLevel.Delete %>" id="<%# "Delete_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.Delete, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.Delete) %> /><label for="<%# "Delete_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" value="<%# PermissionLevel.All %>" id="<%# "All_" & CType(Container.DataItem, UnifiedPermission).UserId %>" name="permissionLevel<%# CType(Container.DataItem, UnifiedPermission).UserId %>" <%# if(CType(Container.DataItem, UnifiedPermission).Permission = PermissionLevel.All, "checked='checked'", "") %> <%= SetLevelDisabled(PermissionLevel.All) %> /><label for="<%# "All_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-2 colRemove">
                                <i title="Remove row" class="fa fa-remove color-danger" onclick="removeUsersAndGroupPermission(this);"></i>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div runat="server" id="divNoPermissions" visible="<%# PermissionsRepeater.Items.Count = 0 %>" class="row">
                            <div class="col-sm-4">
                                </div>
                            <div class="col-sm-8 text-center">
                                <dw:TranslateLabel runat="server" Text="No explicit permissions exist" />
                                </div>
                            
                        </div>
                    </FooterTemplate>
                </asp:Repeater>                

                <div id="newPermissionRowTemplate" style="display: none">
                    <div class="col-sm-4">
                        __UserName__
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="1" name="permissionLevel__UserId__" checked="checked" <%= SetLevelDisabled(PermissionLevel.None) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="4" name="permissionLevel__UserId__" <%= SetLevelDisabled(PermissionLevel.Read) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="20" name="permissionLevel__UserId__" <%= SetLevelDisabled(PermissionLevel.Edit) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="84" name="permissionLevel__UserId__" <%= SetLevelDisabled(PermissionLevel.Create) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="340" name="permissionLevel__UserId__" <%= SetLevelDisabled(PermissionLevel.Delete) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-1">
                        <div class="radio">
                            <input type="radio" value="1364" name="permissionLevel__UserId__" <%= SetLevelDisabled(PermissionLevel.All) %>><label for=""></label>
                        </div>
                    </div>
                    <div class="col-sm-2 colRemove">
                        <i title="Remove row" class="fa fa-remove color-danger" onclick="removeUsersAndGroupPermission(this);"></i>
                    </div>
                </div>
                <div class="text-center">
                    <span class="btn btn-flat footer-btn" style="min-width: 120px" onclick="addGroupClick();"><i class="md md-people-outline color-users"></i>&nbsp;<dw:TranslateLabel runat="server" Text="Add group" /></span>
                </div>  
            </dw:GroupBox>

            <dw:GroupBox runat="server" ID="GroupBoxForInheritedPermissions" Title="Inherited Permissions">
                <asp:Repeater ID="InheritedPermissionsRepeater" runat="server" EnableViewState="false">
                    <HeaderTemplate>
                        <div class="row">
                            <div class="col-sm-4">
                                <strong><dw:TranslateLabel runat="server" Text="Groups" /></strong>
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="None" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Read" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Edit" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Create" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Delete" />
                            </div>
                            <div class="col-sm-1 heading">
                                <dw:TranslateLabel runat="server" Text="Full" />
                            </div>                           
                        </div>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="row <%# if(CType(Container.DataItem, RenderedPermission).Visible, "", "hidden")%>" id="rowInheritedPermission_<%# CType(Container.DataItem, RenderedPermission).UserId %>">                            
                            <div class="col-sm-4" title="<%#GetHintText(CType(Container.DataItem, RenderedPermission))%>">
                                <%# Dynamicweb.Core.UI.Icons.KnownIconInfo.GetIconHtml(CType(Container.DataItem, RenderedPermission).Icon) %> <%# GetUserName(CType(Container.DataItem, RenderedPermission).UserId) %>
                                <input type="hidden" name="inheritedPermissionUserId" value="<%# CType(Container.DataItem, RenderedPermission).UserId %>" />
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">                                    
                                    <input type="radio" disabled id="<%# "InheritedNone_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.None %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.None, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedNone_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" disabled id="<%# "InheritedRead_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.Read %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.Read, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedRead_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" disabled id="<%# "InheritedEdit_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.Edit %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.Edit, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedEdit_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" disabled id="<%# "InheritedCreate_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.Create %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.Create, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedCreate_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" disabled id="<%# "InheritedDelete_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.Delete %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.Delete, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedDelete_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>
                            <div class="col-sm-1">
                                <div class="radio">
                                    <input type="radio" disabled id="<%# "InheritedAll_" & CType(Container.DataItem, UnifiedPermission).UserId %>" value="<%# PermissionLevel.All %>" name="inheritedPermissionLevel<%# CType(Container.DataItem, RenderedPermission).UserId %>" <%# if(CType(Container.DataItem, RenderedPermission).Permission = PermissionLevel.All, "checked='checked'", "") %> /><label class="disabledCursor" for="<%# "InheritedAll_" & CType(Container.DataItem, UnifiedPermission).UserId %>"></label>
                                </div>
                            </div>                            
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        <div runat="server" id="div1" visible="<%# InheritedPermissionsRepeater.Items.Count = 0 %>" class="row text-center">
                            <dw:TranslateLabel runat="server" Text="No inherited permissions exist" />
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </dw:GroupBox> 
        </div>
    </Content>
    <Footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Submit'})" id="SaveButton" runat="server"><dw:TranslateLabel runat="server" Text="Save and close" /></button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})"><dw:TranslateLabel runat="server" Text="Close" /></button>
    </Footer>
</dwc:DialogLayout>
   
    <script type="text/javascript">
        function removeUsersAndGroupPermission(el) {
            var row = el.closest(".row");
            if (row) {
                row.parentNode.removeChild(row);

                let id = row.querySelector('input[name="permissionUserId"]').value;
                let inheritedRow = document.getElementById("rowInheritedPermission_" + id);
                if (inheritedRow){
                    dwGlobal.Dom.removeClass(inheritedRow, "hidden");
                }
            }
        }

        function addGroupClick() {
            var self = this;
            Action.Execute({
                Name: "OpenDialog",
                Url: "/admin/users/dialogs/selectusergroup?mode=33&multiselect=true",
                OnSelected: {
                    Name: "ScriptFunction",
                    Function: function (opts, model) {
                        for (var i = 0; i < model.length; i++) {
                            var id = model[i].Selected;
                            var name = model[i].SelectedName;                            
                            addUsersAndGroupPermission(id, name);

                            let inheritedRow = document.getElementById("rowInheritedPermission_" + id);
                            if (inheritedRow){
                                dwGlobal.Dom.addClass(inheritedRow, "hidden");
                            }
                        }

                        var divNoPermissions = document.getElementById('divNoPermissions');
                        if (divNoPermissions) {
                            divNoPermissions.parentNode.removeChild(divNoPermissions);
                        }
                    }
                }
            });
        }

        function addUsersAndGroupPermission(userId, userName) {
            if (userId == "") return;
            if (document.querySelectorAll('input[name="permissionUserId"][value="' + userId + '"]').length > 0) return;
           
            var permissionTemplate = document.getElementById('newPermissionRowTemplate');
            var div = document.createElement('div');
            div.className = 'row';
            div.innerHTML = permissionTemplate.innerHTML.replace("__UserName__", userName).replace(new RegExp("__UserId__", "g"), userId);

            var permissionUserId = document.createElement("input");
            permissionUserId.setAttribute("type", "hidden");
            permissionUserId.setAttribute("name", "permissionUserId");
            permissionUserId.setAttribute("value", userId);
            div.appendChild(permissionUserId);

            permissionTemplate.parentNode.insertBefore(div, permissionTemplate);
        }
    </script>
    </body>
</html>