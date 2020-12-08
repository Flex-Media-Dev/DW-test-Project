
function ValidateColor(obj, col){
	if ((col.charAt(0)=="#") && (col.charAt(1)<="f") && (col.charAt(2)<="f") && (col.charAt(3)<="f") && (col.charAt(4)<="f") && (col.charAt(5)<="f") && (col.charAt(6)<="f") && (col.length==7)){
		document.all[obj].style.backgroundColor=col;
	}
}

function ColorPicker(exColor, fieldName, objForm){
	colorWin = window.open("/admin/" + "Stylesheet/colorpicker.aspx?fieldname=" + fieldName + "&formname=" + objForm.id, "", "resizable=no,scrollbars=auto,toolbar=no,location=no,directories=no,status=no,width=320,height=360");
}
var sInitColor;
function callColorDlg(sColorType, fieldName, websafe) { 
    var sInitColorObj = document.getElementById(fieldName+'Preview');
    sInitColor = sInitColorObj.style.backgroundColor;
	//sInitColor = document.all[fieldName+'Preview'].style.backgroundColor;
		
	//document.all.dlgHelper.ChooseColorDlg()
	if (sInitColor == null) {
		var sColor = document.all.dlgHelper.ChooseColorDlg(); 
		//var sColor = document.getElementById('dlgHelper').ChooseColorDlg();
		//var sColor = document.getElementById('dlgEditorHelper').ChooseColorDlg();
	} else {
		var sColor = document.all.dlgHelper.ChooseColorDlg(sInitColor); 
		//var sColor = document.getElementById('dlgHelper').ChooseColorDlg(sInitColor);
		//var sColor = document.getElementById('dlgEditorHelper').ChooseColorDlg();
	}
		
	//change decimal to hex 
	sColor = sColor.toString(16); 
	
	//add extra zeroes if hex number is less than 6 digits 
	if (sColor.length < 6) { 
		var sTempString = "000000".substring(0,6-sColor.length); 
		sColor = sTempString.concat(sColor); 
	}
		 
	if(websafe == 'True') {
		sColor = '#' + compareToWEB(sColor.toString(16).toUpperCase());
	} else {
		sColor = '#' + sColor.toString(16).toUpperCase()
	}
	document.all[fieldName+'Preview'].style.backgroundColor=sColor;
	document.all[fieldName].value = sColor.toString(16)
	sInitColor = sColor; 

}

var alphaStr = "0123456789ABCDEF";
var alphaArr = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];

var RGB = [170,170,170];
var range = 0;
var phase = 0;
var sat = 0;
var val = 170 / 255;

function compareToWEB(strColor) {
	a = GiveDec(strColor.substring(0, 1));
   	b = GiveDec(strColor.substring(1, 2));
   	c = GiveDec(strColor.substring(2, 3));
   	d = GiveDec(strColor.substring(3, 4));
   	e = GiveDec(strColor.substring(4, 5));
   	f = GiveDec(strColor.substring(5, 6));

   	x = (a * 16) + b;
   	y = (c * 16) + d;
   	z = (e * 16) + f;
   
	var wr = DEC_to_HEX(DEC_to_WEB(x));
	var wg = DEC_to_HEX(DEC_to_WEB(y));
	var wb = DEC_to_HEX(DEC_to_WEB(z));
	var wh = wr + wg + wb;
	return wh
	}

function GiveDec(Hex)
{
   if(Hex == "A")
      Value = 10;
   else
   if(Hex == "B")
      Value = 11;
   else
   if(Hex == "C")
      Value = 12;
   else
   if(Hex == "D")
      Value = 13;
   else
   if(Hex == "E")
      Value = 14;
   else
   if(Hex == "F")
      Value = 15;
   else
      Value = eval(Hex);

   return Value;
}

function GiveHex(Dec)
{
   if(Dec == 10)
      Value = "A";
   else
   if(Dec == 11)
      Value = "B";
   else
   if(Dec == 12)
      Value = "C";
   else
   if(Dec == 13)
      Value = "D";
   else
   if(Dec == 14)
      Value = "E";
   else
   if(Dec == 15)
      Value = "F";
   else
      Value = "" + Dec;

   return Value;
}

function DEC_to_WEB(d)
	{
	d = Math.round(d / 51);
	d *= 51;
	return d;
	}

function DEC_to_HEX(dec)
	{
	var n_ = Math.floor(dec / 16);
	var _n = dec - n_ * 16;
	return alphaArr[n_] + alphaArr[_n];
}
