app.factory('facetsRepository', function ($http) {
    return {

        getFacets: function (callback, token) {            
            $http.get("/Admin/Api/repositories/Facets/" + repository + "/" + item + "/", {
                    headers: { 'Authorization': token }
                }).success(callback);
        },

        setFacets: function (data, callback, token) {
            $http.post("/Admin/Api/repositories/Facets/" + repository + "/" + item + "/",
            data,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback).error(function (err) { alert(angular.toJson(err))});

        },

        getDataSources: function (callback, token) {            
            $http.get("/Admin/Api/repositories/_sys_datasources", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getModel: function (repository, item, callback, token) {
            $http.post("/Admin/Api/Repositories/_sys_model/" + repository + "/" + item + "/",
            null,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback);

        },

        getParameters: function (repository, item, callback, token) {
            $http.post("/Admin/Api/repositories/_sys_params/" + repository + "/" + item + "/",
            null,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback);

        },

        getRenderTypes: function (callback, token) {
            $http.get("/Admin/Api/repositories/renderTypes/", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

    }

});

