////////////////////////////////////////////////////////////////////////////////
//  InstancePool.as
//  2008.02.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 자주 변경되는 자식 DisplayObject 목록을 cashing함. 
	 */
	public class InstancePool {

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		private const EMPTY_ARRAY: Array = [];

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _items: Array = EMPTY_ARRAY;
		
		private var _parent: DisplayObjectContainer;
		private var _clazz: Class;
		private var _count: uint = 0;
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function InstancePool(parent: DisplayObjectContainer, clazz: Class, initSize: uint = 4) {
			super();
			
			_parent = parent;
			_clazz = clazz;
			checkCapacity(4);
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get count(): uint {
			return _count;
		}
		
		public function set count(value: uint): void {
			if (value != _count) {
				checkCapacity(value);
				_count = value;
			}
		}
		
		
		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------

		public function getInstance(idx: uint): DisplayObject {
			return _items[idx] as DisplayObject;
		}
		
		/**
		 * parent 에서 제거한다.
		 */
		public function hide(): void {
			for (var i: int = 0; i < count; i++) {
				_parent.removeChild(getInstance(i));
			}
		}
		
		/**
		 * parent에 index 위치로 부터 count 만큼 추가한다.
		 */
		public function show(index: int = -1): void {
			if (index < 0)
				index = _parent.numChildren;
			
			for (var i: int = 0; i < count; i++) {
				_parent.addChildAt(getInstance(i), index + i);
			}
		}
		
		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function checkCapacity(value: uint): void {
			while (_items.length < value) {
				_items[_items.length] = new _clazz();
			}
		}

	}
}