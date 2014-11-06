////////////////////////////////////////////////////////////////////////////////
//  NodeValueEvent.as
//  2007.12.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model.events
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 노드 값 관련 이벤트
	 */
	public class NodeValueEvent extends NodeEvent {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		private var _value: Object;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeValueEvent(type: String, node: Node = null, value: Object = null) {
			super(type, node);
			
			_value = value;
		}		
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * Property value
		 */
		public function get value(): Object {
			return _value;
		}
		
		public function set value(val: Object): void {
			_value = val;
		}
	}
}