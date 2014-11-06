////////////////////////////////////////////////////////////////////////////////
//  LaneCreationHandle.as
//  2007.12.31, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
//
//  Addio 2007 !! 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.xpdl.controller.PoolController;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.command.LaneCreationCommand;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	import flash.display.Graphics;
	
	/**
	 * pool에 lane을 추가한다.
	 */
	public class LaneCreationTool extends XPDLNodeControllerTool	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LaneCreationTool(controller: PoolController) {
			super(controller, "Lane 추가");
		}


		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------

		override protected function getCommand(): Command {
			var pool: Pool = controller.model as Pool;
			var lane: Lane = new Lane(pool);
			
			lane.name = "good";
			lane.size = 200;
			
			return new LaneCreationCommand(lane);
		}
		
		override protected function draw(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			var w: int = 11;
			var h: int = 11;
			var m: int = 5;
			
			g.lineStyle(1, 0x000000);
			g.beginFill(0x00ff00);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(m, 2);
			g.lineTo(m, h - 1);
			g.moveTo(2, m);
			g.lineTo(w - 1, m);
		}
	}
}