////////////////////////////////////////////////////////////////////////////////
//  TaskFormPanel.as
//  2007.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.components
{
	import com.maninsoft.smart.modeler.common.ComponentUtils;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UITextField;
	
	/**
	 * TaskApplication에 설정된 taskForm 정보를 간략히 표시하는 panel
	 */
	public class TaskFormPanel extends Sprite implements IDraggable  {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const SOURCE_PANEL: int = 0;
		public static const TARGET_PANEL: int = 1;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _textField: UITextField;
		private var _head: TaskFormPanelHead;
		private var _items: Array;
		private var _task: TaskApplication;
		private var _form: TaskForm;



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskFormPanel(editor: XPDLEditor, task: TaskApplication) {
			super();
			
			_editor = editor;
			this.task = task;
			
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
		
		/** 
		 * 이 패널을 소유하는 매퍼
		 */
		private var _editor: XPDLEditor;
		
		public function get editor(): XPDLEditor {
			return _editor;
		}
		
		/**
		 * diagram
		 */
		public function get diagram(): XPDLDiagram {
			return _editor.diagram as XPDLDiagram;
		}
		
		/** 
		 * taskForm
		 */
		public function get task(): TaskApplication {
			return _task;
		}
		
		public function set task(value: TaskApplication): void {
			_task = value;
			_form = _editor.server.findForm(_task.formId);

			ComponentUtils.clearChildrenByType(this, TaskFormPanelItem);
			_items = [];
			
			if (_task) {	
				var flds: Array= _editor.server.getTaskFormFields(_task.formId);
				var y: int = headHeight;
				
				if (flds) {
					for each (var fld: TaskFormField in flds) {
						var item: TaskFormPanelItem = new TaskFormPanelItem(fld, panelWidth, itemHeight);
						
						addChild(item);
						_items.push(item);
						y += itemHeight;
					}	
				}
			}
		}
		
		public function findItem(fld: TaskFormField): TaskFormPanelItem {
			for each (var pi: TaskFormPanelItem in _items) {
				if (pi.formField == fld)
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
			g.beginFill(fillColor);
			g.drawRect(r.x, r.y, r.width, r.height);
			g.endFill();
			
			drawHead(g, new Rectangle(r.x, r.y, r.width, headHeight));
			
			if (_items) {
				var y: int = r.y + headHeight + 2;
				
				for each (var item: TaskFormPanelItem in _items) {
					drawItem(g, item, new Rectangle(r.x, y, r.width, itemHeight));
					y += itemHeight;
				}
			}
			
			drawBorder(g, r);
		}
		
		private function drawHead(g: Graphics, r: Rectangle): void {
			if (!_head) {
				_head = new TaskFormPanelHead(r.width, r.height);
				addChild(_head);
			}
			
			_head.text = _form ? _form.name : _task.formId;
			_head.headHeight = r.height;
			_head.headWidth = r.width;
			_head.x = r.x;
			_head.y = r.y;
			_head.draw();
		}
		
		private function drawItem(g: Graphics, item: TaskFormPanelItem, r: Rectangle): void {
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