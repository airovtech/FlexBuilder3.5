////////////////////////////////////////////////////////////////////////////////
//  ControllerDragTracker.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.controller.Controller;
	
	public class ControllerDragTracker extends DragTracker {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for property controller */
		private var _controller: Controller
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ControllerDragTracker(controller: Controller) {
			super(controller.editor);
			
			_controller = controller;			
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * controller
		 */
		public function get controller(): Controller {
			return _controller;
		}
		
		public function set controller(value: Controller): void {
			_controller = value;
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	}
}