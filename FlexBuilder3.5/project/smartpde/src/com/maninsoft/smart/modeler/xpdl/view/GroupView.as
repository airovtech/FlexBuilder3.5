////////////////////////////////////////////////////////////////////////////////
//  GroupView.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view
{
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.xpdl.view.base.ArtifactView;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	
	/**
	 * Group view
	 */
	public class GroupView extends ArtifactView {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GroupView() {
			super();

			textColor = 0x000000;
			textAlign = "left";
			showShadowed = false;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function draw(): void {
			var g: Graphics = graphics;
			
			g.clear();

			// 내부를 클릭하면 선택되어야 하므로
			g.lineStyle(0, 0, 0);//, 0, 1.0, true);
			g.beginFill(0, 0);
			g.drawRect(0, 0, nodeWidth, nodeHeight);
			g.endFill();
			
			// 진짜로 그린다.
			g.lineStyle(0, 0);//, 0, 1.0, true);
			GraphicUtils.drawDashedRoundRect(g, 0, 0, nodeWidth, nodeHeight, 5);
			
			// text
			drawTextTop(new Rectangle(0, 0, nodeWidth, nodeHeight), text);
		}
	}
}