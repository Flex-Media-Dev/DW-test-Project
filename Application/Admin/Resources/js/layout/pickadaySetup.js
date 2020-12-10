/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.UIControls) == 'undefined') {
    Dynamicweb.UIControls = new Object();
}
/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.UIControls.DatePicker = function () {
    this.dict = {};
    this.defaultDates = {};
    this.names = [];
    var datepicker = this;
    function SetupPikaTime() {
        var wrapper = document.getElementById("pika-wrapper");
        var timeWrapper = document.getElementById("pika-wrapper-time");
        var pikaHour = document.getElementById("pika-hour");
        var pikaMinute = document.getElementById("pika-minute");
        var pikaTimeCurrentName = document.getElementById("pika-time-currentName");

        //Update time of the calendar-control
        function pikaUpdateTime() {
            var currentName = pikaTimeCurrentName.value;
            if (currentName !== "" && typeof (currentName) !== 'undefined') {
                var hours = parseInt(pikaHour.value);
                var minutes = parseInt(pikaMinute.value);
                if (!isNaN(hours) && !isNaN(minutes)) {
                    var currentDate = datepicker.GetDate(currentName);
                    if (currentDate === null) {
                        currentDate = new Date();
                    }
                    currentDate.setMinutes(minutes);
                    currentDate.setHours(hours);
                    var picker = datepicker.dict[currentName];
                    datepicker.UpdateCalenderDateFields(picker, currentDate, currentName);
                }
            }
        }
        //OnChange event
        function setupOnTimeChange(element) {
            element.onchange = function () {
                if (element.value === "") {
                    element.value = 0;
                }
                pikaUpdateTime();
            }
        }
        setupOnTimeChange(pikaHour);
        setupOnTimeChange(pikaMinute);

        //KeyUp / KeyDown events
        function SetupEventListeners(inputField, callback) {
            var currentValue;
            inputField.onkeydown = function () {
                currentValue = inputField.value;
            }
            inputField.onkeyup = function () {
                if (inputField.value !== currentValue) {
                    callback();
                }
            }
            inputField.onpaste = function () {
                callback();
            }
        }
        SetupEventListeners(pikaHour, pikaUpdateTime);
        SetupEventListeners(pikaMinute, pikaUpdateTime);

        //Click outside the div -> close
        window.onclick = function (e) {
            pikaAddClass(timeWrapper, "is-hidden");
            pikaTimeCurrentName.value = "";
        };
        //stop closure of div, if the div is the target
        timeWrapper.onclick = function (event) {
            event.stopPropagation();
        };
    }
    SetupPikaTime();
}

Dynamicweb.UIControls.DatePicker._instance = null;

Dynamicweb.UIControls.DatePicker.get_current = function () {
    if (!Dynamicweb.UIControls.DatePicker._instance) {
        Dynamicweb.UIControls.DatePicker._instance = new Dynamicweb.UIControls.DatePicker();        
    }
    return Dynamicweb.UIControls.DatePicker._instance;
}

Dynamicweb.UIControls.DatePicker.prototype.initPickaday = function (name, startYear, endYear, strCurrentDate, weekDaysArr, monthsArr) {
    var currentDate;
    var hiddenDateElement = document.getElementById(name + "_datepicker");
    if (hiddenDateElement.value !== "") {
        currentDate = new Date(hiddenDateElement.value);
    } else if (strCurrentDate === "") {
        currentDate = new Data();
    } else {
        currentDate = new Date(strCurrentDate);
    }
    if (currentDate.getFullYear() === 2999) {
        currentDate = new Date();
    }    
    if (typeof getMonthNames !== "undefined") {
        monthsArr = getMonthNames();
    }
    if (typeof getDayNames !== "undefined") {
        weekDaysArr = getDayNames();
    }
    var datepickerControl = this;
    var picker = new Pikaday(
    {
        field: hiddenDateElement,
        firstDay: 1,
        defaultDate: currentDate,
        setDefaultDate: true,
        minDate: new Date(startYear, 0, 1),
        maxDate: new Date(endYear, 11, 31),
        showWeekNumber: true,
        onSelect: function (date) {
            datepickerControl.UpdateCalenderDateFields(picker, date, name);
            picker.hide();
        },
        yearRange: [startYear, endYear],
        i18n: {
            previousMonth: '<i class="md md-keyboard-arrow-left pika-prev"></i>',
            nextMonth: '<i class="md md-keyboard-arrow-right pika-next"></i>',
            months: monthsArr,
            weekdays: weekDaysArr,
            weekdaysShort: getDayNamesShort(weekDaysArr),
        },
        /*remove this to show datepicker on input-click*/
        container: document.getElementById('container'),
        bound: false,
        trigger: document.getElementById(name + "_calendar_btn")
    });
    this.SetupCalendarHead(picker);
    function getDayNamesShort(days) {
        var daysShort = [];
        for (var i = 0; i < days.length; i++) {
            daysShort.push(days[i].substring(0, 1));
        }
        return daysShort;
    }
    return picker;
}

