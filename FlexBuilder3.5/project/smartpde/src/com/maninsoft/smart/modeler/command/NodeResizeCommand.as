////////////////////////////////////////////////////////////////////////////////
//  NodeResizeCommand.as
//  2007.12.22, created by gslim
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
	 * 노드의 크기를 변경하는 커맨드
	 */
	public class NodeResizeCommand extends Command {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _node: Node;
		private var _delta: Point;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeResizeCommand(node: Node, dx: int, dy: int) {
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
		
		override public function redo(): void {
			_node.resizeBy(_delta.x, _delta.y);
		}
		
		override public function undo(): void  {
			_node.resizeBy(-_delta.x, -_delta.y);
		}
	}
}