package com.maninsoft.smart.formeditor.view.dialog
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.controls.KoreanTextArea;
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.Map;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.model.FieldMapping;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.refactor.simple.navigator.FormItemProxy;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.util.FormEditorService;
	import com.maninsoft.smart.formeditor.view.dialog.util.ArithmeticOperatorComboBox;
	import com.maninsoft.smart.formeditor.view.dialog.util.FormLinkComboBox;
	import com.maninsoft.smart.formeditor.view.dialog.util.MappingTypeComboBox;
	import com.maninsoft.smart.formeditor.view.dialog.util.OutMappingTypeComboBox;
	import com.maninsoft.smart.formeditor.view.dialog.util.ServiceLinkComboBox;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.assets.TreeAssets;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;
	import mx.collections.XMLListCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.Menu;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.AdvancedListBaseContentHolder;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.MenuEvent;
	import mx.resources.ResourceManager;
	
	public class MappingDialog extends AbstractDialog
	{
		public static const DIRECTION_IMPORT:String = "import";
		public static const DIRECTION_EXPORT:String = "export";
			
		private var _formEditorBase:FormEditorBase;
		private var _direction:String = DIRECTION_IMPORT;
		private var _field:FormEntity;
		private var _mapping:Mapping;
		[Bindable]
		private var expressionTree:XMLListCollection = new XMLListCollection();
		[Bindable]
		private var fieldType:String;
		[Bindable]
		private var fieldMappings:ArrayCollection = new ArrayCollection();
			
		private var nameInput:KoreanTextInput = new KoreanTextInput;
/// Table Record 기능 추가 시작			
		private var tableRecordHBox:HBox = new HBox();
		private var tableRecordLabel:Label = new Label();
		private var tableRecordCheckBox:CheckBox = new CheckBox();
		private var tableFormLinkHBox:HBox = new HBox();
		private var tableFormLinkComboBox:FormLinkComboBox = new FormLinkComboBox();;
/// Table Record 기능 추가 종료		
		private var expressionDataGrid:AdvancedDataGrid = new AdvancedDataGrid();	
		private var labelColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var operatorColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var mappingTypeColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var formLinkColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var fieldColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var valueFunctionColumn:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		private var expressionLabel:Label = new Label();
		private var expressionTextArea:KoreanTextArea = new KoreanTextArea();
		private var fieldMappingLabel:Label = new Label();
		private var fieldMappingDataGrid:DataGrid = new DataGrid();
		private var eachTimeBox:VBox = new VBox();
		private var eachTimeRadioButtonGroup:RadioButtonGroup = new RadioButtonGroup();	
	
		private var _linkConditionDG:DataGrid = new DataGrid();
		private	var _deleteItemCol:DataGridColumn = new DataGridColumn();
		private	var _leftOperandCol:DataGridColumn = new DataGridColumn();
		private	var _operatorCol:DataGridColumn = new DataGridColumn();
		private	var _rightOperandTypeCol:DataGridColumn = new DataGridColumn();
		private	var _rightOperandCol:DataGridColumn = new DataGridColumn();

		private var condsOperatorRadioGroup: RadioButtonGroup = new RadioButtonGroup();

		private var	deleteItemEditor:ButtonPropertyEditor;			
		private var leftOperandEditor:ButtonPropertyEditor;				
		private var operatorComboBox:ComboBoxPropertyEditor;
		private var rightOperandTypeComboBox:ComboBoxPropertyEditor;
		private var rightOperandEditor:ButtonPropertyEditor;
		private var radioButtonGroupBox:VBox = new VBox();

		[Bindable]
		private var conds:ArrayCollection=null;
		private var fieldOptions:ArrayCollection = null;

		public function MappingDialog(){
			super();
			this.title = resourceManager.getString("FormEditorETC", "dataImportText");
			this.width = 680;
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}

		public function get formEditorBase():FormEditorBase{
			return _formEditorBase;
		}
		
		public function set formEditorBase(value:FormEditorBase):void{
			_formEditorBase = value;
		}
		
		public function get field():FormEntity {
			return _field;
		}
		public function set field(field:FormEntity):void {
			if (this._field == field)
				return;
			this._field = field;
			fieldType = field.format.type;
			if (fieldType == FormatTypes.dataGrid.type){
				tableRecordHBox.visible = true;
				tableFormLinkComboBox.form = field.root;
			}else{
				this.contentBox.removeChild(tableRecordHBox);
			}
			refresh();
		}
		public function get mapping():Mapping {
			return _mapping;
		}
		public function set mapping(mapping:Mapping):void {
			if (this._mapping == mapping)
				return;
			this._mapping = mapping;
			refresh();
		}
		public function get direction():String {
			return _direction;
		}
		public function set direction(direction:String):void {
			this._direction = direction;
			if(direction == DIRECTION_EXPORT){
//				this.contentBox.removeChild(tableRecordHBox);
				tableRecordHBox.visible = false;
				tableRecordHBox.height = 0;
			}else{
				this.contentBox.removeChild(_linkConditionDG);				
				this.contentBox.removeChild(radioButtonGroupBox);
			}
			
			refresh();
		}
		
		override protected function childrenCreated():void{

			var nameHBox:HBox = new HBox();
			nameHBox.percentHeight = 100;
			nameHBox.percentWidth = 100;
			nameHBox.setStyle("verticalAlign", "middle");
			
			var nameLabel:Label = new Label();
			nameLabel.width = 80;
			nameLabel.text = resourceManager.getString("FormEditorETC", "descriptionText");
			nameHBox.addChild(nameLabel);
			
			nameInput.percentWidth = 100;
			nameHBox.addChild(nameInput);
			this.contentBox.addChild(nameHBox);

//// Table Record 기능 추가 시작			
			tableRecordHBox.percentHeight = 100;
			tableRecordHBox.percentWidth = 100;
			tableRecordHBox.setStyle("verticalAlign", "middle");
			
			tableRecordLabel.width = 80;
			tableRecordLabel.text = resourceManager.getString("FormEditorETC", "tableRecordsText");
			tableRecordHBox.addChild(tableRecordLabel);
			
			tableRecordCheckBox.width = 20;
			tableRecordCheckBox.addEventListener(MouseEvent.CLICK, tableRecordCheckBoxClick);
			tableRecordHBox.addChild(tableRecordCheckBox);
			
			tableFormLinkHBox.percentHeight = 100;
			tableFormLinkHBox.percentWidth = 100;
			tableFormLinkHBox.visible = false;
			tableFormLinkHBox.setStyle("verticalAlign", "middle");
			
			var tableFormLinkLabel:Label = new Label();
			tableFormLinkLabel.width = 100;
			tableFormLinkLabel.text =  resourceManager.getString("FormEditorETC", "targetWorkText");
			tableFormLinkLabel.setStyle("textAlign", "right");
			tableFormLinkHBox.addChild(tableFormLinkLabel);
			
			tableFormLinkComboBox.width = 300;
			tableFormLinkComboBox.setStyle("horizontalAlign", "left");
			tableFormLinkHBox.addChild(tableFormLinkComboBox);				
			
			tableRecordHBox.addChild(tableFormLinkHBox);
			this.contentBox.addChild(tableRecordHBox);
/// Table Record 기능 추가 종료			
	
			expressionLabel.text = resourceManager.getString("FormEditorETC", "conditionText");
			expressionLabel.percentWidth = 100;
			expressionLabel.height = 22;
			this.contentBox.addChild(expressionLabel);

			_deleteItemCol.headerText=resourceManager.getString('ProcessEditorETC', 'deleteItemText');
			_deleteItemCol.width = 40;
			_deleteItemCol.editable = true;
			_deleteItemCol.itemEditor=new ClassFactory(ButtonPropertyEditor);

			_leftOperandCol.dataField="firstOperandName";
			_leftOperandCol.headerText=resourceManager.getString('ProcessEditorETC', 'targetWorksNItemText');
			_leftOperandCol.width = 185;
			_leftOperandCol.editable = true;
			_leftOperandCol.itemEditor=new ClassFactory(ButtonPropertyEditor);

			_operatorCol.dataField="operatorName";
			_operatorCol.headerText=resourceManager.getString('ProcessEditorETC', 'operatorText');
			_operatorCol.width = 90;
			_operatorCol.editable = true;
			_operatorCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_rightOperandTypeCol.dataField="secondOperandTypeName";
			_rightOperandTypeCol.headerText=resourceManager.getString('FormEditorETC', 'targetValueTypeText');
			_rightOperandTypeCol.width = 120;
			_rightOperandTypeCol.editable = true;
			_rightOperandTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_rightOperandCol.dataField="secondOperandName";
			_rightOperandCol.headerText=resourceManager.getString('ProcessEditorETC', 'againstValueText');
			_rightOperandCol.width = 185;
			_rightOperandCol.editable = true;
			
			_linkConditionDG.columns = [_deleteItemCol, _leftOperandCol, _operatorCol, _rightOperandTypeCol, _rightOperandCol];
			_linkConditionDG.styleName="selectLinkConditionDG"
			_linkConditionDG.height=0;
			_linkConditionDG.percentWidth=100;
			_linkConditionDG.dataProvider = conds;
			_linkConditionDG.showHeaders=true;
			_linkConditionDG.headerHeight=21;
			_linkConditionDG.rowHeight=23;
			_linkConditionDG.visible=false;
			_linkConditionDG.editable=true;
			_linkConditionDG.selectable=true;
			_linkConditionDG.sortableColumns=false;
			_linkConditionDG.draggableColumns=false;
			_linkConditionDG.resizableColumns=false;
			_linkConditionDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_linkConditionDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.contentBox.addChild(_linkConditionDG);

			radioButtonGroupBox.styleName="linkConditionGroupBox";
			radioButtonGroupBox.visible=false;
			radioButtonGroupBox.height=0;
			
			condsOperatorRadioGroup.selectedValue=Conds.OPERATOR_AND;
			
			var andRadioButton:RadioButton = new RadioButton();
			andRadioButton.group = condsOperatorRadioGroup;
			andRadioButton.height = 21;
			andRadioButton.label = resourceManager.getString('FormEditorETC', 'andNCommentsEText');
			andRadioButton.value = Conds.OPERATOR_AND;
			radioButtonGroupBox.addChild(andRadioButton);

			var orRadioButton:RadioButton = new RadioButton();
			orRadioButton.group = condsOperatorRadioGroup;
			orRadioButton.height = 21;
			orRadioButton.label = resourceManager.getString('FormEditorETC', 'orNCommentsEText');
			orRadioButton.value = Conds.OPERATOR_OR;
			radioButtonGroupBox.addChild(orRadioButton);
			this.contentBox.addChild(radioButtonGroupBox);
			
			_linkConditionDG.addEventListener(MouseEvent.CLICK, checkCond);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, condEditBegin);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_END, condEditEnd);			


			labelColumn.headerText = resourceManager.getString("FormEditorETC", "conditionNameText");
			labelColumn.dataField = "@label";
			labelColumn.editable = false;
			labelColumn.width = 100;			
			operatorColumn.headerText = "";
			operatorColumn.dataField = "@operatorName";
			operatorColumn.width = 30;
			operatorColumn.setStyle("textAlign", "center");
			operatorColumn.itemEditor = new ClassFactory(ArithmeticOperatorComboBox);
			mappingTypeColumn.headerText = resourceManager.getString("FormEditorETC", "dataTypeText");
			mappingTypeColumn.dataField = "@mappingTypeName";
			mappingTypeColumn.width = 80;
			mappingTypeColumn.itemEditor = new ClassFactory(MappingTypeComboBox);
			formLinkColumn.headerText = resourceManager.getString("FormEditorETC", "targetWorkText");
			formLinkColumn.dataField = "@formLinkName";
			formLinkColumn.width = 90;
			fieldColumn.headerText = resourceManager.getString("FormEditorETC", "targetItemText");
			fieldColumn.dataField = "@fieldName";
			fieldColumn.width = 80;
			fieldColumn.itemEditor = new ClassFactory(SimpleComboBox);
			valueFunctionColumn.headerText = resourceManager.getString("FormEditorETC", "targetValueTypeText");
			valueFunctionColumn.dataField = "@valueFunctionName";
			valueFunctionColumn.width = 50;
			valueFunctionColumn.itemEditor = new ClassFactory(SimpleComboBox);
			
			expressionDataGrid.styleName = "mappingExpressionDG";
			expressionDataGrid.height = 200;
			expressionDataGrid.percentWidth = 100;
			expressionDataGrid.rowHeight = 22;
			expressionDataGrid.designViewDataType = "tree";
			expressionDataGrid.sortableColumns = false;
			expressionDataGrid.editable = "true";
			expressionDataGrid.setStyle("verticalAlign", "middle"); 
			expressionDataGrid.dataProvider = new HierarchicalData(expressionTree);
			expressionDataGrid.iconFunction = getIcon;
			expressionDataGrid.setStyle("disclosureClosedIcon", TreeAssets.plusIcon);
			expressionDataGrid.setStyle("disclosureOpenIcon", TreeAssets.minusIcon);
			expressionDataGrid.addEventListener(MouseEvent.CLICK, expressionClick);
			expressionDataGrid.addEventListener(ListEvent.ITEM_CLICK, expressionItemClick);
			expressionDataGrid.addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGIN, expressionEditBegin);
			expressionDataGrid.addEventListener(AdvancedDataGridEvent.ITEM_EDIT_END, expressionEditEnd);
			expressionDataGrid.columns = [ labelColumn, operatorColumn, mappingTypeColumn, formLinkColumn, fieldColumn, valueFunctionColumn];
			this.contentBox.addChild(expressionDataGrid);
			
