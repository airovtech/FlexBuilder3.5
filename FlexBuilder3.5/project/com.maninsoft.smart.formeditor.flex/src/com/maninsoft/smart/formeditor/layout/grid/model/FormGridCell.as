/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.model
 *  Class: 			FormGridCell
 * 					extends SelectableModel
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 FormGridCell의 Model 클래스
 *					<Form관련 Model 구조>
 * 					FormDocument->FormLayout->FormGridLayout->FormGridRow->FormGridCell
 * 															->FormGridColumn
 * 					
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.5 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 					2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
 * 														모델정의를 서버에서 가져와서 로드할 시에(parseXML), 하위모델을 호출할때 상위모델 레퍼런스를 전달한다.
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.layout.grid.model
{
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.layout.grid.util.FormGridUtil;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.SelectableModel;
	
	public class FormGridCell extends SelectableModel
	{
		/**
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는 기능
		 * 	FormGridCell이 GridColumn정보도 같이 가지고 있을 수 있도록, 생성자에 gridColumn을 추가 한다.
		 */
		public function FormGridCell(gridRow:FormGridRow, gridColumn:FormGridColumn=null)
		{
			this.gridRow = gridRow;
			this.gridColumn = gridColumn;
		}
		
		private function get variableRatio():Number{
			if(gridRow && gridRow.gridLayout && gridRow.gridLayout.container)
				return FormDocument(gridRow.gridLayout.container).variableRatio;
			return 1;
		}
		
		private var _gridRow:FormGridRow;
		public function set gridRow(gridRow:FormGridRow):void{
		    this._gridRow = gridRow;
		}
		public function get gridRow():FormGridRow{
		    return this._gridRow;
		}
		public function get gridRowIndex():int{
			if(_gridRow)
				return this._gridRow.gridLayout.getRowIndex(_gridRow);
			return -1;
		}
		
		/**
		 * 2010.3.10 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능 
 	 	 * cell에 column인덱스가 없어서 row들 병합된 경우 처음 아래에 있는 row들의 cell들의 위치가 달라져서,
 	 	 *  각 cell들에게 column인덱스를 기록한다.
 	 	*/
 	 	private var _gridColumn:FormGridColumn;
		public function get gridColumn():FormGridColumn{
			return _gridColumn;
		}
		public function set gridColumn(gridColumn:FormGridColumn):void{
			_gridColumn=gridColumn;
		}
		public function get gridColumnIndex():int{
			if(_gridRow)
				return this._gridColumn.gridLayout.getColumnIndex(_gridColumn);
			return -1;
		}
		
		/**
		 * 2010.3.5 modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 있는  기능 
 	 	 * cell의 span은 row와 column을 같이 표현할 수 있도록 rowSpan을 추가하고, 기존의 span은 column span만을 의미함
 	 	*/
		// 셀의 row span
		private var _rowSpan:int = 1;
		public function set rowSpan(span:int):void{
		    this._rowSpan = span;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
		    trace("[Event]FormGridCell rowSpan Updated : " + _rowSpan + ", event : " + event);
		}
		public function get rowSpan():int{
		    return this._rowSpan;
		}

		// 셀의 colulmn span
		private var _span:int = 1;
		public function set span(span:int):void{
		    this._span = span;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
		    trace("[Event]FormGridCell span Updated : " + _span + ", event : " + event);
		}
		public function get span():int{
		    return this._span;
		}

		// 셀의 크기
		private var _size:Number = 100;
		public function set size(size:Number):void{
		    this._size = size/this.variableRatio;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
			trace("[Event]FormGridCell size updated : " + _size + ", event : " + event);
		}
		public function get size():Number{
		    return this._size*this.variableRatio;
		}
		// 셀에 들어갈 필드 아이디
		private var _fieldId:String;
		public function set fieldId(fieldId:String):void{
		    this._fieldId = fieldId;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
			trace("[Event]FormGridCell fieldId updated : " + _fieldId + ", event : " + event);
		}
		public function get fieldId():String{
		    return this._fieldId;
		}
		
		/**
		 * 	XML로 변환
		 *	
		 * 	2010.3.10 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
		 * 	rowSpan과 gridColumnIndex를 XML에 저장한다. 
		 */ 		
		public function toXML():XML{
			var modelXml:XML = 
				<gridCell size="" span="" rowSpan="" gridColumnIndex="" fieldId=""/>;
				
			modelXml.@size = size;
			modelXml.@span = span;
			modelXml.@rowSpan = rowSpan;
			modelXml.@gridColumnIndex = this.gridColumnIndex;
			if(fieldId != null)
				modelXml.@fieldId = fieldId;

			return modelXml;
		}	
		/**
		 * XML을 객체로 생성
		 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
		 * 	상위모델인 FormGridRow에서 호출시 본인레퍼런스를 전달하기 때문에, 입력 argument에 gridRow을 추가하고,
		 * 	FormGridCell생성시에 gridRow을 저장할 수 있도록 입력한다.
		 * 	그리고, rowSpan과 gridColumnIndex를 추가 한다.
		 */
		public static function parseXML(gridRow:FormGridRow, cellXML:XML):FormGridCell{
			var gridCell:FormGridCell = new FormGridCell(gridRow);
			var gridColumnIndex:int = -1;

			gridCell.size = cellXML.@size;
			gridCell.span = cellXML.@span;
			gridCell.rowSpan = cellXML.@rowSpan;
			if(gridCell.rowSpan<1) gridCell.rowSpan=1;
			if(cellXML.attribute("gridColumnIndex").toString() != "")
				gridColumnIndex = cellXML.@gridColumnIndex;
				
			if(gridRow.gridLayout.columnLength>0)
				FormGridUtil.setGridColumn(gridCell, gridColumnIndex);

			if(cellXML.attribute("fieldId").toString() != "")
				gridCell.fieldId = cellXML.@fieldId;
			
			return gridCell;
		}
	}
}