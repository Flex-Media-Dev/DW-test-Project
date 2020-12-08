
app.controller("IndexesController", ['$scope', '$timeout', 'indexesRepository', function ($scope, $timeout, indexesRepository) {
    $scope.error = null;
    $scope.database = null;

    $scope.refresh = function () {
        Toolbar.setButtonIsDisabled('cmdRefresh', true);
        Toolbar.setButtonIsDisabled('cmdRebuild', true);

        var over = new overlay('loadOverlay');
        over.show();

        indexesRepository.getFragmentationAnalize(function (data) {
            $scope.database = data;
            over.hide();

            Toolbar.setButtonIsDisabled('cmdRefresh', false);

            if (data.error) {
                $scope.error = data.error
            }

            if (data.permissionError) {
                $scope.permissionError = data.permissionError;
            }

            if (!$scope.error && !$scope.permissionError) {
                Toolbar.setButtonIsDisabled('cmdRebuild', false);
            }

            $scope.rebuildStatus();
        });

    }

    $scope.rebuild = function () {
        if (!$scope.database && !$scope.database.indexes) {
            return;
        }

        for (var i = 0; i < $scope.database.indexes.length; i++) {
            var index = $scope.database.indexes[i];
            index.message = null;
        }

        indexesRepository.startRebuild(function (data) {
            $scope.rebuildStatus();
        });
    };

    $scope.rebuildStatus = function () {
        indexesRepository.rebuildStatus(function (data) {

            if (data.meta) {
                var metaEnded = data.meta.length;

                for (var i = 0; i < $scope.database.indexes.length; i++) {
                    var index = $scope.database.indexes[i];
                    var inProgress = false;

                    for (var j = 0; j < data.meta.length; j++) {
                        if (data.meta[j].fullIndexName == $scope.getFullIndexName(index.tableName, index.indexName)) {
                            index.message = data.meta[j].message;
                            inProgress = index.message === 'rebuild...';
                            metaEnded--;
                            break;
                        }
                    }

                    index.inProgress = inProgress;

                    if (metaEnded == 0) {
                        break;
                    }
                }
            }

            if (data.status == 'running') {
                Toolbar.setButtonIsDisabled('cmdRebuild', true);

                $timeout($scope.rebuildStatus, 3000); // update status
            }
            else {
                Toolbar.setButtonIsDisabled('cmdRebuild', false);
            }
        });
    };

    $scope.getFullIndexName = function (tableName, indexName) {
        return (tableName + '.' + indexName).replace('$', '');
    };

    $scope.refresh();
}]);