app.controller("queryController", function ($scope, $http, $timeout, queryRepository) {

    $scope.query = null;
    $scope.instanceTypes = null;
    $scope.search = {};
    $scope.search.parameters = {};
    $scope.search.result = {};
    $scope.datasources = [];
    $scope.supportedActions = [];
    $scope.model = {};
    $scope.terms = [];
    $scope.languages = [];
    $scope.presets = [];
    $scope.updated;
    $scope.token = '';
    $scope.completionRules = [];
    $scope.draggedExpression = {};

    $scope.propertyName = 'Occurrences';
    $scope.reverse = true;
    $scope.showWarning = false;
    $scope.containsExtendedWarning = "Using the ContainsExtended operator can cause bad performance and higher memory usage";

    $scope.init = function (token) {
        $scope.token = 'Basic ' + token;

        $scope.getQuery();
        $scope.getSupportedActions();
        $scope.getPresets();
    };

    $scope.sortBy = function (propertyName) {
        $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
        $scope.propertyName = propertyName;
    };

    $scope.draftInstance = null;

    $scope.getQuery = function () {
        queryRepository.getQuery(function (results) {
            $scope.query = results;
            $scope.updateDataModel();
            $scope.getDataSources();
            $scope.getLanguages();
            $scope.getCompletionRules();

            var expressionsCheckbox = document.getElementById("AppendCompletionExpessions");
            if (expressionsCheckbox) {
                expressionsCheckbox.checked = $scope.query.AppendCompletionExpressions;
            }
        }, $scope.token);
    }

    $scope.validateExpressions = function () {
        return validateExpression($scope.query.Expression);
    }

    $scope.onCancel = function () {
        if (calledFrom == "PIM") {
            document.location.href = '/Admin/Module/eCom_Catalog/dw7/ListSmartSearches.aspx?groupID=' + repositoryclean
        }
        else {
            document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id=' + repositoryclean
        }
    }

    validateExpression = function (expression) {
        if (expression != null) {
            if (expression.Expressions != null) {
                for (var i = 0; i < expression.Expressions.length; i++) {
                    if (expression.Expressions[i].Expressions != null) {
                        if (!validateExpression(expression.Expressions[i])) {
                            return false;
                        }
                    } else {
                        if (!isSimpleExpressionValid(expression.Expressions[i])) {
                            return false;
                        }
                    }
                }
            } else {
                if (!isSimpleExpressionValid(expression)) {
                    return false;
                }
            }
        }
        return true;
    }

    isSimpleExpressionValid = function (expression) {
        return !((expression.Left == null || expression.Left.Field == null)
                || expression.Right == null
                || (expression.Right.class == "ConstantExpression" && (expression.Right.Value == null || expression.Right.Type == null))
                || (expression.Right.class == "ParameterExpression" && expression.Right.VariableName == null)
                || (expression.Right.class == "MacroExpression" && expression.Right.LookupString == null)
                || (expression.Right.class == "TermExpression" && (expression.Right.Value == null || expression.Right.Type == null))
                || expression.Operator == null);
    }

    $scope.setQuery = function () {
        $scope.trySaveQuery();
    }

    $scope.setQueryAndExit = function () {
        $scope.trySaveQuery(function() {
            if (calledFrom == "PIM") {
                document.location.href = '/Admin/Module/eCom_Catalog/dw7/PIM/PimMultiEdit.aspx?queryId=' + $scope.query.ID + '&groupId=' + repositoryclean;
            } else {
                document.location.href = '/Admin/Module/Repositories/ViewRepository.aspx?id=' + repositoryclean
            }
        });
    }

    $scope.trySaveQuery = function (afterSaveFn) {
        $scope.correctIsEmptyExpressions($scope.query.Expression);

        if (!$scope.validateExpressions()) {
            alert(_messages.saveQueryWithWrongExpression);
            return;
        }

        if ($scope.query.Name == "") {
            alert("Query name cannot be empty.");
            return;
        }
        var isNameHasWrongSymbols = false;

        for (var i = 0; !isNameHasWrongSymbols && i < _invalidQueryNameSymbols.length; i++) {
            isNameHasWrongSymbols = $scope.query.Name.indexOf(_invalidQueryNameSymbols[i]) > -1;
        }
        if (isNameHasWrongSymbols) {
            alert(_messages.invalidQueryName);
            return;
        }

        $scope.setViewLanguagesAndFields();
        $scope.setCompletionData();

        var expressionsCheckbox = document.getElementById("AppendCompletionExpessions");
        if (expressionsCheckbox) {
            $scope.query.AppendCompletionExpressions = expressionsCheckbox.checked;
        }

        queryRepository.setQuery($scope.query, function (results) {
            if (results.Succeeded) {
                var resultData = results.Data;
                $scope.query.FileName = resultData.QueryFileName;
                $scope.refreshTreeNode(resultData);
                if (afterSaveFn) {
                    afterSaveFn(resultData);
                }
            } else {
                alert(results.Message);
                console.warn(results.ExceptionData);
            }
        }, $scope.token);
    }

    $scope.changePreset = function () {
        var fields = $scope.model.selectedPreset ? $scope.model.selectedPreset.FieldIds.split(',') : [];
        
        SelectionBox.selectionRemoveAll("ViewFieldList");
        var lstLeft = document.getElementById("ViewFieldList_lstLeft");

        for (var i = 0; i < lstLeft.length; i++) {
            var option = lstLeft.options[i];
            option.selected = fields.indexOf(option.value) != -1;
        }

        SelectionBox.selectionAddSingle("ViewFieldList");
    }

    $scope.setViewLanguagesAndFields = function () {
        //Fetch data from selectionBoxes
        //Fields
        var fields = [];
        var viewFields = SelectionBox.getElementsRightAsOptionArray("ViewFieldList");
        for (var i = 0; i < viewFields.length; i++) {
            fields.push({ Name: viewFields[i].text, Source: viewFields[i].value, Sort: i });
        }

        $scope.query.ViewFields = fields;

        //Languages
        $scope.query.ViewLanguages = $scope.getSelectedDataFromSelectionBox("ViewLanguagesList");

        var listFields = [];
        var listViewFields = SelectionBox.getElementsRightAsOptionArray("ListViewFieldList");
        for (var i = 0; i < listViewFields.length; i++) {
            listFields.push({ Name: listViewFields[i].text, Source: listViewFields[i].value, Sort: i });
        }
        $scope.query.ListViewFields = listFields;
    };

    $scope.setCompletionData = function () {
        $scope.query.CompletionRules = $scope.getSelectedDataFromSelectionBox("CompletionRules");
        $scope.query.CompletionLanguages = $scope.getSelectedDataFromSelectionBox("CompletionLanguages");
    };

    $scope.getSelectedDataFromSelectionBox = function (controlId) {
        var returnList = [];
        var selectedElements = SelectionBox.getElementsRightAsOptionArray(controlId);
        for (var i = 0; i < selectedElements.length; i++) {
            returnList.push({ ID: selectedElements[i].value, Name: selectedElements[i].text, SortOrder: i });
        }
        return returnList;
    };

    $scope.refreshTreeNode = function (option) {
        if (calledFrom == "PIM") {
            console.log(option.NodeId)
            dwGlobal.getNavigatorWindow("PIM").dwGlobal.currentNavigator.refreshNode(option.NodeId)
        }
    }

    $scope.correctIsEmptyExpressions = function (expression) {
        if (expression != null) {
            if (expression.Expressions != null) {
                for (var i = 0; i < expression.Expressions.length; i++) {
                    if (expression.Expressions[i].Expressions != null) {
                        $scope.correctIsEmptyExpressions(expression.Expressions[i])
                    }
                    else {
                        if (expression.Expressions[i].Operator == 'IsEmpty') {
                            expression.Expressions[i].Right = {};
                            expression.Expressions[i].Right.class = 'ConstantExpression';
                            expression.Expressions[i].Right.Value = 'Empty';
                            expression.Expressions[i].Right.Type = 'System.String';
                        }
                    }
                }
            } else {

            }
        }
    }

    $scope.getInstanceTypes = function () {
        queryRepository.getInstanceTypes(function (results) {
            $scope.instanceTypes = results;
        }, function (err) { }, $scope.token);
    }

    $scope.getDataSources = function () {
        queryRepository.getDataSources(function (results) {
            res = [];
            for (var i = 0; i < results.length; i++) {
                if (results[i].Type == "Index")
                    res.push({
                        Repository: results[i].Repository,
                        Item: results[i].Name,
                        Type: results[i].Provider
                    });

                if (results[i].Name == $scope.query.Source.Item && results[i].Repository == $scope.query.Source.Repository) {
                    $scope.query.Source.Type = results[i].Provider;
                }
            }
            $scope.datasources = res;
        }, $scope.token);
    }

    $scope.updateDataModel = function () {

        var addDefaultFields = function (query, fieldsType) {
            if (query[fieldsType] == null || query[fieldsType].length == 0) {
                query[fieldsType] = [];
                query[fieldsType].push({ Name: 'Active', Source: 'ProductActive' })
                query[fieldsType].push({ Name: 'Product name', Source: 'ProductName' })
                query[fieldsType].push({ Name: 'Product number', Source: 'ProductNumber' })
                query[fieldsType].push({ Name: 'Price', Source: 'ProductPrice' })
            }
        }

        queryRepository.getModel($scope.query.Source.Repository, $scope.query.Source.Item, function (results) {
            $scope.model = results;

            if ($scope.model.Fields) {
                $scope.model.Fields.sort(function (a, b) {
                    return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
                });
                $scope.model.Fields.sort(function (a, b) {
                    return a.Group == b.Group ? 0 : a.Group < b.Group ? -1 : 1;
                });
                $scope.model.SortFields = $scope.model.Fields;
                $scope.model.SortFields.push({ Name: "Score", SystemName: "_score", Type: "", Group: "" });
            }
            if (calledFrom == "PIM") {
                addDefaultFields($scope.query, 'ViewFields');

                $scope.fillSelectionBox($scope.model.SortFields, $scope.query.ViewFields, 'ViewFieldList', $scope.compareFields, $scope.createFieldItem);                
            }
            $scope.initFieldSelectors();
        }, $scope.token);

        if (calledFrom == "PIM") {
            queryRepository.getListViewFields(function (results) {
                $scope.model.ListViewFields = results;

                if (results) {
                    results.sort(function (a, b) {
                        return a._name == b._name ? 0 : a._name < b._name ? -1 : 1;
                    });
                    results.sort(function (a, b) {
                        return a._section == b._section ? 0 : a._section < b._section ? -1 : 1;
                    });
                    $scope.model.ListViewFields = results;
                }

                var compareListFields = function (viewField, field) {
                    return viewField.Source == (field._systemName || field.SystemName);
                };

                var createListFieldItem = function (field, sortIndex) {
                    return { Name: (field._name || field.Name), Value: (field._systemName || field.SystemName), Sort: sortIndex || (field._sort || field.Sort) };
                };

                $scope.fillSelectionBox($scope.model.ListViewFields, $scope.query.ListViewFields, 'ListViewFieldList', compareListFields, createListFieldItem);
            }, $scope.token);
        }
    };

    $scope.initFieldSelectors = function () {
        $timeout(function () {
            var elements = document.querySelectorAll("select.fieldname");
            for (var i = 0; i < elements.length; i++) {
                var el = elements[i];
                const opts = { select: el };
                dwGlobal.createSelector(opts);
            }
        });
    };

    $scope.getLanguages = function () {
        queryRepository.getLanguages(function (languages) {
            $scope.languages = languages;
            if (calledFrom == "PIM") {
                $scope.fillSelectionBox($scope.languages, $scope.query.ViewLanguages, 'ViewLanguagesList', $scope.compareLanguages, $scope.createLanguageItem);
                $scope.fillSelectionBox($scope.languages, $scope.query.CompletionLanguages, 'CompletionLanguages', $scope.compareLanguages, $scope.createLanguageItem);
            }
        }, $scope.token);
    };

    $scope.getPresets = function () {
        queryRepository.getPresets(function (presets) {
            $scope.presets = presets;
        }, $scope.token);
    };

    $scope.getCompletionRules = function () {
        queryRepository.getCompletionRules(function (rules) {
            $scope.completionRules = rules;
            if (calledFrom == "PIM") {
                $scope.fillSelectionBox($scope.completionRules, $scope.query.CompletionRules, 'CompletionRules', $scope.compareRules, $scope.createRuleItem);
            }
        }, $scope.token);
    };

    $scope.getSupportedActions = function () {
        queryRepository.getSupportedActions(function (results) {
            res = [];
            for (var i = 0; i < results.length; i++) {
                var vals = results[i].split(':');
                res.push({
                    original: results[i],
                    namespace: vals[0],
                    name: vals[1]
                });
            }
            $scope.supportedActions = res;
        }, $scope.token);
    }

    $scope.addExpression = function (parent) {
        var binaryExpr = { 'class': 'BinaryExpression', Left: { "Field": null, "class": "FieldExpression" } };

        if (parent) {
            parent.Expressions.push(binaryExpr);
        }
        else {
            $scope.query.Expression = binaryExpr;
        }
        $scope.initFieldSelectors();
    }

    $scope.addExpressionGroup = function (parent) {
        var groupExpr = { 'class': 'GroupExpression', Operator: 'And', Expressions: [{ 'class': 'BinaryExpression', Left: { "Field": null, "class": "FieldExpression" } }] };

        if (parent) {
            parent.Expressions.push(groupExpr);
        }
        else {
            $scope.query.Expression = groupExpr;
        }
        $scope.initFieldSelectors();
    }

    $scope.haveExpressions = function () {
        if ($scope.query && $scope.query.Expression)
            return true;

        return false;
    }

    $scope.deleteExpression = function ($scope, index) {
        if (index == 0 && !$scope.$parent.$parent.expr) {
            $scope.query.Expression = null;
        }
        else {
            var arr = $scope.$parent.$parent.expr.Expressions;
            if (arr) {
                arr.splice(index, 1);
            }
        }
    }

    $scope.deleteExpressionGroup = function ($scope, index) {
        $scope.deleteExpression($scope, index);
    }

    $scope.removeProp = function (name) {
        delete $scope.query.Settings[name];
    }

    $scope.insertSetting = function (name, value) {
        $scope.query.Settings[name] = value;
    }


    $scope.openDlgSetting = function (name, val) {
        document.getElementById('dlgSettingName').value = name;
        document.getElementById('dlgSettingValue').value = val;
        dialog.show('dlgSetting');
    }

    $scope.saveDlgSetting = function () {

        if (document.getElementById('dlgSettingName').value.length > 0) {
            alert(document.getElementById('dlgSettingName').value + document.getElementById('dlgSettingValue').value)
            $scope.query.Settings[document.getElementById('dlgSettingName').value] = document.getElementById('dlgSettingValue').value;
            dialog.hide('dlgSetting');
        }

    }

    $scope.getFieldName = function (systemName) {
        if ($scope.model && $scope.model.Fields) {
            for (var i = 0; i < $scope.model.Fields.length; i++) {
                var field = $scope.model.Fields[i];
                if (field.SystemName === systemName) {
                    return field.Name;
                }
            }
        }
    }

    /* DIALOGS */


    /* Search Dialog */
    $scope.openSearchDialog = function () {
        $scope.search = {};
        $scope.search.parameters = {};
        $scope.search.result = {};

        dialog.show('dlgSearch');
    }

    $scope.executeQuery = function () {
        queryRepository.executeQuery($scope.search.parameters, function (results) {
            $scope.search.result = results;
        }, $scope.token);

    }

    $scope.togglePreview = function () {
        $scope.setPreview(!$scope.preview);
    }

    $scope.setPreview = function (pview) {
        $scope.preview = pview;
    }

    $scope.removeQueryParameter = function (index) {
        $scope.query.Parameters.splice(index, 1);
    }

    $scope.openParameterDialog = function (param) {
        if (param) {
            $scope.selectedParam = param;
            $scope.draftParam = angular.copy(param);
        }
        else {
            $scope.selectedParam = null;
            $scope.draftParam = {}; // new parameter
        }
        dialog.show('ParameterDialog');
    }

    $scope.openSourceDialog = function () {
        dialog.show('SourceDialog');
    }

    $scope.saveSourceDialog = function () {
        dialog.hide('SourceDialog');
    }

    $scope.saveParameterDialog = function () {
        if ($scope.selectedParam) {
            $scope.selectedParam.Name = $scope.draftParam.Name;
            $scope.selectedParam.Type = $scope.draftParam.Type;
            $scope.selectedParam.DefaultValue = $scope.draftParam.DefaultValue;
        }
        else {
            if (!$scope.query.Parameters) {
                $scope.query.Parameters = [];
            }
            $scope.query.Parameters.push(angular.copy($scope.draftParam));
        }
        dialog.hide('ParameterDialog');
    }

    $scope.openSortingDialog = function (sort) {
        if (sort) {
            $scope.selectedSort = sort;
            $scope.draftSort = angular.copy(sort);
        }
        else {
            $scope.selectedSort = null;
            $scope.draftSort = {}; // new sorting
        }
        dialog.show('SortOrderDialog');
    }

    $scope.saveSortingDialog = function () {
        if ($scope.selectedSort) {
            $scope.selectedSort.Field = $scope.draftSort.Field;
            $scope.selectedSort.SortDirection = $scope.draftSort.SortDirection;
        }
        else {
            if (!$scope.query.SortOrder) {
                $scope.query.SortOrder = [];
            }
            $scope.query.SortOrder.push(angular.copy($scope.draftSort));
        }
        dialog.hide('SortOrderDialog');
    }

    $scope.removeSortingParameter = function (index) {
        $scope.query.SortOrder.splice(index, 1);
    }

    $scope.editExpression = function (expr) {
        $scope.selectedExpression = expr;
        $scope.fillTerms([], expr, function () {
            dialog.show('EditExpressionDialog');

            if (expr.Right && expr.Right.class == 'CodeExpression') {
                $scope.loadCodeParameters(expr);
            }

        });
    }

    $scope.populateTermSelector = function (control, field, expr, callback) {
        if (expr.Terms && (expr.Terms.Terms && expr.Terms.Terms.length > 0) && expr.Terms.Field == field.SystemName) {
            $scope.fillTerms(expr.Terms.Terms, expr, callback);
        }
        else {
            var spinner;
            if (control != "undefined") {
                spinner = new overlay("wait");
                spinner.overlay = control.getElementsByClassName("overlay-container")[0];
                spinner.show();
            }

            queryRepository.getTerms($scope.query.Source.Repository, $scope.query.Source.Item, field, function (results) {

                $scope.fillTerms(results, expr, callback);
                if (spinner){
                    spinner.hide();
                }
            }, $scope.token);
        }
    }

    $scope.fillTerms = function (results, expr, callback) {
        if (expr.Right != undefined && expr.Left != undefined) {
            $scope.rightExpressionDraft = angular.copy(expr.Right);

            if (!expr.Terms)
            {
                expr.Terms = {};
            }

            expr.Terms.Field = expr.Left.Field;
            expr.Terms.Terms = results;
            $scope.rightExpressionDraft.Terms = {};
            $scope.rightExpressionDraft.Terms.Field = expr.Left.Field;
            $scope.rightExpressionDraft.Terms.Terms = results;

            let selectedTerms = $scope.getSelectedTerms($scope.rightExpressionDraft);
            $scope.setSelected(expr, selectedTerms);
            $scope.selectTerm();
        }
        else {
            var field = expr.Left ? expr.Left.Field : expr.Terms.Field;
            var expressionClass = $scope.rightExpressionDraft ? $scope.rightExpressionDraft.class : "";
            $scope.rightExpressionDraft = {}; // new right expression
            $scope.rightExpressionDraft.class = expressionClass;
            $scope.rightExpressionDraft.Terms = {};
            $scope.rightExpressionDraft.Terms.Field = field;
            $scope.rightExpressionDraft.Terms.Terms = results;

            if (!expr.Terms) {
                expr.Terms = {};
            }

            expr.Terms.Field = field;
            expr.Terms.Terms = results;

            let expression = expr.Right ? expr.Right : expr;
            let selectedTerms = $scope.getSelectedTerms(expression);
            $scope.setSelected(expression, selectedTerms);
            $scope.selectTerm();
        }
        if (callback){
            callback();
        }
    }

    $scope.getSelectedTerms = function (expr) {
        var selectedTerms = [];
        if (expr.Type == "System.Boolean[]" || expr.Type == "System.Boolean") {
            if (typeof (expr.DisplayValue.split) === "function") {
                selectedTerms = expr.DisplayValue.split(",");
            }
        } else {
            selectedTerms = expr.Value;
        }

        return selectedTerms;
    };

    $scope.setSelected = function (expr, termKeys) {
        if (typeof termKeys != "undefined" && expr.Terms) {
            for (var i = 0; i < termKeys.length; i++) {
                var term = expr.Terms.Terms.filter(function (term) {
                    return term.Key == termKeys[i];
                });

                if (term.length == 1) {
                    term[0].selected = true;
                }
            };

            expr.selectedTerms = expr.Terms.Terms.filter(
            function (e) {
                return e.selected == true
            });
            expr.DisplayValue = $scope.buildTermValue(expr.selectedTerms)
        }
    }

    $scope.selectTerm = function (field, expr, termKey) {        
        if (expr != undefined) {
            if (!field) {
                field = $scope.getFieldBySystemName(expr.Terms.Field);
            }

            //Only allow one select term for equal
            if (expr.Operator == 'Equal' && expr.selectedTerms.length >= 1) {
                var terms = expr.Terms.Terms.filter(function (x) { return x.Key == termKey.Key });
                if (terms.length > 0) {
                    //unselect terms but keep the last selected or keep at least one selected
                    for (var i = 0; i < expr.Terms.Terms.length; i++) {                        
                        expr.Terms.Terms[i].selected = (expr.Terms.Terms[i].Key == terms[0].Key);
                    }
                    //select last checked term
                    expr.selectedTerms = terms;
                }
            }

            expr.selectedTerms = expr.Terms.Terms.filter(
                function (e) {
                    return e.selected == true;
                });

            if (expr) {
                expr.DisplayValue = $scope.buildTermValue(expr.selectedTerms);
                $scope.setTerms(field, expr)
            }
        }
    }

    $scope.setValue = function (expr) {
        expr.Right.class = 'ConstantExpression';
        expr.Right.Value = expr.Right.DisplayValue;

        var field = $scope.model.Fields.filter(function (x) { return x.SystemName == expr.Left.Field })
        expr.Right.Type = field[0].Type;
    }

    $scope.buildTermValue = function (selectedTerms) {
        var termValue = "";
        for (var i = 0; i < selectedTerms.length; i++) {
            if (termValue != "") {
                termValue = termValue.concat(",");
            }

            termValue = termValue.concat(selectedTerms[i].Value);
        }

        return termValue;
    }

    $scope.saveEditExpressionDialog = function () {
        if (!$scope.selectedExpression) {
            console.log("expression not set");
            return;
        }
        
        var expr = $scope.selectedExpression;
        expr.Right = {};
        expr.Right.class = $scope.rightExpressionDraft.class;
        var promises = [];

        if (expr.Right.class == 'ConstantExpression') {
            expr.Right.Value = $scope.rightExpressionDraft.DisplayValue;
            expr.Right.DisplayValue = $scope.rightExpressionDraft.DisplayValue;
            expr.Right.Type = $scope.rightExpressionDraft.Type;
        }
        else if (expr.Right.class == 'ParameterExpression') {
            expr.Right.VariableName = $scope.rightExpressionDraft.VariableName;
        }
        else if (expr.Right.class == 'MacroExpression') {
            expr.Right.LookupString = $scope.rightExpressionDraft.LookupString;
        }
        else if (expr.Right.class == 'TermExpression') {
            var selectedValues;
            if ($scope.rightExpressionDraft.selectedTerms) {
                selectedValues = $scope.rightExpressionDraft.selectedTerms.map(function (a) { return a.Key });
                expr.Right.Value = selectedValues
                expr.selectedTerms = $scope.rightExpressionDraft.selectedTerms;
            }
            else {
                selectedValues = $scope.rightExpressionDraft.Value;
                expr.Right.Value = selectedValues;
            }

            expr.Right.DisplayValue = $scope.rightExpressionDraft.DisplayValue;
            
            var field = $scope.model.Fields.filter(function (x) { return x.SystemName == expr.Left.Field })

            expr.Right.Type = field[0].Type;

            if (selectedValues.length > 1 && !expr.Right.Type.endsWith(']')) {
                expr.Right.Type = expr.Right.Type + '[]';
            }
            else {
                //The 'In' operator doesn't work with non-array types, so no matter what this should always return an array, if the operator is 'In'
                if (selectedValues.length == 1 && !expr.Right.Type.endsWith(']') && expr.Operator == "In") {
                    expr.Right.Type = expr.Right.Type + '[]';
                }
            }

            if (selectedValues.length == 0) {
                expr.Right = undefined;
            }
        }
        else if (expr.Right.class == 'CodeExpression') {
            var typeElement = document.getElementById("AddInSelector_CodeProvider_params");

            var parametersElement = document.getElementById("ConfigurableAddIn_parameters");

            var parametersKeyValue = ""

            if (parametersElement != null) {
                var parameterString = parametersElement.value;

                var parameters = parameterString.split(",")

                for (var i = 0; i < parameters.length; i++) {
                    var tokens = parameters[i].split("(");
                    var parameterId = tokens[1].replace(")", "");
                    var parameterName = tokens[0];

                    //Get parameter element by ID
                    var element = document.getElementById(parameterId);

                    if (element == null) {
                        element = document.getElementsByName(parameterId)[0];
                    }

                    if (element != null) {
                        parametersKeyValue += parameterName + "::" + element.value + ";";
                    }
                }
            }

            var promise = queryRepository.getCodeParameters(typeElement.value, encodeURI(parametersKeyValue), function (data) {
                expr.Right.Parameters = data.Value;
                expr.Right.DisplayValue = data.DisplayValue;
                expr.Right.Type = data.Type;
            }, $scope.token);

            promises.push(promise);
        }

        Promise.all(promises).then(function () {
            $scope.rightExpressionDraft = null;
            dialog.hide('EditExpressionDialog');
        })
    }

    $scope.setTerms = function (field, expr) {
        expr.Right = {};
        expr.Right.class = 'TermExpression';

        expr.Right.Value = expr.selectedTerms.map(function (a) { return a.Key });
        expr.Right.DisplayValue = expr.DisplayValue;
        if (field) {
            expr.Right.Type = field.Type;
        }

        if (expr.selectedTerms.length > 1 && !expr.Right.Type.endsWith(']')) {
            expr.Right.Type = expr.Right.Type + '[]';
        }
        else {
            //The 'In' operator doesn't work with non-array types, so no matter what this should always return an array, if the operator is 'In'
            if (expr.selectedTerms.length == 1 && !expr.Right.Type.endsWith(']') && expr.Operator == "In") {
                expr.Right.Type = expr.Right.Type + '[]';
            }
        }

        if (expr.selectedTerms.length == 0) {
            expr.Right = undefined;
        }
    }

    $scope.toggleTermSelector = function (expr, e) {
        if (expr.Disabled) {
            return;
        }

        var optionsCol = e.currentTarget.parentElement.getElementsByClassName("termSelect-options");
        if (optionsCol.length) {
            var elm = optionsCol[0];

            if (elm.classList.contains('termSelect-options-hidden')) {
                elm.classList.remove('termSelect-options-hidden');
                var fieldSystemName = expr.Left ? expr.Left.Field : expr.Terms.Field;
                $scope.populateTermSelector(elm, $scope.getFieldBySystemName(fieldSystemName), expr);
            } else {
                elm.classList.add('termSelect-options-hidden');
            }
        }
    }

    $scope.loadCodeParameters = function (expr) {
        var element = document.getElementById("Dynamicweb.Extensibility.CodeProviderBase, Dynamicweb_AddInTypes");

        if (element != null) {
            if (element.value != expr.Right.Type) {
                element.value = expr.Right.Type;
                element.onchange();
                $scope.fillParameters(expr);
            }
            else {
                $scope.fillParameters(expr);
            }
        }
        else {
            $scope.loop($scope.loadCodeParameters, 200, expr);
        }
    }

    $scope.fillParameters = function (expr) {

        if (document.getElementById('ConfigurableAddIn_values') != null) {
            document.getElementById('ConfigurableAddIn_values').value = expr.Right.Parameters;
            var element = document.getElementById("Dynamicweb.Extensibility.CodeProviderBase, Dynamicweb_AddInTypes");
            element.onchange();
        }
        else {
            $scope.loop($scope.fillParameters, 200, expr);
        }
    }

    $scope.loop = function (callback, timeout, expr) {
        window.setTimeout(function () {
            callback(expr);
        }, timeout);
    }


    $scope.compareFields = function (viewField, field) {
        if (typeof (field.Source) != "undefined" && field.Source.startsWith("ProductCategory")) {
            return viewField.Source == field.Source && viewField.Name == (field.Group + ' - ' + field.Name);
        }
        else {
            return viewField.Source == field.Source && viewField.Name == field.Name;;
        }
    }

    $scope.compareLanguages = function (viewField, field) {
            return viewField.ID == field._LanguageId;
    };

    $scope.compareRules = function (viewRule, rule) {
        if (rule.Id) {
            return viewRule == rule.Id;
        }
        else {
            return viewRule.Id == rule;
        }
    };

    $scope.createLanguageItem = function (language) {
        //From XML
        if (language.ID) {
            return { Name: language.Name, Value: language.ID };
        }
        else {
            return { Name: language._Name, Value: language._LanguageId };
        }
    };

    $scope.createRuleItem = function (rule) {
        return { Name: rule.Name, Value: rule.Id };
    };

    $scope.createFieldItem = function (viewField, sortIndex) {
        if (typeof (viewField.Source) != "undefined" && viewField.Source.startsWith("ProductCategory")) {
            var name = viewField.Name;

            if (viewField.Source.startsWith("ProductCategory") && viewField.Group != undefined) {
                name = viewField.Group + ' - ' + viewField.Name;
            }
            return { Name: name, Value: viewField.Source, Sort: sortIndex || viewField.Sort };
        }
        else {
            return { Name: viewField.Name, Value: viewField.Source };
        }
    };

    $scope.fillSelectionBox = function (datasource, selectedObjects, controlId, compareFunction, itemCreationFunction) {
        var leftList = SelectionBox.getLeftList(controlId);
        if (!leftList) {
            return;
        }
        var left = [];
        var right = [];

        for (var i = 0; i < datasource.length; i++) {
            var filteredObjects = null;
            if (selectedObjects != null) {
                filteredObjects = selectedObjects.filter(function (e) { return compareFunction(e, datasource[i]); });
            }
            else {
                filteredObjects = [];
            }

            //Is the field already set on the query
            if (filteredObjects != null && filteredObjects.length == 0) {
                var leftItem = itemCreationFunction(datasource[i]);
                left.push(leftItem);
            }
        }

        if (selectedObjects) {
            for (var j = 0; j < selectedObjects.length; j++) {
                var datasourceObject = datasource.filter(function (e) { return compareFunction(selectedObjects[j], e);});

                if (datasourceObject[0]) {
                    var rightItem = itemCreationFunction(datasourceObject[0], selectedObjects[j].Sort);
                    rightItem.Sort = datasourceObject[0].Sort;
                    right.push(rightItem);
                }
            }
        }

        left.sort(function (a, b) {
            return a.Name == b.Name ? 0 : a.Name < b.Name ? -1 : 1;
        });

        right.sort(function (a, b) {
            return a.Sort == b.Sort ? 0 : a.Sort < b.Sort ? -1 : 1;
        });

        SelectionBox.fillLists(JSON.stringify({ left: left, right: right }), controlId);
    }

    $scope.getFieldBySystemName = function (systemName) {
        if ($scope.model.Fields != undefined) {
            for (var i = 0; i < $scope.model.Fields.length; i++) {
                var field = $scope.model.Fields[i];
                if (field.SystemName === systemName) {
                    return field;
                }
            }
        }
    }    

    $scope.usesContainsExtended = function () {
        if ($scope.query != null && $scope.query.Expression != undefined) {
            var expression = $scope.query.Expression;

            if (expression.class == "BinaryExpression") {
                return expression.Operator == "ContainsExtended";
            }

            for (var i = 0; i < expression.Expressions.length; i++) {
                if (expression.Expressions[i].Operator == "ContainsExtended") {
                    return true;
                }
            }
        }

        return false;
    }

    $scope.showTermSelector = function (expr) {

        var field = $scope.getFieldBySystemName(expr.Left.Field)

        if (field == undefined) {
            return false;
        }

        if ((field.Type == 'System.Boolean'
        || expr.Operator == 'Equal'
        || expr.Operator == 'In') && (expr.Right == undefined || (expr.Right.class == 'ConstantExpression' || expr.Right.class == 'TermExpression'))) {
            return true;
        }

        if (!expr.Right){
            return false;
        }


        if ((
        (expr.Right.class != 'ConstantExpression'
        && expr.Right.class != 'CodeExpression'
        && expr.Right.class != 'ParameterExpression'
        && expr.Right.class != 'MacroExpression'))
        && (field.Type == 'System.Boolean'
        || expr.Operator == 'Equal'
        || expr.Operator == 'In')) {
            return true;
        }

        return false;

    }

    $scope.showTextBox = function (expr) {

        if ($scope.showTermSelector(expr)) {
            return false;
        }

        if (expr.Operator && expr.Operator == 'IsEmpty') {
            return false;
        }

        if (!expr.Right || expr.Right.class == '') {
            return true;
        }

        if (expr.Right.class == 'ConstantExpression' || expr.Right.class == 'TermExpression' || expr.Right.class == 'CodeExpression') {
            return true;
        }
    }

    $scope.sortExpressionsDragStart = function (event, expr, parent) {
        event.stopPropagation();
        $scope.draggedExpression = expr;
    }

    $scope.sortExpressionsDragOver = function (event, expr) {
        event.stopPropagation();
        event.preventDefault();
    }

    $scope.sortExpressionsDrop = function (event, expr) {
        event.stopPropagation();
        var draggedExpression = $scope.draggedExpression;

        var isEmptyGroupExpression = (expr.class === 'GroupExpression' && expr.Expressions.length === 0);

        var sourceGroupExpression = Helpers.findParentGroupExpression(draggedExpression, $scope.query.Expression);
        var destinationGroupExpression = (!isEmptyGroupExpression)
            ? Helpers.findParentGroupExpression(expr, $scope.query.Expression)
            : expr;

        if (sourceGroupExpression === null || destinationGroupExpression === null) {
            console.error("Source expression or destination expression is invalid");
            return;
        }

        var fromIndex = sourceGroupExpression.Expressions.indexOf(draggedExpression);
        var toIndex = (!isEmptyGroupExpression)
            ? destinationGroupExpression.Expressions.indexOf(expr)
            : 0;

        sourceGroupExpression.Expressions.splice(fromIndex, 1);
        destinationGroupExpression.Expressions.splice(toIndex, 0, draggedExpression);

        $scope.draggedExpression = {};
    }

    $scope.toggleExpression = function (expr) {
        expr.Disabled = !expr.Disabled;
    }
});

var Helpers = (function () {
    return {
        findParentGroupExpression: function (expr, groupExpression) {
            if (groupExpression.Expressions.indexOf(expr) > -1) {
                return groupExpression;
            }

            for (var i = 0; i < groupExpression.Expressions.length; i++) {
                var candidate = groupExpression.Expressions[i];
                if (candidate.class === 'GroupExpression') {
                    return this.findParentGroupExpression(expr, candidate);
                }
            }

            return null;
        }
    };
})();