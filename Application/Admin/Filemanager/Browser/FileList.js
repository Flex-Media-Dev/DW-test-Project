// Fires when a row is selected or deselected
function rowSelected() {
    // Use enable or disable
    var items = getSelectedRows();
    __page.checkToolbarButtons(items, items[0]);
}

function getSelectedRows() {
    var rows = new Array;
    var selectedRows = List.getSelectedRows('Files');
    if (selectedRows.length > 0) {
        for (var i = 0; i < selectedRows.length; i++) {
            rows[i] = selectedRows[i].getAttribute('itemID');
        }
        ContextMenu.callingID = selectedRows[0].getAttribute('id');
        ContextMenu.callingItemID = rows[0];
    }
    return rows;
}

/* Gets file extension */
getExtension = function (file) {
    var ext = '';
    var separatorIndex = 0;

    separatorIndex = file.lastIndexOf('.');
    if (separatorIndex >= 0 && separatorIndex < file.length - 1) {
        ext = file.substr(separatorIndex, file.length - separatorIndex);
    }

    return ext.toLowerCase();
}

function imagePopupPreview(maxWidth, maxHeight, defaultImgUrl) {
    var leftOffset = 20;
    var topOffset = 10;
    var _previewPopupEl = null;
    var _titleEl = null;
    var _popupPosLeft = 0;
    var _popupPosTop = 0;
    var _imageLoaded = null;

    var getPreviewPopup = function () {
        if (!_previewPopupEl) {
            var el = document.createElement('div');
            el.className = "image-popup";
            document.body.insert(el);
            var imgEl = new Element('img', { src: defaultImgUrl || "" });
            _previewPopupEl = el.insert(imgEl);
        }
        return _previewPopupEl;
    };

    var getTitleElement = function () {
        if (!_titleEl) {
            var popup = getPreviewPopup();
            _titleEl = document.createElement('span');
            _titleEl.className = "image-popup-title";
            popup.insert(_titleEl);
        }
        return _titleEl;
    };

    var setImage = function (imgSrc, modified, rawImageSrc) {
        var el = getPreviewPopup();
        var img = el.select("img")[0];
        if (!_imageLoaded) {
            _imageLoaded = function (e) {
                var left = _popupPosLeft + leftOffset;
                var top = _popupPosTop + topOffset;
                var srcWidth = img.width;
                var srcHeight = img.height;

                //var elDim = $(el).getDimensions();
                var ratio = Math.min(maxWidth / srcWidth, maxHeight / srcHeight);
                var w = srcWidth * ratio;
                var h = srcHeight * ratio;
                
                var title = getTitleElement();
                title.setStyle({
                    "width": w + "px"
                });

                //image + title
                h = h + title.height;
                el.setStyle({
                    "width": w + "px",
                    "height": h + "px"
                });

                var pos = correctWithViewport(el, left, top);
                el.setStyle({
                    left: pos.left + "px",
                    top: pos.top + "px"
                });
                el.style.display = 'block';
            };
            img.on("load", _imageLoaded);
        }
        if (!rawImageSrc) {
            if (imgSrc) {
                imgSrc = "/Admin/Public/GetImage.ashx?fmImage_path=" + encodeURIComponent(imgSrc) + "&Format=jpg&width=" + maxWidth + "&height=" + maxHeight + "&Crop=5&donotupscale=1&modified=" + modified;
            }else if (defaultImgUrl) {
                imgSrc = defaultImgUrl;
            } else {
                imgSrc = "";
            }
        } 
        img.writeAttribute("src", imgSrc);
    };
    
    var correctWithViewport = function (el, posLeft, posTop) {
        var vpDim = document.viewport.getDimensions(),
            vpOffset = document.viewport.getScrollOffsets(),
            elDim = $(el).getDimensions();

        if (posLeft + elDim.width > vpDim.width + vpOffset[0]) {
            posLeft -= (elDim.width + leftOffset*2);
        }

        if (posTop + elDim.height > vpDim.height + vpOffset[1]) {
            var delta = (vpDim.height + vpOffset[1]) - (posTop + elDim.height + topOffset*2);
            posTop += delta;
        }
        return {
            left: posLeft,
            top: posTop
        };
    };


    return {
        show: function (imgUrl, modified, title, rawImageSrc) {
            setImage(imgUrl, modified, rawImageSrc);
            if (title) {
                getTitleElement().innerHTML = title;
            }
        },

        setPosition: function (left, top) {
            _popupPosLeft = left;
            _popupPosTop = top;
        },

        hide: function () {
            getPreviewPopup().style.display = 'none';
            getTitleElement().innerHTML = "";
        }
    };
}