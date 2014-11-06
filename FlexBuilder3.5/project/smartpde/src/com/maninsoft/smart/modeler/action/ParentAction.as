////////////////////////////////////////////////////////////////////////////////
//  ParentAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.action
{
	/**
	 * Sub action들을 갖는 action
	 */
	public class ParentAction extends Action	{
		
		//----------------------------------------------------------------------
		// Varaibles
		//----------------------------------------------------------------------
		
		private var _children: Array;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ParentAction(label: String, children: Array) {
			super(label);
			
			_children = children;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get children(): Array {
			return _children;	
		}
	}
}