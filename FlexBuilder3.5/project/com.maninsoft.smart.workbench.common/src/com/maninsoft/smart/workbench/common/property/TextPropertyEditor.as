////////////////////////////////////////////////////////////////////////////////
//  TextPropertyEditor.as
//  2008.01.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	
	/**
	 * 문자열 속성을 편집하는 에디터
	 */
	public class TextPropertyEditor extends TextInput implements IPropertyEditor	{

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function TextPropertyEditor() {
			super();

			setStyle("focusThickness", 1);

			// css로 처리할 것.
			setStyle("fontName", "Tahoma");
			setStyle("fontSize", 11);
		}

		override protected function createChildren(): void {
			super.createChildren();
			// 한글 입력 빠르게
			textField.alwaysShowSelection = true;
		}


		//----------------------------------------------------------------------
		// IPropertyEditor
		//----------------------------------------------------------------------
		
		/**
		 * 편집기를 표시하고 입력 가능한 상태로 만든다.
		 */
		public function activate(pageItem: PropertyPageItem): void {
			this.visible = true;
//			this.setFocus();

			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
			addEventListener(Event.CHANGE, doChange);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;

			removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			removeEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기에 값을 가져오거나 설정한다.
		 */
		public function get editValue(): Object {
			return this.text;
		}
		
		public function set editValue(val: Object): void {
			this.text = val ? val.toString() : "";	
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
		// Event handlers
		//----------------------------------------------------------------------

		protected function doMouseDown(event: MouseEvent): void {
		}		
		
		protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
				case Keyboard.RIGHT:
					event.stopImmediatePropagation();
					break;
			}		
		}
		
		protected function doChange(event:Event): void {
			PropertyPageItem(this.parent).acceptEditValue();
		}
	}
}