////////////////////////////////////////////////////////////////////////////////
//  Node.as
//  2007.12.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * 노드를 생성하는 커맨드
	 */
	public class NodeCreateCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _node: Node;
		private var _parent: Node;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeCreateCommand(parent: Node, node: Node) {
			super();
			
			_node = node;
			_parent = parent;
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			_parent.removeChild(_node);
		}
		
		override public function redo(): void {
			_parent.addChild(_node);
		}
	}
}