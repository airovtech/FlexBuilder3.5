////////////////////////////////////////////////////////////////////////////////
//  ComboBoxPropertyEditor.as
//  2008.02.27, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.ComboBox;
	import mx.events.ListEvent;
	
	/**
	 * 콤보박스를 이용한 프로퍼티 에디터의 기반 클래스
	 */
	public class ComboBoxPropertyEditor extends ComboBox implements IPropertyEditor	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _pageItem: PropertyPageItem;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function ComboBoxPropertyEditor() {
			super();
			
			setStyle("fillAlphas", [1, 1]);
			setStyle("fillColors", [0xffffff, 0xffffff]);
			setStyle("focusThickness", 0);
			setStyle("highlightAlphas", [1, 1]);
			setStyle("fontWeight", "normal");
			setStyle("paddingLeft", 0);
			setStyle("cornerRadius", 0);
			setStyle("fontName", "Tahoma");
			setStyle("fontSize", 11);
		}
		
		override protected function createChildren():void {
			super.createChildren();
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
//			this.setFocus();

			addEventListener(ListEvent.CHANGE, doChange);
			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;

			removeEventListener(ListEvent.CHANGE, doChange);
			removeEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			return selectedItem;
		}
		
		public function set editValue(value: Object): void {
			selectedItem = value;	
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function setEditable(val: Boolean): void {
			this.editable = val;
		}

		public function get isDialog(): Boolean {
			return false;
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * pageItem
		 */
		protected function get pageItem(): PropertyPageItem {
			return _pageItem;
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doChange(event: ListEvent): void {
			PropertyPageItem(this.parent).acceptEditValue();
		}
		
		protected function doKeyDown(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.DOWN) {
				this.open();
				event.stopImmediatePropagation();
			}
		}
	}
}