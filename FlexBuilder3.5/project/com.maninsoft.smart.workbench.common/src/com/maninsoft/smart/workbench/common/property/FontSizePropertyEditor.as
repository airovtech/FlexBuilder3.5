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
	 * FontWeight 속성을 편집하는 에디터
	 */
	public class FontSizePropertyEditor extends ComboBoxPropertyEditor	{

		//----------------------------------------------------------------------
		// Class consts
		//----------------------------------------------------------------------

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FontSizePropertyEditor(values: ArrayCollection) {
			super();
			
			dataProvider = values;
		}

		override public function get editValue(): Object {
			return selectedItem.data;
		}
		
		override public function set editValue(value: Object): void {
			
			selectedItem = value=="11"?dataProvider[0]: value=="12" ? dataProvider[1] : dataProvider[2];	
		}
		
	}
}