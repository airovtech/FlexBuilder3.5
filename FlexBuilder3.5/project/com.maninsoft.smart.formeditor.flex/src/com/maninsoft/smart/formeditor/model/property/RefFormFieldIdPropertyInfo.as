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
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.view.dialog.SelectRefFormFieldIdDialog;
	import com.maninsoft.smart.workbench.common.assets.PropertyIconLibrary;
	import com.maninsoft.smart.workbench.common.property.ButtonPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertyEditor;
	import com.maninsoft.smart.workbench.common.property.IPropertySource;
	import com.maninsoft.smart.workbench.common.property.PropertyInfo;
	
	import flash.geom.Point;
	import mx.controls.Alert;
	
	/**
	 * TaskApplication 의 formId
	 */
	public class RefFormFieldIdPropertyInfo extends PropertyInfo {
		
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _editor: ButtonPropertyEditor;
		private var _formEntity: FormEntity;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------
		
		/** Constructor */
		public function RefFormFieldIdPropertyInfo(id: String, displayName: String, 
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
			_formEntity = source as FormEntity;
			
			if(!_editor) {
				_editor = new ButtonPropertyEditor();
				_editor.clickHandler = doEditorClick;
				_editor.buttonIcon = PropertyIconLibrary.refFormIdIcon;				
				_editor.dialogButton.toolTip = resourceManager.getString("FormEditorETC", "refFormFieldIdSelectTTip");
			}

			if(_formEntity.format.refFormFieldName)
				_editor.data = _formEntity.format.refFormFieldName;
			else
				_editor.data = FormEntity.EMPTY_FORM_FIELDNAME; 			
			return _editor;
		}

		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		private function doEditorClick(editor: ButtonPropertyEditor): void {
			var position:Point = _editor.localToGlobal(new Point(0, _editor.height+1));
			var fieldId:String = _formEntity.format.refFormFieldId ? _formEntity.format.refFormFieldId : FormEntity.EMPTY_FORM_FIELDID
			SelectRefFormFieldIdDialog.execute(_formEntity, fieldId, doAccept, position, _editor.width);
		}

		private function doAccept(item: Object): void {
			var format: FormFormatInfo = _formEntity.format.clone();
			if(item is FormEntity){
				var formField:FormEntity = item as FormEntity;
				format.refFormFieldId = formField.id;
				format.refFormFieldName = formField.name;
				format.refFormFieldType = formField.format.type;
				_formEntity.format = format;
				_editor.editValue = formField.name;
			}else{
				format.refFormFieldId = null;
				format.refFormFieldName = null;
				format.refFormFieldType = null;
				_formEntity.format = format;
				_editor.editValue = FormEntity.EMPTY_FORM_FIELDNAME;
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