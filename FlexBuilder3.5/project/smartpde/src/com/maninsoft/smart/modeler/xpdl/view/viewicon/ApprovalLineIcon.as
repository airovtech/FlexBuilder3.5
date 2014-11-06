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
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
	
	import flash.display.Graphics;
	
	import mx.core.SpriteAsset;
	
	/**
	 * Activity의 Performer가 설정됐을 때 표시
	 * 클릭하면 Performer 설정 툴 제공
	 */
	public class ApprovalLineIcon extends ViewIcon {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
	
		private var _approvalLineName: String;
		private var taskApprovalIcon:SpriteAsset = SpriteAsset(new XPDLEditorAssets.taskApprovalIcon());
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ApprovalLineIcon(view: IView) {
			super(view);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get approvalLineName(): String {
			return _approvalLineName;
		}
		
		public function set approvalLineName(value: String): void {
			_approvalLineName = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function get toolTip(): String {
			return _approvalLineName;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override protected function draw(g: Graphics): void {
			if(contains(taskApprovalIcon))
				removeChild(taskApprovalIcon);
			addChild(taskApprovalIcon);
		}
	}
}