////////////////////////////////////////////////////////////////////////////////
//  DiagramProblem.as
//  2008.04.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax.base
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	/**
	 * Diagram 관련 problem
	 */
	public class DiagramProblem extends Problem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramProblem(diagram: XPDLDiagram) {
			super(diagram);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * diagram
		 */
		public function get diagram(): XPDLDiagram {
			return source as XPDLDiagram;
		}
	}
}