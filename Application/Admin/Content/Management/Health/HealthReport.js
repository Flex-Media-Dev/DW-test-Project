var HealthReport;
(function (HealthReport) {
    var HealthList = (function () {
        function HealthList(provider) {
            this.checkList = {};
            this.provider = provider;
        }

        HealthList.prototype.runProviderCheks = function () {
            var checkRows = List.getAllRows('healthList');
            for (var i = 0; i < checkRows.length; i++) {
                var checkId = checkRows[i].attributes['itemid'].value;
                this.runCheck(checkId);
            }
        };

        HealthList.prototype.runCheck = function (checkId) {
            var _this = this;

            var url = "HealthReport.aspx?provider=" + this.provider + "&checkId=" + checkId;
            fetch(url).then(function (resp) {
                if (resp.ok) {
                    return resp.json();
                }
            }).then(function (check) {
                _this.updateRow(check);
            }).catch(function (ex) {
                HealthList.log("Unable to run check " + checkId, ex);
            });
        };

        HealthList.prototype.updateRow = function (check) {
            var _this = this;
            this.checkList[check.Id] = check;

            var row = List.getRowByID('healthList', "row" + check.Id);
            var cols = row.select("td");
            cols[0].innerHTML = check.State;
            cols[3].innerHTML = check.Count;

            row.style.cursor = "pointer";
            row.onclick = function (e) {
                e.preventDefault();
                e.stopPropagation();
                _this.showDetails(check.Id);
            };            
        };

        HealthList.prototype.showDetails = function (checkId) {
            var check = this.checkList[checkId];

            document.getElementById("dialogName").innerText = check.Name;
            document.getElementById("dialogDescription").innerText = check.Description;

            if (check.Details && check.Details.length > 0) {
                document.getElementById("dialogDetails").style.display = "";
                var detailsTable = document.getElementById("dialogDetailsTable");
                detailsTable.innerHTML = null;
                check.Details.forEach(function (item) {
                    var rowCells = "<td>" + item.ObjectType + "</td>"
                        + "<td>" + item.Key1 + "</td>"
                        + "<td>" + item.Key2 + "</td>"
                        + "<td>" + item.Key3 + "</td>"
                        + "<td>" + item.Value + "</td>";
                    var row = detailsTable.insertRow();
                    row.innerHTML = rowCells;
                });
            }
            else {
                document.getElementById("dialogDetails").style.display = "none";
            }

            document.getElementById("dialogWhat").innerText = check.What;
            dialog.show("CheckDetailDialog");
        };

        HealthList.prototype.initializeSortMenu = function () {
            var _this = this;
            var sortMenu = document.getElementById('SortingMenu:healthList');
            if (sortMenu) {
                var sortAsc = sortMenu.select('a#hrefSortingMenuSortAscending')[0];
                if (sortAsc) {
                    sortAsc.onclick = function (event) {
                        event.preventDefault();
                        var columnIndex = parseInt(ContextMenu.callingID);
                        _this.sortData(columnIndex, true);
                    };
                }

                var sortDesc = sortMenu.select('a#hrefSortingMenuSortDescending')[0];
                if (sortDesc) {
                    sortDesc.onclick = function (event) {
                        event.preventDefault();
                        var columnIndex = parseInt(ContextMenu.callingID);
                        _this.sortData(columnIndex, false);
                    };
                }
            }
        };

        HealthList.prototype.sortData = function (columnIndex, sortAsc) {
            var list = document.getElementById("healthList_body");
            var rows = list.childElements();
            var reverse = sortAsc ? 1 : -1;

            rows.sort(function (a, b) {
                var compare = 0;
                if (columnIndex === 3) { 
                    // Count column
                    compare = parseInt(a.cells[columnIndex].innerText.trim()) > parseInt(b.cells[columnIndex].innerText.trim()) ? 1 : -1;
                }
                else {
                    compare = a.cells[columnIndex].innerText.trim().localeCompare(b.cells[columnIndex].innerText.trim());
                }

                return reverse * compare;
            });

            for (var i = 0; i < rows.length; i++) {
                list.appendChild(rows[i]);
            }
        };

        HealthList.log = function (msg, ex) {
            console.log(msg + ex);
        };

        return HealthList;
    }());

    // Public API
    HealthReport.initializeEditor = function (provider) {
        var health = new HealthList(provider);
        health.initializeSortMenu();
        health.runProviderCheks();
    };

})(HealthReport || (HealthReport = {}));
