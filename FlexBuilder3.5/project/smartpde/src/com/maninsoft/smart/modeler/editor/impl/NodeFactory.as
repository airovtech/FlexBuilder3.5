////////////////////////////////////////////////////////////////////////////////
//  NodeFactory.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.impl
{
	import com.maninsoft.smart.modeler.editor.DiagramEditor;
	import com.maninsoft.smart.modeler.editor.INodeFactory;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 기본 Node Factory
	 */
	public class NodeFactory implements INodeFactory	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _owner: DiagramEditor;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */		
		public function NodeFactory(owner: DiagramEditor) {
			super();
			
			_owner = owner;
		}


		//----------------------------------------------------------------------
		// INodeFactory
		//----------------------------------------------------------------------

		public function createNode(nodeType: String): Node {
			var node: Node = new Node();
			
			return node;
		}
	}
}