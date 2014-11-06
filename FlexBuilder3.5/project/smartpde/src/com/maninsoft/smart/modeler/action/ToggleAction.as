////////////////////////////////////////////////////////////////////////////////
//  ToggleAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.action
{
	public class ToggleAction extends Action {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ToggleAction(label: String) {
			super(label);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function get type(): String {
			return MENU_CHECK;
		}
	}
}