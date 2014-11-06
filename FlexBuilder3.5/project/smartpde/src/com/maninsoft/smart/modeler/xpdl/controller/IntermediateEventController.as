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
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.syntax.Problem;
	import com.maninsoft.smart.modeler.xpdl.view.IntermediateEventView;
	import com.maninsoft.smart.modeler.xpdl.view.base.ActivityView;
	
	import mx.controls.Alert;
	
	/**
	 * Controller for IntermediateEvent
	 */	
	public class IntermediateEventController extends EventController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function IntermediateEventController(model: IntermediateEvent) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new IntermediateEventView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);
			var m: IntermediateEvent = model as IntermediateEvent;
			var v: IntermediateEventView = nodeView as IntermediateEventView;
			
			v.eventType = m.eventType;
		}

		override protected function createTools(): Array {
			var tools: Array = [];
			var tool: ControllerTool;
			
			tool = new NextTaskCreationTool(this);
			tools.push(tool);
			
			return tools;
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var m: IntermediateEvent = model as IntermediateEvent;
			var v: IntermediateEventView = view as IntermediateEventView;
			
			switch (event.prop) {
				case IntermediateEvent.PROP_EVENT_TYPE:
					v.eventType = m.eventType;
					refreshPropertyPage();
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
		private function refreshPropertyPage():void{
			if(editor.selectionManager.contains(this) && editor.selectionManager.items.length==1){
				editor.select(model);
			}
		}
	}
}