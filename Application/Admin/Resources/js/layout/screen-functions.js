/*
* Layout Screen
*/

$(document).ready(function () {
    var resizeFunction = function () {
        if ($('body').innerWidth() < 768) {
            $('body').addClass('label-top');

            $('body').find('.responsive-table-list-off').addClass('responsive-table-list');
        } else {
            $('body').removeClass('label-top');

            $('body').find('.responsive-table-list-off').removeClass('responsive-table-list');
        }
    };
    $(window).on("resize", dwGlobal.debounce(resizeFunction, 250));

    /*
    * Set the area color
    */
    var areaColor = $(parent.document).find('#sidebar').attr("class");
    if (areaColor !== "") {
        $('body').removeClass('area-blue').addClass(areaColor);
    }

    /*
     * Set the deffined input control layout
     */
    SetInputLayout();

    /*
     * Dropdown Menu
     */
    if ($('.dropdown')[0]) {
        //Propagate
        $('body').on('click', '.dropdown.open .dropdown-menu', function (e) {
            e.stopPropagation();
        });

        $('.dropdown').on('shown.bs.dropdown', function (e) {
            if ($(this).attr('data-animation')) {
                $animArray = [];
                $animation = $(this).data('animation');
                $animArray = $animation.split(',');
                $animationIn = 'animated ' + $animArray[0];
                $animationOut = 'animated ' + $animArray[1];
                $animationDuration = '';
                if (!$animArray[2]) {
                    $animationDuration = 500; //if duration is not defined, default is set to 500ms
                }
                else {
                    $animationDuration = $animArray[2];
                }

                $(this).find('.dropdown-menu').removeClass($animationOut);
                $(this).find('.dropdown-menu').addClass($animationIn);
            }
        });

        $('.dropdown').on('hide.bs.dropdown', function (e) {
            if ($(this).attr('data-animation')) {
                e.preventDefault();
                $this = $(this);
                $dropdownMenu = $this.find('.dropdown-menu');

                $dropdownMenu.addClass($animationOut);
                setTimeout(function () {
                    $this.removeClass('open');

                }, $animationDuration);
            }
        });
    }

    /*
     * Waves Animation
     */
    (function () {
        var wavesList = ['.btn'];

        for (var x = 0; x < wavesList.length; x++) {
            if ($(wavesList[x])[0]) {
                if ($(wavesList[x]).is('a')) {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect waves-button');
                }
                else {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect');
                }
            }
        }

        setTimeout(function () {
            if ($('.waves-effect')[0]) {
                Waves.displayEffect();
            }
        });
    })();
});



/*
* DW8 Dialog, Pop-ups and Modals
*/

dialog = {};

