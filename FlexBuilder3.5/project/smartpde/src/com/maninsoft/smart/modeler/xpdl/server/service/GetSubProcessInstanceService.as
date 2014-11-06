package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.parser.XPDLReader;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;

	public class GetSubProcessInstanceService extends LoadInstanceService
	{
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			_xpdlSource = new XML(StringUtil.trim(event.message.body.toString()));			
			_diagram = new XPDLReader().parse(_xpdlSource) as XPDLDiagram;
			if (resultHandler != null)
				resultHandler(this);
		}		
	}
}