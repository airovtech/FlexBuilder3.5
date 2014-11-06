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
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;	
	/**
	 * 문자열 속성
	 */
	public class EventTypePropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: EventTypePropertyEditor;
		private static var VALUES: ArrayCollection = new ArrayCollection(
                [ {label:ResourceManager.getInstance().getString("ProcessEditorETC", "eventTypeMailText"), data:IntermediateEvent.EVENT_TYPE_MAIL}, 
                  {label:ResourceManager.getInstance().getString("ProcessEditorETC", "eventTypeTimerText"), data:IntermediateEvent.EVENT_TYPE_TIMER} ]);



		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function EventTypePropertyInfo(id: String, displayName: String, 
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
				_editor = new EventTypePropertyEditor(VALUES);
			}
			
			return _editor;
		}

		override public function getText(value: Object): String {
			if(value == IntermediateEvent.EVENT_TYPE_MAIL)
				return VALUES[0].label;
			else if(value == IntermediateEvent.EVENT_TYPE_TIMER)
				return VALUES[1].label;
			return VALUES[0].label;
		}							
	}
}