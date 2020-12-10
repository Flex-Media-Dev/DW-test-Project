var pageID = 0;
var loaded = false;
window.onresize = resize;

function Save() {
    var frame = document.getElementById('EditorFrame');

    if (frame) {
        frame.contentWindow.Save();
    }
}

function init(PageID) {
	pageID = PageID;
	setHeight();
	loaded = true;
}

function setHeight() {
	
	var h = (document.documentElement.clientHeight - $("myribbon").getHeight());
	if (h >= 0)
		document.getElementById("EditorFrame").style.height = h + 'px';
	//setTimeout("loaded = true;", 500);
}

function resize() {
	//alert(loaded);
	if (loaded) {
		setHeight();
	}
}

function content() {
	if (pageID != 0) {
		location = "/Admin/Content/ParagraphList.aspx?PageID=" + pageID;
	}
}
