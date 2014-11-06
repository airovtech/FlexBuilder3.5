package com.maninsoft.smart.ganttchart.controller
{
	import com.maninsoft.smart.ganttchart.command.GanttLinkCreateCommand;
	import com.maninsoft.smart.ganttchart.command.GanttNodeCreateCommand;
	import com.maninsoft.smart.ganttchart.request.GanttLinkCreationRequest;
	import com.maninsoft.smart.ganttchart.request.GanttNodeCreationRequest;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.controller.RootController;
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.request.Request;

	public class GanttRootController extends RootController
	{
		public function GanttRootController(owner:DiagramEditor)
		{
			super(owner);
		}

		override public function getCommand(request: Request): Command{
			if (request is GanttNodeCreationRequest) {
				var req: GanttNodeCreationRequest = request as GanttNodeCreationRequest;
				
				var node: Node = owner.createNode(req.objectType); 
				
				node.x = req.pos.x;
				node.y = req.pos.y; 
				return new GanttNodeCreateCommand(owner.diagram.root, req.index, node);	
			} else if (request is GanttLinkCreationRequest) {
				var req2: GanttLinkCreationRequest = request as GanttLinkCreationRequest;
				var path: String = req2.sourceAnchor + "," + req2.targetAnchor;
				
				var link: Link = owner.createLink(req2.linkType, req2.source, req2.target, path);
				
				return new GanttLinkCreateCommand(link, req2.subProcessId);
			}
			
			return super.getCommand(request);
		}
	}
}