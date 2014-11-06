////////////////////////////////////////////////////////////////////////////////
//  TransitionProblem.as
//  2008.04.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax.base
{
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	/**
	 * Link 관련 problem
	 */
	public class TransitionProblem extends Problem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TransitionProblem(link: XPDLLink, level: String = LEVEL_ERROR) {
			super(link, level);
			
			if (!link.problem)
				link.problem = this;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * activity
		 */
		public function get link(): XPDLLink {
			return source as XPDLLink;
		}
	}
}