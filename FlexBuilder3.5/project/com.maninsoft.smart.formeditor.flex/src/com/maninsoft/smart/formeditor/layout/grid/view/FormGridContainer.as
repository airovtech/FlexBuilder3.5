/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.view
 *  Class: 			FormGridContainer
 * 					extends Grid 
 * 					implements ISelectableContainerView
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid Container의 view에 관련된 기능을 제공하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 					2010.3.2 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.view
{
	import com.maninsoft.smart.formeditor.layout.grid.ISelectableContainerView;
	import com.maninsoft.smart.formeditor.layout.grid.control.FormGridContainerEdit;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.formeditor.view.util.CellsToolBox;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	
	public class FormGridContainer extends Grid implements ISelectableContainerView
	{
		public function FormGridContainer(container:IFormContainer, formView:IFormContainerView, editDomain:FormEditDomain)
		{
			this.styleName = "formLayoutGrid";
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
	        this.setStyle("horizontalGap", 1);
	        this.setStyle("verticalGap", 1);
	        			
			this.container = container;
			this.gridLayout = container.layout as FormGridLayout;
			
			this.formView = formView;
			this.editDomain = editDomain;
			
			registerEvent();
			
			registerViewer();
		}

		private var _container:IFormContainer;
		
		public function get container():IFormContainer{
			return _container;
		}
		public function set container(container:IFormContainer):void{
			this._container = container;
		}
		
		private var _editDomain:FormEditDomain;

		public function set editDomain(editDomain:FormEditDomain):void{
		    this._editDomain = editDomain;
		}
		public function get editDomain():FormEditDomain{
		    return this._editDomain;
		}
		
		private var _formView:IFormContainerView;

		public function set formView(formView:IFormContainerView):void{
		    this._formView = formView;
		}
		public function get formView():IFormContainerView{
		    return this._formView;
		}
		
		private var _gridLayout:FormGridLayout;

		public function set gridLayout(gridLayout:FormGridLayout):void{
		    this._gridLayout = gridLayout;
		    
			/**
			 * 2010.3.11 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능 
	 	 	 * 기존의 generateColumnInfo기능을 대신하여 FormGridUtil에 있는  createGridColumnInfo을 호출 한다.
	 	 	*/
		    FormGridUtil.createGridColumnInfo(this._gridLayout);
		    
		    if(this.formGridContainerEdit != null)
		    	this.formGridContainerEdit.formGridLayout = this.gridLayout;
		}
		public function get gridLayout():FormGridLayout{
		    return this._gridLayout;
		}
		
		private var _formGridContainerEdit:FormGridContainerEdit;

		public function set formGridContainerEdit(formGridContainerEdit:FormGridContainerEdit):void{
		    this._formGridContainerEdit = formGridContainerEdit;
		}
		public function get formGridContainerEdit():FormGridContainerEdit{
		    return this._formGridContainerEdit;
		}
		
		private var _selection:Boolean;

		public function set selection(selection:Boolean):void{
		    this._selection = selection;
		}
		public function get selection():Boolean{
		    return this._selection;
		}
		
		public function get selectableModel():ISelectableModel{
		    return this.gridLayout;
		}
		
		private function registerEvent():void{
			this.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function mouseClick(e:MouseEvent):void{
			if(e.target == this){
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
	        	event.view = this;
	        	this.dispatchEvent(event);
				trace("[Event]FormGridContainer mouseClick dispatch event : " + event);
			}
		}
		
		protected function registerViewer():void{
        	if(formGridContainerEdit == null)
        		formGridContainerEdit = new FormGridContainerEdit();
        	formGridContainerEdit.editDomain = this.editDomain;
        	formGridContainerEdit.formGridLayout = this.gridLayout;
        	formGridContainerEdit.formGridContainer = this;
        }
		public function refreshVisual():void{
			var gridLayout:FormGridLayout = this.container.layout as FormGridLayout;
	        
	        // 모델보다 많은 행의 뷰와 컨트롤 제거
	        if(this.getChildren().length > gridLayout.rowLength){
	        	var childSize:int = this.getChildren().length;
        		for(var _i:int = childSize - 1 ; _i >= gridLayout.rowLength; _i--){
        			this.removeChildAt(_i);
        		}	
        	}
        		
	        // 그리드 행 그리기
        	for(var i:int = 0 ; i < gridLayout.rowLength ; i++){
        		var gridRow:FormGridRow = gridLayout.getRowByIndex(i) as FormGridRow;
        		
        		var gridRowView:FormGridRowView;
        		// 기존에 있는 뷰와 컨트롤 재사용
        		if(this.getChildren().length > i){
        			gridRowView = (this.getChildAt(i) as FormGridRowView);
        			if(gridRowView.gridRow != gridRow){
        				gridRowView.gridRow = gridRow;
        			}
        			gridRowView.refreshVisual();
        		}else{
        			// 숫자 이상일때 생성
        			gridRowView = new FormGridRowView(gridRow, this.container, this.formView, this.editDomain);
        			gridRowView.refreshVisual();
        			
        			gridRowView.addEventListener(FormEditorEvent.SELECTVIEW, this.selectChildHandler);
        			gridRowView.addEventListener(FormEditorEvent.UNSELECTVIEW, this.unSelectChildHandler);
        			
        			this.addChild(gridRowView);
        		}
        	}
        	
        	this.formGridContainerEdit.registerColumn();
        	
        }
        
        private var _selections:ArrayCollection = new ArrayCollection();

		public function set selections(selections:ArrayCollection):void{
		    this._selections = selections;
		}
		public function get selections():ArrayCollection{
		    return this._selections;
		}
        
        public function selectChildHandler(e:FormEditorEvent):void{
        	if(this.contains(e.target as DisplayObject)){
        		var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
	        	event.view = e.view;
	        	
	        	event.x = e.target.x + e.x;
	        	event.y = e.target.y + e.y;
	        	
	        	this.dispatchEvent(event);
				trace("[Event]FormGridContainer selectChildHandler dispatch event : " + event);
        	} 
        }
        
        public function unSelectChildHandler(e:FormEditorEvent):void{
        	if(this.contains(e.target as DisplayObject)){
        		var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
	        	event.view = e.view;
	        	
	        	event.x = e.target.x + e.x;
	        	event.y = e.target.y + e.y;
	        	
	        	this.dispatchEvent(event);
				trace("[Event]FormGridContainer unSelectChildHandler dispatch event : " + event);
        	} 
        }
        
        public function selectChildByBound(bound:Rectangle):void {
        	// 한 줄만 선택되게 허용
        	var selectedRow:FormGridRowView = null;
			for each (var gridRow:FormGridRowView in this.getChildren()) {
				if (selectedRow == null && bound.intersects(new Rectangle(gridRow.x, gridRow.y, gridRow.width, gridRow.height))) {
					var inertsectRect:Rectangle = bound.intersection(new Rectangle(gridRow.x, gridRow.y, gridRow.width, gridRow.height));
					inertsectRect.x = inertsectRect.x - gridRow.x;
					inertsectRect.y = inertsectRect.y - gridRow.y;
					gridRow.selectChildByBound(inertsectRect);
					selectedRow = gridRow;
				} else {
					gridRow.unSelectChild();
				}
				
				if (selectedRow != null) {
					var toolBoxPoint:Point = null;
					for each (var item:FormGridItemView in selectedRow.getChildren()) {
						if (!item.selection)
							continue;
						var point:Point = selectedRow.localToGlobal(new Point(item.x, item.y));
						if (toolBoxPoint == null || toolBoxPoint.x > point.x)
							toolBoxPoint = point;
					}
					selectedRow = null;
				}
			}
		}
		
		public function unSelectChild():void {
			CellsToolBox.hide();
			for each(var gridRow:FormGridRowView in this.getChildren()){
				gridRow.unSelectChild();
			}
		}

		public function select():void{
			var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
        	event.view = this;
        	this.dispatchEvent(event);
			trace("[Event]FormGridContainer select dispatch event : " + event);
		}
		
		public function unSelect():void{
			var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
        	event.view = this;
        	this.dispatchEvent(event);
			trace("[Event]FormGridContainer unSelect dispatch event : " + event);
		}
		
		public function getSelectChildren():Array{
			var selectChildren:Array = new Array();
			
			var itemChildren:Array = this.getChildren();
			for(var i:int = 0 ; i < itemChildren.length ; i++){
				var rowViewer:FormGridRowView = (itemChildren[i] as FormGridRowView);
				var rowItemChildren:Array = rowViewer.getSelectChildren();
				for(var j:int = 0 ; j < rowItemChildren.length ; j++){
					selectChildren.push(rowItemChildren[j]);
				}
			}
			
			return selectChildren;
		}

		/**
		 * 2010.3.2 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 * 기존의  getEnableMergeGridItem function은, row가 하나보다 크거나, span이 하나보다 크면 false를 return하는데,
		 * 아래에 있는 function은, span이 같은 모든 cell은 병합할 수 있도록  true를 return함.
 	 	*/
		public function getEnableMergeGridItem():Boolean{
			var rowSpan:int = -1;
			var colSpan:int = -1;
			var selCount:int = 0;
			var itemChildren:Array = this.getChildren();
			for each (var rowViewer:FormGridRowView in  itemChildren) {
				var rowItemChildren:Array = rowViewer.getSelectChildren();
				if(rowItemChildren.length > 0){
					for each (var itemView:FormGridItemView in rowItemChildren){
						if(rowSpan == -1)
							rowSpan = itemView.gridCell.rowSpan;
						else if( rowSpan != itemView.gridCell.rowSpan)
							return false;
						if(colSpan == -1)
							colSpan = itemView.gridCell.span;
						else if( colSpan != itemView.gridCell.span)
							return false;
						selCount++;
					}
				}
			}
			if(selCount>1)
				return true;
			return false;
		}
	}
}