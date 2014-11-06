package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.controls.KoreanTextArea;
	import com.maninsoft.smart.common.controls.KoreanTextInput;
	import com.maninsoft.smart.common.controls.SimpleComboBox;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.Map;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.ExpressionNode;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormLink;
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.formeditor.model.ServiceLink;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.view.dialog.util.ArithmeticOperatorComboBox;
	import com.maninsoft.smart.formeditor.view.dialog.util.FormMappingTypeComboBox;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.workbench.common.assets.TreeAssets;
	
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
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.Menu;
	import mx.controls.RadioButtonGroup;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.listClasses.AdvancedListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.ListEvent;
	import mx.events.MenuEvent;
	
	public class FormMappingDialog extends AbstractDialog
	{
			
		private var _diagram:XPDLDiagram;
		private var _mapping:Mapping;
		[Bindable]
		private var expressionTree:XMLListCollection = new XMLListCollection();
		[Bindable]
		private var fieldType:String;
			
		private var nameInput:KoreanTextInput = new KoreanTextInput;
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
	

		[Bindable]
		private var fieldOptions:ArrayCollection = null;
		
		private var _acceptFunc:Function = null;

		public function FormMappingDialog(){
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "formMappingText");
			this.width = 680;
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}

		public function get diagram():XPDLDiagram{
			return _diagram;
		}
		
		public function set diagram(value:XPDLDiagram):void{
			_diagram = value;
		}
		
		public function get mapping():Mapping {
			return _mapping;
		}
		public function set mapping(mapping:Mapping):void {
			this._mapping = mapping;
			refresh();
		}
		
		public function get acceptFunc():Function{
			return _acceptFunc;
		}
		public function set acceptFunc(value:Function):void{
			_acceptFunc = value;
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
	
			expressionLabel.text = resourceManager.getString("FormEditorETC", "conditionText");
			expressionLabel.percentWidth = 100;
			this.contentBox.addChild(expressionLabel);

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
			mappingTypeColumn.itemEditor = new ClassFactory(FormMappingTypeComboBox);
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
			
			expressionTextArea.percentWidth = 100;
			expressionTextArea.height = 0;
			expressionTextArea.visible = false;
			this.contentBox.addChild(expressionTextArea);

		}
			
		private function refresh():void {
			
			if (!SmartUtil.isEmpty(expressionTree))
				expressionTree.removeAll();
				
			// 이름
			nameInput.text = mapping.name;
				
			eachTimeRadioButtonGroup.selectedValue = mapping.eachTime;
				
			// 계산식
			if (SmartUtil.isEmpty(mapping.expressionTree) && !SmartUtil.isEmpty(mapping.expression)) {
				expressionTextArea.text = mapping.expression;
				expressionTextArea.height = 100;
				expressionTextArea.visible = true;
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
					if (!SmartUtil.isEmpty(node.label) && !SmartUtil.isEmpty(node.mappingType)) {
						expressionTree.addItem(node.toXML());
					}
				}
			}
			
