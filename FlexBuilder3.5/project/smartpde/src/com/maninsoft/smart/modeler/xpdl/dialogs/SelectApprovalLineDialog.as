package com.maninsoft.smart.modeler.xpdl.dialogs
{
	import com.maninsoft.smart.common.dialog.AbstractDialog;
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
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

	public class SelectApprovalLineDialog extends AbstractDialog
	{

		//----------------------------------------------------------------------
		// Class Variables
		//----------------------------------------------------------------------

		private static var _dialog: SelectApprovalLineDialog;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _approvalLines: Array = new Array();
		
		[Bindable]
		public var _approvalLinesPage:Array = new Array();
		private var _acceptFunc: Function;
		
		private var _approvalLineDG:DataGrid = new DataGrid();
		private var _pagingView:PagingView = new PagingView();
		
		[Bindable]
		public var pageSize:int=5;
		[Bindable]
		public var pageNo:int=0;
		[Bindable]
		public var totalSize:int=0;
		private var selectedItem:ApprovalLine;

		public function SelectApprovalLineDialog()
		{
			super();
			this.title = resourceManager.getString("ProcessEditorETC", "approvalLineSelectionText");
			this.showCloseButton=true;
		}
		
		override protected function childrenCreated():void{
			var nameCol:DataGridColumn = new DataGridColumn();
			nameCol.dataField="name";
			nameCol.setStyle("textAlign", "left");
			nameCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "approvalLineNameText");
			nameCol.wordWrap=true;
			
			var descriptionCol:DataGridColumn = new DataGridColumn();
			descriptionCol.dataField="description";
			descriptionCol.setStyle("textAlign", "left");
			descriptionCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "approvalLineDescText");
			descriptionCol.wordWrap=true;
			
			var approvalLevelCol:DataGridColumn = new DataGridColumn();
			approvalLevelCol.width=50;
			approvalLevelCol.dataField="approvalLevel";
			approvalLevelCol.setStyle("textAlign", "left");
			approvalLevelCol.headerText=ResourceManager.getInstance().getString("ProcessEditorETC", "approvalLineLevelText");
			approvalLevelCol.wordWrap=true;
			
			_approvalLineDG.columns = [nameCol, descriptionCol, approvalLevelCol];
			_approvalLineDG.styleName="selectApprovalLineDG"
			_approvalLineDG.percentWidth=100;
			BindingUtils.bindProperty(_approvalLineDG, "dataProvider", this, ["_approvalLinesPage"]);
			_approvalLineDG.showHeaders=true;
			_approvalLineDG.headerHeight=21;
			_approvalLineDG.rowHeight=21;
			_approvalLineDG.editable=false;
			_approvalLineDG.sortableColumns=false;
			_approvalLineDG.draggableColumns=false;
			_approvalLineDG.resizableColumns=true;
			_approvalLineDG.wordWrap=false;
			_approvalLineDG.verticalScrollPolicy = ScrollPolicy.AUTO;
			_approvalLineDG.horizontalScrollPolicy = ScrollPolicy.OFF;
			contentBox.addChild(_approvalLineDG);
			
			BindingUtils.bindProperty(_pagingView, "pageSize", this, ["pageSize"]);
			BindingUtils.bindProperty(_pagingView, "pageNo", this, ["pageNo"]);
			BindingUtils.bindProperty(_pagingView, "totalSize", this, ["totalSize"]);
			contentBox.addChild(_pagingView);
			
			_approvalLineDG.addEventListener(ListEvent.ITEM_CLICK, approvalLineDG_itemClick);			
			_pagingView.addEventListener(PageViewEvent.SELECTPAGE, refresh);
		}

		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function execute(approvalLines: Array, current: Object, acceptFunc: Function, position:Point=null, width:Number=0, height:Number=0): void {
			_dialog = PopUpManager.createPopUp(Application.application as DisplayObject, 
	                                   SelectApprovalLineDialog, true) as SelectApprovalLineDialog;

			var emptyApproval:ApprovalLine = new ApprovalLine();
			emptyApproval.id = ApprovalLine.EMPTY_APPROVAL;
			emptyApproval.name = ResourceManager.getInstance().getString("ProcessEditorETC", "emptyApprovalText");
			emptyApproval.description = "";
			emptyApproval.approvalLevel = "";
			_dialog._approvalLines.push(emptyApproval);
			for each (var approvalLine:ApprovalLine in approvalLines) {
				_dialog._approvalLines.push(approvalLine);
			}

			_dialog.totalSize = _dialog._approvalLines.length;
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
				_dialog.selectedItem = current as ApprovalLine;
				for(var i:int=0; i<_dialog.totalSize; i++)
					if(_dialog._approvalLines[i].id == current.id)
						break;
				if(i<_dialog.totalSize)
					_dialog.pageNo = i/_dialog.pageSize;
			}else{
				_dialog.selectedItem = emptyApproval;
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
			_approvalLinesPage = new Array();					
//			if(_approvalLinesPage.length)
//				_approvalLinesPage.splice(0, _approvalLinesPage.length);
			for(var i:int=pageNo*pageSize; i<totalSize && i<(pageNo+1)*pageSize; i++){
				_approvalLinesPage.push(_approvalLines[i]);
				if(_approvalLines[i].id == selectedItem.id){
					_approvalLineDG.selectedItem = selectedItem;
				}
			}
			_approvalLineDG.setFocus();
			_pagingView.refresh();
		}

		private function dialogClose(accept: Boolean = true): void {		
			if (accept && (_acceptFunc != null) && _approvalLineDG.selectedItem)
				_acceptFunc(_approvalLineDG.selectedItem);
		
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
		// approvalLineDG
		//------------------------

		private function approvalLineDG_itemClick(event:ListEvent): void {
			dialogClose(true);
		}
	}
}