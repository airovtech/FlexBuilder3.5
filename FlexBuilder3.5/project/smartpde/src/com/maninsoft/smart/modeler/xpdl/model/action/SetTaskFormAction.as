////////////////////////////////////////////////////////////////////////////////
//  SetTaskFormAction.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.action
{
	import com.maninsoft.smart.modeler.action.Action;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectFormDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	
	/**
	 * TaskApplication 등의 작업폼을 지정한다.
	 */
	public class SetTaskFormAction extends Action {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _task: TaskApplication;
		private var _forms: Array;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function SetTaskFormAction(task: TaskApplication)	{
			super("작업폼 지정...");
			
			_task = task;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get diagram(): XPDLDiagram {
			return _task.xpdlDiagram;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			SelectFormDialog.execute(diagram.server, _task.formId, dlgAccepted);
		}
		
		private function dlgAccepted(form: TaskForm): void {
			_task.formId = form ? form.id : null;
			_task.formVersion = form ? form.version : null;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	}
}