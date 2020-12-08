
function applyDropDownOption(listId, hiddenParameters, dropDownOptionParametersToHide, hiddenSections, dropDownOptionSectionsToHide) {
    if (listId != null) {
        showAllHiddenElements(listId, hiddenParameters, hiddenSections);
        applyDropDownOptionParametersToHide(listId, hiddenParameters, dropDownOptionParametersToHide);
        applydropDownOptionSectionsToHide(listId, hiddenSections, dropDownOptionSectionsToHide);
    }
}

function applyDropDownOptionParametersToHide(listId, hiddenParameters, dropDownOptionParametersToHide) {
    var listOptionParametersArrayDictionary = dropDownOptionParametersToHide[listId];
    if (listOptionParametersArrayDictionary != null) {
        var dropdown = document.getElementById(listId);
        if (dropdown != null) {
            var value = dropdown.options[dropdown.selectedIndex].value;
            if (value != null && listOptionParametersArrayDictionary[value] != null) {
                hiddenParameters[listId] = [];
                listOptionParametersArrayDictionary[value].forEach((id) => {
                    var el = document.getElementById(id);
                    if (el != null) {
                        hideAddInPropertyElement(el);
                        hiddenParameters[listId].push(el.id);
                    }
                });
            }
        }
    }
}

function applydropDownOptionSectionsToHide(listId, hiddenSections, dropDownOptionSectionsToHide) {
    var listOptionSectionsArrayDictionary = dropDownOptionSectionsToHide[listId];
    if (listOptionSectionsArrayDictionary != null) {
        var dropdown = document.getElementById(listId);
        if (dropdown != null) {
            var value = dropdown.options[dropdown.selectedIndex].value;
            if (value != null && listOptionSectionsArrayDictionary[value] != null) {
                listOptionSectionsArrayDictionary[value].forEach((sectionName) => {
                    var sections = findParametersByAttributeContainsValue(document, "sectionname", sectionName, "div");
                    sections.forEach((section) => {
                        section.style.display = 'none';
                    });
                    hiddenSections.push(sectionName);
                });
            }
        }
    }
}

function showAllHiddenElements(listId, hiddenParameters, hiddenSections) {
    if (hiddenParameters[listId] != null) {
        for (var j = 0; j < hiddenParameters[listId].length; j++) {
            showAddInPropertyElement(document.getElementById(hiddenParameters[listId][j]));
        }
        hiddenParameters[listId] = [];
    }
    var sections = findParametersByAttributeContainsValue(document, "sectionname", "", "div");
    for (var k = 0; k < sections.length; k++) {
        sections[k].style.display = '';
    }
    hiddenSections = [];
}

function hideAddInPropertyElement(element) {
    if (element != null && element.parentElement != null && element.parentElement.parentElement != null) {
        if (element.tagName === 'SELECT' && element.onchange != null &&
            (element.onchange.toString().indexOf("refreshParameters") >= 0 ||
                element.onchange.toString().indexOf("applyDropDownOption") >= 0)) {
            element.selectedIndex = -1;
        }
        element.parentElement.parentElement.style.display = 'none';
        var parent = element.parentElement.parentElement.parentElement;
        if (parent != null) {
            var allHidden = true;
            for (var i = 0; i < parent.childNodes.length; i++) {
                if (parent.childNodes[i].nodeName.toLowerCase() != "script" &&
                    parent.childNodes[i].style != null &&
                    parent.childNodes[i].style.display != 'none') {
                    allHidden = false;
                    break;
                }
            }
            if (allHidden) {
                parent.style.display = 'none';
                if (parent.previousSibling["localName"] == "legend") {
                    parent.previousSibling.style.display = 'none';
                }
            }
        }
    }
}
function showAddInPropertyElement(element) {
    if (element != null && element.parentElement.parentElement != null) {
        element.parentElement.parentElement.style.display = '';
        var parent = element.parentElement.parentElement.parentElement;
        if (parent != null) {
            var anyShown = false;
            for (var i = 0; i < parent.childNodes.length; i++) {
                if (parent.childNodes[i].nodeName.toLowerCase() != "script" &&
                    parent.childNodes[i].style != null &&
                    parent.childNodes[i].style.display != 'none') {
                    anyShown = true;
                    break;
                }
            }
            if (anyShown) {
                parent.style.display = '';
                if (parent.previousSibling["localName"] == "legend") {
                    parent.previousSibling.style.display = '';
                }
            }
        }
    }
}

function findParametersByAttributeContainsValue(parametersDiv, attribute, value, element_type) {
    if (parametersDiv !== null) {
        element_type = element_type || "*";
        var elements = [];
        var parameters = parametersDiv.getElementsByTagName(element_type);
        for (var i = 0; i < parameters.length; i++) {
            var parameter = parameters[i];
            var attributeValue = parameter.getAttribute(attribute);
            if (attributeValue !== null && attributeValue.indexOf(value) >= 0) { elements.push(parameter); }
        }
    }
    return elements;
}

function initMultiColumnDropDown(parentEl) {
    if (parentEl != null) {
        parentEl.querySelector('.custom-select-wrapper').addEventListener('click', function () {
            this.querySelector('.custom-select').classList.toggle('open');
        });

        for (const option of parentEl.querySelectorAll(".custom-option")) {
            option.addEventListener('click', function () {
                if (!this.classList.contains('selected')) {
                    this.parentNode.querySelector('.custom-option.selected').classList.remove('selected');
                    this.classList.add('selected');
                    this.closest('.custom-select').querySelector('.custom-select__trigger span').textContent = this.querySelector("span").textContent;
                    var dropdown = document.getElementById(this.closest('.custom-select-wrapper').dataset.selectid);
                    if (dropdown != null) {
                        dropdown.value = this.dataset.value;
                        dropdown.dispatchEvent(new Event('change'));
                    }
                }
            })
        }

        window.addEventListener('click', function (e) {
            const select = parentEl.querySelector('.custom-select')
            if (select != null && !select.contains(e.target)) {
                select.classList.remove('open');
            }
        });
    }
}