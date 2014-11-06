////////////////////////////////////////////////////////////////////////////////
//  SelectHandle.as
//  2007.12.21, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.common.assets.Cursors;
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	import com.maninsoft.smart.modeler.editor.tool.ResizeTracker;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.managers.CursorManager;
	
	/**
	 * 선택된 DiagramObject의 한 쪽 선택 핸들을 표시한다.
	 */
	public class SelectHandle extends Sprite implements IDraggableHandle {
		
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------

		/** anchor direction */
		public static const DIR_TOPLEFT	 	: int = 0;
		public static const DIR_TOP   	 	: int = 1;
		public static const DIR_TOPRIGHT	 	: int = 2;
		public static const DIR_RIGHT		 	: int = 3;
		public static const DIR_BOTTOMRIGHT	: int = 4;
		public static const DIR_BOTTOM	 	: int = 5;
		public static const DIR_BOTTOMLEFT 	: int = 6;
		public static const DIR_LEFT		 	: int = 7;

		/** 기본 크기 */
		public static const DEF_SIZE: int = 3;

		/** 기본 바탕색 */
		public static const DEF_FILL_COLOR: uint = 0x000000;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for property owner */
		private var _controller: Controller;
		
		/** Storage for property anchorDir */
		private var _anchorDir: int;
		
		/** Storage for property fillColor */
		private var _fillColor: uint = DEF_FILL_COLOR;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SelectHandle(controller: Controller, anchorDir: int, size: int = DEF_SIZE) {
			super();
			
			_controller = controller;
			_anchorDir = anchorDir;
			
			draw(size);
			
			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}		
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * property controller
		 */
		public function get controller(): Controller {
			return _controller;
		}
		
		/**
		 * 마우스로 이 핸들을 드래깅해서 개체의 크기를 변경하고자 할 때
		 * 크기 변경의 방향 
		 */
		public function get anchorDir(): int {
			return _anchorDir;
		}
		
		public function set anchorDir(value: int): void {
			_anchorDir = value;
		}
		
		/**
		 * property fillColor
		 */
		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			_fillColor = value;
		}
		

		//----------------------------------------------------------------------
		// methods
		//----------------------------------------------------------------------
		
		public function getDragTracker(): DragTracker {
			return new ResizeTracker(this);
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		protected function doMouseOver(event: MouseEvent): void {
			var cursor: Class;
			
			switch (anchorDir) {
				case DIR_LEFT:
				case DIR_RIGHT:
					cursor = Cursors.sizeWE;
					break;
					
				case DIR_TOPLEFT:
				case DIR_BOTTOMRIGHT:
					cursor = Cursors.sizeNWSE;
					break;
					
				case DIR_TOPRIGHT:
				case DIR_BOTTOMLEFT:
					cursor = Cursors.sizeNESW;
					break;
					
				default:
					cursor = Cursors.sizeNS;
					break;
			}
			
			CursorManager.setCursor(cursor, 2, -8, -8);
		}

		protected function doMouseOut(event: MouseEvent): void {
			CursorManager.removeCursor(CursorManager.currentCursorID);
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function draw(sz: int): void {
			var g: Graphics = graphics;
			g.clear();
			
			if (controller) {
				//GraphicUtils.drawCircle(g, -sz / 2, -sz / 2, sz, sz, fillColor);
				g.beginFill(0xffffff, 0.2);
				g.drawRect(0, 0, sz*2, sz*2);
				g.endFill();
				GraphicUtils.drawRect(g, 1.5, 1.5, sz, sz, fillColor);
			}
		}
		
	}
}