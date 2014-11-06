////////////////////////////////////////////////////////////////////////////////
//  LaneDeleteCommand.as
//  2008.03.05, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.command
{
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * Pool에서 Lane 하나를 삭제한다.
	 */
	public class LaneDeleteCommand extends LaneCommand {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneDeleteCommand(lane: Lane) {
			super(lane);
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			pool.addLaneAt(lane, lane.id);
		}
		
		override public function redo(): void {
			pool.removeLane(lane);
		}
	}
}