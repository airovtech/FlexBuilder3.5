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
	import com.maninsoft.smart.modeler.xpdl.dialogs.SelectApplicationIdDialog;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.XPDLDiagram;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	public class ApplicationIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _taskApplication: TaskApplication;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ApplicationIdPropertyInfo(id: String, displayName: String, 
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
			_taskApplication = source as TaskApplication;
			
			if (!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon =  PropertyIconLibrary.applicationSelectIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "applicationIdSelectTTip");
				_editor.editValue = _taskApplication.appName;			
			}
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var dgm: XPDLDiagram = _taskApplication.xpdlDiagram;
			dgm.server.getApplicationServices(result)
			function result():void{
				var position:Point = editor.localToGlobal(new Point(0, 0));
				SelectApplicationIdDialog.execute(dgm.server.applicationServices, dgm.server.findApplicationService(_taskApplication.appId), doAccept, position, 650, 224);
			}
		}

		private function doAccept(item:Object): void {
			_taskApplication.applicationService = item as ApplicationService;
			_taskApplication.appName = ApplicationService(item).name;
			_taskApplication.appId = ApplicationService(item).id;
			_editor.editValue = ApplicationService(item).name;
		}
		
		//----------------------------------------------------------------------
		// External methods
		//----------------------------------------------------------------------
		
		public function doClick(): void {
			this.doEditorClick(null);
		}
		
		public function get xpdlDiagram(): XPDLDiagram {
			return _taskApplication.xpdlDiagram;
		}
		
		//----------------------------------------------------------------------
		// getter and setter
		//----------------------------------------------------------------------
		
		public function get taskApplication(): TaskApplication{
			return _taskApplication;
		}
		
		public function set taskApplication(val: TaskApplication): void {
			_taskApplication = val;
		}
	}
}