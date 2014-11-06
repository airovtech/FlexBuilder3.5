////////////////////////////////////////////////////////////////////////////////
//  ColorPropertyInfo.as
//  2008.03.12, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	/**
	 * Color 속성
	 */
	public class TextColorPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: TextColorPropertyEditor;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function TextColorPropertyInfo(id: String, displayName: String,
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
				_editor = new TextColorPropertyEditor();
			}
			
			var formEntity:FormEntity = source as FormEntity;
			_editor.editValue = formEntity.getPropertyValue(FormEntity.PROP_TEXTCOLOR);
			return _editor;
		}
		
		override public function getText(value: Object):String {
			return (value != null) ? Number(value).toString(16) : "";	
		}
		
//		override public function get pageItemClass(): Class {
//			return ColorPropertyPageItem;
//		}
	}
}