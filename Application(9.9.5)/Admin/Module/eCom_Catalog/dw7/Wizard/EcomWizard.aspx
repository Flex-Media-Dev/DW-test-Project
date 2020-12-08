<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="EcomWizard.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomWizard" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title><%=Dynamicweb.SystemTools.Translate.JSTranslate("Dynamicweb eCom Wizard",9)%></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1" />
    <meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1" />
    <meta name="vs_defaultClientScript" content="JavaScript" />
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />
	<link rel="stylesheet" type="text/css" href="wizard.css" />
	
	<script type="text/javascript">
	var TotalPages	= 5;
	var method		= "PRODUCT"
	</script>
	<script type="text/javascript" language="JavaScript" src="wizard.js"></script>
  </head>
  <body MS_POSITIONING="GridLayout">

    <form name="WizardForm" id="WizardForm" method="post">
    <input type="hidden" name="CMD" value="" />

	<div class="HEADER">
		<span id="Version" class="TITLE1">Title</span> 
		<span class="TITLE2"><%=Translate.Translate("Guiden %%", "%%", Translate.Translate("Opret produkt"))%></span> 
		<span class="PAGESTATUS"><%=Translate.Translate("Side")%> 
			<span id="Page">1</span> <%=Translate.Translate("af")%> 
			<span id="TotalPages">1</span>
		</span>
	</div>

	<DIV CLASS="PAGE" ID="PAGE1">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Generelt")%></SPAN><br />
		<p>
			<table border=0 cellpadding=2 cellspacing=0 width='100%' style='width:100%;'>
			<tr><td>
				<table border=0 cellpadding=2 cellspacing=2 width="100%">
				<tr>
				<td width="100"><%=Translate.Translate("Nummer")%></td>
				<td><input type="text" name="Number"></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Navn")%></td>
				<td><input type="text" name="Name"></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Lagerstand")%></td>
				<td><input type="text" name="Stock"></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Vægt")%></td>
				<td><input type="text" name="Weight"> <%=Translate.Translate("Kg.")%></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Rumfang")%></td>
				<td><input type="text" name="Volume"> <%=Translate.Translate("m³")%></td>
				</tr>
				</table>
			</td></tr>
			</table>			
		</P>
	</DIV>
	
	<DIV CLASS="PAGE" ID="PAGE2" style="display:none;">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Beskrivelse")%></SPAN><br />
		<br />
		<p>
			<table border=0 cellpadding=2 cellspacing=0 width='100%' style='width:100%;'>
			<tr><td>
				<table border=0 cellpadding=2 cellspacing=2 width="100%">
				<tr>
				<td width="100"><%=Translate.Translate("Kort")%></td>
				<td><textarea name="ShortDescription" rows="4" cols="55"></textarea></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Lang")%></td>
				<td><textarea name="LongDescription" rows="8" cols="55"></textarea></td>
				</tr>
				</table>
			</td></tr>
			</table>	
		</P>
	</DIV>	

	<DIV CLASS="PAGE" ID="PAGE3" style="display:none;">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Pris")%></SPAN><BR>
		<BR>
		<p>
			<table border=0 cellpadding=2 cellspacing=0 width='100%' style='width:100%;'>
			<tr><td>
				<table border=0 cellpadding=2 cellspacing=2 width="100%">
				<tr>
				<td width="100"><%=Translate.Translate("Pris")%></td>
				<td><input type="text" name="Price"></td>
				</tr>
				</table>
			</td></tr>
			</table>	
		</P>
	</DIV>

	<DIV CLASS="PAGE" ID="PAGE4" style="display:none;">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Medier")%></SPAN><BR>
		<BR>
		<p>
			<table border=0 cellpadding=2 cellspacing=0 width='100%' style='width:100%;'>
			<tr><td>
				<table border=0 cellpadding=2 cellspacing=2 width="100%">
				<tr>
				<td width="100"><%=Translate.Translate("Small")%></td>
				<td><dw:FileArchive runat="server" id="ProductImageSmall"></dw:FileArchive></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Medium")%></td>
				<td><dw:FileArchive runat="server" id="ProductImageMedium"></dw:FileArchive></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Large")%></td>
				<td><dw:FileArchive runat="server" id="ProductImageLarge"></dw:FileArchive></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Link1")%></td>
				<td><dw:FileArchive runat="server" id="ProductLink1"></dw:FileArchive></td>
				</tr>
				<tr>
				<td width="100"><%=Translate.Translate("Link2")%></td>
				<td><dw:FileArchive runat="server" id="ProductLink2"></dw:FileArchive></td>
				</tr>
				</table>				
			</td></tr>
			</table>	
		</P>
	</DIV>

	<DIV CLASS="PAGE" ID="PAGE5" style="display:none;">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Guiden gennemført")%></SPAN><BR>
		<BR>
		<p>
		<%=Translate.Translate("Guiden er nu gennemført.")%><br>
		<%=Translate.Translate("Vinduet lukker om få sekunder.")%><br><br>
		<%=Translate.Translate("Hvis ikke vinduet lukker af sig selv, klik ""Luk"".")%><br>
		</P>
	</DIV>

	<DIV CLASS="PAGE" ID="PAGEEXECUTE" style="display:none;">
		<SPAN CLASS="SUBHEADER"><%=Translate.Translate("Arbejder...")%></SPAN><BR>
		<BR>
		<p>
			<table border=0 cellpadding=5 cellspacing=0 width="100%">
			<tr>
			<td align=left valign=middle><img src="../images/loading.gif" border="0"></td>
			</tr>
			</table>
		</P>
	</DIV>

	<DIV CLASS="FOOTER" align="right">
		<BUTTON ID="BUTTONCANCEL"><%=Translate.Translate("Annuller")%></BUTTON>
		<BUTTON ID="BUTTONPREV"><%=Translate.Translate("Forrige")%></BUTTON>
		<BUTTON ID="BUTTONNEXT"><%=Translate.Translate("Næste")%></BUTTON>
		<BUTTON ID="BUTTONSTART"><%=Translate.Translate("Start")%></BUTTON>
		<BUTTON ID="BUTTONCLOSEW"><%=Translate.Translate("Luk")%></BUTTON>
	</DIV>

	<iframe frameborder="1" name="EcomUpdator" id="EcomUpdator" width="1" height="1" align="right" marginwidth="0" marginheight="0" border="0" frameborder="0" src="../Edit/EcomUpdator.aspx"></iframe>

    </form>

  </body>
</html>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
