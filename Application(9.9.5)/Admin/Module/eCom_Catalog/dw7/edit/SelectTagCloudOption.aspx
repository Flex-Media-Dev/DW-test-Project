<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SelectTagCloudOption.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.SelectTagCloudOption" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludejQuery="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        function createSelectOptionPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;

                    var loadingOptions = false;
                    var pageNumber = 1;
                    var lastKnownScrollPosition = 0;
                    var allListOptionsLoaded = false;
                    var cancelLoader = false;                   

                    function getDistFromBottom() {  
                        var selectBoxListLeft = document.getElementById('TagCloudOptions_lstLeft');
                        var scrollPosition = selectBoxListLeft.scrollTop;
                        var elementScrollHeight = selectBoxListLeft.scrollHeight;
                        var elementHeight = selectBoxListLeft.offsetHeight;
                        var distance = 0;
                        if (scrollPosition > lastKnownScrollPosition) {
                            distance = Math.max(elementHeight - (elementScrollHeight - scrollPosition), 0);
                        }
                        lastKnownScrollPosition = scrollPosition;
                        return distance;
                    };

                    document.getElementById('TagCloudOptions_lstLeft').addEventListener('scroll', function(event) {                            
                        distToBottom = getDistFromBottom();
                        if (!loadingOptions && distToBottom > 0 && !allListOptionsLoaded) {
                            cancelLoader = false;
                            showLoader();
                            loadingOptions = true;
                            pageNumber++;
                            loadOptions();
                        }
                    });

                    var inputChangeHandler = dwGlobal.debounce(function () {
                        {
                            cancelLoader = false;
                            showLoader();
                            document.getElementById('TagCloudOptions_lstLeft').length = 0;
                            pageNumber = 1;
                            allListOptionsLoaded = false;
                            loadOptions();
                        }
                    }, 200);

                    document.querySelector(".selection-box-left .selection-box-search>input").addEventListener('input', inputChangeHandler);
                    document.querySelector(".selection-box-left .selection-box-search>input").addEventListener('keyup', inputChangeHandler);

                    var showLoader = dwGlobal.debounce(function () {
                        if (!cancelLoader) {
                            Action.showCurrentDialogLoader();
                        }
                    }, 400);

                    function loadOptions() {
                        var optionNameSearchElement = document.querySelector(".selection-box-left .selection-box-search>input");
                        let url = "/Admin/module/eCom_Catalog/dw7/Edit/SelectTagCloudOption.aspx?IsAjax=true";
                        url += "&FieldId=" + opts.FieldId;
                        url += "&LanguageId=" + opts.LanguageId;
                        url += "&pageNumber=" + pageNumber;
                        url += "&optionName=" + optionNameSearchElement.value;
                        
                        new Ajax.Request(url, {
                            method: 'get',
                            onSuccess: handleAjaxResponce,
                            onComplete: function () {
                                Action.hideCurrentDialogLoader();
                                cancelLoader = true;
                                loadingOptions = false;
                            }
                        });   
                    };

                    function handleAjaxResponce(transport) {
                        var options = JSON.parse(transport.responseText);
                        var selectedOptionIds = SelectionBox.getElementsRightAsArray("TagCloudOptions");
                        if (options.length) {
                            for (var i = 0; i < options.length; i++) {
                                var selectBoxListLeft = document.getElementById("TagCloudOptions_lstLeft");
                                var optionId = options[i].Key;
                                if(selectedOptionIds.indexOf(optionId) == -1) {
                                    var option = document.createElement("option");
                                    option.text = options[i].Value;
                                    option.value = optionId;
                                    selectBoxListLeft.add(option);
                                }
                            }
                            if (options.length < 100) {
                                allListOptionsLoaded = true;
                            }
                        } else {
                            allListOptionsLoaded = true;
                        }
                    };

                },

                selectionChanged: function () {
                    document.getElementById("SelectedFieldOptions").value = SelectionBox.getElementsRightAsArray("TagCloudOptions");
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>
<dwc:DialogLayout runat="server" ID="OptionsListDialog" Title="Options" HidePadding="False">
        <Content>
            <div id="content">
                <dwc:GroupBox runat="server" DoTranslation="true" Title="Selected options">
                    <dw:SelectionBox runat="server" ID="TagCloudOptions" Width="350"></dw:SelectionBox>
                </dwc:GroupBox>                    
                <input type="hidden" name="SelectedFieldOptions" id="SelectedFieldOptions" value="" runat="server" ClientIDMode="Static" />
            </div>
        </Content>
        <Footer>            
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Submit'})" id="SaveButton" runat="server"><dw:TranslateLabel runat="server" Text="OK" /></button>
            <button class="btn btn-link waves-effect" type="button" onclick="Action.Execute({'Name':'Cancel'})"><dw:TranslateLabel runat="server" Text="Cancel" /></button>
        </Footer>
    </dwc:DialogLayout>
</html>
