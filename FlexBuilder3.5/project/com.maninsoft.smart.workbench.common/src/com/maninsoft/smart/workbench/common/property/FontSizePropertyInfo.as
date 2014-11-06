////////////////////////////////////////////////////////////////////////////////
//  BooleanPropertyInfo.as
//  2008.01.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	/**
	 * 문자열 속성
	 */
	public class FontSizePropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: FontSizePropertyEditor;
		private var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("WorkbenchETC", "smallFontText"), data:"11"}, 
                  {label:ResourceManager.getInstance().getString("WorkbenchETC", "normalFontText"), data:"12"},
                  {label:ResourceManager.getInstance().getString("WorkbenchETC", "bigFontText"), data:"14"} ]);

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FontSizePropertyInfo(id: String, displayName: String, 
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
				_editor = new FontSizePropertyEditor(VALUES);
			}
			
			return _editor;
		}
		
		override public function getText(value: Object): String {
			return value=="11"?VALUES[0].label: value=="12" ? VALUES[1].label : VALUES[2].label;
		}				
	}
}