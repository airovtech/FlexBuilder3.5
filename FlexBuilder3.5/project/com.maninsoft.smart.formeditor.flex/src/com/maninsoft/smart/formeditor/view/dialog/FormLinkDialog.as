package com.maninsoft.smart.formeditor.view.dialog
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.model.property.FormFormatInfo;
	import com.maninsoft.smart.formeditor.refactor.simple.navigator.FormItemProxy;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.util.FormEditorService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.resources.ResourceManager;

	public class FormLinkDialog extends AbstractDialog
	{
		private var _form:FormDocument;
		private var _formLink:FormLink;
		private var _targetFormRef:FormRef;
			
		private	var nameText:KoreanTextInput = new KoreanTextInput();
		private var workIdEditor: ButtonPropertyEditor = new ButtonPropertyEditor;

		private var fieldOptions:ArrayCollection = null;
		private var linkedForm:FormDocument;
		private var linkedFieldOptions:ArrayCollection = null;

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

		[Bindable]
		private var conds:ArrayCollection = new ArrayCollection();
			
		public function FormLinkDialog()
		{
			super();
			this.title = resourceManager.getString("FormEditorETC", "otherWorkConnectText");
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}
			
		public function get form():FormDocument {
			return _form;
		}
		
		public function set form(form:FormDocument):void {
			if (this._form == form)
				return;
			this._form = form;
			fieldOptions = toFieldOptions(form);
			this.refresh();
		}
		public function get formLink():FormLink {
			return _formLink;
		}
		public function set formLink(formLink:FormLink):void {
			if (this._formLink == formLink)
				return;
			this._formLink = formLink;
			if(formLink && formLink.targetFormId){
				FormEditorService.getFormRef(formLink.targetFormId, formRefCallback);
				function formRefCallback(formRef:FormRef):void{
					_targetFormRef = formRef;
					refresh();
				}				
			}else{
				_targetFormRef=null;
				refresh();
			}
		}

		override protected function childrenCreated():void{

			var nameHBox:HBox = new HBox();
			nameHBox.percentWidth = 100;
			nameHBox.setStyle("verticalAlign", "middle");
			var nameLabel:Label = new Label();
			nameLabel.text = resourceManager.getString('FormEditorETC', 'connectionNameText');
			nameLabel.width = 110;
			nameHBox.addChild(nameLabel);

			nameText.percentWidth = 100;
			nameHBox.addChild(nameText);
			this.contentBox.addChild(nameHBox);

			var workIdHBox:HBox = new HBox();
			workIdHBox.percentWidth = 100;
			workIdHBox.setStyle("verticalAlign", "middle");
			var workIdLabel:Label = new Label();
			workIdLabel.text = resourceManager.getString('FormEditorETC', 'workNameText');
			workIdLabel.width = 110;
			workIdHBox.addChild(workIdLabel);

			workIdEditor.setBounds(workIdLabel.width, 0, 530, 22);
			workIdEditor.setEditable(false);
			workIdEditor.clickHandler = doEditorClick;
			workIdEditor.buttonIcon = PropertyIconLibrary.refFormIdIcon;
			workIdEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "workIdSelectTTip");
			workIdHBox.addChild(workIdEditor);
			this.contentBox.addChild(workIdHBox);

			var conditionLabel:Label = new Label();
			conditionLabel.text = resourceManager.getString('FormEditorETC', 'connectionConditionText');
			conditionLabel.width = 150;
			this.contentBox.addChild(conditionLabel);

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
			_linkConditionDG.height=21+23*5+2;
			_linkConditionDG.percentWidth=100;
			_linkConditionDG.dataProvider = conds;
			_linkConditionDG.showHeaders=true;
			_linkConditionDG.headerHeight=21;
			_linkConditionDG.rowHeight=23;
			_linkConditionDG.editable=true;
			_linkConditionDG.selectable=true;
			_linkConditionDG.sortableColumns=false;
			_linkConditionDG.draggableColumns=false;
			_linkConditionDG.resizableColumns=false;
			_linkConditionDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_linkConditionDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_linkConditionDG);

			var radioButtonGroupBox:VBox = new VBox();
			radioButtonGroupBox.styleName="linkConditionGroupBox";
			
			condsOperatorRadioGroup.selectedValue=Conds.OPERATOR_AND;
			
			var andRadioButton:RadioButton = new RadioButton();
			andRadioButton.group = condsOperatorRadioGroup;
			andRadioButton.height = 21;
			andRadioButton.label = resourceManager.getString('FormEditorETC', 'andNCommentsText');
			andRadioButton.value = Conds.OPERATOR_AND;
			radioButtonGroupBox.addChild(andRadioButton);

			var orRadioButton:RadioButton = new RadioButton();
			orRadioButton.group = condsOperatorRadioGroup;
			orRadioButton.height = 21;
			orRadioButton.label = resourceManager.getString('FormEditorETC', 'orNCommentsText');
			orRadioButton.value = Conds.OPERATOR_OR;
			radioButtonGroupBox.addChild(orRadioButton);
			contentBox.addChild(radioButtonGroupBox);
			
			_linkConditionDG.addEventListener(MouseEvent.CLICK, checkCond);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, condEditBegin);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_END, condEditEnd);			
		}

		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var position:Point = workIdEditor.localToGlobal(new Point(0, workIdEditor.height+1));
			SelectRefFormIdDialog.execute(FormEditorBase.getInstance(), _targetFormRef, doAccept, position, workIdEditor.width, 0, true);
		}

		private function doAccept(item: Object): void {
			if(item is WorkPackage && WorkPackage(item).formId){
				FormEditorService.getFormRef(WorkPackage(item).formId, formRefCallback);
				function formRefCallback(formRef: FormRef):void{
					formLink.targetFormId = formRef.id;
					_targetFormRef = formRef;
					workIdEditor.editValue = formRef;
					workIdEditor.data = formRef.label;
					var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTFORM);
					event.formRef = formRef;
					refreshFormView(event);
				}
			}
		}
			
		private function refresh():void {
			if (form == null)
				return;
					
			if (formLink == null) {
				formLink = new FormLink(form.formLinks);
			} else {
				// 연결명
				nameText.text = formLink.name;
				if (formLink.conds != null) {
					workIdEditor.editValue = _targetFormRef;
					if(_targetFormRef){
						workIdEditor.data = _targetFormRef.label;
					}
					
					// and/or
					condsOperatorRadioGroup.selectedValue = formLink.conds.operator;
						
					// conditions
					var conds:ArrayCollection = formLink.conds.conds;
					if (!SmartUtil.isEmpty(conds)) {
						for each (var cond:Cond in conds) {
							if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION)
								cond.secondOperandName = cond.secondExpr;
						}
						this.conds = conds;
					}
				}
					
				refreshFormView();
			}
		}
			
		private function refreshFormView(event:FormEditorEvent = null):void {
			linkedForm = null;
			linkedFieldOptions = null;
				
			var linkedFormId:String = null;
			if (event != null) {
				if (event.type == FormEditorEvent.SELECTFORM) {
					var formRef:FormRef = event.formRef;
					linkedFormId = formRef.id;
					nameText.text = formRef.name;
				}
			} else if (formLink != null) {
				linkedFormId = formLink.targetFormId;
			}
			if (SmartUtil.isEmpty(linkedFormId)) {
				this.refreshCondsView();
				return;
			}
				
			FormEditorService.getForm(linkedFormId, refreshFormViewCallback);
		}
		private function refreshFormViewCallback(form:FormDocument):void {
			this.linkedForm = form;
			linkedFieldOptions = toFieldOptions(linkedForm);
			this.refreshCondsView();
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
			
			this._linkConditionDG.dataProvider = conds;
		}
		
		private function toOperandName(id:String, type:String, name:String):String {
			if (SmartUtil.isEmpty(type) || type == Cond.OPERANDTYPE_EXPRESSION)
				return name;
			if (SmartUtil.isEmpty(id))
				return null;
			var options:ArrayCollection = null;
			if (type == Cond.OPERANDTYPE_SELF) {
				options = fieldOptions;
			} else if (type == Cond.OPERANDTYPE_OTHER) {
				options = linkedFieldOptions;
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
			if(!this._formLink.targetFormId){
				MsgUtil.showMsg(resourceManager.getString("FormEditorMessages", "FEI002"));
				return;
			}
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
			var formEntity:FormEntity = new FormEntity(this._form);
			if(columnIndex == 1){
				formEntity.format.refFormId = this._formLink.targetFormId;
				SelectRefFormFieldIdDialog.execute(formEntity, Cond(_linkConditionDG.selectedItem).firstOperand, setOperand, position, editor.width, 0, false, true);
			}else if(columnIndex == 4){
				formEntity.format.refFormId = this._form.id;
				SelectRefFormFieldIdDialog.execute(formEntity, Cond(_linkConditionDG.selectedItem).secondOperand, setOperand, position, editor.width, 0, false, true);
			}
		}

		private function setOperand(selectedItem:Object):void {
			if(!selectedItem) return;

			var cond: Cond = _linkConditionDG.selectedItem as Cond;
			if (columnIndex == 1) {
				cond.firstOperandType = Cond.OPERANDTYPE_OTHER;
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

		override protected function ok(event:Event = null):void {
			super.ok(event);
				
			// 1. 값 보정
			for each (var cond:Cond in this.conds) {
				if (cond.secondOperandType == Cond.OPERANDTYPE_EXPRESSION) {
					cond.secondExpr = cond.secondOperandName;
					cond.secondOperandName = null;
				} else {
					cond.secondExpr = null;
				}
			}
				
			// 2. 모델에 데이터 설정
			this.formLink.name = nameText.text;
			var linkedFormId:String = null;
			if (this.linkedForm != null)
				linkedFormId = this.linkedForm.id;
			this.formLink.targetFormId = linkedFormId;
			this.formLink.conds.operator = this.condsOperatorRadioGroup.selectedValue as String;
			this.formLink.conds.conds = this.conds;
			
			// 3. ok 이벤트 발생
			var fee:FormEditorEvent = new FormEditorEvent(FormEditorEvent.OK);
			fee.model = this.formLink;
			dispatchEvent(fee);
			
			// 4. 닫기
			close();
		}
	}
}