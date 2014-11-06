////////////////////////////////////////////////////////////////////////////////
//  NextTaskCreationHandle.as
//  2008.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.GroupCommand;
	import com.maninsoft.smart.modeler.command.LinkCreateCommand;
	import com.maninsoft.smart.modeler.command.NodeCreateCommand;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLNodeController;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Event;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	import flash.display.Graphics;
	
	/**
	 * 현재 노드 다음에 태스크 하나를 생성하고 연결한다.
	 */
	public class NextTaskCreationTool extends XPDLNodeControllerTool	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NextTaskCreationTool(controller: XPDLNodeController) {
			super(controller, "다음 Task 생성");
		}


		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------

		/**
		 * 이 컨트롤러의 오른쪽에 task 하나를 생성하고 연결한다.
		 */
		override protected function getCommand(): Command {
			var node: Activity = NodeController(this.controller).nodeModel as Activity;
			var cmd: GroupCommand = new GroupCommand();
			
			var task: TaskApplication =  editor.createNode("TaskApplication") as TaskApplication;
			
			
			var path: String;
			
			// 아래로
			if (node is Event) {
				task.x = node.x - (task.width - node.width) / 2;
				task.y = node.y + node.height + 70;
				path = "180,0";
			} else {
				// 오른쪽으로
				task.y = node.y - (task.height - node.height) / 2;
				task.x = node.x + node.width + 100;
				path = "90,270";
			}

			cmd.add(new NodeCreateCommand(node.parent, task));

			var link: XPDLLink = editor.createLink("default", node, task, path) as XPDLLink;

			cmd.add(new LinkCreateCommand(link));
			
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