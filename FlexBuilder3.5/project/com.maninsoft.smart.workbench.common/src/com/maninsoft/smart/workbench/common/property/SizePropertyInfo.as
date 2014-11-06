////////////////////////////////////////////////////////////////////////////////
//  SizePropertyInfo.as
//  2008.01.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	/**
	 * Size 속성
	 */
	public class SizePropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: TextPropertyEditor;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SizePropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------
				
		override public function getText(value: Object): String {
			return value ? value.toString() : null;
		}

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new SizePropertyEditor();
			}
			
			return _editor;
		}
	}
}