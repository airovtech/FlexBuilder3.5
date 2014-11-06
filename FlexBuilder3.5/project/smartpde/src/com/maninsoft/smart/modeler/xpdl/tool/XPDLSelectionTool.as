////////////////////////////////////////////////////////////////////////////////
//  XPDLSelectionTool.as
//  2008.02.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.tool
{
	import com.maninsoft.smart.modeler.editor.tool.SelectionTool;
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.controller.PoolController;
	import com.maninsoft.smart.modeler.xpdl.model.Pool;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.view.tool.LaneView;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * 1. Lane 핸들링
	 */
	public class XPDLSelectionTool extends SelectionTool {
		
		//----------------------------------------------------------------------
		// Class constans
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function XPDLSelectionTool(editor: XPDLEditor) {
			super(editor);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/** 
		 * xpdlEditor
		 */
		public function get xpdlEditor(): XPDLEditor {
			return super.editor as XPDLEditor;
		}
		

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function handleKeyDown(event: KeyboardEvent): void {
			var curr: Lane = laneSelManager.currentLane;
			
			if (curr) {
				if (pool.isVertical && event.keyCode == Keyboard.LEFT ||
				    !pool.isVertical && event.keyCode == Keyboard.UP) {
					if (curr.id > 0) {
						laneSelManager.currentLane = pool.lane(curr.id - 1);
					}
						
					return;
				}

				if (pool.isVertical && event.keyCode == Keyboard.RIGHT ||
				    !pool.isVertical && event.keyCode == Keyboard.DOWN) {
					if (curr.id < pool.laneCount - 1) {
						laneSelManager.currentLane = pool.lane(curr.id + 1);
					}
						
					return;
				}
						
				if (pool.isVertical && event.keyCode == Keyboard.UP ||
				    !pool.isVertical && event.keyCode == Keyboard.LEFT) {
					editor.select(pool);
					return;			
				}
			}	

			super.handleKeyDown(event);
		}
		
		/**
		 * lane 선택 처리를 한다.
		 */
		override protected function handleDoubleClick(event: MouseEvent): void {
			var selected: Boolean = false;
			
			if (event.target is LaneView || event.target.parent is LaneView) {
				var view: LaneView;
				
				if (event.target is LaneView)
					view = event.target as LaneView;
				else
					view = event.target.parent as LaneView;
					
				if (view) {
					// 기존의 notation 선택들을 해제한다.
					clearSelection();

					if (view.selected)
						laneSelManager.clear(); 

					var ctrl: PoolController = editor.findControllerByModel(pool) as PoolController;
					ctrl.showPropertyView = true;
						
					laneSelManager.add(view);
					selected = true;
				}
			}
	
			// lane 외의 곳을 클릭하면 lane 선택들 해제
			if (!selected)
				laneSelManager.clear();

			super.handleDoubleClick(event);

		}
		
		override protected function handleMouseDown(event: MouseEvent): void {
			var selected: Boolean = false;
			
			if (event.target is LaneView || event.target.parent is LaneView) {
				var view: LaneView;
				
				if (event.target is LaneView)
					view = event.target as LaneView;
				else
					view = event.target.parent as LaneView;
					
				if (view) {
					// 기존의 notation 선택들을 해제한다.
					clearSelection();

					if (view.selected) {
						// ctrl 키를 누른 상태에서 이미 선택한 것을 누르면 선택을 취소한다. 
						if (event.ctrlKey || event.shiftKey) 
							laneSelManager.remove(view);
					} 
					else {	
						// ctrl 키가 눌리지 않았다면 기존의 선택 제거
						if (!event.ctrlKey && !event.shiftKey) 
							laneSelManager.clear(); 
						
						laneSelManager.add(view);
					}
						
					selected = true;
				}
			}
	
			// lane 외의 곳을 클릭하면 lane 선택들 해제
			if (!selected)
				laneSelManager.clear();

			super.handleMouseDown(event);
		}
		

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------
		
		protected function get laneSelManager(): LaneSelectionManager {
			return xpdlEditor.laneSelectionManager;
		}
		
		protected function get pool(): Pool {
			return xpdlEditor.xpdlDiagram.pool;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	}
}