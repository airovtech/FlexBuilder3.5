/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.util
 *  Class: 			FormGridLayoutToolbar
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid Layout에 관련된 기능을 제공하는 Toolbar를 다루는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.util
{
	import com.maninsoft.smart.formeditor.assets.FormEditorAssets;
	import com.maninsoft.smart.formeditor.command.AddFormGridItemCommand;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridCanvas;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.view.FormDocumentView;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.resources.ResourceManager;
	
	public class FormGridLayoutToolbar
	{
		public function FormGridLayoutToolbar(displayContainer:DisplayObjectContainer, editDomain:FormEditDomain, formGridCanvas:FormGridCanvas, formDocumentView:FormDocumentView)
		{
			this.displayContainer = displayContainer;
			this.editDomain = editDomain;
			this.formGridCanvas = formGridCanvas;
			
			this.formDocumentView = formDocumentView;
			
			createVisual();
		}
		
		private var _displayContainer:DisplayObjectContainer;
		
		public function set displayContainer(displayContainer:DisplayObjectContainer):void{
		    this._displayContainer = displayContainer;
		}
		public function get displayContainer():DisplayObjectContainer{
		    return this._displayContainer;
		}
			
		private var _editDomain:FormEditDomain;

		public function set editDomain(editDomain:FormEditDomain):void{
		    this._editDomain = editDomain;
		}
		public function get editDomain():FormEditDomain{
		    return this._editDomain;
		}
		
		private var _formGridCell:FormGridCell;

		public function set formGridCell(formGridCell:FormGridCell):void{
		    this._formGridCell = formGridCell;
		}
		public function get formGridCell():FormGridCell{
		    return this._formGridCell;
		}
		
		private var _formGridCanvas:FormGridCanvas;

		public function set formGridCanvas(formGridCanvas:FormGridCanvas):void{
		    this._formGridCanvas = formGridCanvas;
		    
		    this.formGridCanvas.addEventListener(FormEditorEvent.SELECTVIEW, selectFormGridLayout);
		}
		public function get formGridCanvas():FormGridCanvas{
		    return this._formGridCanvas;
		}	
		
		private var _formDocumentView:FormDocumentView;
		
		public function set formDocumentView(formDocumentView:FormDocumentView):void {
			this._formDocumentView = formDocumentView;
		}
		
		public function get formDocumentView():FormDocumentView {
			return this._formDocumentView;
		}
		
		public function selectFormGridLayout(event:FormEditorEvent):void{
			this.createVisual();
		}
		
//		private var layoutToolBar:HBox;
		
		private var divider:Image;
		private var mergeBtn:LinkButton;
		private var modeBtn:LinkButton;
		
		public function createVisual():void{
			if(this.mergeBtn == null) {
				this.divider = new Image();
				this.divider.source = FormEditorAssets.dividerIcon;
				this.mergeBtn = new LinkButton();
				this.mergeBtn.styleName = "formGridLayoutMerge";
				this.mergeBtn.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "cellMergeUnmergeText");
				this.mergeBtn.toggle = true;
				this.mergeBtn.addEventListener(MouseEvent.MOUSE_DOWN, clickMerge);
				this.displayContainer.addChild(this.divider);
				this.displayContainer.addChild(this.mergeBtn);
				
				this.modeBtn = new LinkButton();
				this.modeBtn.styleName = "formGridLayoutMode";
				this.modeBtn.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "cellMoveText");		
				this.modeBtn.toggle = true;
				this.modeBtn.addEventListener(MouseEvent.CLICK, clickMode);
//				this.displayContainer.addChild(this.modeBtn);
			}
			this.mergeBtn.enabled = this.formGridCanvas.getEnableMergeGridItem();	
			this.modeBtn.selected = this.formGridCanvas.mode == "gridMode";
		}
		
		public function removeVisual():void{
			if (this.displayContainer.contains(this.mergeBtn))
				this.displayContainer.removeChild(this.mergeBtn);
			if (this.displayContainer.contains(this.modeBtn))
				this.displayContainer.removeChild(this.modeBtn);						
		}

		/**
		 * 2010.3.2 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능 
 	 	 * 기존 ClickMerge Function은 하나의 Row에서 span이 1인것들만 Merge를 할 수 있도록 되어 있어서,
 	 	 * 아래는, span이 1이상인것들을 여러개의 Row에서 선택하여 Merge할 수 있도록 수정하였슴.
 	 	 * cell의 span은 column만의 span을 의미하며, 추가로 rowSpan이 있어 row span을 관리한다.
 	 	*/
		public function clickMerge(e:MouseEvent):void{
			var selItems:Array = this.formGridCanvas.getSelectChildren();
			if(selItems.length > 0){
				if(this.formGridCanvas.getEnableMergeGridItem()){
					// 첫번째 아이템을 추출하고 선택된 Row와 Comlumn 갯수를 계산한다.
					var firstItem:FormGridCell = (selItems[0] as FormGridItemView).gridCell;
					var firstItemRowIdx:int = firstItem.gridRowIndex;
					var firstItemColIdx:int = firstItem.gridColumnIndex;
					var selRows:Array = new Array(firstItem.gridRow);
					var selCols:Array = new Array(firstItem.gridColumn);
					for(var selIdx:int = 1 ; selIdx < selItems.length ; selIdx++){
						var targetFormGridItem:FormGridCell = (selItems[selIdx] as FormGridItemView).gridCell;
						
						var targetRowIdx:int = targetFormGridItem.gridRowIndex
						var targetColIdx:int = targetFormGridItem.gridColumnIndex;
						
						for(var rowIdx:int=0; rowIdx<selRows.length; rowIdx++)
							if(selRows[rowIdx] as FormGridRow == targetFormGridItem.gridRow)
								break;
						if(rowIdx==selRows.length)
							selRows.push(targetFormGridItem.gridRow)
							
						for(var colIdx:int=0; colIdx<selCols.length; colIdx++)
							if(selCols[colIdx] as FormGridColumn == targetFormGridItem.gridColumn)
								break;
						if(colIdx==selCols.length)
							selCols.push(targetFormGridItem.gridColumn);
							
						if(firstItemRowIdx >= targetRowIdx && firstItemColIdx > targetColIdx){
							firstItem = targetFormGridItem;
							firstItemRowIdx = targetRowIdx;
							firstItemColIdx = targetColIdx;
						}
					}
					
					var rowSize:int = firstItem.rowSpan*selRows.length;					
					var colSize:int = firstItem.span*selCols.length;

					var command:Command = FormGridCommandUtil.updateItemSpanCommand(firstItem, rowSize, colSize);
					editDomain.getCommandStack().execute(command);
					firstItem.select(true);
				}
			}else{
				var formDocumentView: FormDocumentView = this.formGridCanvas.formView as FormDocumentView;
				var formGridItemView: FormGridItemView = formDocumentView.selectionViewer as FormGridItemView;
				if(formGridItemView != null){
					var _firstItem:FormGridCell = formGridItemView.gridCell;
					var _firstItemRowIdx:int = _firstItem.gridRowIndex;
					var _firstItemColIdx:int = _firstItem.gridColumnIndex;
					var _firstItemCellIdx:int = _firstItem.gridRow.getCellIndex(_firstItem);
					var _rowSpan:int = _firstItem.rowSpan;
					var _colSpan:int = _firstItem.span;
					var _rowIdx:int, _colIdx:int, _cellIdx:int;
					var _newGridItem:FormGridCell;
					var _command:Command = FormGridCommandUtil.updateItemCommand(_firstItem, "span", 1);
					_command = _command.chain(FormGridCommandUtil.updateItemCommand(_firstItem, "rowSpan", 1));

					for(_cellIdx=_firstItemCellIdx+1, _colIdx=_firstItemCellIdx+1; _cellIdx<_firstItemCellIdx+_colSpan; _cellIdx++, _colIdx++){
						_newGridItem = new FormGridCell(_firstItem.gridRow, _firstItem.gridRow.gridLayout.getColumnByIndex(_colIdx));
						_command = _command.chain(new AddFormGridItemCommand(_firstItem.gridRow, _newGridItem, _cellIdx));
					}
					for(_rowIdx=_firstItemRowIdx+1; _rowIdx<_firstItemRowIdx+_rowSpan; _rowIdx++){
						var _curGridRow:FormGridRow = _firstItem.gridRow.gridLayout.getRowByIndex(_rowIdx);
						_cellIdx = FormGridUtil.getCellIndexByColumnIndex(_curGridRow, _firstItemColIdx);
						if(_cellIdx==-1){
							_cellIdx = FormGridUtil.getNoneCellIndexByColumnIndex(_curGridRow, _firstItemColIdx);
						}
						for(_colIdx=_firstItemColIdx; _colIdx<_firstItemColIdx+_colSpan; _colIdx++, _cellIdx++){
							_newGridItem = new FormGridCell(_curGridRow, _curGridRow.gridLayout.getColumnByIndex(_colIdx));
							_command = _command.chain(new AddFormGridItemCommand(_curGridRow, _newGridItem, _cellIdx));
							if(_cellIdx==-1) _cellIdx=0;
						}
					}
					editDomain.getCommandStack().execute(_command);
					_firstItem.select(true);
				}
			}
			this.formGridCanvas.unSelectChild();
		}
		
		public function clickMode(e:MouseEvent):void{
			if (this.modeBtn.selected) {
				// 이동 모드
				this.modeBtn.styleName ="formGridLayoutMode2";
				this.modeBtn.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "cellMoveText");
				this.formGridCanvas.mode = "formMode";
				this.formDocumentView.layoutView.mode = "formMode";
			} else {
				// 필드 선택 모드 
				this.modeBtn.styleName = "formGridLayoutMode";
				this.modeBtn.toolTip = ResourceManager.getInstance().getString("FormEditorETC", "fieldSelectText");
				this.formGridCanvas.mode = "gridMode";
				this.formDocumentView.layoutView.mode = "gridMode";
			}
		}
	}
}