////////////////////////////////////////////////////////////////////////////////
//  LaneEvent.as
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
	public class LaneEvent extends Event {
		
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------

		/** lane 속성 변경 이벤트 */
		public static const CHANGE: String = "change";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _lane: Lane;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneEvent(type: String, lane: Lane) {
			super(type);
			
			_lane = lane;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * lane
		 */
		public function get lane(): Lane {
			return _lane;
		}
		
		public function set lane(value: Lane): void {
			_lane = value;
		}
	}
}