(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define(['chartist'], function (chartist) {
            return (root.returnExportsGlobal = factory(chartist));
        });
    } else if (typeof exports === 'object') {
        module.exports = factory(require('chartist'));
    } else {
        root['Chartist.plugins.chartLegend'] = factory(root.Chartist);
    }
}(this, function (Chartist) {
    /**
     * This Chartist plugin creates a legend to show next to the chart.
     *
     */
    'use strict';

    var defaultOptions = {
        className: '',
        labelInterpolationFnc: null,
        position: 'left'
    };

    Chartist.plugins = Chartist.plugins || {};

    Chartist.plugins.chartLegend = function (options) {

        options = Chartist.extend({}, defaultOptions, options);

        var createSvgRect = function (gridGroup, chartRect, className, eventEmitter) {
            var gridBackground = gridGroup.elem('rect', {
                x: chartRect.x1,
                y: chartRect.y2,
                width: chartRect.width(),
                height: chartRect.height(),
            }, className, true);

            // Event for grid background draw
            eventEmitter.emit('draw', {
                type: 'gridBackground',
                group: gridGroup,
                element: gridBackground
            });
        };

        return function (chart) {
            var existingLegendElement = chart.container.querySelector('.ct-legend');
            if (existingLegendElement) {
                existingLegendElement.parentNode.removeChild(existingLegendElement);
            }

            var legendElement = document.createElement('ul');
            legendElement.className = 'ct-legend';
            legendElement.classList.add('ct-legend-' + options.position);

            if (typeof options.className === 'string' && options.className.length > 0) {
                legendElement.classList.add(options.className);
            }

            var getLabel = options.labelInterpolationFnc || function (legend) {
                return legend;
            };

            var isPieChart = chart instanceof Chartist.Pie;

            var legends = chart.data.legends || chart.data.labels || [];
            legends.forEach(function (legend, i) {
                if (chart.options.ignoreEmptyValues) {
                    if (!chart.data.series[i].value) {
                        return;
                    }
                }
                var lbl = getLabel(legend, i, chart);
                var li = document.createElement('li');
                legendElement.appendChild(li);
                var blockSize = "18px";
                var svg = Chartist.createSvg(li, blockSize, blockSize, 'color-block');
                svg._node.removeAttribute("xmlns:ct")
                var blockRect = Chartist.createChartRect(svg, { chartPadding: 0, width: blockSize, height: blockSize });
                createSvgRect(svg, blockRect, (isPieChart ? "ct-slice-pie ct-legend-rect" : "ct-line ct-legend-rect"), chart.eventEmitter);
                li.className = chart.options.classNames.series + '-' + Chartist.alphaNumerate(i);
                var span = document.createElement('span');
                span.appendChild(document.createTextNode(lbl));
                li.appendChild(span);
                
            });
            chart.on('created', function (data) {
                switch (options.position) {
                    case 'bottom':
                        chart.container.insertBefore(legendElement, null);
                        break;
                    default:
                        chart.container.insertBefore(legendElement, chart.container.childNodes[0]);
                        break;
                }
            });
        };

    };

    return Chartist.plugins.chartLegend;
}));
