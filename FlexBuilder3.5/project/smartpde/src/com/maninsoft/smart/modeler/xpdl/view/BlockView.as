////////////////////////////////////////////////////////////////////////////////
//  DataObjectView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.xpdl.view.base.ArtifactView;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextColorType;
	
	
	/**
	 * DataObject view
	 */
	public class BlockView extends ArtifactView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function BlockView() {
			super();
			
			fillColor = 0xdddddd;
			textColor = 0x666666;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			var g: Graphics = graphics;
			
			g.clear();

			g.lineStyle(borderWidth, borderColor);
			
			g.moveTo(0, 0);
			g.lineTo(nodeWidth - 10, 0);
			g.lineTo(nodeWidth, 10);
			g.lineTo(nodeWidth, nodeHeight);
			g.lineTo(0, nodeHeight);
			g.lineTo(0, 0);
			
			g.moveTo(nodeWidth - 10, 0);
			g.lineTo(nodeWidth - 10, 10);
			g.lineTo(nodeWidth, 10);

			
			// text
			drawText(new Rectangle(0, 0, nodeWidth, nodeHeight), text);
		}
	}
}