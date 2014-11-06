////////////////////////////////////////////////////////////////////////////////
//  EndEventView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.view.base.EventView;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	
	/**
	 * EndEvent view
	 */
	public class EndEventView extends EventView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EndEventView() {
			super();

			borderWidth = 2;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			var g: Graphics = graphics;
			
			g.clear();

			var sz: int = Math.min(nodeWidth, nodeHeight) / 2;
			
			g.lineStyle(borderWidth, borderColor);
			
			if (!showGrayed)
				setFillMode(g);
			else
				g.beginFill(grayedColor);

			g.drawCircle(sz - 1, sz - 1, sz);
			g.endFill();

			g.lineStyle(borderWidth, borderColor);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x000000], [0.07, 0.07], [0, 255]);
			g.drawCircle(sz - 1, sz - 1, sz);
			g.endFill();

			drawText(new Rectangle(0, 0, nodeWidth, nodeHeight), resourceManager.getString("ProcessEditorETC", "endText"));
			super.draw();
		}
	}
}