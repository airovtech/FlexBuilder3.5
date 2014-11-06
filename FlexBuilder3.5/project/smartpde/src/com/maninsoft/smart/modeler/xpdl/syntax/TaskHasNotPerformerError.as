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
	 *  태스크에는 반드시 수행자가  설정되어야 한다.(TaskHasNotPerformerError)
	 */
	public class TaskHasNotPerformerError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskHasNotPerformerError(task: TaskApplication) {
			super(task);
			
			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP015L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP015M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP015D");
		}
		
		public static function checkIt(buff: ArrayCollection, task: TaskApplication): void {
			addCount(TaskHasNotPerformerError);
			
			if (!task.performer) {
				buff.addItem(new TaskHasNotPerformerError(task));
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