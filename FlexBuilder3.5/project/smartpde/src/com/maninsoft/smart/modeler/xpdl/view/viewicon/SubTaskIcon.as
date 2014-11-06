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
	import mx.resources.ResourceManager;
	
	/**
	 * Activity의 Performer가 설정됐을 때 표시
	 * 클릭하면 Performer 설정 툴 제공
	 */
	public class SubTaskIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _subProcessName: String;
		private var subTaskIcon:SpriteAsset = SpriteAsset(new XPDLEditorAssets.subTaskIcon());
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SubTaskIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get subProcessName():String{
			return _subProcessName;
		}
		
		public function set subProcessName(value: String): void{
			_subProcessName = value;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return _subProcessName;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(subTaskIcon))
				removeChild(subTaskIcon);
			addChild(subTaskIcon);
		}
	}
}