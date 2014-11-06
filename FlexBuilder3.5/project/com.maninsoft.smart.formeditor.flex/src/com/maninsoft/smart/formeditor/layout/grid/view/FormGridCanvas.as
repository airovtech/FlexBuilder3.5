/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.view
 *  Class: 			FormGridCanvas
 * 					extends Canvas 
 * 					implements IFormContainerLayoutView
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid Canvas의 view에 관련된 기능을 제공하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.view
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.controller.GraphicalController;
	import com.maninsoft.smart.formeditor.layout.IFormContainerLayoutView;
	import com.maninsoft.smart.formeditor.layout.grid.FormGridInitDialog;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridCommandUtil;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridItemToolBox;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridLayoutToolbar;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.managers.PopUpManager;
	
	public class FormGridCanvas extends Canvas implements IFormContainerLayoutView
	{
		public function FormGridCanvas(container:IFormContainer, formView:IFormContainerView, editDomain:FormEditDomain)
		{
			this.container = container;
			this.formView = formView;
			this.editDomain = editDomain;			
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";
			
			this.gridLayout = this.container.layout as FormGridLayout;
			
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
		}
		public function get gridLayout():FormGridLayout{
			return this._gridLayout;
		}
		
		private var _selection:Boolean;

		public function set selection(selection:Boolean):void{
			this._selection = selection;
		}
		public function get selection():Boolean{
			return this._selection;
		}
		
		private var _mode:String = "gridMode";

		public function set mode(mode:String):void{
			this._mode = mode;
		}
		public function get mode():String{
			return this._mode;
		}
		
		private var _formGridLayoutToolBar:FormGridLayoutToolbar;

		public function set formGridLayoutToolBar(formGridLayoutToolBar:FormGridLayoutToolbar):void{
			this._formGridLayoutToolBar = formGridLayoutToolBar;
		}
		public function get formGridLayoutToolBar():FormGridLayoutToolbar{
			return this._formGridLayoutToolBar;
		}
		
		public function get selectableModel():ISelectableModel{
			return this.gridLayout;
		}
		
		private function registerEvent():void{
			this.addEventListener(MouseEvent.CLICK, mouseClick);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
			this.addEventListener(FormEditorEvent.SELECTVIEW, selectHandler);
			this.addEventListener(FormEditorEvent.UNSELECTVIEW, unSelectHandler);
			
		}
		
		private var controller:GraphicalController;
		
		protected function registerViewer():void{
			if(controller == null)
				controller = new GraphicalController();
			controller.model = this.gridLayout;
			controller.view = this;
		}
		
		public var grid:FormGridContainer;
		private var initLabel:Label;
		
		public function refreshVisual():void{
			if(this.gridLayout != null && this.gridLayout.rowLength > 0 && this.gridLayout.columnLength > 0){
				if(this.initLabel != null){
					this.removeChild(this.initLabel);
					this.initLabel = null;
				}
				if(this.grid == null){
					this.grid = new FormGridContainer(this.container, this.formView, this.editDomain);
					this.grid.x = 0;
					this.grid.y = 0;
					
					this.grid.addEventListener(FormEditorEvent.SELECTVIEW, this.selectChildHandler);
					this.grid.addEventListener(FormEditorEvent.UNSELECTVIEW, this.unSelectChildHandler);
					
					this.addChild(this.grid);
				}
				
				this.grid.refreshVisual();
			}else if(this.initLabel == null){
				this.initLabel = new Label();
				this.initLabel.styleName = 'gridInitLabel';
				this.initLabel.text = resourceManager.getString("FormEditorMessages", "FEI001");
				this.initLabel.x = (this.width - initLabel.text.length*12) / 2;
				this.initLabel.y = (this.height - 100) / 2;
				this.addChild(initLabel);					

				if(this.gridLayout != null){
					if(this.gridLayout.rowLength > 0)
						this.gridLayout.removeAllRow();	
					
					if(this.gridLayout.columnLength > 0)
						this.gridLayout.removeAllColumn();
				}				
			}
		}
		
		override public function set height(value:Number):void {
			super.height = value + 150;
		}
		
		public function selectChildHandler(e:FormEditorEvent):void{
			if(this.contains(e.target as DisplayObject)){
				this.unSelectChild();
				
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
				event.view = e.view;
				
				event.x = e.target.x + e.x;
				event.y = e.target.y + e.y;

				this.dispatchEvent(event);
				trace("[Event]FormGridCanvas selectChildHandler dispatch event : " + event);
			}
		}
 
 		public function unSelectChildHandler(e:FormEditorEvent):void{
			if(this.contains(e.target as DisplayObject)){
				this.unSelectChild();
				
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
				event.view = e.view;
				
				event.x = e.target.x + e.x;
				event.y = e.target.y + e.y;

				this.dispatchEvent(event);
				trace("[Event]FormGridCanvas unSelectChildHandler dispatch event : " + event);
			}
		}
		
		public function selectHandler(event:FormEditorEvent):void{
			refreshToolBox(event);
		}
		
		public function unSelectHandler(event:FormEditorEvent):void{
			refreshToolBox(event);
		}
		
		private function refreshToolBox(e:FormEditorEvent):void{
			if(e.view is FormGridItemView){
				if(e.type == FormEditorEvent.SELECTVIEW && this.parent != null)
					FormGridItemToolBox.createToolBox(e.view as FormGridItemView, this.parent, this.x + e.x, this.y + e.y, this.editDomain);
				else
					FormGridItemToolBox.removeToolBox();
			}else if(e.view is FormGridRowView && (e.view as FormGridRowView).gridRow.size <= 1){
				var formGridRowView:FormGridRowView = e.view as FormGridRowView;
				if(formGridRowView.getChildren().length > 0){
					if(e.type == FormEditorEvent.SELECTVIEW)
						FormGridItemToolBox.createToolBox(formGridRowView.getChildAt(0) as FormGridItemView, this.parent, this.x + e.x, this.y + e.y, this.editDomain);
					else
						FormGridItemToolBox.removeToolBox();
				}else{
					FormGridItemToolBox.removeToolBox();
				}
			}else{
				FormGridItemToolBox.removeToolBox();
			}
		}
				
		private function mouseClick(e:MouseEvent):void {
			if(this.container.layout != null){
				initGrid();
			}else{
				if(e.target == this){
					var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
					event.view = this;
					this.dispatchEvent(event);
					trace("[Event]FormGridCanvas mouseClick dispatch event : " + event);
				}
			}
		}
		
	   	private var gridInitWin:FormGridInitDialog;
		
		public function initGrid():void{
			var layOut:FormGridLayout = this.container.layout as FormGridLayout;
				// layout에  row가 없으면 그리드 초기화
			if(layOut.rowLength == 0){
				gridInitWin = PopUpManager.createPopUp( this, FormGridInitDialog, true) as FormGridInitDialog;
				gridInitWin.addEventListener(Event.COMPLETE, initGridResult);
	
				PopUpManager.centerPopUp(gridInitWin);
			}
			
		}
		
		private function initGridResult(e:Event):void{
			var rowSize:int = gridInitWin.rowInput.value;
			var colSize:int = gridInitWin.colInput.value;
			
			createInitGrid(rowSize, colSize);
		}
		
		private function createInitGrid(rowSize:int, colSize:int):void{
			
			var colWidth:Number = (this.width - (1 * (colSize + 1))) / colSize;
			
			for(var i :int = 0 ; i < colSize ;i++){
				var gridCol:FormGridColumn = new FormGridColumn(this.gridLayout);
				if(colWidth > Config.DEFAULT_LABEL_WIDTH){
					gridCol.labelSize = Config.DEFAULT_LABEL_WIDTH;
				}else{
					gridCol.labelSize = colWidth;
				}
				gridCol.size = colWidth;
				this.gridLayout.addColumn(gridCol);
			}
			
			var command:Command;
			
			for(var _i:int = 0 ; _i < rowSize ; _i++){
				var gridRow:FormGridRow = new FormGridRow(this.gridLayout);
				gridRow.size = Config.DEFAULT_ROW_HEIGHT;
				
				for(var j:int = 0 ; j < colSize ; j++){
					/**
					 * 2010.3.11 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능 
			 	 	 * FormGridCell생성시 해당 Cell이 속해있는 GridColumn정보를 입력한다.
			 	 	*/
					var gridItem:FormGridCell = new FormGridCell(gridRow, gridRow.gridLayout.getColumnByIndex(j));
					gridItem.size = colWidth;
					
					gridRow.addCell(gridItem);
				}
				
				if(command == null){
					command = FormGridCommandUtil.addRowItemCommand(this.gridLayout, gridRow, -1);
				}else{
					command = command.chain(FormGridCommandUtil.addRowItemCommand(this.gridLayout, gridRow, -1));
				}
			}
			
			this.editDomain.getCommandStack().execute(command);
			
			if(this.initLabel!=null && this.contains(this.initLabel)){
				this.removeChild(this.initLabel);
				this.initLabel=null;
			}	
			this.invalidateDisplayList();
		}
		
		private var initPoint:Point;
		
		public function mouseDown(e:MouseEvent):void{
			
			if (this.mode == "gridMode") {
				this.initPoint = this.globalToLocal(new Point(e.stageX, e.stageY));
			}
		}
		
		private var currentPoint:Point;
		
		public function mouseMove(e:MouseEvent):void{
			if(initPoint != null){
				this.currentPoint = this.globalToLocal(new Point(e.stageX, e.stageY));
				// this.currentPoint = new Point(e.localX, e.localY);
				
				refreshSelectLine();
				this.selectChildByBound(new Rectangle(  (this.initPoint.x > this.currentPoint.x)?this.currentPoint.x:this.initPoint.x, 
														(this.initPoint.y > this.currentPoint.y)?this.currentPoint.y:this.initPoint.y,
														Math.abs(this.currentPoint.x - this.initPoint.x), 
														Math.abs(this.currentPoint.y - this.initPoint.y)));
				
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
				event.view = this;
				dispatchEvent(event);
				trace("[Event]FormGridCanvas mouseMove dispatch event : " + event);
			}			
		}
				
		public function mouseUp(e:MouseEvent):void{
			clearSelectLine();			
		}

		public function mouseOut(e:MouseEvent):void{
			clearSelectLine();
		}
				
		private function clearSelectLine():void{
			this.initPoint = null;
			this.currentPoint = null;
			
			refreshSelectLine();
		}
		
		private var selectLine:Canvas;
		
		private function refreshSelectLine():void{
			if(this.selectLine == null){
				this.selectLine = new Canvas();
				this.addChild(this.selectLine);
			}
			
			this.selectLine.graphics.clear();
			
			if(this.initPoint != null && this.currentPoint != null){
				this.selectLine.graphics.lineStyle(1, 0x000000, 0.5, false);
				
				// -
				this.selectLine.graphics.moveTo(initPoint.x, initPoint.y);
				this.selectLine.graphics.lineTo(currentPoint.x, initPoint.y);
				this.selectLine.graphics.lineTo(currentPoint.x, currentPoint.y);
				// |
				this.selectLine.graphics.moveTo(initPoint.x, initPoint.y);
				this.selectLine.graphics.lineTo(initPoint.x, currentPoint.y);
				this.selectLine.graphics.lineTo(currentPoint.x, currentPoint.y);
			}

		}
		
		public function selectChildByBound(bound:Rectangle):void {
			if (bound.intersects(new Rectangle(this.grid.x, this.grid.y, this.grid.width, this.grid.height))) {
				var inertsectRect:Rectangle = bound.intersection(new Rectangle(this.grid.x, this.grid.y, this.grid.width, this.grid.height));
				inertsectRect.x = inertsectRect.x - this.grid.x;
				inertsectRect.y = inertsectRect.y - this.grid.y;
				this.grid.selectChildByBound(inertsectRect);
			}else{
				this.grid.unSelectChild();
			}
		}
		
		public function unSelectChild():void{
			this.grid.unSelectChild();
		}
		
		public function getSelectChildren():Array{
			return this.grid.getSelectChildren();
		}
		
		public function getEnableMergeGridItem():Boolean{
			return this.grid.getEnableMergeGridItem();
		}
	}
}