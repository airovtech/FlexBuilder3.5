////////////////////////////////////////////////////////////////////////////////
//  TaskFormIcon.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.viewicon
{
	import com.maninsoft.smart.modeler.assets.XPDLEditorAssets;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.ViewIcon;
	
	import flash.display.Graphics;
	
	import mx.core.SpriteAsset;
	
	public class TimerEventIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var timerEventIcon: SpriteAsset = SpriteAsset(new XPDLEditorAssets.timerEventIcon());	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function TimerEventIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(timerEventIcon))
				removeChild(timerEventIcon);
			addChild(timerEventIcon);
		}
	}
}