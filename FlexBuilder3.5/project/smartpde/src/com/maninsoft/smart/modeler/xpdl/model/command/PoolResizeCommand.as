////////////////////////////////////////////////////////////////////////////////
//  PoolResizeCommand.as
//  2007.01.03, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.command
{
	import com.maninsoft.smart.modeler.command.Command;
	import com.maninsoft.smart.modeler.common.Size;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	import flash.geom.Point;
	
	/**
	 * 풀의 크기를 변경하는 커맨드
	 */
	public class PoolResizeCommand extends Command {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _pool: Pool;
		private var _delta: Point;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PoolResizeCommand(pool: Pool, dx: int, dy: int) {
			super();
			
			_pool = pool;
			_delta = new Point(dx, dy);
		}
			
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function execute(): void {
			redo();
		}
		
		override public function redo(): void {
			var lane: Lane = _pool.lastLane;
			
			if (!lane) {
				_pool.resizeBy(_delta.x, _delta.y);
			}
			else {
				var sz: Size = _pool.getMinimumSize();
				
				if (_pool.isVertical) {
					_delta.y = Math.max(_delta.y, sz.height - _pool.height);
					_pool.resizeBy(0, _delta.y);
	
				} else {
					_delta.x = Math.max(_delta.x, sz.width - _pool.width);
					_pool.resizeBy(_delta.x, 0);
				}
			}
		}
		
		override public function undo(): void  {
			var lane: Lane = _pool.lastLane;
			
			if (!lane) {
				_pool.resizeBy(-_delta.x, -_delta.y);
			}
			else {
				if (_pool.isVertical) {
					_pool.resizeBy(0, -_delta.y);
	
				} else {
					_pool.resizeBy(-_delta.x, 0);
				}
			}
		}
	}
}