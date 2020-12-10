<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="SystemSolutionReport_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SystemSolutionReport" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        (function ($) {
            page = $.extend(page, {
                purge: function (xref, param, date, confirmMsg, shrinkDB) {
                    var shrinkInfoEl = $("#lbShrinkInfo");
                    if (!confirm(confirmMsg)) {
                        return;
                    }
                    var dataObj = date ? { date: date } : null;
                    var loader = new overlay('wait');
                    $.ajax({
                        type: "GET",
                        url: xref,
                        data: dataObj,
                        cache: false,
                        contentType: "application/json",
                        beforeSend: function () {
                            if (shrinkDB) {
                                shrinkInfoEl.show();
                            } else {
                                shrinkInfoEl.hide();
                            }
                            loader.show();
                        },
                        success: function (responseText) {
                            if (responseText == param + "_reload") {
                                location.reload(true);
                            }

                            var values = shrinkDB ? responseText.split(";") : [];
                            if (values.length == 0) {
                                values.push(responseText);
                            }

                            $("#value_" + param).html(values[0]);
                            if (values.length > 1) {
                                $("#lbSizeOfDb").html(values[1]);
                            }
                            shrinkInfoEl.hide();
                            loader.hide();
                        },
                        error: function () {
                            shrinkInfoEl.hide();
                            loader.hide();
                        }
                    });
                },

                purgeStatv2session: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>Statistics Session";
                    var purgeDate = moment(document.getElementById("<%=purgestatv2session.ClientID.Replace("_", "$")%>_calendar").value).toISOString();
                    this.purge("?cmd=statv2session", "statv2session", purgeDate, confirmMsg, true);
                    return false;
                },

                purgeStatv2sessionbot: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>Statistics Session Bot";
                    var purgeDate = moment(document.getElementById("<%=purgestatv2sessionbot.ClientID.Replace("_", "$")%>_calendar").value).toISOString();
                    this.purge("?cmd=statv2sessionboot", "statv2sessionbot", purgeDate, confirmMsg, true);
                    return false;
                },

                purgeGeneralLog: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>General log";
                    var purgeDate = moment(document.getElementById("<%=purgegenerallog.ClientID.Replace("_", "$")%>_calendar").value).toISOString();
                    this.purge("?cmd=generallog", "generallog", purgeDate, confirmMsg, true);
                    return false;
                },

                purgeActionLog: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>Action log";
                    var purgeDate = moment(document.getElementById("<%=purgeactionlog.ClientID.Replace("_", "$")%>_calendar").value).toISOString();
                    this.purge("?cmd=actionlog", "actionlog", purgeDate, confirmMsg, true);
                    return false;
                },

                purgeTrashBin: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>Trashbin";
                    var purgeDate = moment(document.getElementById("<%=purgetrashbin.ClientID.Replace("_", "$")%>_calendar").value).toISOString();
                    this.purge("?cmd=trashbin", "trashbin", purgeDate, confirmMsg, true);
                    return false;
                },

                purgeCache: function () {
                    var confirmMsg = "<%= Translate.Translate("Are you sure you want to purge ") %>Cache";
                    this.purge("?cmd=cache", "cache", null, confirmMsg, false);
                    return false;
                }
            });

            $(function () {
                $("#dopurgestatv2session").on("click", $.proxy(page.purgeStatv2session, page));
                $("#dopurgestatv2sessionbot").on("click", $.proxy(page.purgeStatv2sessionbot, page));
                $("#dopurgegenerallog").on("click", $.proxy(page.purgeGeneralLog, page));
                $("#dopurgeactionlog").on("click", $.proxy(page.purgeActionLog, page));
                $("#dopurgetrashbin").on("click", $.proxy(page.purgeTrashBin, page));
                $("#dopurgecache").on("click", $.proxy(page.purgeCache, page));
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>
            <li><a href="#">System</a></li>
            <li class="active">Solution report</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" Title="Solution report" />
        <dwc:CardBody runat="server">
            <dw:Overlay ID="wait" runat="server" Message="" ShowWaitAnimation="True">
                <dw:TranslateLabel ID="TranslateLabel27" runat="server" Text="Please wait" />
                ...
                <div id="lbShrinkInfo" class="column" style="display: none; font-size: x-small;">
                    <dw:TranslateLabel ID="TranslateLabel28" runat="server" Text="Database is shrinking. It may take a several minutes." />
                </div>
            </dw:Overlay>

            <dwc:GroupBox runat="server" Title="Information">
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel0" runat="server" Text="Size of /Files folder:" />
                    </label>
                    <%= GetSizeOfFiles() %>
                    <dw:TranslateLabel ID="TranslateLabel25" runat="server" Text="MB" />
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Size of database: " />
                    </label>
                    <span id="lbSizeOfDb"><%= GetSizeOfDatabase()%></span>
                    <dw:TranslateLabel ID="TranslateLabel24" runat="server" Text="MB" />
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Max page views:" />
                    </label>
                    <div><%= GetMaxNumberOfPageViews()%></div>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Number of users :" />
                    </label>
                    <%= GetNumberOfUsers()%>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel23" runat="server" Text="Number of email marketing users :" />
                    </label>
                    <%= GetNumberOfEmailMarketingUsers() %>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Number of visits :" />
                    </label>
                    <%= GetNumberOfVisits() %>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel19" runat="server" Text="Number of master websites:" />
                    </label>
                    <%= GetNumberOfMasterWebsites() %>
                </div>
                <div class="form-group">
                    <label class="control-label">
                        <dw:TranslateLabel ID="TranslateLabel21" runat="server" Text="Number of language websites:" />
                    </label>
                    <%= GetNumberOfLanguageWebsites() %>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 160px"></th>
                            <th style="min-width: 130px"></th>
                            <th style="min-width: 200px">
                                <dw:TranslateLabel ID="TranslateLabel32" runat="server" Text="License allowed value" />
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Total number of websites" />
                            </td>
                            <td>
                                <%= GetNumberOfWebsites() %>
                            </td>
                            <td>
                                <%= CurrentLicense.MaxWebsites %>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel33" runat="server" Text="Number of pages" />
                            </td>
                            <td>
                                <%= GetNumberOfPages()%>
                            </td>
                            <td>
                                <%= CurrentLicense.MaxPages %>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel26" runat="server" Text="Number of pages" />
                            </td>
                            <td>
                                <%= NumberOfItemsOnPagesAndParagraphs()%>
                            </td>
                            <td>
                                <%= CurrentLicense.MaxItems %>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox runat="server" Title="Product information">

                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 160px"></th>
                            <th style="min-width: 130px">
                                <dw:TranslateLabel ID="TranslateLabel50" runat="server" Text="Default language" />
                            </th>
                            <th style="min-width: 200px">
                                <dw:TranslateLabel ID="TranslateLabel51" runat="server" Text="All languages" />
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel52" runat="server" Text="Total number of product records" />
                            </td>
                            <%= GetNumberOfProductRecords() %>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel53" runat="server" Text="Total number of unique product ids" />
                            </td>
                            <%= GetNumberOfProductFamilies() %>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel54" runat="server" Text="Total number of product SKUS" />
                            </td>
                            <%= GetNumberOfProductSkus() %>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel55" runat="server" Text="Total number of product masters" />
                            </td>
                            <%= GetNumberOfProductMasters() %>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel56" runat="server" Text="Total number of product variants" />
                            </td>
                            <%= GetNumberOfProductVariants() %>
                        </tr>
                    </tbody>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox1" runat="server" Title="Actions :">
                <table class="table">
                    <thead>
                        <tr>
                            <th style="width: 160px">
                                <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Metric name" />
                            </th>
                            <th style="min-width: 130px">
                                <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Metric value" />
                            </th>
                            <th style="min-width: 200px">
                                <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Purge before" />
                            </th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel7" runat="server" Text="Statistics Session" />
                            </td>
                            <td>
                                <span id="value_statv2session"><%= GetNORStatV2Session()%></span>
                                <dw:TranslateLabel ID="TranslateLabel12" runat="server" Text="MB" />
                            </td>
                            <td>
                                <div class="form-group">
                                    <dw:DateSelector runat="server" ID="purgestatv2session" AllowNeverExpire="False" IncludeTime="False" Placeholder="" />
                                </div>
                            </td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgestatv2session" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel10" runat="server" Text="Statistics Session Bot" />
                            </td>
                            <td>
                                <span id="value_statv2sessionbot"><%= GetNORStatV2SessionBot()%></span>
                                <dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="MB" />
                            </td>
                            <td>
                                <div class="form-group">
                                    <dw:DateSelector runat="server" ID="purgestatv2sessionbot" AllowNeverExpire="False" IncludeTime="false" Placeholder="" />
                                </div>
                            </td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgestatv2sessionbot" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel11" runat="server" Text="General Log" />
                            </td>
                            <td>
                                <span id="value_generallog"><%= GetNORGeneralLog()%></span>
                                <dw:TranslateLabel ID="TranslateLabel16" runat="server" Text="MB" />
                            </td>
                            <td>
                                <div class="form-group">
                                    <dw:DateSelector runat="server" ID="purgegenerallog" AllowNeverExpire="False" IncludeTime="false" Placeholder="" />
                                </div>
                            </td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgegenerallog" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel13" runat="server" Text="Action Log" />
                            </td>
                            <td>
                                <span id="value_actionlog"><%= GetNORActionLog()%></span>
                                <dw:TranslateLabel ID="TranslateLabel17" runat="server" Text="MB" />
                            </td>
                            <td>
                                <div class="form-group">
                                    <dw:DateSelector runat="server" ID="purgeactionlog" AllowNeverExpire="False" IncludeTime="false" Placeholder="" />
                                </div>
                            </td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgeactionlog" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel20" runat="server" Text="Trashbin" />
                            </td>
                            <td>
                                <span id="value_trashbin"><%= GetNORTrashbin()%></span>
                                <dw:TranslateLabel ID="TranslateLabel18" runat="server" Text="MB" />
                            </td>
                            <td>
                                <div class="form-group">
                                    <dw:DateSelector runat="server" ID="purgetrashbin" AllowNeverExpire="False" IncludeTime="false" Placeholder="" />
                                </div>
                            </td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgetrashbin" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel15" runat="server" Text="Size of cache" />
                            </td>
                            <td>
                                <span id="value_cache"><%= GetSizeOfCache()%></span>
                                <dw:TranslateLabel ID="TranslateLabel22" runat="server" Text="MB" />
                            </td>
                            <td></td>
                            <td>
                                <dwc:Button runat="server" ID="dopurgecache" ClientIDMode="Static" Title="Purge" DoTranslate="false" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
