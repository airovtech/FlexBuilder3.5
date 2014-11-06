////////////////////////////////////////////////////////////////////////////////
//  LaneCreationHandle.as
//  2007.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.xpdl.controller.PoolController;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	
	import flash.display.Graphics;
	
	/**
	 * Pool에서 시작 이벤트를 추가한다.
	 */
	public class StartEventCreationTool extends XPDLNodeControllerTool {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function StartEventCreationTool(controller: PoolController) {
			super(controller, "시작 이벤트 추가");
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		/**
		 * 이 컨트롤러의 오른쪽에 task 하나를 생성하고 연결한다.
		 */
		override protected function getCommand(): Command {
			var pool: Pool = PoolController(this.controller).nodeModel as Pool;
			var cmd: GroupCommand = new GroupCommand();
			
			var task: StartEvent = editor.createNode("StartEvent") as StartEvent;
			
			task.y = 10;
			
			if (pool.firstLane)
				task.x = (pool.firstLane.size - task.width) / 2;
			else
				task.x = 10;

			cmd.add(new NodeCreateCommand(pool, task));
			
			return cmd;
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