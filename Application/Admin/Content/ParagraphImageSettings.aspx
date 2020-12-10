<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="ParagraphImageSettings.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphImageSettings" codePage="65001" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
    <head runat="server">
        <title></title>
		<dw:ControlResources runat="server"></dw:ControlResources>
        
        <style type="text/css">
            body 
            {
            	background-color: #ffffff;
            }
            
            .content
            {
            	background-color: #ffffff;
            }
        </style>
        
        <script language="javascript" type="text/javascript">
            function initializeForm() {
                setDropdownValue('ddHSpace', document.getElementById('hHSpace').value);
                setDropdownValue('ddVSpace', document.getElementById('hVSpace').value);
                setDropdownValue('ddTarget', document.getElementById('hTarget').value);
            }
            
            function setDropdownValue(ddID, value) {
                var opt = document.getElementById(ddID + '_' + value);
                if(opt) opt.selected = true;
            }
            
            function submitForm() {
                submitObject();
                closeForm();
            }
            
            function submitObject() {
                var pid = parseInt(document.getElementById('hFrontendPID').value);
                var obj = null;
                
                var fields = [
                    ['fileName', 'FM_fmImage' ],
                    ['url', 'txURL' ],
                    ['target', 'ddTarget'],
                    ['alt', 'txAltText'],
                    ['caption', 'txCaption'],
                    ['resize', 'chkResize'],
                    ['verticalAlign', 'ddVSpace'],
                    ['verticalSpace', 'txVSpace'],
                    ['horizontalAlign', 'ddHSpace'],
                    ['horizontalSpace', 'txHSpace']
                ];
                
                try {
                    if(window.opener && !window.opener.closed) {
                        obj = window.opener.ParagraphImage.create(pid); 
                        
                        for(var i = 0; i < fields.length; i++) {
                            var pair = fields[i];
                            var formItem = document.getElementById(pair[1]);
                            
                            if(formItem) {
                                if(formItem.getAttribute('type') == 'checkbox')
                                    obj.settings[pair[0]] = formItem.checked;
                                else
                                    obj.settings[pair[0]] = formItem.value;
                            }
                        }
                        
                        obj.settings.hasImage = obj.settings.fileName.length > 0;
                        
                        window.opener.ParagraphImage.modifyCollection(obj);    
                        window.opener.ParagraphImageHandler.updateImage(pid);
                    }
                } catch(ex) { }
            }
            
            function closeForm() {
                window.close();
            }
            
            function validateInt(obj) {
                if (!parseInt(obj.value)) {
		            obj.value = 0;
		            alert(document.getElementById('msgInvalidNumber').innerHTML);
	            }
	            else 
		            obj.value = parseInt(obj.value);
	        }
	        
        </script>
    </head>
    
    <body onload="initializeForm();">
        <form id="MainForm" runat="server" enableviewstate="false">
            <table id="MainTable" border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td>
                        <dw:Toolbar runat="server" ShowStart="false" ShowEnd="false" ID="Toolbar">
                            <dw:ToolbarButton ID="cmdSave" Image="SaveAndClose" Text="Gem og luk" runat="server" OnClientClick="submitForm(); return false;" />
                            <dw:ToolbarButton ID="cmdClose" Image="Delete" Text="Close" runat="server" OnClientClick="closeForm(); return false;" />
                        </dw:Toolbar>
                    </td>
                </tr>
                <tr>
                    <td class="content">
                        <table border="0" cellspacing="0" cellpadding="0" style="width: 500px">
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                            <tr id="rowImagePath" runat="server" visible="false">
                                <td colspan="2">
                                    <dw:GroupBoxStart ID="boxGeneralStart" Title="Generelt" runat="server" />
                                    <table cellpadding="2" cellspacing="0">
                                        <tr>
                                            <td width="130">
                                                <dw:TranslateLabel ID="lbImagePath" Text="Billed" runat="server" />
                                            </td>
                                            <td>
                                                <dw:FileManager ID="fmImage" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                    <dw:GroupBoxEnd ID="boxGeneralEnd" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <dw:GroupBoxStart ID="boxAlignmentStart" Title="Justering" runat="server" />
                                    <table cellpadding="2" cellspacing="0">
                                        <tr>
                                            <td width="130">
                                                <dw:TranslateLabel ID="lbHorizontalAlignment" Text="Horisontal" runat="server" />
                                            </td>
                                            <td>
                                                <input type="text" id="txHSpace" runat="server" class="std" onchange="validateInt(this);" style="width: 20px" />
                                                <dw:TranslateLabel ID="lbHSpacePx" Text="px. fra" runat="server" />
                                                <select id="ddHSpace" class="std" style="width: 120px">
                                                    <option id="ddHSpace_left" value="left"><dw:TranslateLabel ID="lbHSpaceLeft" Text="Venstre" runat="server" /></option>
                                                    <option id="ddHSpace_right" value="right"><dw:TranslateLabel ID="lbHSpaceRight" Text="Højre" runat="server" /></option>
                                                    <option id="ddHSpace_center" value="center"><dw:TranslateLabel ID="lbHSpaceCenter" Text="Centreret" runat="server" /></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="lbVerticalAlignment" Text="Vertikal" runat="server" />
                                            </td>
                                            <td>
                                                <input type="text" id="txVSpace" runat="server" class="std" onchange="validateInt(this);" style="width: 20px" />
                                                <dw:TranslateLabel ID="lbVSpacePx" Text="px. fra" runat="server" />
                                                <select id="ddVSpace" class="std" style="width: 120px">
                                                    <option id="ddVSpace_top" value="top"><dw:TranslateLabel ID="lbVSpaceTop" Text="Top" runat="server" /></option>
                                                    <option id="ddVSpace_bottom" value="bottom"><dw:TranslateLabel ID="lbVSpaceBottom" Text="Bund" runat="server" /></option>
                                                    <option id="ddVSpace_middle" value="middle"><dw:TranslateLabel ID="lbVSpaceMiddle" Text="Midt" runat="server" /></option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <dw:GroupBoxEnd ID="boxAlignmentEnd" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:PlaceHolder ID="phResize" Visible="false" runat="server">
                                        <dw:GroupBoxStart ID="gbResizeStart" Title="Skalering" runat="server" />
                                        <table cellpadding="2" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:CheckBox id="chkResize" runat="server" />
                                                    <label for="chkResize">
                                                        <dw:TranslateLabel ID="lbResize" Text="Tilpas billede" runat="server" />
                                                    </label>
                                                </td>
                                            </tr>
                                        </table>   
                                        <dw:GroupBoxEnd ID="gbResizeEnd" runat="server" />
                                    </asp:PlaceHolder>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <dw:GroupBoxStart ID="gbLinkStart" Title="Link" runat="server" />
                                    <table cellpadding="2" cellspacing="0">
                                        <tr>
                                            <td width="130" valign="top">
                                                <dw:TranslateLabel ID="lbLink" Text="Link" runat="server" />
                                            </td>
                                            <td>
                                                <asp:Label ID="labelLinkManager" runat="server" />
                                            </td>    
                                        </tr>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="lbCaption" Text="Billedetekst" runat="server" />
                                            </td>
                                            <td>
                                                <input type="text" id="txCaption" maxlength="255" class="std" runat="server" />
                                            </td>
                                        </tr>
                                        <asp:PlaceHolder ID="phAlternateText" Visible="false" runat="server">
                                            <tr>
                                                <td>
                                                    <dw:TranslateLabel ID="lbAltText" Text="Alt-tekst" runat="server" />
                                                </td>
                                                <td>
                                                    <input type="text" id="txAltText" maxlength="255" runat="server" class="std" />
                                                </td>
                                            </tr>
                                        </asp:PlaceHolder>
                                        <tr>
                                            <td>
                                                <dw:TranslateLabel ID="lbTarget" Text="Target" runat="server" />
                                            </td>
                                            <td>
                                                <select id="ddTarget" class="std">
                                                    <option id="ddTarget_" value=""><dw:TranslateLabel ID="lbTargetStandard" Text="Standard" runat="server" /></option>
                                                    <option id="ddTarget__blank" value="_blank"><dw:TranslateLabel ID="lbTargetBlank" Text="Nyt vindue (_blank)" runat="server" /></option>
                                                    <option id="ddTarget__top" value="_top"><dw:TranslateLabel ID="lbTargetTop" Text="Samme vindue (_top)" runat="server" /></option>
                                                    <option id="ddTarget__self" value="_self"><dw:TranslateLabel ID="lbTargetSelf" Text="Samme ramme (_self)" runat="server" /></option>>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <dw:GroupBoxEnd ID="gbLinkEnd" runat="server" />
                                </td>
                            </tr>
                        </table>
                        
                        <span id="msgInvalidNumber" style="display: none">
                            <dw:TranslateLabel ID="lbInvalidNumber" Text="Angiv heltal" runat="server" />
                        </span>
                        
                        <input type="hidden" id="hHSpace" value="" runat="server" />
                        <input type="hidden" id="hVSpace" value="" runat="server" />
                        <input type="hidden" id="hTarget" value="" runat="server" />
                        <input type="hidden" id="hFrontendPID" value="" runat="server" />
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>

<%  Translate.GetEditOnlineScript()%>
