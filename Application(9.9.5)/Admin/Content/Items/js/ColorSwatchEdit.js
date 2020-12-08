function ColorSwatchEdit(options) {
    let countOfColors = null;
    let colorThief = null;
    let terminology = {
            OptionNone: "None"
        }
    let businessPalettes = null;
    let businessPaletteTypeSelector = null;

    function CalculateColorsRequest(cmd, baseColor, callback) {
        var data = new FormData();
        data.append("CMD", cmd);
        data.append("BaseColor", baseColor);

        var self = this;
        fetch("/Admin/Content/Items/Editing/ColorSwatchEdit.aspx", {
            method: 'POST',
            body: data
        }).then(function (response) {
            if (response.status >= 200 && response.status < 300) {
                return response.text();
            }
            else {
                var error = new Error(response.statusText)
                error.response = response
                throw error
            }
        }).then(function (colors) {
            if (callback) callback(JSON.parse(colors));
        }).catch(function (error) {
            console.log('There has been a problem with your fetch operation: ' + error.message);
            alert(error.message);
        });
    }

    function CalculateNeutralColors()
    {
        var neutralBase = document.getElementById("ColorSwatchEdit_NeutralBaseSelectPicker").value; 
        var neutralBaseValue = parseInt(neutralBase);
        if (neutralBaseValue > 0)
        {
            var colorInput = document.getElementsByName("BrandColor" + neutralBaseValue)[0];
            if (colorInput && colorInput.value)
            {
                CalculateColorsRequest("CalculateNeutralColors", colorInput.value,
                    function (colors) {
                        SetNeutralColors(colors);
                    });
            }
        }
    }

    function SetBrandColors(colors)
    {
        var brandColorsSection = document.getElementById("BrandColorsSection");
        var colorInputs = brandColorsSection.getElementsByClassName("form-control color");
        for (let i = 0; i < colors.length; i++) {
            UpdateColorSelector(colorInputs[i], colors[i]);
        }
    }

    function SetNeutralColors(colors)
    {
        let brandColorsSection = document.getElementById("NeutralColorsSection");
        let colorInputs = brandColorsSection.getElementsByClassName("form-control color");
        for (let i = 0; i < colors.length; i++) {
            UpdateColorSelector(colorInputs[i], colors[i]);
        }
    }

    function UpdateColorSelector(colorSelector, hexColor)
    {
        colorSelector.value = hexColor;
        var colorBox = colorSelector.closest("div.form-group").getElementsByClassName("color-box")[0];
        colorBox.style.backgroundColor = hexColor; 
    }

    function ConvertRgbToHex(rgb) {
        var red = rgb[0] << 16;  // shift left to get xx0000
        var green = rgb[1] << 8; // shift left to get   xx00
        var blue = rgb[2];
        return "#" + ((1 << 24) + red + green + blue).toString(16).slice(1);
    }

    function AllowDrop(ev) {
        ev.preventDefault();
    }

    function DragStart(ev, colorIndex) {
        ev.dataTransfer.setData("index", colorIndex.toString());
    }

    function DropColor(ev, sectionId, newIndex) {
        ev.preventDefault();
        var oldIndex = parseInt(ev.dataTransfer.getData("index"));
        ChangeColorPosition(sectionId, oldIndex, newIndex);
    }

    function ChangeColorPosition(sectionId, oldIndex, newIndex) {
        var brandColorsSection = document.getElementById(sectionId);
        var colorInputs = brandColorsSection.getElementsByClassName("form-control color");
        var tmpColor = colorInputs[oldIndex].value;

        if (oldIndex < newIndex){
            for(let i = oldIndex; i < newIndex; i++){
                UpdateColorSelector(colorInputs[i], colorInputs[i + 1].value);
            }
        }
        else{
            for(let i = oldIndex; i > newIndex; i--){
                UpdateColorSelector(colorInputs[i], colorInputs[i - 1].value);
            }
        }
        UpdateColorSelector(colorInputs[newIndex], tmpColor);

        if (sectionId == "BrandColorsSection") {
            CalculateNeutralColors();
        }
    }

    let api = {
        initialize: function (options) {
            colorThief = new ColorThief();
            businessPalettes = options.BusinessPalettes;
            terminology.OptionNone = options.OptionNone;
            countOfColors = options.CountOfColors;

            document.querySelector("input[name=BaseColor]").onchange = function () { api.calculateColorGuide(); };
            document.querySelectorAll("input[name^=BrandColor]").forEach(function (input) {
                input.onchange = function () { CalculateNeutralColors(); };
            });
            document.getElementById("ColorSwatchEdit_NeutralBaseSelectPicker").onchange = function () { CalculateNeutralColors(); };
            var imageSelector = document.getElementById("FM_ImageSelector_image");
            imageSelector.onload = function () { api.calculateImageMethod(); };

            businessPaletteTypeSelector = document.getElementById("ColorSwatchEdit_BusinessPaletteType");
            var option = document.createElement("option");
            option.text = terminology.OptionNone;
            option.value = 0;
            businessPaletteTypeSelector.add(option);
              for (var i = 0; i < businessPalettes.length; i++) {
                var option = document.createElement("option");
                option.text = businessPalettes[i].GroupName;
                option.value = i + 1;
                businessPaletteTypeSelector.add(option);
            }
            this.changeBusinessPaletteType();

            var brandColorsSection = document.getElementById("BrandColorsSection");
            var colorInputs = brandColorsSection.getElementsByClassName("color-box"); 
            for (let i = 0; i < colorInputs.length; i++) {
                let div = document.createElement('span');
                div.className = "input-group-addon";
                div.style.border = 0;
                div.innerHTML = "<i class='fa fa-sort'></i>";
                colorInputs[i].parentElement.insertBefore(div, colorInputs[i].nextElementSibling);
                let colorParent = colorInputs[i].closest("div.form-group");
                colorParent.setAttribute("draggable", "true");
                colorParent.ondragstart = function (ev) { DragStart(ev, i); };
                colorParent.ondragover = AllowDrop;
                colorParent.ondrop = function (ev) { DropColor(ev, "BrandColorsSection", i); };
            }

            var neutralColorsSection = document.getElementById("NeutralColorsSection");
            var colorInputs = neutralColorsSection.getElementsByClassName("color-box"); 
            for (let i = 0; i < colorInputs.length; i++) {
                let div = document.createElement('span');
                div.className = "input-group-addon";
                div.style.border = 0;
                div.innerHTML = "<i class='fa fa-sort'></i>";
                colorInputs[i].parentElement.insertBefore(div, colorInputs[i].nextElementSibling);
                let colorParent = colorInputs[i].closest("div.form-group");
                colorParent.setAttribute("draggable", "true");
                colorParent.ondragstart = function (ev) { DragStart(ev, i); };
                colorParent.ondragover = AllowDrop;
                colorParent.ondrop = function (ev) { DropColor(ev, "NeutralColorsSection", i); };
            }
        },

        changeMethod: function ()
        {
            var divColorGuideMethod = document.getElementById("ColorGuideMethod"); 
            var divColorImageMethod = document.getElementById("ColorImageMethod"); 
            var divBusinessPaletteMethod = document.getElementById("BusinessPaletteMethod"); 
            var method = document.getElementById("ColorSwatchEdit_MethodSelectPicker").value; 

            if (method === "ColorGuide" ) 
                dwGlobal.Dom.removeClass(divColorGuideMethod, "hidden");
            else 
                dwGlobal.Dom.addClass(divColorGuideMethod, "hidden");

            if (method === "ImageMethod")
                dwGlobal.Dom.removeClass(divColorImageMethod, "hidden");
            else
                dwGlobal.Dom.addClass(divColorImageMethod, "hidden");

            if (method === "BusinessPalette")
                dwGlobal.Dom.removeClass(divBusinessPaletteMethod, "hidden");
            else
                dwGlobal.Dom.addClass(divBusinessPaletteMethod, "hidden");


            var neutralBase = document.getElementById("ColorSwatchEdit_NeutralBaseSelectPicker"); 
            neutralBase.value = "";
        },

        calculateColorGuide: function ()
        {
            var colorInput = document.getElementsByName("BaseColor")[0];
            if (colorInput && colorInput.value)
            {
                var method = document.getElementById("ColorSwatchEdit_PaletteSelectPicker").value;

                CalculateColorsRequest("Calculate" + method, colorInput.value,
                    function (colors) {
                        SetBrandColors(colors);
                        CalculateNeutralColors();
                    });
            }
        },

        calculateImageMethod: function ()
        {
            var image = document.getElementById("FM_ImageSelector_image");
            if (image && ! dwGlobal.Dom.hasClass(image, "hidden")) {
                var colors = colorThief.getPalette(image, countOfColors);
                if (colors) {
                    SetBrandColors(colors.map(ConvertRgbToHex));
                    CalculateNeutralColors();
                }
            }
        },

        changeBusinessPaletteType: function () {
            var businessPaletteSelector = document.getElementById("ColorSwatchEdit_BusinessPalette");
            for(let i = businessPaletteSelector.options.length - 1; i >= 0 ; i--)
            {
                businessPaletteSelector.remove(i);
            }

            var paletteType = parseInt(businessPaletteTypeSelector.value);
            if (paletteType > 0) {
                var palettes = businessPalettes[paletteType - 1].Palettes;
                for (let i = 0; i < palettes.length; i++) {
                    var option = document.createElement("option");
                    option.text = palettes[i].Name;
                    option.value = i + 1;
                    businessPaletteSelector.add(option);
                }
                this.calculateBusinessPalette();
            }
            else {
                var option = document.createElement("option");
                option.text = terminology.OptionNone;
                option.value = 0;
                businessPaletteSelector.add(option);
            }
        },

        calculateBusinessPalette: function () {
            var businessPaletteSelector = document.getElementById("ColorSwatchEdit_BusinessPalette");
            var paletteType = parseInt(businessPaletteTypeSelector.value);
            if (paletteType > 0) {
                var paletteNumber = parseInt(businessPaletteSelector.value);
                if (paletteNumber > 0) {
                    var colors = businessPalettes[paletteType - 1].Palettes[paletteNumber - 1].Colors;

                    var brandColorsSection = document.getElementById("BrandColorsSection");
                    var colorInputs = brandColorsSection.getElementsByClassName("form-control color");
                    for (let i = 0; i < colors.length; i++) {
                        UpdateColorSelector(colorInputs[i], colors[i]);
                    }

                    CalculateNeutralColors();
                }
            }
        }
    }

    api.initialize(options);
    return api;
} 