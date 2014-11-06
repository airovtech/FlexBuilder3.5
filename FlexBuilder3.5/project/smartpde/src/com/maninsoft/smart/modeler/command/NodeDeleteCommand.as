////////////////////////////////////////////////////////////////////////////////
//  NodeDeleteCommand.as
//  2008.01.04, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 노드를 삭제하는 커맨드
	 */
	public class NodeDeleteCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _node: Node;
		private var _parent: Node;
		private var _links: Array;


		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function NodeDeleteCommand(node: Node) {
			super();
			
			_parent = node.parent;
			_node = node;
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			_links = _node.links;
			redo();
		}
		
		override public function redo(): void {
			_node.diagram.removeLinks(_links);
			_parent.removeChild(_node);
		}
		
		override public function undo(): void  {
			_parent.addChild(_node);
			_node.diagram.addLinks(_links);
		}
	}
}