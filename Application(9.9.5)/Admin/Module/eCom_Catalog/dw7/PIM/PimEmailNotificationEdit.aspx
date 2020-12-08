<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimEmailNotificationEdit.aspx.vb" Inherits="Dynamicweb.Admin.PimEmailNotificationEdit" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludejQuery="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        label[for=rbSendIfQueryContainsMoreThan] {
            float: left;
        }
        #NumberOfItems {
            margin: 8px 0px 0pc 30px;
        }
        .has-error .form-control {
            border: 1px solid #bdbdbd;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <fieldset>
            <dwc:InputText ID="NotificationTitle" runat="server" Label="Title" MaxLength="255" ValidationMessage=""  />
            <dwc:InputText ID="NotificationSubject" runat="server" Label="Subject" MaxLength="255" ValidationMessage="" />

            <div class="form-group">
                <label class="control-label">
                    <dw:TranslateLabel runat="server" Text="To" />
                </label>
                <dw:UserSelector ID="UserSelector" runat="server" />
            </div>

            <div class="form-group">
                <label class="control-label">
                    <dw:TranslateLabel runat="server" Text="Query" />
                </label>
                <div class="form-group-input">
                    <dw:GroupDropDownList runat="server" ID="gddQueries" CssClass="selectpicker"></dw:GroupDropDownList>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label">
                    <dw:TranslateLabel runat="server" Text="Rule" />
                </label>
                <div class="form-group-input">
                    <dwc:RadioButton runat="server" Name="RuleType" ID="rbSendIfQueryContainsResult" OnClick="SwapAddInTypePanel(this);" />
                    <div>
                        <dwc:RadioButton runat="server" Name="RuleType" ID="rbSendIfQueryContainsMoreThan" OnClick="SwapAddInTypePanel(this);" />
                        <input id="NumberOfItems" runat="server" name="NumberOfItems" class="form-control std" step="1" value="25" data-number-type="integer" type="number" style="width: 60px;" />
                        <dw:TranslateLabel runat="server" Text="results" />
                    </div>
                    <dwc:RadioButton runat="server" Name="RuleType" ID="rbAlwaysSend" OnClick="SwapAddInTypePanel(this);" />
                </div>
            </div>

            <div class="form-group">
                <label class="control-label">
                    <dw:TranslateLabel runat="server" Text="Template" />
                </label>
                <dw:FileManager runat="server" ID="TemplateSelector" Folder="Templates/PIM/Notifications" FixFieldName="true"></dw:FileManager>
            </div>

            <dwc:InputNumber ID="MaxNumberOfItems" runat="server" IncrementSize="1" Value="25" Label="Max number of items" />

            <dwc:SelectPicker runat="server" Name="PlaceHolder1" ID="PlaceHolder1" Label="PlaceHolder 1" />
            <dwc:SelectPicker runat="server" Name="PlaceHolder2" ID="PlaceHolder2" Label="PlaceHolder 2" />
            <dwc:SelectPicker runat="server" Name="PlaceHolder3" ID="PlaceHolder3" Label="PlaceHolder 3" />
        </fieldset>
        <%Translate.GetEditOnlineScript()%>
    </form>

    <script type="text/javascript">

        function submitForm() {
            var valid = true;                        
            var el = $("NotificationTitle");
            dwGlobal.hideControlErrors(el);
            if (el != null && el.value == "") {
                dwGlobal.showControlErrors(el, "<%= Translate.Translate("required") %>");
                valid = false;
            }
            var el = $("NotificationSubject");
            dwGlobal.hideControlErrors(el);
            if (el != null && el.value == "") {
                dwGlobal.showControlErrors(el, "<%= Translate.Translate("required") %>");
                valid = false;
            }           
            
            if (valid) {
                var theForm = document.forms["form1"];
                theForm.submit();
            }
        }
    </script>
</body>
</html>
