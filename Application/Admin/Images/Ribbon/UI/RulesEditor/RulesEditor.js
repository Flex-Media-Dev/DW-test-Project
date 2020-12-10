/* ++++++ Registering namespace ++++++ */
if (typeof (Dynamicweb) == 'undefined') {
	var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.Controls) == 'undefined') {
	Dynamicweb.Controls = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

Dynamicweb.Controls.RulesEditor = function (controlID) {
	/// <summary>Represents a profile recognition expression editor.</summary>
	/// <param name="controlID">The unique identifier of the ASP.NET control that is associated with this client object.</param>

	this._associatedControlID = controlID;
	this._container = '';
	this._initialized = false;
	this._rules = null;
	this._rulesByFieldIds = new Hash();
	this._rulesByNodes = {};
	this._ruleFieldsProvider = null;
	this._cancelClickEvent = false;
	this._draggableContainer = null;
	this._tree = null;
	this._state = {};
	this._terminology = {};
	this._isDragging = false;
	this._combinationsManager = null;
	this._simpleMode = false;

	this._handlers = {
		selectionChanged: []
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay = function (owner) {
	/// <summary>Represents a combination overlay.</summary>
	/// <param name="owner">Owning control.</param>
	//debugger
	this._owner = owner;
	this._layout = null;
	this._combinationID = '';
	this._method = Dynamicweb.Controls.RulesEditor.CombineMethod.and;

	if (!this._owner || typeof (this._owner.get_tree) != 'function') {
		this._owner = null;
		Dynamicweb.Controls.RulesEditor.error('Combination overlay must be associated with the owning recognition editor control.');
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.get_owner = function () {
	/// <summary>Gets the reference to owning control.</summary>

	return this._owner;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.get_combinationID = function () {
	/// <summary>Gets the ID of the associated combination.</summary>

	return this._combinationID;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.set_combinationID = function (value) {
	/// <summary>Sets the ID of the associated combination.</summary>
	/// <param name="value">The ID of the associated combination.</param>

	this._combinationID = value;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.get_method = function () {
	/// <summary>Gets the target combine method.</summary>

	return this._method;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.set_method = function (value) {
	/// <summary>Sets the target combine method.</summary>
	/// <param name="value">The target combine method.</param>

	var operatorText = '';

	this._method = Dynamicweb.Controls.RulesEditor.CombineMethod.parse(value);

	this._ensureLayout();

	operatorText = Dynamicweb.Controls.RulesEditor.CombineMethod.getName(this._method).toLowerCase();

	this._layout.operator.innerHTML = operatorText;
	this._layout.operator.className = 'recognition-editor-combination-operator-text recognition-editor-combination-operator-' + operatorText;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.redraw = function (maxDepth) {
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

	if (!this.get_owner()._simpleMode && this.get_combinationID() && this.get_combinationID().length) {
		combination = this.get_owner().get_tree().combination(this.get_combinationID());

		if (combination) {
			distribution = combination.get_componentsDistribution();
			components = distribution.nodes;

			if (components) {
				size = components.length;

				if (size > 0) {
					sideHeight = parseInt((size * 20) / 2) - 8;

					if (sideHeight == null || sideHeight < 0 || isNaN(sideHeight)) {
						sideHeight = 0;
					}

					if (size > 2) {
						sideHeight += parseInt((size - 2) * 0.5);
						if (size % 2 != 0) {
							sideHeightBottomAddition = 1;
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
					    offset = firstCombinationRow.select('input')[0].positionedOffset();

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
					this._layout.container.style.left = (position.left + 1) + 'px';
					this._layout.container.style.top = (position.top - 1) + 'px';
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

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype.remove = function () {
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

Dynamicweb.Controls.RulesEditor.CombinationOverlay.prototype._ensureLayout = function () {
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

		operatorText = Dynamicweb.Controls.RulesEditor.CombineMethod.getName(this.get_method()).toLowerCase();

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
			var newMethod = Dynamicweb.Controls.RulesEditor.CombineMethod.and;

			if (self.get_method() == newMethod) {
				newMethod = Dynamicweb.Controls.RulesEditor.CombineMethod.or;
			}

			combination = self.get_owner().get_tree().combination(self.get_combinationID());
			if (combination) {
				self.get_owner().get_tree().combine(combination.get_components(), newMethod);
			}
		});
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager = function (owner) {
	/// <summary>Represents a combination overlay.</summary>
	/// <param name="owner">Owning control.</param>

	this._owner = owner;
	this._overlays = {};

	if (!this._owner || typeof (this._owner.get_tree) != 'function') {
		this._owner = null;
		Dynamicweb.Controls.RulesEditor.error('Combination overlay must be associated with the owning recognition editor control.');
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.get_owner = function () {
	/// <summary>Gets the reference to owning control.</summary>

	return this._owner;
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.addOverlay = function (combination) {
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
			this._overlays[combinationID] = new Dynamicweb.Controls.RulesEditor.CombinationOverlay(this.get_owner());
			this._overlays[combinationID].set_combinationID(combinationID);

			if (typeof (combination.get_method) == 'function') {
				this._overlays[combinationID].set_method(combination.get_method());
			}
		}
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.removeOverlay = function (combination) {
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

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.clearOverlays = function () {
	/// <summary>Removes all registered overlays.</summary>

	for (var prop in this._overlays) {
		if (this._overlays[prop] && typeof (this._overlays[prop].remove) == 'function') {
			this._overlays[prop].remove();
			delete this._overlays[prop];
		}
	}

	this._overlays = {};
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.redrawOverlays = function (maxDepth) {
	/// <summary>Redraws all overlays.</summary>
	/// <param name="maxDepth">Optional. The maximum depth of the overlays.</param>

	for (var prop in this._overlays) {
		if (this._overlays[prop] && typeof (this._overlays[prop].redraw) == 'function') {
			this._overlays[prop].redraw(maxDepth);
		}
	}
}

Dynamicweb.Controls.RulesEditor.CombinationOverlayManager.prototype.containsOverlay = function (combination) {
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

Dynamicweb.Controls.RulesEditor.TreeRenderer = function (owner) {
	/// <summary>Represents a tree renderer.</summary>
	/// <param name="owner">Owning control.</param>

	this._owner = owner;
	this._maxCombinationDepth = 0;
	this._combinationsManager = null;

	if (!this._owner || typeof (this._owner.get_tree) != 'function') {
		this._owner = null;
		Dynamicweb.Controls.RulesEditor.error('Tree renderer must be associated with the owning recognition editor control.');
	}
}

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype.get_owner = function () {
	/// <summary>Gets the reference to owning control.</summary>

	return this._owner;
}

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype.get_maxCombinationDepth = function() {
	/// <summary>Gets the maximum combination depth.</summary>

	return this._maxCombinationDepth;
}

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype.get_combinationsManager = function () {
	/// <summary>Gets the expression tree node combinations manager (UI).</summary>

	if (!this._combinationsManager) {
		this._combinationsManager = new Dynamicweb.Controls.RulesEditor.CombinationOverlayManager(this.get_owner());
	}

	return this._combinationsManager;
}

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype.renderTree = function () {
	/// <summary>Renders the tree.</summary>

	//debugger

	var expressionEmpty = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-empty')[0];
	var expressionLoading = $(this.get_owner().get_container()).select('div.recognition-editor-loading')[0];
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

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype._renderOverlays = function () {
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

	if (this.get_owner()._simpleMode) {
	    return;
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

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype._renderChildren = function (parent) {
	/// <summary>Renders a given tree level and all sub-levels.</summary>
	/// <param name="parent">An ID of the parent node.</param>
	/// <private />

	//debugger

	var children = [];
	var container = $(this.get_owner().get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container')[0];

	if (parent == null) {
		children = this.get_owner().get_tree().root();
	} else {
		children = this.get_owner().get_tree().children(parent);
	}

	if (children && children.length) {
		for (var i = 0; i < children.length; i++) {
			this._renderNode((i+1), children[i].node, container);
		}
	}
}

Dynamicweb.Controls.RulesEditor.TreeRenderer.prototype._renderNode = function (number, node, parent) {
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
	var columnRuleField = null;
	var actionsContainer = null;
	var interactionTimeout = null;
	var constraintCondition = null;
	var width = this.get_owner().get_state()['HeaderWidth'];

	//debugger

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

	//debugger

	if (node) {
		rule = this.get_owner().findRule(node.get_rule());

		if (rule) {
			row = $(document.createElement('ul'));

			row.writeAttribute('data-node-id', node.get_id());

			row.writeAttribute('data-node-number', number);

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
					if (combination && combination.get_method() != Dynamicweb.Controls.RulesEditor.CombineMethod.none) {
						this.get_combinationsManager().addOverlay(combination);
						nextComponent = combination.get_id();
					} else {
						break;
					}
				} while (true);
			}

		    /* Checkbox column */
			if (!this.get_owner()._simpleMode) {
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
			}

			/* "Rule" column */
			columnRule = newColumn('rule');
			columnRuleField = this.get_owner()._createFieldDropDown(number, node);
			columnRule.appendChild(columnRuleField);
			row.appendChild(columnRule);

			/* "Condition" column */
			columnCondition = newColumn('constraint-operator');
			constraintCondition = this.get_owner()._createConditionDropDown(rule.get_controlType(), number, node);
			columnCondition.appendChild(constraintCondition);
			row.appendChild(columnCondition);

			/* "Value" column */
			columnValue = newColumn('constraint-value');
			valueControl = this.get_owner()._createValueCtrl(node, number);
			columnValue.appendChild(valueControl);
			row.appendChild(columnValue);

			if (this.get_owner()._simpleMode) {
			    /* "Delete" column */
			    var columnDelete = newColumn('delete');
			    var deleteControl = this.get_owner()._createDeleteCtrl(node);
			    columnDelete.appendChild(deleteControl);
			    row.appendChild(columnDelete);
			}

			/* Clearing the float effect */
			clearFix = document.createElement('div');
			clearFix.className = 'recognition-editor-clear';
			clearFix.innerHTML = '&nbsp;';

			parent.appendChild(row);
			parent.appendChild(clearFix);
		}
	}
}

Dynamicweb.Controls.RulesEditor.prototype.get_state = function () {
	/// <summary>Gets the control state.</summary>

	return this._state;
}

Dynamicweb.Controls.RulesEditor.prototype.get_terminology = function () {
	/// <summary>Gets the terminology object.</summary>

	return this._terminology;
}

Dynamicweb.Controls.RulesEditor.prototype.get_tree = function () {
	/// <summary>Gets the reference to expression tree.</summary>

	return this._tree;
}

Dynamicweb.Controls.RulesEditor.prototype.set_tree = function (value) {
	/// <summary>Sets the reference to expression tree.</summary>
	/// <param name="value">A reference to expression tree.</param>

	this._tree = value;
}

Dynamicweb.Controls.RulesEditor.prototype.get_rules = function () {
	/// <summary>Gets the list of all available recognition rules.</summary>

	return this._rules;
}

Dynamicweb.Controls.RulesEditor.prototype.set_rules = function (value) {
	/// <summary>Sets the list of all available recognition rules.</summary>
	/// <param name="value">The list of all available recognition rules.</param>

	this._rules = value;
	this._rulesByFieldIds = new Hash();

	if (this._rules && this._rules.length) {
		for (var i = 0; i < this._rules.length; i++) {
			this._rulesByFieldIds.set(this._rules[i].get_fieldId(), this._rules[i]);
		}
	}
}

Dynamicweb.Controls.RulesEditor.prototype.set_simpleMode = function (value) {
    /// <summary>Sets is simple mode is allowed (only simple combinations are allowed - all AND or all OR).</summary>

    this._simpleMode = value;
}

Dynamicweb.Controls.RulesEditor.prototype.get_associatedControlID = function () {
	/// <summary>Gets the unique identifier of the ASP.NET control that is associated with this client object.</summary>

	return this._associatedControlID;
}

Dynamicweb.Controls.RulesEditor.prototype.set_associatedControlID = function (value) {
	/// <summary>Sets the unique identifier of the ASP.NET control that is associated with this client object.</summary>
	/// <param name="value">The unique identifier of the ASP.NET control that is associated with this client object.</param>

	this._associatedControlID = value;
}

Dynamicweb.Controls.RulesEditor.prototype.get_container = function () {
	/// <summary>Gets the identifier of the DOM element associated with this control.</summary>

	if (!this._container) {
		this._container = $$('input[name="' + this.get_associatedControlID() + '"]');
		if (this._container && this._container.length) {
			this._container = this._container[0].id;
		}
	}

	return this._container;
}

Dynamicweb.Controls.RulesEditor.prototype.set_container = function (value) {
	/// <summary>Sets the identifier of the DOM element associated with this control.</summary>
	/// <param name="value">The identifier of the DOM element associated with this control.</param>

	this._container = value;
}

Dynamicweb.Controls.RulesEditor.prototype.get_expressionRows = function () {
	/// <summary>Gets the list of DOM elements representing rows in expression list.</summary>

	return $(this.get_container()).select('div.recognition-editor-expression div.recognition-editor-expression-container ul');
}

Dynamicweb.Controls.RulesEditor.prototype.get_expressionHeader = function () {
	/// <summary>Gets the reference to DOM element representing expression header row.</summary>

	return $(this.get_container()).select('div.recognition-editor-expression ul.recognition-editor-expression-table-header')[0];
}

Dynamicweb.Controls.RulesEditor.prototype.get_hasExpression = function () {
	/// <summary>Gets value indicating whether there is an existing expression available (that is either loaded or not).</summary>

	return document.getElementById(this.get_container() + '_RulesData').value.length;
}

Dynamicweb.Controls.RulesEditor.prototype.add_ready = function (callback) {
	/// <summary>Registers new callback which is executed when the page is loaded.</summary>
	/// <param name="callback">Callback to register.</param>

	callback = callback || function () { }
	Event.observe(document, 'dom:loaded', function () {
		callback(this, {});
	});
}

Dynamicweb.Controls.RulesEditor.prototype.add_selectionChanged = function (callback) {
	/// <summary>Adds a new callback that is executed when the selection changes.</summary>
	/// <param name="callback">Callback to register.</param>

	if (callback && typeof (callback) == 'function') {
		this._handlers.selectionChanged[this._handlers.selectionChanged.length] = callback;
	}
}

Dynamicweb.Controls.RulesEditor.prototype.clearSelection = function () {
	/// <summary>Clears the selection.</summary>

	this.get_tree().setSelection(null, false, true);
	this.get_state().selectAll.checked = false;
}

Dynamicweb.Controls.RulesEditor.prototype.toExpression = function () {
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
					rule.set_fieldId(foundRule.get_fieldId());
					rule.set_fieldName(foundRule.get_fieldName());
					rule.set_fieldType(foundRule.get_fieldType());
					rule.set_controlType(foundRule.get_controlType());
					//rule.set_operator(foundRule.get_operator());
				}
			} else if (typeof (components[i].get_components) == 'function') {
				fillRulesRecursive(components[i]);
			}
		}
	}

	fillRulesRecursive(ret);

	return ret;
}

Dynamicweb.Controls.RulesEditor.prototype.fromExpression = function (expression) {
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
				//debugger
				foundRule = self.findRule(rule.get_fieldId());

				if (foundRule) {
					rule.set_id(foundRule.get_id());
					rule.set_fieldName(foundRule.get_fieldName());
					rule.set_fieldType(foundRule.get_fieldType());
					rule.set_controlType(foundRule.get_controlType());
					rule.set_dataSource(foundRule.get_dataSource());
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

Dynamicweb.Controls.RulesEditor.prototype.toXml = function () {
	/// <summary>Converts the current recognition expression to XML string.</summary>
	//debugger
	var expression = this.toExpression();
	return new Dynamicweb.Controls.RulesEditor.ExpressionTreeSerializer().toXml(expression);
}

Dynamicweb.Controls.RulesEditor.prototype.fromXml = function (xml) {
	/// <summary>Parses the given XML string and applies the resulting recognition expression.</summary>

	var serializer = new Dynamicweb.Controls.RulesEditor.ExpressionTreeSerializer();
	var expression = serializer.fromXml(xml);

	this.fromExpression(expression);
}

Dynamicweb.Controls.RulesEditor.prototype.commitChanges = function () {
	/// <summary>Commits the changes.</summary>
	document.getElementById(this.get_container() + '_RulesData').value = this.toXml();
}

Dynamicweb.Controls.RulesEditor.prototype.abandonChanges = function () {
	/// <summary>Abandons the changes.</summary>

	document.getElementById(this.get_container() + '_RulesData').value = '';
}

Dynamicweb.Controls.RulesEditor.prototype.initialize = function (onComplete) {
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
		this.get_state().selectAll = c.select('div.recognition-editor-expression ul.recognition-editor-expression-table-header li.recognition-editor-cell-select input')[0];
		this.get_state().createRule = c.select('div.recognition-editor-section-heading')[0];

		/* Canceling "selectstart" event (making out drag'n'drop look prettier) */
		Event.observe(document.body, 'selectstart', function (evt) {
			if (self._isDragging) {
				Event.stop(event);
				event.cancelBubble = true;

				return false;
			}
		});

		/* Configuring "Create rules"*/
		Event.observe(this.get_state().createRule, 'click', function (evt) {
			var allRules = self.get_rules();
			if (allRules && allRules.length && allRules.length > 0)
				self._onRuleDropped(allRules[0]);
		});

		/* Configuring "Select/Deselect all" checkbox */
		Event.observe(self.get_state().selectAll, 'click', function (evt) {
			self.get_tree().setSelection(null, Event.element(evt).checked, true);
		});

		/* Configuring expression tree */
		this.set_tree(new Dynamicweb.Controls.RulesEditor.Tree());
		this.get_tree().add_update(function (sender, e) {
			self.onTreeUpdate(sender, e);
			updateSelectAllState(self.get_tree().selection(null, true));
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

							if (checkbox) checkbox.checked = true;
							row.addClassName('recognition-editor-row-selected');

							rowFound = true;
							break;
						}
					}

					if (!rowFound) {
						row.removeClassName('recognition-editor-row-selected');
						if (checkbox) checkbox.checked = false;
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

		/* Preloading this image since it's quite big (1000x5001, 21kb) */
		this.preloadImage('/Admin/Module/OMC/img/selection.png');

		/* Reloading rules */
		this.reloadRules(function () {
			onComplete();
		});

		this._initialized = true;
	} else {
		onComplete();
	}
}

Dynamicweb.Controls.RulesEditor.prototype.preloadImage = function (url) {
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

Dynamicweb.Controls.RulesEditor.prototype.onTreeUpdate = function (sender, e) {
	/// <summary>Handles the tree "update" event.</summary>
	/// <param name="sender">Event sender.</param>
	/// <param name="e">Event arguments.</param>

	//debugger

	var renderer = null;

	if (e.type == 'structure') {
		renderer = new Dynamicweb.Controls.RulesEditor.TreeRenderer(this);
		renderer.renderTree();

		this.onSelectionChanged({ selection: this.get_tree().selection(null, true) });
	}
}

Dynamicweb.Controls.RulesEditor.prototype.reloadRules = function (onComplete) {
	/// <summary>Reloads and renders the list of all available rules.</summary>
	/// <param name="onComplete">A callback that is fired when the list of rules has been reloaded and rendered.</param>

	var self = this;
	var dataLoading = $($(this.get_container()).select('div.recognition-editor-loading')[0]);

	onComplete = onComplete || function () { }

	this.set_rules(null);

	dataLoading.show();

	this.retrieveRules(function (rules) {
		dataLoading.hide();
		self.reloadExpression();
		onComplete();
	});
}

Dynamicweb.Controls.RulesEditor.prototype.reloadExpression = function () {
	/// <summary>Reloads the current recognition expression.</summary>
	this.fromXml(document.getElementById(this.get_container() + '_RulesData').value);
}

Dynamicweb.Controls.RulesEditor.prototype.retrieveRules = function (onComplete) {
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

Dynamicweb.Controls.RulesEditor.prototype.findRule = function (ruleID) {
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
			if (typeof (this._rulesByNodes[f]) != 'function' && typeof (this._rulesByNodes[f].get_id) == 'function') {
				if (this._rulesByNodes[f].get_id() == ruleID) {
					ret = this._rulesByNodes[f];
					break;
				}
			}
		}
	}

	if (!ret) {
		ret = this._rulesByFieldIds.get(ruleID) || null;
	}

	return ret;
}

Dynamicweb.Controls.RulesEditor.prototype.set_ruleFieldsProvider = function (ruleFieldsProvider) {
    this._ruleFieldsProvider = ruleFieldsProvider;
}


Dynamicweb.Controls.RulesEditor.prototype.loadRules = function (onComplete) {
    /// <summary>Loads the list of all available rules from the server.</summary>
    /// <param name="onComplete">A callback that is fired when the list of rules becomes available.</param>

    var rules = [];
    var rule = null;

    onComplete = onComplete || function () { };
    onCompleteHandler = function (data) {
        if (data && data.rules && data.rules.length) {
            for (var i = 0; i < data.rules.length; i++) {
                rule = new Dynamicweb.Controls.RulesEditor.Rule();
                rule.load(data.rules[i]);

                rules[rules.length] = rule;
            }

            onComplete(rules);
        } else {
            onComplete([]);
        }
    };

    if (this._ruleFieldsProvider) {
        this._ruleFieldsProvider(onCompleteHandler);
    }
    else {
        //onComplete([]);
        Dynamicweb.Ajax.DataLoader.load({ target: this.get_associatedControlID(), argument: 'Rules', onComplete: onCompleteHandler });
    }
}

Dynamicweb.Controls.RulesEditor.prototype.onSelectionChanged = function (e) {
	/// <summary>Fires "selectionChanged" event.</summary>
	/// <param name="e">Event arguments.</param>

	this.notify('selectionChanged', e);
}

Dynamicweb.Controls.RulesEditor.prototype.notify = function (eventName, args) {
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

Dynamicweb.Controls.RulesEditor.prototype._onRuleDropped = function (rule) {
	/// <summary>Occurs when the rule has been dropped onto the expression area.</summary>
	/// <param name="rule">The rule that has been dropped.</param>
	/// <private />

	var node = {};

	this._prepareNode(node, rule);

	this.get_tree().append(node, null);
}

Dynamicweb.Controls.RulesEditor.prototype._prepareNode = function (n, rule) {
	/// <summary>Prepares the given tree node to be added to the expression tree.</summary>
	/// <param name="n">Node to prepare.</param>
	/// <param name="rule">Associated node rule.</param>
	/// <private />

	var nodeID = '';
	var attachedRule = null;

	var setField = function (name, value) {
		if (typeof (n['set_' + name]) == 'function') {
			n['set_' + name](value);
		} else {
			n[name] = value;
		}
	}

	var createNodeRule = function (generatedNodeID) {
		var r = new Dynamicweb.Controls.RulesEditor.Rule();

		r.load(rule);
		r.set_id(r.get_id() + '_' + generatedNodeID);

		return r;
	}

	if (n && rule) {
		nodeID = this.get_tree().generateNodeID();
		attachedRule = createNodeRule(nodeID);
		this._rulesByNodes[nodeID] = attachedRule;

		setField('id', nodeID);
		setField('rule', attachedRule.get_id());
		setField('ruleFieldId', rule.get_fieldId());
		setField('constraintOperator', rule.get_operator());
		setField('constraintValues', [rule.get_valueFrom(), rule.get_valueTo()]);
	}
}

Dynamicweb.Controls.RulesEditor.prototype._makeRulesDraggable = function () {
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

Dynamicweb.Controls.RulesEditor.prototype._getDraggableContainer = function () {
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

Dynamicweb.Controls.RulesEditor.prototype._onClick = function (event) {
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

Dynamicweb.Controls.RulesEditor.prototype._getConditionItems = function (ctrlType) {
	var result = new Array();

	var conditionalTypes = new Array();

	switch (ctrlType) {
		case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.contains);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotContain);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.startsWith);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotStartWith);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.endsWith);
            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotEndWith);
			break;

		case Dynamicweb.Controls.RulesEditor.CtrlType.RateCtrl:
		case Dynamicweb.Controls.RulesEditor.CtrlType.NumericBox:
		case Dynamicweb.Controls.RulesEditor.CtrlType.FloatNumericBox:
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.greaterThanOrEqualTo);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.lessThanOrEqualTo);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isInRange);
			break;

	    case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
    		conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.contains);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotContain);

			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.startsWith);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotStartWith);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.endsWith);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotEndWith);
			break;

		case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
		case Dynamicweb.Controls.RulesEditor.CtrlType.FileSelectorCtrl:
		case Dynamicweb.Controls.RulesEditor.CtrlType.LinkSelectorCtrl:
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);
			break;

        case Dynamicweb.Controls.RulesEditor.CtrlType.DateCtrl:
	    case Dynamicweb.Controls.RulesEditor.CtrlType.DateTimeCtrl:
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);

	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isBefore);
            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isAfter);

            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isEmpty);
            conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isNotEmpty);
	        break;

	    case Dynamicweb.Controls.RulesEditor.CtrlType.AnoterTimeCtrl:
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isBefore);
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isAfter);
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotOccurBefore);
	        conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.doesNotOccurAfter);
	        break;

	    case Dynamicweb.Controls.RulesEditor.CtrlType.EmailCtrl:
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);
			break;

		case Dynamicweb.Controls.RulesEditor.CtrlType.PageCtrl:
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
			conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.isUnder);
            break;

	    case Dynamicweb.Controls.RulesEditor.CtrlType.ProductCtrl:
	    	conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.equals);
	    	conditionalTypes.push(Dynamicweb.Controls.RulesEditor.Operator.notEqualTo);
	    	break;
	}

	if (conditionalTypes.length>0) {
		var term = '';
		var names = Dynamicweb.Controls.RulesEditor.Operator.getNames();

		for (var i = 0; i < conditionalTypes.length; i++) {
			term = this.get_terminology()[Dynamicweb.Controls.RulesEditor.Enumeration.pascalCaseField(names[(conditionalTypes[i])])];
			result.push(new Dynamicweb.Controls.RulesEditor.ListItem(term, conditionalTypes[i]));
		}
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._createConditionDropDown = function (ctrlType, row_id, node) {
	/// <summary>Creates a "Condition" drop-down list.</summary>
	/// <private />
	var result = null;

	if (node) {
		var self = this;

		var ctrlId = "cond_" + row_id;
		var items = this._getConditionItems(ctrlType);
		var val = node.get_constraintOperator();

		if (val == null)
			val = Dynamicweb.Controls.RulesEditor.Operator.equals;

		result = new Dynamicweb.Controls.RulesEditor.DropDownListCtrl(ctrlId, val, items, function (e) {
			var rule = self.findRule(node.get_rule());

			if (rule) {
				var prevOperator = node.get_constraintOperator() != null ? node.get_constraintOperator()
														:  Dynamicweb.Controls.RulesEditor.Operator.equals;

				var val = self._getDefaultValue(rule.get_controlType());
				var values = node.get_constraintValue() != null ? node.get_constraintValue() : [val, null];

				if (prevOperator == Dynamicweb.Controls.RulesEditor.Operator.isInRange)
					values[1] = null;

				if (e == Dynamicweb.Controls.RulesEditor.Operator.isInRange)
					values[1] = val;

				node.set_constraintOperator(e);
				node.set_constraintValue(values);
				self.get_tree().UpdateAll();
			}
		});
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._createValueCtrlByRule = function (rule, row_id, rangeNumber, val, onChange) {
	var result = null;

	if (rule) {
		var ctrlId = "val" + rangeNumber + "_" + row_id + "_" + rule.get_id();

		switch (rule.get_controlType()) {
			case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
				result = new Dynamicweb.Controls.RulesEditor.TextBoxCtrl(ctrlId, val, onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.NumericBox:
				result = new Dynamicweb.Controls.RulesEditor.NumericBoxCtrl(ctrlId, val, onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.FloatNumericBox:
				result = new Dynamicweb.Controls.RulesEditor.FloatNumericBoxCtrl(ctrlId, val, onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
      result = new Dynamicweb.Controls.RulesEditor.DropDownListCtrl(ctrlId, val, rule.get_dataSource(), onChange, {
				allowExpression: true
			});

				// Fire onChange with actual value of drop down
				try {
					var list = Element.match(result, 'select') ? result : Element.select(result, 'select')[0];
					if (list && list.value != val && onChange) {
						onChange(list.value);
					}
				} catch (ex) {}
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
				result = new Dynamicweb.Controls.RulesEditor.BooleanCtrl(ctrlId, val, onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.RateCtrl:
				var isFiveStars = (rangeNumber != 1);
				result = new Dynamicweb.Controls.RulesEditor.RateCtrl(ctrlId, val, isFiveStars, onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.FileSelectorCtrl:
				result = new Dynamicweb.Controls.RulesEditor.FileSelectorCtrl(ctrlId, val, rule.get_dataSource(), onChange);
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.LinkSelectorCtrl:
				result = new Dynamicweb.Controls.RulesEditor.LinkSelectorCtrl(ctrlId, val, onChange);
				break;

		    case Dynamicweb.Controls.RulesEditor.CtrlType.DateTimeCtrl:
		    case Dynamicweb.Controls.RulesEditor.CtrlType.AnoterTimeCtrl:
		        var nameOfMonths = this._terminology['NameOfMonths'];
		        result = new Dynamicweb.Controls.RulesEditor.DateTimeCtrl(ctrlId, val, nameOfMonths, onChange, true);
		        break;

		    case Dynamicweb.Controls.RulesEditor.CtrlType.DateCtrl:
		        var nameOfMonths = this._terminology['NameOfMonths'];
		        result = new Dynamicweb.Controls.RulesEditor.DateTimeCtrl(ctrlId, val, nameOfMonths, onChange, false);
		        break;

		    case Dynamicweb.Controls.RulesEditor.CtrlType.EmailCtrl:
				result = new Dynamicweb.Controls.RulesEditor.EmailCtrl(ctrlId, val, onChange);
				break;

		    case Dynamicweb.Controls.RulesEditor.CtrlType.PageCtrl:
		        result = new Dynamicweb.Controls.RulesEditor.PageCtrl(ctrlId, val, onChange);
		        break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.ProductCtrl:
		        result = new Dynamicweb.Controls.RulesEditor.ProductCtrl(ctrlId, val, onChange);
		        break;
		}
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._getDefaultValue = function (controlType){
	var result = "";

	if (controlType && isFinite(controlType)){
		switch (controlType) {
			case Dynamicweb.Controls.RulesEditor.CtrlType.TextBox:
			case Dynamicweb.Controls.RulesEditor.CtrlType.DropDownList:
			case Dynamicweb.Controls.RulesEditor.CtrlType.FileSelectorCtrl:
			case Dynamicweb.Controls.RulesEditor.CtrlType.LinkSelectorCtrl:
		    case Dynamicweb.Controls.RulesEditor.CtrlType.DateTimeCtrl:
		    case Dynamicweb.Controls.RulesEditor.CtrlType.DateCtrl:
		        result = "";
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.NumericBox:
			case Dynamicweb.Controls.RulesEditor.CtrlType.BooleanCtrl:
			case Dynamicweb.Controls.RulesEditor.CtrlType.RateCtrl:
				result = "0";
				break;

			case Dynamicweb.Controls.RulesEditor.CtrlType.FloatNumericBox:
				result = "0.00";
				break;
		}
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._createValueCtrl = function (node, row_id) {
	/// <summary>Creates a "Condition" drop-down list ctrl.</summary>
	/// <private />
	var result = null;

	//debugger

	var self = this;
	var rule = node ? self.findRule(node.get_rule()) : null;

	if (rule != null) {
		//debugger
		var defVal = self._getDefaultValue(rule.get_controlType());
		var values = node.get_constraintValue() != null ? node.get_constraintValue() : [defVal, null];

		var operator = node.get_constraintOperator() != null ? node.get_constraintOperator()
																: Dynamicweb.Controls.RulesEditor.Operator.equals;

		var isRange = (operator == Dynamicweb.Controls.RulesEditor.Operator.isInRange);

		if (isRange && values[1] == null) values[1] = defVal;

		var divContainer = document.createElement('div');
		divContainer.style.display = "block";
		divContainer.style.width = '260px';

		if (isRange) {
			divContainer.innerText = "";

			var divLeft = document.createElement('div');
			divLeft.style.cssText = "width: 110px; float: left;";

			var divRight = document.createElement('div');
			divRight.style.cssText = "width: 110px; float: left; margin-left: 10px;";

			var ctrlLeft = self._createValueCtrlByRule(rule, row_id, 1, values[0], function (e) {
				var rule = self.findRule(node.get_rule());

				var val = self._getDefaultValue(rule.get_controlType());
				var values = node.get_constraintValue() != null ? node.get_constraintValue() : [val, null];
				values[0] = e.toString();
				node.set_constraintValue(values);
			});

			ctrlLeft.style.cssText = 'width:110px !important;';

			var ctrlRight = self._createValueCtrlByRule(rule, row_id, 2, values[1], function (e) {
				var rule = self.findRule(node.get_rule());

				var val = self._getDefaultValue(rule.get_controlType());
				var values = node.get_constraintValue() != null ? node.get_constraintValue() : [val, null];
				values[1] = e.toString();
				node.set_constraintValue(values);
			});

			ctrlRight.style.cssText = 'width:120px !important;';

			divLeft.appendChild(ctrlLeft);
			divRight.appendChild(ctrlRight);

			divContainer.appendChild(divLeft);
			divContainer.appendChild(divRight);
        }
        else if (operator == Dynamicweb.Controls.RulesEditor.Operator.isEmpty || operator == Dynamicweb.Controls.RulesEditor.Operator.isNotEmpty) {
            result = null;
        }
		else {

			var ctrl = self._createValueCtrlByRule(rule, row_id, 0, values[0], function (e) {
				var rule = self.findRule(node.get_rule());

				var val = self._getDefaultValue(rule.get_controlType());
				var values = node.get_constraintValue() != null ? node.get_constraintValue() : [val, null];
				values[0] = e.toString();
				node.set_constraintValue(values);
			});

			divContainer.appendChild(ctrl);
		}

		result = divContainer;
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._createFieldDropDown = function (row_id, node) {
	/// <summary>Creates a "Condition" drop-down list.</summary>
	/// <private />
	var result = null;

	if (node) {

		var self = this;
		var allRules = self.get_rules();

		var items = new Array();
		var ctrlId = "field_" + row_id;

		for (var i = 0; i < allRules.length; i++) {
			items.push(new Dynamicweb.Controls.RulesEditor.ListItem(allRules[i].get_fieldName(), allRules[i].get_fieldId()));
		}

		var value = (!node.get_ruleFieldId() || node.get_ruleFieldId() == "") ? items[0].get_value() : node.get_ruleFieldId();

		result = new Dynamicweb.Controls.RulesEditor.DropDownListCtrl(ctrlId, value, items, function (e) {
			var rule = self.findRule(e);

			//debugger

			if (rule) {
				var r = new Dynamicweb.Controls.RulesEditor.Rule();
				r.load(rule);
				r.set_id((r.get_id() + '_' + node.get_id()));

				delete self._rulesByNodes[node.get_rule()];
				self._rulesByNodes[r.get_id()] = r;

				var val = self._getDefaultValue(r.get_controlType());

				node.set_rule(r.get_id());
				node.set_ruleFieldId(e);
				node.set_constraintOperator(Dynamicweb.Controls.RulesEditor.Operator.equals);
				node.set_constraintValue([val, null]);
				self.get_tree().UpdateAll();
			}
		});

		result.className = 'std';
		result.style.width = '140px';
	}

	return result;
}

Dynamicweb.Controls.RulesEditor.prototype._createDeleteCtrl = function (node) {
    var self = this;
    var icon = document.createElement('i');
    icon.className = "fa fa-remove color-danger btn btn-clean"
    icon.onclick = function () {
        self.get_tree().removeRange([node._id])
    };
    return icon;
}
