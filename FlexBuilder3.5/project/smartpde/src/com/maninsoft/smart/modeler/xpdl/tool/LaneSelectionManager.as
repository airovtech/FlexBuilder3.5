////////////////////////////////////////////////////////////////////////////////
//  LaneSelectionManager.as
//  2008.03.06, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.tool
{
	import com.maninsoft.smart.modeler.xpdl.XPDLEditor;
	import com.maninsoft.smart.modeler.xpdl.controller.PoolController;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	import com.maninsoft.smart.modeler.xpdl.view.PoolView;
	import com.maninsoft.smart.modeler.xpdl.view.tool.LaneView;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Lane 선택 관리자
	 */
	public class LaneSelectionManager extends EventDispatcher	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: XPDLEditor;
		private var _items: ArrayCollection;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LaneSelectionManager(editor: XPDLEditor) {
			super();
			
			_editor = editor;
			_items = new ArrayCollection();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get count(): int {
			return _items.length;
		}
		
		public function get items(): Array /* of LaneView */ {
			return _items.toArray();
		}

		public function get lanes(): Array /* of Lane */ {
			var lanes: Array = [];
			
			for each (var view: LaneView in _items)
				lanes.push(view.lane);
				
			return lanes;
		}

		/**
		 * current
		 */
		public function get current(): LaneView {
			return _items.length > 0 ? _items[0] as LaneView : null;
		}
		
		public function set current(value: LaneView): void {
			internalClear();
			
			if (value)
				internalAdd(value);
				
			fireChangeEvent();
		}
		
		/**
		 * currentLane
		 */
		public function get currentLane(): Lane {
			var curr: LaneView = current;
			return curr ? curr.lane : null;
		}
		
		public function set currentLane(value: Lane): void {
			current = findLaneView(value);
		}


		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function getItemAt(i: int): Lane {
			return _items.getItemAt(i) as Lane;
		}

		public function clear(): Boolean {
			if (count > 0) {
				internalClear();
				fireChangeEvent();
				return true;
			}
			
			return false;
		}
		
		public function add(lane: LaneView): Boolean {
			if (!_items.contains(lane)) {
				internalAdd(lane);
				fireChangeEvent();
				return true;
			}
			
			return false;
		}
		
		public function addLane(lane: Lane): Boolean {
			return lane ? add(findLaneView(lane)) : false;
		}
		
		public function remove(lane: LaneView): Boolean {
			if (_items.contains(lane)) {
				lane.selected = false;
				_items.removeItemAt(_items.getItemIndex(lane));
				fireChangeEvent();
				return true;
			}
			
			return false;
		}
		
		public function contains(lane: LaneView): Boolean {
			return _items.contains(lane);
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		protected function findLaneView(lane: Lane): LaneView {
			if (lane) {
				var pool: PoolController = _editor.findControllerByModel(lane.owner) as PoolController;
				return PoolView(pool.view).findLaneView(lane);
			}
			
			return null;
		}
		
		protected function internalClear(): void {
			for each (var view: LaneView in _items)
				view.selected = false;
			
			_items.removeAll();
			var pool: PoolController = _editor.findControllerByModel(_editor.xpdlDiagram.pool) as PoolController;
			pool.showPropertyView = false;
		}
		
		protected function internalAdd(lane: LaneView): void {
			lane.selected = true;
			_items.addItem(lane);
		}
		
		protected function fireChangeEvent(): void {
			dispatchEvent(new LaneSelectionEvent(LaneSelectionEvent.CHANGED, lanes));
		}
	}
}