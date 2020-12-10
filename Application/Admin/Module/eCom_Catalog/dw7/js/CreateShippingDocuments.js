/// <reference path="/Admin/Images/Ribbon/UI/List/List.js"/>

(function () {
	var debug = function () {
		if ((typeof (console) != 'undefined') && (typeof (console.debug) == 'function')) {
			; ; ; console.debug.apply(console, arguments);
		}
	}

	var Order = function (orderID, columns) {
		this.orderID = orderID;
		this.columns = columns;
	},

	shippingDocumentInfoColumnIndex = 7,

	info = {
		notSupported: [],
		created: [],
		failed: []
	},
	allNotSupported = 0,
	allAlreadyCaptured = 0,
	allAttemptedCaptured = 0,
	successfulCaptures = 0,

	orderList = [],
	orderListIndex = -1,

	hideList = function () {
		$('ListPanel').hide();
		$('ProgressPanel').show();
	},

	showList = function () {
		$('ListPanel').show();
		$('ProgressPanel').hide();
	},

	startProcessing = function () {
		// hideList();

		var i, row, cols, orderId, state, order,
		rows = List.getAllRows('OrderList');

		for (i = 0; i < rows.length; i++) {
			row = rows[i],
			cols = row.select('td'),
			shippingDocumentInfoColumn = cols[shippingDocumentInfoColumnIndex],
			orderId = row.getAttribute('itemid'),
			isComplete = row.getAttribute('data-order-is-complete') == 'true',
			state = row.getAttribute('data-shipping-document-state');

			if (orderId && isComplete) {
				order = new Order(orderId, cols);
				switch (state) {
					case 'not-supported':
						if (shippingDocumentInfoColumn) {
							shippingDocumentInfoColumn.innerHTML = '<img src="/Admin/Images/Icons/Alert_Small.gif" alt="" /> ' + shippingDocumentInfoColumn.innerHTML;
						}
						break;
					case 'created':
						if (shippingDocumentInfoColumn) {
							shippingDocumentInfoColumn.innerHTML = '<img src="/Admin/Images/Ribbon/Icons/Small/Check_grey.png" alt="" /> ' + shippingDocumentInfoColumn.innerHTML;
						}
						break;
					default:
						orderList.push(order);
						break;
				}
			}
		}

		processNext();
	},

	orderProcessingTemplate = null,

	reportCount = function () {
		if (!orderProcessingTemplate) {
			orderProcessingTemplate = new Template(orderProcessingMessage);
		}
		$('CounterPanel').innerHTML = orderProcessingTemplate.evaluate({
			number: orderListIndex + 1,
			numberOfOrders: orderList.length
		});
	},

	processOrder = function (order) {
		var url = 'CreateShippingDocuments.aspx?AJAX=CreateShippingDocument&orderID=' + order.orderID;

		if (document.location.href.indexOf('force=true') > -1) {
			url += '&force=true';
		}

		allAttemptedCaptured++;
		reportCount();

		new Ajax.Request(url, {
			onSuccess: function (response) {
				var result;
				try {
					result = response.responseText.evalJSON();
				} catch (ex) {
					// alert(ex);
				}
				;;; debug('response.responseText', response.responseText);
				;;; debug('result', result);

				setComplete(order, result);
			},

			onFailure: function () {
				order.isCaptured = false;
			},

			onComplete: function () {
				processNext();
			}
		});
	},

	setComplete = function (order, result) {
		var shippingDocumentInfoColumn = order.columns[shippingDocumentInfoColumnIndex];
		switch (result.status) {
			case 'Created':
				shippingDocumentInfoColumn.innerHTML = '<img src="/Admin/Images/Ribbon/Icons/Small/Check.png" alt="" /> ' + result.messageLocalized;
				info['created'].push(order);
				break;
			default:
				info['failed'].push(order);
				shippingDocumentInfoColumn.innerHTML = '<img src="/Admin/Images/Icons/Delete_Small.gif" alt="" /> ' + result.messageLocalized;
				break;
		}
	},

	processNext = function () {
		orderListIndex++;
		if (orderListIndex < orderList.length) {
			processOrder(orderList[orderListIndex]);
		} else {
			showList();
			var template = new Template(processingCompletedMessage);
			alert(template.evaluate({
				numberOfOrders: orderList.length
			}));
		}
	}

	Event.observe(window, 'load', startProcessing);
} ());
