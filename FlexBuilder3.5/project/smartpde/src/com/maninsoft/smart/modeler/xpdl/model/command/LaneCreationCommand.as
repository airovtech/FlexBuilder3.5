////////////////////////////////////////////////////////////////////////////////
//  LaneCreationCommand.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.command
{
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * Pool에 레인을 추가하는 커맨드
	 */
	public class LaneCreationCommand extends LaneCommand {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneCreationCommand(lane: Lane) {
			super(lane);
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			pool.removeLane(lane);
		}
		
		override public function redo(): void {
			pool.addLane(lane);
		}
	}
}