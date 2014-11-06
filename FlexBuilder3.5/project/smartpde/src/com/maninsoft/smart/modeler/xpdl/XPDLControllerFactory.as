////////////////////////////////////////////////////////////////////////////////
//  XPDLControllerFactory.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.impl.ControllerFactory;
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.xpdl.controller.AndGatewayController;
	import com.maninsoft.smart.modeler.xpdl.controller.AnnotationController;
	import com.maninsoft.smart.modeler.xpdl.controller.BlockController;
	import com.maninsoft.smart.modeler.xpdl.controller.DataObjectController;
	import com.maninsoft.smart.modeler.xpdl.controller.EndEventController;
	import com.maninsoft.smart.modeler.xpdl.controller.GroupController;
	import com.maninsoft.smart.modeler.xpdl.controller.IntermediateEventController;
	import com.maninsoft.smart.modeler.xpdl.controller.OrGatewayController;
	import com.maninsoft.smart.modeler.xpdl.controller.PoolController;
	import com.maninsoft.smart.modeler.xpdl.controller.StartEventController;
	import com.maninsoft.smart.modeler.xpdl.controller.SubFlowController;
	import com.maninsoft.smart.modeler.xpdl.controller.TaskApplicationController;
	import com.maninsoft.smart.modeler.xpdl.controller.TaskServiceController;
	import com.maninsoft.smart.modeler.xpdl.controller.TaskUserController;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLLinkController;
	import com.maninsoft.smart.modeler.xpdl.controller.XPDLNodeController;
	import com.maninsoft.smart.modeler.xpdl.controller.XorGatewayController;
	import com.maninsoft.smart.modeler.xpdl.model.AndGateway;
	import com.maninsoft.smart.modeler.xpdl.model.Annotation;
	import com.maninsoft.smart.modeler.xpdl.model.Block;
	import com.maninsoft.smart.modeler.xpdl.model.DataObject;
	import com.maninsoft.smart.modeler.xpdl.model.EndEvent;
	import com.maninsoft.smart.modeler.xpdl.model.Group;
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.OrGateway;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.StartEvent;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.TaskUser;
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLLink;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	/**
	 * XPDL controller factory
	 */
	public class XPDLControllerFactory extends ControllerFactory {
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function XPDLControllerFactory(owner: XPDLEditor) {
			super(owner);
		}	


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function createController(model: DiagramObject): Controller {
			if (model is XPDLLink) {
				return new XPDLLinkController(model as XPDLLink);
			} else	if (model is Pool) {
				return new PoolController(model as Pool);
			}
			else if (model is StartEvent) {
				return new StartEventController(model as StartEvent);
			}
			else if (model is EndEvent) {
				return new EndEventController(model as EndEvent);
			} 
			else if (model is IntermediateEvent) {
				return new IntermediateEventController(model as IntermediateEvent);
			} 
			else if (model is TaskApplication) {
				return new TaskApplicationController(model as TaskApplication);
			} 
			else if (model is TaskService) {
				return new TaskServiceController(model as TaskService);
			} 
			else if (model is TaskUser) {
				return new TaskUserController(model as TaskUser);
			} 
			else if (model is SubFlow) {
				return new SubFlowController(model as SubFlow);
			} 
			else if (model is XorGateway) {
				return new XorGatewayController(model as XorGateway);
			} 
			else if (model is OrGateway) {
				return new OrGatewayController(model as OrGateway);
			} 
			else if (model is AndGateway) {
				return new AndGatewayController(model as AndGateway);
			} 
			else if (model is Annotation) {
				return new AnnotationController(model as Annotation);
			} 
			else if (model is DataObject) {
				return new DataObjectController(model as DataObject);
			} 
			else if (model is Block) {
				return new BlockController(model as Block);
			} 
			else if (model is Group) {
				return new GroupController(model as Group);
			} 
			else if (model is XPDLNode) {
				return new XPDLNodeController(model as XPDLNode);
			} 
			else {
				return super.createController(model);
			}
		}
	}
}