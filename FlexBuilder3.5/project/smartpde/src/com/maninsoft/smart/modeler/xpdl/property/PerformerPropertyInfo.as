////////////////////////////////////////////////////////////////////////////////
//  PerformerPropertyInfo.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectUserDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.Department;
	import com.maninsoft.smart.modeler.xpdl.server.Group;
	import com.maninsoft.smart.modeler.xpdl.server.TaskFormField;
	import com.maninsoft.smart.modeler.xpdl.server.User;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 performer
	 */
	public class PerformerPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _task: TaskApplication;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function PerformerPropertyInfo(id: String, displayName: String, 
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
				_editor.buttonIcon = PropertyIconLibrary.performerIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "performerSelectTTip");
			}

			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _task.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			SelectUserDialog.execute(dgm.server, null, _task, doAccept, position, _editor.width, 0, true);
		}

		private function doAccept(item: Object): void {
			if(!item || item.id == User.EMPTY_USER_ID){
				_task.performerName = null;
				_task.performer = null;
				_editor.editValue = User.EMPTY_USER_NAME
				return;
			}
			
			if(item is User) {
				_task.performerName = User(item).label;
				_task.performer = User(item).id;					
			}else if(item is Department) {
				_task.performerName = Department(item).label;
				_task.performer = Department(item).id;					
			}else if(item is Group) {
				_task.performerName = Group(item).label;
				_task.performer = Group(item).id;					
			}else if(item is TaskFormField){
				_task.performerName = TaskFormField(item).name;
				_task.performer = TaskFormField(item).id;
			}else if(item is Array && item.length == 2){
				_task.performerName = item[1];
				_task.performer = item[0];
			}
			_editor.editValue = _task.performerName;
		}
	}
}