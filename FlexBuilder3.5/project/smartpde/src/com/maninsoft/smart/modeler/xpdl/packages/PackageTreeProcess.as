////////////////////////////////////////////////////////////////////////////////
//  PackageTreeProcess.as
//  2008.04.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.packages
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.navigator.DiagramTreeRoot;
	
	/**
	 * PackageNavigator 의 process node
	 */
	public class PackageTreeProcess extends DiagramTreeRoot {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PackageTreeProcess(diagram: XPDLDiagram) {
			super(diagram);
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------

		override public function get editable(): Boolean {
			return true;
		}

		override public function get removable(): Boolean {
			return true;
		}
	}
}