////////////////////////////////////////////////////////////////////////////////
//  TaskHasNotFormError.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *  태스크에는 반드시 작업폼이 설정되어야 한다.(TaskHasNotFormError)
	 */
	public class TaskServiceHasNotServiceIdError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskServiceHasNotServiceIdError(task: TaskService) {
			super(task);
			
			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP017L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP017M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP017D");
		}
		
		public static function checkIt(buff: ArrayCollection, task: TaskService): void {
			addCount(TaskServiceHasNotServiceIdError);

			if (task.serviceType == TaskService.SERVICE_TYPE_SYSTEM && (!task.serviceId || task.serviceId == SystemService.EMPTY_SYSTEM_SERVICE)) {
				buff.addItem(new TaskServiceHasNotServiceIdError(task));
			}
		}

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get canFixUp(): Boolean {
			return false;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function fixUp(editor: XPDLEditor): void {
		}
	}
}