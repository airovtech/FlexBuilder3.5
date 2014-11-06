package com.maninsoft.smart.ganttchart.parser
{
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.parser.XPDLReader;

	public class GanttReader extends XPDLReader
	{
		private var dueDate:Date;
		
		public function GanttReader(dueDate:Date)
		{
			super();
			this.dueDate = dueDate;
		}

		override public function parse(source: XML): Diagram {
			XPDLElement._ns = source.namespace("xpdl");

			var ganttPackage: GanttPackage = new GanttPackage(dueDate);
			ganttPackage.read(source);
			
			//trace("parse...\r\n" + xpdlPackage.toString());
			
			var dgm: XPDLDiagram = new XPDLDiagram();
			dgm.xpdlPackage = ganttPackage;
			
			return dgm;
		}
	}
}