////////////////////////////////////////////////////////////////////////////////
//  ColorPropertyInfo.as
//  2008.03.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.page.ColorPropertyPageItem;
	
	/**
	 * Color 속성
	 */
	public class ColorPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ColorPropertyEditor;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ColorPropertyInfo(id: String, displayName: String,
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new ColorPropertyEditor();
			}
			
			return _editor;
		}
		
		override public function getText(value: Object):String {
			return (value != null) ? Number(value).toString(16) : "";	
		}
		
		override public function get pageItemClass(): Class {
			return ColorPropertyPageItem;
		}
	}
}