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
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *  태스크에는 반드시 작업폼이 설정되어야 한다.(TaskHasNotApplicationError)
	 */
	public class TaskHasNotApplicationError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskHasNotApplicationError(task: TaskApplication) {
			super(task);
			
			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP018L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP018M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP018D");
		}
		
		public static function checkIt(buff: ArrayCollection, task: TaskApplication): void {
			addCount(TaskHasNotApplicationError);
			
			if (!task.applicationService) {
				buff.addItem(new TaskHasNotApplicationError(task));
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