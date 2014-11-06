////////////////////////////////////////////////////////////////////////////////
//  SelectionManager.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor
{
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.controller.NodeController;
	import com.maninsoft.smart.modeler.editor.events.SelectionEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Default selction manager
	 */
	public class SelectionManager extends EventDispatcher {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for items */
		private var _items: ArrayCollection;
		
		public var clearOffset: Boolean = false;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SelectionManager() {
			super();
			
			_items = new ArrayCollection();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get count(): int {
			return _items.length;
		}
		
		public function get items(): Array {
			return _items.toArray();
		}
		
		public function get nodeCount(): int {
			var cnt: int = 0;
			
			for each (var ctrl: Controller in _items) {
				if (ctrl is NodeController)
					cnt++;
			}
			
			return cnt;
		}
		
		public function get nodes(): Array /* of Node */ {
			var nodes: Array = [];
			
			for each (var ctrl: Controller in _items) {
				if (ctrl is NodeController) {
					nodes.push(ctrl.model);
				}
			}
			
			return nodes;	
		}
		
		public function get linkCount(): int {
			var cnt: int = 0;
			
			for each (var ctrl: Controller in _items) {
				if (ctrl is LinkController)
					cnt++;
			}
			
			return cnt;
		}
		
		public function get links(): Array /* of Link */ {
			var links: Array = [];
			
			for each (var ctrl: Controller in _items) {
				if (ctrl is LinkController) {
					links.push(ctrl.model);
				}
			}
			
			return links;	
		}

		/**
		 * source나 target은 선택되지 않고, 링크만 홀로 선택된 것들을 리턴
		 */
		public function get soleLinks(): Array /* of Link */ {
			var ctrls: Array = items;
			var links: Array = [];
			
			for each (var ctrl: Controller in ctrls) {
				if (ctrl is LinkController) {
					var link: LinkController = ctrl as LinkController;
					
					if (ctrls.indexOf(link.sourceController) < 0 && ctrls.indexOf(link.targetController))
						links.push(ctrl.model);
				}
			}
			
			return links;	
		}
		
		/**
		 * 가장 최근에 선택된 것을 리턴한다.
		 */
		//public function get selected(): Controller {
		//	return (count > 0) ? _items[count - 1] : null;
		//}
		
		/**
		 * 하나만 선택된 경우 그 것을 리턴한다. 나머지 경우는 모두 null이다.
		 */
		//public function get uniqueSelected(): Controller {
		//	return (count == 1) ? _items[0] : null;
		//}
		
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function clear(): void  {
			if (count > 0) {
				for each (var ctrl: Controller in _items) {
					ctrl.selected = false;			
					ctrl.hideTools();
				}
				
				_items.removeAll();
				fireChangeEvent();
			}
		}
		
		public function add(ctrl: Controller): void {
			ctrl.selected = true;
			
			for each (var c: Controller in _items) {
				c.hideTools();
			}
			
			_items.addItem(ctrl);
			
			// 마지막 선택된 controller의 tool들을 표시한다.
			// lastItem.showTools();
			
			fireChangeEvent();
		}
		
		public function addList(list: Array /* of Controller */): void {
			if ((count == 0) && (list.length == 1))
				add(list[0]);
			
			var ctrl: Controller;
			
			if (list.length > 0) {
				for each (ctrl in _items) {
					ctrl.hideTools();
				}
			
				for each (ctrl in list) {
					if (!contains(ctrl)) {
						add(ctrl);
					}
				}
			}
			
			// 마지막 선택된 controller의 tool들을 표시한다.
			if (count > 0) {
				//lastItem.showTools();
			}

			fireChangeEvent();
		}
		
		public function remove(ctrl: Controller): void {
			ctrl.selected = false;
			ctrl.hideTools();
			
			_items.removeItemAt(_items.getItemIndex(ctrl));
			fireChangeEvent();
		}
		
		public function contains(ctrl: Controller): Boolean {
			return _items.contains(ctrl);
		}
		
		public function getItemAt(index: int): Controller {
			return _items.getItemAt(index) as Controller;
		}
		
		public function canResizeBy(anchorDir: int, dx: int, dy: int): Boolean {
			for each (var ctrl: Controller in _items) {
				if (!ctrl.canResizeBy(anchorDir, dx, dy))
					return false;
			}

			return true;
		}
		
		public function canMoveBy(dx: int, dy: int): Boolean {
			for each (var ctrl: Controller in _items) {
				if (!ctrl.canMoveBy(dx, dy))
					return false;
			}

			return true;
		}

		public function resizeBy(anchorDir: int, dx: int, dy: int): void {
			for each (var ctrl: Controller in _items) {
				var hided: Boolean = ctrl.hideTools();
				
				ctrl.resizeBy(anchorDir, dx, dy);
				
				if (hided) 
					ctrl.showTools();
			}
		}
		
		public function moveBy(dx: int, dy: int): void {
			for each (var ctrl: Controller in _items) {
				var hided: Boolean = ctrl.hideTools();
				if(ctrl.canMoveBy(dx, dy))
					ctrl.moveBy(dx, dy);
				if (hided) 
					ctrl.showTools();
			}
		}
		
		public function refreshSelection(): void {
			for each (var ctrl: Controller in _items) 
				ctrl.refreshSelection();
		}

		//----------------------------------------------------------------------
		// Internal properties
		//----------------------------------------------------------------------

		protected function get firstItem(): Controller {
			return _items.length > 0 ? _items[0] : null;
		}
		
		protected function get lastItem(): Controller {
			return _items.length > 0 ? _items[_items.length - 1] : null;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function fireChangeEvent(): void {
			var models: Array = [];
			
			for each (var item: Controller in _items) {
				models.push(item.model);
			} 
			
			dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, models));
		}
		
	}
}