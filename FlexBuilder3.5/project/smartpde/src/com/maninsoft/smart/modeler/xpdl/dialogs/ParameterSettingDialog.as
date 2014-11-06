package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.assets.DialogAssets;
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.formeditor.model.type.FormatTypes;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLPackage;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.TextPropertyEditor;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.Application;
	import mx.core.ClassFactory;
	import mx.core.ScrollPolicy;
	import mx.events.DataGridEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;

	public class ParameterSettingDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------
		private static const MAX_PARAMETER_ROW:int = 20;

		private static var _dialog: ParameterSettingDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		[Bindable]
		public var _params: ArrayCollection = new ArrayCollection;

		private var _acceptFunc: Function;
		
		private var _parametersDG:DataGrid = new DataGrid();
		private	var _deleteItemCol:DataGridColumn = new DataGridColumn();
		private	var _modeCol:DataGridColumn = new DataGridColumn();
		private	var _idCol:DataGridColumn = new DataGridColumn();
		private	var _dataTypeCol:DataGridColumn = new DataGridColumn();

		private var _pool: Pool;
		private var _process: WorkflowProcess;
		private var diagram:XPDLDiagram;

		private var	deleteItemEditor:ButtonPropertyEditor;			
		private var modeComboBox:ComboBoxPropertyEditor;
		private var idEditor: TextPropertyEditor;
		private var dataTypeComboBox:ComboBoxPropertyEditor;

		public function ParameterSettingDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "parameterSettingTTip");
			this.showCloseButton=true;
			this.showOkButton=true;
			this.showCancelButton=true;
		}
		
		public function get pool(): Pool{
			return _pool;
		}
		
		public function set pool(value: Pool): void{
			_pool = value;
		}
		
		public function get process(): WorkflowProcess{
			return _process;
		}
		
		public function set process(value: WorkflowProcess): void{
			_process = value;
		}
		
		public function get params(): ArrayCollection{
			return _params;
		}
		
		public function set params(value: ArrayCollection): void{
			_params = value;
		}
		
		override protected function childrenCreated():void{

			_deleteItemCol.headerText=resourceManager.getString('ProcessEditorETC', 'deleteItemText');
			_deleteItemCol.width = 40;
			_deleteItemCol.editable = true;
			_deleteItemCol.itemEditor=new ClassFactory(ButtonPropertyEditor);

			_modeCol.dataField="mode";
			_modeCol.headerText=resourceManager.getString('ProcessEditorETC', 'paramModeText');
			_modeCol.width = 90;
			_modeCol.editable = true;
			_modeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);
			
			_idCol.dataField="id";
			_idCol.headerText=resourceManager.getString('ProcessEditorETC', 'paramIdText');
			_idCol.width = 200;
			_idCol.editable = true;
			_idCol.itemEditor=new ClassFactory(TextPropertyEditor);

			_dataTypeCol.dataField="dataType";
			_dataTypeCol.headerText=resourceManager.getString('ProcessEditorETC', 'paramDataTypeText');
			_dataTypeCol.width = 150;
			_dataTypeCol.editable = true;
			_dataTypeCol.itemEditor=new ClassFactory(ComboBoxPropertyEditor);
						
			_parametersDG.columns = [_deleteItemCol, _modeCol, _idCol, _dataTypeCol];
			_parametersDG.styleName="selectLinkConditionDG"
			_parametersDG.percentHeight=100;
			_parametersDG.percentWidth=100;
			_parametersDG.dataProvider = _params;
			_parametersDG.showHeaders=true;
			_parametersDG.headerHeight=21;
			_parametersDG.rowHeight=23;
			_parametersDG.rowCount=MAX_PARAMETER_ROW;
			_parametersDG.editable=true;
			_parametersDG.selectable=true;
			_parametersDG.sortableColumns=false;
			_parametersDG.draggableColumns=false;
			_parametersDG.resizableColumns=true;
			_parametersDG.wordWrap=false;
			_parametersDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_parametersDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_parametersDG);
			
			BindingUtils.bindProperty(_parametersDG, "dataProvider", this, ["_params"]);
			_parametersDG.addEventListener(MouseEvent.CLICK, checkParam);			
			_parametersDG.addEventListener(ListEvent.ITEM_EDIT_BEGIN, paramEditBegin);			
		}

		override protected function ok(event:Event = null):void {
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

		public static function execute(pool: Pool, current: Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   ParameterSettingDialog, true) as ParameterSettingDialog;

			_dialog._acceptFunc = acceptFunc;
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}
	
			if(width) _dialog.width = width;
			if(height) _dialog.height = height;

			_dialog.pool = pool;
			if(pool){
				_dialog.process = XPDLPackage(pool.owner).process;
			}
			if(pool && pool.formalParameters)
				_dialog.setParameters();

		}

		private function doDeleteItemClick(editor: ButtonPropertyEditor): void {
			if(_parametersDG.selectedItem)
				_params.removeItemAt(_parametersDG.selectedIndex);
		}
			
		private function get lastItemTop():Number{
			return _params.length * _parametersDG.rowHeight;
		}
		private function get lastItemBottom():Number{
			return (_params.length+1) * _parametersDG.rowHeight;			
		}

		private function addParameter(param: FormalParameter): void{
			var modeIndex:int = FormalParameter.getModeIndex(param.mode)
			_dialog.params.addItem({mode:(modeIndex==-1)?"":FormalParameter.MODE_TYPES_NAME_FULL[modeIndex], id:param.id, dataType:param.formatType.label});			
		}
		
		private function setParameters(): void{
			for each (var param: FormalParameter in pool.formalParameters){
				addParameter(param);
			}
		}

		private function getFormalParameters(): Array{
			var parameters: Array = [];
			for each (var param: Object in params){
				if(!param.id || param.id=="") return null;
				for each(var param2: Object in params)
					if( (param!=param2) && param.id==param2.id)
						return null;
				var newParameter: FormalParameter = new FormalParameter(process);
				newParameter.id = param.id;
				newParameter.name = param.id;
				newParameter.dataType = FormatTypes.getFormatTypeName(param.dataType);
				var modeIndex:int = FormalParameter.getModeIndex(param.mode);
				newParameter.mode = (modeIndex==-1)?"": FormalParameter.MODE_TYPES_FULL[modeIndex];
				parameters.push(newParameter);
			}
			return parameters;
		}

		private function checkParam(event: MouseEvent):void {
			if (event.target is ListBaseContentHolder && event.localY >= lastItemTop && event.localY <= lastItemBottom) {
				var newParam:FormalParameter = new FormalParameter(process);
				newParam.dataType = FormatTypes.textInput.type;
				newParam.mode = FormalParameter.MODE_INOUT;
				addParameter(newParam);
				_parametersDG.selectedIndex = _params.length - 1;
			}
		}

		private var columnIndex:int = -1;
		private var rowIndex:int = -1;

		private function paramEditBegin(event:DataGridEvent):void {
			event.preventDefault();
				
			var data:Object = event.itemRenderer.data;
				
			_parametersDG.createItemEditor(event.columnIndex, event.rowIndex);
				
			columnIndex = event.columnIndex;
			rowIndex = event.rowIndex;
			var selectedItemTop:Number = event.itemRenderer.y-1;
			if (event.columnIndex == 0) {
				deleteItemEditor = _parametersDG.itemEditorInstance as ButtonPropertyEditor;
				deleteItemEditor.buttonIcon = DialogAssets.deleteItemButton;
				deleteItemEditor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "deleteConditionTTip");
				deleteItemEditor.valueLabel.visible = false;
				deleteItemEditor.dialogButton.buttonMode = false;
				deleteItemEditor.setBounds(5, selectedItemTop, _deleteItemCol.width-13, _parametersDG.rowHeight-2);
				deleteItemEditor.setStyle("horizontalGap", "3");
				deleteItemEditor.clickHandler = doDeleteItemClick;
				deleteItemEditor.setEditable(false);
			}else if (event.columnIndex == 1) {
				modeComboBox = _parametersDG.itemEditorInstance as ComboBoxPropertyEditor;
				modeComboBox.setBounds(_deleteItemCol.width+1, selectedItemTop, _modeCol.width-2, _parametersDG.rowHeight-2);
				modeComboBox.dataProvider = FormalParameter.MODE_TYPES_NAME;
				modeComboBox.selectedIndex = FormalParameter.getModeIndex(data.mode);
			}else if (event.columnIndex == 2) {
				idEditor = _parametersDG.itemEditorInstance as TextPropertyEditor;
				idEditor.setBounds(_deleteItemCol.width+_modeCol.width+1, selectedItemTop, _idCol.width-2, _parametersDG.rowHeight-2);
				idEditor.data = data.id;
			}else if (event.columnIndex == 3) {
				dataTypeComboBox = _parametersDG.itemEditorInstance as ComboBoxPropertyEditor;
				dataTypeComboBox.setBounds(_deleteItemCol.width+_modeCol.width+_idCol.width+1, selectedItemTop, _dataTypeCol.width-2, _parametersDG.rowHeight-2);
				dataTypeComboBox.dataProvider = FormatTypes.formatTypeArray;
				dataTypeComboBox.selectedIndex = FormatTypes.getFormatTypeIndex(data.dataType);
			}
		}

		private function dialogClose(accept: Boolean = true): void {		
			if (accept && (_acceptFunc != null) && _params){
				var formalParameters:Array = getFormalParameters();
				if(formalParameters){
					_acceptFunc(getFormalParameters());
					PopUpManager.removePopUp(this);					
				}else{
					MsgUtil.showError(resourceManager.getString("ProcessEditorMessages", "PEE003" ));
					return;
				}
			}
			PopUpManager.removePopUp(this);
		}
	}
}