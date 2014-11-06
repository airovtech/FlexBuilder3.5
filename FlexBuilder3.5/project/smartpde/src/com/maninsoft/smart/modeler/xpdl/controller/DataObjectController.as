////////////////////////////////////////////////////////////////////////////////
//  DataObjectController.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.DataObject;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.DataObjectView;
	
	/**
	 * Controller for DataObject
	 */	
	public class DataObjectController extends ArtifactController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function DataObjectController(model: DataObject) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new DataObjectView();
		}

		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var view: DataObjectView = nodeView as DataObjectView;
			view.borderColor = 	DataObject(nodeModel).borderColor = 0xa0c4ce; 			
			view.text = DataObject(nodeModel).name;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: DataObjectView = view as DataObjectView;
			var m: DataObject = model as DataObject;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:	
					if (m.name.length == 0) {
						v.text = " ";
					} else {
						v.text = m.name;
					}
					break;

				default:
					super.nodeChanged(event);
			}
		}
	}
}