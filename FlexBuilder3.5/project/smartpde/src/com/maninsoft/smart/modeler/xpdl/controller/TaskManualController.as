package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.xpdl.model.base.Task;
	import com.maninsoft.smart.modeler.xpdl.model.TaskManual;
	import com.maninsoft.smart.modeler.xpdl.view.TaskManualView;
	import com.maninsoft.smart.modeler.view.NodeView;

	public class TaskManualController extends TaskController
	{
		public function TaskManualController(model:Task)
		{
			super(model);
		}
		
		public function get taskManual(): TaskManual {
			return taskModel as TaskManual;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new TaskManualView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: TaskManualView = nodeView as TaskManualView;
			var m: TaskManual = model as TaskManual;
		}
				
	}
}