/**
 * Chartist.js plugin to display a data label on top of the points in a line chart.
 *
 */
/* global Chartist */
(function (window, document, Chartist) {
    'use strict';

    var defaultOptions = {
        currency: undefined,
        currencyFormatCallback: undefined,
        tooltipOffset: {
            x: 0,
            y: -20
        },
        anchorToPoint: false,
        appendToBody: false,
        class: undefined,
        pointClass: 'ct-point',
        snapToGridLineClass: 'ct-snap-to-grid-line',
        snapToGrid: true,
        nearestPointDistance: 40
    };

    Chartist.plugins = Chartist.plugins || {};
    Chartist.plugins.tooltip = function (options) {
        options = Chartist.extend({}, defaultOptions, options);

        return function tooltip(chart) {
            var tooltipSelector = options.pointClass;
            if (chart instanceof Chartist.Bar) {
                tooltipSelector = 'ct-bar';
            } else if (chart instanceof Chartist.Pie) {
                // Added support for donut graph
                if (chart.options.donut) {
                    tooltipSelector = 'ct-slice-donut';
                } else {
                    tooltipSelector = 'ct-slice-pie';
                }
            }

            var $chart = chart.container;
            // when appendToBody is passed then we need to check if there are any tooltips in the document else
            // divs were being created for every instance                       
            var $toolTip = !options.appendToBody ? $chart.querySelector('.chartist-tooltip') : document.querySelector('.chartist-tooltip');
            if (!$toolTip) {
                $toolTip = document.createElement('div');
                $toolTip.className = (!options.class) ? 'chartist-tooltip' : 'chartist-tooltip ' + options.class;
                if (!options.appendToBody) {
                    $chart.appendChild($toolTip);
                } else {
                    document.body.appendChild($toolTip);
                }
            }
            var height = $toolTip.offsetHeight;
            var width = $toolTip.offsetWidth;
            var chartRect = {};
            var isMouseDown = false;

            hide($toolTip);

            chart.on('created', function (context) {
                chartRect = context.chartRect;
            });

            function on(event, selector, callback) {
                $chart.addEventListener(event, function (e) {
                    if (!selector || hasClass(e.target, selector))
                        callback(e);
                });
            }            

            on('mouseover', tooltipSelector, function (event) {
                showTooltip(event);
            });

            on('mouseout', tooltipSelector, function () {
                hide($toolTip);
            });

            on('mousemove', null, function (event) {
                if (false === options.anchorToPoint && !isMouseDown && isShowed($toolTip)) {
                    setPosition(event);
                } else if (isMouseDown) {
                    anchorToNearestPoint(event);
                }               
            });

            on('mousedown', null, function (event) {
                var svgElement = $chart.querySelector('svg:not(.color-block)');
                if (event.which == 1 && svgElement.contains(event.target) && !hasClass(event.target, 'ct-label')) {
                    isMouseDown = true;
                    anchorToNearestPoint(event);
                }
            });

            on('mouseup', null, function (event) {
                if (event.which == 1) {
                    isMouseDown = false;
                    hide($toolTip);
                    removeSnapToXLine();
                }
            });

            function setPosition(event, target) {
                target = target ? target : event.target;
                height = height || $toolTip.offsetHeight;
                width = width || $toolTip.offsetWidth;
                var offsetX = -width / 2 + options.tooltipOffset.x;
                var offsetY = -height + options.tooltipOffset.y;
                var anchorX, anchorY, left, top;

                if (!options.appendToBody || !event) {
                    var box = $chart.getBoundingClientRect();
                    if (event) {
                        left = event.pageX - box.left - window.pageXOffset;
                        top = event.pageY - box.top - window.pageYOffset;
                    }
                    if ((true === options.anchorToPoint || !event) && target.x2 && target.y2) {
                        anchorX = parseInt(target.x2.baseVal.value);
                        anchorY = parseInt(target.y2.baseVal.value);
                    }

                    $toolTip.style.top = (anchorY || top) + offsetY + 'px';
                    $toolTip.style.left = (anchorX || left) + offsetX + 'px';
                } else {
                    $toolTip.style.top = event.pageY + offsetY + 'px';
                    $toolTip.style.left = event.pageX + offsetX + 'px';
                }
            }

            function showTooltip(event, target) {
                var $point = target ? target : event.target;
                var tooltipText = '';

                var isPieChart = (chart instanceof Chartist.Pie) ? $point : $point.parentNode;
                var seriesName = (isPieChart) ? $point.parentNode.getAttribute('ct:meta') || $point.parentNode.getAttribute('ct:series-name') : '';
                var meta = $point.getAttribute('ct:meta') || seriesName || '';
                var hasMeta = !!meta;
                var value = $point.getAttribute('ct:value');

                if (options.transformTooltipTextFnc && typeof options.transformTooltipTextFnc === 'function') {
                    value = options.transformTooltipTextFnc(value);
                }

                if (options.tooltipFnc && typeof options.tooltipFnc === 'function') {
                    tooltipText = options.tooltipFnc(meta, value);
                } else {
                    if (options.metaIsHTML) {
                        var txt = document.createElement('textarea');
                        txt.innerHTML = meta;
                        meta = txt.value;
                    }

                    meta = '<span class="chartist-tooltip-meta">' + meta + '</span>';

                    if (hasMeta) {
                        tooltipText += meta + '<br>';
                    } else {
                        // For Pie Charts also take the labels into account
                        // Could add support for more charts here as well!
                        if (chart instanceof Chartist.Pie) {
                            var label = next($point, 'ct-label');
                            if (label) {
                                tooltipText += text(label) + '<br>';
                            }
                        }
                    }

                    //get the name of current series class
                    var seriesClassName;

                    for (var i = 0; i < $point.parentNode.classList.length; i++) {
                        if ($point.parentNode.classList[i].includes('ct-series-')) {
                            seriesClassName = $point.parentNode.classList[i];
                            break;
                        }
                    }

                    if (seriesClassName) {
                        var legendElement = $chart.querySelector('.ct-legend .' + seriesClassName);
                        if (legendElement) {
                            //copy legend information
                            legendElement = legendElement.cloneNode(true);
                            legendElement.querySelector('svg + span').innerText += ':';

                            tooltipText += '<div class="ct-tooltip-legend ' + seriesClassName + '" >' + legendElement.innerHTML + '</div>';
                        }
                    }

                    if (value) {
                        if (options.currency) {
                            if (options.currencyFormatCallback != undefined) {
                                value = options.currencyFormatCallback(value, options);
                            } else {
                                value = options.currency + value.replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, '$1,');
                            }
                        }
                        value = '<span class="chartist-tooltip-value">' + value + '</span>';
                        tooltipText += value;
                    }
                }

                if (tooltipText) {
                    $toolTip.innerHTML = tooltipText;

                    // Calculate new width and height, as toolTip width/height may have changed with innerHTML change
                    height = $toolTip.offsetHeight;
                    width = $toolTip.offsetWidth;

                    setPosition(event, target);
                    show($toolTip);

                    // Remember height and width to avoid wrong position in IE
                    height = $toolTip.offsetHeight;
                    width = $toolTip.offsetWidth;
                }
            }

            function anchorToNearestPoint(event) {
                if (!(chart instanceof Chartist.Line) || !options.snapToGrid) return;

                //try to get the nearest point to user cursor
                var nearestPoint = getNearestPoint(event.pageX); 

                //show the line which is snapped to X axis
                addSnapToXLine(event, nearestPoint);  

                if (nearestPoint) {
                    //show the tooltip related with this graph point
                    showTooltip(null, nearestPoint);                  
                } else {
                    //if no one point found, hide the tooltip.
                    hide($toolTip);
                }
            }

            function getNearestPoint(pageX) {
                var nearestPoint;
                var left = pageX;

                if (!options.appendToBody) {
                    left = pageX - $chart.getBoundingClientRect().left - window.pageXOffset;
                }             

                var pointsArray = $chart.querySelectorAll('.ct-point');
                pointsArray.forEach(function (point) {
                    //check that point hasn't 0 or empty value
                    if (parseInt(point.getAttribute('ct:value'))) {
                        var pointX = parseInt(point.x2.baseVal.value);
                        if (Math.abs(left - pointX) <= options.nearestPointDistance && (!nearestPoint || pointX < nearestPoint.x2.baseVal.value)) {
                            nearestPoint = point;
                        }
                    }
                });              

                return nearestPoint;
            }

            function addSnapToXLine(event, anchorPoint) {
                var pointX;

                if (!anchorPoint) {
                    pointX = event.pageX;

                    if (!options.appendToBody) {
                        pointX = event.pageX - $chart.getBoundingClientRect().left - window.pageXOffset;
                        if (pointX < chartRect.x1) {
                            pointX = chartRect.x1;
                        }
                        if (pointX > chartRect.x2) {
                            pointX = chartRect.x2;
                        }
                    }
                }

                removeSnapToXLine();

                //add the line which is snapped to X axis
                var lineElement = new Chartist.Svg('line', {
                    x1: anchorPoint ? anchorPoint.x1.baseVal.value : pointX,
                    x2: anchorPoint ? anchorPoint.x2.baseVal.value : pointX,
                    y1: chartRect.y1,
                    y2: chartRect.y2
                }, options.snapToGridLineClass);
                chart.svg.append(lineElement);
            }

            function removeSnapToXLine() {
                var lineElement = $chart.querySelector('.' + options.snapToGridLineClass);
                if (lineElement) {
                    lineElement.remove();
                }     
            }
        }
    };

    function show(element) {
        if (!isShowed(element)) {
            element.className = element.className + ' tooltip-show';
        }
    }

    function hide(element) {
        if (isShowed(element)) {
            var regex = new RegExp('tooltip-show' + '\\s*', 'gi');
            element.className = element.className.replace(regex, '').trim();
        }
    }

    function isShowed(element) {
        return hasClass(element, 'tooltip-show');
    }

    function hasClass(element, className) {
        return (' ' + element.getAttribute('class') + ' ').indexOf(' ' + className + ' ') > -1;
    }

    function next(element, className) {
        do {
            element = element.nextSibling;
        } while (element && !hasClass(element, className));
        return element;
    }

    function text(element) {
        return element.innerText || element.textContent;
    }

}(window, document, Chartist));
