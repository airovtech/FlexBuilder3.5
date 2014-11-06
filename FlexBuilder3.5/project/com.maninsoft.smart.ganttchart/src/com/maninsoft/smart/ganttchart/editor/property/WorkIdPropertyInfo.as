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
	import com.maninsoft.smart.ganttchart.model.GanttTask;
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectWorkIdDialog;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.service.GetProcessInfoByPackageService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class WorkIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _task: GanttTask;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function WorkIdPropertyInfo(id: String, displayName: String, 
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
			_task = source as GanttTask;
			
			if (!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon = PropertyIconLibrary.workIdSelectIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("GanttChartEditorETC", "workIdSelectTTip");
			}

			_editor.data = _task.workName;			
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _task.xpdlDiagram;
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			var work: WorkPackage = dgm.server.findWork(_task.workId);
			if(task.formId){
				MsgUtil.confirmMsg(resourceManager.getString("ProcessEditorMessages", "PEI004"), confirmResult);
				function confirmResult(resultVal:Boolean):void{
					if(resultVal==false) return;
					SelectWorkIdDialog.execute(dgm.server, _editor, _task.workId, doAccept, WorkPackage.PACKAGE_TYPE_SINGLE, position, _editor.width);
				}
			}else{
				SelectWorkIdDialog.execute(dgm.server, _editor, _task.workId, doAccept, WorkPackage.PACKAGE_TYPE_SINGLE, position, _editor.width);
			}
		}

		private function doAccept(item: Object): void {
			if(WorkPackage(item).id == WorkPackage.EMPTY_WORK_ID){
				_task.workInfo = null;
				_editor.editValue = WorkPackage(item).name;
			}else{
				_task.xpdlDiagram.server.getProcessInfoByPackage(WorkPackage(item).id, WorkPackage(item).version, getProcessInfoCallback);
				function getProcessInfoCallback(svc: GetProcessInfoByPackageService):void{
					_task.workInfo = svc.process;
					_editor.editValue = _task.workName;
				}
			}
		}

		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function get xpdlDiagram(): XPDLDiagram {
			return _task.xpdlDiagram;
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
		
		public function get task(): GanttTask {
			return _task;
		}

		public function set task(val: GanttTask): void {
			_task = val;
		}
	}
}