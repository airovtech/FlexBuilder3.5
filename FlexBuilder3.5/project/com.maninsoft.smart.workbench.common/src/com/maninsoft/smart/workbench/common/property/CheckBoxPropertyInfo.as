package com.maninsoft.smart.workbench.common.property
{
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;
	
	/**
	 * 문자열 속성
	 */
	public class CheckBoxPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: CheckBoxPropertyEditor;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function CheckBoxPropertyInfo(id: String, displayName: String, 
		                                      description: String = null,
		                                      category: String = null,
		                                      editable: Boolean = true,
		                                      helpId: String = null) {
			super(id, displayName, description, category, editable, helpId);
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new CheckBoxPropertyEditor();
			}
			
			return _editor;
		}
		
		override public function getText(value: Object): String {
			return value.toString();
		}				
	}
}