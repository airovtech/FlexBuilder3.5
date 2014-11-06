////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeControllerTool.as
//  2007.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.controller.NodeControllerTool;
	import com.maninsoft.smart.modeler.editor.handle.SelectHandle;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLNodeController;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	/**
	 * XPDLNode 컨트롤러 툴
	 */
	public class XPDLNodeControllerTool extends NodeControllerTool {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function XPDLNodeControllerTool(controller: XPDLNodeController, toolTip: String = null) {
			super(controller, toolTip);
		}
		

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get xpdlNodeController(): XPDLNodeController {
			return controller as XPDLNodeController;
		}
		
		protected function get xpdlNode(): XPDLNode {
			return xpdlNodeController.xpdlNode;
		}
		
		protected function get pool(): Pool {
			return xpdlNode.pool;
		}
	}
}