////////////////////////////////////////////////////////////////////////////////
//  LinkCondtionPropertyInfo.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.workbench.common.property
{
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.ListDataPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.display.DisplayObject;
	
	import mx.core.Application;
	
	/**
	 * XPDLLink의 condition 속성 
	 */
	public class ListDataPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ListDataPropertyEditor;
		private var _source: IPropertySource;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ListDataPropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}

		public function get editor():ListDataPropertyEditor{
			return _editor;
		}
		public function set editor(value:ListDataPropertyEditor):void{
			_editor = value;
		}
		
		public function get source():IPropertySource{
			return _source;
		}
		public function set source(value:IPropertySource):void{
			_source = value;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new ListDataPropertyEditor();
				_editor.clickHandler = doEditorClick;
			}
			_source = source;
			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		/**
		 * 프로퍼티 값 value를 문자열로 나타낸다.
		 */
		override public function getText(value: Object): String {
			return "";
		}
		
		protected function doEditorClick(editor: ListDataPropertyEditor): void {
			_editor.addItemClick();
		}

		private function doAccept(value:String): void {
			_editor.editValue = value;
		}
	}
}