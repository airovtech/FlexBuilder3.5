////////////////////////////////////////////////////////////////////////////////
//  AnnotationView.as
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
	
	
	/**
	 * Annotation view
	 */
	public class AnnotationView extends ArtifactView {
		
		//----------------------------------------------------------------------
		// Varaibles
		//----------------------------------------------------------------------


		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function AnnotationView() {
			super();
			
			textColor = 0x666666;
			textAlign = "left";
			showShadowed = false;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

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
			g.lineStyle(0, borderColor);
			g.moveTo(nodeWidth / 4, 0);
			g.lineTo(0, 0);
			g.lineTo(0, nodeHeight);
			g.lineTo(nodeWidth / 4, nodeHeight);
			
			// text
			drawTextTop(new Rectangle(0, 0, nodeWidth, nodeHeight), text);
		}
	}
}