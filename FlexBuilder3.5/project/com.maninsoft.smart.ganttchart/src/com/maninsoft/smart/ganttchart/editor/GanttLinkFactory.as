////////////////////////////////////////////////////////////////////////////////
//  XPDLLinkFactory.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor
{
	import com.maninsoft.smart.modeler.editor.impl.LinkFactory;
	import com.maninsoft.smart.modeler.model.Link;
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.ganttchart.model.ConstraintLine;
	
	/**
	 * XPDLEditor를 위한 Link factory
	 */
	public class GanttLinkFactory extends LinkFactory {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function GanttLinkFactory(owner: GanttChart) {
			super(owner);
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		override public function createLink(linkType: String, source: Node, target: Node, path: String = null, connectType: String = null): Link {
			var link: ConstraintLine = new ConstraintLine(source as Activity, target as Activity, path, connectType);
			return link;
		}
	}
}