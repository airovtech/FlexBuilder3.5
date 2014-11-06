/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.view
 *  Class: 			FormGridItemView
 * 					extends GridItem 
 * 					implements ISelectableView
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid Container의 view에 관련된 기능을 제공하는 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.2.26 Modified by Y.S. Jung for 스펠링수정 *childern* --> *children*
 * 					2010.3.7 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.view
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.command.CreateFormFieldCommand;
	import com.maninsoft.smart.formeditor.layout.grid.control.FormGridItemEdit;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridCommandUtil;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormItemCommandUtil;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormModelUtil;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	import com.maninsoft.smart.formeditor.util.FormatButton;
	import com.maninsoft.smart.formeditor.view.FieldView;
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.formeditor.view.ISelectableView;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.containers.GridItem;
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.events.DividerEvent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	public class FormGridItemView extends GridItem implements ISelectableView
	{
		public function FormGridItemView(gridCell:FormGridCell, container:IFormContainer, formView:IFormContainerView, editDomain:FormEditDomain)
		{
			this.styleName = "formLayoutGridItem";
			
			this.gridCell = gridCell;
			this.container = container;
			this.formView = formView;
			this.editDomain = editDomain;
			
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";
			
			this.setStyle("paddingLeft", Config.DEFAULT_PADDING_SIZE);
			this.setStyle("paddingRight", Config.DEFAULT_PADDING_SIZE);
			this.setStyle("paddingTop", Config.DEFAULT_PADDING_SIZE);
			this.setStyle("paddingBottom", Config.DEFAULT_PADDING_SIZE);
			
			this.registerViewer();
			
			this.registerEvent();
		}
		
		private var _gridCell:FormGridCell;
		private var _container:IFormContainer;
		private var _formView:IFormContainerView;
		private var _editDomain:FormEditDomain;
		private var _selection:Boolean;

		public function set gridCell(gridCell:FormGridCell):void{
			this._gridCell = gridCell;
			
			if(this.formGridItemEdit != null)
				this.formGridItemEdit.formGridCell = this.gridCell;
		}
		public function get gridCell():FormGridCell{
			return this._gridCell;
		}
		
		public function get container():IFormContainer{
			return _container;
		}
		public function set container(container:IFormContainer):void{
			this._container = container;
		}

		public function set formView(formView:IFormContainerView):void{
			this._formView = formView;
		}
		public function get formView():IFormContainerView{
			return this._formView;
		}
		
		public function set editDomain(editDomain:FormEditDomain):void{
			this._editDomain = editDomain;
		}
		public function get editDomain():FormEditDomain{
			return this._editDomain;
		}

		public function set selection(selection:Boolean):void{
			this._selection = selection;
			
			refreshSelection();
		}
		public function get selection():Boolean{
			return this._selection;
		}

		public function get selectableModel():ISelectableModel{
			return this.gridCell;
		}
		
		private var formGridItemEdit:FormGridItemEdit;
		
		protected function registerViewer():void{
			if(formGridItemEdit == null)
				formGridItemEdit = new FormGridItemEdit();
			formGridItemEdit.editDomain = this.editDomain;
			formGridItemEdit.formGridCell = this.gridCell;
			formGridItemEdit.formGridItemView = this;
		}

		/**
		 * 2010.3.2 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 기존의 refreshVisual은 span이 column에 관한것만 표현할 수 있도록 되어있으며, span이 1인것만 병합/해제를 할 수 있었는데,
		 * 아래의 function은 span이 row와 column 둘 다 표현할 수 있도록 되었있어서, 하나 이상의  row와 column들을 갖는 gridCell을 지원한다.
 	 	*/
		public function refreshVisual():void
		{
			var labelSize:Number = 0;

			var rowSpan:int = this.gridCell.rowSpan;
			var rowIdx:int = this.gridCell.gridRow.gridLayout.getRowIndex(this.gridCell.gridRow);
			this.rowSpan = rowSpan;
			if(rowSpan > 1){
				var gridCellHeight:Number = 0;
				for(var i:int = rowIdx ; i < (rowIdx + rowSpan) ; i++){
					gridCellHeight += this.gridCell.gridRow.gridLayout.getRowByIndex(i).size;
				}
				this.height = gridCellHeight;
			}else{
				this.height = this.gridCell.gridRow.gridLayout.getRowByIndex(rowIdx).size;
			}

			if(this.gridCell.gridRow.gridLayout.columnLength > 0){
				var colIdx:int = gridCell.gridColumnIndex;
				var col:FormGridColumn = gridCell.gridColumn;
				var colSpan:int = gridCell.span;
				labelSize = col.labelSize;
				this.colSpan = colSpan; 

				if(colSpan > 1){
					var gridCellWidth:Number = 0;
					for(var j:int = colIdx ; j < (colIdx + colSpan) ; j++){
						gridCellWidth += this.gridCell.gridRow.gridLayout.getColumnByIndex(j).size;
					}
					this.width = gridCellWidth;
				}else{
					this.width = col.size;
				}
			}
			this.colSpan = this.gridCell.span;
							
			refreshFormField(labelSize, this.width);			
		}
		
		private var _fieldView:FieldView;
		public function get fieldView():FieldView {
			return _fieldView;
		}
		public function set fieldView(value:FieldView):void {
			if (_fieldView != null && _fieldView.labelBox != null){
				_fieldView.labelBox.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
			_fieldView = value;
			
			if (_fieldView != null && _fieldView.labelBox != null) {
				_fieldView.labelBox.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_fieldView.labelBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		
		private function refreshSelection():void{
			if(this.selection){
				this.setStyle("borderThickness", "3");
				this.setStyle("borderColor", "#5EA1C4");
			}else{
				this.clearStyle("borderThickness");
				this.clearStyle("borderColor");
			}
		}	
		
		/**
		 * 2010.3.2 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 기존의 refreshVisual은 span이 column에 관한것만 표현할 수 있도록 되어있으며, span이 1인것만 병합/해제를 할 수 있었는데,
		 * 아래의 function은 span이 row와 column 둘 다 표현할 수 있도록 되었있어서, 하나 이상의  row와 column들을 갖는 gridCell을 지원한다.
 	 	*/
		private function refreshFormField(labelSize:Number, size:Number):void{
			var formEntityModel:FormEntity = FormModelUtil.getFormFieldById(this.gridCell.fieldId, this.container);
			if(this.gridCell.fieldId == null){
				if(this.fieldView != null && this.contains(this.fieldView)){
					this.fieldView.removeEventListener(DividerEvent.DIVIDER_RELEASE, this.formFieldDividerRelase);
					this.removeAllChildren();
					
					this.fieldView = null;
				}
			}else{
				if(this.fieldView == null){
					fieldView = new FieldView();
					fieldView.editDomain = this.editDomain;
					fieldView.formViewer = this.formView;
					this.addChild(this.fieldView);
				}else if(!(this.contains(this.fieldView))){
					this.addChild(this.fieldView);
				}
				
				if(formEntityModel != null){
					fieldView.model = formEntityModel;
					
					if(this.gridCell.gridRow.gridLayout.columnLength > 0){
						fieldView.labelSize = labelSize;
						fieldView.contentsSize = size - labelSize - (Config.DEFAULT_BORDER_SIZE * 2) - (Config.DEFAULT_PADDING_SIZE * 2);						
						fieldView.verticalSize = this.height - (Config.DEFAULT_BORDER_SIZE * 2) - (Config.DEFAULT_PADDING_SIZE * 2);
						formEntityModel.height = fieldView.verticalSize;
					}
					this.fieldView.addEventListener(FormEditorEvent.SELECTVIEW, this.selectChildHandler);
					this.fieldView.addEventListener(FormEditorEvent.UNSELECTVIEW, this.unSelectChildHandler);
					this.fieldView.addEventListener(DividerEvent.DIVIDER_RELEASE, this.formFieldDividerRelase);
					
					this.fieldView.refreshVisual();
				}  		
			}
		}
		
		public function selectChildHandler(e:FormEditorEvent):void{
			if(this.contains(e.target as DisplayObject)){
				select();
			} 
		}
		
		public function unSelectChildHandler(e:FormEditorEvent):void{
			if(this.contains(e.target as DisplayObject)){
				var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
				event.view = e.view;
				
				event.x = e.target.x;
				event.y = e.target.y;
				
				this.dispatchEvent(event);
				trace("[Event]FormGridItemView unSelectChildHandler dispatch event : " + event);
			} 
		}
		
		private function registerEvent():void{
			this.addEventListener(MouseEvent.CLICK, mouseClick);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			this.addEventListener(DragEvent.DRAG_ENTER, dragEnter);	
			this.addEventListener(DragEvent.DRAG_OVER, dragOver);	
			this.addEventListener(DragEvent.DRAG_EXIT, dragExit);	
			this.addEventListener(DragEvent.DRAG_DROP, dragDrop);
		}
		
		public function mouseClick(e:MouseEvent):void {
			if (e.target == this && this.formView.layoutView.mode == "gridMode"){
				select();
			}
		}
		
		private var dragFieldTimer:Timer = null;
		public var mouseDownEvent:MouseEvent = null;
		public function mouseDown(event:MouseEvent):void {
			if (this.gridCell.fieldId != null) {
				// 이벤트 오브젝트로부터 이니씨에이터 컴퍼넌트를 취득합니다.
				select();
				
				mouseDownEvent = event;
				// TODO
				if (dragFieldTimer == null) {
					dragFieldTimer = new Timer(200);
					dragFieldTimer.addEventListener(TimerEvent.TIMER, dragField);
				}
				dragFieldTimer.start();
			}
		}
		private function dragField(event:TimerEvent = null):void {
			if (dragFieldTimer != null)
				dragFieldTimer.stop();
			if (!mouseDownEvent)
				return;
			var dragInitiator:FormGridItemView = this;
			// DragSource 오브젝트를 작성합니다.
			var ds:DragSource = new DragSource();
			// 오브젝트에 데이터를 추가합니다.
			ds.addData(this.gridCell, "fromGridCell");

			//  drag  프록시로서 사용하는 Canvas 컨테이너를 작성합니다.
			// 프록시 이미지의 크기를 지정할 필요가 있습니다.
			// 지정하지 않는 경우는 표시되지 않습니다.
			var canvasProxy:Canvas = new Canvas();
			canvasProxy.width=this.width;
			canvasProxy.height=this.height;
			canvasProxy.setStyle('backgroundColor',"#C7DFFA");

			// DragManager doDrag() 메소드를 호출해  drag 를 시작합니다.  
			// 이 멧솟드의 상세한 것에 대하여는
			// 「 drag 의 시작」를 참조해 주세요.
			DragManager.doDrag(dragInitiator, ds, mouseDownEvent, canvasProxy);
		}
		private function mouseUp(event:MouseEvent):void {
			if (dragFieldTimer != null)
				dragFieldTimer.stop();
		}
		
		public function select():void{
			var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.SELECTVIEW);
			event.view = this;
			this.dispatchEvent(event);
			trace("[Event]FormGridItemView select dispatch event : " + event);
		}
		
		public function unSelect():void{
			var event:FormEditorEvent = new FormEditorEvent(FormEditorEvent.UNSELECTVIEW);
			event.view = this;
			this.dispatchEvent(event);
			trace("[Event]FormGridItemView unSelect dispatch event : " + event);
		}
		
		public function dragEnter(event:DragEvent):void{
			if(this.fieldView == null){
  				DragManager.acceptDragDrop(event.currentTarget as IUIComponent);
  				this.setStyle("backgroundColor", "#dbdbdb");
			}
		}
		
		public function dragOver(event:DragEvent):void{
			if(this.gridCell.fieldId == null){
  				DragManager.acceptDragDrop(event.currentTarget as IUIComponent);
  				this.setStyle("backgroundColor", "#dbdbdb");
			}
		}
		
		public function dragExit(event:DragEvent):void{
			this.clearStyle("backgroundColor");
		}
		
		public function dragDrop(event:DragEvent):void{
			if (event.dragInitiator is FormatButton) {
				var child:FormEntity = new FormEntity(this.container.root);
				var formLinkButton:FormatButton = event.dragInitiator as FormatButton;
				child.format.type = formLinkButton.formatType;

				child.name = FormDocument.ITEM_NAME_PREFIX + (this.container.root.currentEntityNum + 1);
				var command:Command = new CreateFormFieldCommand(this.container, child, -1);
				// TODO
				if (this.gridCell.gridRow.gridLayout.columnLength == 0) {
					command = command.chain(
						FormItemCommandUtil.resizeFormItem(
							child, 
							Config.DEFAULT_LABEL_WIDTH, 
							this.width - Config.DEFAULT_LABEL_WIDTH - (Config.DEFAULT_BORDER_SIZE * 2) - (Config.DEFAULT_PADDING_SIZE * 2), 
							this.height - (Config.DEFAULT_BORDER_SIZE * 2) - (Config.DEFAULT_PADDING_SIZE * 2)));
				}
				command = command.chain(FormGridCommandUtil.updateItemCommand(this.gridCell, "fieldId", child.id));
				
				this.editDomain.getCommandStack().execute(command);
				this.select();
			} else if (event.dragInitiator is FormGridItemView) {
				var data:Object = event.dragSource.dataForFormat('fromGridCell');
				if (data is FormGridCell) {
					var fromFormGridCell:FormGridCell = data as FormGridCell;
					var _command:Command = FormGridCommandUtil.updateItemCommand(fromFormGridCell, "fieldId", null);
					
					_command = _command.chain(FormGridCommandUtil.updateItemCommand(this.gridCell, "fieldId", fromFormGridCell.fieldId));
					
					if (this.gridCell.gridRow.gridLayout.columnLength == 0) {
						var diffSize:Number = this.gridCell.size - fromFormGridCell.size; 
						var formEntity:FormEntity = FormModelUtil.getFormFieldById(fromFormGridCell.fieldId, fromFormGridCell.gridRow.gridLayout.container);
						if ((diffSize + formEntity.contentWidth) > 0) {
							_command = _command.chain(FormItemCommandUtil.updateFormItemProperty(formEntity, diffSize + formEntity.contentWidth, FormEntity.PROP_CONTENT_WIDTH));
						}else{
							_command = _command.chain(FormItemCommandUtil.updateFormItemProperty(formEntity, 0, FormEntity.PROP_CONTENT_WIDTH));
							_command = _command.chain(FormItemCommandUtil.updateFormItemProperty(formEntity, diffSize + formEntity.contentWidth + formEntity.labelWidth, FormEntity.PROP_LABEL_WIDTH));
						}
					}
					this.editDomain.getCommandStack().execute(_command);
					
					this.unSelect();
				}
			}
			this.clearStyle("backgroundColor");
		}
		
		public function formFieldDividerRelase(e:DividerEvent):void{
			if(fieldView != null){
				var command:Command = FormGridCommandUtil.updateLabelSizeCommand(this.gridCell, fieldView.getAbsLabelSize() - fieldView.model.labelWidth, fieldView.getAbsContentsSize() - fieldView.model.contentWidth);
				
				if(command != null){
					this.editDomain.getCommandStack().execute(command);
				}
			}
		}
	}
}