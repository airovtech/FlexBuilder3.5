package com.maninsoft.smart.formeditor.refactor.edit.part
{
	import com.maninsoft.smart.formeditor.property.IFormItemPropertyView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	public class FormItemEditorEditPart
	{
		public var editDomain:FormEditDomain;
		public var formItemEditor:IFormItemPropertyView;
		
		private var _formEntityModel:FormEntity;
		
		public function set formEntityModel(formEntityModel:FormEntity):void{
			if(this._formEntityModel != null){
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, propertyChange);
			}
			this._formEntityModel = formEntityModel;
			
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, propertyChange);
		}
		
		public function get formEntityModel():FormEntity{
			return this._formEntityModel;
		}
		
		public function propertyChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
				this.formItemEditor.refreshVisual();	
			}			
		}

	}
}