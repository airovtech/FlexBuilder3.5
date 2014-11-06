////////////////////////////////////////////////////////////////////////////////
//  EllipsisPropertyEditor.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	/**
	 * 버튼을 클릭한 후 표시되는 다이얼로그 등을 통해 속성을 편집하는 에디터
	 */
	public class EllipsisPropertyEditor extends Button implements IPropertyEditor {

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		public static const BUTTON_WIDTH: Number = 30;


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _pageItem: PropertyPageItem;
		private var _editValue: Object;
		private var _clickHandler: Function;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EllipsisPropertyEditor() {
			super();
			
			label = "...";
			setStyle("fillAlphas", [1,1]);
			setStyle("focusThickness", 0);
			
			addEventListener(MouseEvent.CLICK, doClick);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * clickHandler
		 */
		public function set clickHandler(value: Function): void {
			_clickHandler = value;
		}
		

		//----------------------------------------------------------------------
		// IPropertyEditor
		//----------------------------------------------------------------------
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		public function activate(pageItem: PropertyPageItem): void {
			_pageItem = pageItem;
			
			this.visible = true;
			this.setFocus();
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			return _editValue;
		}
		
		public function set editValue(val: Object): void {
			if(_editValue == val) return;
			_editValue = val;
			
			// 프로퍼티 view에 바로 반영한다.
			if (_pageItem)
				_pageItem.editValue = val;	
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x + width - BUTTON_WIDTH;
			this.y = y;
			this.width = BUTTON_WIDTH;
			this.height = height;
		}
		
		public function setEditable(val: Boolean): void {
			this.enabled = val;
		}

		public function get isDialog(): Boolean {
			return true;
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doClick(event: Event): void {
			if (_clickHandler != null) {
				_clickHandler(this);
			}		
		}
	}
}