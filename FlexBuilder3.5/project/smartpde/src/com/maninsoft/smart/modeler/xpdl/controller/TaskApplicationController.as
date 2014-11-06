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
	import com.maninsoft.smart.modeler.model.events.NodeChangeEvent;
	import com.maninsoft.smart.modeler.view.NodeView;
	import com.maninsoft.smart.modeler.view.ViewIconEvent;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.components.TaskFormPanel;
	import com.maninsoft.smart.modeler.xpdl.controller.tool.NextTaskCreationTool;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.action.SetTaskFormAction;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetApplicationServiceDefsService;
	import com.maninsoft.smart.modeler.xpdl.view.TaskApplicationView;
	import com.maninsoft.smart.modeler.xpdl.view.viewicon.TaskFormIcon;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * Controller for TaskApplication
	 */	
	public class TaskApplicationController extends TaskController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		private var _formPanel: TaskFormPanel;
		private var _formPanelVisible: Boolean;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function TaskApplicationController(model: TaskApplication) {
			super(model);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get taskApplication(): TaskApplication {
			return taskModel as TaskApplication;
		}


		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();
			var m: TaskApplication = model as TaskApplication;
			if(m.appId && m.isCustomForm && !m.applicationService)
				this.nodeChanged(new NodeChangeEvent(m, TaskApplication.PROP_APPLICATION_SERVICE));
		}
		
		override protected function createNodeView(): NodeView {
			return new TaskApplicationView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: TaskApplicationView = nodeView as TaskApplicationView;
			var m: TaskApplication = model as TaskApplication;

			v.appId = m.appId;
			v.appName = m.appName;
			v.taskFormId = m.formId;
			v.taskFormName = m.formName;
			v.approvalLine = m.approvalLine;
			v.approvalLineName = m.approvalLineName;
			v.meanTimeInHours = m.meanTimeInHours;
			v.passedTimeInHours = m.passedTimeInHours;
			
			nodeView.addEventListener(ViewIconEvent.ICON_CLICK, doViewIconClick);
		}

		override protected function createTools(): Array {
			var tools: Array = [];
			
			tools.push(new NextTaskCreationTool(this));
//			tools.push(new DataFieldsTool(this));
			
			return tools.concat(createCommonTools());
		}
		
		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: TaskApplicationView = view as TaskApplicationView;
			var m: TaskApplication = model as TaskApplication;
			
			switch (event.prop) {
				case TaskApplication.PROP_APPLICATION_ID:
					if(event.oldValue && event.oldValue != ApplicationService.EMPTY_APPLICATION_SERVICE && event.oldValue != TaskApplication.SYSTEM_APPLICATION_ID)
						XPDLEditor(editor).xpdlDiagram.xpdlPackage.process.removeExtApplication(event.oldValue as String, m);
					if(m.appId && m.applicationService && m.appId != ApplicationService.EMPTY_APPLICATION_SERVICE && m.appId != TaskApplication.SYSTEM_APPLICATION_ID)
						XPDLEditor(editor).xpdlDiagram.xpdlPackage.process.addExtApplication(m.appId, m.applicationService, m);
					else
						m.actualParameters = null;
					v.appId = m.appId;
					v.appName = m.appName;
					v.taskFormId = m.formId;
					v.taskFormName = m.formName;
					refreshView();
					break;
				
				case TaskApplication.PROP_APPLICATION_SERVICE:
					var server:Server = XPDLEditor(editor).server;
					if(!server) server = XPDLEditor(editor).xpdlDiagram.server;
					if(server && !server.applicationServices){
						server.getApplicationServices(getApplicationServicesCallback);
						function getApplicationServicesCallback():void{
							if(server.applicationServices){
								setApplicationService(m, server.applicationServices);
							}
						}
					}else if(server && server.applicationServices){
						setApplicationService(m, server.applicationServices);
					}else{
						var svcApp:GetApplicationServiceDefsService = new GetApplicationServiceDefsService();
						svcApp.serviceUrl = XPDLEditor(editor).builderServiceUrl;
						svcApp.compId = XPDLEditor(editor).compId;
						svcApp.userId = XPDLEditor(editor).userId;
						svcApp.data = svcApp;
						svcApp.resultHandler = getApplicationServiceDefsCallback;
						svcApp.send();
						function getApplicationServiceDefsCallback(svc:GetApplicationServiceDefsService):void{
							if(svc) setApplicationService(m, svc.applicationServices);
						}
					}
					break;
				

				case TaskApplication.PROP_FORMID:
					v.taskFormId = m.formId;
					v.taskFormName = m.formName;
					refreshView();
					break;
				
				case TaskApplication.PROP_APPROVALLINE:
					v.approvalLine = m.approvalLine;
					v.approvalLineName = m.approvalLineName;
					refreshView();
					break;
				
				case TaskApplication.PROP_MEANTIME:
					v.meanTimeInHours = m.meanTimeInHours;
					refreshView();
					break;
				
				case TaskApplication.PROP_PASSEDTIME:
					v.passedTimeInHours = m.passedTimeInHours;
					refreshView();
					break;
				
				default:
					super.nodeChanged(event);
			}
		}

		internal function setApplicationService(task:TaskApplication, appServices:Array):void{
			for each(var appService:ApplicationService in appServices){
				if(appService.id == task.appId && task.appId)
					task.applicationService = appService;
			}
		}
		
		override public function get actions(): Array {
			return super.actions.concat(new SetTaskFormAction(this.taskApplication));
		}


		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		private function doViewIconClick(event: ViewIconEvent): void {
			if (event.icon is TaskFormIcon && !_formPanelVisible) {
				

/*				
				_formPanel = new TaskFormPanel(editor as XPDLEditor, model as TaskApplication);
				_formPanel.addEventListener("headClick", panelHeadClick);
			
				var icon: TaskFormIcon = event.icon as TaskFormIcon;
				var p: Point = new Point(icon.x + icon.width + 4, icon.y + icon.height + 4);
				editor.offsetPoint(icon, p);
				
				_formPanel.x = p.x;
				_formPanel.y = p.y;
				_formPanel.refresh();
				
				editor.getFeedbackLayer().addChild(_formPanel);
				_formPanelVisible = true;
*/				
			}
		}
		
		private function panelHeadClick(event: Event): void {
			if (_formPanelVisible) {
				editor.getFeedbackLayer().removeChild(event.target as DisplayObject);
				_formPanel = null;
				_formPanelVisible = false;
			}
		}
	}
}