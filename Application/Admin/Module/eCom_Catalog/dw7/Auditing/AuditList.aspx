<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AuditList.aspx.vb" Inherits="Dynamicweb.Admin.AuditList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="dwa" Namespace="Dynamicweb.Admin" Assembly="Dynamicweb.Admin" %>

<%@ Register TagPrefix="uc" TagName="UCAuditList" Src="~/Admin/Module/eCom_Catalog/dw7/Auditing/UCAuditList.ascx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server">
    </dw:ControlResources>
    <style>
        <%If SolidPageMode Then %>

        .ListDateTimeFilterSelectorDiv {
            width: 239px !important;
        }
        
        .ListDateTimeFilterSelectorDiv .DateSelectorLabel {
            width: 164px !important;
        }
        <% Else %>
        .ListDateTimeFilterSelectorDiv {
            width: 250px !important;
        }
        <% End If %>
        .filterLabel {
            width: auto !important;
        }

        .modal .list {
            height: calc(100% - 40px) !important;
        }

            .modal .list .filters {
                padding-left: 2px;
            }
    </style>
    <script>
        function createListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                showDetails: function (evt, rowID) {
                    evt.stopPropagation();
                    var ids = rowID;
                    if (!rowID) {
                        ids = [];
                        var rows = window.List.getSelectedRows(this.options.ids.list);
                        for (var i = 0; i < rows.length; i++) {
                            row = window.List.getRowByID(this.options.ids.list, rows[i].id);
                            if (row) {
                                ids.push(row.readAttribute("itemid"));
                            }
                        }
                    }
                    Action.Execute(this.options.actions.showDetails, {
                        ids: ids
                    });
                },

                itemSelected: function () {
                    if (List && List.getSelectedRows(this.options.ids.list).length > 0) {
                        Toolbar.setButtonIsDisabled(this.options.ids.showDetails, false);
                    }
                    else {
                        Toolbar.setButtonIsDisabled(this.options.ids.showDetails, true);
                    }
                },

                exportToExcel: function () {
                    let form = theForm || document.forms[0];
                    let cmdEl = this.createHidden(form, "cmd", "export");
                    form.submit();
                    cmdEl.remove();
                },

                createHidden: function (parent, name, value) {
                    let el = document.createElement("input");
                    el.setAttribute("type", "hidden");
                    el.setAttribute("name", name);
                    el.setAttribute("value", value);
                    parent.appendChild(el);
                    return el;
                }
            };
            obj.init(opts);
            return obj;
        }

        function waitFor(condition, callback) {
            if (!condition()) {
                window.setTimeout(waitFor.bind(null, condition, callback), 1000);
            } else {
                callback();
            }
        }

        function isVisible(el) {
            var style = window.getComputedStyle(el);
            return (style.display !== 'none')
        }
        var dateFilterIsStarted = false;
        function dateRangeFilterChanged(filter) {
            if (!dateFilterIsStarted) {
                dateFilterIsStarted = true;
                let pikaDatePane = document.getElementById("pika-wrapper");
                let pikaTimePane = document.getElementById("pika-wrapper-time")
                waitFor(function () {
                    return !isVisible(pikaTimePane) && !isVisible(pikaDatePane);
                }, function () {
                    window.setTimeout(function () {
                        List._submitForm(filter);
                    }, 500);
                });
            }
        }
    </script>
</head>
    <%If SolidPageMode Then %>   
        <body class="screen-container">
            <div class="dw8-container">
                <form enableviewstate="false" runat="server">
                    <dwc:Card runat="server">
                        <dwc:CardHeader runat="server" Title="Audit List"></dwc:CardHeader>
                        <uc:UCAuditList runat="server" ID="AuditListPlain" DialogMode="False" />     
                    </dwc:Card>
                </form>
            </div>
        </body>
    <% Else %>
<dwc:DialogLayout runat="server" ID="AuditDialog" Title="Audit List" Size="Large" HidePadding="True">
    <content>
        <div class="col-md-0">
            <uc:UCAuditList runat="server" ID="UCAuditDialog"  DialogMode="True" />  
        </div>
    </content>
    <footer>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Close</button>
    </footer>
</dwc:DialogLayout>
    <% End If %>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
