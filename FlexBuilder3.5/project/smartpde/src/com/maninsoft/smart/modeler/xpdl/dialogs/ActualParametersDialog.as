package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.ActualParameter;
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;

	public class ActualParametersDialog extends AbstractDialog
	{
		private static var _dialog:ActualParametersDialog;

		private var _acceptFunc:Function;		
		private var _activity:Activity;
		private var _diagram:XPDLDiagram;

		private var _linkConditionDG:DataGrid = new DataGrid();
		private var _editModeCol:DataGridColumn = new DataGridColumn();
		private	var _messageInParamCol:DataGridColumn = new DataGridColumn();
		private	var _targetTypeCol:DataGridColumn = new DataGridColumn();
		private	var _targetValueCol:DataGridColumn = new DataGridColumn();
		private	var _targetValueTypeCol:DataGridColumn = new DataGridColumn();

		private var targetTypeComboBox:ComboBoxPropertyEditor;
		private var targetValueEditor:ButtonPropertyEditor;
		private var targetValueTypeComboBox:ComboBoxPropertyEditor;

		[Bindable]
		private var actualParams:ArrayCollection = new ArrayCollection();
			
		public function ActualParametersDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "actualParametersSettingText");
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}
			
		public function get activity():Activity{
			return _activity;
		}
		
		public function set activity(value: Activity): void{
			if(_activity == value) return;
			_activity = value;
			var params:ArrayCollection;
			if(_activity is TaskService){
				params = TaskService(_activity).actualParameters.actualParameters;
				_editModeCol.visible = false;
				_editModeCol.width = 0;
			}else if(_activity is SubFlow){
				params = SubFlow(_activity).actualParameters.actualParameters;
				_editModeCol.visible = false;
				_editModeCol.width = 0;
			}else if(_activity is TaskApplication){
				params = TaskApplication(_activity).actualParameters.actualParameters;
				_editModeCol.visible = true;
				_editModeCol.width = 90;
			}
			if(params){
				actualParams = new ArrayCollection();
				for each(var param:ActualParameter in params){
					if(param.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT) continue;
					actualParams.addItem(param.clone());
				}
			}
			this.refresh();
		}
		
		override protected function childrenCreated():void{

			_editModeCol.dataField="editMode";
			_editModeCol.headerText=resourceManager.getString('ProcessEditorETC', 'paramModeText');
			_editModeCol.width = 90;
			_editModeCol.editable = false;

			_messageInParamCol.dataField="formalParameterName";
			_messageInParamCol.headerText=resourceManager.getString('ProcessEditorETC', 'serviceMessageInText');
			_messageInParamCol.width = 185;
			_messageInParamCol.editable = false;

			_targetTypeCol.dataField="targetTypeName";
			_targetTypeCol.headerText=resourceManager.getString('FormEditorETC', 'targetTypeText');
			_targetTypeCol.width = 160;
			_targetTypeCol.editable = true;
			_targetTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_targetValueCol.dataField="targetFieldName";
			_targetValueCol.headerText=resourceManager.getString('FormEditorETC', 'targetValueText');
			_targetValueCol.width = 260;
			_targetValueCol.editable = true;
			
			_targetValueTypeCol.dataField="targetValueTypeName";
			_targetValueTypeCol.headerText=resourceManager.getString('FormEditorETC', 'targetValueTypeText');
			_targetValueTypeCol.width = 90;
			_targetValueTypeCol.editable = true;
			_targetValueTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);

			_linkConditionDG.columns = [_editModeCol, _messageInParamCol, _targetTypeCol, _targetValueCol, _targetValueTypeCol];
			_linkConditionDG.styleName="selectLinkConditionDG"
			_linkConditionDG.percentHeight=100;
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

			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, itemEditBegin);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_END, itemEditEnd);			
		}

		public static function execute(act: Activity, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   ActualParametersDialog, true) as ActualParametersDialog;

			_dialog.activity = act;
			_dialog._acceptFunc = acceptFunc;
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}
	
			if(width) _dialog.width = width;
			if(height) _dialog.height = height;	
			_dialog._diagram = act.diagram as XPDLDiagram;
		}
		
		private function refresh():void {
			// Actual Parameters
			if (!SmartUtil.isEmpty(actualParams)) {
				for each (var actualParam:ActualParameter in actualParams) {
					if (actualParam.targetType == ActualParameter.TARGETTYPE_EXPRESSION)
						actualParam.targetFieldName = actualParam.expression;
					actualParam.targetTypeName = ActualParameter.getTargetTypeNameByValue(actualParam.targetType);
					actualParam.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(actualParam.targetValueType);
				}
				refreshFormView();
			}
		}
			
		private function refreshFormView(event:FormEditorEvent = null):void {
			this._linkConditionDG.dataProvider = actualParams;
		}

		private function doTargetValueEditorClick(editor: ButtonPropertyEditor): void {
			var position:Point = editor.localToGlobal(new Point(0, editor.height+1));
			SelectActivityFieldDialog.execute(_diagram.server.taskForms, _diagram, setTargetField, position, editor.width);
		}

		private function setTargetField(selectedItem: Object):void {
			if(!selectedItem) return;
			
			var taskId:String, selectedId:String, selectedValue:String;
			
			if(selectedItem is TaskFormField){
				for(var i:int=0; i<_diagram.server.taskForms.length; i++){
					if(TaskForm(_diagram.server.taskForms[i]).formId == selectedItem.formId)
						break;
				}
				if(i==_diagram.server.taskForms.length) return;

				for(var j:int=0; j<_diagram.xpdlPackage.process.activities.length; j++){
					if(_diagram.xpdlPackage.process.activities[j] is TaskApplication){
						if(TaskApplication(_diagram.xpdlPackage.process.activities[j]).formId == selectedItem.formId){
							taskId = TaskApplication(_diagram.xpdlPackage.process.activities[j]).id.toString();
							break;
						}
					}
				}
				if(j==_diagram.xpdlPackage.process.activities.length) return;
			
				selectedId = "$ActivityData." + taskId + "." + TaskFormField(selectedItem).id + "." + TaskFormField(selectedItem).name;
				selectedValue = "{" + TaskForm(_diagram.server.taskForms[i]).label + "." + selectedItem.label + "}";
				ActualParameter(actualParams[rowIndex]).targetFieldId = selectedId;
				ActualParameter(actualParams[rowIndex]).targetFieldName = selectedValue;
			}else if(selectedItem is FormalParameter){
				var formalParameter:FormalParameter = selectedItem as FormalParameter;
				if(formalParameter.owner is WorkflowProcess){
					var subPackage: XPDLPackage = WorkflowProcess(formalParameter.owner).owner as XPDLPackage;
					if(_diagram.xpdlPackage.process.id == subPackage.process.id){
						selectedId = "$ProcessParam." + selectedItem.mode + "." + selectedItem.id;
						selectedValue = "{" + subPackage.process.name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(selectedItem.mode)] + "." + selectedItem.id + "}";
						ActualParameter(actualParams[rowIndex]).targetFieldId = selectedId;
						ActualParameter(actualParams[rowIndex]).targetFieldName = selectedValue;
					}else{
						for(i=0; i<_diagram.activities.length; i++){
							if(Activity(_diagram.activities[i]).id.toString() == selectedItem.parentId)
								break;
						}
						if(i==_diagram.activities.length) return;
						selectedId = "$SubParameter." + selectedItem.parentId + "." + selectedItem.mode + "." + selectedItem.id;
						selectedValue = "{" + Activity(_diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(selectedItem.mode)] + "." + selectedItem.id + "}";
						ActualParameter(actualParams[rowIndex]).targetFieldId = selectedId;
						ActualParameter(actualParams[rowIndex]).targetFieldName = selectedValue;
					}
				}else if(formalParameter.owner is ApplicationService){
					for(i=0; i<_diagram.activities.length; i++){
						if(Activity(_diagram.activities[i]).id.toString() == formalParameter.parentId)
							break;
					}
					if(i==_diagram.activities.length) return;
					selectedId = "$ServiceParam." + formalParameter.parentId + "." + FormalParameter.MODE_OUT + "." + formalParameter.id;
					selectedValue = "{" + Activity(_diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(FormalParameter.MODE_OUT)] + "." + formalParameter.id + "}";
					ActualParameter(actualParams[rowIndex]).targetFieldId = selectedId;
					ActualParameter(actualParams[rowIndex]).targetFieldName = selectedValue;
				}
			
			}else if(selectedItem is SystemServiceParameter){
				var serviceParameter: SystemServiceParameter = selectedItem as SystemServiceParameter;
				for(i=0; i<_diagram.activities.length; i++){
					if(Activity(_diagram.activities[i]).id.toString() == selectedItem.parentId)
						break;
				}
				if(i==_diagram.activities.length) return;
				selectedId = "$ServiceParam." + selectedItem.parentId + "." + FormalParameter.MODE_OUT + "." + selectedItem.id;
				selectedValue = "{" + Activity(_diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(FormalParameter.MODE_OUT)] + "." + selectedItem.id + "}";
				ActualParameter(actualParams[rowIndex]).targetFieldId = selectedId;
				ActualParameter(actualParams[rowIndex]).targetFieldName = selectedValue;
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
			for(i=0; i<ActualParameter.TARGET_PROCESS_TYPES.length; i++){
				if(label == ActualParameter.TARGET_PROCESS_TYPES[i].label)
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
			for(i=0; i< ActualParameter.TARGET_PROCESS_TYPES.length; i++){
				if(targetType == ActualParameter.TARGET_PROCESS_TYPES[i].value)
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
			for(i=0; i< ActualParameter.TARGET_PROCESS_TYPES.length; i++){
				if(targetType == ActualParameter.TARGET_PROCESS_TYPES[i].value)
					return ActualParameter.TARGET_PROCESS_TYPES[i].label;
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
				
			if (data.targetType == ActualParameter.TARGETTYPE_PROCESSFORM) {
				_targetValueCol.itemEditor = new ClassFactory(ButtonPropertyEditor);
			} else {
				_targetValueCol.itemEditor = new ClassFactory(KoreanTextInput);
			}
				
			_linkConditionDG.createItemEditor(event.columnIndex, event.rowIndex);
				
			columnIndex = event.columnIndex;
			rowIndex = event.rowIndex;
			var selectedItemTop:Number = event.itemRenderer.y-1;
			if (event.columnIndex == 2) {
				targetTypeComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				targetTypeComboBox.setBounds(_editModeCol.width+_messageInParamCol.width+1, selectedItemTop, _targetTypeCol.width-2, _linkConditionDG.rowHeight-2);
				targetTypeComboBox.dataProvider = ActualParameter.TARGET_PROCESS_TYPES;
				targetTypeComboBox.selectedIndex = this.targetTypeIndexByValue(data.targetType);
			} else if (event.columnIndex == 3) {
				if (data.targetType == ActualParameter.TARGETTYPE_PROCESSFORM) {
					targetValueEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
					targetValueEditor.data = data.targetFieldName;
					targetValueEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
					targetValueEditor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "deleteItemTTip");
					targetValueEditor.setBounds(_editModeCol.width+_messageInParamCol.width+_targetTypeCol.width+1, selectedItemTop, _targetValueCol.width-2, _linkConditionDG.rowHeight-2);
					targetValueEditor.setStyle("horizontalGap", "3");
					targetValueEditor.clickHandler = doTargetValueEditorClick;
					targetValueEditor.setEditable(true);
				} else {					
					(_linkConditionDG.itemEditorInstance as KoreanTextInput).text = data.targetFieldName;
				}
			}else if (event.columnIndex == 4) {
				targetValueTypeComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				targetValueTypeComboBox.setBounds(_editModeCol.width+_messageInParamCol.width+_targetTypeCol.width+_targetValueCol.width+1, selectedItemTop, _targetValueTypeCol.width-2, _linkConditionDG.rowHeight-2);
				targetValueTypeComboBox.dataProvider = ActualParameter.TARGETVALUE_TYPES;
				targetValueTypeComboBox.selectedIndex = this.targetValueTypeIndexByValue(data.targetValueType);
			}
		}

		private function itemEditEnd(event:DataGridEvent):void {
			var data:Object = event.itemRenderer.data;
			var param:ActualParameter = _linkConditionDG.selectedItem as ActualParameter;						
			if (event.columnIndex == 2) {
				if(param.targetType != (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value){
					param.targetFieldId = null;
					param.targetFieldName = null;
					param.targetValueType = ActualParameter.TARGETVALUETYPE_VALUE;
					param.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(param.targetValueType);
					param.expression = null;
				}
				param.targetType = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
				param.targetTypeName = ActualParameter.getTargetTypeNameByValue(param.targetType);
			}else if (event.columnIndex == 3) {
				if (param.targetType == ActualParameter.TARGETTYPE_EXPRESSION) {
					param.targetFieldId = null;
					param.targetFieldName = (_linkConditionDG.itemEditorInstance as KoreanTextInput).text;
					param.expression = param.targetFieldName;
				}
			}else if (event.columnIndex == 4) {
				param.targetValueType = (_linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor).editValue.value;
				param.targetValueTypeName = ActualParameter.getTargetValueTypeNameByValue(param.targetValueType);
			}
		}

		override protected function ok(event:Event = null):void {
			super.ok(event);
				
			// 1. 값 보정
			var actualParameters:ActualParameters = new ActualParameters();
			var param:ActualParameter;
			for each (param in this.actualParams) {
				if (param.targetType == ActualParameter.TARGETTYPE_EXPRESSION) {
					param.targetFieldId = null;
					param.targetFieldName = null;
				} else {
					param.expression = null;
				}
				actualParameters.addActualParameter(param);
			}
			if(activity is TaskService){ 
				for each(param in TaskService(activity).actualParameters.actualParameters){
					if(param.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT)
						actualParameters.addActualParameter(param);
				}
			}else if(activity is SubFlow){ 
				for each(param in SubFlow(activity).actualParameters.actualParameters){
					if(param.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT)
						actualParameters.addActualParameter(param);
				}
			}else if(activity is TaskApplication && TaskApplication(activity).applicationService){ 
				for each(param in TaskApplication(activity).actualParameters.actualParameters){
					if(param.formalParameterMode == ActualParameter.FORMALPARAMETERMODE_OUT)
						actualParameters.addActualParameter(param);
				}
			}
			if(_acceptFunc != null){
				_acceptFunc(actualParameters);
			}
			close();
		}
	}
}