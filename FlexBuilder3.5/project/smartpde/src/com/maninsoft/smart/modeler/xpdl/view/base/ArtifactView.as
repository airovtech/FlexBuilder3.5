////////////////////////////////////////////////////////////////////////////////
//  ArtifactView.as
//  2008.01.15, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.view.base
{
	import flash.text.TextFormat;
	
	/**
	 * Artifact view base
	 */
	public class ArtifactView extends XPDLNodeView	{
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		/** Storage for property text */
		private var _text: String = "";
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ArtifactView() {
			super();
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * text
		 */
		public function get text(): String {
			return _text;
		}
		
		public function set text(value: String): void {
			if (value != _text) {
				_text = value;
				refresh();
			}
		}
		
		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
		override protected function createTextFormat(): TextFormat {
			var fmt:TextFormat = new TextFormat();
			
			fmt.font = "윤고딕340";
			fmt.color = 0x666666;
			fmt.size = 11;
			fmt.bold = false;
			fmt.italic = false;
			fmt.underline = false;
			fmt.align = "left";
			
			return fmt;
		}

		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
	}
}