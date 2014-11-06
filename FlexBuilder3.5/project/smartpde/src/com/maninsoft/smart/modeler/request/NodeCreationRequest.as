////////////////////////////////////////////////////////////////////////////////
//  NodeCreationRequest.as
//  2007.12.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.request
{
	import com.maninsoft.smart.modeler.model.DiagramObject;
	
	/**
	 * 노드 생성 요청
	 */
	public class NodeCreationRequest extends LocationRequest	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _objectType: String;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
				
		/** Constructor */
		public function NodeCreationRequest(objectType: String, x: int, y: int) {
			super("CREATE_NODE_REQUEST", x, y);
			
			_objectType = objectType;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
				
		public function get objectType(): String {
			return _objectType;
		}
	}
}