////////////////////////////////////////////////////////////////////////////////
//  Node.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.command
{
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	
	/**
	 * 노드를 생성하는 커맨드
	 */
	public class GanttNodeCreateCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _node: Node;
		private var _index: int;
		private var _parent: Node;
		private var _ganttPackage: GanttPackage;
		private var _myTaskGroup:GanttTaskGroup;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GanttNodeCreateCommand(parent: Node, index: int, node: Node) {
			super();
			
			_node = node;
			_index = index;
			_parent = parent;
			_ganttPackage = XPDLDiagram(_parent.diagram).xpdlPackage as GanttPackage; 
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {

			if(_node is GanttTaskGroup && GanttTaskGroup(_node).subProcess){
				_ganttPackage.removeSubProcess(GanttTaskGroup(_node).subProcess);
			}

			_parent.removeChild(_node);

			if(_myTaskGroup){
				_ganttPackage.removeNodeInSubProcess(_myTaskGroup.subProcess.id, _node);
			}
		}
		
		override public function redo(): void {
			if(_node is GanttTaskGroup && GanttTaskGroup(_node).subProcess){
				_ganttPackage.addSubProcess(GanttTaskGroup(_node).subProcess);
			}

			_myTaskGroup = _node["taskGroup"] as GanttTaskGroup;

			if(_myTaskGroup){
				var subIndex: int = _index - _myTaskGroup.nodeIndex - 1;
				_ganttPackage.addNodeInSubProcess(_myTaskGroup.subProcess.id, subIndex, _node);
			}

			if(!_parent.children || _index>=_parent.children.length){
				_parent.addChild(_node);
				_index=_parent.children.length-1;
			}else{
				_parent.addChildAt(_node, _index);
			}
			
			_node["taskGroup"]=_myTaskGroup;
			if(_node is GanttTaskGroup && GanttTaskGroup(_node).subProcess){
				GanttTaskGroup(_node).subProcess.parentId = GanttTaskGroup(_node).id.toString();
			}
		}
	}
}