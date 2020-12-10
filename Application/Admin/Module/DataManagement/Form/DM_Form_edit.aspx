<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DM_Form_edit.aspx.vb" Inherits="Dynamicweb.Admin.DataManagement.DM_Form_edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Admin" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="mc" Namespace="Dynamicweb.Admin.ModulesCommon" Assembly="Dynamicweb.Admin" %>

<dw:ModuleHeader ID="headerModule" runat="server" ModuleSystemName="DM_Form" />
<input type="hidden" name="DM_Form_settings" value="FormID,AllowUpdate,FormTemplate,ConfirmationTemplate,pageAfterSave,UploadFolder,renderSubmitButton,renderResetButton,submitButtonValue,resetButtonValue,UseNewsletterSubscription,NewsletterCategories,UserNameField,EmailField,MailFormat,SubscribeCheckboxValue" />
<input type="hidden" name="UploadFolder_field_change" value=":<%= GetDefaultUploadFolder() %>" />

<link rel="Stylesheet" type="text/css" href="/Admin/Module/eCom_Catalog/dw7/images/ObjectSelector.css" />

<script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/ObjectSelector.js"></script>
<script type="text/javascript" src="/Admin/Module/eCom_Catalog/dw7/images/DateSelector.js"></script>
<script type="text/javascript" src="/Admin/Module/DataManagement/Form/style/AjaxQueue.js"></script>

