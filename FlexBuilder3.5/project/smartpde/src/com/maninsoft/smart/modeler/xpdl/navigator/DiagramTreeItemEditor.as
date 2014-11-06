////////////////////////////////////////////////////////////////////////////////
//  DiagramTreeItemEditor.as
//  2008.04.04, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.navigator
{
	import mx.controls.TextInput;
	
	/**
	 * DiagramTree 의 itemEditor
	 */
	public class DiagramTreeItemEditor extends TextInput {

		//----------------------------------------------------------------------
		// Initialization & finalization
		//----------------------------------------------------------------------
	
		public function DiagramTreeItemEditor() {
			super();
			
			setStyle("borderColor", 0x888888);
			setStyle("focusThickness", 0);
			setStyle("paddingTop", 0);
			setStyle("paddingBottom", 0);
			setStyle("fontWeight", "normal");
		}
		
		override protected function createChildren(): void {
			super.createChildren();
			// 한글 입력 빠르게
			textField.alwaysShowSelection = true;
		}
	}
}