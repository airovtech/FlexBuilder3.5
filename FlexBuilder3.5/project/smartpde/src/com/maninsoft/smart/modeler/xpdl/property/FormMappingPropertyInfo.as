////////////////////////////////////////////////////////////////////////////////
//  LinkCondtionPropertyInfo.as
//  2008.02.01, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.property
{
	import com.maninsoft.smart.formeditor.model.Mapping;
	import com.maninsoft.smart.modeler.xpdl.dialogs.FormMappingDialog;
	import com.maninsoft.smart.modeler.xpdl.model.IntermediateEvent;
	import com.maninsoft.smart.modeler.xpdl.model.TaskService;
	import com.maninsoft.smart.workbench.common.property.FormMappingPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	
	import mx.managers.PopUpManager;
	
	/**
	 * FormMapping 의 condition 속성 
	 */
	public class FormMappingPropertyInfo extends PropertyInfo {
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: FormMappingPropertyEditor;
		private var _mapping: Mapping;
		private var _task:TaskService;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function FormMappingPropertyInfo(id: String, displayName: String, 
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
			_task = source as TaskService;
			if(_task.serviceType == TaskService.SERVICE_TYPE_MAIL){
				if(id == TaskService.PROP_MAIL_RECEIVERS)
					_mapping = _task.mailReceivers;
				else if(id == TaskService.PROP_MAIL_CC_RECEIVERS)				
					_mapping = _task.mailCcReceivers;
				else if(id == TaskService.PROP_MAIL_BCC_RECEIVERS)				
					_mapping = _task.mailBccReceivers;
				else if(id == TaskService.PROP_MAIL_SUBJECT)				
					_mapping = _task.mailSubject;
				else if(id == TaskService.PROP_MAIL_CONTENT)				
					_mapping = _task.mailContent;
				else if(id == TaskService.PROP_MAIL_ATTACHMENT)				
					_mapping = _task.mailAttachment;
			}
			if(_mapping == null){
				_mapping = new Mapping(null);
				_mapping.name = resourceManager.getString("ProcessEditorETC", "noneText");
			}

			
			if (!_editor) {
				_editor = new FormMappingPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.dialogButton.toolTip = resourceManager.getString("ProcessEditorETC", "formMappingTTip");
			}

			
			return _editor;
		}


		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: FormMappingPropertyEditor): void {
			var position:Point = editor.localToGlobal(new Point(0, 0));
			var formMappingDialog:FormMappingDialog = PopUpManager.createPopUp(editor, FormMappingDialog, true) as FormMappingDialog;
			formMappingDialog.mapping = _mapping
			formMappingDialog.diagram = _task.xpdlDiagram;
			formMappingDialog.acceptFunc = doAccept;
			formMappingDialog.x = position.x;
			formMappingDialog.y = position.y;
		}

		private function doAccept(mapping:Mapping): void {
			if(_task && _task.serviceType == TaskService.SERVICE_TYPE_MAIL){
				if(id == TaskService.PROP_MAIL_RECEIVERS)
					_task.mailReceivers = mapping;
				else if(id == TaskService.PROP_MAIL_CC_RECEIVERS)				
					_task.mailCcReceivers = mapping;
				else if(id == TaskService.PROP_MAIL_BCC_RECEIVERS)				
					_task.mailBccReceivers = mapping;
				else if(id == TaskService.PROP_MAIL_SUBJECT)				
					_task.mailSubject = mapping;
				else if(id == TaskService.PROP_MAIL_CONTENT)				
					_task.mailContent = mapping;
				else if(id == TaskService.PROP_MAIL_ATTACHMENT)				
					_task.mailAttachment = mapping;
				_editor.editValue = mapping==null ? resourceManager.getString("ProcessEditorETC", "noneText") : mapping.name;
			}
		}
	}
}