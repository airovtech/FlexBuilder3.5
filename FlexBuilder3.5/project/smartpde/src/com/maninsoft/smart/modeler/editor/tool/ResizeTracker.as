////////////////////////////////////////////////////////////////////////////////
//  ResizeTracker.as
//  2007.12.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	
	/**
	 * 개체의 선택 핸들을 드래깅하여 선택된 개체들의 크기를 변경하는 tracker
	 */
	public class ResizeTracker extends ControllerDragTracker {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for handle */
		private var _handle: SelectHandle;
		private var _cursorId: int;
		private var _lastOffset: Size;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ResizeTracker(handle: SelectHandle) {
			super(handle.controller);
			
			_handle = handle;
		}		


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function startDrag(target: Object): Boolean {
			_lastOffset = null;
			return true;
		}
		
		private function offsetToDelta(): Size {
			var sz: Size = new Size(offsetX, offsetY);

			switch (_handle.anchorDir) {
				case SelectHandle.DIR_LEFT:
					sz.dy = 0;
					break;
				
				case SelectHandle.DIR_RIGHT:
					sz.dy = 0;
					break;
					
				case SelectHandle.DIR_TOP:
					sz.dx = 0;
					break;
				
				case SelectHandle.DIR_BOTTOM:
					sz.dx = 0;
					break;
			}
			
			return sz;
		}
		
		override protected function drag(target: Object): Boolean {
			var sz: Size = offsetToDelta();

			if (editor.selectionManager.canResizeBy(handle.anchorDir, sz.dx, sz.dy)) {
				editor.selectionManager.resizeBy(handle.anchorDir, sz.dx, sz.dy);
				_lastOffset = sz;
				return true;
			} 
			
			return false;
		}
		
		override protected function endDrag(target: Object): Boolean {
			return true;
		}		
		
		override protected function performCompleted(): void {
		}
		
		override protected function performCanceled(): void {
		}

		override protected function getCommand(): Command {
			var sz: Size = offsetToDelta();
			var cmd: GroupCommand = new GroupCommand();
			var ctrl:Controller;
				
			if (selManager.canResizeBy(handle.anchorDir, sz.dx, sz.dy)) {
				for each (ctrl in selectedItems) {
					cmd.add(ctrl.getResizeCommand(handle.anchorDir, sz.dx, sz.dy));
					ctrl.refreshSelection();
				}
				
				return cmd;
			}else if(_lastOffset){
				for each (ctrl in selectedItems) {
					cmd.add(ctrl.getResizeCommand(handle.anchorDir, _lastOffset.dx, _lastOffset.dy));
					ctrl.refreshSelection();
				}
				
				return cmd;
			}
			return null;
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get handle(): SelectHandle {
			return _handle;
		}

	}
}