////////////////////////////////////////////////////////////////////////////////
//  BooleanPropertyEditor.as
//  2008.01.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Boolean 속성을 편집하는 에디터
	 */
	public class EventTypePropertyEditor extends ComboBoxPropertyEditor{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function EventTypePropertyEditor(values: ArrayCollection) {
			super();
			
			dataProvider = values;
		}

		override public function get editValue(): Object {
			return selectedItem.data;
		}
		
		override public function set editValue(value: Object): void {
			if(value==IntermediateEvent.EVENT_TYPE_MAIL)
				selectedItem = dataProvider[0];
			else if(value==IntermediateEvent.EVENT_TYPE_TIMER)
				selectedItem = dataProvider[1];
		}
		
	}
}