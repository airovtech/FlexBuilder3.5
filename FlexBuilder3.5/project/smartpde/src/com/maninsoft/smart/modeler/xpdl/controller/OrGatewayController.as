////////////////////////////////////////////////////////////////////////////////
//  OrGatewayController.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.OrGateway;
	import com.maninsoft.smart.modeler.xpdl.view.OrGatewayView;
	
	/**
	 * Controller for OrGateway
	 */	
	public class OrGatewayController extends XPDLNodeController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function OrGatewayController(model: OrGateway) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new OrGatewayView();
		}
	}
}