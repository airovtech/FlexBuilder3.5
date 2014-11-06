////////////////////////////////////////////////////////////////////////////////
//  GatewayView.as
//  2008.01.04, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	/**
	 * Gateway view
	 */
	public class GatewayView extends ActivityView	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _iconColor: uint = 0x286684;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GatewayView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get iconColor(): uint {
			return _iconColor;
		}
		
		public function set iconColor(value: uint): void {
			_iconColor = value;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			var g: Graphics = graphics;
			var radious: Number = 2.5;
			g.clear();

			g.lineStyle(borderWidth, borderColor, 1, true);
			
			if (!showGrayed)
				setFillMode(g);
			else
				g.beginFill(grayedColor);
			
			g.moveTo(nodeWidth/2+radious, 0+radious);
			g.lineTo(nodeWidth-radious, nodeHeight/2-radious);
			g.curveTo(nodeWidth, nodeHeight/2, nodeWidth-radious, nodeHeight/2+radious);
			g.lineTo(nodeWidth/2+radious, nodeHeight-radious);
			g.curveTo(nodeWidth/2, nodeHeight, nodeWidth/2-radious, nodeHeight-radious);
			g.lineTo(0+radious, nodeHeight/2+radious);
			g.curveTo(0, nodeHeight/2, 0+radious, nodeHeight/2-radious);
			g.lineTo(nodeWidth/2-radious, 0+radious);
			g.curveTo(nodeWidth/2, 0, nodeWidth/2+radious, 0+radious);
			g.endFill();

			g.lineStyle(borderWidth, borderColor, 1, true);
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x000000], [0.07, 0.07], [0, 255]);
			g.moveTo(nodeWidth/2+radious, 0+radious);
			g.lineTo(nodeWidth-radious, nodeHeight/2-radious);
			g.curveTo(nodeWidth, nodeHeight/2, nodeWidth-radious, nodeHeight/2+radious);
			g.lineTo(nodeWidth/2+radious, nodeHeight-radious);
			g.curveTo(nodeWidth/2, nodeHeight, nodeWidth/2-radious, nodeHeight-radious);
			g.lineTo(0+radious, nodeHeight/2+radious);
			g.curveTo(0, nodeHeight/2, 0+radious, nodeHeight/2-radious);
			g.lineTo(nodeWidth/2-radious, 0+radious);
			g.curveTo(nodeWidth/2, 0, nodeWidth/2+radious, 0+radious);
			g.endFill();
			
			var sz: int = Math.min(nodeWidth / 2, nodeHeight / 2);
			drawIcon(g, new Rectangle((nodeWidth - sz) / 2, (nodeHeight - sz) / 2, sz, sz));

			removeProblemIcon();
			
			if (problem) {
				problemIcon.problem = problem;
				problemIcon.x = 2;
				problemIcon.y = 2;
				
				addChild(problemIcon);
			}
		}
		

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function drawIcon(g: Graphics, r: Rectangle): void {
		}
	}
}