////////////////////////////////////////////////////////////////////////////////
//  PaletteItem.as
//  2007.12.13, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.palette
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	
	/**
	 * Palette item
	 */
	public class PaletteItem extends ObjectBase {

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for property className */
		private var _className: String;
		
		/** Storage for property label */
		private var _label: String;
		
		
		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function PaletteItem() {
			super();
		}
		
		
		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * property className
		 */
		public function get className(): String {
			return _className;
		}
		
		public function set className(value: String): void {
			_className = value;
		}
		
		
		/**
		 * property label 
		 */
		public function get label(): String {
			return _label;
		}
		
		public function set label(value: String): void {
			_label = value;
		}
	}
}