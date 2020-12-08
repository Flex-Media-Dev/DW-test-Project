<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="System.Data" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="EditorLinker.aspx.vb" Inherits="Dynamicweb.Admin.EditorLinker" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
  	<script language="javascript">
		var fromToolbar = false;
		var editorObject = null;
				
		// to avoid stange behavior when writing css styles from InnerDialogLoaded
		document.write = function(str) {
			return false;
		}
		
		window.onload = function() {
			fromToolbar = (typeof(window.parent.InnerDialogLoaded) != 'undefined');
			document.getElementById('rowSubmit').style.display = fromToolbar ? 'none' : '';
			if (fromToolbar) {
			    PluginInitialize();
			}
			var starageEl = document.getElementById("PageShortCut");
			starageEl.setAttribute("data-opener-callback", "_storeSelectedPage");			
		}

		function _storeSelectedPage(args) {
		    document.cookie = "selectedPageId=" + args.pageID;
		}
		
		function PluginInitialize() {
			editorObject = window.parent.InnerDialogLoaded();
			window.parent.SetOkButton(true);
		}
		
		function Ok() {
		    editorObject.DwPageLink.InsertLink(GetShortCutValue());
			return true;
		}
				
		function internalNewEditor()
		{
		    var tmp = GetShortCutValue();
			var txtLnkUrl = ((navigator.userAgent.indexOf("Firefox") != -1) ? top.opener.document.getElementById("txtLnkUrl") : top.opener.document.all.item("txtLnkUrl"));
			var txtUrl = ((navigator.userAgent.indexOf("Firefox") != -1) ? top.opener.document.getElementById("txtUrl") : top.opener.document.all.item("txtUrl"));

			if (top.opener.document.getElementById("txtLnkUrl")) {
			    txtLnkUrl.value = tmp;
			} else {
			    txtUrl.value = tmp;
			}

			if (top.opener.document.getElementById("txtLnkUrl")) {
			    top.opener.document.getElementById("cmbLnkTarget").selectedIndex = 3;
			} else {
			    top.opener.document.getElementById("cmbLinkProtocol").selectedIndex = 4;
			}
			
			self.close();
        }

        function GetShortCutValue() {
            var tmp = document.getElementById("PageShortCut").value;
            if (tmp.indexOf("/", 0) > -1) {
                tmp = "/Files" + tmp;
            }
            return tmp;
        }
	</script>
  
    <title>EditorLinker</title>
	
	<meta name="robots" content="noindex, nofollow">
  </head>
    
  <body  scroll="no" style="OVERFLOW: hidden">
	<table height="100%" cellSpacing="0" cellPadding="0" width="100%" border="0">
		<tr>
			<td>
				<table cellSpacing="0" cellPadding="0" align="center" border="0">
					<tr>
						<td>
							<%=Dynamicweb.SystemTools.Gui.LinkManager("", "PageShortCut", "", "0", Dynamicweb.Core.Converter.ToInt32(Session("DW_Area")), False, True, True, "", True, True)%>
						</td>
					</tr>
					<tr id="rowSubmit" style="display:">
						<td>
							<br />
							<%=Dynamicweb.SystemTools.Gui.Button(Translate.Translate("OK"), "internalNewEditor();", 0)%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>	
  </body>
</html>
<script>

</script>
