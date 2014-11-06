////////////////////////////////////////////////////////////////////////////////
//  ColorPropertyPageItem.as
//  2008.04.16, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property.page
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import mx.core.FlexSprite;
	
	/**
	 * 색 속성을 처리하는 아이템
	 */
	public class ColorPropertyPageItem extends PropertyPageItem {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: TextField;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ColorPropertyPageItem(propertyPage:PropertyPage) {
			super(propertyPage);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function createValueField(): DisplayObject {
			var fld: FlexSprite = new FlexSprite();
			//var fld: UIComponent = new UIComponent();
			
			_textField = new TextField();
			_textField.defaultTextFormat = defaultTextFormat;
			_textField.mouseEnabled = false;
			_textField.background = false;
			fld.addChild(_textField);
			
			return fld;
		}
		
		override protected function setValueField(value: Object): void {
			_textField.text = propInfo.getText(value);
		}

		override protected function updateValueField(x: Number, y: Number, width: Number, height: Number, bgCol: uint): void {
			var fld: FlexSprite = super.valueField as FlexSprite;
			//var fld: UIComponent = super.valueField as UIComponent;
			var g: Graphics = fld.graphics;
			g.clear();
			
			fld.x = x;
			fld.y = y;
			//fld.width = width;
			//fld.height = height;

			_textField.x = 24;
			_textField.y = 0;
			_textField.width = width - 24;
			_textField.height = height;

			//g.beginFill(bgCol);
			g.lineStyle();
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			g.beginFill(Number(editValue));
			g.lineStyle(1, 0);
			g.drawRect(4, 4, 15, 15);
			g.endFill();
		}
		
		override protected function doKeyDown(event: KeyboardEvent): void {
			switch (event.keyCode) {
				default:
					super.doKeyDown(event);
					break;
			}		
		}
	}
}