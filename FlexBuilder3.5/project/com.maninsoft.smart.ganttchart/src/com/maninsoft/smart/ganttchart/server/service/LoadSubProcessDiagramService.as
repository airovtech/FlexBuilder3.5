package com.maninsoft.smart.ganttchart.server.service
{
	import com.maninsoft.smart.ganttchart.parser.GanttReader;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.service.LoadDiagramService;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;

	public class LoadSubProcessDiagramService extends LoadDiagramService
	{
		private var dueDate:Date;
		public function LoadSubProcessDiagramService(dueDate:Date)
		{
			super();
			this.dueDate = dueDate;
		}

		override protected function doResult(event:ResultEvent): void {
			trace(event);
			_xpdlSource = new XML(StringUtil.trim(event.message.body.toString()));
			_diagram = new GanttReader(dueDate).parse(_xpdlSource) as XPDLDiagram;
			
			if (resultHandler != null)
				resultHandler(this);

		}
		
	}
}