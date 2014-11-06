////////////////////////////////////////////////////////////////////////////////
//  XorRouteView.as
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
	 * XorRoute view
	 */
	public class XorGatewayView extends GatewayView {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XorGatewayView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function drawIcon(g: Graphics, r: Rectangle): void {
			g.lineStyle(2, iconColor, 1, false, "normal", CapsStyle.NONE);
			//g.lineGradientStyle(GradientType.LINEAR, [0xffffff, iconColor], [1, 1], [0x00, 0xff]);
			
			g.moveTo(r.x + 4, r.y + 4);
			g.lineTo(r.x + r.width - 4, r.y + r.height - 4);
			g.moveTo(r.x + r.width - 4, r.y + 4);
			g.lineTo(r.x + 4, r.y + r.height - 4);
		}
		
	}
}