	  /*
	   * "Javascript Form Validation"
	   * Handles basic validation process for a form
	   *
	   * 2007-03-05 [eal] cleaning up the code.
	   * 2007-03-01 [eal] adding datavalidation.
	   * 2007-02-20 [eal] created script.
	   *
	   * Usage:
	   * 
	   */
    
      /* attribute types */
      function addMinLengthRestriction(elementid, length, errormsg) { addValidationAttr(elementid, 'minlength', length); if(errormsg != null) { addValidationAttr(elementid, 'msgminlength', errormsg); } }
      function addMaxLengthRestriction(elementid, length, errormsg) { addValidationAttr(elementid, 'maxlength', length); if(errormsg != null) { addValidationAttr(elementid, 'msgmaxlength', errormsg); } }
      function addMinValueRestriction(elementid, min, errormsg) { addValidationAttr(elementid, 'minvalue', min); if(errormsg != null) { addValidationAttr(elementid, 'msgminvalue', errormsg); } }
      function addMaxValueRestriction(elementid, max, errormsg) { addValidationAttr(elementid, 'maxvalue', max); if(errormsg != null) { addValidationAttr(elementid, 'msgmaxvalue', errormsg); } }
      function addRegExRestriction(elementid, regex, errormsg) { addValidationAttr(elementid, 'regex', regex); if(errormsg != null) { addValidationAttr(elementid, 'msgregex', errormsg); } }
      function addRegExNoMatchRestriction(elementid, regex, errormsg) { addValidationAttr(elementid, 'notregex', regex); if (errormsg != null) { addValidationAttr(elementid, 'msgnotregex', errormsg); } }
      function addMinMaxValueRestriction(elementid, min, max, errormsg) { addMinValueRestriction(elementid, min, errormsg); addMaxValueRestriction(elementid, max, errormsg); }
      function addNumericRestriction(elementid, errormsg) { addRegExRestriction(elementid, '^[-+]?[\\d,.]+$', errormsg); }
      function addPercentRestriction(elementid, min, max, errormsg) { addNumericRestriction(elementid, errormsg); addMinMaxValueRestriction(elementid, min, max, errormsg); }
      function addEmailRestriction(elementid, errormsg) { }
      function addValueLargerThanRestriction(elementid, value, errormsg) { addValidationAttr(elementid, 'largerthan', value); if (errormsg != null) { addValidationAttr(elementid, 'msgvaluelargerthan', errormsg); } }
      function addValueLesserThanRestriction(elementid, value, errormsg) { addValidationAttr(elementid, 'lesserthan', value); if (errormsg != null) { addValidationAttr(elementid, 'msgvaluelesserthan', errormsg); } }
      function addValueNonNegativeOrZeroRestriction(elementid, errormsg) { addRegExRestriction(elementid, '^(0(\\.|,)0*[1-9]+0*)|([1-9]+(\\.|,)?\\d*)$', errormsg); }
      
      /* attribute managing */
      function addValidationAttr(elementid, attrname, value) {
        var element = document.getElementById(elementid);
        if(element != null) {
          addAttr(element, 'val' + attrname, value);
        }
      }
      function addAttr(element, attrname, value) {
        element.setAttribute(attrname, value);
      }
      function getValidationAttr(elementid, attrname) {
        var element = document.getElementById(elementid);
        if(element != null) {
          getAttr(element, 'val' + attrname);
        }
      }
      function getValidationAttrForElement(element, attrname) {
        if(element != null) {
          return getAttr(element, 'val' + attrname);
        }
      }
      function getAttr(element, attrname) {
        if(element != null) {
          return element.getAttribute(attrname);
        }
      }
      
      /* events */
      function addOnchangeEvent(elementid, value) {
      }
      
      /* validation process */
      function doInputValidationById(elementid) {
        var element = document.getElementById(elementid);
        doInputValidation(element, false);
      }
      function doSelectValidation(element, doloop) {
        return doInputValidation(element, doloop);
      }
      function doInputValidation(element, doloop) {
        if(element != null) {
          var isvalidated = true;
        
          // take all previous errors
          removeErrors(element);
            
		  // regex?
	      var regexvalue = getValidationAttrForElement(element, 'regex');
		  if(isvalidated == true && regexvalue != null) {
		    var rx = new RegExp(regexvalue);
            if (!element.value.match(rx)) {
		      var regexmsg = getValidationAttrForElement(element, 'msgregex');
		      addError(element, regexmsg);
		      isvalidated = false;
            }
		  }

		  // not regex?
		  var regexvalue = getValidationAttrForElement(element, 'notregex');
		  if (isvalidated == true && regexvalue != null) {
		      var rx = new RegExp(regexvalue);
		      if (element.value.match(rx)) {
		          var regexmsg = getValidationAttrForElement(element, 'msgnotregex');
		          addError(element, regexmsg);
		          isvalidated = false;
		      }
		  }

		  // long enough?
	      var minlengthvalue = getValidationAttrForElement(element, 'minlength');
		  if(isvalidated == true && minlengthvalue != null && element.value.length < minlengthvalue) {
		    var minlengthmsg = getValidationAttrForElement(element, 'msgminlength');
		    addError(element, minlengthmsg);
		    isvalidated = false;
		  }
            
		  // too long?
	      var maxlengthvalue = getValidationAttrForElement(element, 'maxlength');
		  if(isvalidated == true && maxlengthvalue != null && element.value.length > maxlengthvalue) {
		    var maxlengthmsg = getValidationAttrForElement(element, 'msgmaxlength');
		    addError(element, maxlengthmsg);
		    isvalidated = false;
		  }
            
		  // min value
	      var minvaluevalue = getValidationAttrForElement(element, 'minvalue');
		  if(isvalidated == true && minvaluevalue != null && (parseInt(element.value) < minvaluevalue || parseInt(element.value) == 'NaN')) {
		    var minvaluemsg = getValidationAttrForElement(element, 'msgminvalue');
		    addError(element, minvaluemsg);
		    isvalidated = false;
		  }
            
		  // max value?
	      var maxvaluevalue = getValidationAttrForElement(element, 'maxvalue');
		  if(isvalidated == true && maxvaluevalue != null && (parseInt(element.value) > maxvaluevalue || parseInt(element.value) == 'NaN')) {
		    var maxvaluemsg = getValidationAttrForElement(element, 'msgmaxvalue');
		    addError(element, maxvaluemsg);
		    isvalidated = false;
		  }

		  // value larger than?
		  var valuelargerthan = getValidationAttrForElement(element, 'largerthan');
		  if (isvalidated == true && valuelargerthan != null && (parseFloat(element.value) <= valuelargerthan || parseFloat(element.value) == 'NaN')) {
		      var msg = getValidationAttrForElement(element, 'msgvaluelargerthan');
		      addError(element, msg);
		      isvalidated = false;
		  }

		  // value lesser than?
		  var valuelesserthan = getValidationAttrForElement(element, 'lesserthan');
		  if (isvalidated == true && valuelesserthan != null && (parseFloat(element.value) >= valuelesserthan || parseFloat(element.value) == 'NaN')) {
		      var msg = getValidationAttrForElement(element, 'msgvaluelesserthan');
		      addError(element, msg);
		      isvalidated = false;
		  }

		  // check if all errors are gone.
		  if(doloop == true) {
		    //
		    var parentform = getParentFormElement(element);
		    //
		    if(parentform != null) {
		      doSubmitValidation(parentform.name);
		    }
		  }
		  else {
		    return isvalidated;
		  }
        }
        else {
          return true;
        }
      }
      
      function addError(element, errorstring) {
		// get err element
		var errelement = document.getElementById('err' + element.id);
		if(errelement != null) {
		    errelement.innerHTML = errorstring;
		    errelement.style.display = "block";
		}
        // get help element
		var helpElement = document.getElementById('help' + element.id);
		if (helpElement != null) {
		    helpElement.innerHTML = errorstring;
		}
      }
      function addErrorElement(element) {
		// get err element
		var errelement = document.getElementById('err' + element.id);
		if(errelement == null) {
		  errelement = document.createElement('font');
		  addAttr(errelement, 'id', 'err' + element.id);
		  addAttr(errelement, 'color', 'red');
		  element.outerHTML += errelement.outerHTML;
		}
      }
      function removeErrors(element) {
        if(element != null) {
          var errelement = document.getElementById('err' + element.id);
          if(errelement != null) {
              errelement.innerHTML = '';
              errelement.style.display = "none";
          }
        }
      }
      
      function doSubmitValidation(formname) {
	    var formelement = getFormElementByName(formname);
	    if(formelement != null) {
          var submitbutton = getFormSubmit(formelement);
          
          if(submitbutton != null) {
          }	      
	    }
      }
      
      function doFormValidation(formelement) {
        var isvalidated = true;
        if(formelement != null) {
          /* input elements */
	      var inputs = formelement.getElementsByTagName('input');
	      for(var i = 0; i < inputs.length; i++) {
	        if(inputs[i].id != null && inputs[i].id.length > 0) {
	          var result = doInputValidation(inputs[i]);
	          if(result == false) {
	            isvalidated = result;
	          }
	        }
	      }
          /* select elements */
	      var selects = formelement.getElementsByTagName('select');
	      for(var i = 0; i < selects.length; i++) {
	        if(selects[i].id != null && selects[i].id.length > 0) {
	          var result = doSelectValidation(selects[i]);
	          if(result == false) {
	            isvalidated = result;
	          }
	        }
	      }
	    }
	    return isvalidated;
      }
      
      /* init process */
      function activateValidation(formname) {
        doSubmitValidation(formname);
      }
      function getFormElementByName(formname) {
        // we need a form to have fun with
	    var formelement;
        if(formname != null) {
          for(var i = 0; i < document.forms.length; i++) {
	        if(document.forms[i].name == formname || document.forms[i].id == formname) {
	          formelement = document.forms[i];
	          break;
	        }
          }
        }
        else {
		  formelement = document.forms[0];
        }
        return formelement;
      }
      function getParentFormElement(element) {
	    var parent = element.parentNode;
	    
	    while(parent.nodeName != "#document") {
	      if(parent.nodeName == 'FORM') {
	        return parent;
	      }
	      parent = parent.parentNode;
	    }
	    
	    return null;
      }
      function getFormSubmit(formelement) {
	      // lets find the submit button!
	      var inputs = formelement.getElementsByTagName('input');
	      var submitbutton;
	      for(var i = 0; i < inputs.length; i++) {
		    if(inputs[i].type == 'submit') {
		      submitbutton = inputs[i];
		      break;
		    }
	      }
	      return submitbutton;
      }
      function doSubmit(button) {
        var parentform = getParentFormElement(button);
        if(parentform != null) {
          var validated = doFormValidation(parentform);
          if(validated == true) {
            /*parentform.submit();*/
            return true;
          }
          else {
            /*alert('false');*/
            return false;
          }
        }
      }
      
      var _emptyTags = {
        "IMG":   true,
        "BR":    true,
        "INPUT": true,
        "META":  true,
        "LINK":  true,
        "PARAM": true,
        "HR":    true
      };

      if (typeof HTMLElement != 'undefined' && HTMLElement.prototype.__defineGetter__) {
          HTMLElement.prototype.__defineGetter__("outerHTML", function () {
              var attrs = this.attributes;
              var str = "<" + this.tagName;
              for (var i = 0; i < attrs.length; i++) {
                  str += " " + attrs[i].name + "=\"" + attrs[i].value + "\"";
              }

              if (_emptyTags[this.tagName]) {
                  return str + ">";
              }

              return str + ">" + this.innerHTML + "</" + this.tagName + ">";
          });
      
        HTMLElement.prototype.__defineSetter__("outerHTML", function (sHTML) {
          var r = this.ownerDocument.createRange();
          r.setStartBefore(this);
          var df = r.createContextualFragment(sHTML);
          this.parentNode.replaceChild(df, this);
        });
}