////////////////////////////////////////////////////////////////////////////////
//  PaletteItemView.as
//  2007.12.14, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.palette
{
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	
	/**
	 * PaletteGroup에 표시되는 PaletteItem의 view
	 * Palette 쪽 클래스 구성과 이름이 매끄럽지 못하다. 정돈할 것!!!
	 */
	public class PaletteItemView extends Label {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for property item */
		private var _item: PaletteItem;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function PaletteItemView() {
			super();
			
			addEventListener(MouseEvent.CLICK, doClick);
			addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
		}		
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * 이 뷰가 표시하는 PaletteItem
		 */
		public function get item(): PaletteItem {
			return _item;
		}
		
		public function set item(value: PaletteItem): void{
			_item = value;
		}
		
		/**
		 * group
		 */
		public function get group(): PaletteGroup {
			return parent as PaletteGroup;
		}
		
		/**
		 * palette
		 */
		public function get palette(): Palette {
			return group.palette;
		}
		

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------
		protected function doClick(event: MouseEvent): void {
			if (palette)
				palette.dispatchEvent(new PaletteItemEvent(PaletteItemEvent.CLICK, PaletteItemView(event.currentTarget).item));
		}
		
		protected function doMouseDown(event: MouseEvent): void {
			//startDrag();
			var ds: DragSource = new DragSource();
			ds.addData(this.text, "paletteItem");
			DragManager.doDrag(this, ds, event);
			
		}
		
		protected function doMouseUp(event: MouseEvent): void {
			//stopDrag();
		}
	}
}