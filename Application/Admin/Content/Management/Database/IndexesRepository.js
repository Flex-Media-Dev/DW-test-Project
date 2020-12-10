app.factory('indexesRepository', function ($http) {
    return {

        getFragmentationAnalize: function (callback) {
            $http.get("/Admin/Content/Management/Database/IndexesHandler.ashx?cmd=analyze").success(callback);
        },

        startRebuild: function (callback) {
            $http.get("/Admin/Content/Management/Database/IndexesHandler.ashx?cmd=rebuild").success(callback);
        },

        rebuildStatus: function (callback) {
            $http.get("/Admin/Content/Management/Database/IndexesHandler.ashx?cmd=status").success(callback);
        }

    }
});