////////////////////////////////////////////////////////////////////////////////
//  XPDLViewer.as
//  2008.03.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * XPDL 프로세스 Viewer
	 */
	public class XPDLViewer extends XPDLEditor {


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLViewer() {
			super();
			
			readOnly = true;
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}

		//----------------------------------------------------------------------
		// Overriden methdods
		//----------------------------------------------------------------------
		override public function get scrollMargin():Number{
			return 0;
		}
	}
}