<script type="text/javascript">
    //var selectedProvider = "";
    function SelectFormSaveEvent(provider) {
        var time = new Date();
        
        if ($(provider +"_Event").checked) {
            $(provider +"_FormProviderContainer").style.display = "block";
            $(provider +"_FormProviderProperties").update("<i class=\" <%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%>  fa-spin\"></i>");

            ajaxFormAddInLoader("/Admin/Module/DataManagement/Form/DM_Form_edit.aspx?AJAXCMD=GET_CONTROL_OUTPUT&provider=" + provider + "&timestamp=" + time.getTime(), provider + "_FormProviderProperties", provider);
        } else {
            $(provider +"_FormProviderContainer").style.display = "none";
        }            
    }
    
    function CheckFormSaveEvent(provider) {
        $(provider +"_Event").checked = true;
        SelectFormSaveEvent(provider);
    }

    function ajaxFormAddInLoader(url,divId, provider) {
        AjaxQueue.beginRequest(provider, function(provider) {
            var divId = provider +"_FormProviderProperties";
            
            new Ajax.Request(url, {
                asynchronous: true, 
                evalScripts: true,
                method: 'get',
                
                onComplete: function(request) {                    
                    if(request.status = 200) {                        
                        if (request.responseText != "") {                            
                            $(divId).update(request.responseText)
                            AddInLoadParameters(provider);
                        } else {                            
                            $(divId).style.display = "none";
                        }
                    }
                },
                
                onException: function(request, ex) {
                    $(divId).update("<br/><span class='disableText' style='margin:5px;padding:5px;'>Exception : " + ex.toString() + "</span>");
                }            
            } );
        });
    }
    
    function ajaxLoader(url, id) {
        new Ajax.Updater(id, url, {
            asynchronous: false,
            evalScripts: true,
            method: 'get',
            
            onSuccess: function(request) {
                $(id).update(request.responseText);
            }
        });
    }

    var pageID = '<%= Dynamicweb.Context.Current.Request("PageID") %>'; 
    function AddInLoadParameters(provider) {
        addInParameters_onLoaded = function() { AjaxQueue.endRequest(); }
        updateParametersBySenderId(provider + "_AddInTypes", "div_" + provider + "_parameters", "", pageID);
    }
    
    function ShowFieldSelector(id, obj) {
        if ($(id) != null && $F("FormID").length > 0) {
            var txtBox = $(id);
            var parentDiv = txtBox.parentNode;

            var selectorDiv = parentDiv.down("div");
            if (!selectorDiv) {
                selectorDiv = document.createElement("div");
                selectorDiv.setAttribute("id", id + "SelectorContainer")
                parentDiv.appendChild(selectorDiv);
            }

            if (!obj.checked) {
                txtBox.value = "";
                txtBox.show();
                selectorDiv.hide();
            }else{
                txtBox.hide();
                selectorDiv.show();
                ajaxLoader("/Admin/Module/DataManagement/Form/DM_Form_edit.aspx?AJAXCMD=FILL_FIELDS&formId=" + $F("FormID") + "&provider=" + id + "&timestamp=" + (new Date).getTime(), selectorDiv)
                try {
                    $(id + "_Selector").value = txtBox.value;
                }catch (e) {}
                $(id + "_Selector").onchange();
            }
        }
    }
    
    function SetSelectedField(source, targetID) {
        var target = $(targetID);
        
        target.value = source.value;
    }
    
    function toggleSubmitAction(obj) {
        var templateSelector = $("FM_ConfirmationTemplate");
        var pageSubmit = $("pageAfterSave");
        var pageSubmitBox = $("Link_pageAfterSave");
        
        if (obj == null) {
            var templateRadio = $("formSubmitActionTemplateRadio");
            var pageRadio = $("formSubmitActionPageRadio");
        
            if (templateSelector.value == "" && pageSubmit.value == "") {
                templateRadio.checked = true;
                pageRadio.checked = false;
                toggleSubmitAction(templateRadio);
            }else if (templateSelector.value != "" && pageSubmit.value == "") {
                templateRadio.checked = true;
                pageRadio.checked = false;
                toggleSubmitAction(templateRadio);
            }else if (templateSelector.value == "" && pageSubmit.value != "") {
                templateRadio.checked = false;
                pageRadio.checked = true;
                toggleSubmitAction(pageRadio);
            }else{
                templateSelector.value = "";
                pageSubmit.value = "";
                pageSubmitBox.value = "";
                toggleSubmitAction();
            }
        }else{
            var templateSelectorContainer = $("SaveActionTemplateContainer");
            var pageSubmitContainer = $("SaveActionPageRedirectContainer");
            
            if (obj.id == "formSubmitActionTemplateRadio") {
                templateSelectorContainer.show();
                pageSubmitContainer.hide();
                pageSubmit.value = "";
                pageSubmitBox.value = "";
            }else{
                templateSelectorContainer.hide();
                pageSubmitContainer.show();
                templateSelector.value = "";
            }
        }
    }
    
    function toggleShowButtonValue() {
        var rowSubmit = $("submitButtonValueRow");
        var renderSubmit = $("renderSubmitButton_True");
        var rowReset = $("resetButtonValueRow");
        var renderReset = $("renderResetButton_True");
        
        if (renderSubmit.checked) {
            rowSubmit.show();
        }else{
            rowSubmit.hide();
        }
        if (renderReset.checked) {
            rowReset.show();
        }else{
            rowReset.hide();
        }
    }

    function onChangeFormID(val) {
        var url = "/Admin/Module/DataManagement/Form/DM_Form_edit.aspx?AJAXCMD=SUBSCRIBE_FIELDS&formId=" + val + "&fieldName="
        ajaxLoader(url + 'UserNameField', 'UserNameField');
        ajaxLoader(url + 'EmailField', 'EmailField');
    }

</script>
<style type="text/css">
    .help-block.info{
        margin-top: 4px;
        margin-bottom: 16px;
        width: 20%;
        display: block;
        color: #757575;
        line-height: 1;
        font-size: 11px;
    }
    .control-label{
        float: left;
    }
</style>

