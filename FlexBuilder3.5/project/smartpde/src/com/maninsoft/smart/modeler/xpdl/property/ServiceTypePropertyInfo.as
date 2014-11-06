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
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;	
	/**
	 * 문자열 속성
	 */
	public class ServiceTypePropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ServiceTypePropertyEditor;
		private static var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("ProcessEditorETC", "serviceTypeSystemText"), data:TaskService.SERVICE_TYPE_SYSTEM}, 
                  {label:ResourceManager.getInstance().getString("ProcessEditorETC", "serviceTypeMailText"), data:TaskService.SERVICE_TYPE_MAIL} ]);



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ServiceTypePropertyInfo(id: String, displayName: String, 
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
				_editor = new ServiceTypePropertyEditor(VALUES);
			}
			
			return _editor;
		}

		override public function getText(value: Object): String {
			if(value == TaskService.SERVICE_TYPE_SYSTEM)
				return VALUES[0].label;
			else if(value == TaskService.SERVICE_TYPE_MAIL)
				return VALUES[1].label;
			return VALUES[0].label;
		}							
	}
}