////////////////////////////////////////////////////////////////////////////////
//  XPDLControllerFactory.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.impl.ControllerFactory;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.ganttchart.controller.ConstraintLineController;
	import com.maninsoft.smart.ganttchart.controller.GanttTaskController;
	import com.maninsoft.smart.ganttchart.controller.GanttTaskGroupController;
	import com.maninsoft.smart.ganttchart.model.ConstraintLine;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.controller.GanttChartGridController;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.ganttchart.controller.GanttMilestoneController;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	
	/**
	 * XPDL controller factory
	 */
	public class GanttControllerFactory extends ControllerFactory {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GanttControllerFactory(owner: GanttChart) {
			super(owner);
		}	


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function createController(model: DiagramObject): Controller {
			if (model is GanttChartGrid) {
				return new GanttChartGridController(model as GanttChartGrid);				
			}else if (model is ConstraintLine) {
				return new ConstraintLineController(model as ConstraintLine);
			}else if (model is GanttTask) {
				return new GanttTaskController(model as GanttTask);
			}else if (model is GanttTaskGroup) {
				return new GanttTaskGroupController(model as GanttTaskGroup);
			}else if (model is GanttMilestone) {
				return new GanttMilestoneController(model as GanttMilestone);
			}else {
				return super.createController(model);
			}
		}
	}
}