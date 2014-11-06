////////////////////////////////////////////////////////////////////////////////
//  ColorPropertyEditor.as
//  2008.03.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.PropertyPageItem;
	import com.maninsoft.smart.workbench.common.util.StringUtils;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.ColorPicker;
	import mx.controls.TextInput;
	import mx.events.ColorPickerEvent;
	import mx.events.DropdownEvent;
	
	/**
	 * 색상 속성 에디터
	 */
	public class ColorPropertyEditor extends HBox implements IPropertyEditor	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _pageItem: PropertyPageItem;
		private var _textInput: TextInput;
		private var _colorPicker: ColorPicker;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ColorPropertyEditor() {
			super();
			setStyle("horizontalGap", 0);

			_textInput = new TextInput();
			_textInput.percentWidth = 100;
			_textInput.percentHeight = 100;

			// css로 처리할 것.
			_textInput.setStyle("fontName", "verdana");
			_textInput.setStyle("fontSize", 11);
			
			addChild(_textInput);
			
			_colorPicker = new ColorPicker();
			_colorPicker.width = 21;
			_colorPicker.percentHeight = 100;
			_colorPicker.addEventListener(ColorPickerEvent.CHANGE, doColorPickerChange);
			_colorPicker.addEventListener("close", doColorPickerClose);
			
			addChild(_colorPicker);
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}
		
		override protected function createChildren(): void {
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
//			_textInput.setFocus();

			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		/**
		 * 편집기를 숨긴다.
		 */
		public function deactivate(): void {
			this.visible = false;

			addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
		}
		
		public function get editValue(): Object {
			//return _colorPicker.selectedColor;
			return StringUtils.colorToNumber(_textInput.text);
		}
		
		public function set editValue(val: Object): void {
			_colorPicker.selectedColor = uint(val);
			_textInput.text = _colorPicker.selectedColor.toString(16);
		}
		
		public function setBounds(x: Number, y: Number, width: Number, height: Number): void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function setEditable(val: Boolean): void {
			_textInput.editable = val;
			_colorPicker.editable = val;
		}

		public function get isDialog(): Boolean {
			return false;
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				case Keyboard.DOWN:
					_colorPicker.open();
					event.stopImmediatePropagation();
					break;
			}
			
			if (event.target == _colorPicker) {
				event.stopImmediatePropagation();
			}
		}

		//------------------------------
		// colorPicker
		//------------------------------
		
		protected function doColorPickerChange(event: ColorPickerEvent): void {
			_textInput.text = _colorPicker.selectedColor.toString(16);
			_pageItem.acceptEditValue();
		}
		
		protected function doColorPickerClose(event: DropdownEvent): void {
			_pageItem.setFocus();
		}
	}
}