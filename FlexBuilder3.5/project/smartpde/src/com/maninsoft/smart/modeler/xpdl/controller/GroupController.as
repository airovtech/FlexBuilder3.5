////////////////////////////////////////////////////////////////////////////////
//  GroupController.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.Group;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.GroupView;
	
	/**
	 * Controller for Group
	 */	
	public class GroupController extends ArtifactController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GroupController(model: Group) {
			super(model);
		}

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new GroupView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var view: GroupView = nodeView as GroupView;

			view.text = Group(nodeModel).name;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: GroupView = view as GroupView;
			var m: Group = model as Group;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:	
					v.text = m.name;
					break;

				default:
					super.nodeChanged(event);
			}
		}
	}
}