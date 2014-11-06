////////////////////////////////////////////////////////////////////////////////
//  AndGatewayView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.view.base.GatewayView;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	
	/**
	 * AndRoute view
	 */
	public class AndGatewayView extends GatewayView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function AndGatewayView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function drawIcon(g: Graphics, r: Rectangle): void {
			g.lineStyle(2, iconColor, 1, false, "normal", CapsStyle.NONE);
			//g.lineGradientStyle(GradientType.LINEAR, [0xffffff, iconColor], [1, 1], [0x00, 0xff]);
			
			g.moveTo(r.x + r.width / 2, r.y);
			g.lineTo(r.x + r.width / 2, r.y + r.height);
			g.moveTo(r.x, r.y + r.height / 2);
			g.lineTo(r.x + r.width, r.y + r.height / 2);
		}
	}
}