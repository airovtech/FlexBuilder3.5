////////////////////////////////////////////////////////////////////////////////
//  FormIdPropertyInfo.as
//  2008.03.17, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.formeditor.model.property
{
	import com.maninsoft.smart.formeditor.FormEditorBase;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.util.FormEditorService;
	import com.maninsoft.smart.formeditor.view.dialog.SelectRefFormIdDialog;
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
	public class RefFormIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _formEntity: FormEntity;
		private var _formRef: FormRef;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function RefFormIdPropertyInfo(id: String, displayName: String, 
		                                   description: String = null,
		                                   category: String = null,
		                                   editable: Boolean = true,
		                                   helpId: String = null ) {
			super(id, displayName, description, category, editable, helpId);
		}



		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override public function getEditor(source: IPropertySource): IPropertyEditor {
			_formEntity = source as FormEntity;
			if(!_formEntity.format.formRef){
				_formRef = new FormRef();
				if(_formEntity.format.refFormId){
					FormEditorService.getFormRef(_formEntity.format.refFormId, formRefCallback);
					function formRefCallback(formRef:FormRef):void{
						_formRef = formRef;
					}
				}else{
					_formRef.id = FormEntity.EMPTY_FORMID;
					_formRef.name = FormEntity.EMPTY_FORMNAME;
				}
			}else{
				_formRef = _formEntity.format.formRef;
			}
			
			if(!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon = PropertyIconLibrary.refFormIdIcon;
				_editor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "refFormIdSelectTTip");
			}

			if(_formRef.id == FormEntity.EMPTY_FORMID){
				_editor.data = FormEntity.EMPTY_FORMNAME;
			}else{			
				_editor.data = _formRef.label;
			}			
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------
		
		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			SelectRefFormIdDialog.execute(FormEditorBase.getInstance(), _formRef, doAccept, position, _editor.width, 0, true, true);
		}

		private function doAccept(item: Object): void {
			if(item is WorkPackage){
				var format: FormFormatInfo = _formEntity.format.clone();
				if(WorkPackage(item).id == FormEntity.EMPTY_FORMID){
					_formRef = null;
					format.refFormId = null;
					_formEntity.format = format;
					_editor.editValue = FormEntity.EMPTY_FORMNAME;
				}else if(WorkPackage(item).formId){
					FormEditorService.getFormRef(WorkPackage(item).formId, formRefCallback);
					function formRefCallback(formRef:FormRef):void{
						_formRef = formRef;
						format.refFormId = _formRef.id;
						_formEntity.format = format;
						_editor.editValue = _formRef.label;
					}
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
	}
}