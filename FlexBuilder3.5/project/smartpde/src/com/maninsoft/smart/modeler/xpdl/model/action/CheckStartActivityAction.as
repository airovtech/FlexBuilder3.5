////////////////////////////////////////////////////////////////////////////////
//  CheckStartActivityAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.action
{
	import com.maninsoft.smart.modeler.action.ToggleAction;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	/**
	 * Activity의 StartActivity를 설정한다.
	 */
	public class CheckStartActivityAction extends ToggleAction {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _activity: Activity;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function CheckStartActivityAction(activity: Activity) {
			super("시작 Activity로 지정");
			
			_activity = activity;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function get toggled(): Boolean {
			return _activity.startActivity;
		}
		
		override public function execute(): void {
			_activity.startActivity = !_activity.startActivity;
		}
	}
}