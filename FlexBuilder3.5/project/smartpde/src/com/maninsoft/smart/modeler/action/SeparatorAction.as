////////////////////////////////////////////////////////////////////////////////
//  SeparatorAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.action
{
	/**
	 * Separator action
	 */
	public class SeparatorAction extends Action {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------
		
		public static const Instance: SeparatorAction = new SeparatorAction();


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SeparatorAction() {
			super(null);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function get type(): String {
			return MENU_SEPARATOR;
		}
	}
}