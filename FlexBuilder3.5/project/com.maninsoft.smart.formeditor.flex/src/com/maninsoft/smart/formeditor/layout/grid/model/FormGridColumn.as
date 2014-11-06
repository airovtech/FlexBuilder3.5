/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.layout.grid.model
 *  Class: 			FormGridColumn
 * 					extends EventDispatcher
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서, Form Document의 Grid Layout 밑의 Grid Column을 정의하는 모델 클래스
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
	import com.maninsoft.smart.formeditor.model.FormDocument;
	
	import flash.events.EventDispatcher;
	
	public class FormGridColumn extends EventDispatcher
	{
		public function FormGridColumn(gridLayout:FormGridLayout = null)
		{
			this.gridLayout = gridLayout;
		}

		private function get variableRatio():Number{
			if(this.gridLayout && this.gridLayout.container)
				return FormDocument(this.gridLayout.container).variableRatio;
			return 1;
		}

		private var _gridLayout:FormGridLayout;		
		public function set gridLayout(gridLayout:FormGridLayout):void{
		    this._gridLayout = gridLayout;
		}
		public function get gridLayout():FormGridLayout{
		    return this._gridLayout;
		}
		
		private var _labelSize:Number = Config.DEFAULT_LABEL_WIDTH;
		public function set labelSize(labelSize:Number):void{
		    this._labelSize = labelSize/this.variableRatio;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
			trace("[Event]FormGridColumn labelSize updated : " + _labelSize + ", event : " + event);
		}
		public function get labelSize():Number{
		    return this._labelSize*this.variableRatio;
		}
		
		private var _size:Number;
		public function set size(size:Number):void{
		    this._size = size/this.variableRatio;
		    var event:FormLayoutEvent = new FormLayoutEvent(FormLayoutEvent.UPDATE_LAYOUT_INFO);
		    this.dispatchEvent(event);
			trace("[Event]FormGridColumn size updated : " + _size + ", event : " + event);
		}
		public function get size():Number{
		    return this._size*this.variableRatio;
		}
		
		public function get fixedSize():Number{
			return this._size;
		}
		/**
		 * XML로 변환
		 */ 		
		public function toXML():XML{
			var modelXml:XML = 
				<gridColumn size="" labelSize=""/>;
				
			modelXml.@size = size;
			modelXml.@labelSize = labelSize;
			
			return modelXml;
		}	
		/**
		 * XML을 객체로 생성
		 * 
		 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
		 * 	상위모델인 FormGridLayout에서 호출시 본인레퍼런스를 전달하기 때문에, 입력 argument에 gridLayout을 추가하고,
		 * 	FormGridRow생성시에 gridLayout을 저장할 수 있도록 입력한다.
		 */
		public static function parseXML(gridLayout:FormGridLayout, colXML:XML):FormGridColumn{
			/**
			 * 	2010.3.11 Modified by Y.S. Jung for SWV20001 : 폼빌더에서 하나 이상의 열을 병합/해제할 수 기능
			 * 	FormGridColumn생성시 FormLayout 레퍼런스를 저장한다.
			 */
			var gridCol:FormGridColumn = new FormGridColumn(gridLayout);
			gridCol.size = colXML.@size;
			gridCol.labelSize = colXML.@labelSize;
			
			return gridCol;
		}
	}
}