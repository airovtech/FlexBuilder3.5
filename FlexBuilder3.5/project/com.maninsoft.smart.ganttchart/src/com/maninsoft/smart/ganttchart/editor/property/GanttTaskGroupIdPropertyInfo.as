////////////////////////////////////////////////////////////////////////////////
//  FormIdPropertyInfo.as
//  2008.03.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.editor.property
{
	import com.maninsoft.smart.ganttchart.model.GanttTaskGroup;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectWorkIdDialog;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class GanttTaskGroupIdPropertyInfo extends PropertyInfo{
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _ganttTaskGroup: GanttTaskGroup;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function GanttTaskGroupIdPropertyInfo(id: String, displayName: String, 
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
			_ganttTaskGroup = source as GanttTaskGroup;
			
			if (!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon = PropertyIconLibrary.subFlowSelectIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("GanttEditorETC", "taskGroupIdSelectTTip");
			}
			if(_ganttTaskGroup.subProcessName)
				_editor.data = _ganttTaskGroup.subProcessName;
			else			
				_editor.data = WorkPackage.INTERNAL_GANTT_NAME;
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _ganttTaskGroup.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			SelectWorkIdDialog.execute(dgm.server, _editor, _ganttTaskGroup.subProcessId, doAccept, WorkPackage.PACKAGE_TYPE_GANTT, position, _editor.width);
		}

		private function doAccept(item: Object): void {
			if(WorkPackage(item).id == WorkPackage.INTERNAL_PROCESS_ID){
				_ganttTaskGroup.subProcessInfo = null;
				_editor.editValue = WorkPackage(item).name;				
			}else{
				_ganttTaskGroup.xpdlDiagram.server.getProcessInfoByPackage(WorkPackage(item).id, WorkPackage(item).version, getProcessInfoCallback);
				function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
					_ganttTaskGroup.subProcessInfo = svc.process;
					_editor.editValue = _ganttTaskGroup.subProcessName;
				}
			}
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
		
		public function get ganttTaskGroup(): GanttTaskGroup {
			return _ganttTaskGroup;
		}
		
		public function set ganttTaskGroup(val: GanttTaskGroup): void {
			_ganttTaskGroup = val;
		}
	}
}