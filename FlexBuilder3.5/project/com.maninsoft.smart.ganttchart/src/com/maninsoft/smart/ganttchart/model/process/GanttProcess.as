package com.maninsoft.smart.ganttchart.model.process
{
	import com.maninsoft.smart.ganttchart.model.ConstraintLine;
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;

	public class GanttProcess extends WorkflowProcess
	{
		public function GanttProcess(owner:GanttPackage)
		{
			super(owner);
		}

		override public function read(xml: XML): void {
			super.read(xml);
		}
		
		override public function write(xml: XML): void {
			super.write(xml);
		}	

		public function getGanttPackage(): GanttPackage {
			return super.owner as GanttPackage;
		}
		
		override protected function readActivity(xml: XML): Activity {
			var act: Activity = null;
			
				
			if (xml._ns::Implementation.length() > 0) {
				if (xml._ns::Implementation._ns::Task.length() > 0) {
					if (xml._ns::Implementation._ns::Task._ns::TaskApplication.length() > 0) {
						act = new GanttTask();
						GanttTask(act).ganttBaseDateDiff = getGanttPackage().baseDateDiff;
					}
					else if (xml._ns::Implementation._ns::Task._ns::TaskManual.length() > 0) {
						act = new GanttMilestone();
						GanttMilestone(act).ganttBaseDateDiff = getGanttPackage().baseDateDiff;
					}
				}else if (xml._ns::Implementation._ns::SubFlow.length() > 0) {
					act = new GanttTaskGroup();
					GanttTaskGroup(act).ganttBaseDateDiff = getGanttPackage().baseDateDiff;
				}
			}
			if (act) {
				act.read(xml);
			}
						
			return act;
		}
		
		override protected function readTransition(xml: XML): XPDLLink {
			var source: Activity = findActivity(xml.@From);
			var target: Activity = findActivity(xml.@To);
			var path: String = xml._ns::ConnectorGraphicsInfos._ns::ConnectorGraphicsInfo.@Path;
			
			var link: ConstraintLine = new ConstraintLine(source, target, path);
			
			link.read(xml);
			
			return link;
		}
	}
}