<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ParagraphCompare.aspx.vb" Inherits="Dynamicweb.Admin.ParagraphCompare" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>
    <head>
	    <title>
		    <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Sammenlign versioner" />
	    </title>
	    <dw:ControlResources ID="ControlResources1" runat="server" IncludePrototype="true">
	    </dw:ControlResources>

	    <script type="text/javascript">
		    var versionID = <%=Dynamicweb.Context.Current.Request("VersionID")%>;
		    function restore() {
			    top.opener.restore(versionID);
			    top.close();
			    top.opener.focus();
		    }
		
		    function html(){
			    var loc = '<%=Dynamicweb.Context.Current.Request.RawUrl().ToLower().Replace("&htmlcompare=" & Dynamicweb.Context.Current.Request("htmlCompare"), "") %>' + '&htmlCompare=<%=(Not Dynamicweb.Core.Converter.ToBoolean(Dynamicweb.Context.Current.Request("htmlCompare"))).ToString.ToLower()%>';
			    location = loc;
		    }
		
		    function changeCompare(version){
			    var loc = '<%=Dynamicweb.Context.Current.Request.RawUrl().ToLower().Replace("&versionid=" & Dynamicweb.Context.Current.Request("VersionID"), "") %>' + '&VersionID=' + version;
			    location = loc;
		    }
	    </script>

	    <style type="text/css">
		    th {
                text-transform: uppercase;
                font-size: 13px;
                background-color: #f5f5f5;
                text-align: left;
                white-space: nowrap;
		    }

            td, th {
                padding: 5px 8px;
                border: 1px #e0e0e0 solid;
            }

	        .label-with-buttons {
	            float: left;
                padding-top: 7px;
            }

	        .Toolbar {
	            min-height: 0;
            }

            .Toolbar>ul {
                padding: 0;
	            min-height: 0;
            }

	        .Toolbar>ul>li {
	            margin-left: 0;
            }

            .ci {
			    background-color: #80FF80;
		    }

		    .cd {
			    background-color: #FF8080;
		    }
	    </style>
    </head>
    <body>
        <table>
	        <tr>
		        <th width="170"></th>
		        <th width="30%">
			        <dw:TranslateLabel ID="pubLabel" runat="server" Text="Published" />
			        <dw:TranslateLabel ID="draftLabel" runat="server" Text="Kladde" />
			        <span runat="server" id="appstate" style="display:none;"></span>
		        </th>
		        <th width="30%">
			        <div class="label-with-buttons">
			            <dw:TranslateLabel ID="compareversionLabel" runat="server" Text="Tidligere versioner" />
			        </div>
			        <div style="float:right;" class="inlineToolbar">
			            <dw:Toolbar ID="Toolbar2" runat="server" ShowEnd="false" ShowStart="false">
				            <dw:ToolbarButton ID="ToolbarButton1" runat="server" Divide="None" Icon="Undo" Text="Gendan" OnClientClick="restore();">
				            </dw:ToolbarButton>
			            </dw:Toolbar>
			        </div>
		        </th>
		        <th width="30%">
			        <div class="label-with-buttons">
			            <dw:TranslateLabel ID="TranslateLabel8" runat="server" Text="Compare" />
			        </div>
			        <div style="float:right;" class="inlineToolbar">
			            <dw:Toolbar ID="Toolbar3" runat="server" ShowEnd="false" ShowStart="false">
				            <dw:ToolbarButton ID="showHtml" runat="server" Divide="None" Icon="FormatAlignLeft" Text="HTML" OnClientClick="html();">
				            </dw:ToolbarButton>
			            </dw:Toolbar>
			        </div>
                 </th>
	        </tr>
	        <tr id="versionRow" runat="server">
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel14" runat="server" Text="Version" />
		        </th>
		        <td id="VersionPub" runat="server"></td>
		        <td id="VersionOld" runat="server"></td>
		        <td id="Td3" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel3" runat="server" Text="Afsnitsnavn" />
		        </th>
		        <td id="HeadingPub" runat="server"></td>
		        <td id="HeadingOld" runat="server"></td>
		        <td id="HeadingCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel4" runat="server" Text="Tekst" />
		        </th>
		        <td id="TextPub" runat="server"></td>
		        <td id="TextOld" runat="server"></td>
		        <td id="TextCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel9" runat="server" Text="Billede" />
		        </th>
		        <td id="ImagePub" runat="server"></td>
		        <td id="ImageOld" runat="server"></td>
		        <td id="ImageCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel5" runat="server" Text="Link" />
		        </th>
		        <td id="LinkPub" runat="server"></td>
		        <td id="LinkOld" runat="server"></td>
		        <td id="LinkCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel10" Text="Alt-tekst" runat="server" />
		        </th>
		        <td id="AltPub" runat="server"></td>
		        <td id="AltOld" runat="server"></td>
		        <td id="AltCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel11" Text="Template" runat="server" />
		        </th>
		        <td id="TemplatePub" runat="server"></td>
		        <td id="TemplateOld" runat="server"></td>
		        <td id="TemplateCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel12" Text="Aktiv fra" runat="server" />
		        </th>
		        <td id="PubfromPub" runat="server"></td>
		        <td id="PubfromOld" runat="server"></td>
		        <td id="PubfromCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel13" Text="Aktiv til" runat="server" />
		        </th>
		        <td id="PubtoPub" runat="server"></td>
		        <td id="PubtoOld" runat="server"></td>
		        <td id="PubtoCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel16" Text="Redigeret" runat="server" />
		        </th>
		        <td id="EditPub" runat="server"></td>
		        <td id="EditOld" runat="server"></td>
		        <td id="EditCompare" runat="server"></td>
	        </tr>
	        <tr>
		        <th>
			        <dw:TranslateLabel ID="TranslateLabel18" Text="Bruger" runat="server" />
		        </th>
		        <td id="UserPub" runat="server"></td>
		        <td id="UserOld" runat="server"></td>
		        <td id="UserCompare" runat="server"></td>
	        </tr>
        </table>
    </body>
</html>
