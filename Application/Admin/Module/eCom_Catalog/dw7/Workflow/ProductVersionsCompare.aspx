<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProductVersionsCompare.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.ProductVersionsCompare" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true">
    </dw:ControlResources>

    <script type="text/javascript">
        function formSubmit() {
            document.forms[0].submit();
        }
        
        function initPage(options) {
            console.log(options);
            var versionsPerKey = options.versionsPerKey;
            var languageSelectorEl = document.getElementById("ProductLanguage");
            var variantSelectorEl = document.getElementById("ProductVariant");
            var versionSelectorEl = document.getElementById("ProductVersions");
            var versionStore = document.getElementById("VersionId");
            var findVersion = function() {
                var key = languageSelectorEl.value + "_;_" + variantSelectorEl.value;
                var versions = versionsPerKey[key] || [];
                versionStore.value = versions[0] || -1;
                formSubmit();
            }
            Event.observe(languageSelectorEl, 'change', function () {
                findVersion();
            });
            Event.observe(variantSelectorEl, 'change', function () {
                findVersion();
            });
            Event.observe(versionSelectorEl, 'change', function () {
                versionStore.value = versionSelectorEl.value;
                formSubmit();
            });
        }
    </script>

    <style type="text/css">
        table.main-table {
            border-collapse: collapse;
            width: 100%;
        }

            table.main-table td,
            table.main-table th {
                border-bottom: 1px solid #e5e5e5;
                border-right: 1px solid #e5e5e5;
                padding: 10px;
                text-align: left;
            }

        .compare-version-container {
            position: fixed;
            top: 53px;
            right: 0px;
            bottom: 0px;
            left: 0px;
            overflow: auto;
        }

        .header {
            background-color: #EDF5FF;
            padding: 10px;
            height: 32px;
            border-bottom: 1px solid #e0e0e0;
        }

            .header .select-picker-ctrl label {
                margin-right: 5px;
                padding-top: 6px;
                display: inline-block;
                vertical-align: top;
            }

            .header .form-group {
                display: inline-block;
                vertical-align: top;
                margin-right: 10px;
            }

                .header .form-group:last-child {
                    margin-right: 0px;
                }

                .header .form-group .form-group-input {
                    display: inline-block;
                    vertical-align: top;
                }
        .top-header:first-child {
            width: 250px;
        }

        .top-header:not(:first-child) {
            width: calc((100% - 250px)/3);
        }

        td.has-changes {
            background-color: #fff5e5;
        }
    </style>
</head>
<body class="area-pink" style="overflow: hidden">
    <form id="form1" runat="server">
        <div class="header">
            <dwc:SelectPicker runat="server" ID="ProductLanguage" Label="Language"></dwc:SelectPicker>
            <dwc:SelectPicker runat="server" ID="ProductVariant" Label="Extended variants"></dwc:SelectPicker>
            <dwc:SelectPicker runat="server" ID="ProductVersions" Label="Versions"></dwc:SelectPicker>
            <input type="hidden" id="VersionId" name="VersionId" />
        </div>
        <div class="compare-version-container">
            <dw:Infobar ID="IncorrectVersionInfo" runat="server" Message="Unable to restore the product version" Type="Error" Visible="false"></dw:Infobar>
            <dw:Infobar ID="NoChangesInfo" runat="server" Message="Product has no changes" Type="Information" Visible="false"></dw:Infobar>
            <dw:Infobar ID="NoVersionsFound" runat="server" Message="No versions found" Type="Information" Visible="false"></dw:Infobar>
            <asp:Repeater ID="OrderCoparingsRepeater" runat="server" EnableViewState="false">
                <HeaderTemplate>
                    <table class="main-table">
                        <tr>
                            <th class="header top-header"></th>
                            <th class="header top-header">
                                <div>
                                    <dw:TranslateLabel ID="pubLabel" runat="server" Text="Current version" />
                                </div>
                            </th>
                            <th class="header top-header">
                                <div>
                                    <dw:TranslateLabel ID="compareversionLabel" runat="server" Text="Published version" />
                                </div>
                            </th>
                            <th class="header top-header">
                                <div>
                                    <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Compare" />
                                </div>
                            </th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <th class="header left-header">
                            <%#Eval("FieldName")%>
                        </th>
                        <td><%#Eval("CurrentValue")%></td>
                        <td><%#Eval("OldValue")%></td>
                        <td class='<%#If(Eval("Differs"), "has-changes", "")%>'><%#Eval("CurrentValue")%></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>
