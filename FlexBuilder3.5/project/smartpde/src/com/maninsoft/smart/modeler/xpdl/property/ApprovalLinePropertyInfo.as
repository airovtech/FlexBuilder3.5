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
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectApprovalLineDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.ApprovalLine;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class ApprovalLinePropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _task: TaskApplication;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ApprovalLinePropertyInfo(id: String, displayName: String, 
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
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon =  PropertyIconLibrary.approvalLineIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "approvalLineSelectTTip");
				_editor.editValue = _task.approvalLineName;			
			}
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _task.xpdlDiagram;
			dgm.server.getApprovalLines(result)
			function result():void{
				var position:Point = editor.localToGlobal(new Point(0, 0));
				SelectApprovalLineDialog.execute(dgm.server.approvalLines, dgm.server.findApprovalLine(_task.approvalLine), doAccept, position, 552, 224);
			}
		}

		private function doAccept(item: Object): void {
			_task.approvalLineName = ApprovalLine(item).name;
			_task.approvalLine = ApprovalLine(item).id;
			_editor.editValue = ApprovalLine(item).name;
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function updateTask(item: Object): void {
			_task.approvalLine = ApprovalLine(item).id;
			_task.approvalLineName = ApprovalLine(item).name;
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