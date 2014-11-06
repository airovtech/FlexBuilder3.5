////////////////////////////////////////////////////////////////////////////////
//  EndEventController.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.view.EndEventView;
	
	/**
	 * Controller for EndEvent
	 */	
	public class EndEventController extends EventController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EndEventController(model: EndEvent) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new EndEventView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);
		}
	}
}