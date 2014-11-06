////////////////////////////////////////////////////////////////////////////////
//  Size.as
//  2008.01.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.common
{
	public class Size {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _width: Number;
		private var _height: Number;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		public function Size(width: Number = 0, height: Number = 0) {
			super();
			
			_width = width;
			_height = height;
		}		


		//----------------------------------------------------------------------
		// Class methods
		//----------------------------------------------------------------------

		public static function parse(value: String): Size {
			var arr: Array = value.split(",");
			return new Size(Number(arr[0]), Number(arr[1]));
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * width
		 */
		public function get width(): Number {
			return _width;
		}
		
		public function set width(value: Number): void {
			_width = value;
		}
		
		/**
		 * height
		 */
		public function get height(): Number {
			return _height;
		}
		
		public function set height(value: Number): void {
			_height = value;
		}

		/**
		 * dx
		 */
		public function get dx(): Number {
			return _width;
		}
		
		public function set dx(value: Number): void {
			_width = value;
		}

		
		/**
		 * dy
		 */
		public function get dy(): Number {
			return _height;
		}
		
		public function set dy(value: Number): void {
			_height = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		public function toString(): String {
			return width + "," + height;
		}
	}
}