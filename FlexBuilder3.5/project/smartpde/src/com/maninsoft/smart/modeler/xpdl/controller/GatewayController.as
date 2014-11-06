////////////////////////////////////////////////////////////////////////////////
//  GatewayController.as
//  2007.01.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Gateway;
	import com.maninsoft.smart.modeler.xpdl.view.base.GatewayView;
	
	/**
	 * Controller for Gateway
	 */	
	public class GatewayController extends ActivityController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GatewayController(model: Gateway) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: GatewayView = view as GatewayView;
			var m: Gateway = model as Gateway;
			
			switch (event.prop) {
				default:
					super.nodeChanged(event);
			}
		}

	}
}