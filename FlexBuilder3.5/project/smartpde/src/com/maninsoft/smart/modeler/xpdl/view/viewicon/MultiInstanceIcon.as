////////////////////////////////////////////////////////////////////////////////
//  MultiInstanceIcon.as
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
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	import flash.display.Graphics;
	
	import mx.core.SpriteAsset;
	import mx.resources.ResourceManager;
	
	/**
	 * Activity의 Multi-Instance가 설정됐을 때 표시
	 * 클릭하면 Multi-Instance Behavior 설정 툴 제공
	 */
	public class MultiInstanceIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
	
		private var _multiInstanceBehavior: String;
		private var multiInstanceIcon:SpriteAsset = SpriteAsset(new XPDLEditorAssets.multiInstanceIcon());
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MultiInstanceIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get multiInstanceBehavior(): String {
			return _multiInstanceBehavior;
		}
		
		public function set multiInstanceBehavior(value: String): void {
			_multiInstanceBehavior = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			if(_multiInstanceBehavior == Activity.BEHAVIOR_NONE)
				return ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorNoneText");
			else if(_multiInstanceBehavior == Activity.BEHAVIOR_ALL)
				return ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorAllText");
			else if(_multiInstanceBehavior == Activity.BEHAVIOR_ONE)
				return ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorOneText");
			return ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorNoneText");
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(multiInstanceIcon))
				removeChild(multiInstanceIcon);
			addChild(multiInstanceIcon);
		}
	}
}