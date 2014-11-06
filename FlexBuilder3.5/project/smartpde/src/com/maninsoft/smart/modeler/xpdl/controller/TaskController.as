////////////////////////////////////////////////////////////////////////////////
//  TaskController.as
//  2008.01.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.Task;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.base.TaskView;
	
	import flash.geom.Rectangle;
	
	/**
	 * Base controller for Task model
	 */
	public class TaskController extends ActivityController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskController(model: Task) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get taskModel(): Task {
			return nodeModel as Task;
		}

		
		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function initNodeView(nodeView: NodeView): void {
			super.initNodeView(nodeView);
			
			var view: TaskView = nodeView as TaskView;
			var task: Task = nodeModel as Task;

			view.text = task.name;
			view.startActivity = task.startActivity; 
//			view.performer = task.performer;
			view.performer = task.performerName;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: TaskView = view as TaskView;
			var m: Task = model as Task;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					if (m.name.length == 0) {
						v.text = " ";
					} else {
						v.text = m.name;
					}
					refreshView();
					break;
					
				case Activity.PROP_PERFORMER:
					v.performer = m.performerName;
					refreshView();
					break;
					
				default:
					super.nodeChanged(event);
			}
		}
	}
}