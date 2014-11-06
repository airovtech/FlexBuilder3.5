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
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;	
	/**
	 * 문자열 속성
	 */
	public class MultiInstanceBehaviorPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: MultiInstanceBehaviorPropertyEditor;
		private static var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorNoneText"), data:Activity.BEHAVIOR_NONE}, 
                  {label:ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorAllText"), data:Activity.BEHAVIOR_ALL},
                  {label:ResourceManager.getInstance().getString("ProcessEditorETC", "behaviorOneText"), data:Activity.BEHAVIOR_ONE} ]);



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MultiInstanceBehaviorPropertyInfo(id: String, displayName: String, 
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
				_editor = new MultiInstanceBehaviorPropertyEditor(VALUES);
			}
			
			return _editor;
		}

		override public function getText(value: Object): String {
			if(value == Activity.BEHAVIOR_NONE)
				return VALUES[0].label;
			else if(value == Activity.BEHAVIOR_ALL)
				return VALUES[1].label;
			else if(value == Activity.BEHAVIOR_ONE)
				return VALUES[2].label;		
			return VALUES[0].label;
		}								
	}
}