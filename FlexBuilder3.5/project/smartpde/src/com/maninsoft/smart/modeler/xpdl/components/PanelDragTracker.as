////////////////////////////////////////////////////////////////////////////////
//  PaneDragTracker.as
//  2008.01.07, created by gslim
//
//  Merry Christmas!
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.components
{
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	
	import flash.events.Event;
	
	/**
	 * SmartMapperPanel을 드래깅하는 트래커
	 */
	public class PanelDragTracker extends DragTracker {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		private static const DRAG_NONE : int = 0;
		private static const DRAG_PANEL: int = 1;
		private static const DRAG_HEAD : int = 2;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _dragTarget: int;

		private var _panel: TaskFormPanel;
		private var _orgX: int;
		private var _orgY: int;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PanelDragTracker(panel: TaskFormPanel) {
			super(panel.editor);
			
			_panel = panel;	
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * panel 
		 */
		public function get panel(): TaskFormPanel {
			return _panel;
		}
		
		public function set panel(value: TaskFormPanel): void {
			_panel = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function startDrag(target: Object): Boolean {
			trace("startDrag: " + target);

			_dragTarget = DRAG_PANEL;

			_orgX = panel.x;
			_orgY = panel.y;
		
			return true;
		}
		
		override protected function drag(target: Object): Boolean {
			switch (_dragTarget) {
				case DRAG_HEAD:
				case DRAG_PANEL:
					if (offsetX > 0 || offsetY > 0) {
						panel.x = _orgX + offsetX;
						panel.y = _orgY + offsetY;
						
						panel.dispatchEvent(new Event("moved"));
					}

					break;					
			}
			
			return true;
		}

		override protected function endDrag(target: Object): Boolean {
			switch (_dragTarget) {
				case DRAG_HEAD:
				case DRAG_PANEL:
					break;					
			}

			return true;
		}
		
		override protected function performCompleted(): void {
		}
		
		override protected function performCanceled(): void {
		}
	}
}