//			// 항목연결
//			if (SmartUtil.isEmpty(mapping.fieldMappings)) {
//				refreshFieldMappings();
//			} else {
//				fieldMappings.removeAll();
//				for each (var fieldMapping:FieldMapping in mapping.fieldMappings)
//					fieldMappings.addItem(fieldMapping);
//			}
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
			if (type == ExpressionNode.MAPPINGTYPE_PROCESSFORM) {
				return FormEditorAssets.processIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_SYSTEM) {
				return FormEditorAssets.systemIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
				return FormEditorAssets.expressionIcon;
			} else if (type == ExpressionNode.MAPPINGTYPE_BRACKET) {
				return FormEditorAssets.bracketIcon;
			}
			return null;
		}
			
		private var addMenu:Menu;
		private function expressionClick(event:MouseEvent):void {
			var target:Object = event.target;
			if (target is AdvancedListBaseContentHolder && (SmartUtil.isEmpty(expressionTree) || expressionTree.length == 0)) {
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
			if (event.columnIndex == 0) {
				var itemMdp:Array = [
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
			node.mappingType = ExpressionNode.MAPPINGTYPE_PROCESSFORM;
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
			
			prcForms = new Array();
			prcForms = [{label:"", value:null}];
			prcForms.push({label:"("+resourceManager.getString("FormEditorETC", "processParametersText")+")", value:ExpressionNode.MAPPINGTARGET_PROCESSPARAM});								
			if (!SmartUtil.isEmpty(diagram)) {
				for each(var act:Object in diagram.activities){
					if(act is TaskApplication){
						var task:TaskApplication = act as TaskApplication;
						if(task.formId != null)
							prcForms.push({label: task.formName, value: task.formId});
					}
				}
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
			var i:int;
			
			if (event.columnIndex == 3) {
				formLinkColumn.itemEditor = new ClassFactory(com.maninsoft.smart.common.controls.SimpleComboBox);
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
				var _formLinkComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				if (mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM){
					if (prcForms != null) {
						_formLinkComboBox.dataProvider = prcForms;
					} else {
						prcForms = new Array();
						prcForms = [{label:"", value:null}];
						prcForms.push({label:"("+resourceManager.getString("FormEditorETC", "processParametersText")+")", value:ExpressionNode.MAPPINGTARGET_PROCESSPARAM});								
						if (!SmartUtil.isEmpty(diagram)) {
							for each(var act:Object in diagram.activities){
								if(act is TaskApplication){
									var task:TaskApplication = act as TaskApplication;
									if(task.formId != null)
										prcForms.push({label: task.formName, value: task.formId});
								}
							}
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
						_formLinkComboBox.dataProvider = prcForms;
					}
				} else if(mappingType == ExpressionNode.MAPPINGTYPE_SYSTEM){
					systemFunctionTypes = new Array();
					systemFunctionTypes = [{label:"", value:null}];
					for (i=0; i<ExpressionNode.SYSTEMFUNCTIONTYPES.length; i++)
							systemFunctionTypes.push({label: ExpressionNode.SYSTEMFUNCTIONTYPENAMES[i], value: ExpressionNode.SYSTEMFUNCTIONTYPES[i]});
					_formLinkComboBox.dataProvider = systemFunctionTypes;
					_formLinkComboBox.selectedIndex = 0;
					
				} else if (mappingType == ExpressionNode.MAPPINGTYPE_BRACKET) {
					_formLinkComboBox.dataProvider = null;
					
				}
				_formLinkComboBox.selectItem(formLinkId);
			} else if (event.columnIndex == 4) {
				if (mappingType == ExpressionNode.MAPPINGTYPE_EXPRESSION) {
					var fieldTextInput:TextInput = expressionDataGrid.itemEditorInstance as TextInput;
					fieldTextInput.text = data.@fieldName;
				} else {
					var fieldComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
					if (mappingType == ExpressionNode.MAPPINGTYPE_PROCESSFORM) {
						// 프로세스업무항목 콤보박스
						var prcFormId:String = formLinkId;
						if (SmartUtil.isEmpty(prcFormId)) {
							fieldComboBox.dataProvider = null;
							return;
						} else if (prcFormId == ExpressionNode.MAPPINGTARGET_PROCESSPARAM) {
							fieldComboBox.dataProvider = getProcessParams();
						} else if (prcFormId == ExpressionNode.MAPPINGTARGET_SUBPARAMETER) {
							fieldComboBox.dataProvider = getProcessParams(data.@activityId);
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
				if (valueFunction == null) {
					valueFunction = [
						{label: "", value: null},
						{label: ExpressionNode.toValueFunctionName(ExpressionNode.VALUEFUNCTION_VALUE), value: ExpressionNode.VALUEFUNCTION_VALUE}
					];
				}
				valueFunctionComboBox.dataProvider = valueFunction;
				valueFunctionComboBox.selectItem(data.@valueFunction);
			}
		}

		private var fieldsMap:Map = new Map();
		private function populateFieldComboBox(comboBox:SimpleComboBox, formId:String, selectedFieldId:String):Boolean {
			if (fieldsMap.containsKey(formId)) {
				comboBox.dataProvider = fieldsMap.getValue(formId) as Array;
				return true;
			}
			
			if(!SmartUtil.isEmpty(diagram) && !SmartUtil.isEmpty(diagram.activities)){
				for each(var activity:Object in diagram.activities){
					if(activity is TaskApplication && (activity as TaskApplication).formId == formId){
						var task:TaskApplication = activity as TaskApplication;
						var fieldDp:Array = toFieldDpArray(diagram.server.getTaskFormFields(formId));
						fieldsMap.put(formId, fieldDp);
						comboBox.dataProvider = fieldDp;
						comboBox.selectItem(selectedFieldId);
						return false;
					}
				}
			}
			return false;
		}
		
		private static function toFieldDpArray(fields:Array):Array {
			var array:Array = [{label: "", value: null}];
			if (!SmartUtil.isEmpty(fields)) {
				for each (var field:TaskFormField in fields)
					array.push({icon: FormatTypes.getIcon(field.type), label: field.name, value: field.id});
			}
			return array;
		}

		private function getProcessParams(activityId:String=null):Array {
			if(SmartUtil.isEmpty(diagram)) return null;
			
			if(activityId == null){
				return toProcessOutParams(diagram.pool.formalParameters);
			}else{
				for each(var activity:Object in diagram.activities){
					if(activity.id == activityId)
						return toProcessOutParams(activity.formalParameters);
				}
			}
			return null;
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

		private var subProcesses:Array = null;
		private function getSubProcesses():Array {
			subProcesses = [];
			if (!SmartUtil.isEmpty(diagram)) {
				for(var i:int=0; i<diagram.activities.length; i++)
					if(diagram.activities[i] is SubFlow){
						var subFlow:SubFlow = diagram.activities[i] as SubFlow;
						if(subFlow.subProcessId != null)
							subProcesses.push({label: diagram.activities[i].name + " (" + resourceManager.getString("FormEditorETC", "formalParametersText") + ")", value:ExpressionNode.MAPPINGTARGET_SUBPARAMETER, activityId: diagram.activities[i].id.toString()});
					}
			}
			return subProcesses;
		}

		private var taskServices:Array = null;
		private function getTaskServices():Array {
			taskServices = [];
			if (!SmartUtil.isEmpty(diagram)) {
				for(var i:int=0; i<diagram.activities.length; i++)
					if(diagram.activities[i] is TaskService)
						var taskService:TaskService = diagram.activities[i] as TaskService;
						if(taskService.serviceId != null)
							taskServices.push({label: diagram.activities[i].name + " (" + resourceManager.getString("FormEditorETC", "formalParametersText") + ")", value:ExpressionNode.MAPPINGTARGET_SERVICEPARAM, activityId: diagram.activities[i].id.toString()});
			}
			return taskServices;
		}

		private var applicationServices:Array = null;
		private function getApplicationServices():Array {
			applicationServices = [];
			if (!SmartUtil.isEmpty(diagram)) {
				for(var i:int=0; i<diagram.activities.length; i++)
					if(diagram.activities[i] is ApplicationService)
						var appService:ApplicationService = diagram.activities[i] as ApplicationService;
						if(appService.returnParams != null)
							applicationServices.push({label: diagram.activities[i].name + " (" + resourceManager.getString("ProcessEditorETC", "returnText") + ")", value:ExpressionNode.MAPPINGTARGET_SERVICEPARAM, activityId: diagram.activities[i].id.toString()});
			}
			return applicationServices;
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
				data.@fieldId = null;
				data.@fieldName = "";
			} else if (event.columnIndex == 3) {
				var formLink:Object = null;
				var serviceLink:Object = null;
				var _formLinkComboBox:SimpleComboBox = expressionDataGrid.itemEditorInstance as SimpleComboBox;
				if (_formLinkComboBox != null)
					formLink = _formLinkComboBox.selectedItem;
				if(_formLinkComboBox.selectedItem.activityId)
					data.@activityId = _formLinkComboBox.selectedItem.activityId;
				else
					data.@activityId = null;
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
			if (SmartUtil.isEmpty(expressionTree)) {
				nameInput.text = resourceManager.getString("FormEditorETC", "emptyExpressionText");
				return;
			}
			
			nameInput.text = toExpression("label", expressionTree);
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

			return " mis:getData('" + mappingType + "', '" + formLinkId + "', '" + fieldId + "', '" + valueFunction + "')";			
		}
		
		override protected function ok(event:Event = null):void {
			if(mapping != null){
				mapping.name = nameInput.text;
				if (!SmartUtil.isEmpty(expressionTree) && expressionTree.length == 1) {
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
					mapping = null;
				}					
			}
			
			if(_acceptFunc!=null)
				_acceptFunc(mapping);			
			
			close();
		}		
	}
}