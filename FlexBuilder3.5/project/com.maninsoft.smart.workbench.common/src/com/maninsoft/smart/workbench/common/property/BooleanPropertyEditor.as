////////////////////////////////////////////////////////////////////////////////
//  BooleanPropertyEditor.as
//  2008.01.28, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import mx.collections.ArrayCollection;
	
	/**
	 * Boolean 속성을 편집하는 에디터
	 */
	public class BooleanPropertyEditor extends ComboBoxPropertyEditor	{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function BooleanPropertyEditor(values: ArrayCollection) {
			super();
			
			dataProvider = values;
		}

		override public function get editValue(): Object {
			return selectedItem.data;
		}
		
		override public function set editValue(value: Object): void {
			
			selectedItem = value?dataProvider[0]:dataProvider[1];	
		}
		
	}
}