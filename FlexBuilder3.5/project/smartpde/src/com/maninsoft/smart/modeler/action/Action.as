////////////////////////////////////////////////////////////////////////////////
//  Action.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.action
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	
	
	
	/**
	 * IAction base class
	 */
	public class Action extends ObjectBase implements IAction {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		internal static const MENU_NORAML	  	: String = "normal";
		internal static const MENU_SEPARATOR	: String = "separator";
		internal static const MENU_CHECK    	: String = "check";
		internal static const MENU_RADIO    	: String = "radio";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _label: String = "Action";
		private var _icon: Class;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function Action(label: String, icon: Class = null) {
			super();
			
			_label = label;
			_icon = icon;
		}


		//----------------------------------------------------------------------
		// IAction
		//----------------------------------------------------------------------
		
		public function get label(): String {
			return _label;
		}
		
		public function get icon(): Class {
			return _icon;	
		}
		
		public function get enabled(): Boolean {
			return true;	
		}
		
		public function get toggled(): Boolean {
			return false;
		}
		
		public function get type(): String {
			return MENU_NORAML;	
		}
		
		public function get groupName(): String {
			return null;	
		}
		
		public function execute(): void {
		}
	}
}