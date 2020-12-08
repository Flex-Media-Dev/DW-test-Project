app.factory('queryRepository', function ($http) {
    return {

        getQuery: function (callback, token) {
            $http.get("/Admin/Api/repositories/Query/" + repository + "/" + item + "/" + calledFrom + "/", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        setQuery: function (data, callback, token) {
            data.Name = data.Name.replace(/[\\|&|\/|\:]/g, ' ');
            $http.post("/Admin/Api/repositories/Query/" + repository + "/" + item + "/" + calledFrom + "/",
            data,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback).error(function (err) { alert(angular.toJson(err)) });

        },

        getDataSources: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_datasources?calledFrom=" + calledFrom, {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getModel: function (repository, item, callback, token) {
            $http.post("/Admin/Api/repositories/_sys_model/" + repository + "/" + item + "/",
            null,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback);

        },

        getListViewFields: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_data_list_view_mode_fields", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getSupportedActions: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_supported_actions", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        executeQuery: function (data, callback, token) {
            $http.post("/Admin/Api/repositories/execute/" + repository + "/" + item + "/",
            data,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': token
                }
            }).success(callback).error(function (err) { alert(angular.toJson(err)) });

        },

        getTerms: function (repos, index, field, callback, token) {
            this.getValueMapper(field.Source, repos, index, field.Type, function (valueMapper) {
                valueMapper = valueMapper.replace(/"/g, "");

                if (valueMapper == "") {
                    $http.get("/Admin/Api/repositories/_sys_terms/" + repos + "/" + index + "/" + field.SystemName + "/" + field.Type + "/", {
                        headers: { 'Authorization': token }
                    }).success(callback).error(function (err) { alert(angular.toJson(err)) });
                } else {
                    $http.get("/Admin/Api/repositories/_sys_terms/" + repos + "/" + index + "/" + field.SystemName + "/" + valueMapper + "/" + field.Type + "/" + field.Source + "/", {
                        headers: { 'Authorization': token }
                    }).success(callback).error(function (err) { alert(angular.toJson(err)) });
                }
            }, token);
        },

        getLanguages: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_languages", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getPresets: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_presets", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getCompletionRules: function (callback, token) {
            $http.get("/Admin/Api/repositories/_sys_completion_rules", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getValueMapper: function (fieldSource, repos, index, fieldType, callback, token) {
            if (fieldSource == "")
            {
                fieldSource = "undefined";
            }

            $http.get("/Admin/Api/repositories/_sys_valueMapper/" + fieldSource + "/" + repos + "/" + index + "/" + fieldType + "/", {
                headers: { 'Authorization': token }
            }).success(callback);
        },

        getCodeParameters: function (type, values, callback, token) {
            var data = {
                parameters: values
            };

            $http({
                url: "/Admin/Api/repositories/_sys_code_parameters/" + type + "/",
                method: 'GET',
                params: data,                
                headers: { 'Authorization': token }                
            }).success(callback).error(function (err) { alert(angular.toJson(err)) });
        },
    }

});

