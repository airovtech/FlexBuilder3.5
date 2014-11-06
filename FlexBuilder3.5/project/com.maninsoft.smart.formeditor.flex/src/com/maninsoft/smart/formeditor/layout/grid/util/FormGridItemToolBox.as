/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.util
 *  Class: 			FormGridItemToolBox
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid에 Item을 선택했을때 나타나는 toolBox에 관련된 기능들을 구현한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.util
{
	import com.maninsoft.smart.formeditor.command.UnSelectFormGridItemCommand;
	import com.maninsoft.smart.formeditor.command.UnSelectFormGridLayoutCommand;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormSelectionPointBox;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public class FormGridItemToolBox
	{
		public static var colPreAddBtn:Button;
		public static var colNextAddBtn:Button;
		public static var colRemoveBtn:Button;

        public static var rowPreAddBtn:Button;
		public static var rowNextAddBtn:Button;
		public static var rowRemoveBtn:Button;
				
		public static var selectionGridItemView:FormGridItemView;
		public static var selectionGridItem:FormGridCell;
		
		private static const DEFAULT_TOOL_BTN_SIZE:Number = 12;
		
		private static var editDomain:FormEditDomain;
		
		public static function createToolBox(_selectionGridItemView:FormGridItemView, parent:DisplayObjectContainer, stageX:Number, stageY:Number, _editDomain:FormEditDomain):void{
			var resourceManager:IResourceManager = ResourceManager.getInstance();
			selectionGridItemView = _selectionGridItemView;
			selectionGridItem = _selectionGridItemView.gridCell;
			
			editDomain = _editDomain;
			
			if(colPreAddBtn == null){
				colPreAddBtn = new Button();
				colPreAddBtn.styleName = "colPreAddBtn";
				colPreAddBtn.width = DEFAULT_TOOL_BTN_SIZE;
				colPreAddBtn.height = DEFAULT_TOOL_BTN_SIZE;
				colPreAddBtn.toolTip = resourceManager.getString("FormEditorETC", "colPreAddTTip");
				colPreAddBtn.addEventListener(MouseEvent.CLICK, colPreAddClick);
	
				colNextAddBtn = new Button();
				colNextAddBtn.styleName = "colNextAddBtn";
				colNextAddBtn.width = DEFAULT_TOOL_BTN_SIZE;
				colNextAddBtn.height = DEFAULT_TOOL_BTN_SIZE;
				colNextAddBtn.toolTip = resourceManager.getString("FormEditorETC", "colNextAddTTip");
				colNextAddBtn.addEventListener(MouseEvent.CLICK, colNextAddClick);
				
				colRemoveBtn = new Button();
				colRemoveBtn.styleName = "colRemoveBtn";
				colRemoveBtn.width = DEFAULT_TOOL_BTN_SIZE;
				colRemoveBtn.height = DEFAULT_TOOL_BTN_SIZE;
				colRemoveBtn.toolTip = resourceManager.getString("FormEditorETC", "colRemoveTTip");
				colRemoveBtn.addEventListener(MouseEvent.CLICK, colRemoveClick);
				
				parent.addChild(colPreAddBtn);
				parent.addChild(colNextAddBtn);
				parent.addChild(colRemoveBtn);
				
				rowPreAddBtn = new Button();
				rowPreAddBtn.styleName = "rowPreAddBtn";
				rowPreAddBtn.width = DEFAULT_TOOL_BTN_SIZE;
				rowPreAddBtn.height = DEFAULT_TOOL_BTN_SIZE;
				rowPreAddBtn.toolTip = resourceManager.getString("FormEditorETC", "rowPreAddTTip");
				rowPreAddBtn.addEventListener(MouseEvent.CLICK, rowPreAddClick);
	
				rowNextAddBtn = new Button();
				rowNextAddBtn.styleName = "rowNextAddBtn";
				rowNextAddBtn.width = DEFAULT_TOOL_BTN_SIZE;
				rowNextAddBtn.height = DEFAULT_TOOL_BTN_SIZE;
				rowNextAddBtn.toolTip = resourceManager.getString("FormEditorETC", "rowNextAddTTip");
				rowNextAddBtn.addEventListener(MouseEvent.CLICK, rowNextAddClick);
				
				rowRemoveBtn = new Button();
				rowRemoveBtn.styleName = "rowRemoveBtn";
				rowRemoveBtn.width = DEFAULT_TOOL_BTN_SIZE;
				rowRemoveBtn.height = DEFAULT_TOOL_BTN_SIZE;
				rowRemoveBtn.toolTip = resourceManager.getString("FormEditorETC", "rowRemoveTTip");
				rowRemoveBtn.addEventListener(MouseEvent.CLICK, rowRemoveClick);
				
				parent.addChild(rowPreAddBtn);
				parent.addChild(rowNextAddBtn);
				parent.addChild(rowRemoveBtn);
			}else{
				if(parent.contains(colPreAddBtn)){
					parent.removeChild(colPreAddBtn);
				}
				parent.addChild(colPreAddBtn);
				
				if(parent.contains(colNextAddBtn)){
					parent.removeChild(colNextAddBtn);					
				}
				parent.addChild(colNextAddBtn);
				
				if(parent.contains(colRemoveBtn)){
					parent.removeChild(colRemoveBtn);					
				}
				parent.addChild(colRemoveBtn);
				
				if(parent.contains(rowPreAddBtn)){
					parent.removeChild(rowPreAddBtn);
				}
				parent.addChild(rowPreAddBtn);
				
				if(parent.contains(rowNextAddBtn)){
					parent.removeChild(rowNextAddBtn);
				}
				parent.addChild(rowNextAddBtn);
				
				if(parent.contains(rowRemoveBtn)){
					parent.removeChild(rowRemoveBtn);
				}
				parent.addChild(rowRemoveBtn);
				
			}
			
			colPreAddBtn.x = stageX + (selectionGridItemView.width / 2) - (colRemoveBtn.width / 2) - colPreAddBtn.width;
			colPreAddBtn.y = stageY - colPreAddBtn.height - FormSelectionPointBox.SELECTION_POINT_SIZE;
			
			colRemoveBtn.x = stageX + (selectionGridItemView.width / 2) - (colRemoveBtn.width / 2);
			colRemoveBtn.y = stageY - colRemoveBtn.height - FormSelectionPointBox.SELECTION_POINT_SIZE;
			
			colNextAddBtn.x = stageX + (selectionGridItemView.width / 2) + (colRemoveBtn.width / 2);
			colNextAddBtn.y = stageY - colNextAddBtn.height - FormSelectionPointBox.SELECTION_POINT_SIZE;
							
			colPreAddBtn.visible = true;
			colNextAddBtn.visible = true;
			colRemoveBtn.visible = true;

			rowPreAddBtn.x = stageX - rowPreAddBtn.width - FormSelectionPointBox.SELECTION_POINT_SIZE;
			rowPreAddBtn.y = stageY + (selectionGridItemView.height / 2) - (rowRemoveBtn.height / 2) - rowPreAddBtn.height;
			
			rowRemoveBtn.x = stageX - rowRemoveBtn.width - FormSelectionPointBox.SELECTION_POINT_SIZE;
			rowRemoveBtn.y = stageY + (selectionGridItemView.height / 2) - (rowRemoveBtn.height / 2);
			
			rowNextAddBtn.x = stageX - rowNextAddBtn.width - FormSelectionPointBox.SELECTION_POINT_SIZE;
			rowNextAddBtn.y = stageY + (selectionGridItemView.height / 2) + (rowRemoveBtn.height / 2);
			
			rowPreAddBtn.visible = true;
			rowNextAddBtn.visible = true;
			rowRemoveBtn.visible = true;

		}  
		
		public static function removeToolBox():void{
			if(colPreAddBtn != null){
				selectionGridItemView = null;
				selectionGridItem = null;
				
				colPreAddBtn.visible = false;
				colNextAddBtn.visible = false;
				colRemoveBtn.visible = false;
				
				rowPreAddBtn.visible = false;
				rowNextAddBtn.visible = false;
				rowRemoveBtn.visible = false;
			}
		}
		
		public static function colPreAddClick(e:MouseEvent):void{
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 *  선택한 컬럼의 좌측에 컬럼을 추가하는 기능인데, addColumnCommand들 호출할 시에, 새로운 cell을 만들어서 입력할 필요가 없어 삭제한다.
			 * 	그리고, column Index와  cell Index가 완전히 부합하지는 않은데, cell Index를  column Index로 사용하고 있어서, columnIndex로 대체한다. 
			 */
			var gridItem:FormGridCell = selectionGridItemView.gridCell;
			var command:Command = FormGridCommandUtil.addColumnCommand(	gridItem.gridRow, gridItem.gridColumnIndex);
			editDomain.getCommandStack().execute(command);
			toolBoxClickPost();
		}
		
		public static function colRemoveClick(e:MouseEvent):void{
			var gridLayout:FormGridLayout = selectionGridItemView.gridCell.gridRow.gridLayout;
			var command:Command = FormGridCommandUtil.removeColumnCommand(selectionGridItemView.gridCell);
			command = command.chain(new UnSelectFormGridLayoutCommand(selectionGridItemView.gridCell.gridRow.gridLayout));		
			editDomain.getCommandStack().execute(command);
			FormGridUtil.traceFormGrid(gridLayout);
			toolBoxClickPost();
		}
		
		public static function colNextAddClick(e:MouseEvent):void{
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 *  선택한 컬럼의 우측에 컬럼을 추가하는 기능인데, addColumnCommand들 호출할 시에, 새로운 cell을 만들어서 입력할 필요가 없어 삭제한다.
			 * 	그리고, column Index와  cell Index가 완전히 부합하지는 않은데, cell Index를  column Index로 사용하고 있어서, columnIndex로 대체한다. 
			 */
			var gridItem:FormGridCell = selectionGridItemView.gridCell;
			var command:Command = FormGridCommandUtil.addColumnCommand( gridItem.gridRow, gridItem.gridColumnIndex + selectionGridItemView.gridCell.span);
			editDomain.getCommandStack().execute(command);
			toolBoxClickPost();
		}

		public static function rowPreAddClick(e:MouseEvent):void{
			var gridItem:FormGridCell = selectionGridItemView.gridCell;
			var command:Command = FormGridCommandUtil.addRowCommand( gridItem.gridRow.gridLayout, new FormGridRow(gridItem.gridRow.gridLayout), 
															gridItem.gridRow.gridLayout.getRowIndex(gridItem.gridRow));
			command = command.chain(new UnSelectFormGridItemCommand(gridItem));		
			editDomain.getCommandStack().execute(command);
			toolBoxClickPost();
		}
		
		public static function rowRemoveClick(e:MouseEvent):void{
			/**
			 * 	2010.3.14 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 * 	선택한 cell의 row를 삭제하는 경우인데, cell의 row만 삭제하는 것이 아니라, cell의 rowSpan에 있는 모든 row를 삭제한다.
			 */
			var command:Command = FormGridCommandUtil.removeRowCommand(selectionGridItemView.gridCell);
			command = command.chain(new UnSelectFormGridLayoutCommand(selectionGridItemView.gridCell.gridRow.gridLayout));		
			editDomain.getCommandStack().execute(command);
			toolBoxClickPost();
		}
		
		public static function rowNextAddClick(e:MouseEvent):void{
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 * 	선택한 cell의 아래에 row를 추가하는 경우인데, 선택한 cell의 row보다 1인 큰 row를 추가하는 것에서, 선택한 cell의 rowSpan만큼 큰 row를 추가 한다.
			 */
			var gridItem:FormGridCell = selectionGridItemView.gridCell;
			var command:Command = FormGridCommandUtil.addRowCommand( gridItem.gridRow.gridLayout, new FormGridRow(gridItem.gridRow.gridLayout), 
										gridItem.gridRow.gridLayout.getRowIndex(gridItem.gridRow) + gridItem.rowSpan);

			command = command.chain(new UnSelectFormGridItemCommand(gridItem));		
			editDomain.getCommandStack().execute(command);
			toolBoxClickPost();
		}
		
		private static function toolBoxClickPost():void{
			if(selectionGridItemView != null)
				selectionGridItemView.gridCell.select(false);
		}
	}
}