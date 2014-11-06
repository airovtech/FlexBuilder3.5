/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.model
 *  Class: 			FormGridRow
 * 					extends SelectableModel
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서, Form Document의 Grid Layout밑의 Grid Row를 정의하는 모델 클래스
 * 					Form에 관한 Model구조는 아래와 같이 구성 되어있다.
 * 
 * 						FormDocumnet --> FormLayout --> FormGridLayout --> FormGridRow --> FormGridCell
 * 																	   --> FormGridColumn
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능
 * 														모델정의를 서버에서 가져와서 로드할 시에(parseXML), 하위모델을 호출할때 상위모델 레퍼런스를 전달한다.
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.model
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.SelectableModel;
	
	import mx.collections.ArrayCollection;
	
	public class FormGridRow extends SelectableModel
	{
		public function FormGridRow(gridLayout:FormGridLayout = null)
		{
			this.gridLayout = gridLayout;
		}

		private function get variableRatio():Number{
			if(gridLayout && gridLayout.container)
				return FormDocument(gridLayout.container).variableRatio;
			return 1;
		}
		private var _gridLayout:FormGridLayout;
		public function set gridLayout(gridLayout:FormGridLayout):void{
		    this._gridLayout = gridLayout;
		}
		public function get gridLayout():FormGridLayout{
		    return this._gridLayout;
		}
		
		// 행의 크기
		private var _size:Number = Config.DEFAULT_ROW_HEIGHT;
		public function set size(size:Number):void{
		    this._size = size;
		    this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO));
			trace("[Event]FormGridRow size updated : " + _size + ", event : " + FormLayoutEvent.UPDATE_LAYOUT_INFO);
		}
		public function get size():Number{
		    return this._size;
		}
		
		// 행에 속하는 셀
		private var _cells:ArrayCollection;		
		private function getCells():ArrayCollection{
			if(_cells == null)
				_cells = new ArrayCollection();
				
			return _cells;
		}
		public function addCell(cell:FormGridCell, index:int = -1):void{
			var realIndex:int = (index == -1)?getCells().length:index;
						
			getCells().addItemAt(cell, realIndex);	
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
			trace("[Event]FormGridRow addCell dispatch event : " + FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE);
		}
		public function removeCell(cell:FormGridCell):Boolean{
			var index:int = getCells().getItemIndex(cell);
			if(index < 0)
				return false;
			getCells().removeItemAt(index);
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
			trace("[Event]FormGridRow removeCell dispatch event : " + FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE);
		    return true;
		}		
		public function removeCellByIndex(index:int):Boolean{
			try{
				 getCells().removeItemAt(index);
				 this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
				trace("[Event]FormGridRow removeCellByIndex dispatch event : " + FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE);
				 return true;
			}catch(e:Error){
			}
			return false;
		}		
		public function removeAllCell():void{
		    getCells().removeAll();
		    this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
			trace("[Event]FormGridRow removeAllCell dispatch event : " + FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE);
		}		
		public function getCellIndex(cell:FormGridCell):int{
			var index:int = getCells().getItemIndex(cell);
			return index;
		}		
		public function getCellByIndex(index:int):FormGridCell{
			if(index==-1) return null;
			
			return getCells().getItemAt(index) as FormGridCell;
		}
		
		public function get length():int{
			return getCells().length;
		}
		
		/**
		 * XML로 변환
		 */ 		
		public function toXML():XML{
			var modelXml:XML = 
				<gridRow size="">
				</gridRow>;
				
			modelXml.@size = size;
			
			for(var i:int = 0 ; i < getCells().length ; i++){
				var gridItem:FormGridCell = getCellByIndex(i);
				modelXml.appendChild(gridItem.toXML());
			}
			
			return modelXml;
		}	

		/**
		 * 	XML을 객체로 생성
		 * 
		 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
		 * 	상위모델인 FormGridLayout에서 호출시 본인레퍼런스를 전달하기 때문에, 입력 argument에 gridLayout을 추가하고,
		 * 	FormGridRow생성시에 gridLayout을 저장할 수 있도록 입력한다.
		 */
		public static function parseXML(gridLayout:FormGridLayout, rowXML:XML):FormGridRow{
			/**
			 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 * 	FormGridRow생성시 FormLayout 레퍼런스를 저장한다.
			 */
			var gridRow:FormGridRow = new FormGridRow(gridLayout);
			gridRow.size = rowXML.@size;
			
			for each(var gridCellXML:XML in rowXML.gridCell)
			{
			/**
			 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 * 	하위모델인 FormGridCell호출시 본인의 레퍼런스인 gridRow를 전달한다.
			 */
				var gridCell:FormGridCell = FormGridCell.parseXML(gridRow, gridCellXML);
			    gridRow.addCell(gridCell);
			}
			
			return gridRow;
		}
	}
}