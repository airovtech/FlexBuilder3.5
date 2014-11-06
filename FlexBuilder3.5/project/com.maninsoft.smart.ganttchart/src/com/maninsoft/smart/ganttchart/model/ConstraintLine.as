package com.maninsoft.smart.ganttchart.model
{
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;

	public class ConstraintLine extends XPDLLink
	{
		public function ConstraintLine(source:Activity, target:Activity, path:String=null, connectType:String=null)
		{
			super(source, target, path, connectType);

		}				

		public function get isNodeDeletable():Boolean{
			return true; //!(GanttChartGrid.DEPLOY_MODE);			
		}

		override protected function createPropertyInfos(): Array {
			return null;
		}		
	}
}