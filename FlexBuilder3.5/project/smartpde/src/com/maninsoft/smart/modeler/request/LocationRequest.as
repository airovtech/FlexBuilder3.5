////////////////////////////////////////////////////////////////////////////////
//  LocationRequest.as
//  2007.12.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.request
{
	import flash.geom.Point;
	
	/**
	 * 위치 값을 전달하는 요청
	 * 예를 들면, mouse 클릭, mouse drop 등...
	 */
	public class LocationRequest extends Request {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		/** Storage for pos */
		private var _pos: Point;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function LocationRequest(name: String, x: int, y: int) {
			super(name);
			
			_pos = new Point(x, y);
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get pos(): Point {
			return _pos.clone();		
		}
	}
}