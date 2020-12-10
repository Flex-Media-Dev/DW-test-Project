<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectEmailLink.aspx.vb" Inherits="Dynamicweb.Admin.SelectEmailLink" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title><%= Translate.Translate("Select Email Link") %></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    

    <style>
        #ListTable tr[itemid] {
            cursor: pointer;
        }

        .filters > .btn {
            height: 32px;
        }
    </style>
    <script type="text/javascript">
        var addEvent = window.attachEvent ? function (el, event, handler) { el.attachEvent('on' + event, handler); } : function (el, event, handler) { el.addEventListener(event, handler, false); };
        function openEmailSelector(evt) {
            var editorEl = document.getElementById('email');
            var editorTitleEl = document.getElementById('Title_email');
            var dlgUrl = '/Admin/Marketing/Dialogs/EmailMarketing/SelectEmail';
            if (editorEl.value) {
                dlgUrl += '?emailId=' + editorEl.value;
            }
            Action.Execute({
                'Name': 'OpenDialog',
                'Url': dlgUrl,
                'OnSubmitted': {
                    'Name': 'ScriptFunction',
                    'Function': function (act, model) {
                        console.log(arguments);
                        editorEl.value = model.SelectedEmailId;
                        editorTitleEl.value = model.SelectedEmailTitle;
                        document.forms[0].submit();
                    }
                }
            });
        }
    </script>
</head>
<dwc:DialogLayout runat="server" Title="Select Email Link" HidePadding="True">
    <Content>
        <div class="col-md-0">
            <div class="list">
                <table class="main" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div id="filtersDiv">
                                    <div class="filters clearfix">                                    
                                        <input type="hidden" id="email" name="emailId" value="<%= If(Email IsNot Nothing, Email.ID.ToString(), "")%>" readonly="" />
                                        <input type="text" class="form-control pull-left m-r-5" id="Title_email" name="emailTitle" value="<%= If(Email IsNot Nothing, Email.Subject, "")%>" disabled="disabled" />
                                        <button type="button" class="btn pull-left" id="btnSelectEmail"><%= Translate.Translate("Select email") %></button>
                                    </div>                                    
                                </div>                        
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
            <dw:List runat="server" ID="LinkList" AllowMultiSelect="false" Title="Select email link" ShowHeader="false" StretchContent="true" HandlePagingManually="true" PageSize="1000" NoItemsMessage="No links in selected email">
                <Columns>
                    <dw:ListColumn runat="server" ID="LinkOriginalUrl" Name="Link" TranslateName="true" />
                </Columns>
            </dw:List>
        </div>
    </Content>
</dwc:DialogLayout>
    <script type="text/javascript">(function () {
    var addEvent = window.attachEvent ? function (el, event, handler) { el.attachEvent('on' + event, handler); } : function (el, event, handler) { el.addEventListener(event, handler, false); };

    addEvent(window, 'load', function () {
        addEvent(document.getElementById('btnSelectEmail'), 'click', function (evt) {
            openEmailSelector(evt);
        });

        window.selectLink = function (linkId, linkUrl) {
            let emailSubject = document.getElementById('Title_email').value;
            Action.Execute({
                Name: "ModalResult",
                Result: "Submitted",
                Model: {
                    linkId: linkId,
                    linkUrl: linkUrl,
                    emailSubject: emailSubject
                }
            });
        };
    });        
}())
</script>
    <% Translate.GetEditOnlineScript()%>
</body>
</html>
