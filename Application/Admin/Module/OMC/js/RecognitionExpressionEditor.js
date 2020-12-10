/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
    Dynamicweb.Controls = new Object();
}

if (typeof (Dynamicweb.Controls.OMC) == 'undefined') {
    Dynamicweb.Controls.OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.OMC.RecognitionExpressionEditor = function (controlID) {
    /// <summary>Represents a profile recognition expression editor.</summary>
    /// <param name="controlID">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = controlID;
    this._container = '';
    this._initialized = false;
    this._rules = null;
    this._rulesByNodes = {};
    this._rulesByTypes = new Hash();
    this._cancelClickEvent = false;
    this._draggableContainer = null;
    this._tree = null;
    this._state = {};
    this._terminology = {};
    this._isDragging = false;
    this._pointsSelector = null;
    this._actionsBalloon = null;
    this._combinationsManager = null;
    this._actionNode = null;
    this._pointsSelectorInitialized = false;

    this._handlers = {
        selectionChanged: []
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay = function (owner) {
    /// <summary>Represents a combination overlay.</summary>
    /// <param name="owner">Owning control.</param>

    this._owner = owner;
    this._layout = null;
    this._combinationID = '';
    this._method = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.and;

    if (!this._owner || typeof (this._owner.get_tree) != 'function') {
        this._owner = null;
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error('Combination overlay must be associated with the owning recognition editor control.');
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.get_owner = function () {
    /// <summary>Gets the reference to owning control.</summary>

    return this._owner;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.get_combinationID = function () {
    /// <summary>Gets the ID of the associated combination.</summary>

    return this._combinationID;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.set_combinationID = function (value) {
    /// <summary>Sets the ID of the associated combination.</summary>
    /// <param name="value">The ID of the associated combination.</param>

    this._combinationID = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.get_method = function () {
    /// <summary>Gets the target combine method.</summary>

    return this._method;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.set_method = function (value) {
    /// <summary>Sets the target combine method.</summary>
    /// <param name="value">The target combine method.</param>

    var operatorText = '';

    this._method = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.parse(value);

    this._ensureLayout();

    operatorText = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.getName(this._method).toLowerCase();

    this._layout.operator.innerHTML = operatorText;
    this._layout.operator.className = 'recognition-editor-combination-operator-text recognition-editor-combination-operator-' + operatorText;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.redraw = function (maxDepth) {
    /// <summary>Redraws the overlay.</summary>
    /// <param name="maxDepth">Optional. The maximum combination depth.</param>

    var size = 0;
    var c = null;
    var depth = 0;
    var rows = [];
    var row = null;
    var zIndex = 9;
    var nodeID = '';
    var offset = null;
    var sideHeight = 0;
    var levelWidth = 15;
    var components = [];
    var widthAdjust = 8;
    var width = levelWidth;
    var combination = null;
    var distribution = null;
    var firstCombinationRow = null;
    var sideHeightBottomAddition = 0;
    var position = { left: 0, top: 0 };

    this._ensureLayout();

    var containsComponent = function (component) {
        var ret = false;

        for (var i = 0; i < components.length; i++) {
            if (components[i] == component) {
                ret = true;
                break;
            }
        }

        return ret;
    }

    if (this.get_combinationID() && this.get_combinationID().length) {
        combination = this.get_owner().get_tree().combination(this.get_combinationID());

        if (combination) {
            distribution = combination.get_componentsDistribution();
            components = distribution.nodes;

            if (components) {
                size = components.length;

                if (size > 0) {
                    sideHeight = parseInt((size * 30) / 2) - 8;

                    if (sideHeight == null || sideHeight < 0 || isNaN(sideHeight)) {
                        sideHeight = 0;
                    }
                    //48

                    if (size > 2) {
                        sideHeight += parseInt((size - 2) * 11);
                        if (size % 2 != 0) {
                            sideHeightBottomAddition = 2;
                        }
                    }

                    this._layout.top.style.height = sideHeight + 'px';
                    this._layout.bottom.style.height = (sideHeight + sideHeightBottomAddition) + 'px';

                    rows = this.get_owner().get_expressionRows();

                    for (var i = 0; i < rows.length; i++) {
                        row = $(rows[i]);
                        nodeID = row.readAttribute('data-node-id');

                        if (nodeID && nodeID.length && containsComponent(nodeID)) {
                            firstCombinationRow = row;
                            break;
                        }
                    }

                    if (firstCombinationRow) {
                        offset = $(firstCombinationRow.select('input')[0]).positionedOffset();

                        position.left = offset.left;
                        position.top = offset.top;

                        depth = this.get_owner().get_tree().combinationDepth(this.get_combinationID());
                        if (depth > 0) {
                            zIndex += depth;
                            position.left += (levelWidth * depth) + (widthAdjust * depth);
                        }

                        if (typeof (maxDepth) != 'undefined' && maxDepth != null) {
                            width = levelWidth * Math.abs(maxDepth - depth);
                            if (width > levelWidth) {
                                width += (widthAdjust * Math.abs(maxDepth - (depth + 1)));
                            }
                        }
                    }

                    this._layout.container.style.zIndex = zIndex;
                    this._layout.container.style.width = width + 'px';
                    this._layout.container.style.left = (position.left + 11) + 'px';
                    this._layout.container.style.top = (position.top + 6) + 'px';
                    this._layout.container.style.display = 'block';
                } else {
                    this._layout.container.style.display = 'none';
                }
            } else {
                this._layout.container.style.display = 'none';
            }
        } else {
            this._layout.container.style.display = 'none';
        }
    } else {
        this._layout.container.style.display = 'none';
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype.remove = function () {
    /// <summary>Removes the overlay from the DOM tree.</summary>

    var p = null;

    if (this._layout) {
        p = this._layout.container.parentNode || this._layout.container.parentElement;
        if (p) {
            p.removeChild(this._layout.container);
        }

        this._layout = null;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay.prototype._ensureLayout = function () {
    /// <summary>Ensures that the overlay layout is created.</summary>
    /// <private />

    var c = null;
    var top = null;
    var self = this;
    var bottom = null;
    var operator = null;
    var operatorText = '';
    var rowsContainer = null;
    var operatorInner = null;

    var updateCombinationHighlight = function (isHighlighted) {
        var r = null;
        var allRows = null;
        var combinationRows = [];
        var combination = self.get_owner().get_tree().combination(self.get_combinationID());

        var isCombinationRow = function (rowID) {
            var result = false;

            for (var i = 0; i < combinationRows.length; i++) {
                if (combinationRows[i] == rowID) {
                    result = true;
                    break;
                }
            }

            return result;
        }

        if (combination) {
            combinationRows = combination.get_componentsDistribution().nodes;
            if (combinationRows && combinationRows.length) {
                allRows = self.get_owner().get_expressionRows();
                if (allRows && allRows.length) {
                    for (var i = 0; i < allRows.length; i++) {
                        r = $(allRows[i]);

                        if (isCombinationRow(r.readAttribute('data-node-id'))) {
                            if (isHighlighted) {
                                r.addClassName('recognition-editor-row-combination-highlight');
                            } else {
                                r.removeClassName('recognition-editor-row-combination-highlight');
                            }
                        }
                    }
                }
            }
        }
    }

    if (!this._layout) {
        this._layout = {};
        rowsContainer = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container')[0];

        c = document.createElement('div');
        c.className = 'recognition-editor-combination';
        c.style.display = 'none';

        top = document.createElement('div');
        top.className = 'recognition-editor-combination-top';

        operatorText = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.getName(this.get_method()).toLowerCase();

        operator = document.createElement('div');
        operator.className = 'recognition-editor-combination-operator';
        operator.title = this.get_owner().get_terminology()['ClickToChangeGrouping'];

        operatorInner = document.createElement('div');
        operatorInner.className = 'recognition-editor-combination-operator-text recognition-editor-combination-operator-' + operatorText;
        operatorInner.innerHTML = operatorText;

        operator.appendChild(operatorInner);

        bottom = document.createElement('div');
        bottom.className = 'recognition-editor-combination-bottom';

        c.appendChild(top);
        c.appendChild(operator);
        c.appendChild(bottom);

        rowsContainer.appendChild(c);

        this._layout.top = top;
        this._layout.container = c;
        this._layout.bottom = bottom;
        this._layout.operator = operatorInner;

        Event.observe(operator, 'mouseover', function (e) { updateCombinationHighlight(true); });
        Event.observe(operator, 'mouseout', function (e) { updateCombinationHighlight(false); });
        Event.observe(operator, 'click', function (e) {
            var combination = null;
            var newMethod = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.and;

            if (self.get_method() == newMethod) {
                newMethod = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombineMethod.or;
            }

            combination = self.get_owner().get_tree().combination(self.get_combinationID());
            if (combination) {
                self.get_owner().get_tree().combine(combination.get_components(), newMethod);
            }
        });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager = function (owner) {
    /// <summary>Represents a combination overlay.</summary>
    /// <param name="owner">Owning control.</param>

    this._owner = owner;
    this._overlays = {};

    if (!this._owner || typeof (this._owner.get_tree) != 'function') {
        this._owner = null;
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error('Combination overlay must be associated with the owning recognition editor control.');
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.get_owner = function () {
    /// <summary>Gets the reference to owning control.</summary>

    return this._owner;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.addOverlay = function (combination) {
    /// <summary>Register the new overlay (if it hasn't been registered yet) to be managed by this manager.</summary>
    /// <param name="combination">Tree node combination.</param>

    var combinationID = '';

    if (combination) {
        if (typeof (combination) == 'string') {
            combinationID = combination;
        } else if (typeof (combination.get_id) == 'function') {
            combinationID = combination.get_id();
        }

        if (!this.containsOverlay(combinationID)) {
            this._overlays[combinationID] = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlay(this.get_owner());
            this._overlays[combinationID].set_combinationID(combinationID);

            if (typeof (combination.get_method) == 'function') {
                this._overlays[combinationID].set_method(combination.get_method());
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.removeOverlay = function (combination) {
    /// <summary>Removes the given registered overlay.</summary>
    /// <param name="combination">Tree node combination.</param>

    var combinationID = '';

    if (combination) {
        if (typeof (combination) == 'string') {
            combinationID = combination;
        } else if (typeof (combination.get_id) == 'function') {
            combinationID = combination.get_id();
        }

        if (combinationID && this._overlays[combinationID] && typeof (this._overlays[combinationID].remove) == 'function') {
            this._overlays[combinationID].remove();
            delete this._overlays[combinationID];
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.clearOverlays = function () {
    /// <summary>Removes all registered overlays.</summary>

    for (var prop in this._overlays) {
        if (this._overlays[prop] && typeof (this._overlays[prop].remove) == 'function') {
            this._overlays[prop].remove();
            delete this._overlays[prop];
        }
    }

    this._overlays = {};
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.redrawOverlays = function (maxDepth) {
    /// <summary>Redraws all overlays.</summary>
    /// <param name="maxDepth">Optional. The maximum depth of the overlays.</param>

    for (var prop in this._overlays) {
        if (this._overlays[prop] && typeof (this._overlays[prop].redraw) == 'function') {
            this._overlays[prop].redraw(maxDepth);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager.prototype.containsOverlay = function (combination) {
    /// <summary>Determines whether overlay that is associated with the given combination is being managed by this manager.</summary>
    /// <param name="combination">Tree node combination.</param>

    var ret = false;
    var combinationID = '';

    if (combination) {
        if (typeof (combination) == 'string') {
            combinationID = combination;
        } else if (typeof (combination.get_id) == 'function') {
            combinationID = combination.get_id();
        }

        if (combinationID) {
            for (var prop in this._overlays) {
                if (this._overlays[prop] && typeof (this._overlays[prop].get_combinationID) == 'function') {
                    if (this._overlays[prop].get_combinationID() == combinationID) {
                        ret = true;
                        break;
                    }
                }
            }
        }
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer = function (owner) {
    /// <summary>Represents a tree renderer.</summary>
    /// <param name="owner">Owning control.</param>

    this._owner = owner;
    this._maxCombinationDepth = 0;
    this._combinationsManager = null;

    if (!this._owner || typeof (this._owner.get_tree) != 'function') {
        this._owner = null;
        Dynamicweb.Controls.OMC.RecognitionExpressionEditor.error('Tree renderer must be associated with the owning recognition editor control.');
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype.get_owner = function () {
    /// <summary>Gets the reference to owning control.</summary>

    return this._owner;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype.get_maxCombinationDepth = function() {
    /// <summary>Gets the maximum combination depth.</summary>

    return this._maxCombinationDepth;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype.get_combinationsManager = function () {
    /// <summary>Gets the expression tree node combinations manager (UI).</summary>

    if (!this._combinationsManager) {
        this._combinationsManager = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.CombinationOverlayManager(this.get_owner());
    }

    return this._combinationsManager;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype.renderTree = function () {
    /// <summary>Renders the tree.</summary>

    var expressionEmpty = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-empty')[0];
    var expressionLoading = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-loading')[0];
    var expressionData = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container')[0];

    expressionLoading.hide();
    expressionData.innerHTML = '';

    this.get_combinationsManager().clearOverlays();
    this._maxCombinationDepth = 0;

    if (this.get_owner().get_tree().get_size() > 0) {
        expressionEmpty.hide();
        expressionData.show();

        this._renderChildren(null);
        this._renderOverlays();
    } else {
        expressionData.hide();
        expressionEmpty.show();
    }

    this.get_owner().get_state().selectAll.disabled = (this.get_owner().get_tree().get_size() == 0);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype._renderOverlays = function () {
    /// <summary>Renders the combination overlays.</summary>
    /// <private />

    var rows = [];
    var offset = null;
    var header = null;
    var maxDepth = this.get_maxCombinationDepth();

    var buildOffset = function (container, clean) {
        var existingOffsets = [];
        var combinationOffset = null;
        var offsetClass = 'recognition-editor-combination-offset';

        if (clean) {
            while (container.firstChild.className == offsetClass) {
                container.removeChild(container.firstChild);
            }
        }

        for (var j = 0; j < maxDepth; j++) {
            combinationOffset = document.createElement('li');
            combinationOffset.className = offsetClass;

            container.insertBefore(combinationOffset, container.firstChild);
        }
    }

    this.get_combinationsManager().redrawOverlays(maxDepth);
    header = this.get_owner().get_expressionHeader();

    if (maxDepth > 0) {
        rows = this.get_owner().get_expressionRows();

        if (rows && rows.length) {
            for (var i = 0; i < rows.length; i++) {
                buildOffset(rows[i], false);
            }
        }
    }

    buildOffset(header, true);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype._renderChildren = function (parent) {
    /// <summary>Renders a given tree level and all sub-levels.</summary>
    /// <param name="parent">An ID of the parent node.</param>
    /// <private />

    var children = [];
    var container = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container')[0];

    if (parent == null) {
        children = this.get_owner().get_tree().root();
    } else {
        children = this.get_owner().get_tree().children(parent);
    }

    if (children && children.length) {
        for (var i = 0; i < children.length; i++) {
            this._renderNode(children[i].node, container);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer.prototype._renderNode = function (node, parent) {
    /// <summary>Renders a single tree node.</summary>
    /// <param name="node">A reference to tree node.</param>
    /// <param name="parent">A reference to a DOM element that accepts node output.</param>
    /// <private />

    var row = null;
    var rule = null;
    var self = this;
    var clearFix = null;
    var chkSelect = null;
    var constraint = null;
    var columnRule = null;
    var restColumn = null;
    var combination = null;
    var nextComponent = '';
    var columnValue = null;
    var viewActions = null;
    var valueControl = null;
    var columnSelect = null;
    var combinationDepth = 0;
    var actionsColumn = null;
    var contentOverflow = null;
    var columnCondition = null;
    var columnRuleLabel = null;
    var actionsContainer = null;
    var interactionTimeout = null;
    var constraintCondition = null;
    var width = this.get_owner().get_state()['HeaderWidth'];

    var newColumn = function (suffix) {
        var c = document.createElement('li');

        c.className = 'recognition-editor-cell-' + suffix;

        return c;
    }

    var newOverflow = function () {
        var c = document.createElement('span');

        c.className = 'recognition-editor-cell-content-overflow';

        return c;
    }

    if (node) {
        rule = this.get_owner().findRule(node.get_rule());

        if (rule) {
            constraint = rule.get_constraint();
            row = $(document.createElement('ul'));

            row.writeAttribute('data-node-id', node.get_id());
            row.setStyle({ 'width': width + 'px' });

            if (node.get_isSelected()) {
                row.addClassName('recognition-editor-row-selected');
            }

            /* Combination depth and overlay managing */
            combinationDepth = this.get_owner().get_tree().combinationDepth(node.get_id());

            if (combinationDepth > this._maxCombinationDepth) {
                this._maxCombinationDepth = combinationDepth;
            }

            if (combinationDepth > 0) {
                nextComponent = node.get_id();

                do {
                    combination = this.get_owner().get_tree().owningCombination(nextComponent);
                    if (combination) {
                        this.get_combinationsManager().addOverlay(combination);
                        nextComponent = combination.get_id();
                    } else {
                        break;
                    }
                } while (true);
            }

            /* Checkbox column */
            columnSelect = newColumn('select');
            chkSelect = document.createElement('input');
            chkSelect.id = 'select_' + node.get_id();
            chkSelect.type = 'checkbox';
            chkSelect.checked = !!node.get_isSelected();
            columnSelect.appendChild(chkSelect);
            row.appendChild(columnSelect);

            Event.observe(chkSelect, 'click', function (e) {
                node.set_isSelected(Event.element(e).checked);
            });

            /* "Rule" column */
            columnRule = newColumn('rule');
            columnRuleLabel = document.createElement('label');
            $(columnRuleLabel).writeAttribute('for', chkSelect.id);
            columnRuleLabel.innerHTML = rule.get_name();
            contentOverflow = newOverflow();
            contentOverflow.appendChild(columnRuleLabel);
            columnRule.appendChild(contentOverflow);
            row.appendChild(columnRule);

            /* "Condition" column */
            columnCondition = newColumn('constraint-operator');
            if (constraint) {
                constraintCondition = this.get_owner().get_state()['Condition'].cloneNode(true);

                var removeCondition, ruleOperators = rule.get_operators();
                for (var i = 0; i < constraintCondition.options.length; i++) {
                    removeCondition = true;

                    for (var j = 0; j < ruleOperators.length; j++) {
                        if (constraintCondition.options[i].value == ruleOperators[j].toString()) {
                            removeCondition = false;
                            break;
                        }
                    }

                    if (removeCondition) {
                        constraintCondition.options.remove(i);
                        i--;
                    }
                }

                Event.observe(constraintCondition, 'change', function (e) {
                    var n = self.get_owner().get_tree().node(node.get_id());

                    rule.get_constraint().set_operator(parseInt(constraintCondition.options[constraintCondition.selectedIndex].value));
                    n.set_constraintOperator(rule.get_constraint().get_operator());
                });

                if (constraint.get_operator() != null) {
                    for (var i = 0; i < constraintCondition.options.length; i++) {
                        if (constraintCondition.options[i].value == constraint.get_operator().toString()) {
                            constraintCondition.selectedIndex = i;
                            break;
                        }
                    }
                }

                columnCondition.appendChild(constraintCondition);
            } else {
                columnCondition.innerHTML = '&nbsp;';
            }
            row.appendChild(columnCondition);

            /* "Value" column */
            columnValue = newColumn('constraint-value');
            if (constraint) {
                if (constraint.get_data()) {
                    valueControl = this.get_owner()._createDropDownFromDictionary(constraint.get_data(), constraint.get_value());
                    Event.observe(valueControl, 'change', function (e) {
                        var n = self.get_owner().get_tree().node(node.get_id());

                        rule.get_constraint().set_value(valueControl.options[valueControl.selectedIndex].value);
                        n.set_constraintValue(rule.get_constraint().get_value());
                    });
                } else {
                    valueControl = document.createElement('input');
                    valueControl.type = 'text';
                    valueControl.className = 'std';
                    valueControl.value = constraint.get_value() != null ? constraint.get_value().toString() : '';

                    Event.observe(valueControl, 'blur', function (e) {
                        var n = self.get_owner().get_tree().node(node.get_id());

                        rule.get_constraint().set_value(valueControl.value && valueControl.value.length ? valueControl.value : null);
                        n.set_constraintValue(rule.get_constraint().get_value());
                    });
                }

                columnValue.appendChild(valueControl);
            } else {
                columnValue.innerHTML = '&nbsp;'
            }
            row.appendChild(columnValue);

            /* "Actions" column */
            actionsColumn = newColumn('actions');

            viewActions = document.createElement('a');

            $(viewActions).writeAttribute('data-node-id', node.get_id());
            viewActions.href = 'javascript:void(0);';
            viewActions.innerHTML = this.get_owner().get_terminology()['Browse'];

            Event.observe(viewActions, 'mouseover', function (e) {
                /* First, updating the points for the previous node */
                if (self.get_owner().get_pointsSelector().get_hasFocus()) {
                    self.get_owner().get_pointsSelector().updateValue();
                }

                /* Updating current action node */
                self.get_owner().set_actionNode(node.get_id());

                /* Updating the node reference within the content */
                self.get_owner()._createActionsContent(node.get_id());

                /* Changing the target of the balloon */
                self.get_owner().get_actionsBalloon().set_target(viewActions);

                /* Showing the balloon */
                self.get_owner().get_actionsBalloon().show();
            });

            Event.observe(viewActions, 'mouseout', function (e) {
                if (interactionTimeout) {
                    clearTimeout(interactionTimeout);
                    interactionTimeout = null;
                }

                interactionTimeout = setTimeout(function () {
                    if (!self.get_owner().get_actionsBalloon().get_isUserInteracting()) {
                        /* Clearing current action node */
                        self.get_owner().set_actionNode(null);

                        /* Hiding the balloon */
                        self.get_owner().get_actionsBalloon().hide();
                    }
                }, 1);
            });

            actionsColumn.appendChild(viewActions);

            row.appendChild(actionsColumn);

            /* One more column to prevent scrollbar from breaking the layout */
            restColumn = newColumn('rest');
            restColumn.innerHTML = '&nbsp;';
            row.appendChild(restColumn);

            /* Clearing the float effect */
            clearFix = document.createElement('div');
            clearFix.className = 'recognition-editor-clear';
            clearFix.innerHTML = '&nbsp;';

            parent.appendChild(row);
            parent.appendChild(clearFix);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_actionsBalloon = function () {
    /// <summary>Gets the object that represents a tooltip containing links to rule actions.</summary>

    if (!this._actionsBalloon) {
        this._actionsBalloon = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Balloon();
        this._actionsBalloon.set_title(this.get_terminology()['Browse']);
    }

    return this._actionsBalloon;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_state = function () {
    /// <summary>Gets the control state.</summary>

    return this._state;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_totalPoints = function () {
    /// <summary>Gets the current total amount of points that is given to the visitor if all rules are satisfied.</summary>

    return this.get_tree().totalPoints();
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object.</summary>

    return this._terminology;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_pointsSelector = function () {
    /// <summary>Gets the reference to number selector control that is used for configuring how much points the visitor gets for satisfying the given rule (or a group of rules).</summary>

    var instance = null;

    if (typeof (this._pointsSelector) == 'string') {
        try {
            instance = eval(this._pointsSelector);
        } catch (ex) { }

        this._pointsSelector = instance;
    }

    return this._pointsSelector;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_pointsSelector = function (value) {
    /// <summary>Sets the reference to number selector control that is used for configuring how much points the visitor gets for satisfying the given rule (or a group of rules).</summary>
    /// <param name="value">Either a string or an object representing a number selector control.</param>

    this._pointsSelector = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_tree = function () {
    /// <summary>Gets the reference to expression tree.</summary>

    return this._tree;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_tree = function (value) {
    /// <summary>Sets the reference to expression tree.</summary>
    /// <param name="value">A reference to expression tree.</param>

    this._tree = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_rules = function () {
    /// <summary>Gets the list of all available recognition rules.</summary>

    return this._rules;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_rules = function (value) {
    /// <summary>Sets the list of all available recognition rules.</summary>
    /// <param name="value">The list of all available recognition rules.</param>

    this._rules = value;
    this._rulesByTypes = new Hash();

    if (this._rules && this._rules.length) {
        for (var i = 0; i < this._rules.length; i++) {
            this._rulesByTypes.set(this._rules[i].get_type(), this._rules[i]);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_associatedControlID = function () {
    /// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

    return this._associatedControlID;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_associatedControlID = function (value) {
    /// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
    /// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

    this._associatedControlID = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_actionNode = function () {
    /// <summary>Gets the node that the user is currently performing actions on.</summary>

    return this._actionNode;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_actionNode = function (value) {
    /// <summary>Sets the node that the user is currently performing actions on.</summary>
    /// <param name="value">The node that the user is currently performing actions on.</param>

    this._actionNode = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_container = function () {
    /// <summary>Gets the identifier of the DOM element associated with this control.</summary>

    if (!this._container) {
        this._container = $$('input[name="' + this.get_associatedControlID() + '"]');
        if (this._container && this._container.length) {
            this._container = this._container[0].id;
        }
    }

    return this._container;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.set_container = function (value) {
    /// <summary>Sets the identifier of the DOM element associated with this control.</summary>
    /// <param name="value">The identifier of the DOM element associated with this control.</param>

    this._container = value;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_expressionRows = function () {
    /// <summary>Gets the list of DOM elements representing rows in expression list.</summary>

    return $(this.get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container ul');
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_expressionHeader = function () {
    /// <summary>Gets the reference to DOM element representing expression header row.</summary>

    return $(this.get_container()).select('div.recognition-editor-expression ul.recognition-editor-expression-table-header')[0];
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.get_hasExpression = function () {
    /// <summary>Gets value indicating whether there is an existing expression available (that is either loaded or not).</summary>

    return document.getElementById(this.get_container() + '_Expression').value.length;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.add_ready = function (callback) {
    /// <summary>Registers new callback which is executed when the page is loaded.</summary>
    /// <param name="callback">Callback to register.</param>

    callback = callback || function () { }
    Event.observe(document, 'dom:loaded', function () {
        callback(this, {});
    });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.add_selectionChanged = function (callback) {
    /// <summary>Adds a new callback that is executed when the selection changes.</summary>
    /// <param name="callback">Callback to register.</param>

    if (callback && typeof (callback) == 'function') {
        this._handlers.selectionChanged[this._handlers.selectionChanged.length] = callback;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.clearSelection = function () {
    /// <summary>Clears the selection.</summary>

    this.get_tree().setSelection(null, false, true);
    this.get_state().selectAll.checked = false;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.toExpression = function () {
    /// <summary>Returns the current expression.</summary>

    var self = this;
    var ret = this.get_tree().toExpression();

    var fillRulesRecursive = function (group) {
        var rule = null;
        var foundRule = null;
        var components = group.get_components();

        for (var i = 0; i < components.length; i++) {
            if (typeof (components[i].get_rule) == 'function') {
                rule = components[i].get_rule();
                foundRule = self.findRule(rule.get_id());

                if (foundRule) {
                    rule.set_id(foundRule.get_id());
                    rule.set_name(foundRule.get_name());
                    rule.set_type(foundRule.get_type());
                    rule.set_description(foundRule.get_description());
                    rule.set_operators(foundRule.get_operators());

                    if (foundRule.get_constraint()) {
                        if (!rule.get_constraint()) {
                            rule.set_constraint(foundRule.get_constraint());
                        } else {
                            rule.get_constraint().set_data(foundRule.get_constraint().get_data());
                        }
                    }
                }
            } else if (typeof (components[i].get_components) == 'function') {
                fillRulesRecursive(components[i]);
            }
        }
    }

    fillRulesRecursive(ret);

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.fromExpression = function (expression) {
    /// <summary>Loads the current expression.</summary>
    /// <param name="expression">Recognition expression.</param>

    var self = this;

    var fillRulesRecursive = function (group) {
        var rule = null;
        var foundRule = null;
        var components = group.get_components();

        for (var i = 0; i < components.length; i++) {
            if (typeof (components[i].get_rule) == 'function') {
                rule = components[i].get_rule();
                foundRule = self.findRule(rule.get_type());

                if (foundRule) {
                    rule.set_id(foundRule.get_id());
                    rule.set_name(foundRule.get_name());
                    rule.set_description(foundRule.get_description());
                    rule.set_operators(foundRule.get_operators());

                    if (foundRule.get_constraint()) {
                        if (!rule.get_constraint()) {
                            rule.set_constraint(foundRule.get_constraint());
                        } else {
                            rule.get_constraint().set_data(foundRule.get_constraint().get_data());
                        }
                    }
                }
            } else if (typeof (components[i].get_components) == 'function') {
                fillRulesRecursive(components[i]);
            }
        }
    }

    if (expression) {
        fillRulesRecursive(expression);
    }

    this.get_tree().fromExpression(expression, function (node, expressionNode) {
        self._prepareNode(node, expressionNode.get_rule());
    });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.toXml = function () {
    /// <summary>Converts the current recognition expression to XML string.</summary>

    return new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer().toXml(this.toExpression());
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.fromXml = function (xml) {
    /// <summary>Parses the given XML string and applies the resulting recognition expression.</summary>

    this.fromExpression(new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.ExpressionTreeSerializer().fromXml(xml));
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.commitChanges = function () {
    /// <summary>Commits the changes.</summary>

    document.getElementById(this.get_container() + '_Expression').value = this.toXml();
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.abandonChanges = function () {
    /// <summary>Abandons the changes.</summary>

    document.getElementById(this.get_container() + '_Expression').value = '';
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.initialize = function (onComplete) {
    /// <summary>Initializes the instance.</summary>

    var self = this;
    var c = $(this.get_container());
    var expressionEmpty = c.select('div.recognition-editor-expression div.recognition-editor-empty')[0];
    var expressionData = c.select('div.recognition-editor-expression div.recognition-editor-expression-container')[0];
    var expressionsHeader = c.select('div.recognition-editor-expression ul.recognition-editor-expression-table-header')[0];

    var dropAreas = [expressionEmpty, expressionData];
    var updateSelectAllState = function (selection) {
        if (selection.length > 0 && selection.length == self.get_tree().get_size()) {
            self.get_state().selectAll.checked = true;
        } else {
            self.get_state().selectAll.checked = false;
        }
    }

    onComplete = onComplete || function () { }

    if (!this._initialized) {
        this.get_state()['HeaderWidth'] = parseInt(expressionsHeader.getStyle('width').replace('px', ''));
        this.get_state()['Condition'] = this._createConditionDropDown();
        this.get_state()['TotalPoints'] = $(this.get_container()).select('.recognition-editor-totalpoints')[0];
        this.get_state().selectAll = c.select('div.recognition-editor-expression ul.recognition-editor-expression-table-header li.recognition-editor-cell-select input')[0];

        /* Canceling "selectstart" event (making out drag'n'drop look prettier) */
        Event.observe(document.body, 'selectstart', function (evt) {
            if (self._isDragging) {
                Event.stop(event);
                event.cancelBubble = true;

                return false;
            }
        });

        /* Configuring "Select/Deselect all" checkbox */
        Event.observe(this.get_state().selectAll, 'click', function (evt) {
            self.get_tree().setSelection(null, Event.element(evt).checked, true);
        });

        /* Droppables patch - includes scroll offsets */
        Droppables.isAffected = function (point, element, drop) {
            return (
          (drop.element != element) &&
          ((!drop._containers) ||
            this.isContained(element, drop)) &&
          ((!drop.accept) ||
            (Element.classNames(element).detect(
              function (v) { return drop.accept.include(v) }))) &&
          Position.withinIncludingScrolloffsets(drop.element, point[0], point[1]));
        }

        /* Initializing droppable areas */
        for (var i = 0; i < dropAreas.length; i++) {
            Droppables.add(dropAreas[i], {
                accept: 'recognition-editor-rule-draggable',
                hoverclass: 'recognition-editor-expression-hover',

                onHover: function (draggable, droppable) {
                    /* "hoverClass" doesn't trigger when the "onHover" is not defined - bug? */
                },

                onDrop: function (draggable, droppable, event) {
                    var targetRule = null;
                    var ruleID = draggable.readAttribute('data-rule-id');
                    var targetElement = typeof (event.srcElement) != 'undefined' ? event.srcElement : event.target;

                    targetRule = self.findRule(ruleID);

                    if (targetRule) {
                        self._onRuleDropped(targetRule);
                    }
                }
            });
        }

        /* Configuring expression tree */
        this.set_tree(new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Tree());
        this.get_tree().add_update(function (sender, e) {
            self.onTreeUpdate(sender, e);
            updateSelectAllState(self.get_tree().selection(null, true));

            self.get_state()['TotalPoints'].innerHTML = self.get_totalPoints();
        });

        this.get_tree().add_selectionChanged(function (sender, e) {
            var row = null;
            var checkbox = null;
            var rowFound = false;
            var rows = $(self.get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container ul');

            if (rows && rows.length) {
                for (var i = 0; i < rows.length; i++) {
                    rowFound = false;
                    row = $(rows[i]);
                    checkbox = row.select('li.recognition-editor-cell-select input')[0];

                    for (var j = 0; j < e.selection.length; j++) {
                        if (e.selection[j].node.get_id() == row.readAttribute('data-node-id')) {
                            checkbox.checked = true;
                            row.addClassName('recognition-editor-row-selected');

                            rowFound = true;
                            break;
                        }
                    }

                    if (!rowFound) {
                        row.removeClassName('recognition-editor-row-selected');
                        checkbox.checked = false;
                    }
                }
            }

            updateSelectAllState(e.selection);

            self.onSelectionChanged({ selection: e.selection });
        });

        this.get_tree().add_afterNodeRemove(function (sender, e) {
            for (var i = 0; i < e.nodes.length; i++) {
                delete self._rulesByNodes[e.nodes[i].get_id()];
            }
        });

        this.get_tree().add_totalPointsChanged(function (sender, e) {
            self.get_state()['TotalPoints'].innerHTML = e.points.toString();
        });

        /* Preloading this image since it's quite big (1000x5001, 21kb) */
        this.preloadImage('/Admin/Module/OMC/img/selection.png');

        /* Reloading rules */
        this.reloadRules(function () {
            self.reloadExpression();

            onComplete();
        });

        this._initialized = true;
    } else {
        onComplete();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.preloadImage = function (url) {
    /// <summary>Preloads the given image.</summary>
    /// <param name="url">Resource URL.</param>

    var img = null;
    var preloadElement = null;
    var preloadType = 'dom';
    var preloadContainer = document.getElementById(this.get_container() + '_preloadContainer');

    if (url && url.length) {
        if (preloadType == 'object' && document.images) {
            img = new Image();
            img.src = url;
        } else if (preloadContainer) {
            preloadElement = document.createElement('img');
            preloadElement.src = url;

            preloadContainer.appendChild(preloadElement);
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.onTreeUpdate = function (sender, e) {
    /// <summary>Handles the tree "update" event.</summary>
    /// <param name="sender">Event sender.</param>
    /// <param name="e">Event arguments.</param>

    var renderer = null;

    if (e.type == 'structure') {
        renderer = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.TreeRenderer(this);
        renderer.renderTree();

        this.onSelectionChanged({ selection: this.get_tree().selection(null, true) });
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.reloadRules = function (onComplete) {
    /// <summary>Reloads and renders the list of all available rules.</summary>
    /// <param name="onComplete">A callback that is fired when the list of rules has been reloaded and rendered.</param>

    var self = this;
    var noData = $($(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-empty')[0]);
    var dataLoading = $($(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-loading')[0]);
    var rulesContainer = $($(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-rules-list')[0]);

    onComplete = onComplete || function () { }

    this.set_rules(null);

    noData.hide();
    rulesContainer.hide();

    dataLoading.show();

    this.retrieveRules(function (rules) {
        dataLoading.hide();

        self.renderRules(rules);

        onComplete();
    });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.reloadExpression = function () {
    /// <summary>Reloads the current recognition expression.</summary>

    this.fromXml(document.getElementById(this.get_container() + '_Expression').value);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.retrieveRules = function (onComplete) {
    /// <summary>Makes a request to either a cache or a remote server to return a list of all available rules.</summary>
    /// <param name="onComplete">A callback that is fired when the list of rules becomes available.</param>

    var self = this;

    onComplete = onComplete || function () { }

    if (!this.get_rules()) {
        this.loadRules(function (rules) {
            self.set_rules(rules);
            onComplete(self.get_rules());
        });
    } else {
        onComplete(this.get_rules());
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.findRule = function (ruleID) {
    /// <summary>Finds specified rule among the list of all rules by its ID.</summary>
    /// <param name="ruleID">An ID of the rule.</param>

    var ret = null;
    var allRules = this.get_rules();

    if (allRules && allRules.length) {
        for (var i = 0; i < allRules.length; i++) {
            if (allRules[i].get_id() == ruleID) {
                ret = allRules[i];
                break;
            }
        }
    }

    if (!ret) {
        for (var f in this._rulesByNodes) {
            if (typeof (this._rulesByNodes[f]) != 'function' && typeof (this._rulesByNodes[f].get_name) == 'function') {
                if (this._rulesByNodes[f].get_id() == ruleID) {
                    ret = this._rulesByNodes[f];
                    break;
                }
            }
        }
    }

    if (!ret) {
        ret = this._rulesByTypes.get(ruleID) || null;
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.loadRules = function (onComplete) {
    /// <summary>Loads the list of all available rules from the server.</summary>
    /// <param name="onComplete">A callback that is fired when the list of rules becomes available.</param>

    var rules = [];
    var rule = null;

    onComplete = onComplete || function () { }

    Dynamicweb.Ajax.DataLoader.load({ target: this.get_associatedControlID(), argument: 'Rules', onComplete: function (data) {
        if (data && data.rules && data.rules.length) {
            for (var i = 0; i < data.rules.length; i++) {
                rule = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule();
                rule.load(data.rules[i]);

                rules[rules.length] = rule;
            }

            onComplete(rules);
        } else {
            onComplete([]);
        }
    }
    });
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.renderRules = function (rules) {
    /// <summary>Renders the given list of rules.</summary>
    /// <param name="onComplete">A list of rules to render.</param>

    var self = this;
    var rulesList = null;
    var rulesListItem = null;
    var rulesListItemHeading = null;
    var rulesListItemDescription = null;
    var noData = $($(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-empty')[0]);
    var rulesContainer = $($(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-rules-list')[0]);

    if (rules && rules.length) {
        noData.hide();
        rulesContainer.innerHTML = '';

        rulesList = new Element('ul');

        for (var i = 0; i < rules.length; i++) {
            rulesListItem = new Element('li');
            rulesListItemHeading = new Element('strong');
            rulesListItemDescription = new Element('span');

            rulesListItem.className = 'recognition-editor-rule';
            rulesListItem.writeAttribute('data-rule-id', rules[i].get_id());

            rulesListItemHeading.innerHTML = rules[i].get_name();
            rulesListItemDescription.innerHTML = rules[i].get_description();

            rulesListItem.appendChild(rulesListItemHeading);
            rulesListItem.appendChild(rulesListItemDescription);

            Event.observe(rulesListItem, 'mousedown', function (e) { self._isDragging = true; });
            Event.observe(rulesListItem, 'mouseup', function (e) { self._isDragging = false; });
            Event.observe(rulesListItem, 'selectstart', function (e) {
                Event.stop(e);

                e.cancelBubble = true;
                return false;
            });

            (function (r) {
                Event.observe(rulesListItem, 'dblclick', function (e) {
                    self._isDragging = false;
                    self._onRuleDropped(r);
                });
            })(rules[i]);

            rulesList.appendChild(rulesListItem);
        }

        rulesContainer.appendChild(rulesList);

        rulesContainer.show();

        this._makeRulesDraggable();
    } else {
        rulesContainer.hide();
        noData.show();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.onSelectionChanged = function (e) {
    /// <summary>Fires "selectionChanged" event.</summary>
    /// <param name="e">Event arguments.</param>

    this.notify('selectionChanged', e);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype.notify = function (eventName, args) {
    /// <summary>Notifies clients about the specified event.</summary>
    /// <param name="eventName">Event name.</param>
    /// <param name="args">Event arguments.</param>

    var callbacks = [];
    var callbackException = null;

    if (eventName && eventName.length) {
        callbacks = this._handlers[eventName];

        if (callbacks && callbacks.length) {
            if (typeof (args) == 'undefined' || args == null) {
                args = {};
            }

            for (var i = 0; i < callbacks.length; i++) {
                callbackException = null;

                try {
                    callbacks[i](this, args);
                } catch (ex) {
                    callbackException = ex;
                }

                /* Preventing "Unable to execute code from freed script" errors to raise */
                if (callbackException && callbackException.number != -2146823277) {
                    this.error(callbackException.message);
                }
            }
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._onRuleDropped = function (rule) {
    /// <summary>Occurs when the rule has been dropped onto the expression area.</summary>
    /// <param name="rule">The rule that has been dropped.</param>
    /// <private />

    var node = {};

    this._prepareNode(node, rule);

    /* Setting the default amount of points for every new rule */
    node.points = 1;

    this.get_tree().append(node, null);
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._prepareNode = function (n, rule) {
    /// <summary>Prepares the given tree node to be added to the expression tree.</summary>
    /// <param name="n">Node to prepare.</param>
    /// <param name="rule">Associated node rule.</param>
    /// <private />

    var nodeID = '';
    var constraint = null;
    var attachedRule = null;

    var setField = function (name, value) {
        if (typeof (n['set_' + name]) == 'function') {
            n['set_' + name](value);
        } else {
            n[name] = value;
        }
    }

    var createNodeRule = function (generatedNodeID) {
        var r = new Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Rule();

        r.load(rule);
        r.set_id(r.get_id() + '_' + generatedNodeID);

        return r;
    }

    if (n && rule) {
        nodeID = this.get_tree().generateNodeID();
        attachedRule = createNodeRule(nodeID);
        this._rulesByNodes[nodeID] = attachedRule;

        constraint = rule.get_constraint();

        setField('id', nodeID);
        setField('rule', attachedRule.get_id());
        setField('constraintOperator', constraint != null ? constraint.get_operator() : null);
        setField('constraintValue', constraint != null ? constraint.get_value() : null);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._makeRulesDraggable = function () {
    /// <summary>Makes all currently visible rules draggable.</summary>
    /// <private />

    var self = this;
    var rules = $(this.get_container()).select('div.recognition-editor-rules div.recognition-editor-rules-list ul li.recognition-editor-rule');

    if (rules && rules.length) {
        for (var i = 0; i < rules.length; i++) {
            new Draggable(this._getDraggableContainer(), {
                revert: true,
                handle: rules[i],
                delay: 200,

                starteffect: function () { },
                endeffect: function () { },

                onStart: function (draggable, event) {
                    var handleHtml = '';
                    var elm = draggable.element;
                    var ruleID = $(draggable.handle).readAttribute('data-rule-id');
                    var handleHeadingContent = $(draggable.handle).select('strong');
                    var handleDescriptionContent = $(draggable.handle).select('span');
                    var textContainer = elm.select('.recognition-editor-rule-draggable-content');

                    if (textContainer && textContainer.length > 0 && handleHeadingContent && handleHeadingContent.length) {
                        textContainer = textContainer[0];
                        handleHeadingContent = handleHeadingContent[0];

                        elm.writeAttribute('data-rule-id', ruleID);

                        if (handleDescriptionContent && handleDescriptionContent.length) {
                            handleDescriptionContent = handleDescriptionContent[0];
                        } else {
                            handleDescriptionContent = null;
                        }

                        if (typeof (handleHeadingContent.innerText) != 'undefined') {
                            handleHtml = '<strong>' + handleHeadingContent.innerText + '</strong>';
                        } else if (typeof (handleHeadingContent.textContent) != 'undefined') {
                            handleHtml = '<strong>' + handleHeadingContent.textContent + '</strong>';
                        }

                        if (handleDescriptionContent) {
                            if (typeof (handleDescriptionContent.innerText) != 'undefined') {
                                handleHtml += ('<span>' + handleDescriptionContent.innerText + '</span>');
                            } else if (typeof (handleDescriptionContent.textContent) != 'undefined') {
                                handleHtml += ('<span>' + handleDescriptionContent.textContent + '</span>');
                            }
                        }

                        textContainer.innerHTML = handleHtml;
                    }

                    elm.style.display = 'block';

                    document.body.style.cursor = 'url(\'/Admin/Images/Ribbon/UI/Tree/img/grab.cur\'), move';
                },

                onDrag: function (draggable, event) {
                    var elm = draggable.element;

                    /* 
                    Overriding draggable's offset and position.
                    This is required in order to make the draggable element follow the mouse pointer.
                    */
                    draggable.offset = [1, 8];
                    elm.style.left = 0;
                    elm.style.top = 0;
                },

                onEnd: function (draggable, event) {
                    var elm = draggable.element;

                    elm.style.display = 'none';
                    document.body.style.cursor = 'auto';

                    /* There is a "click" event which if fired after the "mouseup" event (in IE only) - we need to cancel that */
                    self._cancelClickEvent = true;

                    self._isDragging = false;
                }
            });
        }
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._getDraggableContainer = function () {
    /// <summary>Returns draggable object.</summary>
    /// <private />

    var self = this;

    if (!this._draggableContainer) {
        this._draggableContainer = document.getElementById(this.get_container() + '_draggableContainer');

        /* There is a "click" event which if fired after the "mouseup" event on drag release (in IE only) - we need to cancel that */
        if (Prototype.Browser.IE) {
            Event.stopObserving(document.body, 'click', self._onClick);
            Event.observe(document.body, 'click', self._onClick.bindAsEventListener(self));
        }
    }

    return this._draggableContainer;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._onClick = function (event) {
    /// <summary>Internal member. Handles "click" event of a document's body.</summary>
    /// <param name="event">Event data.</param>
    /// <private />

    var ret = true;
    var element = Event.element(event);

    /* Do we need to cancel this event ? */
    if (this._cancelClickEvent) {
        /* If the source element is not our drag handle then we won't cancel any more "click" events */
        if (!(element.id == this._getDraggableContainer().id ||
            element.up('.recognition-editor-rule-draggable'))) {

            this._cancelClickEvent = false;
        }

        /* Canceling event */
        Event.stop(event);
        event.cancelBubble = true;

        ret = false;
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._createConditionDropDown = function () {
    /// <summary>Creates a "Condition" drop-down list.</summary>
    /// <private />

    var term = '';
    var optionsAdded = 0;
    var ret = document.createElement('select');
    var names = Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator.getNames();

    ret.className = 'std';
    ret.disabled = !names || !names.length;

    if (!ret.disabled) {
        for (var i = 0; i < names.length; i++) {
            term = this.get_terminology()[Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Enumeration.pascalCaseField(names[i])];
            if (term && term.length) {
                ret.options[ret.options.length] = new Option(term, Dynamicweb.Controls.OMC.RecognitionExpressionEditor.Operator[names[i]]);
                optionsAdded += 1;
            }
        }

        ret.disabled = (optionsAdded == 0);
    }

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._createDropDownFromDictionary = function (data, selectedValue) {
    /// <summary>Creates a drop-down list using the data from the given dictionary.</summary>
    /// <param name="data">Dictionary containing list data.</param>
    /// <param name="selectedValue">Selected value.</param>
    /// <private />

    var keys = [];
    var selectedIndex = 0;
    var ret = document.createElement('select');

    ret.className = 'std';

    if (data) {
        keys = data.keys();
        if (keys && keys.length) {
            for (var i = 0; i < keys.length; i++) {
                ret.options[ret.options.length] = new Option(data.get(keys[i]), keys[i]);
                if (keys[i] == selectedValue) {
                    selectedIndex = i;
                }
            }

            ret.selectedIndex = selectedIndex;
        }
    }

    ret.disabled = !keys || !keys.length;

    return ret;
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._createActionsContent = function (nodeID) {
    /// <summary>Generates the content for the "Actions" balloon.</summary>
    /// <param name="nodeID">An ID of the corresponding tree node.</param>
    /// <private />

    var self = this;
    var list = null;
    var item = null;
    var link = null;
    var isCombined = false;
    var isLastNode = false;
    var isFirstNode = false;
    var pointsContainer = null;
    var pointsDescription = null;
    var pointsParentDescription = null;
    var rootNodes = this.get_tree().root();
    var content = this.get_actionsBalloon().get_content();

    if (rootNodes.length) {
        isFirstNode = rootNodes[0].node.get_id() == nodeID;
        isLastNode = rootNodes[rootNodes.length - 1].node.get_id() == nodeID;
        isCombined = this.get_tree().isCombined(nodeID);
    }

    var actionClick = function (elm, onClick) {
        if (!elm.hasClassName('recognition-editor-action-disabled') && !elm.up('.recognition-editor-action-disabled')) {
            onClick();
        }
    }

    var switchView = function () {
        var c = $(content);
        var originalIsSilent = false;
        var n = self.get_tree().node(nodeID);
        var pointsValue = c.select('div.recognition-editor-points-value')[0];
        var pointsParent = c.select('div.recognition-editor-points-parent-description')[0];

        c.select('a.recognition-editor-action-orderup')[0].className = 'recognition-editor-action-orderup' + (isFirstNode ? ' recognition-editor-action-disabled' : '');
        c.select('a.recognition-editor-action-orderdown')[0].className = 'recognition-editor-action-orderdown' + (isLastNode ? ' recognition-editor-action-disabled' : '');
        c.select('li.recognition-editor-action-ungroup-container')[0].style.display = (isCombined ? '' : 'none');

        pointsValue.style.marginBottom = isCombined ? '3px' : '10px';
        pointsParent.style.display = isCombined ? 'block' : 'none';

        if (n) {
            originalIsSilent = self.get_pointsSelector().get_isSilent();
            self.get_pointsSelector().set_isSilent(true);

            self.get_pointsSelector().set_selectedValue(n.get_points());

            self.get_pointsSelector().set_isSilent(originalIsSilent);
        }
    }

    if (content) {
        /* Simply updating the node ID */
        $($(content).select('div.recognition-editor-actions-list')[0]).writeAttribute('data-node-id', nodeID);
        switchView();
    } else {
        /* Generating content from scratch */

        content = document.createElement('div');
        content.className = 'recognition-editor-actions-list';

        $(content).writeAttribute('data-node-id', nodeID);

        pointsDescription = document.createElement('div');
        pointsDescription.className = 'recognition-editor-points-description';
        pointsDescription.innerHTML = this.get_terminology()['PointsDescription'];
        content.appendChild(pointsDescription);

        pointsContainer = document.createElement('div');
        pointsContainer.className = 'recognition-editor-points-value';
        pointsContainer.appendChild(document.getElementById(this.get_container() + '_pointsSelector'));
        pointsContainer.firstChild.style.display = 'block';
        content.appendChild(pointsContainer);

        pointsParentDescription = document.createElement('div');
        pointsParentDescription.className = 'recognition-editor-points-parent-description';
        pointsParentDescription.innerHTML = this.get_terminology()['InheritedByParent'];
        content.appendChild(pointsParentDescription);

        list = document.createElement('ul');

        /* "Move up" action */
        item = document.createElement('li');
        link = document.createElement('a');
        link.href = 'javascript:void(0);';
        link.className = 'recognition-editor-action-orderup';
        link.setAttribute('title', this.get_terminology()['OrderUp']);
        // link.innerHTML = this.get_terminology()['OrderUp'];
        link.innerHTML = '<i class="fa fa-arrow-up"></i>';
        Event.observe(link, 'click', function (e) { actionClick(Event.element(e), function () { self._actionOrderUp(e); }); });
        item.appendChild(link);
        list.appendChild(item);

        /* "Move down" action */
        item = document.createElement('li');
        link = document.createElement('a');
        link.href = 'javascript:void(0);';
        link.className = 'recognition-editor-action-orderdown';
        // link.innerHTML = this.get_terminology()['OrderDown'];
        link.innerHTML = '<i class="fa fa-arrow-down"></i>';
        link.setAttribute('title', this.get_terminology()['OrderDown']);
        Event.observe(link, 'click', function (e) { actionClick(Event.element(e), function () { self._actionOrderDown(e); }); });
        item.appendChild(link);
        list.appendChild(item);

        /* "Ungroup: action */
        item = document.createElement('li');
        link = document.createElement('a');
        link.href = 'javascript:void(0);';
        item.className = 'recognition-editor-action-ungroup-container';
        link.className = 'recognition-editor-action-ungroup';
        //link.innerHTML = this.get_terminology()['Ungroup'];
        link.innerHTML = '<i class="fa fa-unlink"></i>';
        link.setAttribute('title', this.get_terminology()['Ungroup']);
        Event.observe(link, 'click', function (e) { actionClick(Event.element(e), function () { self._actionUngroup(e); }); });
        item.appendChild(link);
        list.appendChild(item);

        /* "Remove" action */
        item = document.createElement('li');
        link = document.createElement('a');
        link.href = 'javascript:void(0);';
        link.className = 'recognition-editor-action-remove';
        //link.innerHTML = this.get_terminology()['Remove'];
        link.innerHTML = '<i class="fa fa-times"></i>';
        link.setAttribute('title', this.get_terminology()['Remove']);
        Event.observe(link, 'click', function (e) { actionClick(Event.element(e), function () { self._actionRemove(e); }); });
        item.appendChild(link);
        list.appendChild(item);

        content.appendChild(list);

        this.get_actionsBalloon().set_content(content);

        switchView();
    }

    if (!this._pointsSelectorInitialized) {
        this.get_pointsSelector().add_valueChanged(function (sender, args) {
            var n = null;
            var nodes = null;
            var combination = null;

            if (self.get_actionNode()) {
                combination = self.get_tree().topOwningCombination(self.get_actionNode());
                if (combination) {
                    nodes = combination.get_componentsDistribution().nodes;
                }
            }

            if (nodes == null) {
                nodes = [self.get_actionNode()];
            }

            for (var i = 0; i < nodes.length; i++) {
                n = self.get_tree().node(nodes[i]);
                if (n) {
                    n.set_points(args.value);
                }
            }
        });

        this._pointsSelectorInitialized = true;
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._actionOrderUp = function (e) {
    /// <summary>Performs the "Order up" action.</summary>
    /// <param name="e">Event object.</param>
    /// <private />

    var nodeID = '';
    var allRows = [];
    var balloonContent = Event.element(e).up('div.recognition-editor-actions-list');

    if (balloonContent) {
        nodeID = balloonContent.readAttribute('data-node-id');
        this.get_tree().moveUp(nodeID);

        allRows = $(this.get_container()).select('.recognition-editor-cell-actions a');

        for (var i = 0; i < allRows.length; i++) {
            if ($(allRows[i]).readAttribute('data-node-id') == nodeID) {
                this.get_actionsBalloon().set_target(allRows[i]);
                this.get_actionsBalloon().update();

                break;
            }
        }

        this._createActionsContent(nodeID);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._actionOrderDown = function (e) {
    /// <summary>Performs the "Order down" action.</summary>
    /// <param name="e">Event object.</param>
    /// <private />

    var nodeID = '';
    var allRows = [];
    var balloonContent = Event.element(e).up('div.recognition-editor-actions-list');

    if (balloonContent) {
        nodeID = balloonContent.readAttribute('data-node-id');
        this.get_tree().moveDown(nodeID);

        allRows = $(this.get_container()).select('.recognition-editor-cell-actions a');

        for (var i = 0; i < allRows.length; i++) {
            if ($(allRows[i]).readAttribute('data-node-id') == nodeID) {
                this.get_actionsBalloon().set_target(allRows[i]);
                this.get_actionsBalloon().update();

                break;
            }
        }

        this.get_actionsBalloon().update();
        this._createActionsContent(nodeID);
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._actionRemove = function (e) {
    /// <summary>Performs the "Remove" action.</summary>
    /// <param name="e">Event object.</param>
    /// <private />

    var nodeID = '';
    var balloonContent = Event.element(e).up('div.recognition-editor-actions-list');

    if (balloonContent) {
        nodeID = balloonContent.readAttribute('data-node-id');
        this.get_tree().remove(nodeID);

        this.get_actionsBalloon().hide();
    }
}

Dynamicweb.Controls.OMC.RecognitionExpressionEditor.prototype._actionUngroup = function (e) {
    /// <summary>Performs the "Ungroup" action.</summary>
    /// <param name="e">Event object.</param>
    /// <private />

    var nodeID = '';
    var balloonContent = Event.element(e).up('div.recognition-editor-actions-list');

    if (balloonContent) {
        nodeID = balloonContent.readAttribute('data-node-id');
        this.get_tree().breakCombination([nodeID]);

        this.get_actionsBalloon().hide();
    }
}