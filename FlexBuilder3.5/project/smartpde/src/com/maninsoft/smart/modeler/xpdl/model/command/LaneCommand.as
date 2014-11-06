////////////////////////////////////////////////////////////////////////////////
//  LaneCommand.as
//  2008.02.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.command
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * Lane 관련 base command
	 */
	public class LaneCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _lane: Lane;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneCommand(lane: Lane) {
			super();
			
			_lane = lane;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * pool
		 */
		public function get pool(): Pool {
			return _lane.owner;
		}

		/**
		 * lane
		 */
		public function get lane(): Lane {
			return _lane;
		}
	}
}