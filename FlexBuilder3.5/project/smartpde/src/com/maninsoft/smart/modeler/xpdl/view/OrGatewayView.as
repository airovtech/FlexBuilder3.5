////////////////////////////////////////////////////////////////////////////////
//  OrRouteView.as
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
	 * OrRoute view
	 */
	public class OrGatewayView extends GatewayView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function OrGatewayView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function drawIcon(g: Graphics, r: Rectangle): void {
			g.lineStyle(2, iconColor, 1, false, "normal", CapsStyle.NONE);
			//g.lineGradientStyle(GradientType.LINEAR, [0xffffff, iconColor], [1, 1], [0x00, 0xff]);
			
			r.inflate(-2, -2);
			
			g.beginFill(fillColor, 0);
			g.drawCircle(r.x + r.width / 2, r.y + r.height / 2, r.width / 2);
			g.endFill();
		}
	}
}