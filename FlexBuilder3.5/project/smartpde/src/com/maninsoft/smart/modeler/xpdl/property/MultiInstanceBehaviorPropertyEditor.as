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
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Boolean 속성을 편집하는 에디터
	 */
	public class MultiInstanceBehaviorPropertyEditor extends ComboBoxPropertyEditor{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MultiInstanceBehaviorPropertyEditor(values: ArrayCollection) {
			super();
			
			dataProvider = values;
		}

		override public function get editValue(): Object {
			return selectedItem.data;
		}
		
		override public function set editValue(value: Object): void {
			if(value==Activity.BEHAVIOR_NONE)
				selectedItem = dataProvider[0];
			else if(value==Activity.BEHAVIOR_ALL)
				selectedItem = dataProvider[1];
			else if(value==Activity.BEHAVIOR_ONE)
				selectedItem = dataProvider[2];
		}
		
	}
}