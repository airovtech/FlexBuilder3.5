/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.model
 *  Class: 			FormGridLayout
 * 					extends FormLayout
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form Document Grid Layout을 정의하는 모델 클래스
 * 					Form에 관한 Model구조는 아래와 같이 구성 되어있다.
 * 
 * 						FormDocumnet --> FormLayout --> FormGridLayout --> FormGridRow --> FormGridCell
 * 																	   --> FormGridColumn
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 														모델정의를 서버에서 가져와서 로드할 시에(parseXML), 하위모델을 호출할때 상위모델 레퍼런스를 전달한다.
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.model
{
	import com.maninsoft.smart.formeditor.Config;
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.layout.model.FormLayout;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	
	import mx.collections.ArrayCollection;
	
	public class FormGridLayout extends FormLayout
	{
		public function FormGridLayout()
		{
		}
		
		// 행에 속하는 셀
		private var _rows:ArrayCollection;		
		private function getRows():ArrayCollection{
			if(_rows == null)
				_rows = new ArrayCollection();
				
			return _rows;
		}
		public function addRow(row:FormGridRow, index:int = -1):void{
			if(index == -1)
				getRows().addItem(row);
			else
				getRows().addItemAt(row, index);
			
			this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		}
		public function removeRow(row:FormGridRow):Boolean{
			var index:int = getRows().getItemIndex(row);
			if(index < 0)
				return false;
			getRows().removeItemAt(index);
			
			this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		    return true;
		}
		public function removeRowByIndex(index:int):Boolean{
			try{
				 getRows().removeItemAt(index);
				 this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
				 this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
				 return true;
			}catch(e:Error){
			}
			return false;
		}
		public function removeAllRow():void{
		    getRows().removeAll();
		    this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		    this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		}
		public function getRowIndex(row:FormGridRow):int{
			var index:int = getRows().getItemIndex(row);
			return index;
		}
		public function getRowByIndex(index:int):FormGridRow{
			return getRows().getItemAt(index) as FormGridRow;
		}
		public function get rowLength():int{
			return getRows().length;
		}
		
		public function get layoutFixedWidth():Number{
			var width:Number = 0;
			for each(var col:FormGridColumn in getColumns()){
				width += col.fixedSize;
			}
			return width;
		}
		
		// 행에 속하는 셀
		private var _columns:ArrayCollection;		
		private function getColumns():ArrayCollection{
			if(_columns == null)
				_columns = new ArrayCollection();
				
			return _columns;
		}
		public function addColumn(column:FormGridColumn, index:int = -1):void{
			if(index == -1)
				getColumns().addItem(column);
			else
				getColumns().addItemAt(column, index);
			
			this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));	
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		}
		public function removeColumn(column:FormGridColumn):Boolean{
			var index:int = getColumns().getItemIndex(column);
			if(index < 0)
				return false;
			getColumns().removeItemAt(index);
			
			this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
			this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		    return true;
		}
		public function removeColumnByIndex(index:int):Boolean{
			try{
				 getColumns().removeItemAt(index);
				 this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
				 this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
				 return true;
			}catch(e:Error){
			}
			return false;
		}
		public function removeAllColumn():void{
		    getColumns().removeAll();
		    this.dispatchEvent(new FormPropertyEvent(FormPropertyEvent.UPDATE_FORM_STRUCTURE));
		    this.dispatchEvent(new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE));
		}
		public function getColumnIndex(column:FormGridColumn):int{
			var index:int = getColumns().getItemIndex(column);
			return index;
		}
		public function getColumnByIndex(index:int):FormGridColumn{
			return getColumns().getItemAt(index) as FormGridColumn;
		}
		public function get columnLength():int{
			return getColumns().length;
		}
		
		/**
		 * XML로 변환
		 */ 		
		override public function toXML():XML{
			var modelXml:XML = 
				<layout>
					<columns>
					</columns>
				</layout>;
			
			modelXml.@type = FormLayout.GRID;	
			
			for(var i:int = 0 ; i < getRows().length ; i++){
				var gridRow:FormGridRow = getRowByIndex(i);
				modelXml.appendChild(gridRow.toXML());
			}
			
			for(var _i:int=0; _i<getColumns().length; _i++){
				var gridColumn:FormGridColumn = getColumnByIndex(_i);
				modelXml.columns[0].appendChild(gridColumn.toXML());
			}
			return modelXml;
		}	

		/**
		 * XML을 객체로 생성
		 */
		public static function parseXML(layoutXML:XML):FormLayout{
			var gridLayout:FormGridLayout = new FormGridLayout();
			
			if(layoutXML.columns[0] != null){
				for each(var gridColumnXML:XML in layoutXML.columns[0].gridColumn)
				{
					/**
					 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
					 * 	하위모델인 GridColumn을 호출할 시에 본인의 레퍼런스인  gridLayout을 전달한다.
					 */
					var gridColumn:FormGridColumn = FormGridColumn.parseXML(gridLayout, gridColumnXML);
				    gridLayout.addColumn(gridColumn);
				}
			}
			
			for each(var gridRowXML:XML in layoutXML.gridRow)
			{
					/**
					 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
					 * 	하위모델인 GridRow을 호출할 시에 본인의 레퍼런스인  gridLayout을 전달한다.
					 */
				var gridRow:FormGridRow = FormGridRow.parseXML(gridLayout, gridRowXML);
			    gridLayout.addRow(gridRow);
			}
			
			if(gridLayout.columnLength==0){
				FormGridUtil.createGridColumnInfo(gridLayout);
			}			
			return gridLayout;
		}	
	}
}