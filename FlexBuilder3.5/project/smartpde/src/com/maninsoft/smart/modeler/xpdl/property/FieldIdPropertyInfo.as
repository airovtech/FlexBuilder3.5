////////////////////////////////////////////////////////////////////////////////
//  FormIdPropertyInfo.as
//  2008.03.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectSubjectFieldDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.workbench.common.property.FormIdPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.FieldIdPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 fieldId
	 */
	public class FieldIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: FieldIdPropertyEditor;
		private var _task: TaskApplication;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FieldIdPropertyInfo(id: String, displayName: String, 
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
			_task = source as TaskApplication;
			
			if (!_editor) {
				_editor = new FieldIdPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "fieldIdSelectTTip");
			}

			_editor.data = _task.formName;			
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: FieldIdPropertyEditor): void {
			var dgm: XPDLDiagram = _task.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			SelectSubjectFieldDialog.execute(_task.subjectFieldId, _task, doAccept, position, _editor.width);
		}

		private function doAccept(item: Object): void {
			_task.subjectFieldId = TaskFormField(item).id
			_task.subjectFieldName = TaskFormField(item).name;
			_editor.editValue = TaskFormField(item).name;
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function updateTask(item: Object): void {
			_task.subjectFieldId = TaskFormField(item).id;
			_task.subjectFieldName = TaskFormField(item).name;
		}
		
		public function get xpdlDiagram(): XPDLDiagram {
			return _task.xpdlDiagram;
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
		
		public function get task(): TaskApplication {
			return _task;
		}
		
		public function set task(val: TaskApplication): void {
			_task = val;
		}
	}
}