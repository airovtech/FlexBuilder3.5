////////////////////////////////////////////////////////////////////////////////
//  ShowMapperTool.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.ControllerTool;
	import com.maninsoft.smart.modeler.mapper.IMappingSource;
	import com.maninsoft.smart.modeler.mapper.MappingTool;
	import com.maninsoft.smart.modeler.xpdl.controller.ActivityController;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLLinkController;
	
	import flash.display.Graphics;
	
	/**
	 * 매퍼를 표시하고 매핑을 도와주는 툴
	 */
	public class ShowMappingTool extends ControllerTool {
		
		//----------------------------------------------------------------------
		// Class variables
		//----------------------------------------------------------------------

		private static var _tool: MappingTool = null;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function ShowMappingTool(controller: Controller) {
			super(controller, "Data 매핑");
			
			this.opaqueBackground = true;
		}


		//----------------------------------------------------------------------
		// Virtual methods
		//----------------------------------------------------------------------

		protected function createMappingTool(): MappingTool {
			return new MappingTool(editor);
		}

		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------

		override public function get enabled(): Boolean {
			if (controller is XPDLLinkController) {
				var ctrl: XPDLLinkController = controller as XPDLLinkController;
				
				return ctrl.sourceController is ActivityController &&
				        ctrl.targetController is ActivityController;			
			}
		
			return false;
		}

		override protected function getCommand(): Command {
			return null;
		}
		
		override protected function execute(): void {
			if (controller is XPDLLinkController) {
				var ctrl: XPDLLinkController = controller as XPDLLinkController;
			
				if (ctrl.sourceController is IMappingSource && ctrl.targetController is IMappingSource) {
					if (!_tool) {
						_tool = createMappingTool();
					}
				
					_tool.show(ctrl.sourceController as IMappingSource, ctrl.targetController as IMappingSource);
					editor.activeTool = _tool;
				}
			}
		}
		
		override protected function draw(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			var w: int = 11;
			var h: int = 11;
			var m: int = 5;
			
			g.lineStyle(1, 0x000000);
			g.beginFill(0x880000);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(m, 2);
			g.lineTo(m, h - 1);
			g.moveTo(2, m);
			g.lineTo(w - 1, m);
		}
	}
}