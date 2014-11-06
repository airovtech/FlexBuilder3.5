////////////////////////////////////////////////////////////////////////////////
//  NodeChangeEvent.as
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
	 * 노드 속성 값 변경 이벤트
	 */
	public class NodeChangeEvent extends NodeValueEvent {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _prop: String;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeChangeEvent(node: Node = null, prop: String = null, oldValue: Object = null) {
			super(NodeEvent.CHANGE, node, oldValue);
			
			_prop = prop;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * Property oldValue
		 */
		public function get oldValue(): Object {
			return super.value;
		}
		
		public function set oldValue(val: Object): void {
			super.value = val;
		}

		/**
		 * 변경된 프로퍼티 명
		 */
		public function get prop(): String {
			return _prop;
		}
		
		public function set prop(value: String): void {
			_prop = value;
		}
	}
}