app.factory('indexRepository', function ($http) {
    return {

        getIndex: function (callback) {
            $http.get("/Admin/Api/repositories/Index/" + repository + "/" + item + "/").success(callback);
        },

        setIndex: function (data, callback) {
            $http.post("/Admin/Api/repositories/Index/" + repository + "/" + item + "/",
            data,
            {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).success(callback).error(function (err) { alert(angular.toJson(err))});

        },



        resumeIndex: function (instance, meta, incallback) {
            $http.post("/Admin/Api/repositories/resume/" + repository + "/" + item + "-index/" + instance + "/",
                meta,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).success(incallback);
        },

        getStatus: function (callback, errorCallback) {
            $http.post("/Admin/Api/repositories/_sys_status/" + repository + "/" + item + "/")
                .success(callback)
                .error(errorCallback);
        },

        getInstanceTypes: function (callback, errorCallback) {
            $http.post("/Admin/Api/repositories/_sys_instance_types/" + repository + "/" + item + "/")
            .success(callback)
            .error(errorCallback);
        },

        getBuildTypes: function (callback, errorCallback) {
            $http.post("/Admin/Api/repositories/_sys_build_types/" + repository + "/" + item + "/")
            .success(callback)
            .error(errorCallback);
        },

        getFieldTypes: function (callback, errorCallback) {
            $http.post("/Admin/Api/repositories/_sys_field_types/" + repository + "/" + item + "/")
            .success(callback)
            .error(errorCallback);
        }

    }

});

