/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.util
 *  Class: 			FormGridUtil
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서, Form Grid에 관련된 여러가지 유용한 기능들을 제공한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.util
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridContainer;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridRowView;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.refactor.simple.util.FormModelUtil;
	
	import flash.utils.describeType;
	
	public class FormGridUtil
	{

		/**
		 * 	2010.3.10 Created by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 *  FormGridLayout의 columnLenght가 0인 경우에 컬럼정보를 새롭게 만드는  기능 이다.
		 * 	row병합기능이 추가된 이후에는 row에서 컬럼 인덱스를 찾는 방법이 달라졌기 때문에 이 기능을 사용할 수 없다.
		 * 	그래서, 이 기능을 호출하는 Layout정보에는 row병합이 이루어지지 않았다는 가정으로 가지고 본 기능을 수행한다.
		 */
		public static function createGridColumnInfo(gridLayout:FormGridLayout):void{
			if(gridLayout.columnLength>0) return;
			var columnLength:int = getMaxColumnSize(gridLayout);
			for(var colIdx:int=0; colIdx<columnLength; colIdx++){
				var gridColumn:FormGridColumn = new FormGridColumn(gridLayout);
				var colSize:Object = getColumnSize(gridLayout, colIdx);
				gridColumn.size = colSize["size"];
				gridColumn.labelSize = colSize["labelSize"];
				gridLayout.addColumn(gridColumn, colIdx);
			}
			for(var rowIdx:int=0; rowIdx<gridLayout.rowLength; rowIdx++){
				var gridRow:FormGridRow = gridLayout.getRowByIndex(rowIdx);
				for(var cellIdx:int=0, colSpan:int=0; cellIdx<gridRow.length; cellIdx++){
					gridRow.getCellByIndex(cellIdx).gridColumn = gridLayout.getColumnByIndex(colSpan);
					colSpan += gridRow.getCellByIndex(cellIdx).span;
				}
			}
		}

		/**
		 * 	2010.3.10 Created by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	gridCell이 gridColumn정보를 가지고 있지 않을 경우나, 서버에서 폼정보를 가져와서 gridCell을 생성할 때 gridColumnIndex만 가지고
		 * 	gridColumn 레퍼런스를 저장하는 기능이다.
		 */
		public static function setGridColumn(gridCell:FormGridCell, gridColumnIndex:int):void{
			
			if(gridCell.gridRow == null){
				return;	
			}
			
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
			 * 	gridColumnIndex가 -1인 경우에는 row병합 기능이 추가되기 전에 gridColumnIndex 정보를 가지고 있는 않은 경우에 해당된다.
			 * 	이 경우에는, 모든 row에 span합이 다 같다는 전제에서 아래의 기능을 수행한다.
			 */
			if(gridColumnIndex == -1){
				var gridRow:FormGridRow = gridCell.gridRow;
				var gridCellIndex:int = gridCell.gridRow.getCellIndex(gridCell);
				if(gridCellIndex==-1) gridCellIndex=gridRow.length;
				for(var cellIdx:int=0, colSpan:int=0; cellIdx<gridCellIndex; cellIdx++)
					colSpan += gridRow.getCellByIndex(cellIdx).span;
				gridCell.gridColumn = gridRow.gridLayout.getColumnByIndex(colSpan);
								
			/**
			 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
			 * 	gridColumnIndex가 -1이 아닌 경우에는 row병합 기능이 추가된 후에 생성된 cell이다.
			 * 	그러나, 본 기능을 호출한 이유는, gridCell에서 gridRow나 gridLayout을 찾을 수 없는 경우 에 한해서 호출은 한다.
			 * 	현재는, 서버에서 폼정의 정보 xml데이터를 가져와서 gridCell model에 생성시에 gridRow정보가 없어서 본 기능을 추가 한다.
			 */
			}else{
				gridCell.gridColumn = gridCell.gridRow.gridLayout.getColumnByIndex(gridColumnIndex);	
			}			
		}
		
		/**
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	모든 cell에 column index를 추가 하면서, cell index와 column index는 갖지 않을 수 있으므로, 반드시 구분하여 사용하여야 한다.
		 */
		public static function getCellIndexByColumnIndex(gridRow:FormGridRow, columnIndex:int):int{
			if(!gridRow) return -1
			for(var cellIndex:int=0; cellIndex<gridRow.length; cellIndex++){
				var gridCell:FormGridCell = gridRow.getCellByIndex(cellIndex);
				var gridColumnIndex:int = gridCell.gridColumnIndex;
				if(gridColumnIndex==columnIndex)
					return cellIndex;
			}
			return -1
		}
		/**
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	모든 cell에 column index를 추가 하면서, cell index와 column index는 갖지 않을 수 있으므로, 반드시 구분하여 사용하여야 한다.
		 * 	그래서, column index를 포함하는 cell index를 돌려 주는 기능을 포함 하였다.
		 */
		public static function getCellIndexByColumnIndexInSpan(gridRow:FormGridRow, columnIndex:int):int{
			if(!gridRow) return -1
			
			for(var cellIndex:int=0; cellIndex<gridRow.length; cellIndex++){
				var gridCell:FormGridCell = gridRow.getCellByIndex(cellIndex);
				var gridColumnIndex:int = gridCell.gridColumnIndex;
				if(gridColumnIndex<columnIndex&&gridColumnIndex+gridCell.span>columnIndex)
					return cellIndex;
			}
			return -1;
		}

		/**
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	모든 cell에 column index를 추가 하면서, cell index와 column index는 갖지 않을 수 있으므로, 반드시 구분하여 사용하여야 한다.
		 * 	Cell인 병합된 경우에는 Cell들중에  특정 column을 없는 경우들이 생기므로, cell이 없는 경우에 추가 될 수 있는 cell index를 반환한다. 
		 */
		public static function getNoneCellIndexByColumnIndex(gridRow:FormGridRow, columnIndex:int):int{
			if(!gridRow) return -1
			if(gridRow.length==0 && gridRow.gridLayout.columnLength>columnIndex) return 0;
			
			for(var cellIndex:int=0; cellIndex<gridRow.length; cellIndex++){
				var gridCell:FormGridCell = gridRow.getCellByIndex(cellIndex);
				var gridColumnIndex:int = gridCell.gridColumnIndex;
				if(gridColumnIndex==columnIndex || (gridColumnIndex<columnIndex&&gridColumnIndex+gridCell.span>columnIndex))
					return -1;
				if(gridColumnIndex>columnIndex)
					return cellIndex;					
			}
			return -1;
		}

		/**
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	모든 cell에 column index를 추가 하면서, cell index와 column index는 갖지 않을 수 있으므로, 반드시 구분하여 사용하여야 한다.
		 * 	Cell인 병합된 경우에는 Cell들중에  특정 column을 없는 경우들이 생기므로, cell이 없는 경우에 추가 될 수 있는 cell index를 반환한다. 
		 */
		public static function getFirstNoneCellIndexByColumnIndex(gridRow:FormGridRow, columnIndex:int):int{
			if(!gridRow) return -1;

			for(var cellIndex:int=0; cellIndex<gridRow.length; cellIndex++){
				var gridCell:FormGridCell = gridRow.getCellByIndex(cellIndex);
				var gridColumnIndex:int = gridCell.gridColumnIndex;
				if(gridColumnIndex==columnIndex || (gridColumnIndex<columnIndex && (gridColumnIndex+gridCell.span)>columnIndex)){
					return -1;
				}
				if(cellIndex==0){
					if(gridColumnIndex>columnIndex){
						break;
					}else if(gridRow.length==1){
						cellIndex=1;
						break;
					}
				}else{
					if(gridColumnIndex>columnIndex){
						var prevGridCell:FormGridCell = gridRow.getCellByIndex(cellIndex-1);
						if( prevGridCell.gridColumnIndex+prevGridCell.span<=columnIndex){
							break;
						}
						return -1;
					}
				}
			}

			var rowIndex:int = gridRow.gridLayout.getRowIndex(gridRow);
			for(var i:int=rowIndex-1; i>=0; i--){
				var targetGridRow:FormGridRow = gridRow.gridLayout.getRowByIndex(i);
				var targetCellIndex:int = FormGridUtil.getCellIndexByColumnIndex(targetGridRow, columnIndex);
				if(targetCellIndex!=-1){
					if(targetGridRow.getCellByIndex(targetCellIndex).rowSpan>(rowIndex-i)){
						return cellIndex;
					}
					return -1;
				}	
			}
			return -1;
		}
		
		public static function getFormDocumentHeight(container:FormDocument):Number{
			var heightSize:Number = 0;
			if(container.layout is FormGridLayout){				
				var gridLayout:FormGridLayout = container.layout as FormGridLayout;
				
				heightSize += container.topSpace;
				heightSize += container.bottomSpace;
				
				for(var i:int = 0 ; i < gridLayout.rowLength ; i++){
					var gridRow:FormGridRow = gridLayout.getRowByIndex(i);
					heightSize += gridRow.size;
					heightSize += 1;
					heightSize += Config.DEFAULT_BORDER_SIZE;
				}
			}
			if(heightSize<Config.MINIMUM_DOCUMENT_HEIGHT)
				return Config.MINIMUM_DOCUMENT_HEIGHT;
			else
				return heightSize;
		}

		public static function traceFormGrid(gridLayout:FormGridLayout):void{
			traceObejct(gridLayout);
			
			for(var i:int = 0 ; i < gridLayout.columnLength ; i++){
				traceObejct(gridLayout.getColumnByIndex(i));
			}
			
			for(var _i:int = 0 ; _i < gridLayout.rowLength ; _i++){
				var targetRow:FormGridRow = gridLayout.getRowByIndex(_i);
				traceObejct(targetRow);
				for(var j:int = 0 ; j < targetRow.length ; j++){
					traceObejct(targetRow.getCellByIndex(j));
				}
			}
		}
		
		public static function traceObejct(obj:Object):void{
			// 컨트롤의 E4X XML 오브젝트 기술을 취득합니다.
            var classInfo:XML = describeType(obj);

            // E4X XML 오브젝트 전체를 ta2 에 덤프 합니다.
            trace(classInfo.toString());

            // 클래스명을 열거합니다.
            trace("Class " + classInfo.@name.toString() + "\n");

            // accessor를  properties 로서 열거합니다.
            for each (var a:XML in classInfo..accessor) {
                 trace("Property " + a.@name + "=" + obj[a.@name] + 
                    " (" + a.@type +") \n");
            }
            
            // 오브젝트의 변수, 변수의 값, 및 변수의 형태를 열거합니다.
            for each (var v:XML in classInfo.variable) {
                trace("Variable " + v.@name + "=" + obj[v.@name] + 
                    " (" + v.@type + ") \n");
            }
		}
		
		public static function isLastGridItem(gridItem:FormGridCell):Boolean{
			var currentIdx:int = gridItem.gridColumnIndex;
			if(gridItem.gridRow.gridLayout.columnLength == currentIdx + gridItem.span){
				return true;
			}
			return false;
		}
		
		public static function getMaxColumnSize(gridLayout:FormGridLayout):int{
			var maxSize:int = gridLayout.columnLength;
			if(maxSize>0) return maxSize;
			
			for(var i:int = 0 ; i < gridLayout.rowLength ; i++){
				var targetRow:FormGridRow = gridLayout.getRowByIndex(i);
				
				var maxRowColSize:int = 0;
				for(var j:int = 0 ; j < targetRow.length ; j++){
					var targetItem:FormGridCell = targetRow.getCellByIndex(j);
					maxRowColSize += targetItem.span;
				}
				
				if(maxSize < maxRowColSize){
					maxSize = maxRowColSize;
				}
			}
			return maxSize;
		}
		
		public static function getColumnWidthArray(gridLayout:FormGridLayout):Array{
			var maxSize:int = getMaxColumnSize(gridLayout);
			
			var colWidthArray:Array = new Array();
			for(var i:int = 0 ; i < maxSize; i++){
				colWidthArray.push(getColumnWidth(gridLayout, i));
			}
			
			return colWidthArray;
		}
		
		public static function getColumnSizeArray(gridLayout:FormGridLayout):Array{
			var maxSize:int = getMaxColumnSize(gridLayout);
			
			var colSizeArray:Array = new Array();
			for(var i:int = 0 ; i < maxSize; i++){
				colSizeArray.push(getColumnSize(gridLayout, i));
			}
			
			return colSizeArray;
		}		
		
		public static function getColumnWidth(gridLayout:FormGridLayout, index:int):Number{
			return getColumnSize(gridLayout, index)["size"];
		}
		
		/**
		 * 	2010.3.18 modified by Y.S.Jung
		 * 	getColumnSize는 SmartWorks V2.0전의 버전을 수용하기 위한 기능중에 하나이다.
		 * 	스마트웍스 초기버전에는 gridLayout이 column을 관리하지 않아 column정보가 없는 가지고 있지 않아서,
		 * 	그런 경우에 대응할 수 있도록 본 기능을 구현한 것이다.
		 * 	본 기능을 V2.0이상 버전에서 작성된 gridLayout model의 column size를 구하기 위하여 호출하면 이상 반응할 수 있다. 
		 */
		public static function getColumnSize(gridLayout:FormGridLayout, index:int):Object{
			// 해당하는 인덱스에 있는 span이 1개인 item 크기 반환
			var sameSpan:Boolean = true;
			var previousSpan:int = -1;
			for(var i:int = 0 ; i < gridLayout.rowLength ; i++){
				var targetRow:FormGridRow  = gridLayout.getRowByIndex(i);
				for(var j:int=0, columnIndex:int=0; j<targetRow.length; j++){
					columnIndex+=targetRow.getCellByIndex(j).span;
					if(index+1<=columnIndex) break;
				}
				if(j==targetRow.length) continue;
				
				var targetItem:FormGridCell = targetRow.getCellByIndex(j);
				if(targetItem != null){
					if(targetItem.span == 1){
						if(gridLayout.container != null && targetItem.fieldId != null){
							var formField:FormEntity = FormModelUtil.getFormFieldById(targetItem.fieldId, gridLayout.container);
							return {size : targetItem.size, labelSize : formField.labelWidth};
						}else{
							return {size : targetItem.size, labelSize : (targetItem.size < Config.DEFAULT_LABEL_WIDTH)?targetItem.size: Config.DEFAULT_LABEL_WIDTH};
						}
					}
					if(sameSpan)
						if(previousSpan == -1){
							previousSpan = targetItem.span;
						}else if(previousSpan != targetItem.span){
							sameSpan = false;
						}
				}
			}
			// span이 모두 같은 경우해당하는 인덱스에 있는  item을 나누어서 반환 크기 반환
			if(!sameSpan){
				if(gridLayout.rowLength > 0){
					var _targetRow:FormGridRow  = gridLayout.getRowByIndex(0);
					for(j=0, columnIndex=0; j<targetRow.length; j++){
						columnIndex+=targetRow.getCellByIndex(j).span;
						if(index+1<=columnIndex) break;
					}
					if(j==targetRow.length) return {size : 0, labelSize : 0};
				
					var _targetItem:FormGridCell = _targetRow.getCellByIndex(j);
					if(gridLayout.container != null && _targetItem.fieldId != null){
						var _formField:FormEntity = FormModelUtil.getFormFieldById(_targetItem.fieldId, gridLayout.container);
						return {size :(_targetItem.size / _targetItem.span), labelSize : _formField.labelWidth};
					}else{
						return {size : (_targetItem.size / _targetItem.span), labelSize : ((_targetItem.size / _targetItem.span) < Config.DEFAULT_LABEL_WIDTH)?(_targetItem.size / _targetItem.span): Config.DEFAULT_LABEL_WIDTH};
					}
				}
			}
			// TODO
			return {size : 0, labelSize : 0};
		}
		
		public static function getColumn(gridRow:FormGridRow, index:int):FormGridCell{
			var targetIndex:int = 0;
			for(var i:int = 0 ; i < gridRow.length ; i++){
				var targetItem:FormGridCell  = gridRow.getCellByIndex(i);
				
				if(targetIndex == index){
					return targetItem;
				}
				
				targetIndex += targetItem.span;
			}
			return null;
		}
		public static function getItemWithSpan(gridRow:FormGridRow, index:int):FormGridCell{
			var targetIndex:int = 0;
			for(var i:int = 0 ; i < gridRow.length ; i++){
				var targetItem:FormGridCell  = gridRow.getCellByIndex(i);
				
				if(targetIndex <= index && index <= (targetIndex + targetItem.span - 1)){
					return targetItem;
				}
				
				targetIndex += targetItem.span;
			}
			return null;
		}		
		public static function getFormGridItemByFieldId(gridLayout:FormGridLayout, fieldId:String):FormGridCell{
			var targetIndex:int = 0;
			for(var i:int = 0 ; i < gridLayout.rowLength ; i++){
				var gridRow:FormGridRow  = gridLayout.getRowByIndex(i);
				for(var j:int = 0 ; j < gridRow.length ; j++){
					var gridItem:FormGridCell  = gridRow.getCellByIndex(j);
					if(gridItem.fieldId != null && gridItem.fieldId == fieldId){
						return gridItem;
					}
				}				
			}
			return null;
		}
		public static function getFormGridItemViewByFieldId(gridLayoutView:FormGridContainer, fieldId:String):FormGridItemView{
			for(var i:int = 0 ; i < gridLayoutView.numChildren ; i++){
				var gridRowView:FormGridRowView  = gridLayoutView.getChildAt(i) as FormGridRowView;
				for(var j:int = 0 ; j < gridRowView.numChildren ; j++){
					var gridItemView:FormGridItemView  = gridRowView.getChildAt(j) as FormGridItemView;
					if(gridItemView.gridCell.fieldId != null && gridItemView.gridCell.fieldId == fieldId){
						return gridItemView;
					}
				}				
			}
			return null;
		}

		/**
		 * 	2010.3.15 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
		 * 	모든 cell에 column index를 추가 하면서, cell index와 column index는 갖지 않을 수 있으므로, 반드시 구분하여 사용하여야 한다.
		 * 	row index와 column index로 Grid Item을 찾는 기능이다.
		 */
		public static function getFormGridItemViewByRowColIndex(gridLayoutView:FormGridContainer, rowIndex:int, columnIndex:int):FormGridItemView{
			var gridRowView:FormGridRowView  = gridLayoutView.getChildAt(rowIndex) as FormGridRowView;
			for(var cellIndex:int = 0 ; cellIndex < gridRowView.numChildren ; cellIndex++){
				var gridItemView:FormGridItemView  = gridRowView.getChildAt(cellIndex) as FormGridItemView;
				if(gridItemView.gridCell.gridColumnIndex == columnIndex){
					return gridItemView;
				}
			}
			return null;
		}
		public static function getColumnNumber(gridCell:FormGridCell):int{
			for(var i:int = 0 ; i < gridCell.gridRow.gridLayout.columnLength ; i++){
				var targetItem:FormGridCell  = FormGridUtil.getItemWithSpan(gridCell.gridRow, i);
				
				if(gridCell == targetItem){
					return i;
				}
			}
			return -1;
		}	
		
		public static function getCellWidth(gridCell:FormGridCell):Number{
			var cellWidth:Number = 0;
			
			var targetIndex:int = getColumnNumber(gridCell);
			for(var i:int = 0 ; i < gridCell.span ; i++){
				var gridCol:FormGridColumn = gridCell.gridRow.gridLayout.getColumnByIndex(i + targetIndex);
				cellWidth += gridCol.size;
			}
			return cellWidth;
		}		
	}
}