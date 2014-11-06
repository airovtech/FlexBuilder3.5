////////////////////////////////////////////////////////////////////////////////
//  RootNodeController.as
//  2007.12.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.controller
{
	import com.maninsoft.smart.modeler.model.RootNode;
	import com.maninsoft.smart.modeler.view.IView;
	
	public class RootNodeController extends NodeController {
	
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function RootNodeController(model: RootNode) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * Property model
		 */
		public function get rootModel(): RootNode {
			return super.model as RootNode;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------

		/**
		 * root 노드는 뷰가 없다.
		 */
		override protected function createView(): IView {
			return null;
		}
	}
}