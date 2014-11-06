////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeForm.as
//  2008.04.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.assets.DiagramNavigatorAssets;
	
	/**
	 * DiagramTree activity 에 설정된 taskForm을 나타낸다.
	 */
	public class DiagramTreeForm extends DiagramTreeNode {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _task: TaskApplication;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DiagramTreeForm(task: TaskApplication) {
			super();
			
			_task = task;
		}

		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * task
		 */
		public function get task(): TaskApplication {
			return _task;
		}
		
		/**
		 * form
		 */
		public function get formId(): String {
			return _task.formId;
		}

		
		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get label(): String {
			return _task.formName;
		}
		
		public function set label(val:String): void {
			_task.formName = val;
		}
		
		override public function get icon(): Class {
			return DiagramNavigatorAssets.formIcon;
		}

		override public function get editable(): Boolean {
			return true;
		}
	}
}