////////////////////////////////////////////////////////////////////////////////
//  TaskApplicationErrors.as
//  2008.03.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 태스크 어플리케이션에 관한 에러들을 검사한다.
	 * 1. 시작 태스크는 반드시 시작이벤트로 부터 연결되어야 한다.(InvalidStartTaskError)
	 * 2. 반드시 폼이 설정되어야 한다.(TaskHasNotFormError)
	 */
	public class TaskApplicationErrors extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskApplicationErrors(diagram: XPDLDiagram) {
			super(diagram);
		}

		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(TaskApplicationErrors);
			
			for each (var task: TaskApplication in diagram.pool.getActivities(TaskApplication)) {
				InvalidStartTaskError.checkIt(buff, task); 
				if(task.isCustomForm==true)
					TaskHasNotApplicationError.checkIt(buff, task);
				else
					TaskHasNotFormError.checkIt(buff, task);
				TaskHasNotPerformerError.checkIt(buff, task);
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
	}
}