////////////////////////////////////////////////////////////////////////////////
//  ConnectHandle.as
//  2007.12.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.controller.NodeController;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Connectiong 시 사용되는 handle
	 */
	public class ConnectHandle extends Sprite	{

		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------

		/** 기본 크기 */
		public static const DEF_SIZE: int = 6;

		/** 기본 바탕색 */
		public static const DEF_FILL_COLOR: uint = 0xffffff;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _controller: NodeController;
		private var _anchor: Number;
		
		/** Storage for property fillColor */
		private var _fillColor: uint = DEF_FILL_COLOR;

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		public function ConnectHandle(controller: NodeController, anchor: Number) {
			super();
			
			_controller = controller;
			_anchor = anchor;
			
			draw(DEF_SIZE);
			
			addEventListener(MouseEvent.CLICK, doClick);
			addEventListener(MouseEvent.MOUSE_OVER, doMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get controller(): NodeController {
			return _controller;
		}
		
		public function get anchor(): Number {
			return _anchor;
		}
		
		/**
		 * property fillColor
		 */
		public function get fillColor(): uint {
			return _fillColor;
		}
		
		public function set fillColor(value: uint): void {
			if (value != _fillColor) {
				_fillColor = value;
				draw(DEF_SIZE);
			}
		}


		//----------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------

		private function doClick(event: MouseEvent): void {
			trace(event);
		}

		private function doMouseOver(event: MouseEvent): void {
			trace(event);
			fillColor = 0xff0000;
		}

		private function doMouseOut(event: MouseEvent): void {
			trace(event);
			fillColor = 0xffffff;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		protected function draw(sz: int): void {
			var g: Graphics = graphics;
			g.clear();
			
			GraphicUtils.drawRect(g, -sz / 2, -sz / 2, sz, sz, fillColor);
		}
	}
}