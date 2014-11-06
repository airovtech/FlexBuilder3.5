////////////////////////////////////////////////////////////////////////////////
//  BooleanPropertyInfo.as
//  2008.01.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	
	import mx.collections.ArrayCollection;
	
	import mx.resources.ResourceManager
	
	/**
	 * 문자열 속성
	 */
	public class SubFlowExecutionPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: SubFlowExecutionPropertyEditor;
		private static var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("ProcessEditorETC", "synchrText"), data:SubFlow.EXECUTION_SYNCHR}, 
                  {label:ResourceManager.getInstance().getString("ProcessEditorETC", "asynchrText"), data:SubFlow.EXECUTION_ASYNCHR} ]);



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SubFlowExecutionPropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor{
			if (!_editor) {
				_editor = new SubFlowExecutionPropertyEditor(VALUES);
			}
			
			return _editor;
		}

		override public function getText(value: Object): String {
			return (value==SubFlow.EXECUTION_SYNCHR)?VALUES[0].label:VALUES[1].label;
		}								
	}
}