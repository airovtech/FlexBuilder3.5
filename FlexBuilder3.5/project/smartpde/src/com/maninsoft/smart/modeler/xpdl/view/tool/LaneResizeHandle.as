////////////////////////////////////////////////////////////////////////////////
//  LaneResizeHandle.as
//  2008.02.22, created by gslim
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
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	
	/**
	 * LaneView의 너비를 조정하는 핸들
	 */
	public class LaneResizeHandle extends Sprite implements IDraggable {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _owner: LaneView;
		private var _resizeTracker: LaneResizeTracker;
		
		internal var laneHeight: Number;
		internal var laneWidth: Number;
		internal var bodySize: Number;
		internal var isVertical: Boolean;
		internal var readOnly: Boolean;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function LaneResizeHandle(owner: LaneView) {
			super();
			
			_owner = owner;

			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		
		
		//----------------------------------------------------------------------
		// IDraggable
		//----------------------------------------------------------------------
		
		public function getDragTracker(event: MouseEvent): DragTracker {
			if (_resizeTracker == null) {
				_resizeTracker = new LaneResizeTracker(_owner);
			}
			
			return _resizeTracker;
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		
		private function doMouseOver(event: MouseEvent): void {
			if (!readOnly) {
				var cursor: Class = isVertical ? Cursors.sizeWE : Cursors.sizeNS;
				
				if (isVertical) {
					CursorManager.setCursor(cursor, 2, -8, -8);
				} else {
					CursorManager.setCursor(cursor, 2, -8, -8);
				}
			}
		}

		private function doMouseOut(event: MouseEvent): void {
			if (!readOnly) {
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		/**
		 * LaneView 에서 모두 그리므로, 자리만 차지하자.
		 */
		internal function render(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			g.lineStyle(3, 0, 0);
			
			if (isVertical) {
				g.moveTo(0, 0);
				g.lineTo(0, bodySize);
			}
			else {
				g.moveTo(0, 0);
				g.lineTo(bodySize, 0);
			}
		}
	}
}