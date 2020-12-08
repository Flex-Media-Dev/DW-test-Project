
function dateSelectorUpdateDate(container) {

    // get select-instances
    var selector_day = document.getElementById(container + '_day');
    var selector_month = document.getElementById(container + '_month');
    var selector_year = document.getElementById(container + '_year');
    var selector_hour = document.getElementById(container + '_hour');
    var selector_minute = document.getElementById(container + '_minute');
    var objContainer = document.getElementById(container);

    // get hidden field values we need for calculation
    var selMonth = selector_month.options[selector_month.selectedIndex].value;
    var selYear = selector_year.options[selector_year.selectedIndex].value;

    // disable days that arent valid this month
    disableInvalidDays(selector_day, selMonth, selYear);
    
    // get hidden field value we are missing
    var selDay = selector_day.options[selector_day.selectedIndex].value;
    var selHour = selector_hour.options[selector_hour.selectedIndex].value;
    var selMinute = selector_minute.options[selector_minute.selectedIndex].value;
        
    // set hidden field value
    var selDate = selDay + '-' + selMonth + '-' + selYear + ' ' + selHour + ':' + selMinute + ':00';
    objContainer.value = selDate;
}
function noclick(e) {
	if (e.options[e.selectedIndex].disabled) {
		e.selectedIndex = window.select_current[e.id];
	}
}
function disableInvalidDays(e, month, year) {
	/* get max days */	
	var maxdays = 31;
	if(month == 2 && year % 4 == 0) {
	    maxdays = 29;
	}
	else if(month == 2) {
	    maxdays = 28;
	}
	else if(month == 4 || month == 6 || month == 9 || month == 11) {
	    maxdays = 30;
	}	
	
	resetDayOptions(e, maxdays, getSelectedDay(e));
}

function getSelectedDay(e) {
	for (var i=0, option; option = e.options[i]; i++) {
	    if (option.selected) {
	        return option.value;
	    }
	}
	return 1;
}

function resetDayOptions(e, maxdays, selectedday) {    
    if(maxdays < selectedday) {
        selectedday = maxdays;
    }
    
    removeAllDayOptions(e);
    
    for(var i = 1; i <= maxdays; i++) {
        if(i < 10) {
            addDayOption(e, '0'+i, '0'+i);
        }
        else {
            addDayOption(e, i, i);
        }
    }
    
    reselectItems(e, selectedday);
}

function addDayOption(selectObject,optionText,optionValue) {
    var len = selectObject.length++;
	selectObject.options[len].value = optionValue;
	selectObject.options[len].text = optionText;
	selectObject.selectedIndex = len; 
}

function hasDayOptions(obj) {
	if (obj!=null && obj.options!=null) {
		return true;
	}
	return false;
}
		
function reselectItems(selectObject, selectedValue) {
	for (var i = 0;i < selectObject.length;i++) {
	    if(selectObject.options[i].value == selectedValue) {
		    selectObject.options[i].selected = true;
		    selectObject.selectedIndex = i;
		    break;
		}
	}
}

function removeAllDayOptions(selectObject) {
	if (!hasDayOptions(selectObject)) {
		return;
	}
	
	for (var i=(selectObject.options.length-1); i>=0; i--) {
		var info = selectObject.options[i].value;
		selectObject.options[i] = null;
	}
	selectObject.selectedIndex = 0;
}