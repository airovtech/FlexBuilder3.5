////////////////////////////////////////////////////////////////////////////////
//  LinkByTargetTool.as
//  2008.01.05, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.command.LinkCreateCommand;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLNodeController;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	import flash.display.Graphics;
	
	/**
	 * 선택된 2개의 노드들 중 현재 노드를 타겟으로 나머지 노드를 소스로 링크
	 */
	public class LinkByTargetTool extends XPDLNodeControllerTool	{

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function LinkByTargetTool(controller: XPDLNodeController) {
			super(controller, "Target으로 연결");
		}
		
		/*		
		protected function createLinkByTargetTool(): XPDLNodeControllerTool {
			var nodes: Array = selManager.nodes;
			
			if (nodes.length == 2) {
				if (nodes[0] == this) {
					return new LinkByTargetTool(this, nodes[1]);
				} else if (nodes[1] == this) {
					return new LinkByTargetTool(this, nodes[0]);
				}
			}
			
			return null;
		}
		*/
		


		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------
		
		override public function get enabled(): Boolean {
			var nodes: Array = selManager.nodes;
			
			return (nodes.length == 2) && (nodes.indexOf(controller) >= 0);
		}

		/**
		 * 이 컨트롤러의 오른쪽에 task 하나를 생성하고 연결한다.
		 */
		override protected function getCommand(): Command {
			var nodes: Array = selManager.nodes;

			var targetNode: Activity = NodeController(controller).nodeModel as Activity;
			var sourceNode: Activity = ((nodes[0] == controller) ? nodes[1] : nodes[0]) as Activity; 
			
			var link: Link = editor.createLink("default", sourceNode, targetNode);
			var cmd: LinkCreateCommand = new LinkCreateCommand(link);
			return cmd;
		}
		
		override protected function draw(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			var w: int = 11;
			var h: int = 11;
			var m: int = 5;
			
			g.lineStyle(1, 0x000000);
			g.beginFill(0x00eeee);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(m, 2);
			g.lineTo(m, h - 1);
			g.moveTo(2, m);
			g.lineTo(w - 1, m);
		}
	}
}