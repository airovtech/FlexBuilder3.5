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
	public class BooleanPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: BooleanPropertyEditor;
		private var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("WorkbenchETC", "trueText"), data:true}, 
                  {label:ResourceManager.getInstance().getString("WorkbenchETC", "falseText"), data:false} ]);

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function BooleanPropertyInfo(id: String, displayName: String, 
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
				_editor = new BooleanPropertyEditor(VALUES);
			}
			
			return _editor;
		}
		
		override public function getText(value: Object): String {
			return value?VALUES[0].label:VALUES[1].label;
		}				
	}
}