Dynamicweb.UIControls.DatePicker.prototype.IsNotSet = function (prefix) {
    var fNotSet = document.getElementById(prefix + '_notSet');
    if (fNotSet) {
        return fNotSet.value.toLowerCase() === 'true';
    }
    return false;
}

Dynamicweb.UIControls.DatePicker.prototype.GetDate = function (name) {
    if (this.IsNotSet(name)) return null;
    var hiddenDateElement = document.getElementById(name + "_calendar");
    if (hiddenDateElement.value === "") return null;
    var currentDate = new Date(hiddenDateElement.value);
    return currentDate;
}

Dynamicweb.UIControls.DatePicker.prototype.SetDate = function (name, date, preventOnSelect) {
    if(typeof date === 'undefined' || date === null){
        this.ClearDate(name);
        return;
    }
    var picker = this.dict[name];
    var currentDate = picker.getDate();
    if (currentDate.getFullYear() !== date.getFullYear() || currentDate.getMonth() !== date.getMonth() || currentDate.getDate() !== date.getDate() || currentDate.getHours() !== date.getHours() || currentDate.getMinutes() !== date.getMinutes()) {
        picker.setDate(date, preventOnSelect);
    }

    var postbackDate = document.getElementById("DatePicker_" + name);
    var hiddenDateElement = document.getElementById(name + "_calendar");
    var dateString = "";
    if (date !== null) {
        var strMinutes = date.getMinutes() < 9 ? "0" + date.getMinutes() : date.getMinutes();
        var strHours = date.getHours() < 9 ? "0" + date.getHours() : date.getHours();
        var strDate = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
        dateString = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + strDate + " " + strHours + ":" + strMinutes; ///yyyy-MM-dd HH:mm
    }
    var isChanged = false;
    if (hiddenDateElement.value != dateString) {
        isChanged = true;
    }
    hiddenDateElement.value = dateString;
    var fNotSet = document.getElementById(name + '_notSet');
    if (fNotSet != null) {
        fNotSet.value = "False";
    }
    if (isChanged) {
        var labelButton = document.getElementById(name + "_label");
        if (labelButton != null && labelButton.onchange != null) {
            labelButton.onchange();
        }
    }
}

Dynamicweb.UIControls.DatePicker.prototype.ClearDate = function (prefix) {
    var fLabel = document.getElementById(prefix + '_label');
    var fNotSet = document.getElementById(prefix + '_notSet');
    if (fNotSet) {
        var picker = this.dict[prefix];
        if (typeof picker !== 'undefined') {
            picker.setDate(new Date());
        }
        var resetDate = null;
        if (this.defaultDates[prefix] !== "")
            resetDate = new Date(this.defaultDates[prefix]);
        this.SetDate(prefix, resetDate);
        if (fLabel) fLabel.innerHTML = document.getElementById('DWCalendarNotSetString').value;
        fNotSet.value = 'True';
    }
}

Dynamicweb.UIControls.DatePicker.prototype.UpdateCalendarDate = function (date, name) {
    if (date.getFullYear() === 2999) {
        this.ClearDate(name);
    } else {
        var picker = this.dict[name];
        this.UpdateCalenderDateFields(picker, date, name);
    }
}

