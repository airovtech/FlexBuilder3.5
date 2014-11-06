////////////////////////////////////////////////////////////////////////////////
//  LaneView.as
//  2008.02.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.tool
{
	import com.maninsoft.smart.common.assets.Cursors;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.IDraggable;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.model.pool.LaneChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.view.PoolView;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.managers.CursorManager;
	
	/**
	 * 마우스 드래깅으로 Lane의 크기를 변경하는 tool
	 */
	public class LaneView extends Sprite implements IDraggable {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _resizeTracker: DragTracker;
		private var _resizeHandle: LaneResizeHandle;
		private var _resizer: Sprite;
		private var _cursor: Class;
		
		private var _textField: TextField;
		private var _textFormat: TextFormat;
		
		private var _lane: Lane;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneView() {
			super();
			
			this.doubleClickEnabled = true;
			
			_textFormat = new TextFormat();
			_textFormat.font = "윤고딕350";
			_textFormat.size = 12;
			_textFormat.color = 0x666666;
			_textFormat.align = "center";

			_textField = new TextField();
			_textField.selectable = false;
			_textField.embedFonts = true;
			_textField.wordWrap = false;
			_textField.doubleClickEnabled = true;
			_textField.defaultTextFormat = _textFormat;
			
			addChild(_textField);
			
			_resizeHandle = new LaneResizeHandle(this);
			addChild(_resizeHandle);

			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		
		
		//----------------------------------------------------------------------
		// IDraggable
		//----------------------------------------------------------------------
		
		public function getDragTracker(event: MouseEvent): DragTracker {
			return null;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * editor
		 */
		public function get editor(): XPDLEditor {
			var p: DisplayObject = this.parent;
			
			while (p) {
				if (p is XPDLEditor)
					return p as XPDLEditor;
					
				p = p.parent;
			}
			
			return null;
		}
		
		/**
		 * pool view
		 */
		public function get pool(): PoolView {
			return parent as PoolView;
		} 
		
		/**
		 * lane
		 */
		public function get lane(): Lane {
			return _lane;
		}
		
		public function set lane(value: Lane): void {
			if (value != _lane) {
				if (_lane)
					_lane.removeEventListener(LaneChangeEvent.CHANGE, laneChanged);
					
				_lane = value;
				
				if (_lane)
					_lane.addEventListener(LaneChangeEvent.CHANGE, laneChanged);
			}
		}
		
		/**
		 * laneWidth
		 */
		public function get laneWidth(): Number {
			return _lane.width;
		}
		
		/**
		 * laneHeight
		 */
		public function get laneHeight(): Number {
			return _lane.height;
		}
		
		/**
		 * isVertical
		 */
		public function get isVertical(): Boolean {
			return _lane.isVertical;	
		}
		
		/**
		 * selected
		 */
		private var _selected: Boolean; 
		
		public function get selected(): Boolean {
			return _selected;
		}
		
		public function set selected(value: Boolean): void {
			if (value != _selected) {
				_selected = value;
				refresh();	
			}
		}

		private var _poolSelected:Boolean=false;
		public function set poolSelected(value:Boolean):void{
			_poolSelected = value;
		}
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function showResizeFeedback(): Boolean {
			hideResizeFeedback();
			
			if (_resizer == null) {
				_resizer = new Sprite();
			}
			
			if (isVertical) {
				_resizer.x = pool.x + this.x + laneWidth - 3;
				_resizer.y = pool.y + this.y;
			}
			else {
				_resizer.x = pool.x + this.x;
				_resizer.y = pool.x + this.y + laneHeight - 3;
			}
			
			var g: Graphics = _resizer.graphics;
			g.clear();
			
			g.lineStyle(1, 0x0000FF, 2);
			g.moveTo(0, 0);
			
			if (isVertical) {
				g.lineTo(0, pool.height-pool.poolHeadSize-1);
			} else {
				g.lineTo(pool.width-pool.poolHeadSize-1, 0);
			}
				
			//pool.addChild(_resizer);
			editor.getFeedbackLayer().addChild(_resizer);

			if (isVertical) {
				_cursor = Cursors.sizeWE;
				CursorManager.setCursor(_cursor, 1, -10);
			} else {
				_cursor = Cursors.sizeNS;
				CursorManager.setCursor(_cursor, 1, 0, -10);
			}
			
			return true;
		}
		
		public function hideResizeFeedback(): Boolean {
			if (_resizer) {
				if (_cursor) {
					CursorManager.removeCursor(CursorManager.currentCursorID);
				}
				
//				if (pool.contains(_resizer))
//					pool.removeChild(_resizer);
				if (editor.getFeedbackLayer().contains(_resizer))
					editor.getFeedbackLayer().removeChild(_resizer);
			}
			
			return true;
		}
		
		public function moveResizeFeedback(offsetX: int,  offsetY: int): Boolean {
			if (isVertical) {
				_resizer.x = pool.x + this.x + laneWidth - 3 + offsetX;
			} else {
				_resizer.y = pool.y + this.y + laneHeight - 3 + offsetY;
			}
			
			return true;
		}
		
		public function refresh(): void {
			if (pool) 
				isVertical ? render(pool.nodeHeight - pool.poolHeadSize) : render(pool.nodeWidth - pool.poolHeadSize);
				//isVertical ? render(pool.nodeHeight) : render(pool.nodeWidth);
		}
		
		/**
		 * 그린다.
		 */
		public function render(poolSize: Number): void {
			isVertical ? renderVertical(poolSize) : renderHorizontal(poolSize);

			if (selected) {
				var g: Graphics = this.graphics;

				g.lineStyle(1, 0xda0000);
				g.beginFill(0, 0);
				if(isVertical)
					g.drawRect(0, 0, laneWidth, poolSize);
				else
					g.drawRect(0, 0, poolSize, laneHeight);
				g.endFill();
			}
		}
		
		private function initResizeHandle(bodySize: Number): void {
			_resizeHandle.laneWidth = laneWidth;
			_resizeHandle.laneHeight = laneHeight;
			_resizeHandle.bodySize = bodySize;
			_resizeHandle.isVertical = isVertical;
			
			if (editor)
				_resizeHandle.readOnly = editor.readOnly;
		}
		
		private function renderVertical(bodySize: Number): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			g.beginFill(0xeaeaea, 1);
			g.lineStyle(0, 0x999999, 0);
			g.drawRect(1, 1, laneWidth-1, laneHeight-1);

			g.lineStyle(1, 0x999999, 1);
			g.moveTo(0, 0);
			g.lineTo(laneWidth, 0);

			if(!_poolSelected){
				g.lineStyle(1, 0x999999, 1);
				g.moveTo(laneWidth, 0);
				g.lineTo(laneWidth, bodySize);
			}
			g.endFill();
			
			// draw text
			_textField.x = 2;
			_textField.y = 2;
			_textField.width = laneWidth - 4;
			_textField.height = laneHeight - 4;
			
			_textField.defaultTextFormat = _textFormat;
			_textField.wordWrap = false;
			
			// defaultTextFormat을 설정한 후 text를 변경시켜 다시 그리게 한다.
			_textField.text = lane.name;

			// field.textHeight 에 4를 더한다. TextLineMetrics 의 2-pixel gutter 참조.
			_textField.height = Math.min(_textField.textHeight + 4, laneHeight - 4);
			_textField.y = Math.max(0, (laneHeight - _textField.textHeight - 4) / 2);
			
			_textField.rotation = 0;

			// draw resize handle
			_resizeHandle.x = laneWidth - 2;
			_resizeHandle.y = 0;
			initResizeHandle(bodySize);
			_resizeHandle.render();
		}
		
		private function renderHorizontal(bodySize: Number): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			//g.beginGradientFill(GradientType.LINEAR, [0xffffff, lane.headColor], [1, 1], [0x00, 0xff]);
			g.beginFill(0xeaeaea, 1);
			g.lineStyle(0, 0x999999, 0);
			g.drawRect(1, 1, laneWidth-1, laneHeight-1);

			g.lineStyle(1, 0x999999, 1);
			g.moveTo(0, 0);
			g.lineTo(0, laneHeight);

			if(!_poolSelected){
				g.lineStyle(1, 0x999999, 1);
				g.moveTo(0, laneHeight);
				g.lineTo(bodySize, laneHeight);
			}
			g.endFill();
			
			// draw text
			_textField.x = 2;
			_textField.y = laneHeight + 2;
			_textField.width = laneHeight - 4;
			_textField.height = laneWidth - 4;
			
			// defaultTextFormat을 설정한 후 text를 변경시켜 다시 그리게 한다.
			_textField.text = lane.name;

			// field.textHeight 에 4를 더한다. TextLineMetrics 의 2-pixel gutter 참조.
			_textField.height = Math.min(_textField.textHeight + 4, laneWidth - 4);
			_textField.y = Math.max(laneHeight, (laneWidth - _textField.textHeight - 4) / 2);
			
			_textField.rotation = -90;
			
			// draw resize handle
			_resizeHandle.x = 0;
			_resizeHandle.y = laneHeight - 2;
			initResizeHandle(bodySize);
			_resizeHandle.render();
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function laneChanged(event: LaneChangeEvent): void {
			refresh();
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doMouseOver(event: MouseEvent): void {
		}

		private function doMouseOut(event: MouseEvent): void {
		}
	}
}