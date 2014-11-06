////////////////////////////////////////////////////////////////////////////////
//  SetActivityPerformerAction.as
//  2008.01.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.action
{
	import com.maninsoft.smart.modeler.action.Action;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectUserDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	
	/**
	 * Activity의 수행자를 설정한다.
	 */
	public class SetActivityPerformerAction extends Action {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _activity: Activity;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SetActivityPerformerAction(activity: Activity) {
			super("수행자 설정...");
			
			_activity = activity;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			if(_activity is TaskApplication){
				var task:TaskApplication = _activity as TaskApplication;
				SelectUserDialog.execute(null, _activity.performer, task, dlgAccepted);
			}else{
				SelectUserDialog.execute(null, _activity.performer, null, dlgAccepted);
			}
		}
		
		private function dlgAccepted(user: String): void {
			_activity.performer = user;		
		}
	}
}