////////////////////////////////////////////////////////////////////////////////
//  LaneMoveCommand.as
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
	 * Lane의 위치를 변경한다.
	 */
	public class LaneMoveCommand extends LaneCommand {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _oldId: int;
		private var _newId: int;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneMoveCommand(lane: Lane, newId: int)	{
			super(lane);
			
			_oldId = lane.id;
			_newId = newId;
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			pool.moveLane(lane, _oldId);
		}
		
		override public function redo(): void {
			pool.moveLane(lane, _newId);
		}
	}
}