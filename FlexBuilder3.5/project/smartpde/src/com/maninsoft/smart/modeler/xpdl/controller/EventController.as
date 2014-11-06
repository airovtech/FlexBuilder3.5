////////////////////////////////////////////////////////////////////////////////
//  EventController.as
//  2008.04.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.model.Node;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.model.base.Event;
	
	/**
	 * Event controller base
	 */
	public class EventController extends ActivityController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function EventController(model: Event)	{
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function initNodeView(nodeView: NodeView): void {
			super.initNodeView(nodeView);
		}

		override public function get canPopUp(): Boolean {
			return false;
		}

		/**
		 * 현재 편집 가능한 상태인가?
		 */
		override public function canModifyText(): Boolean {
			return false;
		}
	}
}