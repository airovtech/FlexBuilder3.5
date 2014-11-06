/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.util
 *  Class: 			FormGridCommandUtil
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Grid에 관련된 Command들을 생성하는 Util 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.util
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.command.AddFormGridColumnCommand;
	import com.maninsoft.smart.formeditor.command.AddFormGridItemCommand;
	import com.maninsoft.smart.formeditor.command.AddFormGridRowCommand;
	import com.maninsoft.smart.formeditor.command.IncreaseAttrFormGridColumnCommand;
	import com.maninsoft.smart.formeditor.command.IncreaseAttrFormGridItemCommand;
	import com.maninsoft.smart.formeditor.command.RemoveFormGridColumnCommand;
	import com.maninsoft.smart.formeditor.command.RemoveFormGridItemCommand;
	import com.maninsoft.smart.formeditor.command.RemoveFormGridRowCommand;
	import com.maninsoft.smart.formeditor.command.UpdateFormGridItemCommand;
	import com.maninsoft.smart.formeditor.command.UpdateFormGridRowCommand;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.refactor.command.IncreaseAttrFormEntityCommand;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormDocumentCommandUtil;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormItemCommandUtil;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormModelUtil;
	import com.maninsoft.smart.workbench.common.command.model.Command;
	
	public class FormGridCommandUtil
	{
		public static function addRowItemCommand(gridLayout:FormGridLayout, gridRow:FormGridRow, index:int = -1):Command{
			var command:Command = new AddFormGridRowCommand(gridLayout, gridRow, index);			
			command = command.chain(resizeFormDocumentCommand(gridLayout.container.root, gridRow.size + Config.DEFAULT_BORDER_SIZE + 1));
			return command;
		}
		
		public static function addRowCommand(gridLayout:FormGridLayout, gridRow:FormGridRow, index:int = -1, colSize:int = -1):Command{
			var command:Command = addRowItemCommand(gridLayout, gridRow, index);

			/**
			 * 	2010.3.14 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 *  row추가시에 전row들 중에 특정cell이 row병합을 하였나 확인하여, 추가될row가 row병합된 cell에 포함되면 rowSpan을 늘려준다.
			 * 	그리고, 추가될 row에서 해당 cell을 제거한다.
			 */
			var mergedColIndexs:Array = new Array();
			if(index>0){
				for(var rowIndex:int=0; rowIndex<index; rowIndex++){
					var targetGridRow:FormGridRow = gridLayout.getRowByIndex(rowIndex);
					for(var cellIndex:int=0; cellIndex<targetGridRow.length; cellIndex++){
						var targetGridItem:FormGridCell = targetGridRow.getCellByIndex(cellIndex);
						if(targetGridItem.rowSpan>index-rowIndex){
							command = command.chain(new IncreaseAttrFormGridItemCommand(targetGridItem, "rowSpan", 1));
							var targetColIndex:int = targetGridItem.gridColumnIndex;
							for(var spanIndex:int=0; spanIndex<targetGridItem.span; spanIndex++){
								mergedColIndexs.push(targetColIndex+spanIndex);
							}
						}
					}
				}
			}
			
			if(colSize == -1){
				colSize = FormGridUtil.getMaxColumnSize(gridLayout);
			}			
			for(var i:int=0; i<colSize; i++){
				/**
				 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
				 *  모든셀에 컬럼인덱스 정보를 저장한다.
				 */
				for(var j:int=0; j<mergedColIndexs.length; j++)
					if(i==(mergedColIndexs[j] as int))
						break;
				if(j<mergedColIndexs.length)
					continue;
					
				var gridItem:FormGridCell = new FormGridCell(gridRow, gridLayout.getColumnByIndex(i));
				gridItem.size = FormGridUtil.getColumnWidth(gridLayout, i);
				command = command.chain(addItemCommand(gridRow, gridItem));
			}
			return command;
		}
		
		public static function addItemCommand(gridRow:FormGridRow, gridItem:FormGridCell, index:int = -1):Command{
			var command:Command = new AddFormGridItemCommand(gridRow, gridItem, index);
			
			return command;
		}

		public static function addColumnCommand(gridRow:FormGridRow, colIndex:int = -1):Command{
			var command:Command;
			var sumColWidth:Number = 0;
			
			for(var i:int = 0 ; i < gridRow.gridLayout.columnLength ; i++){
				sumColWidth += gridRow.gridLayout.getColumnByIndex(i).size;
			}
			// 평균크기로 추가
			var newColWidth:Number = (sumColWidth + ((gridRow.gridLayout.columnLength - 1) * 1) + (gridRow.gridLayout.columnLength * 2)) /(gridRow.gridLayout.columnLength + 1);
			var gridCol:FormGridColumn = new FormGridColumn(gridRow.gridLayout);
			gridCol.size = newColWidth - 1 - 2;
			command = new AddFormGridColumnCommand(gridRow.gridLayout, gridCol, colIndex);
			for (var _i:int=0; _i<gridRow.gridLayout.rowLength; _i++) {
				var targetRow:FormGridRow = gridRow.gridLayout.getRowByIndex(_i);
				/**
				 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
				 *  모든셀에 컬럼인덱스 정보를 저장한다.
				 */
				var newGridItem:FormGridCell = new FormGridCell(targetRow, gridCol);
				var cellIndex:int = FormGridUtil.getCellIndexByColumnIndex(targetRow, colIndex);
				if(cellIndex==-1){
					cellIndex = FormGridUtil.getCellIndexByColumnIndexInSpan(targetRow, colIndex);
					if(cellIndex!=-1){
						command = command.chain(new IncreaseAttrFormGridItemCommand(targetRow.getCellByIndex(cellIndex), "span", 1));
					}else{
						cellIndex = FormGridUtil.getFirstNoneCellIndexByColumnIndex(targetRow, colIndex);
						if(cellIndex!=-1){
							command = command.chain(new AddFormGridItemCommand(targetRow, newGridItem, cellIndex));
						}else if(FormGridUtil.getNoneCellIndexByColumnIndex(targetRow, colIndex)==-1){
							command = command.chain(new AddFormGridItemCommand(targetRow, newGridItem, cellIndex));
						}
					}
				}else{
					command = command.chain(new AddFormGridItemCommand(targetRow, newGridItem, cellIndex));
				}					
			}
			// 동등분할로 줄일 값 산정
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 *	동등분할하여 각 컬럼들의 사이즈를 줄이면 0보다 적은 사이즈가 나올수 있으므로,
			 * 	동등 사이즈가 아닌 동등 비율로 사이즈 조정 한다. 	
			 */
			var minusRate:Number = newColWidth/sumColWidth;
			for (var __i:int=0; __i<gridRow.gridLayout.columnLength; __i++) {
				var targetCol:FormGridColumn = gridRow.gridLayout.getColumnByIndex(__i);
				command = command.chain(new IncreaseAttrFormGridColumnCommand(targetCol, "size", -(targetCol.size*minusRate)));
			}
			return command;
		}
		
		public static function updateRowCommand(gridRow:FormGridRow, type:String, value:Object):Command{
			var command:Command = new UpdateFormGridRowCommand(gridRow, type, value);
			
			return command;
		}
		
		public static function updateItemCommand(gridItem:FormGridCell, type:String, value:Object):Command{
			var command:Command = new UpdateFormGridItemCommand(gridItem, type, value);
			
			return command;
		}
		
		public static function removeItemCommand(gridItem:FormGridCell):Command{
			var command:Command = new RemoveFormGridItemCommand(gridItem);
			
			if(gridItem.fieldId != null && gridItem.fieldId != "") {
				var targetFormEntity:FormEntity = FormModelUtil.getFormFieldById(gridItem.fieldId, gridItem.gridRow.gridLayout.container);	
				command = command.chain(FormDocumentCommandUtil.createRemoveSchemaItem(targetFormEntity));
			}
			
			return command;
		}
		
		public static function removeColumnCommand(gridItem:FormGridCell):Command{
			var command:Command = null;
			var colNum:int = gridItem.gridColumnIndex;
			var colSpan:int = gridItem.span;
			// 각 행에서 컬럼에 연결되는 아이템을 삭제
			for(var i:int = 0 ; i < gridItem.gridRow.gridLayout.rowLength ; i++){
				var targetRow:FormGridRow = gridItem.gridRow.gridLayout.getRowByIndex(i);
				var targetItem:FormGridCell;
				var remainSpan:int = colSpan;
				var colIndex:int = colNum;
				var cellIndex:int = FormGridUtil.getCellIndexByColumnIndex(targetRow, colIndex);
				while(remainSpan){
					if(cellIndex!=-1 && cellIndex<targetRow.length){
						targetItem = targetRow.getCellByIndex(cellIndex);	
						if(targetItem.span<=remainSpan){
							if(command)
								command = command.chain(removeItemCommand(targetItem));
							else
								command = removeItemCommand(targetItem);
							remainSpan-=targetItem.span;
						}else if(targetItem.span>remainSpan){
							if(command)
								command = command.chain(new IncreaseAttrFormGridItemCommand(targetItem, "span", -remainSpan));						
							else
								command = new IncreaseAttrFormGridItemCommand(targetItem, "span", -remainSpan);
							command = command.chain(new UpdateFormGridItemCommand(targetItem, "gridColumn", targetRow.gridLayout.getColumnByIndex(colNum+remainSpan))); 
							remainSpan=0;
						}							
						cellIndex++;
					}else{
						cellIndex = FormGridUtil.getCellIndexByColumnIndexInSpan(targetRow, colNum);
						if(cellIndex!=-1){
							targetItem = targetRow.getCellByIndex(cellIndex);	
							if(targetItem.span<=remainSpan){
								if(command)
									command = command.chain(new IncreaseAttrFormGridItemCommand(targetItem, "span", -targetItem.span));
								else
									command = new IncreaseAttrFormGridItemCommand(targetItem, "span", -targetItem.span);
								remainSpan-= targetItem.span;
							}else{
								if(command)
									command = command.chain(new IncreaseAttrFormGridItemCommand(targetItem, "span", -remainSpan));
								else
									command = new IncreaseAttrFormGridItemCommand(targetItem, "span", -remainSpan);
								remainSpan = 0;
							}
							cellIndex++;
						}else{
							remainSpan--;
							cellIndex = FormGridUtil.getCellIndexByColumnIndex(targetRow, colIndex++);
						}
					}
				}
			}
			// 컬럼을 삭제
			var sumColSize:Number=0;
			for(colIndex=colNum; (colIndex-colNum)<colSpan; colIndex++){
				var targetCol:FormGridColumn = gridItem.gridRow.gridLayout.getColumnByIndex(colIndex);
				sumColSize += targetCol.size + 1;
				command = command.chain(new RemoveFormGridColumnCommand(targetCol));
			}
				
			// 남은 컬럼크기를 옆 컬럼에 더해준다.
			var nextCol:FormGridColumn;
			if(gridItem.gridRow.gridLayout.columnLength > colSpan){
				if(colNum+colSpan == gridItem.gridRow.gridLayout.columnLength){
					nextCol = gridItem.gridRow.gridLayout.getColumnByIndex(colNum - 1);
				}else{
					nextCol = gridItem.gridRow.gridLayout.getColumnByIndex(colNum + colSpan);
				}
				command = command.chain(new IncreaseAttrFormGridColumnCommand(nextCol, "size", sumColSize));
			}
			return command;
		}
		
		/**
		 * 	2010.3.14 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
		 * 	선택한 cell의 row를 삭제하는 경우인데, cell의 row만 삭제하는 것이 아니라, cell의 rowSpan에 있는 모든 row를 삭제한다.
		 */
		public static function removeRowCommand(gridItem:FormGridCell):Command{
			
			var command:Command = null;
						
			var remainRowSpan:int = gridItem.rowSpan;
			var rowSize:Number=0;
			while(remainRowSpan){
				var targetGridRow:FormGridRow = gridItem.gridRow.gridLayout.getRowByIndex(gridItem.gridRowIndex+remainRowSpan-1);
				for(var i:int = 0 ; i < targetGridRow.length ; i++){
					var targetGridItem:FormGridCell = targetGridRow.getCellByIndex(i);
					if(	targetGridItem.rowSpan<=remainRowSpan){ 
						if(command == null){
							command = removeItemCommand(targetGridItem);
						}else{
							command = command.chain(removeItemCommand(targetGridItem));
						}
					}else if(targetGridItem.rowSpan>remainRowSpan){
						if(command == null){
							command = new IncreaseAttrFormGridItemCommand(targetGridItem, "rowSpan", -remainRowSpan);
						}else{
							command = command.chain(new IncreaseAttrFormGridItemCommand(targetGridItem, "rowSpan", -remainRowSpan));
						}
					}
				}						
				command = command.chain(new RemoveFormGridRowCommand(targetGridRow));
				rowSize -= targetGridRow.size + Config.DEFAULT_BORDER_SIZE + 1;
				remainRowSpan--;
			}
			command = command.chain(resizeFormDocumentCommand(gridItem.gridRow.gridLayout.container.root, rowSize));


			/**
			 * 	2010.3.14 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 *  row추가시에 전row들 중에 특정cell이 row병합을 하였나 확인하여, 추가될row가 row병합된 cell에 포함되면 rowSpan을 늘려준다.
			 */
			var index:int = gridItem.gridRowIndex;
			if(index>0){
				for(var rowIndex:int=0; rowIndex<index; rowIndex++){
					targetGridRow = gridItem.gridRow.gridLayout.getRowByIndex(rowIndex);
					for(var colIndex:int=0; colIndex<targetGridRow.length; colIndex++){
						targetGridItem = targetGridRow.getCellByIndex(colIndex);
						if(targetGridItem.rowSpan>index-rowIndex){
							remainRowSpan = targetGridItem.rowSpan-(index-rowIndex);
							if(remainRowSpan>=gridItem.rowSpan){
								remainRowSpan = gridItem.rowSpan;
							} 
							command = command.chain(new IncreaseAttrFormGridItemCommand(targetGridItem, "rowSpan", -remainRowSpan));
						}
					}
				}
			}

			return command;
		}

		/**
		 * 2010.3.2 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 * 기존의 updateItemSpanCommand function은, span이 1인경우만 하나의 row에서 ItemSpan을 실행하는데,
		 * 아래에 있는 function은, 여러개의 row와 column들이 같은 span을 가지고 있으면 병합할 수 있도록 기능을 제공함.
 	 	*/

		public static function updateItemSpanCommand(gridCell:FormGridCell, rowSize:int, colSize:int):Command{
			if(rowSize*colSize>1){
				var rowIndex:int = gridCell.gridRow.gridLayout.getRowIndex(gridCell.gridRow);
				var colIndex:int = gridCell.gridColumnIndex;
				// 순서가 중요 아이템을 먼저 삭제하고  span을 조정해야 함. span을 먼저 조정하면 해당 로우에 컬럼 크기가 전체 크기보다 커짐
				var command:Command;
				for(var i:int=rowIndex; i<rowIndex+rowSize;){
					var curGridRow:FormGridRow = gridCell.gridRow.gridLayout.getRowByIndex(i);
					var cellIndex:int = FormGridUtil.getCellIndexByColumnIndex(curGridRow, colIndex);
					for(var j:int=0; cellIndex< curGridRow.length && j < colSize;){
						var curGridCell:FormGridCell = curGridRow.getCellByIndex(cellIndex);
						if(i!=rowIndex || j!=0){
							if(command == null){
								command = removeItemCommand(curGridCell);
							}else{
								command = command.chain(removeItemCommand(curGridCell));
							}
						}
						cellIndex += curGridCell.span;
						j += curGridCell.span;
					}
					i += gridCell.rowSpan;
				}
				if(command){
					command = command.chain(updateItemCommand(gridCell, "rowSpan", rowSize));
					command = command.chain(updateItemCommand(gridCell, "span", colSize));
				}
				return command;
			}			
			return null;
		}

		public static function updateColumnSizeCommand(gridLayout:FormGridLayout, index:int, diffWidth:Number):Command{
			
			var command:Command;			
			var gridCol:FormGridColumn = gridLayout.getColumnByIndex(index);
			command = new IncreaseAttrFormGridColumnCommand(gridCol, "size", diffWidth);
				
			// 다른  그리드 컬럼 크기 줄이기
			var diffSize:Number = diffWidth;
			var targetNextDiffSize:Number = 0;
			if(diffSize > 0){
				for(var j:int = index + 1 ; j < gridLayout.columnLength && targetNextDiffSize == 0; j++){
					var targetNextCol:FormGridColumn = gridLayout.getColumnByIndex(j);
						
					targetNextDiffSize = (targetNextCol.size - diffSize) > 0?targetNextCol.size - diffSize:0;
							
					command = command.chain(new IncreaseAttrFormGridColumnCommand(targetNextCol, "size", targetNextDiffSize - targetNextCol.size));
	
					diffSize =   diffSize - targetNextCol.size;
				}
			}else{
				var _targetNextCol:FormGridColumn = gridLayout.getColumnByIndex(index + 1);
				command = command.chain(new IncreaseAttrFormGridColumnCommand(_targetNextCol, "size", -diffSize));
			}			
			return command;
		}

		public static function updateRowSizeCommand(gridLayout:FormGridLayout, index:int, newSize:Number):Command{
			var targetRow:FormGridRow = gridLayout.getRowByIndex(index);		
			var command:Command = updateRowCommand(targetRow, "size", newSize);
			
			if(gridLayout.columnLength == 0){
				for(var i:int = 0 ; i < targetRow.length ; i++){
					var targetCell:FormGridCell = targetRow.getCellByIndex(i);
					if(targetCell.fieldId != null){
						var targetFormEntity:FormEntity = FormModelUtil.getFormFieldById(targetCell.fieldId, gridLayout.container);
						command = command.chain(FormItemCommandUtil.updateFormItemProperty(targetFormEntity, newSize - (Config.DEFAULT_PADDING_SIZE * 2) - (Config.DEFAULT_BORDER_SIZE * 2), FormEntity.PROP_HEIGHT));
					}
				}
			}
			
			command = command.chain(resizeFormDocumentCommand(gridLayout.container.root, newSize - targetRow.size));

			return command;
		}

		public static function updateLabelSizeCommand(gridCell:FormGridCell, labelDiffSize:Number, contentsDiffSize:Number):Command{
			var index:int = gridCell.gridRow.getCellIndex(gridCell);

			var command:Command;
			if(gridCell.gridRow.gridLayout.columnLength > 0){
				var gridCol:FormGridColumn = gridCell.gridRow.gridLayout.getColumnByIndex(index);
				command = new IncreaseAttrFormGridColumnCommand(gridCol, 'labelSize', labelDiffSize);
			}else{
				for(var i:int = 0 ; i < gridCell.gridRow.gridLayout.rowLength ; i++){
					var targetCell:FormGridCell = gridCell.gridRow.gridLayout.getRowByIndex(i).getCellByIndex(index);
					if(targetCell.fieldId != null){
						var formEntityModel:FormEntity = FormModelUtil.getFormFieldById(targetCell.fieldId, targetCell.gridRow.gridLayout.container);
						if(command == null){
							command = new IncreaseAttrFormEntityCommand(formEntityModel, 'labelSize', labelDiffSize);
						}else{
							command = command.chain(new IncreaseAttrFormEntityCommand(formEntityModel, 'labelSize', labelDiffSize));	
						}
						command = command.chain(new IncreaseAttrFormEntityCommand(formEntityModel, 'contentsSize', contentsDiffSize));	
					}
				}
			}
			return command;
		}

		public static function resizeFormDocumentCommand(container:FormDocument, newSize:Number):Command{
			if(container.layout is FormGridLayout){				
				var heightSize:Number = FormGridUtil.getFormDocumentHeight(container);
				heightSize += newSize;
				var command:Command =FormDocumentCommandUtil.updateFormDocumentProperty(container, heightSize , FormDocument.PROP_HEIGHT);
				return command;
			}
			return null;				
		}
	}
}