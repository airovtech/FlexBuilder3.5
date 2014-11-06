////////////////////////////////////////////////////////////////////////////////
//  LaneResizeCommand.as
//  2008.02.22, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.command
{
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * Lane의 크기를 변경하는 커맨드
	 */
	public class LaneResizeCommand extends LaneCommand {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _delta: Number;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LaneResizeCommand(lane: Lane, delta: Number) {
			super(lane);
			
			_delta = delta;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			pool.resizeLaneBy(lane, _delta);
		}
		
		override public function undo(): void  {
			pool.resizeLaneBy(lane, -_delta);
		}

	}
}