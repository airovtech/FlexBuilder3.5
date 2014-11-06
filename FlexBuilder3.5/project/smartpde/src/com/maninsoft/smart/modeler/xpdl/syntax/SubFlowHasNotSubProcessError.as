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
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 *  태스크에는 반드시 작업폼이 설정되어야 한다.(TaskHasNotFormError)
	 */
	public class SubFlowHasNotSubProcessError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SubFlowHasNotSubProcessError(subTask: SubFlow) {
			super(subTask);
			
			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP016L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP016M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP016D");
		}
		
		public static function checkIt(buff: ArrayCollection, subTask: SubFlow): void {
			addCount(SubFlowHasNotSubProcessError);
			
			if (!subTask.subProcessId) {
				buff.addItem(new SubFlowHasNotSubProcessError(subTask));
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