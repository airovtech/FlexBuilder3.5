////////////////////////////////////////////////////////////////////////////////
//  PaletteGroup.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.palette
{
	import com.maninsoft.smart.modeler.common.ComponentUtils;
	
	import flash.events.MouseEvent;
	
	import mx.core.Container;
	
	/** 
	 * 관련된 PaletteItem 들을 표시하는 컨테이너
	 * PaletteGroup은 Palette에 포함된다.
	 */
	public class PaletteGroup extends Container {
		
		//----------------------------------------------------------------------
		// Variables 
		//----------------------------------------------------------------------
		
		/** Storage for property items */
		private var _items: Array;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization 
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PaletteGroup() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// Properties 
		//----------------------------------------------------------------------
		
		/**
		 * 이 팔레트 그룹이 소유한 팔레트
		 * 현재 팔레트가 Accordion 컨테이너를 이용해 구현되었으므로
		 * parent를 리턴한다.
		 */
		public function get palette(): Palette {
			return parent as Palette;
		}
		
		
		/**
		 * 팔레트 그룹에 포함된 팔레트 아이템 목록을 배열로 리턴한다.
		 * null 일 수 있다.
		 */
		public function get items(): Array {
			return _items;
		}
		
		public function set items(value: Array): void {
			_items = value;
			
			resetChildren();
			invalidateDisplayList();
		}
		
		
		//----------------------------------------------------------------------
		// Internal methods 
		//----------------------------------------------------------------------
		
		/**
		 * items 속성에 새로운 팔레트아이템 목록이 설정되면
		 * 기존 아이템 뷰들을 모두 제거하고, 새로 구성한다.
		 * 현재, 팔레트아이템은 팔레크 그룹 내에서 Label 컨트롤로 표시된다.
		 */
		private function resetChildren(): void {
			ComponentUtils.clearChildren(this);
			
			for (var i: int = 0; i < _items.length; i++) {
				var tool: PaletteItemView = new PaletteItemView();
				
				tool.x = 10;
				tool.y = 10 + i * 21;
				tool.width = 80;
				tool.height = 21;
				tool.item = PaletteItem(_items[i]);
				tool.text = tool.item.label;
				
				addChild(tool);	
			}
		}
	}
}