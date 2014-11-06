package com.maninsoft.smart.ganttchart.command
{
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;

	public class GanttNodeDeleteCommand extends Command
	{
		
		private var _node: Node;
		private var _index: int;
		private var _parent: Node;
		private var _links: Array;
		private var _subIndex: int;
		private var _myTaskGroup: GanttTaskGroup;
		private var _ganttPackage: GanttPackage;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function GanttNodeDeleteCommand(node:Node, index: int)
		{
			super();
			
			_parent = node.parent;
			_node = node;
			_index = index;
			_ganttPackage = XPDLDiagram(_parent.diagram).xpdlPackage as GanttPackage;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			_links = _node.links;
			redo();
		}
		
		override public function redo(): void {
			_myTaskGroup = _node["taskGroup"] as GanttTaskGroup;
			if(_myTaskGroup){
				_subIndex = Activity(_node).nodeIndex - _myTaskGroup.nodeIndex - 1;
			}
			if(_node is GanttTaskGroup && GanttTaskGroup(_node).subProcess){
				_node.diagram.removeLinks(GanttTaskGroup(_node).subProcess.transitions);
				for each(var act:Activity in GanttTaskGroup(_node).subProcess.activities)
					_parent.removeChild(act);
				_ganttPackage.removeSubProcess(GanttTaskGroup(_node).subProcess);
			}

			_node.diagram.removeLinks(_links);
			_parent.removeChild(_node);
		
			if(_myTaskGroup){
				_ganttPackage.removeLinksInSubProcess(_links);
				_ganttPackage.removeNodeInSubProcess(_myTaskGroup.subProcess.id, _node);
			}	
		}
		
		override public function undo(): void  {
			if(_node is GanttTaskGroup && GanttTaskGroup(_node).subProcess){
				_ganttPackage.addSubProcess(GanttTaskGroup(_node).subProcess);
			}
			_parent.addChildAt(_node, _index);
			_node.diagram.addLinks(_links);
			
			if(_myTaskGroup)
				_ganttPackage.addNodeInSubProcess(_myTaskGroup.subProcess.id, _subIndex, _node);
				_ganttPackage.addLinksInSubProcess(_myTaskGroup.subProcess.id, _links)
		}
	}
}