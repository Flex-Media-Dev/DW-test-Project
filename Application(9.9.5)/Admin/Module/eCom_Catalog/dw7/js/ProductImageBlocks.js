if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

Dynamicweb.ProductImageBlocks = function () {
    let self = this;
    this.imgPreviewObj = imagePopupPreview(300, 300, "/Admin/Images/eCom/missing_image.jpg");  

    this.canselShowing = false;

    this.showPopupFunction = dwGlobal.debounce(function (element) {
        let imageElement = element;
        if (!self.canselShowing) {
            let imgUrl = imageElement.readAttribute("data-image-path");
            let modified = imageElement.readAttribute("data-modified");
            let title = imageElement.readAttribute("data-title");
            let rawSrc = imageElement.readAttribute("data-external");
            let noPreview = imageElement.readAttribute("data-nopreview");
            self.canselShowing = false;
            if (!noPreview) {
                self.imgPreviewObj.show(rawSrc ? imageElement.readAttribute("src") : imgUrl, modified || "", title || "", rawSrc);
            }
        }
    }, 400);
    this.container = null;
};

Dynamicweb.ProductImageBlocks._instance = null;

Dynamicweb.ProductImageBlocks.get_current = function () {
    if (!Dynamicweb.ProductImageBlocks._instance) {
        Dynamicweb.ProductImageBlocks._instance = new Dynamicweb.ProductImageBlocks();
    }
    return Dynamicweb.ProductImageBlocks._instance;
};

Dynamicweb.ProductImageBlocks.prototype.initialize = function (options) {
    let self = this;
    self.options = options
    if (options) {   
        if (options.container) {
            let imageblockSelector = options.imageblockSelector || ".image-cnt > .image-block";
            options.container.on('mouseover', imageblockSelector, function (e, element) { self._showPreview(e, element) });
            options.container.on('mouseout', imageblockSelector, function (e, element) { self._hidePreview() });
            if (options.enableVideoPreview) {
                options.container.on('click', imageblockSelector + "[data-playable=true]", function (e, element) { self._previewVideo(e, element) });
                options.container.on('click', imageblockSelector + "[data-extension=pdf]", function (e, element) { self._previewPDF(e, element) });
            }            
        }
    }
}

Dynamicweb.ProductImageBlocks.prototype._previewPDF = function (e, element) {
    let container = document.getElementById('VideoDetailPreviewContainer');
    container.style.height = 'calc(100vh - 144px)';
    container.insertAdjacentHTML("afterbegin", '<embed id="Image" height="100%" width="100%" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html" src="' + element.getAttribute("data-image-path") + '" type="application/pdf">');    
    let dialogContainer = document.getElementById("VideoDetailPreview");
    if (dialogContainer) {
        let closeButton = dialogContainer.querySelector(".close > i");
        closeButton.addEventListener("click", function () {
            container.innerHTML = '';
            container.style.height = '';
        });
    }
    dialog.setTitle('VideoDetailPreview', this.options.previewPdfDialogTitle || "Preview");
    dialog.show("VideoDetailPreview");
}

Dynamicweb.ProductImageBlocks.prototype._previewVideo = function (e, element) {
    let container = document.getElementById('VideoDetailPreviewContainer');
    container.innerHTML = '';
    if (element.getAttribute("data-external") == 'true') {
        let playerUrl = element.getAttribute("data-embeded-url");
        container.insertAdjacentHTML("afterbegin", '<iframe src="' + playerUrl + '" frameborder="0" allow="accelerometer; autoplay; fullscreen; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>');   
    } else {
        let videoElement = document.createElement("video");
        videoElement.setAttribute("controls", "true");
        let sourceElement = document.createElement("source");
        sourceElement.setAttribute("src", element.getAttribute("data-image-path"));
        sourceElement.setAttribute("type", "video/" + element.getAttribute("data-format"));
        videoElement.appendChild(sourceElement);
        container.appendChild(videoElement);
    }
    let dialogContainer = document.getElementById("VideoDetailPreview");
    if (dialogContainer) {
        let closeButton = dialogContainer.querySelector(".close > i");
        closeButton.addEventListener("click", function () {
            container.innerHTML = '';
        });
    }
    dialog.show("VideoDetailPreview");
}

Dynamicweb.ProductImageBlocks.prototype._hidePreview = function () {    
    this.imgPreviewObj.hide();
    this.canselShowing = true;
}

Dynamicweb.ProductImageBlocks.prototype._showPreview = function (e, element) {
    let imageElement = element;
    this.imgPreviewObj.setPosition(e.pageX, e.pageY);
    this.showPopupFunction(imageElement);
    this.canselShowing = false;
}