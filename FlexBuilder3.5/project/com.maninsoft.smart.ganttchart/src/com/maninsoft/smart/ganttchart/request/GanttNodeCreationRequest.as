////////////////////////////////////////////////////////////////////////////////
//  NodeCreationRequest.as
//  2007.12.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.request
{
	import com.maninsoft.smart.modeler.request.LocationRequest;
	
	/**
	 * 노드 생성 요청
	 */
	public class GanttNodeCreationRequest extends LocationRequest{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _objectType: String;
		private var _index: int;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
				
		/** Constructor */
		public function GanttNodeCreationRequest(objectType: String, x: int, y: int, index: int) {
			super("CREATE_NODE_REQUEST", x, y);
			
			_objectType = objectType;
			_index = index;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
				
		public function get objectType(): String {
			return _objectType;
		}

		public function get index(): int {
			return _index;
		}
	}
}