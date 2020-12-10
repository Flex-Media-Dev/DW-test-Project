
function getQueryString() {
	return "&Type=" + Type + "&ItemID=" + ItemID + "&LangID=" + LangID + "&IsFullPage=" + IsFullPage + "&IsNewNavigator=" + IsNewNavigator;
}

function del(id) {
	if (confirm("Delete?")) {
		location = "List.aspx?Delete=" + id + getQueryString();
		return false;
	}
}

function edit(id) {
	location = "Edit.aspx?ID=" + id + getQueryString();
}

function add() {
	location = "Edit.aspx?ID=0" + getQueryString();
}

function activateDeactivateCommentByIcon(commentId) {
    var imgIcon = document.getElementById('img' + commentId);
    var activateProducts = (imgIcon.getAttribute('data-active') != 'true');

    new Ajax.Request("/Admin/Content/Comments/List.aspx?IsAjax=true&ChangeCommentActive=" + activateProducts + "&CommentID=" + commentId, {
        method: 'get',
        onSuccess: function (transport) {
            if (transport.responseText == "yes") {
                var oldState = imgIcon.getAttribute('data-active') == 'true';
                if (oldState != activateProducts) {
                    var row = List.getRowByID("CommentList", "row" + commentId);
                    if (activateProducts) {
                        row.classList.remove("dis")
                    } else {
                        row.classList.add("dis")
                    }
                    imgIcon.setAttribute('data-active', activateProducts);
                    imgIcon.setAttribute('class', imgIcon.getAttribute("data-css-state-active-" + activateProducts));
                }
            }
        },
        onFailure: function () {
            new overlay("__ribbonOverlay").hide();
        }
    });
}