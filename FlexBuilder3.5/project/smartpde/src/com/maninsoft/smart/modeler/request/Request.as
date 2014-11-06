////////////////////////////////////////////////////////////////////////////////
//  Request.as
//  2007.12.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.request
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	
	
	/**
	 * 에디터 외부 혹은 에디터 사용자 인터페이스를 통해 발생하는 UI 요청
	 */
	public class Request extends ObjectBase {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _name: String = "REQUEST";
		
		
		//----------------------------------------------------------------------
		// Initialization & finalinzation
		//----------------------------------------------------------------------
	
		/** Constructor */
		public function Request(name: String) {
			super();
			
			_name = name;
		}	
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
	
		/** 
		 * name
		 */
		public function get name(): String {
			return _name;
		}	
	}
}