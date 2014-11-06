package com.maninsoft.smart.formeditor.refactor.simple.control
{
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.refactor.simple.view.form.FormItemViewer;
	import  com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain
	
	public class SubFormItemController
	{
		public var editDomain:FormEditDomain;
		public var formItemViewer:FormItemViewer;
		
		private var _formEntityModel:FormEntity;
		
		public function set formEntityModel(formEntityModel:FormEntity):void{
			if(this._formEntityModel != null){
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
				this._formEntityModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
			}
			this._formEntityModel = formEntityModel;
			
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
			this._formEntityModel.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
		}
		
		public function get formEntityModel():FormEntity{
			return this._formEntityModel;
		}
		
		public function propertyChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
				this.formItemViewer.refreshVisual();	
			}			
		}
		
		public function structureChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
				this.formItemViewer.refreshVisual();
//				this.formItemViewer.refreshVisual();	
			}			
		}

	}
}