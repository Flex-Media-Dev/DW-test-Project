/**
 *  Javascript handles the selection of elements in the
 *  SelectionBox
 */

var SelectionBox = new Object();

SelectionBox.getOrderPosition = function (option, list, compare) {
    if (option === undefined) return null;
    if (!compare) {
        compare = function (a, b) {
            return a.localeCompare(b);
        }
    }
    var l = 0, u = list.options.length - 1;
    while (l <= u) {
        var m = parseInt((l + u) / 2);
        switch (compare(list.options[m].text, option.text)) {
            case -1:
                var ml = m;
                l = m + 1;
                break;
            case +1:
                var mu = m;
                u = m - 1;
                break;
            default:
                u = m - 1;
        }
    }

    return l;
}

SelectionBox.insertOption = function (option, list, defaultPosition) {
    var index = defaultPosition ? undefined : SelectionBox.getOrderPosition(option, list);
    list.options.add(new Option(option.text, option.value), index);
}

SelectionBox.selectionAddSingle = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var lstRight = SelectionBox.getRightList(selectionBoxID);
    var arrIndex = new Array;

    if (lstLeft.selectedIndex != -1) {
        for (var i = 0; i < lstLeft.length; i++) {
            var option = lstLeft.options[i];
            if (option.selected) {
                SelectionBox.insertOption(option, lstRight);
                arrIndex.push(i);
            }
        }
        var length = arrIndex.length;
        for (var i = 0; i < length; i++) {
            lstLeft.remove(arrIndex.pop());
        }


        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);

        if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
            eval(selectionBoxID + "_onChange")();
        }
    }
}

SelectionBox.selectionAddAll = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var lstRight = SelectionBox.getRightList(selectionBoxID);

    if (SelectionBox.listHaveEditableOptions(lstLeft)) {
        for (var i = 0; i < lstLeft.length; i++) {
            var option = lstLeft.options[i];
            SelectionBox.insertOption(option, lstRight, true);
        }
        lstLeft.length = 0;

        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);

        if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
            eval(selectionBoxID + "_onChange")();
        }
    } else if (lstLeft.length == 0) {
        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);
    }
}

SelectionBox.selectionRemoveSingle = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var lstRight = SelectionBox.getRightList(selectionBoxID);
    var arrIndex = new Array;

    if (lstRight.selectedIndex != -1) {
        for (var i = 0; i < lstRight.length; i++) {
            var option = lstRight.options[i];
            if (option.selected) {
                SelectionBox.insertOption(option, lstLeft);
                arrIndex.push(i);
            }
        }
        var length = arrIndex.length;
        for (var i = 0; i < length; i++) {
            lstRight.remove(arrIndex.pop());
        }


        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);

        if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
            eval(selectionBoxID + "_onChange")();
        }
    }
}

SelectionBox.selectionRemoveAll = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var lstRight = SelectionBox.getRightList(selectionBoxID);

    if (SelectionBox.listHaveEditableOptions(lstRight)) {
        for (var i = 0; i < lstRight.length; i++) {
            var option = lstRight.options[i];
            SelectionBox.insertOption(option, lstLeft, true);
        }
        lstRight.length = 0;

        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);

        if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
            eval(selectionBoxID + "_onChange")();
        }
    } else if (lstRight.length == 0) {
        SelectionBox.setNoDataLeft(selectionBoxID);
        SelectionBox.setNoDataRight(selectionBoxID);
    }
}

SelectionBox.selectionMoveUpLeft = function (selectionBoxID) {
    var lst = SelectionBox.getLeftList(selectionBoxID);

    var iSelected = 0;
    for (var i = 0; i < lst.length; i++) {
        if (lst.options[i].selected) {
            if (i != iSelected) {
                var selectedOption = new Option(lst.options[i].text, lst.options[i].value);
                var movedOption = new Option(lst.options[i - 1].text, lst.options[i - 1].value);
                try {
                    lst.options[i] = movedOption;
                    lst.options[i - 1] = selectedOption;
                    lst.options[i - 1].selected = true;
                } catch (e) {
                }
            }
            iSelected++;
        }
    }

    if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
        eval(selectionBoxID + "_onChange")();
    }
}

