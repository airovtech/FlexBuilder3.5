////////////////////////////////////////////////////////////////////////////////
//  SelectionMenuHandle.as
//  2008.01.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.modeler.controller.Controller;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Menu;
	import mx.events.FlexMouseEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	
	/**
	 * 선택된 DiagramObject를 위한 메뉴를 표시한다.
	 */
	public class SelectionMenuHandle extends Sprite {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _controller: Controller;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SelectionMenuHandle() {
			super();
			
			draw();
		}		
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * controller
		 */
		public function get controller(): Controller {
			return _controller;
		}
		
		public function set controller(value: Controller): void {
			_controller = value;
			
			if (!value) {
				this.visible = false;
			} else {
				var p: Point = controller.popUpPosition;
				
				p = controller.controllerToEditor(p);
				this.x = p.x - this.width;
				this.y = p.y;
				
				this.visible = true;
			}
		}
		

		//----------------------------------------------------------------------
		// methods
		//----------------------------------------------------------------------
		
		public function showMenu(): void {
			if (_controller) {
				var menu: Menu = createMenu(_controller.actions); 
				
				if (menu) {
					menu.addEventListener(MenuEvent.ITEM_CLICK, menu_click);
					menu.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, menu_MouseDownOutSide);
					menu.addEventListener(KeyboardEvent.KEY_DOWN, menu_KeyDown);
			
					var p: Point = new Point(x + width + 8, y);
					p = controller.editor.localToGlobal(p);
			
					menu.x = p.x * controller.editor.zoom / 100;
					menu.y = p.y * controller.editor.zoom / 100;
					
					menu.visible = true;
					menu.setFocus();
			
					PopUpManager.addPopUp(menu, _controller.editor, true);
				}
			}
		}
		
		private function menu_click(event: MenuEvent): void {
			event.item.execute();
		}
		
		private function menu_MouseDownOutSide(event: FlexMouseEvent): void {
			Menu(event.target).visible = false;
		}
		
		private function menu_KeyDown(event: KeyboardEvent): void {
			Menu(event.target).visible = false;
		}
		
		private function createMenu(actions: Array): Menu {
			if (actions && actions.length > 0) {
				var menu: Menu = Menu.createMenu(null, actions, false);
				return menu;
			}
			
			return null;	
		}
		
		public function refresh(): void {
			if (controller && visible) {
				var p: Point = controller.popUpPosition;
				
				p = controller.controllerToEditor(p);
				this.x = p.x - this.width;
				this.y = p.y;
			}
		}

		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		private function doMouseOver(event: MouseEvent): void {
		}

		private function doMouseOut(event: MouseEvent): void {
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function draw(): void {
			var g: Graphics = graphics;
			g.clear();

			g.beginFill(0xffff00);
			g.lineStyle(1, 0);
			
			g.drawRect(0, 0, 3, 9);
			
			g.moveTo(5, 0);
			g.lineTo(14, 5);
			g.lineTo(5, 9);
			g.lineTo(5, 0);
			
			g.endFill();
		}
		
	}
}