<dw:GroupBox ID="GroupBox1" runat="server" DoTranslation="true" Title="Form settings">
    <table cellpadding="1" cellspacing="1" border="0">
        <tr>
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Form" />
                </div>
            </td>
            <td>
                <select name="FormID" id="FormID"  onchange='onChangeFormID(this.value);' class="std">
                    <asp:Literal id="FormList" runat="server"></asp:Literal>
                </select>
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Form template" />
                </div>
            </td>
            <td>
                <dw:FileManager runat="server" ID="FormTemplate" Folder="/Templates/DataManagement/Forms/Form" FullPath="true" />
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel runat="server" Text="When submitting form" />
                </div>
            </td>
            <td>
                <input type="radio" name="formSubmitAction" value="template" id="formSubmitActionTemplateRadio" onclick="toggleSubmitAction(this);" /><label for="formSubmitActionTemplateRadio"><dw:TranslateLabel runat="server" Text="Use confirmation template" /></label><br />
                <input type="radio" name="formSubmitAction" value="page" id="formSubmitActionPageRadio" onclick="toggleSubmitAction(this);" /><label for="formSubmitActionPageRadio"><dw:TranslateLabel runat="server" Text="Redirect to page" /></label>
            </td>
        </tr>
        <tr id="SaveActionTemplateContainer">
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Confirmation template" />
                </div>
            </td>
            <td>
                <dw:FileManager runat="server" ID="ConfirmationTemplate" Folder="/Templates/DataManagement/Forms/Confirmation" FullPath="true" />
            </td>
        </tr>
        <tr id="SaveActionPageRedirectContainer">
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Page after submission" />
                </div>
            </td>
            <td>
                <dw:LinkManager ID="pageAfterSave" runat="server" DisableFileArchive="true" />
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
            &nbsp;
            </td>
            <td>
                <div class="nobr">
                    <dwc:CheckBox ID="AllowUpdate" runat="server" Name="AllowUpdate" Label="Allow the form to update the existing data" />                        
                </div>
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel runat="server" Text="Upload folder" />
            </td>
            <td>
                <div class="nobr">
                    <dw:FolderManager ID="UploadFolder" Name="UploadFolder" Folder="" runat="server" />
                </div>
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel runat="server" Text="Display 'Submit' button" />
            </td>
            <td>
                <div class="nobr">
                    <asp:Literal ID="RenderSubmitLiteral" runat="server" />
                </div>
            </td>
        </tr>
        <tr id="submitButtonValueRow">
            <td class="leftColHigh">
                <dw:TranslateLabel runat="server" Text="'Submit' button label" />
            </td>
            <td>
                <div class="nobr">
                    <asp:Literal ID="submitButtonValueLiteral" runat="server" />
                </div>
            </td>
        </tr>
        <tr>
            <td class="leftColHigh">
                <dw:TranslateLabel runat="server" Text="Display 'Reset' button" />
            </td>
            <td>
                <div class="nobr">
                    <asp:Literal ID="RenderResetLiteral" runat="server" />
                </div>
            </td>
        </tr>
        <tr id="resetButtonValueRow">
            <td class="leftColHigh">
                <dw:TranslateLabel runat="server" Text="'Reset' button label" />
            </td>
            <td>
                <div class="nobr">
                    <asp:Literal ID="resetButtonValueLiteral" runat="server" />
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>



<dw:GroupBox ID="GroupBox2" runat="server" DoTranslation="true" Title="Form save events">
    <table cellpadding="1" cellspacing="1">
        <tr>
            <td class="leftColHigh">
                <div class="nobr">
                    <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Event" />
                </div>
            </td>
            <td>
                <asp:Literal id="FormProviderList" runat="server"></asp:Literal>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<asp:Literal ID="PropertiesBoxesContainer" runat="server"></asp:Literal>

<script type="text/javascript">
    toggleShowButtonValue();

    function LoadSelectedEvents() {
        <%=LoadEventScript()%>
        AjaxQueue.onComplete = function() {
            var chk1 = $("MailReceiptSaveProvider.UseFormFieldForRecipientEmail");
            var chk2 = $("MailFormSaveProvider.UseFormFieldForSenderEmail");
            var chk3 = $("MailFormSaveProvider.UseFormFieldForSenderName");
            var chk4 = $("MailFormSaveProvider.UseFormFieldForRecipient");
            
            if (chk1 != null) {
                if (chk1.checked == true) {
                    chk1.onclick();
                }
            }
            
            if (chk2 != null) {
                if (chk2.checked == true) {
                    chk2.onclick();
                }
            }
            
            if (chk3 != null) {
                if (chk3.checked == true) {
                    chk3.onclick();
                }
            }

            if (chk4 != null) {
                if (chk4.checked == true) {
                    chk4.onclick();
                }
            }
        }
        
        toggleSubmitAction();
    }
    setTimeout("LoadSelectedEvents()", 500);        
</script>