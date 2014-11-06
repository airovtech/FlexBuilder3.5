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
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectFormDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.TaskForm;
	import com.maninsoft.smart.workbench.common.property.FormIdPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class FormIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: FormIdPropertyEditor;
		private var _task: TaskApplication;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FormIdPropertyInfo(id: String, displayName: String, 
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
				_editor = new FormIdPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "formIdSelectTTip");
				_editor.formEditButton.toolTip = resourceManager.getString("ProcessEditorETC", "formEditTTip");
			}

			_editor.data = _task.formName;			
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: FormIdPropertyEditor): void {
			var dgm: XPDLDiagram = _task.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			var form:TaskForm = dgm.server.findForm(_task.formId);
			if(!form && _task.formId==TaskApplication.SYSTEM_FORM_ID){
				form = new TaskForm();
				form.id = _task.formId;
				form.formId = _task.formId;
				form.name = _task.formName;
				form.version = _task.formVersion;
			}
			if(!task.hasOwnProperty("workId")){
				SelectFormDialog.execute(dgm.server, form, doAccept, false, position, _editor.width);
			}else{
				if(task["workId"]){
					MsgUtil.confirmMsg(resourceManager.getString("ProcessEditorMessages", "PEI005"), confirmResult);
					function confirmResult(resultVal:Boolean):void{
						if(resultVal==false) return;
						SelectFormDialog.execute(dgm.server, form, doAccept, false, position, _editor.width);
					}
				}else{
					SelectFormDialog.execute(dgm.server, form, doAccept, false, position, _editor.width);					
				}
			}
		}

		private function doAccept(item: Object): void {
			_task.formId = TaskForm(item).formId;
			_task.formVersion = TaskForm(item).version;
			_editor.editValue = TaskForm(item).name;
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function updateTask(item: Object): void {
			_task.formId = TaskForm(item).formId;
			_task.formVersion = TaskForm(item).version;
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