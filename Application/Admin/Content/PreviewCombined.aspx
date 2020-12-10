<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PreviewCombined.aspx.vb" Inherits="Dynamicweb.Admin.PreviewCombined" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<!DOCTYPE html>

<html>
<head id="Head1" runat="server">
    <title><dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Preview" /></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1" />
	<dw:ControlResources ID="ControlResources01" runat="server" IncludeUIStylesheet="true" IncludePrototype="true" />
    <link rel="stylesheet" href="../Module/OMC/Experiments/Preview.css" type="text/css" />
    <script type="text/javascript" src="../Module/OMC/Experiments/Preview.js"></script>
    
    <script>
      document.addEventListener('DOMContentLoaded', function () {
        window.preview = new Preview({
            preview: document.getElementById('preview'),
            pageId: '<%= PageID %>',
            page: '<%=OriginalPage %>'
        });

        window.addEventListener('unload', preview.disableProfileTest());
    });
    </script>
	
 <style type="text/css">        
        .DivCheckBoxList
        {
	        display:none;
	        background-color:White;
	        width:250px;
	        position:absolute;
	        height:200px;
	        overflow-y:auto; 
	        overflow-x:hidden;
	        border-style:solid;
	        border-color:Gray; 
	        border-width:1px;
            z-index:1000;
        }

        .CheckBoxList
        {
	        position:relative;
	        width:250px;
	        height:10px; 
	        overflow:scroll;
	        font-size:small;
        }
    </style>
    <script type="text/javascript">	        
        var timoutID;
        function ShowMList()
        {
            var divRef = document.getElementById("divCheckBoxList");
            if(divRef)
                divRef.style.display = "block";            
        }
    	
        function HideMList()
        {
            if(document.getElementById("divCheckBoxList"))
                document.getElementById("divCheckBoxList").style.display = "none";            
        }
	    
        function FindSelectedItems()
        {
            var cblstTable = document.getElementById("lstMultipleValues")
            var selectedValues = "";
            var selOrderId = "";
            if (cblstTable) {
                var labelID = "txtSelectedMLValues"            
                var checkBoxPrefix = cblstTable.id + "_";
                var noOfOptions = cblstTable.rows.length;
                var selectedText = "";
                
                for(i = 0; i < noOfOptions ; ++i)
                {
                    if(document.getElementById(checkBoxPrefix + i).checked)
                    {
                        var node = document.getElementById(checkBoxPrefix + i).parentNode;
                        if(node){
                            if(selectedText == ""){ 
                                if(node.lastChild){
                                    selectedText = node.lastChild.innerHTML;
                                }else{
                                    selectedText = node.innerHTML;
                                }                            
                                selectedValues = node.attributes["jsvalue"].value;
                            }else{
                                if(node.lastChild){
                                    selectedText = selectedText + "," + node.lastChild.innerHTML;
                                }else{
                                    selectedText = selectedText + "," + node.innerHTML;
                                }                            
                                selectedValues = selectedValues + "," + node.attributes["jsvalue"].value;
                            }
                        }
                    }
                }                
                if(document.getElementById(labelID)){
                    document.getElementById(labelID).innerText  = selectedText;
                    document.getElementById(labelID).title  = selectedText;
                }
            }
            var previewOrder = document.getElementById("previewOrder")
            if (previewOrder) {
                selOrderId = previewOrder[previewOrder.selectedIndex].value;
            }
            var url;
            if (selectedValues.length > 0 || selOrderId.length > 0){
                url = "/Admin/Content/Previewcombined.aspx?PageID=" + <%=PageID%> + "&emailPrewiew=true&segmentID=" + selectedValues + "&orderID=" + selOrderId;
            }
            else{
                url = $("testurl").value;
            }
            document.getElementById("previewFrame").src = url;
        }
    </script>
</head>
<body>
	<form runat="server"  id="preview" class="preview">
        <input type="hidden" id="testurl" value="<%=OriginalPage %>" />
        <input type="hidden" id="isDraft" value="" />
        <input type="hidden" runat="server" id="isOMC" value="" />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>    
        <header id="header" class="preview__header">
            <div class="preview__header-logo">
                <a href="/">
                    <img width="28" src="/Admin/Resources/img/DWLogoStar.svg" alt="Logo" />
                </a>
            </div>
            <div class="preview__header-actions">
                <div id="prevOMCdiv" runat="server" class="preview__tool preview__tool--wide">
                    <dwc:SelectPicker runat="server" ID="prevOMCList" onChange="window.preview.changeOMC(this)" Width="200"></dwc:SelectPicker>
                </div>
                <div id="prevSegmentDiv" runat="server" class="preview__tool">
		            <h1 class="previewLabel"><%= Dynamicweb.SystemTools.Translate.Translate("Preview segment") & ": "%></h1>                    
                    <div>
                        <asp:UpdatePanel runat="server">
                            <ContentTemplate>                     
                                <div runat="server" onmouseover="clearTimeout(timoutID);" onmouseout="timoutID = setTimeout('HideMList()', 750);">
                                    <table>
                                        <tr>
                                            <td align="right">
                                                <div class="std" onclick="ShowMList()"  style="height:30px;width:229px;">
                                                    <label id="txtSelectedMLValues" onclick="ShowMList()" runat="server" style="text-align: left;float:left;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;width:205px;"  />
                                                    <i class="fa fa-caret-down" runat="server" style="padding-top: 4px;" onclick="ShowMList()" align="right" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div>            	                            
                                                    <div runat="server" id="divCheckBoxList" class="DivCheckBoxList">
		                                                <asp:CheckBoxList ID="lstMultipleValues" runat="server" Width="250px" CssClass="CheckBoxList"></asp:CheckBoxList>						        			           			        
		                                            </div>
		                                        </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>   
                    </div>
                </div>
                <div class="preview__tool">
                    <dwc:SelectPicker runat="server" ID="prevSizeList" onChange="window.preview.changeFrame(this)" Width="200"></dwc:SelectPicker>
                </div>
                <div id="rotateScreen" runat="server" class="preview__tool preview__tool--rotate">
                    <i class="fa fa-mobile preview__rotate js-preview-rotate" data-rotate-target="prevSizeList"></i>
                </div>
                <div id="prevProfileDiv" runat="server" class="preview__tool">
                    <dwc:SelectPicker runat="server" ID="profilesList" onChange="window.preview.changeProfile(this)" Width="200"></dwc:SelectPicker>
                </div>
                <div id="prevPubStateDiv" runat="server" class="preview__tool">
                     <dwc:SelectPicker runat="server" ID="prevStateList" onChange="window.preview.changeState(this)" Width="200"></dwc:SelectPicker>
                </div>
                <div id="previewOrderDiv" runat="server" class="preview__tool" visible="false">
                    <asp:DropDownList  runat="server" ID="previewOrder" onchange="FindSelectedItems(event)"></asp:DropDownList>
                </div>
            </div>
        </header>
	    <div id="previewContent" class="preview__content">
            <div data-id="previewFrame" class="preview__loader js-preview-loader"></div>
		    <iframe id="previewFrame" class="preview__frame js-preview-frame"></iframe>
	    </div>      
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
    %>
</html>

