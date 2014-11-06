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
	import com.maninsoft.smart.modeler.xpdl.model.Block;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.view.BlockView;
	
	/**
	 * Controller for Block
	 */	
	public class BlockController extends ArtifactController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function BlockController(model: Block) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new BlockView();
		}

		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var view: BlockView = nodeView as BlockView;
			view.borderColor = 	Block(nodeModel).borderColor = 0xa0c4ce; 			
			view.text = Block(nodeModel).name;
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: BlockView = view as BlockView;
			var m: Block = model as Block;
			
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