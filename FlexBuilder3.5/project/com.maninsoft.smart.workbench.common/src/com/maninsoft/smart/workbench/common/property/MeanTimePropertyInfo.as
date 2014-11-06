package com.maninsoft.smart.workbench.common.property
{
	/**
	 * 문자열 속성
	 */
	public class MeanTimePropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: MeanTimePropertyEditor;
		private var _minimumMinutes:int;
		private var _maximumMinutes:int;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function MeanTimePropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null,
		                                   minimumMinutes:int = 0,
		                                   maximumMinutes:int = 0) {
			super(id, displayName, description, category, editable, helpId);
			_minimumMinutes = minimumMinutes;
			_maximumMinutes = maximumMinutes;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			if (!_editor) {
				_editor = new MeanTimePropertyEditor(_minimumMinutes, _maximumMinutes);
			}
			
			return _editor;
		}
				
	}
}