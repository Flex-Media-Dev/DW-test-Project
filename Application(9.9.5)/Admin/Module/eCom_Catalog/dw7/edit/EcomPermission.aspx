<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomPermission.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomPermission" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Ecommerce.UserPermissions" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title><%=Translate.JsTranslate("User Permissions")%></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    <script type="text/javascript">
        var allRightsGranted = <%= DirectCast(Dynamicweb.Ecommerce.UserPermissions.UserPermissionRights.All, Integer).ToString() %>;
        var noneRightsGranted = <%= DirectCast(Dynamicweb.Ecommerce.UserPermissions.UserPermissionRights.None, Integer).ToString() %>;
        function definedRight(userID, userName, isGroup, permissions, inherited){
            this.userID = userID;
            this.isGroup = isGroup;
            this.userName = userName;
            this.permissions = permissions;
            this.inherited = inherited;
        }
        var ChangeStatusModes = {
            Unchanged: 0,
            Added: 1,
            Changed: 2,
            Deleted: 4
        };
        var htRights = {};
        <%= InjectRightsJavascript() %>
        var guitextConfirmClose = "<%=Translate.JsTranslate("Are you sure you want to close the window?\nYour changes will be lost")%>";
        
        var guitextUnknownError = "<%=Translate.JsTranslate("An unknown error occured. Permissions were not saved.")%>";
        var guitextEveryone = "<%=Translate.JsTranslate("Everyone")%>";
    </script>

    <script language="javascript" type="text/javascript">
        function getHelp(){
            <%=Gui.Help("", "ecom.permissions", "en") %>
        }
        
        window.selectedItem = null;
        function ItemSelected(selectedItemId) {
            var userItems = this.items;
            window.selectedItem = null;
            for(var i = 0; i < userItems.length; i++) {
                if (userItems[i].id == selectedItemId) {
                    window.selectedItem = userItems[i];
                    break;
                }
            }
            populateUserPermissions()
        }

        function ItemUnSelected() {
            window.selectedItem = null
            populateUserPermissions()
        }

        function getRightsIndexId(id) {
            return "RIGHTS_" + id;
        }

        function ItemRemoved(removedItemId) {
            var obj = htRights[getRightsIndexId(removedItemId)];
            if (obj) {
                obj.changeState |= ChangeStatusModes.Deleted;
            }
        }

        function defaultUserSelected() {
            window.selectedItem = {id: "<%= UserPermission.EveryoneUserId %>"};
            populateUserPermissions()
        }

        function defaultUserRemoved() {
            return false;
        }

        function populateUserPermissions() {
            var item = window.selectedItem;
            var elems = $$("#UserPermissionRights input");
            if (item) {
                var obj = htRights[getRightsIndexId(item.id)];
                if (!obj) {
                    obj = new definedRight(item.id, item.name, item.type == 'group', "-1", false);
                    htRights[getRightsIndexId(item.id)] = obj;
                    obj.changeState = ChangeStatusModes.Added;
                } else if (obj.changeState & ChangeStatusModes.Deleted) {
                    obj.changeState &= ~ChangeStatusModes.Deleted;
                }

                elems.each(function(el, i) {
                    if (obj.permissions < 1) {
                        el.checked = obj.permissions == el.value;
                    } else {
                        el.checked = (obj.permissions && el.value) == el.value;
                    }
                    el.disabled = false;
                });
            } else {
                elems.each(function(el, i) {
                    el.checked = false;
                    el.disabled = true;
                });
            }
        }
        
        $(document).on("dom:loaded", function() {
            $("UserPermissionRights").on("change", "input", function(e, chb) {
                if (window.selectedItem) {
                    var elems = $$("#UserPermissionRights input");
                    var rightsObj = htRights[getRightsIndexId(window.selectedItem.id)];
                    if (chb.value == allRightsGranted || chb.value == noneRightsGranted) {
                        if (chb.checked)
                        {
                            elems.each(function(el, i) {
                                if (el != chb) {
                                    el.checked = false;
                                } else {
                                    rightsObj.permissions = el.value;
                                    rightsObj.changeState |= ChangeStatusModes.Changed;
                                }
                            });
                        } else {
                            chb.checked = true;
                        }
                    } else {
                        rightsObj.permissions = 0;
                        elems.each(function(el, i) {
                            if (el.checked) {
                                rightsObj.permissions += el.value;
                                rightsObj.changeState |= ChangeStatusModes.Changed;
                            }
                        });
                    }
                    console.log(rightsObj);
                }
            });
        });

        function dialogCommandOK() {
            var s = "";
            for(var key in htRights){
                var dr = htRights[key];
                if (!(dr.changeState & ChangeStatusModes.Deleted)) {
                    if(s.length > 0){
                        s = s + "~"
                    }
                    s = s + dr.userID + "_" + dr.permissions;
                }
            }

            var queryStringParams = window.location.href.toQueryParams() || {};
            var url = "EcomPermission.aspx?CMD=SAVE";
            url += "&TYPE=" + queryStringParams.CMD || "";
            url += "&ID=" + queryStringParams.ID || "";
            url += "&RIGHTS=" + s.valueOf();
            var el = document.getElementById('ApplyToChildren');
            if (el) {
                url += "&APPLYTOCHILDREN=" + el.checked;
            }

            new Ajax.Request(url, {
                onComplete: function(response) {
                    if (200 == response.status) {
                        <%=new Dynamicweb.Management.Actions.ModalAction("Submitted").ToString()%>
                    } else {
                        alert(guitextUnknownError);
                        <%=new Dynamicweb.Management.Actions.ModalAction("Rejected").ToString()%>
                    }
                } 
            });
            return false;
        }

        function hasChanges() {
            for(var key in htRights){
                var dr = htRights[key];
                if (dr.changeState > ChangeStatusModes.Unchanged) {
                    return true;
                }
            }
            return false;
        }
    </script>
