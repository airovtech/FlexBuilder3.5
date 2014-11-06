////////////////////////////////////////////////////////////////////////////////
//  SelectHandle.as
//  2007.12.29, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.editor.handle
{
	import com.maninsoft.smart.modeler.common.GraphicUtils;
	import com.maninsoft.smart.modeler.controller.Controller;
	import com.maninsoft.smart.modeler.controller.LinkController;
	import com.maninsoft.smart.modeler.editor.tool.DragTracker;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * 선택된 링크를 tooling 할 수 있는 핸들
	 */
	public class LinkHandle extends Sprite {
		//----------------------------------------------------------------------
		// Class constants
		//----------------------------------------------------------------------
		/** 기본 바탕색 */
		public static const DEF_FILL_COLOR: uint = 0xffffff;

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for property owner */
		private var _controller: Controller;
		
		/** Storage for property fillColor */
		private var _fillColor: uint = DEF_FILL_COLOR;
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LinkHandle(controller: LinkController) {
			super();
			
			_controller = controller;
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
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	}
}