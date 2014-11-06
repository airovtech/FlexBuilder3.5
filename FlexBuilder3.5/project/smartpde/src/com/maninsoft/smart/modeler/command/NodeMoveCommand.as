////////////////////////////////////////////////////////////////////////////////
//  NodeMoveCommand.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Node;
	
	import flash.geom.Point;
	
	/**
	 * 노드의 위치를 변경하는 커맨드
	 */
	public class NodeMoveCommand extends Command	{
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _node: Node;
		private var _delta: Point;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeMoveCommand(node: Node, dx: int, dy: int) {
			super();
			
			_node = node;
			_delta = new Point(dx, dy);
		}
		
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function undo(): void  {
			_node.x -= _delta.x;
			_node.y -= _delta.y;
		}
		
		override public function redo(): void {
			_node.x += _delta.x;
			_node.y += _delta.y;
		}
	}
}