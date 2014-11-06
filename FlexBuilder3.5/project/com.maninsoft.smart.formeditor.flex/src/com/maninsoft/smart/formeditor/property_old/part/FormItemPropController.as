package com.maninsoft.smart.formeditor.property.part
{
	import com.maninsoft.smart.formeditor.property.IFormPropertyEditor;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	public class FormItemPropController
	{

		public var editDomain:FormEditDomain;
		public var formView:IFormPropertyEditor;
		
		private var _formEntityModel:FormEntity;
		
		public function get formEntityModel():FormEntity{
			return this._formEntityModel;
		}
		public function set formEntityModel(formEntityModel:FormEntity):void{
			if (this._formEntityModel != null) {
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
			}
			this._formEntityModel = formEntityModel;
			
			if (this._formEntityModel == null)
				return;
			
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
		}
		
		public function propertyChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
				this.formView.refreshVisual();	
			}			
		}
		
		public function structureChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
//				this.formView.formViewer.refreshVisual();
				this.formView.refreshVisual();	
			}			
		}
	}
}