<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EcomVariantGrp_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomVariantGrp_Edit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
    

    <style type="text/css">
       

        #DWRowHeadLine {
            background: #DFE9F5 url(/Admin/Images/Ribbon/UI/List/Pipe.gif) repeat-x scroll left bottom;
            height: 20px;
        }

        .OutlookHeaderStart {
            font: 11px Verdana, Helvetica, Arial, Tahoma;
            border-bottom: 0px !important;
            font-weight: normal;
            padding-left: 5px;
        }

        .OutlookHeader {
            font: 11px Verdana, Helvetica, Arial, Tahoma;
            border-bottom: 0px !important;
            font-weight: normal;
            border-left: 2px outset white;
            padding-left: 5px;
        }

        input.disabled {
            user-select: none;
            -moz-user-select: none;
            -webkit-user-select: none;
            color: gray;
            cursor: pointer;
        }
        <% If eCommerce.Common.Context.LanguageID <> eCommerce.Common.Application.DefaultLanguage.LanguageID Then %>
        .editable-list.list .editable-list-body .editable-list-button.delete-button span {
            background-image: url(/Admin/Images/Ribbon/Icons/Small/earth_delete.png) !important; 
            }
        <% End If %>                        
    </style>

    <script type="text/javascript" src="../images/functions.js"></script>
    <script type="text/javascript" src="../images/addrows.js"></script>
    <script type="text/javascript" src="../images/layermenu.js"></script>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>

    <script type="text/javascript">
        strHelpTopic = 'ecom.settings.variants.edit';
        var isDefaultLanguage = '<%=eCommerce.Common.Context.LanguageID%>' == '<%=Dynamicweb.eCommerce.Common.Application.DefaultLanguage.LanguageID%>';

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();            
        });

        function TabHelpTopic(tabName) {
            switch (tabName) {
                case 'GENERAL':
                    strHelpTopic = 'ecom.settings.variants.edit.general';
                    break;
                case 'ATTRIBUTES':
                    strHelpTopic = 'ecom.settings.variants.edit.attributes';
                    break;
                case 'PROPERTIES':
                    strHelpTopic = 'ecom.settings.variants.edit.properties';
                    break;
                case 'RELATIONS':
                    strHelpTopic = 'ecom.settings.variants.edit.relations';
                    break;
                default:
                    strHelpTopic = 'ecom.settings.variants.edit';
            }
        }

        function SaveVariantGroup() {
            submitTabID();
            document.getElementById('Form1').SaveButton.click();
        }

        function submitTabID() {
            var setTabID = "";

            var allDivs;
            if (!isDefaultLanguage)
                allDivs = document.getElementsByTagName("DIV")

            try {
                for (var a = 0; a < allDivs.length; a++) {
                    if (allDivs[a].className != "" &&
					    (allDivs[a].style.display == "" || allDivs[a].style.display == "block") &&
					    allDivs[a].className.indexOf("Tab") > -1
					) {
                        setTabID = allDivs[a].id;
                    }
                }

                var oldURL = GetFileNameFromUrl(location.href);
                var newURL = "";
                var qsURL = GetQueryFromUrl(location.href);
                var qsURL2 = GetTabIDFromQs(qsURL);

                oldURL = "" + oldURL.toLowerCase();
                newURL = oldURL + "?Tab=" + setTabID;

                if (qsURL2 != "") {
                    newURL += "&" + qsURL2;
                }

                if (setTabID != "") {
                    document.getElementById('Form1').action = newURL;
                }

            } catch (e) {
                //Nothing
            }
            document.getElementById('Form1').Tab.value = setTabID
        }

        function saveVariants() {
            save(true);
        }

        function save(close) {
            <% If Not String.IsNullOrEmpty(vargrpId) Then%>
            $("Close").value = close ? 1 : 0;
            $('Form1').SaveButton.click();
            <% Else%>
            if ($$('.editable-list-row .editable-list-data').length > 0) {
                $("Close").value = close ? 1 : 0;
                $('Form1').SaveButton.click();
            } else {
                var alertmsg = '<%=Translate.JsTranslate("Add variants before saving a variant group")%>';
                alert(alertmsg);
            }
            <% End If%>
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteVariant() {
            if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click();
        }

        if (typeof (Dynamicweb) == 'undefined') {
            var Dynamicweb = new Object();
        }

        if (typeof (Dynamicweb.eCommerce) == 'undefined') {
            Dynamicweb.eCommerce = new Object();
        }

        if (typeof (Dynamicweb.eCommerce.Variants) == 'undefined') {
            Dynamicweb.eCommerce.Variants = new Object();
        }

        Dynamicweb.eCommerce.Variants.VariantOption = function () { };
        Dynamicweb.eCommerce.Variants.VariantOption.ErrorEmptyVariantName = "Variant name can not be empty!"
        Dynamicweb.Ajax.ControlManager.get_current().add_controlReady('VariantsList', function (control) {
            var validationFn = function (sender, args) {
                var ruleName = args.row.get_propertyValue("VariantName").trim();
                if (ruleName.length == 0) {
                    alert(Dynamicweb.eCommerce.Variants.VariantOption.ErrorEmptyVariantName);
                    args.cancel = true;
                }
            };
            var currentLanguage = '<%=eCommerce.Common.Context.LanguageID%>';
            var defaultLanguage = '<%=Dynamicweb.eCommerce.Common.Application.DefaultLanguage.LanguageID%>';
            var updateVariantsListRow = function (rowModel, rowEl) {
                var langId = rowModel.get_propertyValue("VariantLanguageId")
                var addOrRemove = !isDefaultLanguage && currentLanguage != langId;
                if (addOrRemove) {
                    rowEl.addClassName("dis");
                } else {
                    rowEl.removeClassName("dis");
                }
            };
            var updateRowsOnCurrentPage = function () {
                var ctrl = control.get_container();
                control.forEach(function (rowModel) {
                    var rowEl = ctrl.select(".editable-list-row.editable-list-data[data-model-id=" + rowModel.get_id() + "]")[0];
                    if (rowEl) {
                        updateVariantsListRow(rowModel, rowEl)
                    }
                }, ctrl);
            };

            control.add_rowCreating(validationFn);
            control.add_rowUpdating(function (sender, args) {
                validationFn(sender, args);
                if (!args.cancel) {
                    var rowModel = args.row;
                    rowModel.set_propertyValue("VariantLanguageId", currentLanguage);
                    var rowEl = sender.get_container().select(".editable-list-row.editable-list-data[data-model-id=" + rowModel.get_id() + "]")[0];
                    if (rowEl) {
                        updateVariantsListRow(rowModel, rowEl);
                    }
                }
            });
            control.add_rowDeleting(function (sender, args) {
                var rowModel = args.row;
                rowModel.set_propertyValue("VariantLanguageId", defaultLanguage);
                var rowEl = sender.get_container().select(".editable-list-row.editable-list-data[data-model-id=" + rowModel.get_id() + "]")[0];
                if (rowEl) {                    
                    updateVariantsListRow(rowModel, rowEl);
                    args.cancel = !isDefaultLanguage;
                }
            });

            updateRowsOnCurrentPage();
            control.get_pager().add_buttonClicked(function (sender, args) {
                updateRowsOnCurrentPage();
            });
        });

        Dynamicweb.eCommerce.Variants.VariantGroupProperty = function () { };
        Dynamicweb.eCommerce.Variants.VariantGroupProperty.ErrorEmptyName = "Property name can not be empty!"
        Dynamicweb.eCommerce.Variants.VariantGroupProperty.ErrorNotValidSystemName = "Property system name is not valid!"
        Dynamicweb.Ajax.ControlManager.get_current().add_controlReady('PropertiesList', function (control) {
            var validationFn = function (sender, args, isCreateEvent) {
                var propName = args.row.get_propertyValue("PropertyName").trim();
                var propSystemName = args.row.get_propertyValue("PropertySystemName").trim();
                if (propName.length == 0) {
                    alert(Dynamicweb.eCommerce.Variants.VariantGroupProperty.ErrorEmptyName);
                    args.cancel = true;
                } else {
                    if (propSystemName.length == 0 || !isNaN(propSystemName.charAt(0)) || ["image", "by", "module", "select", "in", "from", "order"].indexOf(propSystemName) >= 0 || !/^[a-zA-Z0-9_]*$/.test(propSystemName) || sender.findRows(function (x) { return x.get_propertyValue("PropertySystemName").trim() == propSystemName; }).length > (isCreateEvent ? 0 : 1)) {
                        alert(Dynamicweb.eCommerce.Variants.VariantGroupProperty.ErrorNotValidSystemName);
                        args.cancel = true;
                    }
                }
            };
            control.add_rowCreating(function (sender, args) { validationFn(sender, args, true); });
            control.add_rowUpdating(function (sender, args) { validationFn(sender, args, false); });
        });

        function g_initLabelEditor(editor, meta) {
            var cnt = document.getElementById(editor.get_id());
            var ce = {
                container: function () {
                    return cnt;
                },
                val: function (obj, undef) {                    
                    if (obj === undef) {
                        return cnt.innerHTML;
                    } else {
                        if (obj) {
                            cnt.innerHTML = obj;
                        }
                        cnt.style.display = obj ? "" : "none";
                        var nameLbl = $$('.editor-field-name')[0];
                        if (nameLbl) {
                            nameLbl.style.display = obj ? "" : "none";
                        }
                    }
                }
            }
            return ce;
        };
    </script>

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

</head>
<body class="area-pink <%=If(DialogMode, "", "screen-container")%>" >
    <div class="card">
        <dw:Overlay runat="server" id="ProductEditOverlay"></dw:Overlay>
        <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
        <form id="Form1" method="post" runat="server">
            <input type="hidden" name="Tab" />
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="NoVarsExistsForLanguageBlock" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Variantgruppe">
                <dwc:InputText runat="server" ID="NameStr" Label="Navn" MaxLength="255" />
                <dwc:InputTextArea runat="server" ID="DescriptionStr" Label="Beskrivelse" MaxLength="255" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Variants">
                <dw:EditableList ID="VariantsList" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" CssClass="list"></dw:EditableList>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Properties">
                <dw:Infobar ID="PropertiesValidationInfoBar" runat="server" Message="" Type="Error" Visible="False" />
                <dw:EditableList ID="PropertiesList" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false"></dw:EditableList>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" Title="Relations" ID="RelationsGroupbox">
                <dw:List runat="server" ShowTitle="false" ID="varGroupRelations" ShowPaging="True" PageSize="25" HandlePagingManually="True" PageNumber="1" UseCountForPaging="True" ShowCount="True">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Product name" ItemAlign="Left" HeaderAlign="Left" />
                    </Columns>
                </dw:List>
            </dwc:GroupBox>
            <asp:Button ID="SaveButton" Style="display: none;" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none;" runat="server"></asp:Button>      
        </form>    
    </div>
    <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>
    <iframe name="EcomUpdator" id="EcomUpdator" width="1" height="1" align="right" marginwidth="0" marginheight="0" frameborder="0" src="EcomUpdator.aspx"></iframe>
    <script type="text/javascript">
        //addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name needs to be specified")%>');
        //activateValidation('Form1');
    </script>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
<%=Dynamicweb.SystemTools.Gui.SelectTab()%>
