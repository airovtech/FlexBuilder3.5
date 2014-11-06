////////////////////////////////////////////////////////////////////////////////
//  ActivityProblem.as
//  2008.04.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax.base
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	
	/**
	 * Activity 관련 problem
	 */
	public class ActivityProblem extends Problem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ActivityProblem(activity: Activity, level: String = LEVEL_ERROR) {
			super(activity, level);
			
			if (!activity.problem)
				activity.problem = this;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * activity
		 */
		public function get activity(): Activity {
			return source as Activity;
		}
	}
}