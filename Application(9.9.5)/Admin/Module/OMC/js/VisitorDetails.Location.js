/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

if (typeof (OMC.VisitorDetails) == 'undefined') {
    OMC.VisitorDetails = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

var _VisitorDetailsLocationMapCallback = function() {
    /// <summary>Occurs when the Google Maps API finished loading.</summary>
    /// <private />

    OMC.VisitorDetails.Location.get_current()._mapCallback();
}

OMC.VisitorDetails.Location = function () {
    /// <summary>Displays location information.</summary>

    this._details = {};
    this._terminology = {};
    this._mapInitialized = false;
    this._mapInitializedCallbacks = [];
}

OMC.VisitorDetails.Location._instance = null;

OMC.VisitorDetails.Location.get_current = function () {
    /// <summary>Gets the current instance of an object.</summary>

    if (!OMC.VisitorDetails.Location._instance) {
        OMC.VisitorDetails.Location._instance = new OMC.VisitorDetails.Location();
    }

    return OMC.VisitorDetails.Location._instance;
}

OMC.VisitorDetails.Location.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

OMC.VisitorDetails.Location.prototype.get_details = function () {
    /// <summary>Gets location details.</summary>

    return this._details;
}

OMC.VisitorDetails.Location.prototype.set_details = function (value) {
    /// <summary>Sets location details.</summary>
    /// <param name="value">Location details.</param>

    this._details = value;
}

OMC.VisitorDetails.Location.prototype.get_mapInitialized = function () {
    /// <summary>Gets value indicating whether map component has been initialized.</summary>

    return this._mapInitialized;
}

OMC.VisitorDetails.Location.prototype.add_mapInitialized = function (callback) {
    /// <summary>Registers a new callback that is executed after map component has been initialized.</summary>
    /// <param value="callback">Callback to register.</param>

    callback = callback || function () { }

    if (this.get_mapInitialized()) {
        callback(this, {});
    } else {
        this._mapInitializedCallbacks[this._mapInitializedCallbacks.length] = callback;
    }
}

OMC.VisitorDetails.Location.prototype.initialize = function () {
    /// <summary>Initializes the component.</summary>

    if (this.get_details() &&
        ((this.get_details().latitude != null && this.get_details().latitude != 0) ||
        (this.get_details().longitude != null && this.get_details().longitude != 0))) {

        this.loadMap({
            marker: {
                latitude: this.get_details().latitude,
                longitude: this.get_details().longitude
            }
        });
    } else {
        this.updateMapState('empty');
    }
}

OMC.VisitorDetails.Location.prototype.loadMap = function (params) {
    /// <summary>Loads the map.</summary>
    /// <param name="params">Load parameters.</param>

    var self = this;
    var script = null;

    if (!params) {
        params = {};
    }

    var componentInitialized = function () {
        var map = null;
        var marker = null;
        var mapOptions = null;
        var coordinates = null;

        self.updateMapState('none');

        if (typeof (google) != 'undefined' && typeof (google.maps) != 'undefined') {
            mapOptions = {
                zoom: 8,
                disableDefaultUI: true,
                zoomControl: true,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }

            if (params.marker) {
                coordinates = new google.maps.LatLng(params.marker.latitude, params.marker.longitude);
                mapOptions.center = coordinates;
            }

            map = new google.maps.Map(document.getElementById('mapContainer'), mapOptions);

            if (coordinates) {
                marker = new google.maps.Marker({
                    position: coordinates,
                    map: map
                });
            }
        } else {
            self.updateMapState('empty');
        }
    }

    if (this.get_mapInitialized()) {
        componentInitialized();
    } else {
        this.updateMapState('loading');
        this.add_mapInitialized(componentInitialized);

        script = document.createElement("script");

        script.type = "text/javascript";
        script.src = "https://maps.googleapis.com/maps/api/js?sensor=false&callback=_VisitorDetailsLocationMapCallback";

        document.getElementsByTagName('head')[0].appendChild(script);
    }
}

OMC.VisitorDetails.Location.prototype.updateMapState = function (state) {
    /// <summary>Updates map state.</summary>
    /// <param name="state">New map state.</param>

    var mapContainer = null;

    if (state && state.length) {
        mapContainer = document.getElementById('mapContainer');

        if (mapContainer) {
            mapContainer.innerHTML = '';
            mapContainer.style.backgroundColor = '#ffffff';

            if (state == 'empty') {
                mapContainer.innerHTML = ('<div class="visitor-details-location-map-centered"><i>' +
                    this.get_terminology()['MapNotAvailable'] + '</i></div>');
            } else if (state == 'loading') {
                mapContainer.innerHTML = ('<div class="visitor-details-location-map-centered">' +
                    '<i class="fa-refresh fa-spin"></i>' + '</div>');
            }
        }
    }
}

OMC.VisitorDetails.Location.prototype._mapCallback = function () {
    /// <summary>Occurs when the map component has been initialized.</summary>
    /// <private />

    if (!this._mapInitialized) {
        this._mapInitialized = true;

        for (var i = 0; i < this._mapInitializedCallbacks.length; i++) {
            this._mapInitializedCallbacks[i](this, {});
        }
    }
}


