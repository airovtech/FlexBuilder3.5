package com.maninsoft.smart.formeditor.refactor.simple.control
{
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.refactor.simple.view.mapping.FormMappingEditor;
	import  com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain
	
	public class FormMappingEditorController
	{
		public var editDomain:FormEditDomain;
		public var editor:FormMappingEditor;
		
		private var _formModel:FormDocument;
		
		public function set formModel(formModel:FormDocument):void{
			
			if(this._formModel != null){
				this._formModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
			}
			
			this._formModel = formModel;
			
			if(this._formModel != null){
				this._formModel.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);				
			}
		}
		
		public function get formModel():FormDocument{
			return this._formModel;
		}
		
		public function structureChange(propertyChangeEvent:FormPropertyEvent):void{
			if(propertyChangeEvent.target == this.formModel){
				this.editor.loadMappingFrag();	
			}			
		}

	}
}