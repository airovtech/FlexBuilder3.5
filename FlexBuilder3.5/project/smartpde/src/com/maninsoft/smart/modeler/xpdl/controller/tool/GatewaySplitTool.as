////////////////////////////////////////////////////////////////////////////////
//  GatewaySplitHandle.as
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
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.controller.GatewayController;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Gateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	
	import flash.display.Graphics;
	
	/**
	 * XorGateway 다음에 task 두개를 생성하고 연결한다.
	 */
	public class GatewaySplitTool extends XPDLNodeControllerTool {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GatewaySplitTool(controller: GatewayController) {
			super(controller, "Task 분기");
		}

		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------

		/**
		 * 이 컨트롤러의 게이트웨이 모델 오른쪽에 두개의 태스크를 생성하고 연결한다.
		 */
		override protected function getCommand(): Command {
			var cmd: GroupCommand = new GroupCommand();
			
			var node: Activity = GatewayController(this.controller).nodeModel as Gateway;
			
			var task: TaskApplication = editor.createNode("TaskApplication") as TaskApplication;
			task.x = node.x + node.width + 100;
			task.y = Math.max(4, node.y - task.height - 10);
			cmd.add(new NodeCreateCommand(node.parent, task));
			
			var link: Link = editor.createLink("default", node, task, "90,270") as XPDLLink;
			cmd.add(new LinkCreateCommand(link));

			task = editor.createNode("TaskApplication") as TaskApplication;
			task.x = node.x + node.width + 100;
			task.y = node.y + node.height + 10;
			cmd.add(new NodeCreateCommand(node.parent, task));
			
			link = editor.createLink("default", node, task, "90,270") as XPDLLink;
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