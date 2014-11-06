package com.maninsoft.smart.formeditor.view.dialog
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.refactor.simple.navigator.FormItemProxy;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	public class DetailConditionDialog extends AbstractDialog
	{
		private var _formEditorBase:FormEditorBase;
		private var _field:FormEntity;
		private var _propertyId:String;
		private var _callback:Function;
		[Bindable]
		private var fieldType:String;

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

		public function DetailConditionDialog(){
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
			refresh();
		}

		public function get propertyId():String {
			return _propertyId;
		}
		public function set propertyId(propertyId:String):void {
			_propertyId = propertyId;
		}
		
		public function get callback():Function {
			return _callback;
		}
		public function set callback(callback:Function):void {
			_callback = callback;
		}
		
		override protected function childrenCreated():void{

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
			contentBox.addChild(_linkConditionDG);

			radioButtonGroupBox.styleName="linkConditionGroupBox";
			radioButtonGroupBox.visible=false;
			radioButtonGroupBox.height=0;
			
			condsOperatorRadioGroup.selectedValue=Conds.OPERATOR_AND;
			
			var andRadioButton:RadioButton = new RadioButton();
			andRadioButton.group = condsOperatorRadioGroup;
			andRadioButton.height = 21;
			andRadioButton.label = resourceManager.getString('FormEditorETC', 'andNCommentsE2Text');
			andRadioButton.value = Conds.OPERATOR_AND;
			radioButtonGroupBox.addChild(andRadioButton);

			var orRadioButton:RadioButton = new RadioButton();
			orRadioButton.group = condsOperatorRadioGroup;
			orRadioButton.height = 21;
			orRadioButton.label = resourceManager.getString('FormEditorETC', 'orNCommentsE2Text');
			orRadioButton.value = Conds.OPERATOR_OR;
			radioButtonGroupBox.addChild(orRadioButton);
			contentBox.addChild(radioButtonGroupBox);
			_linkConditionDG.addEventListener(MouseEvent.CLICK, checkCond);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, condEditBegin);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_END, condEditEnd);			

		}
			
		private function refresh():void {
			if (field == null)
				return;
			
			// 계산식
			this.titleIcon = FormEditorAssets.detailConditionIcon;
			this.title = resourceManager.getString("FormEditorETC", "detailConditionText");
			this.width = 600;
			
			_linkConditionDG.height=21+23*10+2;
			_linkConditionDG.visible=true;
			radioButtonGroupBox.visible=true;
			radioButtonGroupBox.height=23*2+2;

			this.fieldOptions = toFieldOptions(field.root);
			if(this.conds==null){
				if(this.propertyId == FormEntity.PROP_HIDDEN_USE && field.hiddenConditions!=null){
			 		this.conds = field.hiddenConditions.conds;
			 		condsOperatorRadioGroup.selectedValue = field.hiddenConditions.operator;
			 	}else if(this.propertyId == FormEntity.PROP_READONLY_USE && field.readOnlyConditions!=null){
			 		this.conds = field.readOnlyConditions.conds;
			 		condsOperatorRadioGroup.selectedValue = field.readOnlyConditions.operator;
			 	}else if(this.propertyId == FormEntity.PROP_REQUIRED_USE && field.requiredConditions!=null){
			 		this.conds = field.requiredConditions.conds;
			 		condsOperatorRadioGroup.selectedValue = field.requiredConditions.operator;
				}	

			 	if(this.conds==null) this.conds = new ArrayCollection();

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
			
		override protected function ok(event:Event = null):void {
			if(this.conds != null){
	
				// 1. 값 보정
				for each (var cond:Cond in this.conds) {
					if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION) {
						cond.secondExpr = cond.secondOperandName;
						cond.secondOperandName = null;
					} else {
						cond.secondExpr = null;
					}
				}
				
				if(_propertyId == FormEntity.PROP_HIDDEN_USE){
					field.hiddenConditions.conds = this.conds;
					field.hiddenConditions.operator = condsOperatorRadioGroup.selectedValue as String;
				}else if(_propertyId == FormEntity.PROP_READONLY_USE){
					field.readOnlyConditions.conds = this.conds;
					field.readOnlyConditions.operator = condsOperatorRadioGroup.selectedValue as String;
				}else if(_propertyId == FormEntity.PROP_REQUIRED_USE){
					field.requiredConditions.conds = this.conds;
					field.requiredConditions.operator = condsOperatorRadioGroup.selectedValue as String;
				}
 			}			

			close();
			if(_callback != null)
				_callback();
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
		
		public static function popupDetailConditionDialog(parent:DisplayObjectContainer, position:Point, field:FormEntity, propertyId:String, callback:Function = null):void {
			var detailConditionDialog:DetailConditionDialog = PopUpManager.createPopUp(parent, DetailConditionDialog, true) as DetailConditionDialog;
			if (callback != null)
				detailConditionDialog.addEventListener(FormEditorEvent.OK, callback);
			
			detailConditionDialog.propertyId = propertyId;
			detailConditionDialog.formEditorBase = parent as FormEditorBase;
			detailConditionDialog.field = field;
			detailConditionDialog.callback = callback;
			detailConditionDialog.x = position.x;
			detailConditionDialog.y = position.y;
		}
		
	}
}