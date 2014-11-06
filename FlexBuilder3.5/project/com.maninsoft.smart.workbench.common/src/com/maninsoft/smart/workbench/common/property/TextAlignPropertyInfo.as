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
	public class TextAlignPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: TextAlignPropertyEditor;
		private var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("WorkbenchETC", "leftText"), data:"left"}, 
                  {label:ResourceManager.getInstance().getString("WorkbenchETC", "centerText"), data:"center"},
                  {label:ResourceManager.getInstance().getString("WorkbenchETC", "rightText"), data:"right"} ]);

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function TextAlignPropertyInfo(id: String, displayName: String, 
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
				_editor = new TextAlignPropertyEditor(VALUES);
			}
			
			return _editor;
		}
		
		override public function getText(value: Object): String {
			return value == "left" ? VALUES[0].label : value == "center" ? VALUES[1].label : value == "right" ? VALUES[2].label : VALUES[0].label;
		}				
	}
}