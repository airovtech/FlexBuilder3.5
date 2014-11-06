////////////////////////////////////////////////////////////////////////////////
//  LaneChangeEvent.as
//  2008.03.06, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.pool
{
	import flash.events.Event;
	
	/**
	 * Lane 관련 이벤트
	 */
	public class LaneChangeEvent extends LaneEvent {
		
		
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------

		/** lane 속성 변경 이벤트 */
		public static const CHANGE: String = "change";


		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _prop: String;
		private var _oldValue: Object;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function LaneChangeEvent(type: String, lane: Lane, prop: String, oldValue: Object) {
			super(type, lane);
			
			_prop = prop;
			_oldValue = oldValue;
		}

		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * oldValue
		 */
		public function get oldValue(): Object {
			return _oldValue;
		}

		/**
		 * 변경된 프로퍼티 명
		 */
		public function get prop(): String {
			return _prop;
		}
	}
}