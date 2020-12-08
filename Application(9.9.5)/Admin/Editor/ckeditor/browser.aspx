<%@ Page Language="vb" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="utf-8" />
    <title>Link Browser</title>
    <dw:ControlResources ID="ControlResources1" IncludePrototype="true" runat="server" IncludeUIStylesheet="false">
        <Items>
            <dw:GenericResource Url="/Admin/Editor/ckeditor/ckeditor/ckeditor.js" />
            <dw:GenericResource Url="/Admin/Link.js" />
        </Items>
    </dw:ControlResources>
</head>
<body>
    <dwc:DialogLayout runat="server" ID="LinkEdit" Title="Link">
        <Content>
            <div class="form-group">
                <label class="control-label" for="Link_url"><%=Translate.Translate("Link")%></label>
                <%= Gui.MakeLinkManager("", "url", False, True, True, "", True, True) %>
            </div>
        </Content>
        <Footer>
            <button class="btn btn-link waves-effect" type="button" onclick="finishBrowse(null, getQueryValue('fId'));"><dw:TranslateLabel runat="server" Text="Save and close" /></button>
            <button class="btn btn-link waves-effect" type="button" onclick="closeDialog();"><dw:TranslateLabel runat="server" Text="Close" /></button>
        </Footer>
    </dwc:DialogLayout>
    <script>
        function setLink(url, data, filebrowserFunctionID) {
            var opener = Action._getCurrentDialogOpener();
            if (opener && typeof opener.CKEDITOR.tools.callFunction != 'undefined') {
                opener.CKEDITOR.tools.callFunction(filebrowserFunctionID, url, function () {
                    var element,
                    dialog = this.getDialog();
                    if (dialog.getName() == 'link') {
                        var tabId, attribute;
                        if (data.attributes) {
                            for (tabId in data.attributes) {
                                for (attribute in data.attributes[tabId]) {
                                    element = dialog.getContentElement(tabId, attribute);
                                    if (element) {
                                        element.setValue(data.attributes[tabId][attribute]);
                                    }
                                }
                            }
                        }
                    }
                });
            }
        }

        function finishBrowse(dialogID, filebrowserFunctionID) {
            var url = document.getElementById('url').value,
            type, rel,
            title = document.getElementById('Link_url').value,
            data = { url: url, attributes: {} };

            if (/Default.aspx.*#/i.test(url)) {
                type = 'internal link';
                url = '/' + url;
            } else if (/Default.aspx/i.test(url)) {
                type = 'link';
                url = '/' + url;
            } else if (url) {
                type = 'file';
            }

            setLink(url, data, filebrowserFunctionID);
            closeDialog();
        }

        function getQueryValue(paramName) {
            var url = window.location.href;
            paramName = paramName.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + paramName + "(=([^&#]*)|&|#|$)");
            var results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }

        function closeDialog() {
            Action.Execute({ Name: 'CloseDialog', Result: 'cancel' });
        }
    </script>
</body>
</html>
