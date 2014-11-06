package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.common.util.SmartUtil;
	import com.maninsoft.smart.formeditor.model.Cond;
	import com.maninsoft.smart.formeditor.model.Conds;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.modeler.xpdl.utils.XPDLEditorEvent;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class LinkConditionDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------
		private static const MAX_CONDITION_ROW:int = 5;

		private static var _dialog: LinkConditionDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		[Bindable]
		private var _conds:ArrayCollection = new ArrayCollection();

		private var _acceptFunc: Function;
		
		private var _linkConditionDG:DataGrid = new DataGrid();
		private	var _deleteItemCol:DataGridColumn = new DataGridColumn();
		private	var _leftOperandCol:DataGridColumn = new DataGridColumn();
		private	var _operatorCol:DataGridColumn = new DataGridColumn();
		private	var _rightOperandCol:DataGridColumn = new DataGridColumn();

		private var _link:XPDLLink;
		private var diagram:XPDLDiagram;

		private var condsOperatorRadioGroup: RadioButtonGroup = new RadioButtonGroup();

		private var	deleteItemEditor:ButtonPropertyEditor;			
		private var leftOperandEditor:ButtonPropertyEditor;				
		private var operatorComboBox:ComboBoxPropertyEditor;
		private var rightOperandEditor:ButtonPropertyEditor;

		public function LinkConditionDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "linkConditionSettingText");
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}
		
		public function get link():XPDLLink {
			return _link;
		}
		public function set link(value:XPDLLink):void {
			_link = value;
			diagram = _link.diagram as XPDLDiagram;
			refresh();
		}
			
		override protected function childrenCreated():void{

			_deleteItemCol.headerText=resourceManager.getString('ProcessEditorETC', 'deleteItemText');
			_deleteItemCol.width = 40;
			_deleteItemCol.editable = true;
			_deleteItemCol.itemEditor=new ClassFactory(ButtonPropertyEditor);

			_leftOperandCol.dataField="left";
			_leftOperandCol.headerText=resourceManager.getString('ProcessEditorETC', 'targetWorksNItemText');
			_leftOperandCol.width = 240;
			_leftOperandCol.editable = true;
			_leftOperandCol.itemEditor=new ClassFactory(ButtonPropertyEditor);

			_operatorCol.dataField="operator";
			_operatorCol.headerText=resourceManager.getString('ProcessEditorETC', 'operatorText');
			_operatorCol.width = 90;
			_operatorCol.editable = true;
			_operatorCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);
			
			_rightOperandCol.dataField="right";
			_rightOperandCol.headerText=resourceManager.getString('ProcessEditorETC', 'againstValueText');
			_rightOperandCol.width = 240;
			_rightOperandCol.editable = true;
			_rightOperandCol.itemEditor=new ClassFactory(ButtonPropertyEditor);
			
			_linkConditionDG.columns = [_deleteItemCol, _leftOperandCol, _operatorCol, _rightOperandCol];
			_linkConditionDG.styleName="selectLinkConditionDG"
