////////////////////////////////////////////////////////////////////////////////
//  NodeEvent.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.model.events
{
	import com.maninsoft.smart.modeler.model.Node;
	
	import flash.events.Event;
	
	/**
	 * Node 관련 이벤트
	 */
	public class NodeEvent extends Event {
		
		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		/** 노드 추가 이벤트 */
		public static const CREATE	: String = "create";
		/** 노드 삭제 이벤트 */
		public static const REMOVE	: String = "remove";
		/** 노드 대체 이벤트 */
		public static const REPLACE	: String = "replace";
		/** 노드 속성 변경 이벤트 */
		public static const CHANGE	: String = "change";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _node: Node;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeEvent(type: String, node: Node = null) {
			super(type);
			
			_node = node;
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * Property node
		 */
		public function get node(): Node {
			return _node;
		}
		
		public function set node(value: Node): void {
			_node = value;
		}
	}
}