/// <reference path="/Admin/Resources/js/layout/Actions.js" />

var Action = Action || {};
Action.Submit = Action.Submit || function (action) {
    if (action.ShowOverlay) {
        Action.showCurrentDialogLoader();
    }
    window.document.forms[0].submit();
};

Action.Cancel = Action.Cancel || function (action) {
    Action.Execute({ Name: 'CloseDialog' });
};

Action.Select = Action.Select || function (action) {

};

Action.ModalResult = Action.ModalResult || function (action) {
    var _action = Action._getCurrentDialogAction();
    var _model = Action._getCurrentDialogModel();
    var _opener = Action._getCurrentDialogOpener();
    var nextAction = null;

    if (_action) {
        if (action.Result === "Submitted") {
            nextAction = _action.OnSubmitted;
        }

        if (action.Result === "Rejected") {
            nextAction = _action.OnRejected;
        }

        if (action.Result === "Cancelled") {
            nextAction = _action.OnCancelled;
        }

        if (action.Result === "Selected") {
            nextAction = _action.OnSelected;
        }
    }
    if (!nextAction || nextAction.Name != "OpenDialog") {
        Action.Execute({ Name: 'CloseDialog' });
    }

    if (nextAction) {
        _opener.Action.Execute(nextAction, action.Model || _model);
    }
};