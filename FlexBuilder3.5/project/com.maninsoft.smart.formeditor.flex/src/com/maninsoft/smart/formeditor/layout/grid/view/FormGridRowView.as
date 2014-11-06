/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.view
 *  Class: 			FormGridRowView
 * 					extends GridRow 
 * 					implements ISelectableContainerView
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid Row의 view에 관련된 기능을 제공하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 					2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.view
{
	import com.maninsoft.smart.formeditor.layout.grid.ISelectableContainerView;
	import com.maninsoft.smart.formeditor.layout.grid.control.FormGridRowEdit;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.formeditor.view.format.TableView;
	import com.maninsoft.smart.workbench.common.property.page.PropertyPage;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.containers.GridRow;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DragEvent;
	
	public class FormGridRowView extends GridRow implements ISelectableContainerView
	{
		public function FormGridRowView(gridRow:FormGridRow, container:IFormContainer, formView:IFormContainerView, editDomain:FormEditDomain)
		{
			this.styleName = "formLayoutGridRow";
			
			this.gridRow = gridRow;
			this.container = container;
			this.formView = formView;
			this.editDomain = editDomain;

			registerViewer();
			
			registerEvent();
		}

		private var _gridRow:FormGridRow;

		public function set gridRow(gridRow:FormGridRow):void{
		    this._gridRow = gridRow;
		    
		    if(this.formGridRowEdit != null)
		   	 this.formGridRowEdit.formGridRow = this.gridRow;
		}
		public function get gridRow():FormGridRow{
		    return this._gridRow;
		}
		
		private var _container:IFormContainer;
		
		public function get container():IFormContainer{
			return _container;
		}
		public function set container(container:IFormContainer):void{
			this._container = container;
		}

		private var _formView:IFormContainerView;

		public function set formView(formView:IFormContainerView):void{
		    this._formView = formView;
		}
		public function get formView():IFormContainerView{
		    return this._formView;
		}
		
		private var _editDomain:FormEditDomain;

		public function set editDomain(editDomain:FormEditDomain):void{
		    this._editDomain = editDomain;
		}
		public function get editDomain():FormEditDomain{
		    return this._editDomain;
		}
		
		private var _selection:Boolean;

		public function set selection(selection:Boolean):void{
		    this._selection = selection;
		}
		public function get selection():Boolean{
		    return this._selection;
		}

		public function get selectableModel():ISelectableModel{
		    return this.gridRow;
		}
		
		private function registerEvent():void{
			this.addEventListener(MouseEvent.CLICK, mouseClick);
			/**
		 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
		 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
		 	 */
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(DragEvent.DRAG_ENTER, dragEnter);	
			this.addEventListener(DragEvent.DRAG_OVER, dragOver);	
			this.addEventListener(DragEvent.DRAG_EXIT, dragExit);	
			this.addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}

		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		public function dragEnter(e:DragEvent):void{

			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEvent(e);
	   			if(gridItemView && gridItemView.gridCell.fieldId==null){
   					gridItemView.dragEnter(e);
	   			}
	  		}			
		}
		
		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		public function dragOver(e:DragEvent):void{
			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEvent(e);
	   			if(gridItemView && gridItemView.gridCell.fieldId==null){
	   				gridItemView.dragOver(e);
	   			}
	  		}			
		}
		
		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		public function dragExit(e:DragEvent):void{
			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEvent(e);
	   			if(gridItemView && gridItemView.gridCell.fieldId==null){
	   				gridItemView.dragExit(e);
	   			}
	  		}			
		}
		
		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		public function dragDrop(e:DragEvent):void{
			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEvent(e);
	   			if(gridItemView && gridItemView.gridCell.fieldId==null){
	   				gridItemView.dragDrop(e);
	   			}
	  		}			
		}
		
		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		public function mouseClick(e:MouseEvent):void{
			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEvent(e);
	   			if(gridItemView && gridItemView.formView.layoutView.mode == "gridMode"){
	   				gridItemView.mouseDownEvent=null;
	   				gridItemView.select();
	   			}
	   			
				/**
			 	 * 	2010.3.8 Modified by Y.S. Jung
			 	 * 	GridRow를 직접 click하여 선택하는 경우가 없어 이벤트가 필요없어서 코멘트아웃 하였음.
			 	 */
				//var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
	        	//event.view = this;
	        	//this.dispatchEvent(event);
	        	
   				if(gridItemView && (gridItemView.parent != this) && gridItemView.fieldView){
   					gridItemView.fieldView.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	   			}
			}
		}

		/**
	 	 * 	2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
	 	 * 	row병합기능이 추가되면서, row병합된 cell의 밑에 있는 row들의 cell들은 마우스이벤트가 발생하지 않고 해당 row에 발생하여,
	 	 * 	MOUSE_DOWN, DRAG_ENTER, DRAG_OVER, DRAG_EXIT, DRAG_DROP의 이벤트를 받아서, 해당되는 셀을 선택하는 것과 같이 수행되로록 한다.  
	 	 */
		private function mouseDown(e:MouseEvent):void {
			if(e.target == this){
	   			var gridItemView:FormGridItemView = this.getGridItemViewByMouseEventOnLabel(e);
	   			if(gridItemView){
	   				gridItemView.mouseDown(e);
	   			}
			}
		}
		
		/**
		 *  2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 * 	여러개의 row가 병합되어있을 경우, 병합된 Cell의 처음 row에서 해당 cell을 클릭하면 해당 cell을 선택할 수 있는데,
		 * 	아래 row들에서 선택을 하면 cell은 선택이 안되고, 아래 row만 선택이 된다.
		 * 	그래서, 아래와 같이, 아래row들에서 선택을 하면 병합된 cell이 선택되게 구현 하였다. 
		 */
		private function getGridItemViewByMouseEvent(e:MouseEvent):FormGridItemView{
			var targetRowIdx:int = this.gridRow.gridLayout.getRowIndex(this.gridRow);
			var lastPos:Number = 0;
			for(var colIdx:int=0; colIdx<this.gridRow.gridLayout.columnLength; colIdx++){
				if(e.localX>lastPos && e.localX<lastPos+this.gridRow.gridLayout.getColumnByIndex(colIdx).size){
					break;
				}
				lastPos += this.gridRow.gridLayout.getColumnByIndex(colIdx).size+1;
			}
			if(colIdx==this.gridRow.gridLayout.columnLength || FormGridUtil.getNoneCellIndexByColumnIndex(this.gridRow, colIdx)==-1) return null;
			
			var curGridRow:FormGridRow;
			var cellIdx:int;
			for(var rowIdx:int = targetRowIdx-1; rowIdx>=0; rowIdx--){
				curGridRow = this.gridRow.gridLayout.getRowByIndex(rowIdx);
				cellIdx = FormGridUtil.getCellIndexByColumnIndex(curGridRow, colIdx);
				if(cellIdx!=-1) break;
				cellIdx = FormGridUtil.getCellIndexByColumnIndexInSpan(curGridRow, colIdx);
				if(cellIdx!=-1) break;
			}
				
			if(rowIdx>=0){
				colIdx = curGridRow.getCellByIndex(cellIdx).gridColumnIndex;
        		var gridItemView:FormGridItemView = FormGridUtil.getFormGridItemViewByRowColIndex(this.parent as FormGridContainer, rowIdx, colIdx);
        		if(gridItemView && gridItemView.fieldView && gridItemView.fieldView.model.format.type == "dataGrid"){
        			var tableView:TableView = gridItemView.fieldView.formatView as TableView;
        			var tableColumns:Array = tableView.table.columns;
        			tableView.isDataGridSelected = false;
        			tableView.release();
        			if(tableColumns){
        				var colWidth:int = 0;
						for(var tcol:int=0; tcol<tableColumns.length; tcol++){
							var tableColumn:DataGridColumn = tableColumns[tcol] as DataGridColumn;
							if(e.localX>=colWidth && e.localX<=colWidth+tableColumn.width){
								tableView.fieldView.dataGridSelectFormEntity = FormEntity(tableView.fieldModel.children.getItemAt(tcol));
								tableView.isDataGridSelected = true;
								tableColumn.setStyle("headerStyleName", "myHeaderSelectStyles");									
								break;
							}
							colWidth = colWidth+tableColumn.width;
						}
        			}
        		}
        		return gridItemView;
   			}
   			return null;
		}

		/**
		 *  2010.3.8 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 * 	여러개의 row가 병합되어있을 경우, 병합된 Cell의 처음 row에서 해당 cell을 클릭하면 해당 cell을 선택할 수 있는데,
		 * 	아래 row들에서 선택을 하면 cell은 선택이 안되고, 아래 row만 선택이 된다.
		 * 	그래서, 아래와 같이, 아래row들에서 선택을 하면 병합된 cell이 선택되게 구현 하였다.
		 * 	본 기능은, GridItemView의 label부분을 선택했을경우만 해당된다. 
		 */
		private function getGridItemViewByMouseEventOnLabel(e:MouseEvent):FormGridItemView{
			var gridItemView:FormGridItemView = getGridItemViewByMouseEvent(e);
			if(gridItemView){
				var CellPos:Number = 0;
				for(var colIdx:int=0; colIdx<gridItemView.gridCell.gridColumnIndex; colIdx++){
					CellPos += gridItemView.gridCell.gridRow.gridLayout.getColumnByIndex(colIdx).size+1;
				}
				if(e.localX>CellPos && e.localX<CellPos+gridItemView.gridCell.gridColumn.labelSize){
					return gridItemView;
				}
			}
			return null;
		}
		
		private var formGridRowEdit:FormGridRowEdit;
		
		protected function registerViewer():void{
        	if(formGridRowEdit == null)
        		formGridRowEdit = new FormGridRowEdit();
        	formGridRowEdit.editDomain = this.editDomain;
        	formGridRowEdit.formGridRow = this.gridRow;
        	formGridRowEdit.formGridRowView = this;
        }
        
		public function refreshVisual():void
		{
			this.height = gridRow.size;
        	
        	// 모델보다 많은 컬럼의 뷰와 컨트롤 제거
	        if(this.getChildren().length > gridRow.length){
	        	var childSize:int = this.getChildren().length;
        		for(var i:int = childSize - 1 ; i >= gridRow.length ; i--){
        			this.removeChildAt(i);
        		}	
        	}
        	
    	    for(var j:int = 0 ; j < gridRow.length ; j++){
    			var gridCell:FormGridCell = gridRow.getCellByIndex(j) as FormGridCell;
    			
    			var gridItemView:FormGridItemView;
    			// 기존 컬럼의 뷰어와 컨트롤 재사용
    			if(this.getChildren().length > j){
    				gridItemView = this.getChildAt(j) as FormGridItemView;
    				// 모델까지 같지 않을 경우만 모델을 설정하고 다시 그려줌
    				if(gridItemView.gridCell != gridCell){
    					gridItemView.gridCell = gridCell;
    				}
    				gridItemView.refreshVisual();
    			}else{
    				gridItemView = new FormGridItemView(gridCell, this.container, this.formView, this.editDomain);
    				gridItemView.refreshVisual();
    				
    				gridItemView.addEventListener(FormEditorEvent.SELECTVIEW, this.selectChildHandler);
    				gridItemView.addEventListener(FormEditorEvent.UNSELECTVIEW, this.unSelectChildHandler);
    				
    				this.addChild(gridItemView);
    			}	
    		}	
    		
			this.invalidateDisplayList();
		}
		
	    public function selectChildHandler(e:FormEditorEvent):void{
	    	if(this.contains(e.target as DisplayObject)){
	    		var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
	        	event.view = e.view;
	        	
	        	event.x = e.target.x + e.x;
	        	event.y = e.target.y + e.y;
	        	
	        	this.dispatchEvent(event);
				trace("[Event]FormGridRowView selectChildHandler dispatch event : " + event);
	    	}
        }
        
        public function unSelectChildHandler(e:FormEditorEvent):void{
	    	if(this.contains(e.target as DisplayObject)){
	    		var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
	        	event.view = e.view;
	        	
	        	event.x = e.target.x + e.x;
	        	event.y = e.target.y + e.y;
	        	
	        	this.dispatchEvent(event);
				trace("[Event]FormGridRowView unSelectChildHandler dispatch event : " + event);
	    	}
        }
        
        public function selectChildByBound(bound:Rectangle):void{
			for each(var gridItem:FormGridItemView in this.getChildren()){
				gridItem.selection = bound.intersects(new Rectangle(gridItem.x, gridItem.y, gridItem.width, gridItem.height));
			}
		}
		
		public function unSelectChild():void{
			for each(var gridItem:FormGridItemView in this.getChildren()){
				gridItem.selection = false;
			}
		}
		
		public function getSelectChildren():Array{
			var selectChildren:Array = new Array();
			
			var itemChildren:Array = this.getChildren();
			for(var i:int = 0 ; i < itemChildren.length ; i++){
				if((itemChildren[i] as FormGridItemView).selection){
					selectChildren.push(itemChildren[i]);
				}
			}			
			return selectChildren;
		}
        
 	}
}