//			expressionTextArea.percentWidth = 100;
//			expressionTextArea.height = 0;
//			expressionTextArea.visible = false;
//			this.contentBox.addChild(expressionTextArea);

			fieldMappingLabel.text = resourceManager.getString("FormEditorETC", "itemConnectText");
			fieldMappingLabel.percentWidth = 100;
			fieldMappingLabel.height = 0;
			this.contentBox.addChild(fieldMappingLabel);

			var tableItemColumn:DataGridColumn = new DataGridColumn();
			tableItemColumn.headerText = resourceManager.getString("FormEditorETC", "tableItemText");
			tableItemColumn.dataField = "leftOperandName";
			tableItemColumn.width = 200;
			tableItemColumn.editable = false;			
			var targetItemColumn:DataGridColumn = new DataGridColumn();
			targetItemColumn.headerText = resourceManager.getString("FormEditorETC", "targetWorkNItemText");
			targetItemColumn.dataField = "rightOperandName";
			targetItemColumn.width = 200;
			targetItemColumn.itemEditor = new ClassFactory(SimpleComboBox);
			
			fieldMappingDataGrid.styleName = "mappingFieldMappingDG";			
			fieldMappingDataGrid.percentWidth = 100;
			fieldMappingDataGrid.height = 0;
			fieldMappingDataGrid.setStyle("verticalAlign", "middl");
			fieldMappingDataGrid.sortableColumns = false;
			fieldMappingDataGrid.editable = true;
			fieldMappingDataGrid.dataProvider = fieldMappings;
			fieldMappingDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, fieldMappingEditBegin);
			fieldMappingDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END, fieldMappingEditEnd);
			fieldMappingDataGrid.addEventListener(MouseEvent.CLICK, fieldMappingClick);
			fieldMappingDataGrid.columns = [tableItemColumn, targetItemColumn];
			this.contentBox.addChild(fieldMappingDataGrid);

			eachTimeBox.setStyle("verticalGap", 2);
			eachTimeRadioButtonGroup.selectedValue = "and";
			eachTimeRadioButtonGroup.addEventListener(Event.CHANGE, rename);
			
			var onceRadioButton:RadioButton = new RadioButton();
			onceRadioButton.group = eachTimeRadioButtonGroup;
			onceRadioButton.label = resourceManager.getString("FormEditorETC", "onceNCommentsText");
			onceRadioButton.value = false;
			eachTimeBox.addChild(onceRadioButton);
			var everytimeRadioButton:RadioButton = new RadioButton();
			everytimeRadioButton.group = eachTimeRadioButtonGroup;
			everytimeRadioButton.label = resourceManager.getString("FormEditorETC", "everytimeNCommentsText");
			everytimeRadioButton.value = true;
			eachTimeBox.addChild(everytimeRadioButton);
			this.contentBox.addChild(eachTimeBox);

		}
			
		private function refresh():void {
			if (field == null)
				return;
			
			if (!SmartUtil.isEmpty(expressionTree))
				expressionTree.removeAll();
				
			if (mapping == null) {
				mapping = new Mapping(field.mappings);
				return;
			}
				
			// 이름
			nameInput.text = mapping.name;
				
			eachTimeRadioButtonGroup.selectedValue = mapping.eachTime;
			
			tableRecordCheckBox.selected = false;
			tableFormLinkHBox.visible = false;
			if(mapping.type == Mapping.TYPE_TABLE_RECORDS){
				tableRecordCheckBox.selected = true;
				tableFormLinkHBox.visible = true;
				tableFormLinkComboBox.selectItem(mapping.formLinkId);
				// 항목연결
				fieldMappingLabel.height = 22;
				fieldMappingDataGrid.height = 200;
				expressionLabel.height = 0;
				expressionDataGrid.height = 0;
				
				fieldMappings.removeAll();
				if (!SmartUtil.isEmpty(mapping.fieldMappings)) {
					for each (var fieldMapping:FieldMapping in mapping.fieldMappings)
						fieldMappings.addItem(fieldMapping);
				}
				refreshFieldMappings();
			
			}
			// 계산식
			if (SmartUtil.isEmpty(mapping.expressionTree) && !SmartUtil.isEmpty(mapping.expression)) {
//				expressionTextArea.text = mapping.expression;
//				expressionTextArea.height = 100;
//				expressionTextArea.visible = true;
			} else {
				if (!SmartUtil.isEmpty(mapping.expressionTree)) {
					var expressionTreeClone:XML = new XML(mapping.expressionTree);
					for each (var nodeXML:XML in expressionTreeClone.children())
						expressionTree.addItem(nodeXML);
				} else {
					var node:ExpressionNode = new ExpressionNode();
					node.label = mapping.name;
					node.operator = "+";
					node.operatorName = ExpressionNode.toOperatorName(node.operator);
					node.mappingType = mapping.mappingType;
					node.mappingTypeName = ExpressionNode.toMappingTypeName(mapping.mappingType);
					node.formLinkId = mapping.formLinkId;
					node.formLinkName = SmartUtil.toDefault(mapping.formLinkName, mapping.formLinkId);
					node.serviceLinkId = mapping.serviceLinkId;
					node.serviceLinkName = SmartUtil.toDefault(mapping.serviceLinkName, mapping.serviceLinkId);
					node.activityId = mapping.activityId;
					node.fieldId = mapping.fieldId;
					node.fieldName = SmartUtil.toDefault(mapping.fieldName, mapping.fieldId);
					node.valueFunction = mapping.valueFunction;
					node.valueFunctionName = SmartUtil.toDefault(ExpressionNode.toValueFunctionName(mapping.valueFunction), mapping.valueFunction);
					if (direction == DIRECTION_EXPORT) {
						if (   node.mappingType != ExpressionNode.MAPPINGTYPE_OTHERFORM 
							&& node.mappingType != ExpressionNode.MAPPINGTYPE_PROCESSFORM
							&& node.mappingType != ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
							node.mappingType = ExpressionNode.MAPPINGTYPE_OTHERFORM;
							node.mappingTypeName = ExpressionNode.toMappingTypeName(ExpressionNode.MAPPINGTYPE_OTHERFORM);
							node.formLinkId = null;
							node.formLinkName = null;
							node.serviceLinkId = null;
							node.serviceLinkName = null;
							node.activityId = null;
							node.fieldId = null;
							node.fieldName = null;
							node.valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
							node.valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
						}
						expressionTree.addItem(node.toXML());
					} else if (!SmartUtil.isEmpty(node.label) && !SmartUtil.isEmpty(node.mappingType)) {
						expressionTree.addItem(node.toXML());
					}
				}
			}
			
			// 화면구조
			if (direction == DIRECTION_EXPORT) {
				expressionDataGrid.height = 50;
				labelColumn.visible = false;
				operatorColumn.visible = false;
				mappingTypeColumn.itemEditor = new ClassFactory(OutMappingTypeComboBox);
				
				this.titleIcon = FormEditorAssets.exportIcon;
				this.title = resourceManager.getString("FormEditorETC", "dataExportText");
				this.width = 600;
				
				_linkConditionDG.height=21+23*5+2;
				_linkConditionDG.visible=true;
				radioButtonGroupBox.visible=true;
				radioButtonGroupBox.height=23*2+2;
				eachTimeBox.visible = false;
				eachTimeBox.enabled = false;
				eachTimeBox.height = 0;

				this.fieldOptions = toFieldOptions(field.root);
				if(this.conds==null){
				 	this.conds = field.mappings.outConds.conds;
				 	if(this.conds==null) this.conds = new ArrayCollection();
					// and/or
					condsOperatorRadioGroup.selectedValue = field.mappings.outConds.operator;
					this._linkConditionDG.dataProvider = this.conds;
				}
					
				// conditions
				var conds:ArrayCollection = this.conds;
				if (!SmartUtil.isEmpty(conds)) {
					for each (var cond:Cond in conds) {
						if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION)
							cond.secondOperandName = cond.secondExpr;
					}
					this.conds = conds;
				}
				refreshCondsView();
			}
		}
		
		private function refreshCondsView():void {
			if (SmartUtil.isEmpty(conds))
				return;
			
			for each (var cond:Cond in conds) {
				cond.firstOperandName = toOperandName(cond.firstOperand, cond.firstOperandType, cond.firstOperandName);
				cond.operatorName = operatorNameByValue(cond.operator);
				cond.secondOperandTypeName = operandTypeNameIndexByValue(cond.secondOperandType);
				cond.secondOperandName = toOperandName(cond.secondOperand, cond.secondOperandType, cond.secondOperandName);
			}
		}

		private function toOperandName(id:String, type:String, name:String):String {
			if (SmartUtil.isEmpty(type) || type == Cond.OPERANDTYPE_EXPRESSION)
				return name;
			if (SmartUtil.isEmpty(id))
				return null;
			var options:ArrayCollection = null;
			if (type == Cond.OPERANDTYPE_SELF) {
				options = fieldOptions;
			}
			if (SmartUtil.isEmpty(options))
				return null;
			
			for each (var field:FormEntity in options) {
				if (field.id != id)
					continue;
				return field.name;
			}
				
			return null;
		}
				
		private function getIcon(item:Object):Class {
			var type:String = item.@mappingType;
			if (type == ExpressionNode.MAPPINGTYPE_SELFFORM) {
				return FormEditorAssets.formIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
				return FormEditorAssets.formLinkIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_PROCESSFORM) {
				return FormEditorAssets.processIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_SYSTEM) {
				return FormEditorAssets.systemIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
				return FormEditorAssets.serviceLinkIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
				return FormEditorAssets.expressionIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_BRACKET) {
				return FormEditorAssets.bracketIcon;
			}
			return null;
		}

		private function tableRecordCheckBoxClick(event:MouseEvent):void {
			if(tableRecordCheckBox.selected == true){
				tableFormLinkHBox.visible = true;
				fieldMappingLabel.height = 22;
				fieldMappingDataGrid.height = 200;
				expressionLabel.height = 0;
				expressionDataGrid.height = 0;
			}else{
				tableFormLinkHBox.visible = false;
				fieldMappingLabel.height = 0;
				fieldMappingDataGrid.height = 0;
				expressionLabel.height = 22;
				expressionDataGrid.height = 200;
				mapping.fieldMappings=null;
				refreshFieldMappings();
			}
			rename();
		}
			
		private function tableFormLinkChanged(event:Event):void {
			fieldMappings = null;
			subFieldsRefreshed = false;
			refreshFieldMappings();
		}
			
		private var addMenu:Menu;
		private function expressionClick(event:MouseEvent):void {
			if (direction == DIRECTION_EXPORT)
				return;
			
			var target:Object = event.target;
			if (target is AdvancedListBaseContentHolder) {
				if (addMenu == null) {
					var addMdp:Array = new Array();
					addMdp.push({label: resourceManager.getString("WorkbenchETC", "addText"), click: addItem});
					addMenu = Menu.createMenu(this, addMdp, false);
				}
				var point:Point = this.localToGlobal(new Point(mouseX, mouseY));
				SmartUtil.showMenu(addMenu, point.x, point.y);
			}
		}
		private function expressionItemClick(event:ListEvent):void {
			if (direction == DIRECTION_EXPORT)
				return;
			
			if (event.columnIndex == 0) {
				var itemMdp:Array = [
					{label: resourceManager.getString("WorkbenchETC", "addText"), click: addItem}, 
					{label: resourceManager.getString("FormEditorETC", "addBelowText"), click: addItem, item: expressionDataGrid.selectedItem}, 
					{label: resourceManager.getString("WorkbenchETC", "deleteText"), click: removeItem, item: expressionDataGrid.selectedItem}
				];
				var itemMenu:Menu = Menu.createMenu(this, itemMdp, false);
				var point:Point = this.localToGlobal(new Point(mouseX, mouseY));
				SmartUtil.showMenu(itemMenu, point.x, point.y);
			}
		}
		
		private function addItem(event:MenuEvent):void {
			var item:Object = event.item["item"];
			var node:ExpressionNode = new ExpressionNode();
			node.operator = "+";
			node.operatorName = ExpressionNode.toOperatorName(node.operator);
			node.mappingType = ExpressionNode.MAPPINGTYPE_SELFFORM;
			node.mappingTypeName = ExpressionNode.toMappingTypeName(node.mappingType);
			node.formLinkName = node.mappingTypeName;
			node.valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
			node.valueFunctionName = ExpressionNode.toValueFunctionName(node.valueFunction);
			var nodeXML:XML = node.toXML();
			nodeXML.@label = ExpressionNode.toLabel(nodeXML);
			if (item == null) {
				expressionTree.addItem(nodeXML);
				expressionDataGrid.selectedIndex = expressionTree.getItemIndex(nodeXML);
			} else {
				XML(item).appendChild(nodeXML);
				expressionDataGrid.expandItem(item, true);
				expressionDataGrid.selectedIndex = expressionTree.getItemIndex(nodeXML);
			}
			rename();
		}
		private function removeItem(event:MenuEvent):void {
			var item:Object = event.item["item"];
			var i:int = expressionTree.getItemIndex(item);
			if (i != -1) {
				expressionTree.removeItemAt(i);
				if (i > 0)
					expressionDataGrid.selectedIndex = i - 1;
			} else {
				var parent:XMLListCollection = new XMLListCollection(XML(item).parent().children());
				parent.removeItemAt(parent.getItemIndex(item));
				// TODO 선택
//				expressionDataGrid.selectedItem = parent;
			}
			rename();
		}
			
		private var prcForms:Array = null;
		private static var systemFunctionTypes:Array = null;
		private static var systemFunctions:Array = null;
		private static var valueFunction:Array = null;
		private static var valueFunctions:Array = null;
		private function expressionEditBegin(event:AdvancedDataGridEvent):void {
			event.preventDefault();
			
			var data:XML = XML(event.itemRenderer.data);
			var mappingType:String = data.@mappingType;
			var formLinkId:String = data.@formLinkId;
			var serviceLinkId:String = data.@serviceLinkId;
			var i:int;
			
			if (event.columnIndex == 3) {
				if (mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					formLinkColumn.itemEditor = new ClassFactory(com.maninsoft.smart.formeditor.view.dialog.util.FormLinkComboBox);
				}else if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
					formLinkColumn.itemEditor = new ClassFactory(com.maninsoft.smart.formeditor.view.dialog.util.ServiceLinkComboBox);
				}else {
					formLinkColumn.itemEditor = new ClassFactory(com.maninsoft.smart.common.controls.SimpleComboBox);
				}
			} else if (event.columnIndex == 4) {
				// 직접입력 유형인 경우 텍스트입력 유형의 컨트롤로 에디터 전환
				if (mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
					fieldColumn.itemEditor = new ClassFactory(mx.controls.TextInput);
				} else {
					fieldColumn.itemEditor = new ClassFactory(com.maninsoft.smart.common.controls.SimpleComboBox);
				}
			}
				
			expressionDataGrid.createItemEditor(event.columnIndex, event.rowIndex);
				
			if (event.columnIndex == 1) {
				(expressionDataGrid.itemEditorInstance as SimpleComboBox).selectItem(data.@operator);
			} else if (event.columnIndex == 2) {
				(expressionDataGrid.itemEditorInstance as SimpleComboBox).selectItem(mappingType);
			} else if (event.columnIndex == 3) {
				if (mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					// 다른업무연결 콤보박스
					var formLinkComboBox:FormLinkComboBox = expressionDataGrid.itemEditorInstance as FormLinkComboBox;
					formLinkComboBox.form = field.root;
					formLinkComboBox.selectItem(formLinkId);
					formLinkComboBox.callback = setFormLink;
						
				}else if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
					// 외부서비스연결 콤보박스
					var serviceLinkComboBox:ServiceLinkComboBox = expressionDataGrid.itemEditorInstance as ServiceLinkComboBox;
					serviceLinkComboBox.form = field.root;
					serviceLinkComboBox.selectItem(serviceLinkId);
					serviceLinkComboBox.callback = setServiceLink;
						
				} else {
					var _formLinkComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
					if (mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM) {
						if (prcForms != null) {
							_formLinkComboBox.dataProvider = prcForms;
						} else {
							prcForms = new Array();
							prcForms = [{label:"", value:null}];
							prcForms.push({label:"("+resourceManager.getString("FormEditorETC", "processParametersText")+")", value:ExpressionNode.MAPPINGTARGET_PROCESSPARAM});								
							if(this.direction != MappingDialog.DIRECTION_EXPORT){
								FormEditorService.getProcessFormRefsByFormId(field.root.id, function(formRefs:ArrayCollection, totalSize:int):void {
									if (!SmartUtil.isEmpty(formRefs)) {
										for each (var formRef:FormRef in formRefs)
											prcForms.push({label: formRef.name, value: formRef.id});
									}
									var subProcesses:Array = getSubProcesses();
									for each(var activity:Object in subProcesses)
										prcForms.push(activity);
									
									var taskServices:Array = getTaskServices();
									for each(activity in taskServices)
										prcForms.push(activity);									

									var applicationServices:Array = getApplicationServices();
									for each(activity in applicationServices)
										prcForms.push(activity);									
								});
							}
							_formLinkComboBox.dataProvider = prcForms;
						}
					} else if(mappingType == ExpressionNode.MAPPINGTYPE_SYSTEM){
						systemFunctionTypes = new Array();
						systemFunctionTypes = [{label:"", value:null}];
						for (i=0; i<ExpressionNode.SYSTEMFUNCTIONTYPES.length; i++)
								systemFunctionTypes.push({label: ExpressionNode.SYSTEMFUNCTIONTYPENAMES[i], value: ExpressionNode.SYSTEMFUNCTIONTYPES[i]});
						_formLinkComboBox.dataProvider = systemFunctionTypes;
						_formLinkComboBox.selectedIndex = 0;
						
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_SELFFORM || 
						mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
						_formLinkComboBox.dataProvider = [
							{label: data.@mappingTypeName, value: null}
						];
						_formLinkComboBox.selectedIndex = 0;
						
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
						_formLinkComboBox.dataProvider = null;
						
					}
					_formLinkComboBox.selectItem(formLinkId);
				}
			} else if (event.columnIndex == 4) {
				if (mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
					var fieldTextInput:TextInput = expressionDataGrid.itemEditorInstance as TextInput;
					fieldTextInput.text = data.@fieldName;
				} else {
					var fieldComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
					if (mappingType == ExpressionNode.MAPPINGTYPE_SELFFORM) {
						fieldComboBox.dataProvider = getSelfFields();
						
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
						if (SmartUtil.isEmpty(formLinkId) || field.root.formLinks == null || SmartUtil.isEmpty(field.root.formLinks.formLinks)) {
							fieldComboBox.dataProvider = null;
							return;
						}
						
						var otherFormId:String = null;
						for each (var _formLink:FormLink in field.root.formLinks.formLinks) {
							if (_formLink.id != formLinkId)
								continue;
							otherFormId = _formLink.targetFormId;
							break;
						}
							
						if (SmartUtil.isEmpty(otherFormId)) {
							fieldComboBox.dataProvider = null;
							return;
						}
						
						// 다른업무항목 콤보박스
						if (!populateFieldComboBox(fieldComboBox, otherFormId, data.@fieldId))
							return;
						
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
						if (SmartUtil.isEmpty(serviceLinkId) || field.root.serviceLinks == null || SmartUtil.isEmpty(field.root.serviceLinks.serviceLinks)) {
							fieldComboBox.dataProvider = null;
							return;
						}
						
						var serviceId:String = null;
						for each (var _serviceLink:ServiceLink in field.root.serviceLinks.serviceLinks) {
							if (_serviceLink.id != serviceLinkId)
								continue;
							serviceId = _serviceLink.targetServiceId;
							break;
						}
							
						if (SmartUtil.isEmpty(serviceId)) {
							fieldComboBox.dataProvider = null;
							return;
						}
						
						// 다른업무항목 콤보박스
						if (!populateServiceFieldComboBox(fieldComboBox, serviceId, data.@fieldId))
							return;
						
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM) {
						// 프로세스업무항목 콤보박스
						var prcFormId:String = formLinkId;
						if (SmartUtil.isEmpty(prcFormId)) {
							fieldComboBox.dataProvider = null;
							return;
						} else if (prcFormId == field.root.id) {
							fieldComboBox.dataProvider = getSelfFields();
						} else if (prcFormId == ExpressionNode.MAPPINGTARGET_PROCESSPARAM) {
							fieldComboBox.dataProvider = getProcessParams();
						} else if (prcFormId == ExpressionNode.MAPPINGTARGET_SUBPARAMETER) {
							fieldComboBox.dataProvider = getProcessParams(data.@activityId);
						} else if (prcFormId == ExpressionNode.MAPPINGTARGET_SERVICEPARAM) {
							fieldComboBox.dataProvider = getServiceParams(data.@activityId);
						} else {
							if (!populateFieldComboBox(fieldComboBox, prcFormId, data.@fieldId))
								return;
						}
							
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEM) {
						var functionTypeId:String = formLinkId;
						if (SmartUtil.isEmpty(functionTypeId)) {
							fieldComboBox.dataProvider = null;
							return;
						}
						systemFunctions = new Array();
						systemFunctions.push({label: "", value: null});
						if (functionTypeId == ExpressionNode.SYSTEMFUNCTIONTYPE_CURRENTUSER) {
							for (i=0; i<ExpressionNode.SYSTEMFUNCTIONS_CURRENTUSER.length; i++)
								systemFunctions.push({label: ExpressionNode.SYSTEMFUNCTIONNAMES_CURRENTUSER[i], value: ExpressionNode.SYSTEMFUNCTIONS_CURRENTUSER[i]});
						}else if (functionTypeId == ExpressionNode.SYSTEMFUNCTIONTYPE_CURRENTTIME) {
							for (i=0; i<ExpressionNode.SYSTEMFUNCTIONS_CURRENTTIME.length; i++)
								systemFunctions.push({label: ExpressionNode.SYSTEMFUNCTIONNAMES_CURRENTTIME[i], value: ExpressionNode.SYSTEMFUNCTIONS_CURRENTTIME[i]});
						}else if (functionTypeId == ExpressionNode.SYSTEMFUNCTIONTYPE_CURRENTPROCESS) {
							for (i=0; i<ExpressionNode.SYSTEMFUNCTIONS_CURRENTPROCESS.length; i++)
								systemFunctions.push({label: ExpressionNode.SYSTEMFUNCTIONNAMES_CURRENTPROCESS[i], value: ExpressionNode.SYSTEMFUNCTIONS_CURRENTPROCESS[i]});
						}else if (functionTypeId == ExpressionNode.SYSTEMFUNCTIONTYPE_MAILMESSAGE) {
							for (i=0; i<ExpressionNode.SYSTEMFUNCTIONS_MAILMESSAGE.length; i++)
								systemFunctions.push({label: ExpressionNode.SYSTEMFUNCTIONNAMES_MAILMESSAGE[i], value: ExpressionNode.SYSTEMFUNCTIONS_MAILMESSAGE[i]});
						}if (functionTypeId == ExpressionNode.SYSTEMFUNCTIONTYPE_MISC) {
							for (i=0; i<ExpressionNode.SYSTEMFUNCTIONS_MISC.length; i++)
								systemFunctions.push({label: ExpressionNode.SYSTEMFUNCTIONNAMES_MISC[i], value: ExpressionNode.SYSTEMFUNCTIONS_MISC[i]});
						}
						
						fieldComboBox.dataProvider = systemFunctions;
					} else if (mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
						fieldComboBox.dataProvider = null;
						return;
					}
					fieldComboBox.selectItem(data.@fieldId);
				}
			} else if (event.columnIndex == 5) {
				var valueFunctionComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				if (mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					valueFunctions = [
						{label: "", value: null}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE), value: ExpressionNode.VALUEFUNCTION_VALUE}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_SUM), value: ExpressionNode.VALUEFUNCTION_SUM}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_AVERAGE), value: ExpressionNode.VALUEFUNCTION_AVERAGE}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_MIN), value: ExpressionNode.VALUEFUNCTION_MIN}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_MAX), value: ExpressionNode.VALUEFUNCTION_MAX}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_COUNT), value: ExpressionNode.VALUEFUNCTION_COUNT}
					];
					valueFunctionComboBox.dataProvider = valueFunctions;
				}else if(mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE
						&&	((fieldType == FormatTypes.comboBox.type) || (fieldType == FormatTypes.checkBox.type) 
								|| (fieldType == FormatTypes.checkBox.type) 
								|| (fieldType == FormatTypes.radioButton.type)) ){
					valueFunctions = [
						{label: "", value: null}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE), value: ExpressionNode.VALUEFUNCTION_VALUE}, 
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_LIST), value: ExpressionNode.VALUEFUNCTION_LIST}
					];
					valueFunctionComboBox.dataProvider = valueFunctions;
				} else {
					if (valueFunction == null) {
						valueFunction = [
							{label: "", value: null},
							{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE), value: ExpressionNode.VALUEFUNCTION_VALUE}
						];
					}
					valueFunctionComboBox.dataProvider = valueFunction;
				}
				valueFunctionComboBox.selectItem(data.@valueFunction);
			}
		}

		private var fieldsMap:Map = new Map();
		private function populateFieldComboBox(comboBox:SimpleComboBox, formId:String, selectedFieldId:String):Boolean {
			if (fieldsMap.containsKey(formId)) {
				comboBox.dataProvider = fieldsMap.getValue(formId) as Array;
				return true;
			}
			
			FormEditorService.getFieldsByFormId(formId, function(fields:ArrayCollection):void {
				var fieldDp:Array = toFieldDpArray(fields);
				fieldsMap.put(formId, fieldDp);
				comboBox.dataProvider = fieldDp;
				comboBox.selectItem(selectedFieldId);
			});
			return false;
		}
		
		private function populateServiceFieldComboBox(comboBox:SimpleComboBox, serviceId:String, selectedFieldId:String):Boolean {
			if (fieldsMap.containsKey(serviceId)) {
				comboBox.dataProvider = fieldsMap.getValue(serviceId) as Array;
				return true;
			}
			
			FormEditorService.getSystemServiceRef(serviceId, function(serviceRef:SystemService):void {
				if(!serviceRef) return;
				var fieldDp:Array;
				if(direction == MappingDialog.DIRECTION_EXPORT)
					fieldDp = serviceRef.messageIn;
				else
					fieldDp = serviceRef.messageOut;
				fieldsMap.put(serviceId, fieldDp);
				comboBox.dataProvider = fieldDp;
				comboBox.selectItem(selectedFieldId);
			});
			return false;
		}
		
		private var selfFields:Array = null;
		private function getSelfFields():Array {
			if (selfFields == null)
				selfFields = toFieldDpArray(field.root.children);
			return selfFields;
		}
		private static function toFieldDpArray(fields:ArrayCollection):Array {
			var array:Array = [{label: "", value: null}];
			if (!SmartUtil.isEmpty(fields)) {
				for each (var field:FormEntity in fields)
					array.push({icon: FormatTypes.getIcon(field.format.type), label: field.name, value: field.id});
			}
			return array;
		}

		private var processParams:Array = null;
		private function getProcessParams(activityId:String=null):Array {
			if (processParams == null)
				if(this.direction == MappingDialog.DIRECTION_EXPORT) 
					processParams = toProcessInParams(formEditorBase.getProcessFormalParameters(activityId));
				else
					processParams = toProcessOutParams(formEditorBase.getProcessFormalParameters(activityId));
			return processParams;
		}
		private static function toProcessInParams(params:Array):Array {
			var array:Array = [{label: "", value: null}];
			if (!SmartUtil.isEmpty(params)) {
				for(var i:int=0; i<params.length; i++)
					if(params[i].mode != "OUT")
						array.push({icon: FormatTypes.getIcon(params[i].formatType.type), label: params[i].label, value: params[i].id});
			}
			return array;
		}
		private static function toProcessOutParams(params:Array):Array {
			var array:Array = [{label: "", value: null}];
			if (!SmartUtil.isEmpty(params)) {
				for(var i:int=0; i<params.length; i++)
					if(params[i].mode != "IN")
						array.push({icon: FormatTypes.getIcon(params[i].formatType.type), label: params[i].label, value: params[i].id});
			}
			return array;
		}

		private var serviceParams:Array = null;
		private function getServiceParams(activityId:String=null):Array {
			if (serviceParams == null)
				if(this.direction != MappingDialog.DIRECTION_EXPORT){
					if(formEditorBase.isApplicationService(activityId)) 
						serviceParams = toServiceOutParams(formEditorBase.getApplicationServiceReturnParams(activityId));
					else
						serviceParams = toServiceOutParams(formEditorBase.getSystemServiceMessageOut(activityId));
				}
			return serviceParams;
		}
		private static function toServiceOutParams(params:Array):Array {
			var array:Array = [{label: "", value: null}];
			if (!SmartUtil.isEmpty(params)) {
				for(var i:int=0; i<params.length; i++)
						array.push({icon: FormatTypes.getIcon(FormatTypes.textInput.type), label: params[i].label, value: params[i].id});
			}
			return array;
		}

		private var subProcesses:Array = null;
		private function getSubProcesses():Array {
			if (subProcesses == null)
				subProcesses = toSubProcesses(formEditorBase.getProcessSubProcesses(), resourceManager.getString("FormEditorETC", "formalParametersText"));
			return subProcesses;
		}
		private static function toSubProcesses(activities:Array, text:String):Array {
			var array:Array = [];
			if (!SmartUtil.isEmpty(activities)) {
				for(var i:int=0; i<activities.length; i++)
						array.push({label: activities[i].name + " (" + text + ")", value:ExpressionNode.MAPPINGTARGET_SUBPARAMETER, activityId: activities[i].id.toString()});
			}
			return array;
		}

		private var taskServices:Array = null;
		private function getTaskServices():Array {
			if (taskServices == null)
				taskServices = toTaskServices(formEditorBase.getProcessTaskServices(), resourceManager.getString("FormEditorETC", "formalParametersText"));
			return taskServices;
		}
		private static function toTaskServices(activities:Array, text:String):Array {
			var array:Array = [];
			if (!SmartUtil.isEmpty(activities)) {
				for(var i:int=0; i<activities.length; i++)
						array.push({label: activities[i].name + " (" + text + ")", value:ExpressionNode.MAPPINGTARGET_SERVICEPARAM, activityId: activities[i].id.toString()});
			}
			return array;
		}

		private var applicationServices:Array = null;
		private function getApplicationServices():Array {
			if (applicationServices == null)
				applicationServices = toApplicationServices(formEditorBase.getProcessApplicationServices(), resourceManager.getString("ProcessEditorETC", "returnText"));
			return applicationServices;
		}
		private static function toApplicationServices(activities:Array, text:String):Array {
			var array:Array = [];
			if (!SmartUtil.isEmpty(activities)) {
				for(var i:int=0; i<activities.length; i++)
						array.push({label: activities[i].name + " (" + text + ")", value:ExpressionNode.MAPPINGTARGET_SERVICEPARAM, activityId: activities[i].id.toString()});
			}
			return array;
		}

		private function expressionEditEnd(event:AdvancedDataGridEvent):void {
			var data:XML = XML(event.itemRenderer.data);
			
			if (event.columnIndex == 1) {
				var operatorComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				var operator:Object = null;
				if (operatorComboBox != null)
					operator = operatorComboBox.selectedItem;
				if (operator == null) {
					data.@operator = null;
					data.@operatorName = null;
					return;
				}
				data.@operator = operator["value"];
				data.@operatorName = operator["label"];
			} else if (event.columnIndex == 2) {
				var mappingTypeComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				var mappingTypeItem:Object = null;
				if (mappingTypeComboBox != null)
					mappingTypeItem = mappingTypeComboBox.selectedItem;
				if (mappingTypeItem == null) {
					data.@mappingType = null;
					data.@mappingTypeName = "";
				} else if (data.@mappingType == mappingTypeItem["value"]) {
					return;
				} else {
					data.@mappingType = mappingTypeItem["value"];
					data.@mappingTypeName = mappingTypeItem["label"];
				}
				data.@formLinkId = null;
				data.@serviceLinkId = null;
				if (data.@mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM || 
					data.@mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE || 
					data.@mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM || 
					data.@mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
					data.@formLinkName = "";
				} else {
					data.@formLinkName = data.@mappingTypeName;
				}
				data.@fieldId = null;
				data.@fieldName = "";
				if (data.@mappingType != ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					data.@valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
					data.@valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
				}
			} else if (event.columnIndex == 3) {
				var formLink:Object = null;
				var serviceLink:Object = null;
				if (data.@mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					var formLinkComboBox:FormLinkComboBox = expressionDataGrid.itemEditorInstance as FormLinkComboBox;
					if (formLinkComboBox != null)
						formLink = formLinkComboBox.selectedItem;
				}else if (data.@mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE) {
					var serviceLinkComboBox:ServiceLinkComboBox = expressionDataGrid.itemEditorInstance as ServiceLinkComboBox;
					if (serviceLinkComboBox != null)
						serviceLink = serviceLinkComboBox.selectedItem;
				} else {
					var _formLinkComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
					if (_formLinkComboBox != null)
						formLink = _formLinkComboBox.selectedItem;
					if(_formLinkComboBox.selectedItem.activityId)
						data.@activityId = _formLinkComboBox.selectedItem.activityId;
					else
						data.@activityId = null;
				}
				var feEvent:FormEditorEvent = new FormEditorEvent(FormEditorEvent.OK);
				if(serviceLink){
					feEvent.model = serviceLink;
					setServiceLink(feEvent);
				}else{
					feEvent.model = formLink;
					setFormLink(feEvent);					
				}
			} else if (event.columnIndex == 4) {
				if (data.@mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
					var expression:String = (expressionDataGrid.itemEditorInstance as TextInput).text;
					data.@fieldName = expression;
				} else {
					var fieldComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
					var field:Object = null;
					if (fieldComboBox != null)
						field = fieldComboBox.selectedItem;
					if (field == null) {
						data.@fieldId = null;
						data.@fieldName = "";
					} else if (data.@fieldId == field["value"] && data.@fieldName == field["label"]) {
						return;
					} else {
						data.@fieldId = field["value"];
						data.@fieldName = field["label"];
					}
				}
				if (data.@mappingType != ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					data.@valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
					data.@valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
				}
			} else if (event.columnIndex == 5) {
				var valueFunctionComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				var valueFunction:Object = null;
				if (valueFunctionComboBox != null)
					valueFunction = valueFunctionComboBox.selectedItem;
				if (valueFunction == null) {
					data.@valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
					data.@valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
				} else {
					data.@valueFunction = valueFunction["value"];
					data.@valueFunctionName = valueFunction["label"];
				}
			}
			
			data.@label = ExpressionNode.toLabel(data);
			rename();
		}
		
		private function setFormLink(event:FormEditorEvent):void {
			var data:XML = expressionDataGrid.selectedItem as XML;
			var formLink:Object = event.model;
			if (formLink == null) {
				data.@formLinkId = null;
				data.@formLinkName = "";
			} else {
				var label:String = null;
				var value:String = "";
				if (formLink is FormLink) {
					label = formLink["name"];
					value = formLink["id"];
				} else {
						label = formLink["label"];
						value = formLink["value"];
				}
				if (data.@formLinkId == value) {
					return;
				} else {
					data.@formLinkId = value;
					data.@formLinkName = label;
				}
				data.@serviceLinkId = null;
				data.@serviceLinkName = "";
			}
			if (data.@mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM || 
				data.@mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM || 
				data.@mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
				data.@fieldId = null;
				data.@fieldName = "";
				if (data.@mappingType != ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					data.@valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
					data.@valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
				}
			}
		}
		
		private function setServiceLink(event:FormEditorEvent):void {
			var data:XML = expressionDataGrid.selectedItem as XML;
			var serviceLink:Object = event.model;
			if (serviceLink == null) {
				data.@serviceLinkId = null;
				data.@serviceLinkName = "";
			} else {
				var label:String = null;
				var value:String = "";
				if (serviceLink is ServiceLink) {
					label = serviceLink["name"];
					value = serviceLink["id"];
				} else {
					label = serviceLink["label"];
					value = serviceLink["value"];
				}
				if (data.@serviceLinkId == value) {
					return;
				} else {
					data.@serviceLinkId = value;
					data.@serviceLinkName = label;
				}
				data.@formLinkId = null;
				data.@formLinkName = "";
			}
			if (data.@mappingType == ExpressionNode.MAPPINGTYPE_OTHERFORM || 
				data.@mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE || 
				data.@mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM || 
				data.@mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
				data.@fieldId = null;
				data.@fieldName = "";
				if (data.@mappingType != ExpressionNode.MAPPINGTYPE_OTHERFORM) {
					data.@valueFunction = ExpressionNode.VALUEFUNCTION_VALUE;
					data.@valueFunctionName = ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE);
				}
			}
		}
		
		private function rename(event:Event=null):void {

			if(tableRecordCheckBox.selected){		
				nameInput.text = FieldMapping.toLabel(tableFormLinkComboBox.selectedItem["label"], fieldMappings);
			}else{
				if (SmartUtil.isEmpty(expressionTree)) {
					nameInput.text = resourceManager.getString("FormEditorETC", "emptyExpressionText");
					return;
				}
				
				nameInput.text = toExpression("label", expressionTree);
			}
			if (eachTimeBox.visible && eachTimeBox.height != 0)
				nameInput.text += (eachTimeRadioButtonGroup.selectedValue == true? resourceManager.getString("FormEditorETC", "everytimeBracketText") : resourceManager.getString("FormEditorETC", "onceBracketText"));
		}
		private static function toChildExpression(type:String, nodes:XMLList, parent:XML):String {
			if (SmartUtil.isEmpty(nodes))
				return "";
			var expr:String = "";
			if (parent.@mappingType != ExpressionNode.MAPPINGTYPE_BRACKET) {
				var operator:String = type == "function"? nodes[0].@operator : nodes[0].@operatorName;
				if (!SmartUtil.isEmpty(operator))
					expr += " " + operator;
				expr += " ";
			}
			expr += "(" + toExpression(type, nodes) + ")";
			return expr;
		}
		private static function toExpression(type:String, nodes:Object):String {
			if (SmartUtil.isEmpty(nodes))
				return "";
			var expr:String = "";
			var i:int = 0;
			for each (var node:XML in nodes) {
				if (type == "function") {
					var func:String = "";
					if (i++ != 0) {
						var operator:String = node.@operator;
						if (!SmartUtil.isEmpty(operator))
							expr += " " + operator;
					}
					expr += toFunction(node);
				} else {
					var label:String = node.@label;
					if (i++ == 0) {
						label = removeUnit(label);
					} else {
						label = " " + label;
					}
					expr += label;
				}
				expr += toChildExpression(type, node.child("node"), node);
			}
			return expr;
		}
		private static function removeUnit(label:String):String {
			var hasUnit:Boolean = false;
			for each (var unit:String in ExpressionNode.OPERATORNAMES) {
				if (label.indexOf(unit) == 0) {
					hasUnit = true;
					break
				}
			}
			if (hasUnit)
				label = label.substring(2);
			return label;
		}
		private static function toFunction(node:XML):String {
			var mappingType:String = node.@mappingType;
			
			if (mappingType == ExpressionNode.MAPPINGTYPE_BRACKET)
				return "";
			if (mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION)
				return " " + node.@fieldName;
			if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEM)
				return " " + node.@fieldId + "()";
			
			var formLinkId:String = node.@formLinkId;
			var serviceLinkId:String = node.@serviceLinkId;
			var fieldId:String = node.@fieldId;
			var valueFunction:String = node.@valueFunction;
			if (mappingType == ExpressionNode.MAPPINGTYPE_SELFFORM)
				formLinkId = "this";
			else if (mappingType == ExpressionNode.MAPPINGTYPE_SYSTEMSERVICE)
				formLinkId = serviceLinkId;

			return " mis:getData('" + mappingType + "', '" + formLinkId + "', '" + fieldId + "', '" + valueFunction + "')";			
		}
		
		override protected function ok(event:Event = null):void {
			mapping.name = nameInput.text;
			mapping.eachTime = eachTimeRadioButtonGroup.selectedValue as Boolean;
			if(tableRecordCheckBox.selected){
					mapping.type = Mapping.TYPE_TABLE_RECORDS;
					mapping.mappingType = null;
					mapping.formLinkId = tableFormLinkComboBox.selectedItem["value"];
					mapping.formLinkName = tableFormLinkComboBox.selectedItem["label"];
					mapping.serviceLinkId = null;
					mapping.serviceLinkName = null;
					mapping.activityId = null;
					mapping.fieldId = null;
					mapping.fieldName = null;
					mapping.valueFunction = null;
					mapping.expression = null;
					mapping.expressionTree = null;
					mapping.fieldMappings = fieldMappings;				
			}else if (!SmartUtil.isEmpty(expressionTree)) {
				if (expressionTree.length == 1) {
					var node:XML = expressionTree[0];
					mapping.type = Mapping.TYPE_SIMPLE;
					mapping.mappingType = node.@mappingType;
					mapping.formLinkId = node.@formLinkId;
					mapping.formLinkName = node.@formLinkName;
					mapping.serviceLinkId = node.@serviceLinkId;
					mapping.serviceLinkName = node.@serviceLinkName;
					mapping.activityId = node.@activityId;
					mapping.fieldId = node.@fieldId;
					mapping.fieldName = node.@fieldName;
					mapping.valueFunction = node.@valueFunction;
					mapping.expression = null;
					mapping.expressionTree = null;
					mapping.fieldMappings = null;
				} else {
					mapping.type = Mapping.TYPE_EXPRESSION;
					mapping.mappingType = null;
					mapping.formLinkId = null;
					mapping.formLinkName = null;
					mapping.serviceLinkId = null;
					mapping.serviceLinkName = null;
					mapping.activityId = null;
					mapping.fieldId = null;
					mapping.fieldName = null;
					mapping.valueFunction = null;
					mapping.expression = toExpression("function", expressionTree);
					mapping.expressionTree = <expressionTree/>;
					for each (var _node:XML in expressionTree)
						mapping.expressionTree.appendChild(_node);
					mapping.fieldMappings = null;
				}
			} else {
				mapping.type = Mapping.TYPE_EXPRESSION;
				mapping.mappingType = null;
				mapping.formLinkId = null;
				mapping.formLinkName = null;
				mapping.serviceLinkId = null;
				mapping.serviceLinkName = null;
				mapping.activityId = null;
				mapping.fieldId = null;
				mapping.fieldName = null;
				mapping.valueFunction = null;
				mapping.expression = expressionTextArea.text;
				mapping.expressionTree = null;
					mapping.fieldMappings = null;
			}
			
			var fe:FormEditorEvent = new FormEditorEvent(FormEditorEvent.OK);
			fe.model = mapping;
			dispatchEvent(fe);

			if(this.conds != null && direction == DIRECTION_EXPORT){
	
				// 1. 값 보정
				for each (var cond:Cond in this.conds) {
					if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION) {
						cond.secondExpr = cond.secondOperandName;
						cond.secondOperandName = null;
					} else {
						cond.secondExpr = null;
					}
				}
				
				field.mappings.outConds.conds = this.conds	
				field.mappings.outConds.operator = this.condsOperatorRadioGroup.selectedValue as String;
				fe.model = field.mappings.outConds;
				dispatchEvent(fe);
			}			

			close();
		}
		
		private function fieldMappingEditBegin(event:DataGridEvent):void {
			event.preventDefault();
			
			var fieldMapping:FieldMapping = event.itemRenderer.data as FieldMapping;
			
			var data:Object = tableFormLinkComboBox.selectedItem;
			var formLinkId:String = (data == null) ? null : data["value"];
			var serviceLinkId:String = null;
			fieldMappingDataGrid.createItemEditor(event.columnIndex, event.rowIndex);
			
			if (event.columnIndex == 1) {
			var fieldComboBox:SimpleComboBox = fieldMappingDataGrid.itemEditorInstance as SimpleComboBox;
				
				if(!SmartUtil.isEmpty(formLinkId)){
					if (field.root.formLinks == null || SmartUtil.isEmpty(field.root.formLinks.formLinks)) {
						fieldComboBox.dataProvider = null;
						return;
					}
				
					var otherFormId:String = null;
					for each (var _formLink:FormLink in field.root.formLinks.formLinks) {
						if (_formLink.id != formLinkId)
							continue;
						otherFormId = _formLink.targetFormId;
						break;
					}
				
					if (SmartUtil.isEmpty(otherFormId)) {
						fieldComboBox.dataProvider = null;
						return;
					}

					// 다른업무항목 콤보박스
					if (!populateFieldComboBox(fieldComboBox, otherFormId, fieldMapping.rightOperand))
						return;
					
				}else if(!SmartUtil.isEmpty(serviceLinkId)){
					if (field.root.serviceLinks == null || SmartUtil.isEmpty(field.root.serviceLinks.serviceLinks)) {
						fieldComboBox.dataProvider = null;
						return;
					}
				
					var otherServiceId:String = null;
					for each (var _serviceLink:ServiceLink in field.root.serviceLinks.serviceLinks) {
						if (_serviceLink.id != serviceLinkId)
							continue;
						otherServiceId = _serviceLink.targetServiceId;
						break;
					}
				
					if (SmartUtil.isEmpty(otherServiceId)) {
						fieldComboBox.dataProvider = null;
						return;
					}

					// 다른업무항목 콤보박스
					if (!populateServiceFieldComboBox(fieldComboBox, otherServiceId, fieldMapping.rightOperand))
						return;
					
				}else{
					fieldComboBox.dataProvider = null;
					return;					
				}
				fieldComboBox.selectItem(fieldMapping.rightOperand);
			}
		}
		private function fieldMappingEditEnd(event:DataGridEvent):void {
			var fieldMapping:FieldMapping = event.itemRenderer.data as FieldMapping;
			
			if (event.columnIndex == 1) {
				var fieldComboBox:SimpleComboBox = fieldMappingDataGrid.itemEditorInstance as SimpleComboBox;
				var field:Object = null;
				if (fieldComboBox != null)
					field = fieldComboBox.selectedItem;
				if (field == null) {
					fieldMapping.rightOperand = null;
					fieldMapping.rightOperandName = "";
				} else if (fieldMapping.rightOperand == field["value"] && fieldMapping.rightOperandName == field["label"]) {
					return;
				} else {
					fieldMapping.rightOperand = field["value"];
					fieldMapping.rightOperandName = field["label"];
				}
			}
			rename();
		}
		private var subFields:ArrayCollection = null;
		private var subFieldsRefreshed:Boolean = false;
		private var fieldMappingMenu:Menu;
		private function fieldMappingClick(event:MouseEvent):void {
			if (subFieldsRefreshed)
				return;
				
			var target:Object = event.target;
			if (target is ListBaseContentHolder) {
				if (fieldMappingMenu == null) {
					var mdp:Array = new Array();
					mdp.push({label: resourceManager.getString("FormEditorETC", "refreshMappingsText"), click: refreshFieldMappings});
					fieldMappingMenu = Menu.createMenu(this, mdp, false);
				}
				var point:Point = this.localToGlobal(new Point(mouseX, mouseY));
				SmartUtil.showMenu(fieldMappingMenu, point.x, point.y);
			}
		}
		private function refreshFieldMappings(event:MenuEvent = null):void {
			if (subFieldsRefreshed)
				return;
			subFields = this.field.children;
			if (SmartUtil.isEmpty(subFields) && !SmartUtil.isEmpty(fieldMappings)) {
				fieldMappings.removeAll();
				return;
			}
			
			var map:Map = new Map();
			if (!SmartUtil.isEmpty(fieldMappings)) {
				for each (var fieldMapping:FieldMapping in fieldMappings)
					map.put(fieldMapping.leftOperand, fieldMapping);
				fieldMappings.removeAll();
			}
			for each (var field:FormEntity in subFields) {
				if (map.containsKey(field.id)) {
					var oldFieldMapping:FieldMapping = map.getValue(field.id) as FieldMapping;
					oldFieldMapping.leftOperandName = field.name;
					fieldMappings.addItem(oldFieldMapping);
					continue;
				}
				var newFieldMapping:FieldMapping = new FieldMapping();
				newFieldMapping.leftOperand = field.id;
				newFieldMapping.leftOperandName = field.name;
				fieldMappings.addItem(newFieldMapping);
			}
			
			subFieldsRefreshed = true;
		}
		
		protected static function toFieldOptions(form:FormDocument):ArrayCollection{
			if (form == null)
				return null;
			
			var fieldOptions:ArrayCollection = new ArrayCollection();
				
			for each(var field:FormEntity in form.children){
				if (field is FormItemProxy)
					continue;
				fieldOptions.addItem(field);
			}
				
			var idField:FormEntity = new FormEntity(form, "id");
			idField.name = ResourceManager.getInstance().getString("FormEditorETC", "idBracketText");
			idField.format = new FormFormatInfo();
			fieldOptions.addItem(idField);
			
			return fieldOptions;
		}
			
		private function addCond(): void {
			var cond:Cond = new Cond();
			cond.operatorName = operatorNameByValue(cond.operator);
			cond.secondOperandTypeName = this.operandTypeNameIndexByValue(cond.secondOperandType);
			conds.addItem(cond);
		}

		private function get lastItemTop():Number{
			return conds.length * _linkConditionDG.rowHeight;
		}
		private function get lastItemBottom():Number{
			return (conds.length+1) * _linkConditionDG.rowHeight;			
		}

		private function checkCond(event:MouseEvent):void {
			if (event.target is ListBaseContentHolder && event.localY >= lastItemTop && event.localY <= lastItemBottom) {
				addCond();
				_linkConditionDG.selectedIndex = conds.length - 1;
			}
		}

		private function doDeleteItemClick(editor: ButtonPropertyEditor): void {
			if(_linkConditionDG.selectedItem)
				conds.removeItemAt(_linkConditionDG.selectedIndex);
		}

		private function doOperandEditorClick(editor: ButtonPropertyEditor): void {
			var position: Point = editor.localToGlobal(new Point(0, editor.height+1));
			var formEntity:FormEntity = new FormEntity(this.field.root);
			if(columnIndex == 1){
				formEntity.format.refFormId = this.field.root.id;
				SelectRefFormFieldIdDialog.execute(formEntity, Cond(_linkConditionDG.selectedItem).firstOperand, setOperand, position, editor.width, 0, false, true);
			}else if(columnIndex == 4){
				formEntity.format.refFormId = this.field.root.id;
				SelectRefFormFieldIdDialog.execute(formEntity, Cond(_linkConditionDG.selectedItem).secondOperand, setOperand, position, editor.width, 0, false, true);
			}
		}

		private function setOperand(selectedItem:Object):void {
			if(!selectedItem) return;

			var cond: Cond = _linkConditionDG.selectedItem as Cond;
			if (columnIndex == 1) {
				cond.firstOperandType = Cond.OPERANDTYPE_SELF;
				cond.firstOperand = selectedItem.id;
				cond.firstOperandName = selectedItem.name;
			} else if (columnIndex == 4) {
				cond.secondOperandType = Cond.OPERANDTYPE_SELF;
				cond.secondOperand = selectedItem.id;
				cond.secondOperandName = selectedItem.name;
			}
			_linkConditionDG.invalidateList();
		}

		private function operatorIndexByLabel(label:String):int {
			if (SmartUtil.isEmpty(label))
				return -1;
			for(var i:int=0; i< Cond.OPERATORS.length; i++){
				if(label == Cond.OPERATORS[i].label)
					return i;
			}
			return -1;
		}
			
		private function operatorNameByValue(operator:String):String {
			if (SmartUtil.isEmpty(operator))
				return null;
			for(var i:int=0; i< Cond.OPERATORS.length; i++){
				if(operator == Cond.OPERATORS[i].value)
					return Cond.OPERATORS[i].label;
			}
			return null;
		}
			
		private function operandTypeIndexByValue(label:String):int {
			if (SmartUtil.isEmpty(label))
				return -1;
			for(var i:int=0; i< Cond.OPERAND_TYPES.length; i++){
				if(label == Cond.OPERAND_TYPES[i].value)
					return i;
			}
			return -1;
		}
			
		private function operandTypeNameIndexByValue(operatorType:String):String {
			if (SmartUtil.isEmpty(operatorType))
				return null;
			for(var i:int=0; i< Cond.OPERAND_TYPES.length; i++){
				if(operatorType == Cond.OPERAND_TYPES[i].value)
					return Cond.OPERAND_TYPES[i].label;
			}
			return null;
		}
			
		private var columnIndex:int = -1;
		private var rowIndex:int = -1;

		private function condEditBegin(event:DataGridEvent):void {
			event.preventDefault();
			var data:Object = event.itemRenderer.data;
				
			if (data.secondOperandType == Cond.OPERANDTYPE_SELF) {
				_rightOperandCol.itemEditor = new ClassFactory(ButtonPropertyEditor);
			} else {
				_rightOperandCol.itemEditor = new ClassFactory(KoreanTextInput);
			}
				
			_linkConditionDG.createItemEditor(event.columnIndex, event.rowIndex);
				
			columnIndex = event.columnIndex;
			rowIndex = event.rowIndex;
			var selectedItemTop:Number = event.itemRenderer.y-1;
			
			if (event.columnIndex == 0) {
				deleteItemEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
				deleteItemEditor.buttonIcon = DialogAssets.deleteItemButton;
				deleteItemEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "deleteItemTTip");
				deleteItemEditor.valueLabel.visible = false;
				deleteItemEditor.dialogButton.buttonMode = false;
				deleteItemEditor.setBounds(5, selectedItemTop, _deleteItemCol.width-13, _linkConditionDG.rowHeight-2);
				deleteItemEditor.setStyle("horizontalGap", "3");
				deleteItemEditor.clickHandler = doDeleteItemClick;
				deleteItemEditor.setEditable(false);
			}else if (event.columnIndex == 1) {
				leftOperandEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
				leftOperandEditor.data = data.firstOperandName;
				leftOperandEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
				leftOperandEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "formIdSelectTTip");
				leftOperandEditor.setBounds(_deleteItemCol.width+1, selectedItemTop, _leftOperandCol.width-2, _linkConditionDG.rowHeight-2);
				leftOperandEditor.setStyle("horizontalGap", "3");
				leftOperandEditor.clickHandler = doOperandEditorClick;
				leftOperandEditor.setEditable(false);
			} else if (event.columnIndex == 2) {
				operatorComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				operatorComboBox.setBounds(_deleteItemCol.width+_leftOperandCol.width+1, selectedItemTop, _operatorCol.width-2, _linkConditionDG.rowHeight-2);
				operatorComboBox.dataProvider = Cond.OPERATORS;
				operatorComboBox.selectedIndex = this.operatorIndexByLabel(data.operatorName);
			} else if (event.columnIndex == 3) {
				rightOperandTypeComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				rightOperandTypeComboBox.setBounds(_deleteItemCol.width+_leftOperandCol.width+_operatorCol.width+1, selectedItemTop, _rightOperandTypeCol.width-2, _linkConditionDG.rowHeight-2);
				rightOperandTypeComboBox.dataProvider = Cond.OPERAND_TYPES;
				rightOperandTypeComboBox.selectedIndex = this.operandTypeIndexByValue(data.secondOperandType);
			} else if (event.columnIndex == 4) {
				if (data.secondOperandType == Cond.OPERANDTYPE_SELF) {
				rightOperandEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
					rightOperandEditor.data = data.secondOperandName;
					rightOperandEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
					rightOperandEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "deleteItemTTip");
					rightOperandEditor.setBounds(_deleteItemCol.width+_leftOperandCol.width+_operatorCol.width+_rightOperandTypeCol.width+1, selectedItemTop, _rightOperandCol.width-2, _linkConditionDG.rowHeight-2);
					rightOperandEditor.setStyle("horizontalGap", "3");
					rightOperandEditor.clickHandler = doOperandEditorClick;
					rightOperandEditor.setEditable(true);
				} else {					
					(_linkConditionDG.itemEditorInstance as KoreanTextInput).text = data.secondOperandName;
				}
			}
		}

		private function condEditEnd(event:DataGridEvent):void {
			var data:Object = event.itemRenderer.data;
			var cond:Cond = _linkConditionDG.selectedItem as Cond;						
			if (event.columnIndex == 2) {
				cond.operator = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
			}else if (event.columnIndex == 3) {
				cond.secondOperandType = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
			}
			if (event.columnIndex == 4) {
				if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION) {
					cond.secondOperandType = Cond.OPERANDTYPE_EXPRESSION;
					cond.secondOperand = null;
					cond.secondOperandName = (_linkConditionDG.itemEditorInstance as KoreanTextInput).text;
				}
			}
		}
		
	}
}