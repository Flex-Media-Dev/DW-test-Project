(function () {
    // GeoLocation stuff
    var formatDouble = function (value) {
        var numberFormat = mapsSettings.numberFormat,
            formatted = value.toFixed(6);

        formatted = formatted
            // Replace point with localized decimal separator
            .replace('.', numberFormat.numberDecimalSeparator);

        return formatted;
    },

        parseDouble = function (value) {
            var d = parseFloat(value);
            return isNaN(d) ? 0 : d;
        },

        // Convert to double from localized string representation
        getDouble = function (value) {
            var numberFormat = mapsSettings.numberFormat;

            value = value
                // Remove all group separators
                .replace(numberFormat.numberGroupSeparator, '')
                // Replace decimal separator with point
                .replace(numberFormat.numberDecimalSeparator, '.');

            return parseDouble(value);
        },

        translate = function (text, values) {
            var msg = mapsSettings.messages[text] ? mapsSettings.messages[text] : text,
                template = new Template(msg);

            return template.evaluate(values);
        },

        update = function (dontRestoreValue) {
            var element = $('GeoLocationIsCustom');
            if (element) {
                if (element.checked) {
                    setReadOnly(['GeoLocationLat', 'GeoLocationLng'], false);
                } else {
                    if (!dontRestoreValue) {
                        // Reset values
                        restoreValue(['GeoLocationLat', 'GeoLocationLng']);
                    }
                    setReadOnly(['GeoLocationLat', 'GeoLocationLng'], true);
                }
            }
        },

        setReadOnly = function (elements, readOnly) {
            if (!Object.isArray(elements)) {
                elements = [elements];
            }
            elements.each(function (el) {
                if (readOnly) {
                    $(el).setAttribute('readonly', 'readonly');
                } else {
                    $(el).removeAttribute('readonly');
                }
            });
        },

        storeValue = function (elements) {
            // Store values for later use
            if (!Object.isArray(elements)) {
                elements = [elements];
            }
            elements.each(function (el) {
                if ($(el)) {
                    $(el).setAttribute('data-value', Form.Element.getValue(el));
                }
            });
        },

        restoreValue = function (elements) {
            if (!Object.isArray(elements)) {
                elements = [elements];
            }
            elements.each(function (el) {
                Form.Element.setValue(el, $(el).getAttribute('data-value'));
            });
        },

        showLocationOnMap = function () {
            var name, value,
                map = mapsSettings.fieldMap,
                url = '/Admin/Module/Maps/ShowOnMap.aspx?action=show&zoom=8';

            for (name in map) if (map.hasOwnProperty(name)) {
                if ($(map[name])) {
                    value = Form.Element.getValue(map[name]);
                    if ((name == 'lat') || (name == 'lng')) {
                        value = getDouble(value);
                    }
                    url += '&' + name + '=' + encodeURIComponent(value);
                }
            }

            if ($('GeoLocationIsCustom').checked) {
                url += '&editable=true';
            }

            (function () {
                var width = screen.width / 2,
                    height = screen.height / 2,
                    left = screen.width / 4,
                    top = screen.height / 4;

                open(url, 'geolocation', 'left=' + left +
                    ", top=" + top +
                    ", screenX=" + left +
                    ", screenY=" + top +
                    ", width=" + width +
                    ", height=" + height +
                    ", resizable=yes" +
                    ", scrollbars=yes");
            }());
        },

        setGeoLocation = function (info, fromAPI) {
            var lat = parseDouble(info.lat),
                lng = parseDouble(info.lng);
            setReadOnly(['GeoLocationLat', 'GeoLocationLng'], false);
            Form.Element.setValue('GeoLocationLat', formatDouble(lat));
            Form.Element.setValue('GeoLocationLng', formatDouble(lng));
            $('GeoLocationIsCustom').checked = !fromAPI;
            update(true);
        },

        getLocationFromAPI = function () {
            var url = '/Admin/Module/Maps/ShowOnMap.aspx?action=get',
                map = mapsSettings.fieldMap,
                address = ['address', 'address2', 'zip', 'city', 'state', 'country'].map(function (key) {
                    return Form.Element.getValue(map[key]);
                }).join(' ');

            url += '&address=' + encodeURIComponent(address);

            var repeatCounter = 0;
            var it = setInterval(function () {                
                new Ajax.Request(url, {
                    method: 'get',
                    asynchronous: false,
                    onSuccess: function (transport) {
                        var json = transport.responseJSON;
                        if (json) {
                            if ((json.status == 'OK') && (json.results.length > 0)) {
                                clearInterval(it);
                                var location = json.results[0].geometry.location;
                                setGeoLocation({
                                    lat: location.lat,
                                    lng: location.lng
                                }, true);
                                return;
                            } else if (json.status == 'OVER_QUERY_LIMIT') {                                
                                repeatCounter += 1;                                                                
                                if (repeatCounter <= 5) {
                                    return;
                                }
                            }
                        }                        
                        clearInterval(it);
                        alert(translate('Unable to get location for address "#{address}"', { address: address }));
                    },
                    onFailure: function () {
                        clearInterval(it);
                    }
                });
            }, 2000)
        }

    // Expose for use in popup
    window.setGeoLocation = setGeoLocation;

    window.mapsSettings = {
        numberFormat: {
            numberDecimalSeparator: '.',
            numberGroupSeparator: ','
        },

        messages: {
            'Unable to get location for address "#{address}"': 'Unable to get location for address "#{address}"'
        },

        fieldMap: {
            // name: element id
            'lat': 'GeoLocationLat',
            'lng': 'GeoLocationLng',
            'name': 'Name',
            'address': 'Address',
            'address2': 'Address2',
            'zip': 'Zip',
            'city': 'City',
            'state': 'State',
            'country': 'Country'
        }
    };

    if ($('GeoLocationShowOnMap')) {
        $('GeoLocationShowOnMap').observe('click', showLocationOnMap);
    }
    if ($('GeoLocationGetFromAPI')) {
        $('GeoLocationGetFromAPI').observe('click', getLocationFromAPI);
    }

    storeValue(['GeoLocationLat', 'GeoLocationLng']);
    if ($('GeoLocationIsCustom')) {
        $('GeoLocationIsCustom').observe('change', function () { update(); });
    }
    update();
}())
