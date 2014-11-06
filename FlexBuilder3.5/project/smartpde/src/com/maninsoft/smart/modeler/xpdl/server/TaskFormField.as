////////////////////////////////////////////////////////////////////////////////
//  TaskFormField.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import mx.resources.ResourceManager;
	
	/**
	 * 태스크 업무화면
	 */
	public class TaskFormField extends ObjectBase {
		
		public static const EMPTY_FIELD_NAME:String = ResourceManager.getInstance().getString("WorkbenchETC", "emptyFieldNameText");;
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		public var formId: String;
		public var id: String;
		public var name: String;
		public var type: String;
		public var icon: Class;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskFormField() {
			super();
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		public function get label():String{
			return name;
		}
	}
}