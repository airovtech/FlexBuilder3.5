////////////////////////////////////////////////////////////////////////////////
//  DataFieldsTool.as
//  2008.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller.tool
{
	import com.maninsoft.smart.modeler.xpdl.controller.ActivityController;
	import com.maninsoft.smart.modeler.xpdl.dialogs.DataFieldsDialog;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	import flash.display.Graphics;
	
	/**
	 * XPDL Activity의 DataField들을 정의하는 툴
	 */
	public class DataFieldsTool_old extends XPDLNodeControllerTool {
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DataFieldsTool_old(controller: ActivityController) {
			super(controller, "DataFields");
		}



		//----------------------------------------------------------------------
		// Overidden methods
		//----------------------------------------------------------------------
		
		override protected function execute(): void {
			DataFieldsDialog.execute(controller.model as Activity, editor, this.x + this.width + 4, this.y + this.width + 4);
		}

		override protected function draw(): void {
			var g: Graphics = this.graphics;
			
			g.clear();
			
			var w: int = 11;
			var h: int = 11;
			var m: int = 5;
			
			g.lineStyle(1, 0x000000);
			g.beginFill(0xff0000);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			g.moveTo(m, 2);
			g.lineTo(m, h - 1);
			g.moveTo(2, m);
			g.lineTo(w - 1, m);
		}
	}
}