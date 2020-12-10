<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="Message.aspx.vb" Inherits="Dynamicweb.Admin.SmsMessage" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="HeadContent" runat="server">
	<script>
	    var confirmSendMsg = "<%=Translate.JsTranslate("Send")%>?";
	    var specifyNameErrorMsg = "<%=Translate.JsTranslate("Please specify name")%>";
	    var specifyMessageErrorMsg = "<%=Translate.JsTranslate("Please specify message")%>";
	    var specifyRecipientsErrorMsg = "<%=Translate.JsTranslate("Please specify recipients")%>";
	    var txtMessages = "<%=Translate.JsTranslate("messages")%>";

	    function requiredFieldValidate(el, errorMsg, forceFocusToElement) {
	        if (!el.value) {
	            dwGlobal.showControlErrors(el, errorMsg);
	            if (forceFocusToElement && el.focus) {
	                el.focus();
	            }	            
	            return false;
	        }
	        dwGlobal.hideControlErrors(el);
	        return true;
	    }

	    function validate() {
	        var res = requiredFieldValidate(document.getElementById("MessageName"), specifyNameErrorMsg, true);
	        res = requiredFieldValidate(document.getElementById("MessageText"), specifyMessageErrorMsg, res) && res;
	        res = requiredFieldValidate(document.getElementById("MessageGrouphidden"), specifyRecipientsErrorMsg, res) && res;
	        return res;
	    }

	    function send() {
	        if (validate()) {
	            if (confirm(confirmSendMsg)) {
	                document.getElementById("SendButton").click();
	            }
	        }
		}

		function calculate(field) {
			var msgCount = 0
			if (field.value.length > 0) {
				msgCount = Math.ceil(field.value.length / 160);
			}
			
			if (field.value.length > 120) {
				var header = 0;
				if (msgCount > 1) {
					header = 14; //If a text message is more than one message long, it uses a header to chain them
				}
				if (msgCount > 2) {
					header = 21; //If a text message is more than one message long, it uses a header to chain them
				}
				if (msgCount > 3) {
					header = 28; //If a text message is more than one message long, it uses a header to chain them
				}
				document.getElementById("charCount").innerHTML = field.value.length + "/" + ((msgCount*160)-header);
			} else {
				document.getElementById("charCount").innerHTML = "";
			}
			
			if (field.value.length > 160){
			    document.getElementById("msgCount").innerHTML = msgCount + " " + txtMessages + ", ";
			} else {
				document.getElementById("msgCount").innerHTML = "";
			}
		}

		function deleteMessage() {
		    var act = <%= GetDeleteMessagesAction().ToJson() %>;
		    act.OnSubmitted.Function = function(){
		        document.getElementById("DeleteButton").click();
		    }
            Action.Execute(act);
		}

	    window.addEventListener("load", function (event) {
	        var msgTextEl = document.getElementById("MessageText");
	        var fn = dwGlobal.debounce(function () {
	            calculate(msgTextEl);
	        }, 200);
	        msgTextEl.addEventListener("keyup", fn);
	        dwGlobal.Dom.triggerEvent(msgTextEl, "keyup");
	    });
	</script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
		<dw:Toolbar ID="ToolbarButtons" runat="server" ShowEnd="false">
			<dw:ToolbarButton ID="cmdSaveAndSend" runat="server" Disabled="false" Divide="None" Icon="Save" OnClientClick="send();" Text="Save and send" ShowWait="false" />
			<dw:ToolbarButton ID="cmdCancel" runat="server" Disabled="false" Divide="None" Icon="TimesCircle" OnClientClick="location='SmsList.aspx'" Text="Cancel" />
            <dw:ToolbarButton ID="cmdDelete" runat="server" Divide="Before" Icon="TimesCircle" Text="Delete" OnClientClick="deleteMessage();" Disabled="True"/>  
            <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="Before" Icon="Help" Text="Help" OnClientClick="help();" />
		</dw:Toolbar>
        <dwc:CardHeader runat="server" Title="New text message"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="gbMessage" Title="Message" runat="server">
                <dwc:InputText runat="server" ID="MessageName" Name="MessageName" Label="Name" ValidationMessage="" />
                <dwc:InputTextArea runat="server" ID="MessageText" Label="Message" Info="" ValidationMessage="" />
                <div class="form-group">
                    <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Send to groups" />
                    <div class="form-group-input">
                        <dw:UserSelector runat="server" ID="MessageGroup" Show="Users, Groups, SmartSearches" Width="250"></dw:UserSelector>
                        <small class="help-block error" id="helpMessageGrouphidden"></small>
                    </div>
                </div>
            </dwc:GroupBox>
            <asp:Button ID="DeleteButton" ClientIDMode="Static" Style="display: none" runat="server" />
            <asp:Button ID="SendButton"  ClientIDMode="Static" Style="display: none" runat="server" />
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
