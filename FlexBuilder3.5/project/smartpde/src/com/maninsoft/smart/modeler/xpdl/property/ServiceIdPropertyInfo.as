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
	import com.maninsoft.smart.formeditor.view.dialog.SelectServiceIdDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.formeditor.model.SystemService;
	
	import flash.geom.Point;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class ServiceIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _taskService: TaskService;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ServiceIdPropertyInfo(id: String, displayName: String, 
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
			_taskService = source as TaskService;
			
			if (!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon =  PropertyIconLibrary.serviceSelectIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "serviceIdSelectTTip");
				_editor.editValue = _taskService.serviceName;			
			}
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _taskService.xpdlDiagram;
			dgm.server.getSystemServices(result)
			function result():void{
				var position:Point = editor.localToGlobal(new Point(0, 0));
				SelectServiceIdDialog.execute(dgm.server.systemServices, dgm.server.findSystemService(_taskService.serviceId), doAccept, position, 650, 224);
			}
		}

		private function doAccept(item:Object): void {
			_taskService.systemService = item as SystemService;
			_taskService.serviceName = SystemService(item).name;
			_taskService.serviceId = SystemService(item).id;
			_editor.editValue = SystemService(item).name;
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function get xpdlDiagram(): XPDLDiagram {
			return _taskService.xpdlDiagram;
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
		
		public function get taskService(): TaskService{
			return _taskService;
		}
		
		public function set taskService(val: TaskService): void {
			_taskService = val;
		}
	}
}