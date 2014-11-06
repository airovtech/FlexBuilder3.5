////////////////////////////////////////////////////////////////////////////////
//  MoveTracker.as
//  2007.12.24, created by gslim
//
//  Merry Christmas!
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.NodeMoveCommand;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 선택된 개체들을 이동시키는 tracker
	 */
	public class MoveTracker extends ControllerDragTracker {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		private var _lastOffset: Size;
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function MoveTracker(controller: Controller) {
			super(controller);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function startDrag(target: Object): Boolean {
			_lastOffset = null;
			return true;
		}
		
		override protected function drag(target: Object): Boolean {

			if (editor.selectionManager.canMoveBy(offsetX, offsetY)) {
				editor.selectionManager.moveBy(offsetX, offsetY);
				_lastOffset = new Size(offsetX, offsetY);
				return true;
			}
			
			return false;
		}

		override protected function endDrag(target: Object): Boolean {
			return true;
		}
		
		override protected function performCompleted(): void {
			for each (var ctrl: Controller in selManager.items) {
				ctrl.refreshSelection();
				
				if (ctrl.hideTools()) 
					ctrl.showTools();
			}
		}
		
		override protected function performCanceled(): void {
		}
		
		override protected function getCommand(): Command {
			var cmd: GroupCommand = new GroupCommand();
			var ctrl:Controller;				
			if (selManager.canMoveBy(offsetX, offsetY)) {
				for each (ctrl in selManager.items) {
					cmd.add(new NodeMoveCommand(ctrl.model as Node, offsetX, offsetY));
				}
				
				return cmd;
			}else if(_lastOffset){
				for each (ctrl in selManager.items) {
					cmd.add(new NodeMoveCommand(ctrl.model as Node, _lastOffset.dx, _lastOffset.dy));
				}
				
				return cmd;				
			}
			
			return null;
		}
	}
}