//			_linkConditionDG.height=21+23*5+2;
			_linkConditionDG.percentWidth=100;
			_linkConditionDG.dataProvider = _conds;
			_linkConditionDG.showHeaders=true;
			_linkConditionDG.headerHeight=21;
			_linkConditionDG.rowHeight=23;
			_linkConditionDG.editable=true;
			_linkConditionDG.selectable=true;
			_linkConditionDG.sortableColumns=false;
			_linkConditionDG.draggableColumns=false;
			_linkConditionDG.resizableColumns=true;
			_linkConditionDG.wordWrap= false;			
			_linkConditionDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_linkConditionDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_linkConditionDG);

			var radioButtonGroupBox:VBox = new VBox();
			radioButtonGroupBox.styleName="linkConditionGroupBox";
			
			condsOperatorRadioGroup.selectedValue=Conds.OPERATOR_AND;
			
			var andRadioButton:RadioButton = new RadioButton();
			andRadioButton.group = condsOperatorRadioGroup;
			andRadioButton.height = 21;
			andRadioButton.label = resourceManager.getString('ProcessEditorETC', 'andNCommentsText');
			andRadioButton.value = Conds.OPERATOR_AND;
			radioButtonGroupBox.addChild(andRadioButton);

			var orRadioButton:RadioButton = new RadioButton();
			orRadioButton.group = condsOperatorRadioGroup;
			orRadioButton.height = 21;
			orRadioButton.label = resourceManager.getString('ProcessEditorETC', 'orNCommentsText');
			orRadioButton.value = Conds.OPERATOR_OR;
			radioButtonGroupBox.addChild(orRadioButton);
			contentBox.addChild(radioButtonGroupBox);
			
			_linkConditionDG.addEventListener(MouseEvent.CLICK, checkCond);			
			_linkConditionDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, condEditBegin);			
		}

		override protected function ok(event:Event = null):void {
			var xeEvent:XPDLEditorEvent = new XPDLEditorEvent(XPDLEditorEvent.OK);
			xeEvent.value = condition;
			dispatchEvent(xeEvent);
			this.dialogClose(true);
		}

		override protected function cancel(event:Event = null):void {
			this.dialogClose(false);
		}

		override protected function close(event:Event = null):void {
			dialogClose(false);
		}

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function execute(link:XPDLLink, current: Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   LinkConditionDialog, true) as LinkConditionDialog;

			_dialog._acceptFunc = acceptFunc;
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}
	
			if(width) _dialog.width = width;
			if(height) _dialog.height = height;

			_dialog.link = link;

		}

		private function refresh():void {
			_conds.removeAll();
			condsOperatorRadioGroup.selectedValue = Conds.OPERATOR_AND;
				
			var condsStr:String = link.condition;
			if (SmartUtil.isEmpty(condsStr))
				return;
				
			condsOperatorRadioGroup.selectedValue = condsOperator(condsStr);
			var index:int = condsOperatorIndex(condsStr);
			while (index != -1) {
				var cond:String = condsStr.substr(0, index);
				condsStr = condsStr.substr(index + 3);
					
				addCond(cond);
				index = condsOperatorIndex(condsStr);
			}
			addCond(condsStr);
		}

		private function condsOperator(condsStr:String):String {
			if (condsStr.indexOf(Conds.OPERATOR_OR + " {") != -1 || condsStr.indexOf(Conds.OPERATOR_OR_SYMBOL + " {") != -1)
				return Conds.OPERATOR_OR;
			else
				return Conds.OPERATOR_AND;
		}

		private function condsOperatorIndex(condsStr:String):int {
			var index:int = -1;
			index = condsStr.indexOf(Conds.OPERATOR_OR + " {");
			if (index == -1) {
				index = condsStr.indexOf(Conds.OPERATOR_OR_SYMBOL + " {");
				if (index == -1) {
					index = condsStr.indexOf(Conds.OPERATOR_AND + " {");
					if (index == -1) {
						index = condsStr.indexOf(Conds.OPERATOR_AND_SYMBOL + " {");
					}
				}
			}
			return index;
		}
		private function condOperator(condStr:String):Object {
			if (SmartUtil.isEmpty(condStr))
				return Cond.OPERATORS[Cond.EQUAL_INDEX];
			for each (var operator:Object in Cond.OPERATORS) {
				if (SmartUtil.isEmpty(operator))
					continue;
				if (condStr.indexOf(operator.value) == -1)
					continue;
				return operator;
			}
			return Cond.OPERATORS[Cond.EQUAL_INDEX];
		}

		private function condOperatorIndex(condStr:String):int {
			if (SmartUtil.isEmpty(condStr))
				return -1;
			for each (var operator:Object in Cond.OPERATORS) {
				if (SmartUtil.isEmpty(operator))
					continue;
				if (condStr.indexOf(operator.value) == -1)
					continue;
				return condStr.indexOf(operator.value);
			}
			return -1;
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
			
		private function addCond(cond:String = null): void {
			var index:int = -1;
			var left:String = "";
			var operator:Object = condOperator(cond);
			var right:String = "";
			var operatorLength:int=0;
			if (cond != null) {
				index = condOperatorIndex(cond);
				if (index > 0){
					operatorLength=operator.value.length;
					left = StringUtil.trim(cond.substr(0, index));
				}
				if (cond.length > index + operatorLength);
					right = StringUtil.trim(cond.substr(index + operatorLength));
			}
			_conds.addItem({left: left, operator: operator.label, right: right});
		}

		private function get lastItemTop():Number{
			return _conds.length * _linkConditionDG.rowHeight;
		}
		private function get lastItemBottom():Number{
			return (_conds.length+1) * _linkConditionDG.rowHeight;			
		}
		private function checkCond(event:MouseEvent):void {
			if (event.target is ListBaseContentHolder && event.localY >= lastItemTop && event.localY <= lastItemBottom) {
				addCond();
				_linkConditionDG.selectedIndex = _conds.length - 1;
			}
		}
/*
		private var itemMenu:Menu;
		private function condClick(event:ListEvent):void {
			if (itemMenu == null) {
				var mdp:Array = new Array();
				mdp.push({label: resourceManager.getString("ProcessEditorETC", "deleteItemText"), click: removeCond});
				itemMenu = Menu.createMenu(this, mdp, false);
			}
			var point:Point = this.localToGlobal(new Point(mouseX, mouseY));
			SmartUtil.showMenu(itemMenu, point.x, point.y);
		}
*/		
		private function doDeleteItemClick(editor: ButtonPropertyEditor): void {
			if(_linkConditionDG.selectedItem)
				_conds.removeItemAt(_linkConditionDG.selectedIndex);
		}
			
		private var columnIndex:int = -1;
		private var rowIndex:int = -1;

		private function condEditBegin(event:DataGridEvent):void {
			event.preventDefault();
				
			var data:Object = event.itemRenderer.data;
				
			_linkConditionDG.createItemEditor(event.columnIndex, event.rowIndex);
				
			columnIndex = event.columnIndex;
			rowIndex = event.rowIndex;
			var selectedItemTop:Number = event.itemRenderer.y-1;
			if (event.columnIndex == 0) {
				deleteItemEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
				deleteItemEditor.buttonIcon = DialogAssets.deleteItemButton;
				deleteItemEditor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "deleteConditionTTip");
				deleteItemEditor.valueLabel.visible = false;
				deleteItemEditor.dialogButton.buttonMode = false;
				deleteItemEditor.setBounds(5, selectedItemTop, _deleteItemCol.width-13, _linkConditionDG.rowHeight-2);
				deleteItemEditor.setStyle("horizontalGap", "3");
				deleteItemEditor.clickHandler = doDeleteItemClick;
				deleteItemEditor.setEditable(false);
			}else if (event.columnIndex == 1) {
				leftOperandEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
				leftOperandEditor.data = data.left;
				leftOperandEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
				leftOperandEditor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "formNFieldSelectTTip");
				leftOperandEditor.setBounds(_deleteItemCol.width+1, selectedItemTop, _leftOperandCol.width-2, _linkConditionDG.rowHeight-2);
				leftOperandEditor.setStyle("horizontalGap", "3");
				leftOperandEditor.clickHandler = doEditorClick;
				leftOperandEditor.setEditable(false);
			} else if (event.columnIndex == 2) {
				operatorComboBox = _linkConditionDG.itemEditorInstance as ComboBoxPropertyEditor;
				operatorComboBox.setBounds(_deleteItemCol.width+_leftOperandCol.width+1, selectedItemTop, _operatorCol.width-2, _linkConditionDG.rowHeight-2);
				operatorComboBox.dataProvider = Cond.OPERATORS;
				operatorComboBox.selectedIndex = operatorIndexByLabel(data.operator);
			} else if (event.columnIndex == 3) {
				rightOperandEditor = _linkConditionDG.itemEditorInstance as ButtonPropertyEditor;
				rightOperandEditor.data = data.right;
				rightOperandEditor.buttonIcon = PropertyIconLibrary.formIdIcon;
				rightOperandEditor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "formNFieldSelectTTip");
				rightOperandEditor.setBounds(_deleteItemCol.width+_leftOperandCol.width+_operatorCol.width+1, selectedItemTop, _rightOperandCol.width-2, _linkConditionDG.rowHeight-2);
				rightOperandEditor.setStyle("horizontalGap", "3");
				rightOperandEditor.clickHandler = doEditorClick;
				rightOperandEditor.setEditable(true);
			}
		}

		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var position:Point = editor.localToGlobal(new Point(0, editor.height+1));
			SelectActivityFieldDialog.execute(diagram.server.taskForms, diagram, setOperand, position, editor.width);
		}

		private function setOperand(selectedItem: Object):void {
			if(!selectedItem) return;
			
			if(selectedItem is TaskFormField){
				for(var i:int=0; i<diagram.server.taskForms.length; i++){
					if(TaskForm(diagram.server.taskForms[i]).formId == selectedItem.formId)
						break;
				}
				if(i==diagram.server.taskForms.length) return;
			
				var selectedValue:String = "{" + TaskForm(diagram.server.taskForms[i]).label + "." + selectedItem.label + "}";
				if (columnIndex == 1) {
					_conds[rowIndex].left = selectedValue;
				} else if (columnIndex == 3) {
					_conds[rowIndex].right = selectedValue;
				}
			}else if(selectedItem is FormalParameter){
				var formalParameter: FormalParameter = selectedItem as FormalParameter;
				if(formalParameter.owner is WorkflowProcess){
					var subPackage: XPDLPackage = WorkflowProcess(formalParameter.owner).owner as XPDLPackage;
					if(diagram.xpdlPackage.process.id == subPackage.process.id){
						selectedValue = "{" + subPackage.process.name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(selectedItem.mode)] + "." + selectedItem.id + "}";
						if (columnIndex == 1) {
							_conds[rowIndex].left = selectedValue;
						} else if (columnIndex == 3) {
							_conds[rowIndex].right = selectedValue;
						}				
					}else{
						for(i=0; i<diagram.activities.length; i++){
							if(Activity(diagram.activities[i]).id.toString() == selectedItem.parentId)
								break;
						}
						if(i==diagram.activities.length) return;
						selectedValue = "{" + Activity(diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(selectedItem.mode)] + "." + selectedItem.id + "}";
						if (columnIndex == 1) {
							_conds[rowIndex].left = selectedValue;
						} else if (columnIndex == 3) {
							_conds[rowIndex].right = selectedValue;
						}				
					}
				}else if(formalParameter.owner is ApplicationService){
					var returnParameter: FormalParameter = selectedItem as FormalParameter;
					for(i=0; i<diagram.activities.length; i++){
						if(Activity(diagram.activities[i]).id.toString() == returnParameter.parentId)
							break;
					}
					if(i==diagram.activities.length) return;
					selectedValue = "{" + Activity(diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(FormalParameter.MODE_OUT)] + "." + returnParameter.id + "}";
					if (columnIndex == 1) {
						_conds[rowIndex].left = selectedValue;
					} else if (columnIndex == 3) {
						_conds[rowIndex].right = selectedValue;
					}				
				}
			}else if(selectedItem is SystemServiceParameter){
				var serviceParameter: SystemServiceParameter = selectedItem as SystemServiceParameter;
				for(i=0; i<diagram.activities.length; i++){
					if(Activity(diagram.activities[i]).id.toString() == selectedItem.parentId)
						break;
				}
				if(i==diagram.activities.length) return;
				selectedValue = "{" + Activity(diagram.activities[i]).name + "." + FormalParameter.MODE_TYPES_NAME_FULL[FormalParameter.getModeIndex(FormalParameter.MODE_OUT)] + "." + selectedItem.id + "}";
				if (columnIndex == 1) {
					_conds[rowIndex].left = selectedValue;
				} else if (columnIndex == 3) {
					_conds[rowIndex].right = selectedValue;
				}				
			} 
			_linkConditionDG.invalidateList();
		}

		private function get condition():String {
			if (SmartUtil.isEmpty(_conds))
				return "";
				
			var expr:String = "";
			var condsOperator:String = condsOperatorRadioGroup.selectedValue as String;
			var i:int = 0;
			for each (var cond:Object in _conds) {
				var left:String = StringUtil.trim(cond.left as String);
				var operator:String = StringUtil.trim(cond.operator as String);
				var right:String = StringUtil.trim(cond.right as String);
					
				if (SmartUtil.isEmpty(left) || SmartUtil.isEmpty(operator) || SmartUtil.isEmpty(right))
					continue;
				if (i++ > 0) {
					expr += " " + condsOperator + " ";
				}
				expr += left + " " + Cond.OPERATORS[operatorIndexByLabel(operator)].value + " " + right;
			}
			return expr;
		}

		private function dialogClose(accept: Boolean = true): void {		
			if (accept && (_acceptFunc != null) && _conds)
				_acceptFunc(condition);
		
			PopUpManager.removePopUp(this);
		}
	}
}