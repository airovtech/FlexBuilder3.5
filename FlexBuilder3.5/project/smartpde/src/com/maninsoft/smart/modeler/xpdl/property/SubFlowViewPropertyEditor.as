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
	import com.maninsoft.smart.workbench.common.property.ComboBoxPropertyEditor;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Boolean 속성을 편집하는 에디터
	 */
	public class SubFlowViewPropertyEditor extends ComboBoxPropertyEditor{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function SubFlowViewPropertyEditor(values: ArrayCollection) {
			super();
			
			dataProvider = values;
		}

		override public function get editValue(): Object {
			return selectedItem.data;
		}
		
		override public function set editValue(value: Object): void {
			
			selectedItem = (value==SubFlow.VIEW_COLLAPSED)?dataProvider[0]:dataProvider[1];	
		}
		
	}
}