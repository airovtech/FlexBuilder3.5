////////////////////////////////////////////////////////////////////////////////
//  EventView.as
//  2008.04.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	/**
	 * Event view
	 */
	public class EventView extends ActivityView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EventView() {
			super();
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {

			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = -6;
				problemIcon.y = -6;
				
				addChild(problemIcon);
			}
		}
	}
}