////////////////////////////////////////////////////////////////////////////////
//  NodeControllerTool.as
//  2007.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * node 컨트롤러 툴
	 */
	public class NodeControllerTool extends ControllerTool {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function NodeControllerTool(controller: NodeController, toolTip: String = null) {
			super(controller, toolTip);
		}


		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get nodeController(): NodeController {
			return controller as NodeController;
		}
		
		protected function get node(): Node {
			return nodeController.nodeModel;	
		}
	}
}