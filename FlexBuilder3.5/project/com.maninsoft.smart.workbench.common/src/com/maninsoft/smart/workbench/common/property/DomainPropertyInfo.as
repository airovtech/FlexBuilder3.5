////////////////////////////////////////////////////////////////////////////////
//  DomainPropertyInfo.as
//  2008.02.25, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	/**
	 * 도메인을 갖는 속성
	 */
	public class DomainPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _domain: Array;
		private var _editor: DomainPropertyEditor;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DomainPropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}
		

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		/**
		 * domain
		 */
		public function get domain(): Array {
			return _domain;
		}
		
		public function set domain(value: Array): void {
			_domain = value;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new DomainPropertyEditor(_domain);
			}
			
			return _editor;
		}
	}
}