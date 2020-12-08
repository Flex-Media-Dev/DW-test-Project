function LeadsListPage(opts) {
    var options = opts;

    var _mapState = function (state) {
        /// <summary>Toggles map container into the given state.</summary>
        /// <param name="state">New map state.</param>
        /// <private />

        var mapContainer = null;

        if (state && state.length) {
            mapContainer = document.getElementById("visitorLocationMap");

            if (mapContainer) {
                mapContainer.innerHTML = '';
                mapContainer.style.backgroundColor = '#ffffff';

                if (state == 'empty') {
                    mapContainer.innerHTML = ('<div class="omc-leads-list-visitor-info-map-padding"><i>' +
                        (options.Terminology['MapNotAvailable'] || 'Map not available') + '</i></div>');
                } else if (state == 'loading') {
                    mapContainer.innerHTML = ('<div class="omc-leads-list-visitor-info-map-padding">' +
                        '<i class="fa fa-refresh fa-spin"></i>' + '</div>');
                }
            }
        }
    }

    var secondaryListRows = [];
    var additionalVisitorRows = [];
    var approvedLeads = [];
    var visitorsData = null;
    var hasChanges = false;

    var _getVisitorsData = function () {
        if (!visitorsData) {
            visitorsData = {};
            var visitorsRows = List.getAllRows("LeadsList");
            if (visitorsRows && visitorsRows.length > 0) {
                visitorsRows.forEach(function (row) {
                    if (row.hasClassName("listRow")) {
                        var visitor = _getVisitorDataFromRow(row);
                        visitorsData[visitor.visitorId] = visitor;
                    }
                });
            }
        }
        return visitorsData;
    };

    var _getVisitorEntries = function (visitorId) {
        if (_getVisitorsData()) {
            var foundVisitor = visitorsData[visitorId];
            if (foundVisitor) {
                var relatedVisitors = [];
                for (var dataVisitorId in visitorsData) {
                    var visitor = visitorsData[dataVisitorId];
                    if (visitor.visitorSessionId == foundVisitor.visitorSessionId){
                        relatedVisitors.push(visitor.visitorId);
                    }
                }
                return relatedVisitors;
            }
        }
        return [];
    };

    var _getVisitorDataFromRow = function (row) {
        var visitor = {};
        visitor.visitorId = row.getAttribute("data-visitorId");
        visitor.visitorSessionId = row.getAttribute("data-visitorSessionId");
        visitor.visitsCount = row.getAttribute("data-visitsCount");
        visitor.lastVisit = row.getAttribute("data-lastVisit");
        visitor.pageviews = row.getAttribute("data-pageviews");
        visitor.engagement = row.getAttribute("data-engagement");
        visitor.cartReference = row.getAttribute("data-cartReference");
        visitor.orderId = row.getAttribute("data-orderId");
        visitor.username = row.getAttribute("data-username");
        visitor.usercompany = row.getAttribute("data-usercompany");
        visitor.ipaddress = row.getAttribute("data-ipaddress");
        visitor.company = row.getAttribute("data-company");
        visitor.isp = row.getAttribute("data-isp");
        visitor.countrycode = row.getAttribute("data-countrycode");
        visitor.region = row.getAttribute("data-region");
        visitor.domain = row.getAttribute("data-domain");
        visitor.latitude = row.getAttribute("data-latitude");
        visitor.longitude = row.getAttribute("data-longitude");
        visitor.state = row.getAttribute("data-state");
        visitor.isLead = row.getAttribute("data-isLead");
        return visitor;
    };

    var _loadMap = function (ip, latitude, longitude) {
        /// <summary>Loads the map.</summary>
        /// <param name="params">Map parameters.</param>
        /// <private />
        _mapState('none');

        if (typeof (google) != 'undefined' && typeof (google.maps) != 'undefined') {
            var coordinates = latitude && longitude ? new google.maps.LatLng(latitude, longitude) : null;

            var map = new google.maps.Map(document.getElementById("visitorLocationMap"), {
                zoom: 8,
                disableDefaultUI: true,
                zoomControl: true,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                center: coordinates
            });

            var marker = new google.maps.Marker({
                position: coordinates,
                map: map,
                title: ip
            });

        } else {
            console.warn("cannot load google map");
            _mapState('empty');
        }
    }

    var _moveRow = function (visitorId, originalList, tempList) {
        //ToDo:fix select checkboxes
        var selectedRow = List.getRowByID(originalList, "row" + visitorId);

        var listRows = document.getElementById(tempList + "_body");

        _removeSelectedVisitorRows(visitorId);

        var newRow = selectedRow.cloneNode(true);
        newRow.id += tempList;
        //clear disabled state if row is already disabled in main leads list
        newRow.disabled = false;
        newRow.classList.remove("dis");
        if (tempList == "SecondaryLeadsList") {
            _handleSecondaryListRow(newRow, visitorId);
        } else {
            var visitor = _getVisitorsData()[visitorId];
            visitor.state = "";
            visitor.isLead = false;
        }
        listRows.appendChild(newRow);
        selectedRow.classList.add("dis");
        selectedRow.disabled = true;
    };

    var _removeSelectedVisitorRows = function (visitorId, removeAll) {
        var selector = "tr[data-visitorid='" + visitorId + "']" + (removeAll ? "" : ":not(#row" + visitorId + ")");
        var selectedVisitorRows = document.querySelectorAll(selector);
        if (selectedVisitorRows.length > 0) {
            for (var i = 0; i < selectedVisitorRows.length; i++) {
                var selectedVisitorRow = selectedVisitorRows[i];
                if (selectedVisitorRow) {
                    selectedVisitorRow.remove();
                }
            }
        }
    };

    var _handleSecondaryListRow = function (row, visitorId) {
        row.getElementsByClassName("actions")[0].classList.add("hidden-actions");
        var newCell = row.insertCell(row.cells.length - 1);
        var div = document.createElement('div');
        var txt = document.createTextNode(options.Terminology['ApprovedState'] || 'Approved');
        div.appendChild(txt);
        div.className = "btn btn-flat lead-state-label";
        div.id = visitorId + "stateLabel";
        div.setAttribute("title", options.Terminology['LeadStateColumnTitle'] || 'Select the new lead state for this visitor');
        div.onclick = function (e) {
            ContextMenu.show(e, 'LeadStatesContext', visitorId, options.Terminology['ApprovedState'] || 'Approved');
        };
        newCell.setAttribute("align", "center");
        newCell.appendChild(div);

        var visitor = _getVisitorsData()[visitorId];
        visitor.state = options.Terminology['ApprovedState'] || 'Approved';
        visitor.isLead = true;
    };

    var _updateState = function (state) {
        var checkboxes = document.getElementById("LeadStatesContext").getElementsByTagName("input");
        for (var i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = false;
        }
        if(state){
            document.getElementById(state + "StateButton").getElementsByTagName("input")[0].checked = true;
        }
    };

    var _getAllselectedRows = function() {        
        var rows = [];
        rows = rows.concat(List.getSelectedRows("LeadsList"));
        rows = rows.concat(List.getSelectedRows("SecondaryLeadsList"));
        rows = rows.concat(List.getSelectedRows("AdditionalLeadsList"));
        rows.filter(function (row, index) { return rows.indexOf(row) == index; });
        return rows;
    };

    var _getAllselectedVisitorIds = function () {
        var selectedRows = _getAllselectedRows();
        var visitorIds = selectedRows.map(function (row) { return row.getAttribute("data-visitorid"); });
        return visitorIds.filter(function (visitorId, index) { return visitorIds.indexOf(visitorId) == index; });
    };

    var api = {
        initialize: function (opts) {
            var self = this;
            this.options = opts;
            visitorsData = _getVisitorsData();
            var secondaryListData = document.getElementById("SecondaryLeadsListData").value;
            var additionalListData = document.getElementById("AdditionalLeadsListData").value;
            if (secondaryListData) {
                hasChanges = true;
                var parsedData = JSON.parse(secondaryListData) || [];
                parsedData.forEach(function (secondaryVisitor) { 
                    secondaryListRows.push(secondaryVisitor.visitorId);
                    visitorsData[secondaryVisitor.visitorId] = secondaryVisitor;
                });
            }
            if (additionalListData) {
                hasChanges = true;
                var parsedData = JSON.parse(additionalListData) || [];
                parsedData.forEach(function (additionalVisitor) {
                    additionalVisitorRows.push(additionalVisitor.visitorId);
                    visitorsData[additionalVisitor.visitorId] = additionalVisitor;
                });
            }
            document.body.onbeforeunload = function () {
                return hasChanges || null;
            }
        },
        help: showHelp,
        
        save: function (close) {
            hasChanges = false;
            /* Show spinning wheel*/
            new overlay('wait').show();

            if (close) {
                document.getElementById('saveAndClose').value = 'True';
            }

            var visitors = [];            
            for (visitorId in visitorsData) {
                var visitor = visitorsData[visitorId];
                if (visitors.indexOf(visitor) == -1) {
                    visitors.push(visitor);
                }
            }

            document.getElementById("VisitorsData").value = JSON.stringify(visitors);
            document.getElementById("Cmd").value = "SaveLeads";

            List._submitForm();
        },

        cancel: function () {
            hasChanges = false;
            if (options.NavigateToDashboardAction) {
                Action.Execute(options.NavigateToDashboardAction);
            } else {
                location.href = "/Admin/Dashboard/Marketing/View";
            }
        },

        visitorSelected: function (listId, element) {
            var listRow = element.closest(".listRow");
            var indexOfCheckAll = element.id.indexOf("chk_all_");
            var selected = [];
            if (indexOfCheckAll == 0) {
                selected = _getAllselectedRows();
            } else {
                var visitorId = listRow.getAttribute("data-visitorid");
                var selector = "tr[data-visitorid='" + visitorId + "']";
                var selectedVisitorRows = document.querySelectorAll(selector);
                if (selectedVisitorRows.length > 0) {
                    for (var i = 0; i < selectedVisitorRows.length; i++) {
                        var selectedVisitorRow = selectedVisitorRows[i];
                        if (selectedVisitorRow) {
                            var rowListId = selectedVisitorRow.parentElement.getAttribute("controlid");
                            List.setRowSelected(rowListId, selectedVisitorRow, element.checked)
                            selected.push(selectedVisitorRow);
                        }
                    }
                }
            }
            if (!!this.options.LeadState) {
                if (selected.length > 0) {
                    Ribbon.enableButton('StatesRibbonButton');
                    Ribbon.enableButton('cmdCreateNotification');
                } else {
                    Ribbon.disableButton('StatesRibbonButton');
                    Ribbon.disableButton('cmdCreateNotification');
                }
            } else {
                if (selected.length > 0) {
                    Ribbon.enableButton('cmdMarkAsLeads');
                    Ribbon.enableButton('cmdMarkAsNotLeads');
                    Ribbon.enableButton('cmdIgnoreCompamies');
                    Ribbon.enableButton('cmdSendInMail');
                } else {
                    Ribbon.disableButton('cmdMarkAsLeads');
                    Ribbon.disableButton('cmdMarkAsNotLeads');
                    Ribbon.disableButton('cmdIgnoreCompamies');
                    Ribbon.disableButton('cmdSendInMail');
                }
            }
        },

        applyFilters: function () {
            hasChanges = false;
            new overlay('wait').show();
            List._submitForm();
        },

        resetFilters: function () {
            var url = "LeadsList.aspx";
            if (this.options.NotLeads) {
                url += "?NotLeads=true"
            } else if (!!this.options.LeadState) {
                url += "?State=" + encodeURIComponent(this.options.LeadState);
            }
            location.href = url;
        },

        showInfobox: function (ip, isp, region, domain, latitude, longitude) {
            document.getElementById("visitorLocatoinIpAddress").innerText = ip;
            document.getElementById("visitorLocatoinISP").innerText = isp;
            document.getElementById("visitorLocatoinRegion").innerText = region;
            document.getElementById("visitorLocatoinDomain").innerText = domain;

            _mapState('empty');
            if (!isNaN(latitude) && !isNaN(longitude) && latitude > 0 && longitude > 0) {
                _loadMap(ip, latitude, longitude);
            }
            dialog.show("VisitorLocationDialog");
        },


        ignoreSelected: function () {
            var selectedVisitorIds = _getAllselectedVisitorIds();
            var companies = [];
            var visitors = _getVisitorsData();
            for (var i = 0; i < selectedVisitorIds.length; i++) {
                var visitorId = selectedVisitorIds[i];
                var visitor = visitors[visitorId];
                if (visitor.company && companies.indexOf(visitor.company) == -1) {
                    companies.push(visitor.company);
                }
            }
            this.ignoreCompanies(companies.join());
        },

        ignoreCompanies: function (companies) {
            document.getElementById("AddedKnownProviders").value = companies;
            document.getElementById("Cmd").value = "AddKnownProviders";
            List._submitForm();
        },

        openVisitsList: function (visitorID, isLead, navigateToVisits, orderID) {
            var query = "";

            if (isLead != null) {
                query += ('&IsLead=' + isLead.toString());
            }

            if (orderID) {
                query += ('&orderID=' + orderID.toString());
            }

            if (!!navigateToVisits) {
                query += ('&Section=Visits');
            }

            var url = '/Admin/Module/OMC/Leads/Details/Default.aspx?ID=' + encodeURIComponent(visitorID) + '&' + query;

            dialog.show("pwDialog", url, dialog.sizes.large);
        },

        markSelected: function () {
            var selectedVisitorIds = _getAllselectedVisitorIds();
            var notLeadOrPotential = [];
            var visitors = _getVisitorsData();
            for (var i = 0; i < selectedVisitorIds.length; i++) {
                var visitorId = selectedVisitorIds[i];
                var visitor = visitors[visitorId];
                if (visitor.isLead != "true") {
                    notLeadOrPotential.push(visitorId);
                }
            }
            this.moveVisitor(null, notLeadOrPotential, true);
        },

        unmarkSelected: function () {
            var selectedVisitorIds = _getAllselectedVisitorIds();
            var leadOrPotential = [];
            var visitors = _getVisitorsData();
            for (var i = 0; i < selectedVisitorIds.length; i++) {
                var visitorId = selectedVisitorIds[i];
                var visitor = visitors[visitorId];
                if (visitor.isLead != "false") {
                    leadOrPotential.push(visitorId);
                }
            }
            this.moveVisitor(null, leadOrPotential, false);
        },

        moveVisitor: function (element, visitorIds, isLead) {
            hasChanges = true;
            if (element) {
                var listRow = element.closest(".listRow");
                var currentListId = listRow.parentElement.getAttribute("controlid");
                if (currentListId == "LeadsList" && listRow.disabled) {
                    return;
                }
            }

            var tempList = !!isLead ? "SecondaryLeadsList" : "AdditionalLeadsList";

            var selectAllCheckbox = document.getElementById("chk_all_" + tempList);
            if (selectAllCheckbox.disabled) {
                selectAllCheckbox.disabled = false;
                selectAllCheckbox.onclick = function (e) {
                    var listId = tempList;
                    List.setAllSelected(listId, this.checked); currentPage.visitorSelected(listId, this);
                }
            }

            var relatedVisitorIds = [];
            visitorIds.forEach(function (theVisitorId) { relatedVisitorIds = relatedVisitorIds.concat(_getVisitorEntries(theVisitorId)); });
            for (var j = 0; j < relatedVisitorIds.length; j++) {
                var visitorId = relatedVisitorIds[j];
                _moveRow(visitorId, "LeadsList", tempList);
                if (!!isLead) {
                    var visitorIndex = additionalVisitorRows.indexOf(visitorId);
                    if (visitorIndex != -1) {
                        additionalVisitorRows.splice(visitorIndex, 1);
                    }
                    secondaryListRows.push(visitorId);
                } else {
                    var visitorIndex = secondaryListRows.indexOf(visitorId);
                    if (visitorIndex != -1) {
                        secondaryListRows.splice(visitorIndex, 1);
                    }
                    additionalVisitorRows.push(visitorId);
                }
            }
            document.getElementById("AdditionalLeadsListData").value = JSON.stringify(additionalVisitorRows.map(function (additionalRowId) { return visitorsData[additionalRowId]; }));
            document.getElementById("SecondaryLeadsListData").value = JSON.stringify(secondaryListRows.map(function (secondaryRowId) { return visitorsData[secondaryRowId]; }));
        },

        sendLeadsAsEmail: function () {
            var selectedRows = _getAllselectedRows();
            var visitorIds = selectedRows.map(function (row) { return row.getAttribute("data-visitorsessionid"); });
            this.sendLeadMail(visitorIds.filter(function (visitorId, index) { return visitorIds.indexOf(visitorId) == index; }));
        },

        sendLeadMail: function (visitorIds) {
            if (visitorIds && Array.isArray(visitorIds) && visitorIds.length > 0) {
                //filters: { "AreaID", "PeriodFrom", "PeriodTo", "Country", "PageViewsFrom", "ExtranetUsers", "IsLead", "ExcludeKnownProviders", "Profile" };
                var url = '/Admin/Module/OMC/Leads/EmailLeadEdit.aspx?ID=' + visitorIds.join();
                url += "&AreaID=" + document.getElementById("LeadsList:WebsiteFilter").value;
                if (document.getElementById("FromDateFilter:DateSelector_notSet").value.toLowerCase() != "true") {
                    url += "&PeriodFrom=" + document.getElementById("FromDateFilter:DateSelector_calendar").value;
                }
                if (document.getElementById("ToDateFilter:DateSelector_notSet").value.toLowerCase() != "true") {
                    url += "&PeriodTo=" + document.getElementById("ToDateFilter:DateSelector_calendar").value;
                }
                url += "&Country=" + document.getElementById("LeadsList:CountryFilter").value;
                url += "&PageViewsFrom=" + document.getElementById("LeadsList:PageviewsFilter").value;
                url += "&ExtranetUsers=" + document.getElementById("LeadsList:ExtranetUsersFilter").value;
                if (!!this.options.LeadState || !!this.options.NotLeads) {
                    var isLead = !this.options.NotLeads;
                    url += "&IsLead=" + visitorIds.map(function (visitorId) { return isLead; }).join();
                }
                url += "&ExcludeKnownProviders=" + document.getElementById("LeadsList:ExcludedCompaniesFilter").checked;
                url += "&Profile=" + document.getElementById("LeadsList:ProfileFilter").value;

                dialog.show("SendEmailDialog", url);
            }
        },

        leadStatesContextShow: function (contextMenu) {
            var state = ""
            if (contextMenu.callingID) {
                document.getElementById('LeadStatesContext').classList.remove("checkbox-hidden");
                var visitor = _getVisitorsData()[contextMenu.callingID];
                if (visitor) {
                    state = visitor.state;
                }
            } else {
                document.getElementById('LeadStatesContext').classList.add("checkbox-hidden");
            }
            _updateState(state);
        },

        clearState: function (contextMenu) {
            hasChanges = true;
            var visitorId = contextMenu.callingID;
            if (visitorId) {
                var relatedVisitorIds = _getVisitorEntries(visitorId);
                for (var j = 0; j < relatedVisitorIds.length; j++) {
                    var relatedVisitorId = relatedVisitorIds[j];
                    _removeSelectedVisitorRows(relatedVisitorId, !!this.options.LeadState || !!this.options.NotLeads);
                    var selectedRow = List.getRowByID("LeadsList", "row" + relatedVisitorId);
                    if (selectedRow && !Array.isArray(selectedRow)) {
                        selectedRow.disabled = false;
                        selectedRow.classList.remove("dis");
                    }

                    var visitorIndex = secondaryListRows.indexOf(relatedVisitorId);
                    if (visitorIndex != -1) {
                        secondaryListRows.splice(visitorIndex, 1);
                    }

                    var visitor = _getVisitorsData()[relatedVisitorId];
                    visitor.state = "";
                    visitor.isLead = "";
                }

            } else {
                var selectedRows = _getAllselectedRows();
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedRow = selectedRows[i];
                    visitorId = selectedRow.getAttribute("data-visitorid");
                    var relatedVisitorIds = _getVisitorEntries(visitorId);
                    for (var j = 0; j < relatedVisitorIds.length; j++) {
                        var relatedVisitorId = relatedVisitorIds[j];

                        selectedRow = List.getRowByID("LeadsList", "row" + relatedVisitorId);

                        if (selectedRow && !Array.isArray(selectedRow)) {
                            selectedRow.disabled = true;
                            selectedRow.classList.add("dis");
                        }

                        if (secondaryListRows.indexOf(relatedVisitorId) == -1) {
                            secondaryListRows.push(relatedVisitorId);
                        }

                        var visitor = _getVisitorsData()[relatedVisitorId];
                        visitor.state = "";
                        visitor.isLead = "";
                    }
                }               
            }

            document.getElementById("SecondaryLeadsListData").value = JSON.stringify(secondaryListRows.map(function (secondaryRowId) { return visitorsData[secondaryRowId]; }));
        },

        setState: function (contextMenu, newState) {
            hasChanges = true;
            var visitorId = contextMenu.callingID;
            if (visitorId) {
                _updateState(newState);
                var relatedVisitorIds = _getVisitorEntries(visitorId);
                for (var j = 0; j < relatedVisitorIds.length; j++) {
                    var relatedVisitorId = relatedVisitorIds[j];
                    document.getElementById(relatedVisitorId + "stateLabel").innerText = newState;
                    _getVisitorsData()[relatedVisitorId].state = newState;
                }
                document.getElementById("SecondaryLeadsListData").value = JSON.stringify(secondaryListRows.map(function (secondaryRowId) { return visitorsData[secondaryRowId]; }));
            } else {
                var selectedRows = _getAllselectedRows();
                var visitorIds = selectedRows.map(function (row) { return row.getAttribute("data-visitorid"); });
                for (var j = 0; j < visitorIds.length; j++) {
                    var selectedRow = selectedRows[j];
                    selectedRow.disabled = false;
                    selectedRow.classList.remove("dis");

                    visitorId = selectedRow.getAttribute("data-visitorid");

                    document.getElementById(visitorId + "stateLabel").innerText = newState;
                    _getVisitorsData()[visitorId].state = newState;

                    var visitorIndex = secondaryListRows.indexOf(visitorId);
                    if (secondaryListRows.indexOf(visitorId) != -1) {
                        secondaryListRows.splice(visitorIndex, 1);
                    }
                }

                document.getElementById("SecondaryLeadsListData").value = JSON.stringify(secondaryListRows.map(function (secondaryRowId) { return visitorsData[secondaryRowId]; }));
            }
        },

        createNotification: function () {            
            var frame = document.getElementById("CreateNotificationDialogFrame");
            var dialogWindow = frame.contentWindow ? frame.contentWindow : frame.window;

            var selectedRows = _getAllselectedRows();
            var visitorIds = selectedRows.map(function (row) { return row.getAttribute("data-visitorsessionid"); });
            var uniqvisitorsId = visitorIds.filter(function (visitorId, index) { return visitorIds.indexOf(visitorId) == index; });

            dialogWindow.OMC.ReturningVisitorNotificationManager.get_current().set_visitors(uniqvisitorsId);
            dialogWindow.OMC.ReturningVisitorNotificationManager.get_current().set_dialog(document.getElementById("CreateNotificationDialog"));

            dialog.show("CreateNotificationDialog");
        },

        manageNotifications: function () {
            dialog.show("NotificationsListDialog");
        }
    };

    api.initialize(options);
    return api;
}