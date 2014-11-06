package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.formeditor.model.ActualParameters;
	import com.maninsoft.smart.modeler.xpdl.dialogs.ActualParametersDialog;
	import com.maninsoft.smart.modeler.xpdl.model.SubFlow;
	import com.maninsoft.smart.modeler.xpdl.model.TaskApplication;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.modeler.xpdl.model.base.Activity;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	import com.maninsoft.smart.workbench.common.property.ActualParametersPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import flash.geom.Point;
	
	/**
	 * XPDLLink의 condition 속성 
	 */
	public class ActualParametersPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ActualParametersPropertyEditor;
		private var _activity: Activity;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function ActualParametersPropertyInfo(id: String, displayName: String, 
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
			if (!_editor) {
				_editor = new ActualParametersPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "actualParametersTTip");
			}

			_activity = source as Activity;
			if(_activity is SubFlow && SubFlow(_activity).actualParameters){
				_editor.data = SubFlow(_activity).actualParameters.toString();
			}else if(_activity is TaskService && TaskService(_activity).actualParameters){
				_editor.data = TaskService(_activity).actualParameters.toString();
			}else if(_activity is TaskApplication && TaskApplication(_activity).actualParameters){
				_editor.data = TaskApplication(_activity).actualParameters.toString();
			}
			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ActualParametersPropertyEditor): void {
			var position:Point = editor.localToGlobal(new Point(0, 0));
			if(_activity is TaskService){
				var taskService:TaskService = _activity as TaskService;
				if(!taskService.serviceId){
					MsgUtil.showError(resourceManager.getString("ProcessEditorMessages", "PEE004"));
					return;
				}
			}else if(_activity is SubFlow){
				var subFlow:SubFlow = _activity as SubFlow;
				if(!subFlow.subProcessId){
					MsgUtil.showError(resourceManager.getString("ProcessEditorMessages", "PEE005"));
					return;
				}
			}else if(_activity is TaskApplication){
				var task:TaskApplication = _activity as TaskApplication;
				if(!task.appId || task.appId == ApplicationService.EMPTY_APPLICATION_SERVICE || task.appId == TaskApplication.SYSTEM_APPLICATION_ID){
					MsgUtil.showError(resourceManager.getString("ProcessEditorMessages", "PEE006"));
					return;
				}
			}
			ActualParametersDialog.execute(_activity, doAccept, position);
		}

		private function doAccept(actualParams:ActualParameters): void {
			if (actualParams != null){
				if(_activity is SubFlow)
					SubFlow(_activity).actualParameters = actualParams;
				else if(_activity is TaskService)
					TaskService(_activity).actualParameters = actualParams;
				else if(_activity is TaskApplication)
					TaskApplication(_activity).actualParameters = actualParams;
				_editor.editValue = actualParams.toString();
			}
		}
	}
}