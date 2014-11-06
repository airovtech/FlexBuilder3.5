////////////////////////////////////////////////////////////////////////////////
//  Event.as
//  2007.12.20, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.model.base
{
	import com.maninsoft.smart.modeler.model.DiagramObject;
	import com.maninsoft.smart.modeler.model.Node;
	
	/**
	 * XPDL Event activity
	 */
	public class Event extends Activity {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
		
		/** Construtor */
		public function Event() {
			super();
			
			_width = defaultWidth;
			_height = defaultHeight;
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		

		//----------------------------------------------------------------------
		// Overriden properties
		//----------------------------------------------------------------------
		
		override public function get defaultWidth(): Number {
			return 35;
		}

		override public function get defaultHeight(): Number {
			return 35;
		}
		
		override public function get defaultFillColor(): uint {
			return 0xeff8ff;
		}

		override public function get defaultBorderColor(): uint {
			return 0xa0c4ce;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		
		override public function assign(source: DiagramObject): void {
			super.assign(source);
			
			_width = Math.min(_width, _height);
			_height = _width;
		}
		
		override public function resize(newWidth: int, newHeight: int): void {
			// 정사각형 경계의 원이 되도록 한다.
			newHeight = newWidth = Math.min(newWidth, newHeight);
			super.resize(newWidth, newHeight);
		}
	}
}