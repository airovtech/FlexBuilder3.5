////////////////////////////////////////////////////////////////////////////////
//  DomainPropertyEditor.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import mx.controls.ComboBox;
	
	/**
	 * 도메인을 갖는 속성을 편집하는 에디터
	 */
	public class DomainPropertyEditor extends ComboBoxPropertyEditor {
		
		//----------------------------------------------------------------------
		// Varaibles
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DomainPropertyEditor(domain: Array) {
			super();
			
			dataProvider = domain;
		}
	}
}