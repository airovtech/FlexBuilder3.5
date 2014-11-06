////////////////////////////////////////////////////////////////////////////////
//  NodeBoundsCommand.as
//  2008.03.10, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.command
{
	import com.maninsoft.smart.modeler.model.Node;
	
	import flash.geom.Rectangle;
	
	/**
	 * 노드의 크기 및 위치를 변경하는 커맨드
	 */
	public class NodeBoundsCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _node: Node;
		private var _bounds: Rectangle;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function NodeBoundsCommand(node: Node, newBounds: Rectangle) {
			super();
			
			_node = node;
			_bounds = newBounds.clone();
		}

		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			var old: Rectangle= _node.bounds;
			_node.bounds = _bounds;
			_bounds = old;
		}
		
		override public function undo(): void  {
			redo();
		}
	}
}