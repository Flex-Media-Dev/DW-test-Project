class ColorSwatch {
    constructor(selector, options) {
        const self = this;
        const defaults = {
            shadeValueStep: 20,
            shadeShowDelay: 500,
            shadeHideDelay: 1000
        };

        this.settings = Object.assign({}, defaults, options);
        this.selector = selector;

        document.addEventListener("DOMContentLoaded", () => {
            self.init();
        });
    }

    init() {
        //for default
        this.selector = document.querySelectorAll(this.selector || ".color-swatch-picker");
        if (!this.selector.length) {
            return;
        }
        this.pickers = {};
        const self = this;
        let _settings = this.settings;
        if (_settings.palette != null) {
            _settings.palette = this.getPaletteArrays(_settings.palette);
        }
        this.selector.forEach((colorSwatch) => {
            let id = colorSwatch.id;
            this.pickers[id] = {
                node: colorSwatch,
                value: colorSwatch.getAttribute('data-value'),
                showEdit: colorSwatch.getAttribute('data-show-edit'),            
            };

            if (_settings.palette != null) {
                this.renderBrandSet(id);
                this.renderNeutralSet(id);
            }

            this.renderCustomColor(id);
            this.renderTransparentColor(id);
            if (this.pickers[id].showEdit == 'True') {
                this.renderEditButton(id);
            }
            if (this.pickers[id].value != null && this.pickers[id].value != "") {
                this.initValue(id);
            }
        }, this);
    }

    initValue(key) {
        let _settings = this.settings;
        let _data = this.pickers[key];

        if (_data.value.startsWith('#')) {
            //handler for choose
            _data.customColorNode.label.onclick();
            //handler for change color
            _data.customColorNode.label.value = _data.value;
            _data.customColorNode.label.onchange();
        } else if (_settings.palette == null) {
            return;
        } else if (_data.value.startsWith('Brand')) {
            if (_data.value.indexOf('shade') != -1) {
                let valueArray = _data.value.split('_shade');
                let colorName = valueArray[0];
                let shadeValue = valueArray[1];
                let colorNode = _data.brandColorsNodes[colorName];
                let shadeNode = _data.shadesNodes[shadeValue];

                shadeNode.color = this.getShade(colorNode.color, shadeValue);
                this.addCheckedShade(key, colorNode, shadeNode);
            } else {
                _data.brandColorsNodes[_data.value].radio.checked = true;
            }
        } else if (_data.value.startsWith('Neutral')) {
            _data.neutralColorsNodes[_data.value].radio.checked = true;
        } else if (_data.value === 'transparent') {
            _data.transparentColorNode.radio.checked = true;
        }
    }

    getPaletteArrays(palette) {
        let brandColors = {};
        let neutralColors = {};
        if (typeof (palette) == "string") {
            palette = JSON.parse(palette);
        }
        for (let colorName in palette) {
            let color = palette[colorName]
            if (color == "") {
                color = "#ffffff";
            } else if (color.length == 4 && color[0] == "#") {
                color = this.shortColorToLong(color);
            }
            if (colorName.startsWith('Brand')) {
                brandColors[colorName] = color;
            }
            if (colorName.startsWith('Neutral')) {
                neutralColors[colorName] = color;
            }
        }
        return { brandColors: brandColors, neutralColors: neutralColors };
    }

    renderBrandSet(key, appendInStart) {
        let _settings = this.settings;
        let _data = this.pickers[key];
        _data.brandColorsNodes = {};

        for (let colorName in _settings.palette.brandColors) {
            let colorNode = this.createColorNode(key + '_' + colorName, key, colorName, _settings.palette.brandColors[colorName], _settings.brandTitle);
            let showTimer = null;

            colorNode.node.addEventListener("mouseover", () => {
                showTimer = setTimeout(() => {
                    this.showShades(key, colorNode);
                    clearTimeout(showTimer);
                }, _settings.shadeShowDelay);
            });

            colorNode.node.addEventListener("mouseout", () => {
                clearTimeout(showTimer);
            });

            colorNode.label.addEventListener('click', () => {
                this.removeCheckedShade(key);
                this.uncheckCustomColor(key);
            });

            _data.brandColorsNodes[colorName] = colorNode;
        }
        _data.brandSet = this.createSet(_data.brandColorsNodes, "color-swatch-picker__set--brand");

        if (appendInStart) {
            _data.node.insertBefore(_data.brandSet, _data.node.firstChild);
        } else {
            _data.node.appendChild(_data.brandSet);
        }

        this.renderShades(key);
    }

    renderNeutralSet(key, appendInStart) {
        let _settings = this.settings;
        let _data = this.pickers[key];
        _data.neutralColorsNodes = {};
        for (let colorName in _settings.palette.neutralColors) {
            _data.neutralColorsNodes[colorName] = this.createColorNode(key + '_' + colorName, key, colorName, _settings.palette.neutralColors[colorName], _settings.neutralTitle);
            _data.neutralColorsNodes[colorName].label.addEventListener('click', () => {
                this.removeCheckedShade(key);
                this.uncheckCustomColor(key);
            });
        }
        _data.neutralSet = this.createSet(_data.neutralColorsNodes, "color-swatch-picker__set--neutral");

        if (appendInStart) {
            _data.node.insertBefore(_data.neutralSet, _data.node.firstChild);
        } else {
            _data.node.appendChild(_data.neutralSet);
        }
    }

    renderShades(key) {
        let _settings = this.settings;
        let _data = this.pickers[key];

        let shadesNode = document.createElement('div');
        shadesNode.className = "color-swatch-picker__shades";

        _data.shadesNodes = {};

        for (let value = 90; value > 0;value -= _settings.shadeValueStep) {
            _data.shadesNodes[value] = this.createColorNode(key + '_shade' + value, key + '_shade', value, null, _settings.shadeTitle);
            shadesNode.appendChild(_data.shadesNodes[value].node);
        }

        _data.shadesNode = shadesNode;
        _data.brandSet.insertBefore(_data.shadesNode, _data.brandSet.firstChild);

        //create CheckedShadeNode 
        _data.checkedShade = this.createColorNode(key + '_shadeChecked', key, '', null, _settings.shadeTitle);
        _data.checkedShade.node.classList.add('color-swatch-picker__color--shade');

        //add event listener for brandset to show shades after delay
        _data.hideShadesTimer = null;
        _data.brandSet.addEventListener('mouseleave', (event) => {
            _data.hideShadesTimer = setTimeout(() => {
                _data.shadesNode.style.display = "none";
                clearTimeout(_data.hideShadesTimer);
            }, _settings.shadeHideDelay);
        });

        _data.brandSet.addEventListener('mouseenter', (event) => {
            clearTimeout(_data.hideShadesTimer);
        });
    }

    createSet(colorNodes, className) {
        let set = document.createElement('div');
        set.classList.add('color-swatch-picker__set');
        if (className != null) {
            set.classList.add(className);
        }
        for (let colorName in colorNodes) {
            set.appendChild(colorNodes[colorName].node);
        }

        return set;
    }

    createColorNode(id, name, value, color, title) {
        let colorRadio = document.createElement('input');
        colorRadio.type = 'radio';
        colorRadio.id = id;
        colorRadio.name = name;
        colorRadio.value = value;

        let colorLabel = document.createElement('label');
        colorLabel.setAttribute('for', id);
        colorLabel.className = "color-swatch-picker__color-label";

        if (title != null) {
            colorLabel.title = title;
        }

        let colorWrap = document.createElement('div');
        colorWrap.className = "color-swatch-picker__color";
        colorWrap.appendChild(colorRadio);
        colorWrap.appendChild(colorLabel);

        let colorNode = { label: colorLabel, radio: colorRadio, node: colorWrap };

        if (color != null) {
            this.setColor(colorNode, color);
        }

        return colorNode;
    }

    setColor(colorNode, color) {
        colorNode.label.style = "--color: " + color + ";--markColor:" + this.getMarkColor(color) + ";";
        colorNode.color = color;
    }

    showShades(key, colorNode) {
        let _settings = this.settings;
        let _data = this.pickers[key];
        let hsv = this.hexToHsv(colorNode.color);
        let i = 0;

        //uncheck all shades
        this.uncheckShades(key);

        for (let value in _data.shadesNodes) {
            let shade = this.hsvToHex({ H: hsv.H, S: hsv.S, V: value });
            let shadeNode = _data.shadesNodes[value];
            this.setColor(shadeNode, shade);
            shadeNode.node.onclick = (event) => {
                if (event.srcElement.tagName == "INPUT") {
                    return;
                }
                this.addCheckedShade(key, colorNode, shadeNode);
                clearTimeout(_data.hideShadesTimer);
            };
            i++;
        }

        //check if this one have checked shade
        if (this.hasCheckedShade(colorNode)) {
            _data.shadesNodes[_data.checkedShade.value].radio.checked = true;
        }
        let isNodeAfterCheckedShade = this.isNodeAfterCheckedShade(colorNode.node);
        _data.shadesNode.style = "--left:" + (colorNode.node.offsetLeft + (isNodeAfterCheckedShade ? 5: 20)) + "px;";
        if (isNodeAfterCheckedShade) {
            _data.shadesNode.style.left = "10px";
        }
        _data.shadesNode.style.display = "block";
    }

    isNodeAfterCheckedShade(node) {
        while (node.previousElementSibling != null && !node.previousElementSibling.classList.contains('color-swatch-picker__color--with-shade')) {
            node = node.previousElementSibling;
        }
        return node.previousElementSibling != null;
    }

    uncheckShades(key) {
        let _data = this.pickers[key];
        let checkedElement = _data.shadesNode.querySelector('input[type=radio]:checked');
        if (checkedElement != null) {
            checkedElement.checked = false;
        }
    }

    addCheckedShade(key, colorNode, shadeNode) {
        let _data = this.pickers[key];

        this.removeCheckedShade(key);
        this.uncheckCustomColor(key);
        colorNode.node.classList.add('color-swatch-picker__color--with-shade');
        _data.shadesNode.style.display = "none";
        _data.checkedShade.radio.checked = true;
        _data.checkedShade.radio.value = colorNode.radio.value + "_shade" + shadeNode.radio.value;
        this.setColor(_data.checkedShade, shadeNode.color);
        _data.checkedShade.value = shadeNode.radio.value;
        colorNode.node.appendChild(_data.checkedShade.node);
    }

    hasCheckedShade(colorNode) {
        return colorNode.node.classList.contains('color-swatch-picker__color--with-shade');
    }

    removeCheckedShade(key) {
        let _data = this.pickers[key];
        if (_data.checkedShade != null && _data.checkedShade.node.parentNode != null) {
            _data.checkedShade.node.parentNode.classList.remove('color-swatch-picker__color--with-shade');
            _data.checkedShade.node.remove();
            this.uncheckShades(key);
        }
    }

    uncheckCustomColor(key) {
        let _data = this.pickers[key];
        _data.customColorNode.label.classList.remove('color-swatch-picker__color-label--editable');
    }

    renderCustomColor(key) {
        let _settings = this.settings;
        let _data = this.pickers[key];

        let customColorSet = document.createElement('div');
        customColorSet.className = "color-swatch-picker__set color-swatch-picker__set--custom";

        let colorRadio = document.createElement('input');
        colorRadio.type = 'radio';
        colorRadio.name = key;
        colorRadio.value = "#ffffff";

        let colorPicker = document.createElement('input');
        //.color - jscolor trigger
        colorPicker.id = key + '_custom';
        colorPicker.className = "color-swatch-picker__color-label color {valueElement: '" + key + "_custom', hash: true, pickerFaceColor: 'transparent', pickerFace: 3, pickerBorder: 0, pickerInsetColor: 'black'}";
        colorPicker.title = _settings.customTitle;
        colorPicker.onclick = () => {
            colorRadio.checked = true;
            this.removeCheckedShade(key);
            colorPicker.classList.add('color-swatch-picker__color-label--editable');
        };

        let colorRadioMark = document.createElement('div');
        colorRadioMark.className = "color-swatch-picker__color-mark";
        colorRadioMark.addEventListener('click', () => {
            colorPicker.focus();
        });

        let colorChangeHandler = (color) => {
            if (color == null) {
                color = colorPicker.value
            }
            colorRadio.value = color;
            let markColor = this.getMarkColor(color);
            colorPicker.style = "background-color: " + colorPicker.style.backgroundColor + ";--markColor: " + markColor + ";";
            colorRadioMark.style.borderColor = markColor;
        };

        colorPicker.onchange = () => {
            colorChangeHandler();
        };

        colorPicker.onblur = () => {
            if (!this.isHexColorValid(colorPicker.value)) {
                colorChangeHandler(this.rgbStringToHex(colorPicker.style.backgroundColor));
            }
        }

        let colorWrap = document.createElement('div');
        colorWrap.className = "color-swatch-picker__color";
        colorWrap.appendChild(colorRadio);
        colorWrap.appendChild(colorPicker);
        colorWrap.appendChild(colorRadioMark);

        let customColorNode = { label: colorPicker, radio: colorRadio, node: colorWrap };

        customColorSet.appendChild(customColorNode.node);
        _data.customColorNode = customColorNode;
        _data.node.appendChild(customColorSet);
        jscolor.install();
    }

    renderTransparentColor(key) {
        let _settings = this.settings;
        let _data = this.pickers[key];
        _data.transparentColorNode = this.createColorNode(key + '_transparent', key, 'transparent', '#FFFFFF', _settings.transparentTitle);
        _data.transparentColorNode.label.addEventListener('click', () => {
            this.removeCheckedShade(key);
            this.uncheckCustomColor(key);
        });

        let transparentColorSet = document.createElement('div');
        transparentColorSet.className = "color-swatch-picker__set color-swatch-picker__set--transparent";
        transparentColorSet.appendChild(_data.transparentColorNode.node);

        _data.node.appendChild(transparentColorSet);
    }

    renderEditButton(key) {
        let _settings = this.settings;
        let _data = this.pickers[key];

        let editButton = document.createElement('button');
        editButton.className = "color-swatch-picker__edit";
        editButton.title = _settings.editButtonTitle;
        editButton.type = "button";
        editButton.addEventListener('click', () => {
            let url = "/Admin/Content/Items/Editing/ColorSwatchEdit.aspx?AreaId=" + _settings.areaId;

            Action.Execute({
                'Name': 'OpenDialog',
                'Url': url,
                'OnSubmitted': {
                    'Name': 'ScriptFunction',
                    'Function': (act, result) => {
                        let newPalette = this.getPaletteArrays(result);
                        _settings.palette = newPalette;
                        this.selector.forEach((picker) => {
                            let key = picker.id;
                            let _data = this.pickers[key];

                            if (_data.brandSet == null) { //not initialized on start
                                this.renderNeutralSet(key, true);
                                this.renderBrandSet(key, true);
                            } else {
                                for (let colorName in newPalette.brandColors) {
                                    let colorNode = _data.brandColorsNodes[colorName];
                                    this.setColor(colorNode, newPalette.brandColors[colorName]);
                                    if (this.hasCheckedShade(colorNode)) {
                                        this.setColor(_data.checkedShade, this.getShade(newPalette.brandColors[colorName], _data.checkedShade.value));
                                    }
                                }

                                for (let colorName in newPalette.neutralColors) {
                                    this.setColor(_data.neutralColorsNodes[colorName], newPalette.neutralColors[colorName]);
                                }
                            }
                        }, this);
                    }
                }
            });
        });
        let icon = document.createElement('i');
        icon.className = "fa fa-pencil";
        editButton.appendChild(icon);
        _data.editButton = editButton;
        _data.node.appendChild(_data.editButton);
    }

    getMarkColor(color) {
        let rgb = this.hexToRgb(color);
        let luma = 0.2126 * rgb.R + 0.7152 * rgb.G + 0.0722 * rgb.B; // per ITU-R BT.709
        return luma > 128 ? "#000000" : "#ffffff";
    }

    hexToRgb(hex) {
        hex = hex.replace('#', '');
        if (hex.length === 6) {
            return {
                R: parseInt(hex.substr(0, 2), 16),
                G: parseInt(hex.substr(2, 2), 16),
                B: parseInt(hex.substr(4, 2), 16)
            };
        } else {
            return parseInt(hex, 16);
        }
    }

    //rgb(xxx, xxx, xxx)
    rgbStringToHex(rgb) {
        rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
        if (rgb) {
            return this.rgbToHex({ R: parseInt(rgb[1]), G: parseInt(rgb[2]), B: parseInt(rgb[3]) });
        } else {
            return "#FFFFFF";
        }
    }

    rgbToHex(rgb) {
        return "#" + ((1 << 24) + (rgb.R << 16) + (rgb.G << 8) + rgb.B).toString(16).slice(1);
    }

    hsvToRgb(hsv) {
        var rgb = [],
            h, s, v, hi, f, p, q, t;
        h = hsv.H;
        s = hsv.S;
        v = hsv.V;
        s = s / 100;
        v = v / 100;
        hi = Math.floor((h / 60) % 6);
        f = (h / 60) - hi;
        p = v * (1 - s);
        q = v * (1 - f * s);
        t = v * (1 - (1 - f) * s);
        switch (hi) {
            case 0:
                rgb = [v, t, p];
                break;
            case 1:
                rgb = [q, v, p];
                break;
            case 2:
                rgb = [p, v, t];
                break;
            case 3:
                rgb = [p, q, v];
                break;
            case 4:
                rgb = [t, p, v];
                break;
            case 5:
                rgb = [v, p, q];
        }
        return {
            R: Math.min(255, Math.floor(rgb[0] * 256)),
            G: Math.min(255, Math.floor(rgb[1] * 256)),
            B: Math.min(255, Math.floor(rgb[2] * 256))
        };
    }

    hexToHsv(hex) {
        hex = (hex.charAt(0) == "#") ? hex.substring(1, 7) : hex;
        var r = parseInt(hex.substring(0, 2), 16) / 255,
            g = parseInt(hex.substring(2, 4), 16) / 255,
            b = parseInt(hex.substring(4, 6), 16) / 255,
            result = {
                'h': 0,
                's': 0,
                'v': 0
            },
            minVal = Math.min(r, g, b),
            maxVal = Math.max(r, g, b),
            delta = (maxVal - minVal),
            del_R, del_G, del_B;

        result.v = maxVal;
        if (delta === 0) {
            result.h = 0;
            result.s = 0;
        } else {
            result.s = delta / maxVal;
            del_R = (((maxVal - r) / 6) + (delta / 2)) / delta;
            del_G = (((maxVal - g) / 6) + (delta / 2)) / delta;
            del_B = (((maxVal - b) / 6) + (delta / 2)) / delta;
            if (r == maxVal) {
                result.h = del_B - del_G;
            } else if (g == maxVal) {
                result.h = (1 / 3) + del_R - del_B;
            } else if (b == maxVal) {
                result.h = (2 / 3) + del_G - del_R;
            }
            if (result.h < 0) {
                result.h += 1;
            }
            if (result.h > 1) {
                result.h -= 1;
            }
        }
        return {
            H: Math.round(result.h * 360),
            S: Math.round(result.s * 100),
            V: Math.round(result.v * 100)
        };
    }

    hsvToHex(hsv) {
        return this.rgbToHex(this.hsvToRgb(hsv));
    }

    isHexColorValid(hex) {
        return hex.match(/^\W*([0-9A-F]{3}([0-9A-F]{3})?)\W*$/i);
    }

    getShade(color, value) {
        let hsv = this.hexToHsv(color);
        return this.hsvToHex({ H: hsv.H, S: hsv.S, V: value });
    }

    shortColorToLong(color) {
        return "#" + color[1] + color[1] + color[2] + color[2] + color[3] + color[3];
    }
}