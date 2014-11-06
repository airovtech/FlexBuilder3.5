package com.maninsoft.smart.ganttchart.editor
{
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	
	/**
	 * XPDL 프로세스 Viewer
	 */
	public class GanttChartViewer extends GanttChart {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GanttChartViewer() {
			super();
			
			readOnly = true;
			gripMode = false;
			GanttChartGrid.readOnly = true;
			GanttChartGrid.DEPLOY_MODE = false;
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
		}

		//----------------------------------------------------------------------
		// Overriden methdods
		//----------------------------------------------------------------------
		override public function get scrollMargin():Number{
			return 0;
		}
	}
}