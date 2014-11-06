////////////////////////////////////////////////////////////////////////////////
//  SmartMappingPanel.as
//  2007.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.mapper
{
	import com.maninsoft.smart.modeler.common.ComponentUtils;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UITextField;
	
	/**
	 * 매퍼의 한 쪽 멤버들을 리스팅하는 뷰
	 */
	public class SmartMappingPanel extends Sprite implements IDraggable {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const SOURCE_PANEL: int = 0;
		public static const TARGET_PANEL: int = 1;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: UITextField;
		private var _head: SmartMappingPanelHead;
		private var _items: Array;
		private var _panelType: int;
	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SmartMappingPanel(editor: DiagramEditor, panelType: int) {
			super();
			
			_editor = editor;
			_panelType = panelType;
			
			addEventListener(MouseEvent.ROLL_OUT, doRollOver);
			addEventListener(MouseEvent.ROLL_OUT, doRollOut);			
		}
		

		//----------------------------------------------------------------------
		// IDraggable
		//----------------------------------------------------------------------
		
		public function getDragTracker(event: MouseEvent): DragTracker {
			return new PanelDragTracker(this);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		//------------------------------
		// mapper
		//------------------------------
		
		/** 
		 * 이 패널을 소유하는 매퍼
		 */
		private var _editor: DiagramEditor;
		
		public function get editor(): DiagramEditor {
			return _editor;
		}
		
		//------------------------------
		// panelType
		//------------------------------

		/**
		 * 소스/타깃 구분
		 */
		public function get panelType(): int {
			return _panelType;
		}		
		
		
		//------------------------------
		// mapSource
		//------------------------------
		
		/** 
		 * 매핑 소스 개체
		 */
		private var _mapSource: IMappingSource;

		public function get mapSource(): IMappingSource {
			return _mapSource;
		}
		
		public function set mapSource(value: IMappingSource): void {
			_mapSource = value;

			ComponentUtils.clearChildrenByType(this, SmartMappingPanelItem);	
			_items = null;		
			
			if (value.mappingItems) {
				_items = [];
				
				for each (var mi: IMappingItem in value.mappingItems) {
					var iv: SmartMappingPanelItem = new SmartMappingPanelItem(mi, panelWidth, itemHeight);
					addChild(iv);		
					_items.push(iv);
				}
			}
			
			refresh();
			
			var r: Rectangle = value.mappingBounds;
			x = (panelType == SOURCE_PANEL) ? (r.x - r.width / 2) : (r.x + r.width / 2);
			y = r.y + r.height + 4;
		}
		
		public function findItem(mi: IMappingItem): SmartMappingPanelItem {
			for each (var pi: SmartMappingPanelItem in _items) {
				if (pi.item == mi)
					return pi;
			}
			
			return null;
		}
		
		//------------------------------
		// panelSize
		//------------------------------
		
		/**
		 * panelSize
		 */
		private var _panelSize: Point = new Point(150, 200);

		public function get panelSize(): Point {
			return _panelSize.clone();
		}
		
		public function set panelSize(value: Point): void {
			_panelSize.x = value.x;
			_panelSize.y = value.y;			
		}
		
		/**
		 * panelWidth
		 */
		public function get panelWidth(): int {
			return _panelSize.x;
		}
		
		/**
		 * panelHeight
		 */
		public function get panelHeight(): int {
			return _panelSize.y;
		}

		//------------------------------
		// headHeight
		//------------------------------
		
		/**
		 * headHeight
		 */
		private var _headHeight: int = 27;
		
		public function get headHeight(): int {
			return _headHeight;
		}
		
		public function set headHeight(value: int): void {
			_headHeight = value;
		}

		//------------------------------
		// itemHeight
		//------------------------------
		
		/**
		 * itemHeight
		 */
		private var _itemHeight: int = 23;
		
		public function get itemHeight(): int {
			return _itemHeight;
		}
		
		public function set itemHeight(value: int): void {
			_itemHeight = value;
		}
		
		//------------------------------
		// headHeight
		//------------------------------
		
		/** 
		 * lineColor
		 */
		private var _lineColor: uint = 0xeaeaea;
		
		public function get lineColor(): uint {
			return _lineColor;
		}
		
		public function set lineColor(value: uint): void {
			_lineColor = value;
		}

		//------------------------------
		// fillColor
		//------------------------------

		/**
		 * fillColor
		 */
		private var _fillColor: uint = 0xeaeaea;

		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			_fillColor = value;
		}

		//------------------------------
		// focused
		//------------------------------

		/**
		 * focused
		 */
		private var _focused: Boolean;

		public function get focused(): Boolean {
			return _focused;
		}
		
		public function set focused(value: Boolean): void {
			_focused = value;
			refresh();
		}

		//------------------------------
		// borderWidth
		//------------------------------

		/**
		 * borderWidth
		 */
		private var _borderWidth: int = 2;

		public function get borderWidth(): int {
			return _borderWidth;
		}
		
		public function set borderWidth(value: int): void {
			_borderWidth = value;
			refresh();
		}

		//------------------------------
		// borderColor
		//------------------------------

		/**
		 * borderColor
		 */
		private var _borderColor: uint = 0xaaaaaa;

		public function get borderColor(): uint {
			return _borderColor;
		}
		
		public function set borderColor(value: uint): void {
			_borderColor = value;
		}

		//------------------------------
		// focusedBorderColor
		//------------------------------

		/**
		 * focusedBorderColor
		 */
		private var _focusedBorderColor: uint = 0x000000;

		public function get focusedBorderColor(): uint {
			return _focusedBorderColor;
		}
		
		public function set focusedBorderColor(value: uint): void {
			_focusedBorderColor = value;
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		public function refresh(): void{
			draw();
		}
		
		private function draw(): void {
			var g: Graphics = this.graphics;
			var h: Number = Math.max(panelHeight, headHeight + 2 + _items.length * itemHeight + 4);
			var r: Rectangle = new Rectangle(0, 0, panelWidth, h);
			
			g.clear();
			
			g.lineStyle(1, lineColor);
			g.beginFill(fillColor, 0.5);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			drawHead(g, new Rectangle(r.x, r.y, r.width, headHeight));
			
			if (_items) {
				var y: int = r.y + headHeight + 2;
				
				for each (var item: SmartMappingPanelItem in _items) {
					drawItem(g, item, new Rectangle(r.x, y, r.width, itemHeight));
					y += itemHeight;
				}
			}
			
			drawBorder(g, r);
		}
		
		private function drawHead(g: Graphics, r: Rectangle): void {
			if (!_head) {
				_head = new SmartMappingPanelHead(r.width, r.height);
				addChild(_head);
			}
			
			_head.text = mapSource.mappingTitle;
			_head.headHeight = r.height;
			_head.headWidth = r.width;
			_head.x = r.x;
			_head.y = r.y;
			_head.draw();
		}
		
		private function drawItem(g: Graphics, item: SmartMappingPanelItem, r: Rectangle): void {
			item.itemHeight = r.height;
			item.itemWidth = r.width;
			item.x = r.x;
			item.y = r.y;
			item.draw();
		}
		
		private function drawBorder(g: Graphics, r: Rectangle): void {
			g.lineStyle(borderWidth, focused ? focusedBorderColor : borderColor);
			g.beginFill(0, 0);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
		}

		/*
		protected function drawStringRect(text: String, r: Rectangle): void {
			drawString(text, r.x, r.y, r.width, r.height);
		}

		protected function drawString(text: String, x: int, y: int, w: int, h: int): void {
			if (!_textField) {
				_textField = new UITextField();
				addChild(_textField);
			}
			
			_textField.wordWrap = false;
			_textField.textColor = 0x00000;
			_textField.mouseEnabled = false;
			_textField.text = text;
			_textField.move(x + (w - _textField.textWidth) / 2, y + (h - _textField.textHeight) / 2 - 5);
		}
		*/


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doRollOver(event: MouseEvent): void {
			event.stopImmediatePropagation();
			
			focused = true;
		}
		
		private function doRollOut(event: MouseEvent): void {
			event.stopImmediatePropagation();
			
			focused = false;
		}
	}
}