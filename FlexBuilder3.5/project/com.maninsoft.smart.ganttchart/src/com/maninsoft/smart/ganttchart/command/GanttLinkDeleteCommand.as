package com.maninsoft.smart.ganttchart.command
{
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;

	public class GanttLinkDeleteCommand extends Command
	{
		
		private var _diagram: Diagram;
		private var _package: GanttPackage;
		private var _link: Link;
		private var _subProcessId: String;


		public function GanttLinkDeleteCommand(link:Link)
		{
			super();
			_link = link;
			_diagram = link.diagram;
			_package = XPDLDiagram(link.diagram).xpdlPackage as GanttPackage;
		}
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			_diagram.removeLink(_link);
			_subProcessId = _package.removeLinkInSubProcess(_link);
		}
		
		override public function undo(): void  {
			_diagram.addLink(_link);
			if(_subProcessId)
				_package.addLinkInSubProcess(_subProcessId, _link);
		}
	}
}