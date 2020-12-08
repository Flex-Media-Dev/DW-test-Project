<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Page Language="vb" AutoEventWireup="false" Codebehind="EcomWizardImpExp.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomWizardImpExp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title><%=Dynamicweb.SystemTools.Translate.JSTranslate("Dynamicweb eCom Wizard",9)%></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
	<link rel="stylesheet" type="text/css" href="wizard.css">
	
	<script>
	var TotalPages = 7;
	</script>
	<script type="text/javascript" language="JavaScript" src="wizard.js"></script>
	<script src="/Admin/FileManager/FileManager_browse2.js" type="text/javascript"></script>

  </head>
  <body MS_POSITIONING="GridLayout">

    <form id="WizardForm" method="post" runat="server">

	<DIV CLASS="HEADER">
		<SPAN ID="Version" CLASS="TITLE1">DW Ecom v1.1</SPAN> 
		<SPAN CLASS="TITLE2">Guiden Import Export</SPAN> 
		<SPAN CLASS="PAGESTATUS">Side 
			<SPAN ID="Page">1</SPAN> af 
			<SPAN ID="TotalPages">7</SPAN>
		</SPAN>
	</DIV>

	<DIV CLASS="PAGE" ID="PAGE1">
     
		<SPAN CLASS="SUBHEADER">Vælg fil of el. type</SPAN><BR>
		
		<table cellpadding=2 cellspacing=2 width="100%">
		<tr>
		<td>Vælg fil</td>
		<td><dw:FileArchive runat="server" id="W_FileName"></dw:FileArchive></td>
		</tr>
		<tr>
		<td>Vælg type</td>
		<td><select><option>Ingen</option><option>CSV (Tekst)</option><option>XML</option><option>Access database</option><option>SQL tekst fil</option><option>DB Connection</option></select></td>
		</tr>
		</table>

	</DIV>
	
	<DIV CLASS="PAGE" ID="PAGE2">
     
		<SPAN CLASS="SUBHEADER">Opret / vælg import</SPAN><BR>
		
		<table cellpadding=2 cellspacing=2 width="100%">
		<tr>
		<td><input type=radio name=wType value=0> Opret ny</td>
		</tr>
		<tr>
		<td><input type=radio name=wType value=1> Vælg blandt allerede oprettede</td>
		</tr>
		<tr>
		<td>
		<select name=imports size=10 style="width:100%;">
		<option value="1">Import 1 [Products]</option>
		<option value="1">Import 2 [Products]</option>
		<option value="1">Import 4 [Pictures]</option>
		<option value="1">Import 7 [Stock]</option>
		<option value="1">Import 11 [Paymethods]</option>
		<option value="1">Import 27 [Vat groups]</option>
		</select>
		</td>
		</tr>
		</table>

	</DIV>	

	<DIV CLASS="PAGE" ID="PAGE3">
     
		<SPAN CLASS="SUBHEADER">Data type genkeldelse</SPAN><BR>
		
		<table cellpadding=2 cellspacing=2 width="100%">
		<tr>
		<td>Vælg tekst qualifier</td>
		<td><select><option>'</option><option>´</option><option>"</option><option>""</option></select></td>
		</tr>
		<tr>
		<td>Vælg seperator</td>
		<td><select><option>;</option><option>,</option><option>#</option><option>@</option><option>Tabulator [TAB]</option><option>Mellemrum [SPACE]</option></select></td>
		</tr>
		</table>

	</DIV>

	
	<DIV CLASS="PAGE" ID="PAGE4">

		<SPAN CLASS="SUBHEADER">Data format</SPAN><BR>
		
		<table cellpadding=2 cellspacing=2 width="100%">
		<tr>
		<td>
		<input type=radio name=wFormat value=0> Opret format&nbsp;&nbsp;<input type=text name=formatString size=50>&nbsp;<img src="../images/check.gif">
		</td>
		<tr>
		<td>
		<input type=radio name=wFormat value=1> Brug format<br>
		</td>
		</tr>
		</tr>
		<tr>
		<td><input type=radio name=wFormat value=2> Vælg blandt allerede oprettede</td>
		</tr>
		<tr>
		<td>
		<select name=imports size=10 style="width:100%;">
		<option value="1">Format 1</option>
		<option value="1">Format 2</option>
		<option value="1">Format 3</option>
		<option value="1">Format 4</option>
		<option value="1">Format 5</option>
		<option value="1">Format 6</option>
		</select>
		</td>
		</tr>
		</table>
	
	</DIV>	
	
	<DIV CLASS="PAGE" ID="PAGE5">5</DIV>	
	<DIV CLASS="PAGE" ID="PAGE6">6</DIV>	

	<DIV CLASS="PAGE" ID="PAGE7">
     
		<SPAN CLASS="SUBHEADER">Guiden gennemført</SPAN><BR>

		<p>
		Guiden er nu gennemført, tryk på "Luk".
		</P>

	</DIV>



	<DIV CLASS="FOOTER" align="right">
		<BUTTON ID="BUTTONCANCEL">Annuller</BUTTON>
		<BUTTON ID="BUTTONPREV">Forrige</BUTTON>
		<BUTTON ID="BUTTONNEXT"">Næste</BUTTON>
		<BUTTON ID="BUTTONSTART">Start</BUTTON>
		<BUTTON ID="BUTTONCLOSEW">Luk</BUTTON>
	</DIV>

    </form>

  </body>
</html>

<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
