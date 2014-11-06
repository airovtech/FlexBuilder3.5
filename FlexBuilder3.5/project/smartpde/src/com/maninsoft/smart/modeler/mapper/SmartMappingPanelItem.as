////////////////////////////////////////////////////////////////////////////////
//  SmartMappingPanelItem.as
//  2007.01.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mx.core.UITextField;
	
	/**
	 * SmartMapperPanel 의 항목 view
	 */
	public class SmartMappingPanelItem extends Sprite {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: UITextField;
		private var _textFormat: TextFormat;
	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SmartMappingPanelItem(item: IMappingItem, width: int, height: int) {
			super();		
			
			_item = item;
			
			_textField = new UITextField();
			_textField.y = 2;
			_textField.width = width;
			_textField.height = height;
			_textField.mouseEnabled = false;
			_textField.text = item.label;

			_textFormat = new TextFormat();
			_textFormat.align = "center";

			addChild(_textField);
		}
	

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
	
		//------------------------------
		// panel
		//------------------------------
		
		public function get panel(): SmartMappingPanel {
			return parent as SmartMappingPanel;
		}
	
		//------------------------------
		// itemWidth
		//------------------------------
		
		private var _item: IMappingItem;
		
		public function get item(): IMappingItem {
			return _item;
		}

		//------------------------------
		// itemWidth
		//------------------------------
		
		public function get itemWidth(): int {
			return _textField.width;
		}
		
		public function set itemWidth(value: int): void {
			if (value != itemWidth) {
				_textField.width = value;
				draw();
			}
		}
	
		//------------------------------
		// itemHeight
		//------------------------------
		
		public function get itemHeight(): int {
			return _textField.height;
		}
		
		public function set itemHeight(value: int): void {
			if (value != itemHeight) {
				_textField.height = value;
				draw();
			}
		}
	
		//------------------------------
		// text
		//------------------------------
		
		public function get text(): String {
			return _textField.text;
		}
		
		public function set text(value: String): void {
			if (value != text) {
				_textField.text = value;
				draw();
			}
		}
		
		//------------------------------
		// bounds
		//------------------------------
		
		public function get bounds(): Rectangle {
			return new Rectangle(parent.x + x, parent.y + y, width, height);
		}
		
		//------------------------------
		// connectPoint
		//------------------------------
		
		public function get connectPoint(): Point {
			var r: Rectangle = bounds;
			
			return isSource ? new Point(r.x + r.width - 10, r.y + r.height / 2)
			                 : new Point(r.x + 10, r.y + r.height / 2);
		}
		
		//------------------------------
		// isSource
		//------------------------------
		
		public function get isSource(): Boolean {
			return panel.panelType == SmartMappingPanel.SOURCE_PANEL;
		}
		
	

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function draw(): void {
			_textField.wordWrap = false;
			_textField.textColor = 0x00000;

			_textField.setTextFormat(_textFormat);
		}
	}
}