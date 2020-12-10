app.controller("facetsController", function ($scope, $http, $timeout, facetsRepository) {

    $scope.facets = null;
    $scope.instanceTypes = null;

    $scope.draftInstance = null;
    $scope.Preview = true;

    $scope.draftField = null;
    $scope.selectedField = null;
    $scope.datasources = [];
    $scope.model = {};
    $scope.parameters = [];
    $scope.renderTypes = [];
    $scope.token = '';

    $scope.init = function (token) {        
        $scope.token = 'Basic ' + token;

        $scope.getDataSources();
        $scope.getFacets();
        $scope.getRenderTypes();
    }

    $scope.getFacets = function () {        
        facetsRepository.getFacets(function (results) {
            $scope.facets = results;
            $scope.updateDataModel();
            $scope.updateDataParameters();
        }, $scope.token);
    }

    $scope.setFacets = function () {
        facetsRepository.setFacets($scope.facets, function (results) { }, $scope.token);
    }

    $scope.getRenderTypes = function () {
        facetsRepository.getRenderTypes(function (results) {
            $scope.renderTypes = results;
        }, $scope.token)
    }

    $scope.getDataSources = function () {
        facetsRepository.getDataSources(function (results) {
            res = [];
            for (var i = 0; i < results.length; i++) {
                if (results[i].Type == "Query")
                    res.push({
                        Repository: results[i].Repository,
                        Item: results[i].Name
                    });
            }
            $scope.datasources = res;
        }, $scope.token);
    }

    $scope.updateDataModel = function () {
        facetsRepository.getModel($scope.facets.Source.Repository, $scope.facets.Source.Item, function (results) {
            $scope.model = results;

            if ($scope.model.Fields) {
                $scope.model.Fields.sort(function (a, b) {
                    return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
                })
                if ($scope.facets && $scope.facets.FieldsTermsCount) {
                    for (var i = 0; i < $scope.model.Fields.length; i++) {
                        var count = $scope.facets.FieldsTermsCount[$scope.model.Fields[i].SystemName];
                        if (count != null) {
                            $scope.model.Fields[i].Name += " (" + count + ")";
                        }                        
                    }
                }
            }
        }, $scope.token);
    }

    $scope.updateDataParameters = function () {
        facetsRepository.getParameters($scope.facets.Source.Repository, $scope.facets.Source.Item, function (results) {
            $scope.parameters = results;
        }, $scope.token);
    }

    $scope.isNoLongerAvailable = function (facet) {
        var res = !$scope.parameters.length == 0; // return false if parameters is empty - still loading.
        angular.forEach($scope.parameters, function (param, key) {
            if (param.Name == facet.QueryParameter) {
                res = false;
            }
        });

        return res;
    }

    $scope.exceedFieldsTermsCount = function (facet) {
        return $scope.facets.FieldsTermsCount[facet.Field] > 256;
    }

    $scope.onFacetsSourceChanged = function () {
        $scope.updateDataModel();
        $scope.updateDataParameters();
    }

    $scope.setFacetsAndExit = function () {
        facetsRepository.setFacets($scope.facets, function (results) {
            document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id=' + repositoryclean
        }, $scope.token);
    }

    $scope.togglePreview = function () {
        $scope.setPreview(!$scope.preview);
    }

    $scope.setPreview = function (pview) {
        $scope.preview = pview;
    }

    /* Field Dialog */
    $scope.newFacetDialog = function (facet) {
        $scope.selectedFacet = null;
        $scope.draftFacet = facet || { Type: 'Field' };
        if (!facet.Visibility) {
            facet.Visibility = { Status: 'AlwaysVisible', Condition: 'HasValue' };
        }
        dialog.show('FacetDialog');
    }

    $scope.openFacetDialog = function (facet) {
        $scope.selectedFacet = facet;
        $scope.draftFacet = angular.copy(facet);
        dialog.show('FacetDialog');
    }

    $scope.saveFacetDialog = function () {
        if ($scope.selectedFacet) {
            $scope.selectedFacet.Name = $scope.draftFacet.Name;
            $scope.selectedFacet.Type = $scope.draftFacet.Type;
            $scope.selectedFacet.QueryParameter = $scope.draftFacet.QueryParameter;
            $scope.selectedFacet.Field = $scope.draftFacet.Field;
            $scope.selectedFacet.Options = $scope.draftFacet.Options;
            $scope.selectedFacet.RenderType = $scope.draftFacet.RenderType;
            $scope.selectedFacet.Visibility = angular.copy($scope.draftFacet.Visibility);
        }
        else {
            $scope.facets.Items.push($scope.draftFacet);
        }
        dialog.hide('FacetDialog');
    }

    $scope.removeFacet = function (index) {
        $scope.facets.Items.splice(index, 1);
    }

    $scope.removeFacetOption = function (index) {
        $scope.draftFacet.Options.splice(index, 1);
    }

    $scope.sortFacetsDrop = function (event, facet) {
        var fromIndex = parseInt(event.dataTransfer.getData("FacetIndex"));
        var toIndex = $scope.facets.Items.indexOf(facet);
        $scope.facets.Items.splice(toIndex, 0, $scope.facets.Items.splice(fromIndex, 1)[0]);
    }

    $scope.sortFacetsDragOver = function (event) {
        event.preventDefault();
    }

    $scope.sortFacetsDragStart = function (event, facet) {
        var facetIndex = $scope.facets.Items.indexOf(facet);
        event.dataTransfer.setData("FacetIndex", facetIndex);
    }
});
