////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeFactory.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor
{
	import com.maninsoft.smart.ganttchart.model.GanttMilestone;
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.modeler.editor.INodeFactory;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	/**
	 * XPLD node factory
	 */
	public class GanttNodeFactory implements INodeFactory {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _owner: GanttChart;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function GanttNodeFactory(owner: GanttChart) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		public function createNode(nodeType: String): Node {
			var node: XPDLNode = null;
			
			switch (nodeType) {
				case "GanttTask":
					node = new GanttTask();
					break;
					
				case "GanttTaskGroup":
					node = new GanttTaskGroup();
					break;
					
				case "GanttSubTask":
					node = new GanttTask();
					break;
					
				case "GanttMilestone":
					node = new GanttMilestone();
					break;					
			}			
			return node;
		}
	}
}