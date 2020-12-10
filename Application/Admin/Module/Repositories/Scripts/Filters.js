angular.module('ng').filter('timespan', function() {
    return function(input, hoursText, minutesText, secondsText) {
        if (!input)
            return '';

        var indexOfTicks = input.indexOf(".");
        if (indexOfTicks > -1)
            input = input.substring(0, indexOfTicks);

        var elements = input.split(":");
        if (elements.length != 3)
            return input;

        return (elements[0] != '00' ? elements[0] + ' ' + hoursText +  ' ' : '') + (elements[1] != '00' ? elements[1] +  ' ' + minutesText +  ' ' : '') + elements[2] +  ' ' + secondsText;
    };
});