<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AuditDetails.aspx.vb" Inherits="Dynamicweb.Admin.AuditDetails" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server" />
    <style type="text/css">
        .top-align {
            vertical-align:top !important;
        }

        .ListDateTimeFilterSelectorDiv {
            width: 250px !important;
        }

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
        function createDetailsPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },

                showAuditDetails: function (evt, rowID) {
                    evt.stopPropagation();
                    var ids = rowID;
                    Action.Execute(this.options.actions.showAuditDetails, {
                        ids: ids
                    });
                },

                showUser: function (evt) {
                    evt.stopPropagation();
                    var userId = parseInt(evt.target.readAttribute("data-user-id"));
                    if (userId > 1) {
                        Action.Execute({ Name: 'CloseAllDialogs' });
                        Action.Execute(this.options.actions.showUserInfo, {
                            userId: userId
                        });
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
<dwc:DialogLayout runat="server" ID="AuditDetailsDialog" Title="Audit detail" Size="Large" HidePadding="True">
    <content>
        <div runat="server" id="AuditDetailsContainer" class="col-md-0">
            <dwc:GroupBox runat="server" Title="Audit Information">
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Object")%></label>
                    <div>
                        <%=GetAuditObjectInfo(AuditInfo.Value) %>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Updated by")%></label>
                    <div>
                        <%=GetUserName(AuditInfo.Value) %>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Updated on")%></label>
                    <div>
                        <%=AuditInfo.Value.Timestamp.ToString(DateHelper.DateFormatString, Dynamicweb.Environment.ExecutingContext.GetCulture(False)) %>
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox ID="DetailsGroupbox" Title="Details" runat="server">
                <dw:List ID="DetailsList" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" Personalize="true" >                
                    <Columns>
                        <dw:ListColumn ID="clmKey" TranslateName="True" Name="Key" runat="server" EnableSorting="true" CssClass="top-align" />
                        <dw:ListColumn ID="clmAction" TranslateName="True" Name="Action" runat="server" EnableSorting="true" CssClass="top-align" />
                        <dw:ListColumn ID="clmInfo1" TranslateName="True" Name="Old Value" runat="server" CssClass="top-align" />
                        <dw:ListColumn ID="clmInfo2" TranslateName="True" Name="New Value" runat="server" CssClass="top-align" />
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
        </div>
        <div runat="server" id="AuditsContainer" class="col-md-0">
            <dwc:GroupBox runat="server" Title="Audit Information">                
                <div class="form-group">
                    <label class="control-label"><%=Translate.Translate("Updated on")%></label>
                    <div>
                        <asp:Label id="TimeRange" runat="server" />                        
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Details">
                <dw:List ID="AuditsList" runat="server" ShowHeader="True" ShowPaging="True" ShowTitle="False" Personalize="true" >
                    <Filters>
                        <dw:ListAutomatedSearchFilter runat="server" ID="TextFilter" Priority="2" WaterMarkText="" />
                        <dw:ListDropDownListFilter ID="ObjectTypeFilter" Label="Object type" AutoPostBack="true" Priority="1" runat="server"></dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="ObjectActionFilter" Label="Description" AutoPostBack="true" Priority="3" runat="server"></dw:ListDropDownListFilter>
                        <dw:ListDropDownListFilter ID="PageSizeFilter" Width="60" Label="Paging size" AutoPostBack="true" Priority="4" runat="server">
                            <Items>
                                <dw:ListFilterOption Text="25" Value="25" DoTranslate="false" Selected="true" />
                                <dw:ListFilterOption Text="50" Value="50" DoTranslate="false" />
                                <dw:ListFilterOption Text="75" Value="75" DoTranslate="false" />
                                <dw:ListFilterOption Text="100" Value="100" DoTranslate="false" />
                                <dw:ListFilterOption Text="150" Value="150" DoTranslate="false" />
                                <dw:ListFilterOption Text="200" Value="200" DoTranslate="false" />
                                <dw:ListFilterOption Text="500" Value="500" DoTranslate="false" />
                            </Items>
                        </dw:ListDropDownListFilter>
                        <dw:ListDateFilter ID="DateFromFilter" Label="From" IncludeTime="true" runat="server" OnClientChange="dateRangeFilterChanged('lstAudit:DateFromFilter');"></dw:ListDateFilter>
                        <dw:ListDateFilter ID="DateToFilter" Label="To" IncludeTime="true" runat="server" OnClientChange="dateRangeFilterChanged('lstAudit:DateToFilter');"></dw:ListDateFilter>
                    </Filters>
                    <Columns>
                        <dw:ListColumn ID="clmDate" TranslateName="True" Name="Date" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmUpdatedBy" TranslateName="True" Name="Updated by" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmObjectType" TranslateName="True" Name="Object Type" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmLanguage" TranslateName="True" Name="Language" runat="server" EnableSorting="true" />                    
                        <dw:ListColumn ID="clmId" TranslateName="True" Name="Object" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmObjectInfo" TranslateName="True" Name="Object Information" runat="server" />
                        <dw:ListColumn ID="clmAuditDescription" TranslateName="True" Name="Description" runat="server" />
                        <dw:ListColumn ID="clmDetailKey" TranslateName="True" Name="Key" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="clmDetailAction" TranslateName="True" Name="Action" runat="server" EnableSorting="true" />
                        <dw:ListColumn ID="ListColumn1" TranslateName="True" Name="Old Value" runat="server" CssClass="top-align" />
                        <dw:ListColumn ID="ListColumn2" TranslateName="True" Name="New Value" runat="server" CssClass="top-align" />
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
       </div>
    </content>
    <footer>
        <button runat="server" id="btnExportToExcel" class="btn btn-link waves-effect" type="button" onclick="currentPage.exportToExcel()">Export</button>
        <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})">Close</button>
    </footer>
</dwc:DialogLayout>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
