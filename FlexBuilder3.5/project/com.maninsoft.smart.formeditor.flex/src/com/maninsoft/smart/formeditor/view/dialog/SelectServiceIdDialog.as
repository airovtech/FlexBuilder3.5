package com.maninsoft.smart.formeditor.view.dialog
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.workbench.common.event.PageViewEvent;
	import com.maninsoft.smart.workbench.common.util.PagingView;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	public class SelectServiceIdDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------

		private static var _dialog: SelectServiceIdDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _systemServices: Array = new Array();
		
		[Bindable]
		public var _systemServicesPage:Array = new Array();
		private var _acceptFunc: Function;
		
		private var _systemServiceDG:DataGrid = new DataGrid();
		private var _pagingView:PagingView = new PagingView();
		
		[Bindable]
		public var pageSize:int=5;
		[Bindable]
		public var pageNo:int=0;
		[Bindable]
		public var totalSize:int=0;
		private var selectedItem:SystemService;

		public function SelectServiceIdDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "serviceIdSelectionText");
			this.showCloseButton=true;
		}
		
		override protected function childrenCreated():void{
			var nameCol:DataGridColumn = new DataGridColumn();
			nameCol.dataField="name";
			nameCol.setStyle("textAlign", "left");
			nameCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "systemServiceNameText");
			nameCol.wordWrap=true;
			
			var descriptionCol:DataGridColumn = new DataGridColumn();
			descriptionCol.dataField="description";
			descriptionCol.setStyle("textAlign", "left");
			descriptionCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "systemServiceDescText");
			descriptionCol.wordWrap=true;
			
			var wsdlUliCol:DataGridColumn = new DataGridColumn();
			wsdlUliCol.dataField="wsdlUli";
			wsdlUliCol.setStyle("textAlign", "left");
			wsdlUliCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "systemServiceWsdlUliText");
			wsdlUliCol.wordWrap=true;
			
			var portCol:DataGridColumn = new DataGridColumn();
			portCol.dataField="port";
			portCol.setStyle("textAlign", "left");
			portCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "systemServicePortText");
			portCol.wordWrap=true;
			
			var operationCol:DataGridColumn = new DataGridColumn();
			operationCol.dataField="operation";
			operationCol.setStyle("textAlign", "left");
			operationCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "systemServiceOperationText");
			operationCol.wordWrap=true;
			
			_systemServiceDG.columns = [nameCol, descriptionCol, wsdlUliCol, portCol, operationCol];
			_systemServiceDG.styleName="selectSystemServiceDG"
			_systemServiceDG.percentWidth=100;
			BindingUtils.bindProperty(_systemServiceDG, "dataProvider", this, ["_systemServicesPage"]);
			_systemServiceDG.showHeaders=true;
			_systemServiceDG.headerHeight=21;
			_systemServiceDG.rowHeight=21;
			_systemServiceDG.editable=false;
			_systemServiceDG.sortableColumns=false;
			_systemServiceDG.draggableColumns=false;
			_systemServiceDG.resizableColumns=true;
			_systemServiceDG.wordWrap=false;
			_systemServiceDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_systemServiceDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_systemServiceDG);
			
			BindingUtils.bindProperty(_pagingView, "pageSize", this, ["pageSize"]);
			BindingUtils.bindProperty(_pagingView, "pageNo", this, ["pageNo"]);
			BindingUtils.bindProperty(_pagingView, "totalSize", this, ["totalSize"]);
			contentBox.addChild(_pagingView);
			
			_systemServiceDG.addEventListener(ListEvent.ITEM_CLICK, systemServiceDG_itemClick);			
			_pagingView.addEventListener(PageViewEvent.SELECTPAGE, refresh);
		}

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function execute(systemServices: Array, current: Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   SelectServiceIdDialog, true) as SelectServiceIdDialog;

			var emptySystemService: SystemService = new SystemService();
			emptySystemService.id = SystemService.EMPTY_SYSTEM_SERVICE;
			emptySystemService.name = ResourceManager.getInstance().getString("ProcessEditorETC", "emptySystemServiceText");
			emptySystemService.description = "";
			emptySystemService.wsdlUli = "";
			emptySystemService.port = "";
			emptySystemService.operation = "";
			emptySystemService.messageIn = [];
			emptySystemService.messageOut = [];			
			_dialog._systemServices.push(emptySystemService);
			for each (var systemService: SystemService in systemServices) {
				_dialog._systemServices.push(systemService);
			}

			_dialog.totalSize = _dialog._systemServices.length;
			_dialog._acceptFunc = acceptFunc;
			if(position){
				_dialog.x = position.x;
				_dialog.y = position.y;
			}else{
				PopUpManager.centerPopUp(_dialog);	
			}
	
			if(width) _dialog.width = width;
			if(height) _dialog.height = height;
	
			if(current){
				_dialog.selectedItem = current as SystemService;
				for(var i:int=0; i<_dialog.totalSize; i++)
					if(_dialog._systemServices[i].id == current.id)
						break;
				if(i<_dialog.totalSize)
					_dialog.pageNo = i/_dialog.pageSize;
			}else{
				_dialog.selectedItem = emptySystemService;
			}
			_dialog.refresh();
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		private function refresh(event:PageViewEvent=null):void{
			if (event != null)
				if (event.type == PageViewEvent.SELECTPAGE)
					pageNo = event.pageNo;
			_systemServicesPage = new Array();					
			for(var i:int=pageNo*pageSize; i<totalSize && i<(pageNo+1)*pageSize; i++){
				_systemServicesPage.push(_systemServices[i]);
				if(_systemServices[i].id == selectedItem.id){
					_systemServiceDG.selectedItem = selectedItem;
				}
			}
			_systemServiceDG.setFocus();
			_pagingView.refresh();
		}

		private function dialogClose(accept: Boolean = true): void {		
			if (accept && (_acceptFunc != null) && _systemServiceDG.selectedItem)
				_acceptFunc(_systemServiceDG.selectedItem);
		
			PopUpManager.removePopUp(this);
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		//------------------------
		// Dialog
		//------------------------

		private function dlg_close(): void {
			dialogClose(false);
		}

		private function dlg_keyDown(event:KeyboardEvent): void {
			if (event.keyCode == Keyboard.ESCAPE)
				dialogClose(false);
		}	

		//------------------------
		// systemServiceDG
		//------------------------

		private function systemServiceDG_itemClick(event:ListEvent): void {
			dialogClose(true);
		}
	}
}