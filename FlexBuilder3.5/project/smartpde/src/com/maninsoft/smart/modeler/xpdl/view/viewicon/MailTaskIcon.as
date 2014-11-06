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
	import com.maninsoft.smart.modeler.xpdl.view.TaskServiceView;
	
	import flash.display.Graphics;
	
	import mx.core.SpriteAsset;
	
	/**
	 * TaskApplication에 custemFormId가 설정됐을 때 표시
	 */
	public class MailTaskIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var mailTaskIcon: SpriteAsset = SpriteAsset(new XPDLEditorAssets.mailTaskIcon());	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MailTaskIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(mailTaskIcon))
				removeChild(mailTaskIcon);
			addChild(mailTaskIcon);
		}
		
		override public function get toolTip(): String {
			var view:TaskServiceView = super.view as TaskServiceView
			return view.mailReceivers;		
		}
	}
}