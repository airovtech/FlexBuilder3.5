////////////////////////////////////////////////////////////////////////////////
//  LaneSelectionEvent.as
//  2008.03.06, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.tool
{
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	import flash.events.Event;
	
	/**
	 * Lane 선택 관련 이벤트
	 */
	public class LaneSelectionEvent extends Event	{
		
		//----------------------------------------------------------------------
		// Event types
		//----------------------------------------------------------------------

		public static const CHANGED: String = "laneSelectionChanged";
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _selection: Array;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LaneSelectionEvent(type: String, selection: Array /* of Lane */) {
			super(type);
			
			_selection = selection ? selection : [];
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * selection
		 */
		public function get selection(): Array {
			return _selection;
		}
		
		/**
		 * focusedLane
		 */
		public function get selectedLane(): Lane {
			return _selection.length > 0 ? _selection[_selection.length - 1] as Lane : null;
		}

	}
}