SelectionBox.selectionMoveDownLeft = function (selectionBoxID) {
    var lst = SelectionBox.getLeftList(selectionBoxID);

    var iSelected = lst.length - 1;
    for (var i = lst.length - 1; i >= 0; i--) {
        if (lst.options[i].selected) {
            if (i != iSelected) {
                var selectedOption = new Option(lst.options[i].text, lst.options[i].value);
                var movedOption = new Option(lst.options[i + 1].text, lst.options[i + 1].value);
                try {
                    lst.options[i + 1] = selectedOption;
                    lst.options[i] = movedOption;
                    lst.options[i + 1].selected = true;
                } catch (e) {
                }
            }
            iSelected--;
        }
    }

    if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
        eval(selectionBoxID + "_onChange")();
    }
}

SelectionBox.selectionMoveUpRight = function (selectionBoxID) {
    var lst = SelectionBox.getRightList(selectionBoxID);

    var iSelected = 0;
    for (var i = 0; i < lst.length; i++) {
        if (lst.options[i].selected) {
            if (i != iSelected) {
                var selectedOption = new Option(lst.options[i].text, lst.options[i].value);
                var movedOption = new Option(lst.options[i - 1].text, lst.options[i - 1].value);
                try {
                    lst.options[i] = movedOption;
                    lst.options[i - 1] = selectedOption;
                    lst.options[i - 1].selected = true;
                } catch (e) {
                }
            }
            iSelected++;
        }
    }

    if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
        eval(selectionBoxID + "_onChange")();
    }
}

SelectionBox.selectionMoveDownRight = function (selectionBoxID) {
    var lst = SelectionBox.getRightList(selectionBoxID);

    var iSelected = lst.length - 1;
    for (var i = lst.length - 1; i >= 0; i--) {
        if (lst.options[i].selected) {
            if (i != iSelected) {
                var selectedOption = new Option(lst.options[i].text, lst.options[i].value);
                var movedOption = new Option(lst.options[i + 1].text, lst.options[i + 1].value);
                try {
                    lst.options[i + 1] = selectedOption;
                    lst.options[i] = movedOption;
                    lst.options[i + 1].selected = true;
                } catch (e) {
                }
            }
            iSelected--;
        }
    }

    if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
        eval(selectionBoxID + "_onChange")();
    }
}

SelectionBox.getElementsRightAsArray = function (selectionBoxID) {
    var lstRight = SelectionBox.getRightList(selectionBoxID);
    var arr = new Array();

    if (SelectionBox.listHaveEditableOptions(lstRight)) {
        arr[0] = lstRight.options[0].value;
        for (var i = 1; i < lstRight.length; i++) {
            arr[i] = lstRight.options[i].value;
        }
    }

    return arr;
}

SelectionBox.getElementsRightAsOptionArray = function (selectionBoxID) {
    var lstRight = SelectionBox.getRightList(selectionBoxID);
    var arr = new Array();

    if (SelectionBox.listHaveEditableOptions(lstRight)) {
        arr[0] = lstRight.options[0];
        for (var i = 1; i < lstRight.length; i++) {
            arr[i] = lstRight.options[i];
        }
    }

    return arr;
}

SelectionBox.getElementsLeftAsArray = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var arr = new Array();

    if (SelectionBox.listHaveEditableOptions(lstLeft)) {
        arr[0] = lstLeft.options[0].value;
        for (var i = 1; i < lstLeft.length; i++) {
            arr[i] = lstLeft.options[i].value;
        }
    }

    return arr;
}

SelectionBox.getElementsLeftAsOptionArray = function (selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var arr = new Array();

    if (SelectionBox.listHaveEditableOptions(lstLeft)) {
        arr[0] = lstLeft.options[0];
        for (var i = 1; i < lstLeft.length; i++) {
            arr[i] = lstLeft.options[i];
        }
    }

    return arr;
}

