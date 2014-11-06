////////////////////////////////////////////////////////////////////////////////
//  XPDLLinkController.as
//  2008.01.07, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.model.events.LinkChangeEvent;
	import com.maninsoft.smart.modeler.view.IView;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.ShowMappingTool;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.view.base.XPDLLinkView;
	
	
	/**
	 * Controller for XPDLLink
	 */
	public class XPDLLinkController extends LinkController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function XPDLLinkController(model: XPDLLink) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------

		override protected function createView(): IView {
			var view: XPDLLinkView = new XPDLLinkView(calcConnectPoints());
			var m: XPDLLink = model as XPDLLink;
			if (view) {
				view.label = m.name;
				view.isDefault = m.isDefault;
				view.problem = m.problem; 
			
				if(m.status == XPDLLink.STATUS_COMPLETED || checkNeighborStatus()){
					view.lineColor = 0xbbbbbb;
				}
				view.refresh();
			}
			return view;
		}

		private function checkNeighborStatus(): Boolean{
			if(targetNode && targetNode is Activity){
				var nextActivity: Activity = targetNode as Activity;
				if(nextActivity.incomingLinks.length==1 && nextActivity.incomingLinks[0] == this.model){
					if(	   nextActivity.status == Activity.STATUS_COMPLETED 
						|| nextActivity.status == Activity.STATUS_PROCESSING 
						|| nextActivity.status == Activity.STATUS_SUSPENDED 
						|| nextActivity.status == Activity.STATUS_RETURNED 
						|| nextActivity.status==Activity.STATUS_DELAYED)
						return true;
					else
						return false;
				}
			}
			if(sourceNode && sourceNode is Activity){
				var prevActivity: Activity = sourceNode as Activity;
				if(prevActivity.outgoingLinks.length==1 && prevActivity.outgoingLinks[0] == this.model){
					if(prevActivity.status == Activity.STATUS_COMPLETED)
						return true;
					else
						return false;
				}				
			}
			return false;
		}
		override protected function createTools(): Array {
			var tools: Array = [];
			
			tools.push(new ShowMappingTool(this));
			
			return tools;
		}

		override protected function linkChanged(event: LinkChangeEvent): void {
			var v: XPDLLinkView = view as XPDLLinkView;
			var m: XPDLLink = model as XPDLLink;
			
			switch (event.prop) {
				case XPDLLink.PROP_NAME:
					if (m.name.length == 0) {
						// null도 안되고 ""도 안된다.
						// " "만 된다. 2009.01.16 sjyoon
						v.label = " ";
					} else {
						v.label = m.name;
					}
					super.refreshView();
					break;
				
				case XPDLLink.PROP_ISDEFAULT:
					v.isDefault = m.isDefault;
					super.refreshView();
					break;
					
				case XPDLLink.PROP_PROBLEM:
					v.problem = m.problem;
					super.refreshView();
					break;
					
				default:
					super.refreshView();
					break;
			}
		}
	}
}