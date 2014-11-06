////////////////////////////////////////////////////////////////////////////////
//  SmartMappingPanelHead.as
//  2007.01.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mx.core.UITextField;
	
	/**
	 * SmartMapperPanel 의 head view
	 */
	public class SmartMappingPanelHead extends Sprite implements IDraggable {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: UITextField;
		private var _textFormat: TextFormat;
	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SmartMappingPanelHead(width: int, height: int) {
			super();		
			
			_textField = new UITextField();
			_textField.y = 3;
			_textField.width = width;
			_textField.height = height;
			_textField.mouseEnabled = false;

			_textFormat = new TextFormat();
			_textFormat.align = "center";

			addChild(_textField);
			
			addEventListener(MouseEvent.CLICK, doClick);
		}
	

		//----------------------------------------------------------------------
		// IDraggable
		//----------------------------------------------------------------------
		
		public function getDragTracker(event: MouseEvent): DragTracker {
			return new PanelDragTracker(parent as SmartMappingPanel);
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
		// headWidth
		//------------------------------
		
		public function get headWidth(): int {
			return _textField.width;
		}
		
		public function set headWidth(value: int): void {
			if (value != headWidth) {
				_textField.width = value;
				draw();
			}
		}
	
		//------------------------------
		// headHeight
		//------------------------------
		
		public function get headHeight(): int {
			return _textField.height;
		}
		
		public function set headHeight(value: int): void {
			if (value != headHeight) {
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
	

		//----------------------------------------------------------------------`
		// Methods
		//----------------------------------------------------------------------
		
		public function draw(): void {
			_textField.wordWrap = false;
			_textField.textColor = 0xffffff;
			_textField.setTextFormat(_textFormat);
			
			var g: Graphics = this.graphics;
			var r: Rectangle = drawBounds;
			
			//g.beginFill(0x00ff00, 0.6);
			g.beginGradientFill(GradientType.RADIAL, [0xffffff, 0x555555], [1, 1], [0x00, 0xff]);
			g.lineStyle(2, panel.fillColor);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			r = closeBounds;

			g.lineStyle(2, 0xffff00);
			g.moveTo(r.x, r.y);
			g.lineTo(r.x + r.width, r.y + r.height);
			g.moveTo(r.x + r.width, r.y);
			g.lineTo(r.x, r.y + r.height);			
		}

		//----------------------------------------------------------------------`
		// Internal properties
		//----------------------------------------------------------------------
		
		private function get drawBounds(): Rectangle {
			return new Rectangle(2, 2, headWidth - 4, headHeight - 4);
		}
		
		private function get closeBounds(): Rectangle {
			var r: Rectangle = drawBounds;
			
			r.x += r.width - 10 - 6;
			r.y += 6;
			r.width = 8;
			r.height = 8;
			
			return r;
		}


		//----------------------------------------------------------------------`
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doClick(event: MouseEvent): void {
			if (closeBounds.contains(event.localX, event.localY))
				panel.dispatchEvent(new Event("headClick"));
		}
	}
}