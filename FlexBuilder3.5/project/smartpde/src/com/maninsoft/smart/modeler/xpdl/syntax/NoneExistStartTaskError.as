////////////////////////////////////////////////////////////////////////////////
//  NoneExistStartTaskError.as
//  2008.03.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.syntax
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.syntax.base.DiagramProblem;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 다이어그램에 시작 태스크가 없다.
	 */
	public class NoneExistStartTaskError extends DiagramProblem {
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NoneExistStartTaskError(diagram: XPDLDiagram) {
			super(diagram);

			level = LEVEL_ERROR;
			label = resourceManager.getString("ProcessEditorMessages", "PEP006L");
			message = resourceManager.getString("ProcessEditorMessages", "PEP006M");
			description = resourceManager.getString("ProcessEditorMessages", "PEP006D"); 
		}

		public static function checkIt(buff: ArrayCollection, diagram: XPDLDiagram): void {
			addCount(NoneExistStartTaskError);
			
			var acts: Array = diagram.pool.getActivities(TaskApplication);
			
			if (acts.length > 0) {
				for each (var act: TaskApplication in acts) 
					if (act.startActivity)
						return;
			}
			
			buff.addItem(new NoneExistStartTaskError(diagram));
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		protected function get pool(): Pool {
			return XPDLDiagram(source).pool;
		}
		

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		/**
		 * TaskApplication 이 하나라도 존재하면 처리 가능하다.
		 */
		override public function get canFixUp(): Boolean {
			return pool.hasActivityOf(TaskApplication);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		override public function fixUp(editor: XPDLEditor): void {
			var task: TaskApplication = pool.getFirstTask();

			if (task)
				task.startActivity = true;
		}
	}
}