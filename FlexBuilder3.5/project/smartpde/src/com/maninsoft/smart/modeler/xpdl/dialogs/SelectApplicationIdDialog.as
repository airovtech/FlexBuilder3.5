package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.workbench.common.event.PageViewEvent;
	import com.maninsoft.smart.workbench.common.util.PagingView;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.ScrollPolicy;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	public class SelectApplicationIdDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------

		private static var _dialog: SelectApplicationIdDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _applicationServices: Array = new Array();
		
		[Bindable]
		public var _applicationServicesPage:Array = new Array();
		private var _acceptFunc: Function;
		
		private var _applicationServiceDG:DataGrid = new DataGrid();
		private var _pagingView:PagingView = new PagingView();
		
		[Bindable]
		public var pageSize:int=5;
		[Bindable]
		public var pageNo:int=0;
		[Bindable]
		public var totalSize:int=0;
		private var selectedItem:ApplicationService;

		public function SelectApplicationIdDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "applicationIdSelectionText");
			this.showCloseButton=true;
		}
		
		override protected function childrenCreated():void{
			var nameCol:DataGridColumn = new DataGridColumn();
			nameCol.dataField="name";
			nameCol.setStyle("textAlign", "left");
			nameCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "applicationServiceNameText");
			nameCol.wordWrap=true;
			
			var descriptionCol:DataGridColumn = new DataGridColumn();
			descriptionCol.dataField="description";
			descriptionCol.setStyle("textAlign", "left");
			descriptionCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "applicationServiceDescText");
			descriptionCol.wordWrap=true;
			
			var urlCol:DataGridColumn = new DataGridColumn();
			urlCol.dataField="url";
			urlCol.setStyle("textAlign", "left");
			urlCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "applicationServiceUrlText");
			urlCol.wordWrap=true;
			
			var editMethodCol:DataGridColumn = new DataGridColumn();
			editMethodCol.dataField="editMethod";
			editMethodCol.setStyle("textAlign", "left");
			editMethodCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "applicationServiceEditMethodText");
			editMethodCol.wordWrap=true;
			
			var viewMethodCol:DataGridColumn = new DataGridColumn();
			viewMethodCol.dataField="viewMethod";
			viewMethodCol.setStyle("textAlign", "left");
			viewMethodCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "applicationServiceViewMethodText");
			viewMethodCol.wordWrap=true;
			
			_applicationServiceDG.columns = [nameCol, descriptionCol, urlCol, editMethodCol, viewMethodCol];
			_applicationServiceDG.styleName="selectSystemServiceDG"
			_applicationServiceDG.percentWidth=100;
			BindingUtils.bindProperty(_applicationServiceDG, "dataProvider", this, ["_applicationServicesPage"]);
			_applicationServiceDG.showHeaders=true;
			_applicationServiceDG.headerHeight=21;
			_applicationServiceDG.rowHeight=21;
			_applicationServiceDG.editable=false;
			_applicationServiceDG.sortableColumns=false;
			_applicationServiceDG.draggableColumns=false;
			_applicationServiceDG.resizableColumns=true;
			_applicationServiceDG.wordWrap=false;
			_applicationServiceDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_applicationServiceDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_applicationServiceDG);
			
			BindingUtils.bindProperty(_pagingView, "pageSize", this, ["pageSize"]);
			BindingUtils.bindProperty(_pagingView, "pageNo", this, ["pageNo"]);
			BindingUtils.bindProperty(_pagingView, "totalSize", this, ["totalSize"]);
			contentBox.addChild(_pagingView);
			
			_applicationServiceDG.addEventListener(ListEvent.ITEM_CLICK, applicationServiceDG_itemClick);			
			_pagingView.addEventListener(PageViewEvent.SELECTPAGE, refresh);
		}

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function execute(applicationServices: Array, current: Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   SelectApplicationIdDialog, true) as SelectApplicationIdDialog;

			var emptyApplicationService:ApplicationService = new ApplicationService();
			emptyApplicationService.id = ApplicationService.EMPTY_APPLICATION_SERVICE;
			emptyApplicationService.name = ResourceManager.getInstance().getString("ProcessEditorETC", "emptyApplicationServiceText");
			emptyApplicationService.description = "";
			emptyApplicationService.url = "";
			emptyApplicationService.editMethod = "";
			emptyApplicationService.viewMethod = "";
			emptyApplicationService.editParams = [];
			emptyApplicationService.viewParams = [];
			emptyApplicationService.returnParams = [];
			_dialog._applicationServices.push(emptyApplicationService);
			for each (var applicationService: ApplicationService in applicationServices) {
				_dialog._applicationServices.push(applicationService);
			}

			_dialog.totalSize = _dialog._applicationServices.length;
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
				_dialog.selectedItem = current as ApplicationService;
				for(var i:int=0; i<_dialog.totalSize; i++)
					if(_dialog._applicationServices[i].id == current.id)
						break;
				if(i<_dialog.totalSize)
					_dialog.pageNo = i/_dialog.pageSize;
			}else{
				_dialog.selectedItem = emptyApplicationService;
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
			_applicationServicesPage = new Array();					
			for(var i:int=pageNo*pageSize; i<totalSize && i<(pageNo+1)*pageSize; i++){
				_applicationServicesPage.push(_applicationServices[i]);
				if(_applicationServices[i].id == selectedItem.id){
					_applicationServiceDG.selectedItem = selectedItem;
				}
			}
			_applicationServiceDG.setFocus();
			_pagingView.refresh();
		}

		private function dialogClose(accept: Boolean = true): void {		
			if (accept && (_acceptFunc != null) && _applicationServiceDG.selectedItem)
				_acceptFunc(_applicationServiceDG.selectedItem);
		
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

		private function applicationServiceDG_itemClick(event:ListEvent): void {
			dialogClose(true);
		}
	}
}