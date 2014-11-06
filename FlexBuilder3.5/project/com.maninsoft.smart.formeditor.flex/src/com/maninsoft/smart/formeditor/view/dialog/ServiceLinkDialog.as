package com.maninsoft.smart.formeditor.view.dialog
{
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.util.FormEditorService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
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
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;

	public class ServiceLinkDialog extends AbstractDialog
	{
		private var _form:FormDocument;
		private var _serviceLink:ServiceLink;
		private var _targetServiceRef:SystemService;
			
		private	var nameText:KoreanTextInput = new KoreanTextInput();
		private var serviceIdEditor: ButtonPropertyEditor = new ButtonPropertyEditor;

		private var fieldOptions:ArrayCollection = null;
		private var linkedService:SystemService;
		private var linkedFieldOptions:ArrayCollection = null;

		private var _linkConditionDG:DataGrid = new DataGrid();
		private	var _messageInParamCol:DataGridColumn = new DataGridColumn();
		private	var _targetTypeCol:DataGridColumn = new DataGridColumn();
		private	var _targetValueCol:DataGridColumn = new DataGridColumn();
		private	var _targetValueTypeCol:DataGridColumn = new DataGridColumn();

		private var executionRadioGroup: RadioButtonGroup = new RadioButtonGroup();

		private var targetTypeComboBox:ComboBoxPropertyEditor;
		private var targetValueEditor:ButtonPropertyEditor;
		private var targetValueTypeComboBox:ComboBoxPropertyEditor;

		[Bindable]
		private var actualParams:ArrayCollection = new ArrayCollection();
			
		public function ServiceLinkDialog()
		{
			super();
			this.title = resourceManager.getString("FormEditorETC", "systemServiceConnectText");
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
			this.refresh();
		}
		public function get serviceLink():ServiceLink {
			return _serviceLink;
		}
		public function set serviceLink(serviceLink:ServiceLink):void {
			if (this._serviceLink == serviceLink)
				return;
			this._serviceLink = serviceLink;
			if(serviceLink && serviceLink.targetServiceId){
				FormEditorService.getSystemServiceRef(serviceLink.targetServiceId, serviceRefCallback);
				function serviceRefCallback(serviceRef:SystemService):void{
					_targetServiceRef = serviceRef;
					refresh();
				}				
			}else{
				_targetServiceRef=null;
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

			var serviceIdHBox:HBox = new HBox();
			serviceIdHBox.percentWidth = 100;
			serviceIdHBox.setStyle("verticalAlign", "middle");
			var serviceIdLabel:Label = new Label();
			serviceIdLabel.text = resourceManager.getString('FormEditorETC', 'serviceNameText');
			serviceIdLabel.width = 110;
			serviceIdHBox.addChild(serviceIdLabel);

			serviceIdEditor.setBounds(serviceIdLabel.width, 0, 530, 22);
			serviceIdEditor.setEditable(false);
			serviceIdEditor.clickHandler = doEditorClick;
			serviceIdEditor.buttonIcon = PropertyIconLibrary.refFormIdIcon;
			serviceIdEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "serviceSelectTTip");
			serviceIdHBox.addChild(serviceIdEditor);
			this.contentBox.addChild(serviceIdHBox);

			var parameterLabel:Label = new Label();
			parameterLabel.text = resourceManager.getString('FormEditorETC', 'parameterValueText');
			parameterLabel.width = 120;
			this.contentBox.addChild(parameterLabel);

			_messageInParamCol.dataField="formalParameterName";
			_messageInParamCol.headerText=resourceManager.getString('ProcessEditorETC', 'serviceMessageInText');
			_messageInParamCol.width = 185;
			_messageInParamCol.editable = false;

			_targetTypeCol.dataField="targetTypeName";
			_targetTypeCol.headerText=resourceManager.getString('FormEditorETC', 'targetTypeText');
			_targetTypeCol.width = 120;
			_targetTypeCol.editable = true;
			_targetTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_targetValueCol.dataField="targetFieldName";
			_targetValueCol.headerText=resourceManager.getString('FormEditorETC', 'targetValueText');
			_targetValueCol.width = 185;
			_targetValueCol.editable = true;
			
			_targetValueTypeCol.dataField="targetValueTypeName";
			_targetValueTypeCol.headerText=resourceManager.getString('FormEditorETC', 'targetValueTypeText');
			_targetValueTypeCol.width = 90;
			_targetValueTypeCol.editable = true;
			_targetValueTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_linkConditionDG.columns = [_messageInParamCol, _targetTypeCol, _targetValueCol, _targetValueTypeCol];
			_linkConditionDG.styleName="selectLinkConditionDG"
			_linkConditionDG.height=21+23*5+2;
			_linkConditionDG.percentWidth=100;
			_linkConditionDG.dataProvider = actualParams;
			_linkConditionDG.showHeaders=true;
			_linkConditionDG.headerHeight=21;
			_linkConditionDG.rowHeight=23;
			_linkConditionDG.editable=true;
			_linkConditionDG.selectable=true;
			_linkConditionDG.sortableColumns=false;
			_linkConditionDG.draggableColumns=false;
			_linkConditionDG.resizableColumns=true;
			_linkConditionDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_linkConditionDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_linkConditionDG);

			var radioButtonGroupBox:VBox = new VBox();
			radioButtonGroupBox.styleName="linkConditionGroupBox";
			
			executionRadioGroup.selectedValue=ActualParameters.EXECUTION_BEFORE;
			
			var beforeRadioButton:RadioButton = new RadioButton();
			beforeRadioButton.group = executionRadioGroup;
			beforeRadioButton.height = 21;
			beforeRadioButton.label = resourceManager.getString('FormEditorETC', 'beforeNCommentsText');
			beforeRadioButton.value = ActualParameters.EXECUTION_BEFORE;
			radioButtonGroupBox.addChild(beforeRadioButton);

			var afterRadioButton:RadioButton = new RadioButton();
			afterRadioButton.group = executionRadioGroup;
			afterRadioButton.height = 21;
			afterRadioButton.label = resourceManager.getString('FormEditorETC', 'afterNCommentsText');
			afterRadioButton.value = ActualParameters.EXECUTION_AFTER;
			radioButtonGroupBox.addChild(afterRadioButton);
			contentBox.addChild(radioButtonGroupBox);
			
			_linkConditionDG.addEventListener(MouseEvent.CLICK, checkItem);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, itemEditBegin);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_END, itemEditEnd);			
		}

		private function doEditorClick(editor:ButtonPropertyEditor): void {
			var position:Point = serviceIdEditor.localToGlobal(new Point(0, serviceIdEditor.height+1));
			FormEditorService.getSystemServiceRefs(systemServiceRefsCallback);
			function systemServiceRefsCallback(systemServiceRefs: Array):void{
				SelectServiceIdDialog.execute(systemServiceRefs, _targetServiceRef, doAccept, position, serviceIdEditor.width, 0);
			}
		}

		private function doAccept(item: Object): void {
			if(item is SystemService && SystemService(item).id){
				var systemService:SystemService = item as SystemService;
				serviceLink.targetServiceId = systemService.id;
				_targetServiceRef = systemService;
				serviceIdEditor.editValue = systemService;
				serviceIdEditor.data = systemService.label;
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTSERVICE);
				event.systemServiceRef = systemService;
				refreshFormView(event);
			}
		}
			
		private function refresh():void {
			if (form == null)
				return;
					
			if (serviceLink == null) {
				serviceLink = new ServiceLink(form.serviceLinks);
			} else {
				// 연결명
				nameText.text = serviceLink.name;
				if (serviceLink.actualParams != null) {
					serviceIdEditor.editValue = _targetServiceRef;
					if(_targetServiceRef){
						serviceIdEditor.data = _targetServiceRef.label;
					}
					
					executionRadioGroup.selectedValue = serviceLink.actualParams.execution;
						
					// Actual Parameters
					var actualParams:ArrayCollection = serviceLink.actualParams.actualParameters;
					if (!SmartUtil.isEmpty(actualParams)) {
						for each (var actualParam:ActualParameter in actualParams) {
							if(actualParam.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT){
								actualParams.removeItemAt(actualParams.getItemIndex(actualParam));
								continue;
							}
							if (actualParam.targetType == ActualParameter.TARGETTYPE_EXPRESSION)
								actualParam.targetFieldName = actualParam.expression;
							actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
							actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);
						}
						this.actualParams = actualParams;
					}
				}
					
				refreshFormView();
			}
		}
			
		private function refreshFormView(event:FormEditorEvent = null):void {
			linkedService = null;
			linkedFieldOptions = null;
				
			var linkedServiceId:String = null;
			if(event != null) {
				if (event.type == FormEditorEvent.SELECTSERVICE) {
					var systemServiceRef:SystemService = event.systemServiceRef;
					linkedServiceId = systemServiceRef.id;
					nameText.text = systemServiceRef.name;
					linkedService = event.systemServiceRef;
					var newParams:ActualParameters = new ActualParameters();
					for each(var inParam:SystemServiceParameter in systemServiceRef.messageIn){
						var actualParam:ActualParameter = new ActualParameter();
						actualParam.formalParameterId = inParam.id;
						actualParam.formalParameterName = inParam.name;
						actualParam.formalParameterType = inParam.elementType;
						actualParam.formalParameterMode = ActualParameter.FORMALPARAMETERMODE_IN;
						actualParam.targetType = ActualParameter.TARGETTYPE_EXPRESSION;
						actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
						actualParam.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
						actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);						
						newParams.addActualParameter(actualParam);
					}
					actualParams = newParams.actualParameters;
				}
			}else if (serviceLink != null) {
				linkedServiceId = serviceLink.targetServiceId;
			}
			this._linkConditionDG.dataProvider = actualParams;
		}

		private function checkItem(event:MouseEvent):void {
			if(!this._serviceLink.targetServiceId){
				MsgUtil.showMsg(resourceManager.getString("FormEditorMessages", "FEI003"));
				return;
			}
		}
		private function doTargetValueEditorClick(editor: ButtonPropertyEditor): void {
			var position: Point = editor.localToGlobal(new Point(0, editor.height+1));
			var formEntity:FormEntity = new FormEntity(this._form);
			if(columnIndex == 2){
				formEntity.format.refFormId = this._form.id;
				SelectRefFormFieldIdDialog.execute(formEntity, ActualParameter(_linkConditionDG.selectedItem).targetFieldId, setTargetField, position, editor.width, 0, false, true);
			}
		}

		private function setTargetField(selectedItem:Object):void {
			if(!selectedItem) return;

			var param:ActualParameter = _linkConditionDG.selectedItem as ActualParameter;
			if (columnIndex == 2) {
				param.targetType = ActualParameter.TARGETTYPE_SELF;
				param.targetFieldId = selectedItem.id;
				param.targetFieldName = selectedItem.name;
			}
			_linkConditionDG.invalidateList();
		}

		private function targetTypeIndexByLabel(label:String):int {
			if (SmartUtil.isEmpty(label))
				return -1;
			for(var i:int=0; i< ActualParameter.TARGET_TYPES.length; i++){
				if(label == ActualParameter.TARGET_TYPES[i].label)
					return i;
			}
			return -1;
		}
			
		private function targetTypeIndexByValue(targetType:String):int {
			if (SmartUtil.isEmpty(targetType))
				return -1;
			for(var i:int=0; i< ActualParameter.TARGET_TYPES.length; i++){
				if(targetType == ActualParameter.TARGET_TYPES[i].value)
					return i;
			}
			return -1;
		}
			
		private function targetTypeNameByValue(targetType:String):String {
			if (SmartUtil.isEmpty(targetType))
				return null;
			for(var i:int=0; i< ActualParameter.TARGET_TYPES.length; i++){
				if(targetType == ActualParameter.TARGET_TYPES[i].value)
					return ActualParameter.TARGET_TYPES[i].label;
			}
			return null;
		}
			
		private function targetValueTypeIndexByValue(targetValueType:String):int {
			if (SmartUtil.isEmpty(targetValueType))
				return -1;
			for(var i:int=0; i< ActualParameter.TARGETVALUE_TYPES.length; i++){
				if(targetValueType == ActualParameter.TARGETVALUE_TYPES[i].value)
					return i;
			}
			return -1;
		}
			
		private var columnIndex:int = -1;
		private var rowIndex:int = -1;

		private function itemEditBegin(event:DataGridEvent):void {
			event.preventDefault();
			var data:Object = event.itemRenderer.data;
				
			if (data.targetType == ActualParameter.TARGETTYPE_SELF) {
				_targetValueCol.itemEditor = new ClassFactory(ButtonPropertyEditor);
			} else {
				_targetValueCol.itemEditor = new ClassFactory(KoreanTextInput);
			}
				
			_linkConditionDG.createItemEditor(event.columnIndex, event.rowIndex);
				
			columnIndex = event.columnIndex;
			rowIndex = event.rowIndex;
			var selectedItemTop:Number = event.itemRenderer.y-1;
			
			if (event.columnIndex == 1) {
				targetTypeComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				targetTypeComboBox.setBounds(_messageInParamCol.width+1, selectedItemTop, _targetTypeCol.width-2, _linkConditionDG.rowHeight-2);
				targetTypeComboBox.dataProvider = ActualParameter.TARGET_TYPES;
				targetTypeComboBox.selectedIndex = this.targetTypeIndexByValue(data.targetType);
			} else if (event.columnIndex == 2) {
				if (data.targetType == ActualParameter.TARGETTYPE_SELF) {
					targetValueEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
					targetValueEditor.data = data.targetFieldName;
					targetValueEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
					targetValueEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "deleteItemTTip");
					targetValueEditor.setBounds(_messageInParamCol.width+_targetTypeCol.width+1, selectedItemTop, _targetValueCol.width-2, _linkConditionDG.rowHeight-2);
					targetValueEditor.setStyle("horizontalGap", "3");
					targetValueEditor.clickHandler = doTargetValueEditorClick;
					targetValueEditor.setEditable(true);
				} else {					
					(_linkConditionDG.itemEditorInstance as KoreanTextInput).text = data.targetFieldName;
				}
			}else if (event.columnIndex == 3) {
				targetValueTypeComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				targetValueTypeComboBox.setBounds(_messageInParamCol.width+_targetTypeCol.width+_targetValueCol.width+1, selectedItemTop, _targetValueTypeCol.width-2, _linkConditionDG.rowHeight-2);
				targetValueTypeComboBox.dataProvider = ActualParameter.TARGETVALUE_TYPES;
				targetValueTypeComboBox.selectedIndex = this.targetValueTypeIndexByValue(data.targetValueType);
			}
		}

		private function itemEditEnd(event:DataGridEvent):void {
			var data:Object = event.itemRenderer.data;
			var param:ActualParameter = _linkConditionDG.selectedItem as ActualParameter;						
			if (event.columnIndex == 1) {
				param.targetType = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
				param.targetTypeName = ActualParameter.getTargetTypeNameByValue(param.targetType);
			}else if (event.columnIndex == 2) {
				if (param.targetType == ActualParameter.TARGETTYPE_EXPRESSION) {
					param.targetFieldId = null;
					param.targetFieldName = (_linkConditionDG.itemEditorInstance as KoreanTextInput).text;
					param.expression = param.targetFieldName;
				}
			}else if (event.columnIndex == 3) {
				param.targetValueType = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
				param.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(param.targetValueType);
			}
		}

		override protected function ok(event:Event = null):void {
			super.ok(event);
				
			// 1. 값 보정
			for each (var param:ActualParameter in this.actualParams) {
				if (param.targetType == ActualParameter.TARGETTYPE_EXPRESSION) {
					param.targetFieldId = null;
					param.targetFieldName = null;
				} else {
					param.expression = null;
				}
			}
			for each(var inParam:SystemServiceParameter in linkedService.messageOut){
				var actualParam:ActualParameter = new ActualParameter();
				actualParam.formalParameterId = inParam.id;
				actualParam.formalParameterName = inParam.name;
				actualParam.formalParameterType = inParam.elementType;
				actualParam.formalParameterMode = ActualParameter.FORMALPARAMETERMODE_OUT;
				actualParams.addItem(actualParam);
			}
			
			// 2. 모델에 데이터 설정
			this.serviceLink.name = nameText.text;
			var linkedServiceId:String = null;
			if (this.linkedService != null)
				linkedServiceId = this.linkedService.id;
			this.serviceLink.targetServiceId = linkedServiceId;
			this.serviceLink.actualParams.execution = this.executionRadioGroup.selectedValue as String;
			
			this.serviceLink.actualParams.actualParameters = this.actualParams;
			
			// 3. ok 이벤트 발생
			var fee:FormEditorEvent = new FormEditorEvent(FormEditorEvent.OK);
			fee.model = this.serviceLink;
			dispatchEvent(fee);
			
			// 4. 닫기
			close();
		}
	}
}