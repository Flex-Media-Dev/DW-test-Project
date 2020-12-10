function replaceSubstring(inputString, fromString, toString) {
	var temp = inputString;
   	if (fromString == "") {
		return inputString;
   	}
   	
   	fromString = ""+ fromString;
   	toString = ""+ toString;
   	
 	if (toString.indexOf(fromString) == -1) {
    	while (temp.indexOf(fromString) != -1) {
        	var toTheLeft = temp.substring(0, temp.indexOf(fromString));
        	var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
        	temp = toTheLeft + toString + toTheRight;
      	}
   	} else { 
    	var midStrings = new Array("~", "`", "_", "^", "#");
      	var midStringLen = 1;
      	var midString = "";
	
		while (midString == "") {
        	for (var i=0; i < midStrings.length; i++) {
        		var tempMidString = "";
        		for (var j=0; j < midStringLen; j++) { tempMidString += midStrings[i]; }
        		if (fromString.indexOf(tempMidString) == -1) {
			    	midString = tempMidString;
              		i = midStrings.length + 1;
		        }
         	}
		} 
	
		while (temp.indexOf(fromString) != -1) {
        	var toTheLeft = temp.substring(0, temp.indexOf(fromString));
		   	var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
        	temp = toTheLeft + midString + toTheRight;
		}

		while (temp.indexOf(midString) != -1) {
        	var toTheLeft = temp.substring(0, temp.indexOf(midString));
        	var toTheRight = temp.substring(temp.indexOf(midString)+midString.length, temp.length);
	       	temp = toTheLeft + toString + toTheRight;
      	}
   	}
   	return temp;
}