SelectionBox.listHaveEditableOptions = function (list) {
    return list == null ? false : list.length > 1 || (list.length == 1 && !list.options[0].disabled)
}

SelectionBox.getLeftList = function (selectionBoxID) {
    var lstLeft = document.getElementById(selectionBoxID + "_lstLeft");
    return lstLeft;
}

SelectionBox.getRightList = function (selectionBoxID) {
    var lstRight = document.getElementById(selectionBoxID + "_lstRight");
    return lstRight;
}

SelectionBox.fillLists = function (result, selectionBoxID) {
    var lstLeft = SelectionBox.getLeftList(selectionBoxID);
    var lstRight = SelectionBox.getRightList(selectionBoxID);

    //Clean up the lists
    lstLeft.length = 0;
    lstRight.length = 0;

    var lists = eval('(' + result + ')');

    for (var i = 0; i < lists.left.length; i++) {
        var listItem = lists.left[i]
        var option;

        if (typeof (listItem) == 'object') {
            option = new Option(listItem.Name, listItem.Value);
        }
        else {
            option = new Option(listItem, listItem);
        }

        lstLeft.options.add(option);

    }
    for (var i = 0; i < lists.right.length; i++) {
        var listItem = lists.right[i]

        var option;

        if (typeof (listItem) == 'object') {
            option = new Option(listItem.Name, listItem.Value);
        }
        else {
            option = new Option(listItem, listItem);
        }

        lstRight.options.add(option);
    }

    SelectionBox.setNoDataLeft(selectionBoxID);
    SelectionBox.setNoDataRight(selectionBoxID);

    if (typeof (eval(selectionBoxID + "_onChange")) == 'function') {
        eval(selectionBoxID + "_onChange")();
    }
}

SelectionBox.getListItems = function (url, selectionBoxID) {
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function (request) {
            SelectionBox.fillLists(request.responseText, selectionBoxID);
        }
    });
}

SelectionBox.setNoDataLeft = function (selectionBoxID) {
    var noDataTextVariable = selectionBoxID + "_lstLeft_no_data_text";
    if (window[noDataTextVariable]) {
        var lst = document.getElementById(selectionBoxID + '_lstLeft');
        if (lst.options.length == 0) {
            lst.options.add(new Option(eval(selectionBoxID + "_lstLeft_no_data_text"), selectionBoxID + "_lstLeft_no_data"));
            lst.options[0].disabled = true;
        } else {
            for (var i = 0; i < lst.options.length; i++) {
                if (lst.options[i].value == selectionBoxID + "_lstLeft_no_data") {
                    lst.remove(i);
                }
            }
        }
    }
}

SelectionBox.setNoDataRight = function (selectionBoxID) {
    var noDataTextVariable = selectionBoxID + "_lstRight_no_data_text";
    if (window[noDataTextVariable]) {
        var lst = document.getElementById(selectionBoxID + '_lstRight');
        if (lst.options.length == 0) {
            lst.options.add(new Option(eval(noDataTextVariable), selectionBoxID + "_lstRight_no_data"));
            lst.options[0].disabled = true;
        } else {
            for (var i = 0; i < lst.options.length; i++) {
                if (lst.options[i].value == selectionBoxID + "_lstRight_no_data") {
                    lst.remove(i);
                }
            }
        }
    }
}

SelectionBox.filterLeftSelection = function (input, selectionBoxID) {
    var lst = document.getElementById(selectionBoxID + '_lstLeft');
    SelectionBox.filterSelection(input, lst);
}

SelectionBox.filterRightSelection = function (input, selectionBoxID) {
    var lst = document.getElementById(selectionBoxID + '_lstRight');
    SelectionBox.filterSelection(input, lst);
}

SelectionBox.filterSelection = function (input, selectionBox) {
    if (input && selectionBox && selectionBox.options && selectionBox.options.length > 0) {
        for (var i = 0; i < selectionBox.options.length; i++) {
            var option = selectionBox.options[i];
            option.style.display = (!input.value || option.text.toLowerCase().indexOf(input.value.toLowerCase()) != -1) ? "" : "none";
        }
    }
}