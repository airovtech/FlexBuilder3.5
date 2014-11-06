////////////////////////////////////////////////////////////////////////////////
//  InvalidStartTaskError.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.ActivityProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 시작 태스크는 반드시 시작이벤트로 부터 연결되어야 한다.
	 */
	public class InvalidStartTaskServiceError extends ActivityProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function InvalidStartTaskServiceError(task: TaskService) {
			super(task);
			
			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP003L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP003M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP003D");
		}
		
		public static function checkIt(buff: ArrayCollection, task: TaskService): void {
			addCount(InvalidStartTaskServiceError);
			
			if (task.startActivity && !task.isTransitedFrom(StartEvent)) {
				buff.addItem(new InvalidStartTaskServiceError(task));
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