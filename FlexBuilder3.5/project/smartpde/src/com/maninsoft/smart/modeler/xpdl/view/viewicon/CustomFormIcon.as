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
	
	/**
	 * TaskApplication에 custemFormId가 설정됐을 때 표시
	 */
	public class CustomFormIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var customFormIcon: SpriteAsset = SpriteAsset(new XPDLEditorAssets.taskCustomFormIcon());	

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function CustomFormIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * formId
		 */
		private var _customFormId: String;
		
		public function get customFormId(): String {
			return _customFormId;
		}
		
		public function set customFormId(value: String): void {
			_customFormId = value;
		}

		/**
		 * formName
		 */
		private var _customFormName: String;
		
		public function get customFormName(): String {
			return _customFormName;
		}
		
		public function set customFormName(value: String): void {
			_customFormName = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return customFormName;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(customFormIcon))
				removeChild(customFormIcon);
			addChild(customFormIcon);
		}
	}
}