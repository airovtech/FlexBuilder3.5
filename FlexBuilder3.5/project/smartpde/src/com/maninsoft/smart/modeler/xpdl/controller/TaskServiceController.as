////////////////////////////////////////////////////////////////////////////////
//  TaskApplicationController.as
//  2008.01.11, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.controller
{
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.ViewIconEvent;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.view.TaskServiceView;
	
	/**
	 * Controller for TaskService
	 */	
	public class TaskServiceController extends TaskController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskServiceController(model: TaskService) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get taskService(): TaskService {
			return taskModel as TaskService;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override protected function createNodeView(): NodeView {
			return new TaskServiceView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: TaskServiceView = nodeView as TaskServiceView;
			var m: TaskService = model as TaskService;

			v.serviceType = m.serviceType;
			v.serviceId = m.serviceId;
			v.serviceName = m.serviceName;
			v.mailReceivers = resourceManager.getString("ProcessEditorETC", "mailReceiversText") + ":" + (m.mailReceivers ? m.mailReceivers.name : m.mailCcReceivers ? m.mailCcReceivers.name : m.mailBccReceivers ? m.mailBccReceivers.name : resourceManager.getString("ProcessEditorETC", "noneText"));
			
			nodeView.addEventListener(ViewIconEvent.ICON_CLICK, doViewIconClick);
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: TaskServiceView = view as TaskServiceView;
			var m: TaskService = model as TaskService;
			
			switch (event.prop) {
				case TaskService.PROP_SERVICE_ID:
					if(event.oldValue && event.oldValue != SystemService.EMPTY_SYSTEM_SERVICE)
						XPDLEditor(editor).xpdlDiagram.xpdlPackage.process.removeExtApplication(event.oldValue as String, m);
					if(m.serviceId && m.systemService && m.serviceId != SystemService.EMPTY_SYSTEM_SERVICE)
						XPDLEditor(editor).xpdlDiagram.xpdlPackage.process.addExtApplication(m.serviceId, m.systemService, m);
					else
						m.actualParameters = null;
					v.serviceId = m.serviceId;
					v.serviceName = m.serviceName;
					refreshView();
					break;
				
				case TaskService.PROP_SERVICE_TYPE:
					if(m.serviceId && m.systemService && m.serviceId != SystemService.EMPTY_SYSTEM_SERVICE)
						XPDLEditor(editor).xpdlDiagram.xpdlPackage.process.removeExtApplication(m.serviceId as String, m);
					m.actualParameters = null;
					
					m.mailReceivers = null;
					m.mailCcReceivers = null;
					m.mailBccReceivers = null;
					m.mailSubject = null;
					m.mailContent = null;
					m.mailAttachment = null;
					
					v.serviceType = m.serviceType;
					v.serviceId = m.serviceId = null;
					v.serviceName = m.serviceName = null;
					v.mailReceivers = resourceManager.getString("ProcessEditorETC", "mailReceiversText") + ":" + resourceManager.getString("ProcessEditorETC", "noneText");
					refreshView();
					refreshPropertyPage();
					break;
									
				case TaskService.PROP_MAIL_RECEIVERS:
				case TaskService.PROP_MAIL_CC_RECEIVERS:
				case TaskService.PROP_MAIL_BCC_RECEIVERS:
				case TaskService.PROP_MAIL_SUBJECT:
				case TaskService.PROP_MAIL_CONTENT:
				case TaskService.PROP_MAIL_ATTACHMENT:
					v.mailReceivers = resourceManager.getString("ProcessEditorETC", "mailReceiversText") + ":" + (m.mailReceivers ? m.mailReceivers.name : m.mailCcReceivers ? m.mailCcReceivers.name : m.mailBccReceivers ? m.mailBccReceivers.name : resourceManager.getString("ProcessEditorETC", "noneText"));
					refreshView();
					break;
									
				default:
					super.nodeChanged(event);
			}
		}

		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		private function doViewIconClick(event: ViewIconEvent): void {
			//AlertUtils.info(event.icon.toolTip);
		}
				
		private function refreshPropertyPage():void{
			if(editor.selectionManager.contains(this) && editor.selectionManager.items.length==1){
				editor.select(model);
			}
		}
	}
}