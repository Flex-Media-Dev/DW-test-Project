<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="DatabaseSearchReplace_cpl.aspx.vb" Inherits="Dynamicweb.Admin.DatabaseSearchReplace_cpl" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Images/Ribbon/UI/List/List.js"></script>
    <script type="text/javascript">

        var page = SettingsPage.getInstance();
        (function ($) {
            $.extend(page,
            {
                onSave: function() {
                    this.showWaitSplash();
                    this.submit();
                },

                showWaitSplash: function() {
                    var __o = new overlay('__ribbonOverlay');
                    __o.show();
                },

                highlightWord: function(node, word) {
                    if (!node) {
                        return;
                    }
                    if (node.hasChildNodes) {
                        for (var hi_cn = 0; hi_cn < node.childNodes.length; hi_cn++) {
                            this.highlightWord(node.childNodes[hi_cn], word);
                        }
                    }

                    if (node.nodeType == 3) {
                        tempNodeVal = node.nodeValue.toLowerCase();
                        tempWordVal = word.toLowerCase();
                        if (tempNodeVal.indexOf(tempWordVal) != -1) {
                            pn = node.parentNode;
                            if (pn.className != "mark") {
                                nv = node.nodeValue;
                                ni = tempNodeVal.indexOf(tempWordVal);
                                before = document.createTextNode(nv.substr(0, ni));
                                docWordVal = nv.substr(ni, word.length);
                                after = document.createTextNode(nv.substr(ni + word.length));
                                hiwordtext = document.createTextNode(docWordVal);
                                hiword = document.createElement("span");
                                hiword.className = "mark";
                                hiword.appendChild(hiwordtext);
                                pn.insertBefore(before, node);
                                pn.insertBefore(hiword, node);
                                pn.insertBefore(after, node);
                                pn.removeChild(node);
                            }
                        }
                    }
                }
            });

            function getOptions(element, optionsFor) {
                $.ajax({
                    method: "POST",
                    url: "DatabaseSearchReplace_cpl.aspx",
                    data: { IsAjax: true, Control: $(element).attr("id"), ControlValue: $(element).val() }
                })
                .done(function (response) {
                    $("#RequiredFields").val(JSON.parse(response).RequiredFields);
                    var options = JSON.parse(response).Options;
                    var relatedElement = $('#' + optionsFor);
                    $(relatedElement).find("option").remove();
                    $.each(options, function (key, value) {
                        $(relatedElement).append($("<option></option>")
                        .attr("value", value).text(key));
                    });
                    $(relatedElement).next("div.bootstrap-select").remove();
                    $(relatedElement).data('selectpicker',null);
                    $(relatedElement).selectpicker();
                    $("#" + optionsFor+"Container").show();
                });
            };

            function validateSearchSubmit(forReplace) {
                var valid = true;
                dwGlobal.hideAllControlsErrors();
                if (!$("#DatabaseList").val()) {
                    dwGlobal.showControlErrors("DatabaseList", "required")
                    valid = false;
                }
                if (!$("#TableList").val()) {
                    dwGlobal.showControlErrors("TableList", "required")
                    valid = false;
                }
                if (!$("#FieldList").val()) {
                    dwGlobal.showControlErrors("FieldList", "required")
                    valid = false;
                }
                if (!$("#ReplaceString").val()) {
                    dwGlobal.showControlErrors("ReplaceString", "required")
                    valid = false;
                }
                if (valid && !forReplace) {
                    page.showWaitSplash();
                }
                return valid;
            };

            function validateSearchAndReplaceSubmit() {
                var valid = validateSearchSubmit(true);
                if (!$("#ReplaceWith").val()) {
                    dwGlobal.showControlErrors("ReplaceWith", "required")
                    valid = false;
                }
                if (valid) {
                    page.showWaitSplash();
                }
                return valid;
            };
            
            $(function () {
                var strWord = $("#ReplaceString").val();
                if (strWord) {
                    page.highlightWord(document.getElementById('DisplaySearchResult'), strWord);
                }

                $("#DatabaseList").on("change", function() {
                    getOptions(this, "TableList"); 
                    if (!$(this).val()) {
                        $("#TableList").change();
                    }
                });
                $("#TableList").on("change", function () { getOptions(this, "FieldList"); });
                $("#FieldList").on("change", function() {
                    $("#SearchTextContainer").show();
                    $("#ButtonRow").show();
                });

                $("#DisplaySearchButton").on("click", function () { return validateSearchSubmit(); });
                $("#SearchButton").on("click", function () { return validateSearchAndReplaceSubmit(); });

                if ($("#DatabaseList").val()) {
                    $("#TableListContainer").show();
                    $("#FieldListContainer").show();
                    $("#SearchTextContainer").show();
                    $("#ButtonRow").show();
                }
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Header">
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Search and replace" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox Title="Indstillinger" runat="server">
                <dwc:SelectPicker ID="DatabaseList" Label="Database" runat="server" ClientIDMode="Static" ValidationMessage="" />

                <div id="TableListContainer" style="display: none;">
                    <dwc:SelectPicker ID="TableList" Label="Tabel" runat="server" ClientIDMode="Static" ValidationMessage="" />
                </div>
                <div id="FieldListContainer" style="display: none;">
                    <dwc:SelectPicker ID="FieldList" Label="Felt" runat="server" ClientIDMode="Static" ValidationMessage="" />
                </div>
                <div id="SearchTextContainer" style="display: none;">
                    <dwc:InputText ID="ReplaceString" Label="Søg efter" runat="server" ClientIDMode="Static" ValidationMessage="" />
                    <dwc:InputText ID="ReplaceWith" Label="Erstat med" runat="server" ClientIDMode="Static" ValidationMessage="" />
                </div>

                <div id="ResultText" visible="false" class="alert alert-success" role="alert" runat="server" ></div>
                <div id="ButtonRow" style="display: none;">
                    <input type="hidden" ID="RequiredFields" runat="server" clientidmode="Static" value=""/>
                    <dwc:Button ID="DisplaySearchButton" Name="Action" runat="server" ActionType="submit" Title="Find" Value="Find" />
                    <dwc:Button ID="SearchButton" Name="Action" runat="server" ActionType="submit" Title="Erstat alle" Value="FindAndReplace" />
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox Title="Poster" id="RecordsGroupBox" runat="server">
                <dw:List ID="SearchResultsList" runat="server" Visible="false" ShowTitle="False" />
            </dwc:GroupBox>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