dialog.show = function (dialogId) {
    $(("#" + dialogId)).css('display', 'block');
    $(("#" + dialogId)).addClass('in');
    $('body').addClass('modal-open overflow-x');

    $('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
};

dialog.showAt = function (dialogId) {
    $(("#" + dialogId)).css('display', 'block');
    $(("#" + dialogId)).addClass('in');
    $('body').addClass('modal-open overflow-x');

    $('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
};

dialog.hide = function (dialogId) {
    $(("#" + dialogId)).css('display', 'none');
    $(("#" + dialogId)).removeClass('in');
    $('body').removeClass('modal-open overflow-x');

    $('#dark-overlay').remove();

    return false;
};

dialog.setTitle = function (dialogId, newTitle) {
    if ($('#T_' + dialogId)) {
        $('#T_' + dialogId).text(newTitle);
    }
};

dialog.getTitle = function (dialogId) {
    return $('#T_' + dialogId).html();
};

/*
* DW8 Bootstrap vs. Prototype fix
*/
var ppt = window.Prototype;
if (ppt && ppt.BrowserFeatures && ppt.BrowserFeatures.ElementExtensions) {
    var disablePrototypeJS = function (method, pluginsToDisable) {
        var handler = function (event) {
            event.target[method] = undefined;
            setTimeout(function () {
                delete event.target[method];
            }, 0);
        };
        pluginsToDisable.each(function (plugin) {
            jQuery(window).on(plugin.replace("{0}", method), handler);
        });
    },

        pluginsToDisable = ["{0}.bs.collapse", "{0}.bs.dropdown", "{0}.bs.modal", "{0}.bs.tooltip", "{0}.bs.popover", "{0}.bs.tab", "dp.{0}"/*bootstrap-datetimepicker.js*/];
    disablePrototypeJS('show', pluginsToDisable);
    disablePrototypeJS('hide', pluginsToDisable);
}


/*
* Layout switcher
*/

function SwitchLayout(layouttype) {
    $('body').attr("id", layouttype + "-layout");
}

function SetInputLayout() {
    if (localStorage.getItem('input-layout') === "boxed" || localStorage.getItem('input-layout') === null) {
        $('body').addClass('boxed-fields');
    } else {
        $('body').addClass('material-fields');
    }

    if (localStorage.getItem('interface-layout') === "material" || localStorage.getItem('interface-layout') === null) {
        $('body').attr('id', 'material-layout');
    } else {
        $('body').attr('id', 'flemming-layout');
    }

    if (localStorage.getItem('columns-layout') !== "material" && localStorage.getItem('columns-layout') !== null) {
        $('body').addClass('column-boxes');
    }
}

function chartTooltipMergesHorizontally(chartEl, currentMeta, currentValue) {
    let evt = event;
    let pointEl = evt.target;
    const pointIndex = [...pointEl.parentNode.querySelectorAll("line")].indexOf(pointEl);
    let legends = $(".ct-legend li", chartEl);
    let chartObj = chartEl.data("chart");
    let series = chartObj.data.series;
    let tooltip = series.reduce((accomuilator, s, index) => {
        let pointData = s[pointIndex];
        let legendElement = null;
        if (legends.length) {
            legendElement = legends[index].cloneNode(true);
        }
        let meta = pointData ? pointData.meta : 'N\A';
        let val = pointData ? pointData.value : 'N\A';
        let text = meta + " : " + val;
        if (legendElement) {
            legendElement.querySelector('svg + span').innerText = text;
            return accomuilator + "<div class='ct-tooltip-legend " + legendElement.classList + "'>" + legendElement.innerHTML + "</div><br />";
        }
        else {
            return accomuilator + "<div class='ct-tooltip-legend'>" + text + "</div><br />";
        }
    }, "");
    return "<div class='text-left'>" + tooltip + "</div>";
}

document.addEventListener("DOMContentLoaded", function (event) {
    var buttons = document.getElementsByClassName("groupbox-button-collapse");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function () {
            var elm = this;
            var collapsedContent = elm.parentNode.getElementsByClassName("groupbox-content")[0];
            collapsedContent.classList.toggle('collapsed');

            elm.getElementsByClassName("groupbox-icon-collapse")[0].classList.toggle('fa-minus');
            elm.getElementsByClassName("groupbox-icon-collapse")[0].classList.toggle('fa-plus');

            if (elm.getElementsByClassName("gbSubtitle")[0]) {
                elm.getElementsByClassName("gbSubtitle")[0].classList.toggle('hidden');
            }

            // Save group box collapsed state to PersonalSettings        
            var postBackId = document.querySelectorAll('input[id*=' + elm.parentNode.parentNode.id + ']')[0];
            if (postBackId) {
                var id = postBackId.id;
                $.ajax({
                    type: 'POST',
                    data: {
                        __EVENTTARGET: id || "",
                        __EVENTARGUMENT: "Collapsed:" + collapsedContent.hasClassName("collapsed")
                    }
                });
            }
        };
    }

    function GetLongestLabel(labels) {
        var longestLabel = 0;
        for (var i = 0; i < labels.length; i++) {
            var label = labels[i];
            var length = label.length;
            if (length > longestLabel) {
                longestLabel = length;
            }
        }
        return longestLabel;
    }

    function createChartTooltipPluginOptions(chartEl, tooltipOpts) {
        let tooltipOptions = {
            tooltipOffset: {
                x: 0,
                y: -10
            }
        };
        if (tooltipOpts) {
            tooltipOptions.tooltipOffset.x = tooltipOpts.OffsetX || tooltipOptions.tooltipOffset.x;
            tooltipOptions.tooltipOffset.y = tooltipOpts.OffsetY || tooltipOptions.tooltipOffset.y;
            if (tooltipOpts.MergeHorizontally) {
                tooltipOptions.tooltipFnc = (meta, val) => chartTooltipMergesHorizontally(chartEl, meta, val);
            }
        }
        return tooltipOptions;
    }

    var initChart = function (chartCnt, chartData, undefined) {
        chartData = chartData || {};
        var chartType = chartData.chartType || chartCnt.data("type") || "Line";
        var strokeColor = chartData.strokeColor || chartCnt.data("stroke-color");
        var tooltipOpts = chartData.tooltip;
        var options = {};
        var chartEl = chartCnt.find(".ct-chart");
        if (!chartData.data) {
            chartData.data = chartEl.data("data") || {};
        }
        if (!tooltipOpts) {
            tooltipOpts = chartEl.data("tooltip") || {};
        }
        var responsiveOptions = null;
        var legendsCount = 0;
        if (chartData.data.legends) {
            legendsCount = chartData.data.legends.length;
        }

        var dataSeriesCount = 0;
        if (chartData.data.multiSeries) {
            dataSeriesCount = chartData.data.multiSeries[0].length;
        } else {
            dataSeriesCount = chartData.data.series.length;
        }
        if (legendsCount === 0) {
            legendsCount = 1;
        }
        var availableWidth = $(chartEl).width();
        var barsOnGraph = legendsCount * dataSeriesCount;
        var spacing;
        if (barsOnGraph > availableWidth / 3 * 2) {
            spacing = 1;
        } else if (barsOnGraph > availableWidth / 3) {
            spacing = 2;
        } else if (barsOnGraph > availableWidth / 7) {
            spacing = 4;
        } else if (barsOnGraph > availableWidth / 10) {
            spacing = 6;
        } else if (barsOnGraph > availableWidth / 14) {
            spacing = 8;
        } else if (barsOnGraph > availableWidth / 18) {
            spacing = 10;
        } else if (barsOnGraph > availableWidth / 22) {
            spacing = 12;
        } else if (barsOnGraph > availableWidth / 26) {
            spacing = 16;
        } else if (barsOnGraph > availableWidth / 30) {
            spacing = 18;
        } else if (barsOnGraph > availableWidth / 36) {
            spacing = 20;
        } else if (barsOnGraph > availableWidth / 40) {
            spacing = 22;
        } else if (barsOnGraph > availableWidth / 44) {
            spacing = 24;
        } else if (barsOnGraph > availableWidth / 48) {
            spacing = 26;
        } else if (barsOnGraph > availableWidth / 52) {
            spacing = 28;
        } else {
            spacing = 30;
        }

        if (chartType === "Funnel") {
            showFunnelChart();
            return;
        }

        if (chartType !== "Pie") {
            if (chartData.data.multiSeries) {
                chartData.data.series = chartData.data.multiSeries;
            }
            else if (chartData.data.series) {
                var arr = [];
                arr.push(chartData.data.series);
                chartData.data.series = arr;
            }
            chartData.data.series = chartData.data.series.map(transformSeriesArray);

            if (Chartist.plugins && Chartist.plugins.chartLegend && chartData.data.legends) {
                let chartPadding = {};
                switch (chartData.data.legendPosition) {
                    case 'top':
                        chartPadding = { top: 26 };
                        break;
                    case 'bottom':
                        chartPadding = { bottom: 26 };
                        break;
                    case 'left':
                        chartPadding = { left: 100 };
                        break;
                    default:
                        chartPadding = { right: 100 };
                        break;
                }

                options = {
                    seriesBarDistance: spacing,
                    strokeWidth: spacing,
                    chartPadding: chartPadding,
                    axisY: {
                        // Use only integer values (whole numbers) for the scale steps
                        onlyInteger: true
                    }
                };
                var labels = chartData.data.labels;
                var longestLabel = GetLongestLabel(labels);
                var aproxWidth = longestLabel * 5 * labels.length;
                if (aproxWidth > availableWidth) {
                    var fraction = Math.ceil(aproxWidth / availableWidth);
                    options.axisX = {
                        labelInterpolationFnc: function (value, index) {
                            return index % fraction === 0 ? value : null;
                        }
                    };
                }
                options.plugins = [Chartist.plugins.chartLegend({ position: chartData.data.legendPosition || "right" })];
            } else {
                options.axisY = { onlyInteger: true };
            }
        } else {
            if (chartData.data.multiSeries) {
                chartData.data.series = transformSeriesArray(chartData.data.multiSeries[0], 0);
            } else {
                chartData.data.series = transformSeriesArray(chartData.data.series, 0);
            }

            if (Chartist.plugins && Chartist.plugins.chartLegend) {
                let chartPadding = {};
                switch (chartData.data.legendPosition) {
                    case 'top':
                        chartPadding = { top: 40 };
                        break;
                    case 'bottom':
                        chartPadding = { bottom: 40 };
                        break;
                    default:
                        chartPadding = 20;
                        break;
                }

                options = {
                    chartPadding: chartPadding,
                    labelOffset: 80,
                    ignoreEmptyValues: true,
                    chartValues: chartData.data.series,
                    labelInterpolationFnc: function (value, idx) {
                        return this.chartValues[idx].value;
                    },
                    axisX: { offset: 0 },
                    axisY: {
                        // Use only integer values (whole numbers) for the scale steps
                        onlyInteger: true,
                        offset: 0
                    }
                };
                options.plugins = [Chartist.plugins.chartLegend({ position: chartData.data.legendPosition || "left" })];
            } else {
                options.axisX = { offset: 0 }
                options.axisY = { onlyInteger: true, offset: 0 };
            }
        }

        if (!Array.isArray(options.plugins)) {
            options.plugins = [];
        }
        let tooltipPluginOpts = createChartTooltipPluginOptions(chartEl, tooltipOpts);
        if (tooltipPluginOpts) {
            options.plugins.push(Chartist.plugins.tooltip(tooltipPluginOpts));
        }
       
        var chartCtrl = new Chartist[chartType](chartEl[0], chartData.data, options, responsiveOptions);
        chartEl.data("chart", chartCtrl);
        if (strokeColor) {
            chartCtrl.on('draw', function (context) {
                if (chartType === "Line" && (context.type === 'point' || context.type === 'line')) {
                    context.element.attr({ style: 'stroke: ' + strokeColor + ';' });
                }
                else if (chartType === "Bar" && context.type === 'bar') {
                    context.element.attr({ style: 'stroke: ' + strokeColor + ';stroke-width: ' + spacing + 'px;' });
                }
            });
        } else {
            
            var wasLimited = false;
            var legendsCounter = legendsCount;
            if (legendsCount > 1) {
                var legends = chartData.data.legends;
                var lastLegend = legends[legends.length - 1];
                wasLimited = lastLegend === 'Other';
            }
            var counter = -1;
            chartCtrl.on('draw', function (data) {
                if (data.type === 'bar' && spacing > 0) {
                    if (wasLimited && data.seriesIndex === legends.length - 1) {
                        data.element.attr({
                            style: 'stroke-width: ' + spacing + 'px;'
                        });
                        data.element._node.className.baseVal += " other";
                    } else {
                        data.element.attr({
                            style: 'stroke-width: ' + spacing + 'px;'
                        });
                    }
                } else if (data.type === 'Line') {
                    if (wasLimited && data.seriesIndex === legends.length - 1) {
                        data.element._node.className.baseVal += " other";
                    }
                } else if (data.type === 'label' && data.element._node.children && $(data.element._node.children[0]).text() !== '') {
                    if (counter === 0) {
                        counter = 1;
                        data.element.attr({
                            style: 'overflow: visible;'
                        });
                        data.element._node.className.baseVal += " extra-padding";
                    } else {
                        counter = 0;
                    }
                } else if (wasLimited && data.type === 'gridBackground') {
                    if (legendsCounter === 1) {
                        data.element._node.className.baseVal += " other";
                    } else {
                        legendsCounter --;
                    }
                }
            });
        }

        function transformSeriesArray(seriesArray, multiSeriesIndex) {

            return seriesArray.map(function (seriesValue, valueIndex) {
                var dataObject = {
                    value: seriesValue
                };

                if (chartData.data.metadata) {
                    var metadata = chartData.data.metadata[multiSeriesIndex][valueIndex];

                    if (!metadata && chartData.data.labels) {
                        //try to use labels instead
                        metadata = chartData.data.labels[valueIndex];
                    }
                    if (metadata) {
                        dataObject.meta = metadata;
                    }
                }

                return dataObject;
            });
        }

        function showFunnelChart() {
            const transpose = matrix => matrix[0].map((col, i) => matrix.map(row => row[i]));
            const transposeColors = matrix => matrix.map(color => [color]);
            const colors = [
                '#1cb55d', '#f05b4f', '#f4c63d', '#d17905',
                '#453d3f', '#59922b', '#0544d3', '#6b0392',
                '#f05b4f', '#dda458', '#eacf7d', '#86797d',
                '#b2c326', '#6188e2', '#a748ca', '#c0c0c0'];

            let funnelData = {
                labels: chartData.data.labels,
                subLabels: chartData.data.legends,
                values: chartData.data.series,
                colors: ['#f4c63d', '#66CC66'] 
            };

            if (chartData.data.multiSeries) {
                if (legendsCount > 1 && chartData.data.legends[legendsCount - 1] === 'Other') {
                    colors[legendsCount - 1] = '#c0c0c0';
                }
                while (legendsCount > colors.length) {
                    colors.push('#c0c0c0');
                }

                funnelData.values = transpose(chartData.data.multiSeries);
                funnelData.colors = transposeColors(colors);
            }

            var graph = new FunnelGraph({
                container: chartEl[0],
                data: funnelData
            });
            chartEl.data("chart", graph);

            graph.container = chartEl[0];
            graph.draw();
        }
    };

    /* Chartist init */
    $(".chart").each(function () {
        var chartEl = $(this);
        var url = chartEl.data("source");
        if (url) {
            $.getJSON(url, function (data) {
                initChart(chartEl, data);
            }).error(function (response) {
                var inner = response.responseText.split(/<body[^>]*>|(.*?)<\/body>/igm)[2];
                chartEl.html("<div style=\"overflow: scroll;height: 100%;\">" + inner || response.responseText + "</div>");
            });
        } else {
            initChart(chartEl);
        }
    });
});