package com.maninsoft.smart.ganttchart.parser
{
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.process.XPDLElement;
	import com.maninsoft.smart.modeler.xpdl.parser.XPDLWriter;

	public class GanttWriter extends XPDLWriter
	{
		public function GanttWriter()
		{
			super();
		}

		override public function serialize(dgm: XPDLDiagram): XML {
			var pack: GanttPackage = dgm.xpdlPackage as GanttPackage;
			var xml: XML = <xpdl:Package xmlns:xpdl="http://www.wfmc.org/2004/XPDL2.0alpha"/>;
						
			pack.process.activities = dgm.activities;
			pack.process.transitions = dgm.transitions;
			pack.artifacts = dgm.artifacts;
			
			XPDLElement._ns = xml.namespace();
			pack.write(xml);
			
			trace("serialize...\r\n" + xml.toXMLString());
			
			return xml;
		}
		
	}
}