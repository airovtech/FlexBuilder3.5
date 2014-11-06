////////////////////////////////////////////////////////////////////////////////
//  XPDLNodeFactory.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl
{
	import com.maninsoft.smart.modeler.editor.INodeFactory;
	import com.maninsoft.smart.modeler.model.Node;
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
	import com.maninsoft.smart.modeler.xpdl.model.XorGateway;
	import com.maninsoft.smart.modeler.xpdl.model.base.XPDLNode;
	
	/**
	 * XPLD node factory
	 */
	public class XPDLNodeFactory implements INodeFactory {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _owner: XPDLEditor;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function XPDLNodeFactory(owner: XPDLEditor) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		public function createNode(nodeType: String): Node {
			var node: XPDLNode = null;
			
			switch (nodeType) {
				case "Pool":
					node = new Pool(null);
					break;
					
				case "StartEvent":
					node = new StartEvent();
					break;
					
				case "EndEvent":
					node = new EndEvent();
					break;
				
				case "IntermediateEvent":
					node = new IntermediateEvent();
					break;
				
				case "TaskApplication":
					node = new TaskApplication();
					break;
					
				case "TaskService":
					node = new TaskService();
					break;
					
				case "SubFlow":
					node = new SubFlow();
					break;
					
				case "XorGateway":
					node = new XorGateway();
					break;
					
				case "OrGateway":
					node = new OrGateway();
					break;
					
				case "AndGateway":
					node = new AndGateway();
					break;
					
				case "Annotation":
					node = new Annotation();
					break;
					
				case "DataObject":
					node = new DataObject();
					break;
					
				case "Block":
					node = new Block();
					break;
					
				case "Group":
					node = new Group();
					break;
			}
			
			return node;
		}
	}
}