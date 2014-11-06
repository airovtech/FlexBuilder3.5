////////////////////////////////////////////////////////////////////////////////
//  SubFlowController.as
//  2007.12.13, created by gslim
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
	import com.maninsoft.smart.modeler.xpdl.XPDLMonitor;
	import com.maninsoft.smart.modeler.xpdl.XPDLViewer;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SubProcessViewerDialog;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	import com.maninsoft.smart.modeler.xpdl.model.process.WorkflowProcess;
	import com.maninsoft.smart.modeler.xpdl.server.Server;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetSubProcessInstanceService;
	import com.maninsoft.smart.modeler.xpdl.view.SubFlowView;
	
	import flash.geom.Point;
	
	/**
	 * Controller for SubFlow
	 */	
	public class SubFlowController extends ActivityController {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function SubFlowController(model: SubFlow) {
			super(model);
		}

		//----------------------------------------------------------------------
		// Overriden Methods
		//----------------------------------------------------------------------
		
		override public function activate(): void {
			super.activate();
			var m: SubFlow = model as SubFlow;
			if(m.subProcessInfo)
				this.nodeChanged(new NodeChangeEvent(m, SubFlow.PROP_SUBPROCESS_ID));
			if(m.subProcessInstId)
				this.nodeChanged(new NodeChangeEvent(m, SubFlow.PROP_SUBPROCESS_INST_ID));
		}
		
		override protected function createNodeView(): NodeView {
			return new SubFlowView();
		}
		
		override protected function initNodeView(nodeView:NodeView): void {
			super.initNodeView(nodeView);

			var v: SubFlowView = nodeView as SubFlowView;
			var m: SubFlow = model as SubFlow;

			v.text 			= m.name;
			v.execution 	= m.execution;
			v.subFlowView 	= m.subFlowView;
			v.subProcessName= m.subProcessName;
			v.meanTimeInHours = m.meanTimeInHours;
			if(m.subProcessInstId)
				v.passedTimeInHours = m.passedTimeInHours;
			nodeView.addEventListener(ViewIconEvent.ICON_CLICK, doViewIconClick);
		}

		override protected function nodeChanged(event: NodeChangeEvent): void {
			var v: SubFlowView = view as SubFlowView;
			var m: SubFlow = model as SubFlow;
			
			switch (event.prop) {
				case XPDLNode.PROP_NAME:
					v.text = m.name;
					refreshView();
					break;

				case SubFlow.PROP_SUBPROCESS:
					v.meanTimeInHours = m.meanTimeInHours;
					if(m.subProcessInstId)
						v.passedTimeInHours = m.passedTimeInHours;
					v.subProcessProblem = m.subProcessProblem;
					refreshView();
					break;
						
				case SubFlow.PROP_SUBPROCESS_ID:
					if(m.subProcessInfo && m.subProcessInfo.packageId && m.subProcessInfo.version){
						if(m.subProcessInfo.processId){
							m.subProcessId = m.subProcessInfo.processId;
							Pool(m.parent).changeSubProcess(editor, m as SubFlow);
							v.subProcessName = m.subProcessName;
							refreshView();
						}else{
							var server:Server = XPDLEditor(editor).xpdlDiagram.server;
							if(!server) server = XPDLEditor(editor).server;
							if(server){
								 server.getProcessInfoByPackage(m.subProcessInfo.packageId, m.subProcessInfo.version, getProcessInfoCallback);	
							}else if(editor){
								var svcPrc:GetProcessInfoByPackageService = new GetProcessInfoByPackageService();
								svcPrc.serviceUrl = XPDLEditor(editor).builderServiceUrl;
								svcPrc.compId = XPDLEditor(editor).compId;
								svcPrc.userId = XPDLEditor(editor).userId;
								svcPrc.packageId = m.subProcessInfo.packageId;
								svcPrc.version = m.subProcessInfo.version;
								svcPrc.data = svcPrc;
								svcPrc.resultHandler = getProcessInfoCallback;
								svcPrc.send();
							}
							function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
								m.subProcessInfo.processId = svc.process.processId;
								m.subProcessInfo.categoryPath =  svc.process.categoryPath;
								m.subProcessInfo.name = svc.process.name;
								m.subProcessId = m.subProcessInfo.processId;
								Pool(m.parent).changeSubProcess(editor, m as SubFlow);
								v.subProcessName = m.subProcessName;
								refreshView();
							}
						}
					}else if(!m.subProcessInfo){
						m.subProcess = null;
						m.subProcessId = null;
						m.actualParameters = null;
						Pool(m.parent).changeSubProcess(this.editor, m as SubFlow);
						v.subProcessName = m.subProcessName;
						refreshView();
					}					
					break;
					
				case SubFlow.PROP_SUBPROCESS_INST_ID:
					if(m.subProcessInstId){
						server = XPDLEditor(editor).xpdlDiagram.server;
						if(!server) server = XPDLEditor(editor).server;
						if(server){
							 server.getSubProcessInstance(m.subProcessInstId, getSubProcessInstanceCallback);
						}else if(editor){
							var svcInst:GetSubProcessInstanceService = new GetSubProcessInstanceService();
							svcInst.serviceUrl = XPDLEditor(editor).serviceUrl;
							svcInst.compId = XPDLEditor(editor).compId;
							svcInst.userId = XPDLEditor(editor).userId;
							svcInst.prcInstId = m.subProcessInstId;
							svcInst.data = svcInst;
							svcInst.resultHandler = getSubProcessInstanceCallback;
							svcInst.send();
						}
						function getSubProcessInstanceCallback(svc: GetSubProcessInstanceService):void{
							if(!svc.xpdlSource) return;
							m.subProcessDiagram = svc.diagram;
							if(m.subProcessDiagram.xpdlPackage.process && m.subProcessDiagram.xpdlPackage.process is WorkflowProcess){
								m.subProcessDiagram.xpdlPackage.process.id = m.subProcessId
								m.subProcess = m.subProcessDiagram.xpdlPackage.process;
							}
							v.subProcessName = m.subProcessName;
							refreshView();
						}
					}else if(!m.subProcessInstId){
						m.subProcessDiagram = null;
						m.subProcess = null;
						m.subProcessId = null;
						Pool(m.parent).changeSubProcess(this.editor, m as SubFlow);
						v.subProcessName = m.subProcessName;
						refreshView();
					}					
					break;
					
				case SubFlow.PROP_VIEW:
					if(m.subFlowView == SubFlow.VIEW_EXPANDED && m.subProcessDiagram){
						SubProcessViewerDialog.closeViewer();
						var title: String = m.name + "["+m.subProcessName+"]";
						var position: Point = editor.localToGlobal(new Point(v.x+4, v.y+v.nodeHeight+2));
						SubProcessViewerDialog.execute(title, m.subProcessDiagram, m, v, true, position, 600, 400);
					}else{
						SubProcessViewerDialog.closeViewer();
					}
					refreshPropertyPage();

				case SubFlow.PROP_EXECUTION:
					v.execution = m.execution;
					break;
				
				default:
					super.nodeChanged(event);
			}
		}
		
		//----------------------------------------------------------------------
		// Internal Methods
		//----------------------------------------------------------------------
		
		private function doViewIconClick(event: ViewIconEvent): void {
			var m: SubFlow = model as SubFlow;
			m.subFlowView = SubFlow.VIEW_EXPANDED;			
		}

		private function refreshPropertyPage():void{
			if(editor.selectionManager.contains(this) && editor.selectionManager.items.length==1)
				editor.select(model);
		}
	}
}