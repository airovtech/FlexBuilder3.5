////////////////////////////////////////////////////////////////////////////////
//  DepartmentPropertyInfo.as
//  2008.04.18, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.workbench.common.property.EllipsisPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.modeler.xpdl.model.pool.Lane;
	
	/**
	 * Lane의 Department
	 */
	public class DepartmentPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: EllipsisPropertyEditor;
		private var _lane: Lane;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function DepartmentPropertyInfo(id: String, displayName: String, 
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
			_lane = source as Lane;
			
			if (!_editor) {
				_editor = new EllipsisPropertyEditor();
				_editor.clickHandler = doEditorClick;
			}

			_editor.data = _lane.deptName;			
			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: EllipsisPropertyEditor): void {
			//var dgm: XPDLDiagram = _task.xpdlDiagram;
			
			//SelectUserDialog.execute(dgm.server.organization, null, doAccept);
		}

		private function doAccept(item: Object): void {
/* 			if (item is User) {
				_task.performerName = User(item).name;
				_task.performer = User(item).id;
			} */
		}
	}
}