</head>
<body>
    <dwc:DialogLayout runat="server" ID="EcommercePermissionEdit" Title="Edit permissions" HidePadding="True">
        <Content>
            <div class="col-md-0">
                <dw:Toolbar runat="server" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="getHelp();" />
                </dw:Toolbar>
                <dw:GroupBox ID="GroupBox1" runat="server" Title="Select group(s) and user(s)">
                    <%=Translate.Translate("Change the permissions for a specific group or user.")%>
                    <dw:UserSelector runat="server" ID="UserSelector" Show="Both" OnSelectScript="ItemSelected" OnUnselectScript="ItemUnSelected" OnRemoveScript="ItemRemoved"
                        DisplayDefaultUser="true" DefaultUserName="Everyone" OnDefaultUserSelectScript="defaultUserSelected" OnDefaultUserRemoveScript="defaultUserRemoved">
                    </dw:UserSelector>
                    <%
                        Dim suppliedCMD As String = Dynamicweb.Context.Current.Request("CMD")
                        Select Case suppliedCMD
                            Case "GROUPS", "SHOPLIST", "SHOP", "GROUP"
                    %>
                    <br />
                    <dw:CheckBox runat="server" ID="ApplyToChildren" />
                    <label for="ApplyToChildren">
                        <dw:TranslateLabel Text="Apply to children" runat="server" />
                    </label>
                    <%
                        End Select
                    %>
                </dw:GroupBox>
                <dw:GroupBox ID="UserPermissionRights" runat="server" Title="Set permission">
                    <div>
                        <dw:CheckBox runat="server" ID="UserPermissionRightsAll" FieldName="UserPermissionRightsAll" Enabled="false" />
                        <label for="UserPermissionRightsAll">
                            <dw:TranslateLabel runat="server" ID="UserPermissionRightsAllLabel" Text="" />
                        </label>
                    </div>
                    <div>
                        <dw:CheckBox runat="server" ID="UserPermissionRightsNone" FieldName="UserPermissionRightsNone" Enabled="false" />
                        <label for="UserPermissionRightsNone">
                            <dw:TranslateLabel runat="server" ID="UserPermissionRightsNoneLabel" Text="" />
                        </label>
                    </div>
                </dw:GroupBox>
            </div>
        </Content>
        <Footer>
            <button class="btn btn-link waves-effect" type="button" onclick="dialogCommandOK();">OK</button>
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Cancel</button>
        </Footer>
    </dwc:DialogLayout>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>
