////////////////////////////////////////////////////////////////////////////////
//  StartActivityIcon.as
//  2008.01.15, created by gslim
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
	import mx.resources.ResourceManager;
	
	/**
	 * Activity의 StartActivity가 true일 때 표시
	 */
	public class StartActivityIcon extends ViewIcon {
		
		private var startActivityIcon: SpriteAsset = SpriteAsset(new XPDLEditorAssets.startActivityIcon());

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function StartActivityIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return ResourceManager.getInstance().getString("ProcessEditorETC", "startEventText");
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(startActivityIcon))
				removeChild(startActivityIcon);
			addChild(startActivityIcon);
		}
	}
}