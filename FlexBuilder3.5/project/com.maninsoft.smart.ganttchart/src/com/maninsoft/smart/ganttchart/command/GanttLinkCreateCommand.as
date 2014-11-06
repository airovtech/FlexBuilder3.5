////////////////////////////////////////////////////////////////////////////////
//  Node.as
//  2007.12.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.command
{
	import com.maninsoft.smart.ganttchart.model.process.GanttPackage;
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.model.Diagram;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	
	/**
	 * 링크를 생성하는 커맨드
	 */
	public class GanttLinkCreateCommand extends Command {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _diagram: Diagram;
		private var _link: Link;
		private var _subProcessId: String;
		private var _package: GanttPackage;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GanttLinkCreateCommand(link: Link, subProcessId: String) {
			super();
			
			_link = link;
			_diagram = link.diagram;
			_subProcessId = subProcessId;
			var dsfd:XPDLDiagram;
			_package = XPDLDiagram(link.diagram).xpdlPackage as GanttPackage;
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			_diagram.addLink(_link);
						
			if(_subProcessId)
				_package.addLinkInSubProcess(_subProcessId, _link);
				
		}
		
		override public function undo(): void {
			_diagram.removeLink(_link);
			
			if(_subProcessId)
				_package.removeLinkInSubProcess(_link);
			
		}
	}
}