Dynamicweb.UIControls.DatePicker.prototype.UpdateCalenderDateFields = function (picker, date, name) {
    var target = document.getElementById(name + "_label");
    var dayName = picker.options.i18n.weekdays[date.getDay()].substring(0, 3); //Fri etc.
    var monthName = picker.options.i18n.months[date.getMonth()].substring(0, 3); //Jun etc
    var dateNumber = date.getDate();
    var strMinutes = date.getMinutes() < 9 ? "0" + date.getMinutes() : date.getMinutes();
    var strHours = date.getHours() < 9 ? "0" + date.getHours() : date.getHours();
    var btnTime = document.getElementById(name + "_calendar_time_btn");
    var useTime = btnTime !== null;
    var strDate = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
    var dateStr = dayName + ", " + strDate + " " + monthName + " " + date.getFullYear();//Wed, 13 Jan 2016 00:00
    if (useTime) {
        dateStr = dateStr + " " + strHours + ":" + strMinutes; //Wed, 13 Jan 2016 00:00
    }
    target.innerText = dateStr;

    this.SetDate(name, date, true);
}

Dynamicweb.UIControls.DatePicker.prototype.SetupCalendarHead = function (picker) {
    var date = picker.getDate();    
    var fullYear = date.getFullYear();
    var monthName = picker.options.i18n.months[date.getMonth()].substring(0, 3);
    var dayName = picker.options.i18n.weekdays[date.getDay()].substring(0, 3);    
    document.getElementById("datepicker-year").innerText = fullYear;
    document.getElementById("datepicker-date").innerText = dayName + ", " + monthName + " " + date.getDate();
}

//legacy-support
function DWClearDate(prefix) {
    // Set 'not set' value
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    datepicker.ClearDate(prefix);
}

function SetupCalendarOnfocus(name, startYear, endYear, strCurrentDate, defaultDateStr, weekDays, months) {
    var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
    datepicker.defaultDates[name] = defaultDateStr;
    datepicker.names.push(name);    
    if (typeof datepicker.dict[name] === 'undefined') {
        var picker = datepicker.initPickaday(name, startYear, endYear, strCurrentDate, weekDays, months);
        datepicker.dict[name] = picker;
    }
    if (name === "ValidFrom_Editor"){
        var t = datepicker.dict["ValidFrom_Editor"];
        console.log(t.getDate());
    }
    var pikaTimeCurrentName = document.getElementById("pika-time-currentName");
    var button = document.getElementById(name + "_calendar_btn");
    var labelButton = document.getElementById(name + "_label"); 

    button.onclick = labelButton.onclick = function (event) {
        var timeWrapper = document.getElementById("pika-wrapper-time");
        pikaAddClass(timeWrapper, "is-hidden");
        pikaTimeCurrentName.value = "";
        for (var i = 0; i < datepicker.names.length; i++) {
            var fetchedName = datepicker.names[i];
            var current = datepicker.dict[fetchedName];
            if (typeof current !== 'undefined') {
                current.hide();
            }
        }        
        datepicker.SetupCalendarHead(datepicker.dict[name]);
        datepicker.dict[name].show();
        event.stopPropagation();
        event.preventDefault();
    };

    var buttonTime = document.getElementById(name + "_calendar_time_btn");

    //UI button
    if (buttonTime !== null) {
        buttonTime.onclick = function (event) {
            for (var i = 0; i < datepicker.names.length; i++) {
                datepicker.dict[datepicker.names[i]].hide();
            }
            var timeWrapper = document.getElementById("pika-wrapper-time");
            pikaRemoveClass(timeWrapper, "is-hidden");
            var pikaTimeCurrentName = document.getElementById("pika-time-currentName");
            var pikaHour = document.getElementById("pika-hour");
            var pikaMinute = document.getElementById("pika-minute");
            adjustElementToOtherElement(timeWrapper, this);
            var picker = datepicker.dict[name];
            pikaTimeCurrentName.value = name;
            var currentDate = datepicker.GetDate(name);
            if (currentDate === null) {
                pikaHour.value = 0;
                pikaMinute.value = 0;
            } else {
                pikaHour.value = currentDate.getHours();
                pikaMinute.value = currentDate.getMinutes();
            }
            event.stopPropagation();
        };
    }
}