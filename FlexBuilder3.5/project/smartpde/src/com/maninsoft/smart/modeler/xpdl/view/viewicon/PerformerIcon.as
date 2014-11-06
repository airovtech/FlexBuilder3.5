////////////////////////////////////////////////////////////////////////////////
//  PerformerIcon.as
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
	
	/**
	 * Activity의 Performer가 설정됐을 때 표시
	 * 클릭하면 Performer 설정 툴 제공
	 */
	public class PerformerIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
	
		private var _performer: Object;
		private var taskUserIcon:SpriteAsset = SpriteAsset(new XPDLEditorAssets.taskUserIcon());
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PerformerIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get performer(): Object {
			return _performer;
		}
		
		public function set performer(value: Object): void {
			_performer = value;
			//viewBoolean = false;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return /*"수행자: " + */(_performer ? _performer.toString() : "?");
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(taskUserIcon))
				removeChild(taskUserIcon);
			addChild(taskUserIcon);
		}
	}
}