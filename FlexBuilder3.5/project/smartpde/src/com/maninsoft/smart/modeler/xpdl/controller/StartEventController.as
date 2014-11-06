////////////////////////////////////////////////////////////////////////////////
//  StartEventController.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.controller.ControllerTool;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.NextTaskCreationTool;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.view.StartEventView;
	import com.maninsoft.smart.modeler.xpdl.view.base.ActivityView;
	
	/**
	 * Controller for StartEvent
	 */	
	public class StartEventController extends EventController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function StartEventController(model: StartEvent) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new StartEventView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);
			StartEventView(nodeView).startActivity = getStartActivity();
		}

		override protected function createTools(): Array {
			var tools: Array = [];
			var tool: ControllerTool;
			
			tool = new NextTaskCreationTool(this);
			tools.push(tool);
			
			return tools;
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: StartEventView = view as StartEventView;
			
			switch (event.prop) {
				case Activity.PROP_STARTACTIVITY:
					v.startActivity = getStartActivity();
					refreshView();
					break;
					
				default:
					super.nodeChanged(event);
			}
		}


		override protected function checkStatus(status: String, view: ActivityView): void {
			super.checkStatus(status, view);

			var nextActivityStatus: String = getNextActivityStatus();
			switch (nextActivityStatus) {
				case Activity.STATUS_PROCESSING: // Assigned to the performer and started, but finished yet
				case Activity.STATUS_COMPLETED: // finished task 
				case Activity.STATUS_SUSPENDED: // Process is stopped at the task
				case Activity.STATUS_DELAYED: // Assigned to the performer, but not started yet even the planed start time is over
					view.fillColor = 0xbbbbbb;
					view.borderColor = 0x767676;
					break;

				case Activity.STATUS_CREATED:// Created Activity, but planned to be started.
					view.fillColor = 0xbdda7d;
					view.borderColor = 0x767676;
					break;	
			}
		}
		
		private function getNextActivityStatus():String{
			if(!activity.outgoingLinks || (activity.outgoingLinks && activity.outgoingLinks.length!=1))
				return null;
			if(XPDLLink(activity.outgoingLinks[0]).target is Activity){
				var nextActivity: Activity = XPDLLink(activity.outgoingLinks[0]).target as Activity;
				if(nextActivity)
					return nextActivity.status;
			}
			return null;
		}

		private function getStartActivity(): Boolean{
			if(!activity.outgoingLinks || (activity.outgoingLinks && activity.outgoingLinks.length!=1))
				return false;
			if(XPDLLink(activity.outgoingLinks[0]).target is Activity){
				var nextActivity: Activity = XPDLLink(activity.outgoingLinks[0]).target as Activity;
				if(nextActivity)
					return nextActivity.startActivity;
			}
			return false;
		}
	}
}