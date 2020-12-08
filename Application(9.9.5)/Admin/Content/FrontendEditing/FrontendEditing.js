var setPageData = function () { };
var translate = function () { };
var statusBar = {};

(function ($) {
    var pageData = null;

	var resizeContent = function () {
	    var topbar = $("#topbar");
	    var topbarHeight = topbar.height();
	    var contentWrapper = $("#content");
	    if (topbarHeight > 0) {
	        contentWrapper.css("top", topbarHeight + "px");
	    }
	};

	var setApprovalType = function () {
	    var topbar = $("#topbar");
		var approvalType = pageData && pageData.approvalType;
		topbar.removeClass("draft workflow");

		if (approvalType < 0) {
			topbar.addClass("draft");
		} else if (approvalType > 0) {
			topbar.addClass("workflow");
		}
		resizeContent();
	};

	// The real function
	setPageData = function (data) {
		pageData = data;
		setApprovalType();
	};

	translate = function (text) {
		if (typeof dwFrontendEditing.messages != 'undefined' && dwFrontendEditing.messages[text]) {
			text = dwFrontendEditing.messages[text];
		} else {
			text = '*' + text.replace(/\s+/g, '_');
		}
		return text;
	};

	statusBar = {
	    $status: null,
	    $statusContentElement: null,
		getStatusElement: function () {
		    if (!this.$status) {
		        this.$status = $("#status");
			}

		    return this.$status;
		},
		getStatusContentElement: function () {
			if (!this.$statusContentElement) {
			    this.$statusContentElement = $("#status > .content");
			}
			return this.$statusContentElement;
		},
        
		set: function (message, data) {
		    var el = this.getStatusElement(),
            content = this.getStatusContentElement();

		    if (data && message) {
		        if (data.translate) {
		            message = translate(message);
		        }
		        message = message.replace(/@([a-z]+)/i, function (text, key) {
		            return data[key];
		        });
		    }
		    content.html(message);
		    el.show();
		    el.removeClass('info');
		    el.removeClass('success');
		    el.removeClass('alert');
		    el.removeClass('error');
		    if (data && data.className) {
		        el.addClass(data.className);
		    } else {
		        el.addClass('info');
		    }
		    return this;
		},

		fade: function () {
		    var el = this.getStatusElement();
		    el.one("animationend", function () {
		        el.hide();
		        el.removeClass("fade-in-and-out");
		    });
			el.addClass("fade-in-and-out");
			return this;
		}
	};

	$(function () {
		var contentFrame = $("#contentFrame").get(0);
		resizeContent();
		$("#content").show();

		$("#btn-close").on("click", function () {
			var location = document.location;
			var url = location.href.replace(/#.*/, '');
			url = url.replace(/[?&]FrontendEditingState=[a-z]+/gi, '');
			url += (url.indexOf('?') > -1 ? '&' : '?') + 'FrontendEditingState=disable&close=true';
			document.location.href = url;
		});

		$("#toggle-editing").on("change", function () {
		    var isChecked = $(this).is(":checked");
			var location = contentFrame.contentDocument.location;
			var url = location.href.replace(/#.*/, '');
			url = url.replace(/[?&]FrontendEditingState=[a-z]+/gi, '');
			url += (url.indexOf('?') > -1 ? '&' : '?') + 'FrontendEditingState=' + (isChecked ? 'edit' : 'browse');
			statusBar.set(translate(isChecked ? 'Inline editing enabled' : 'Inline editing disabled')).fade();
			contentFrame.src = url;
		});
	});
}(jQuery));
