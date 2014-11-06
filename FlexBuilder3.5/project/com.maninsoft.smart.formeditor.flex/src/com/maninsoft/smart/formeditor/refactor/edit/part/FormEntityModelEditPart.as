package com.maninsoft.smart.formeditor.refactor.edit.part
{
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	import com.maninsoft.smart.formeditor.refactor.view.form.FormEntityModelEditPartViewer;
	import  com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain
	
	public class FormEntityModelEditPart 
	{
		public var editDomain:FormEditDomain;
		public var formEntityEditPartViewer:FormEntityModelEditPartViewer;
		
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
				this.formEntityEditPartViewer.refreshBasicVisual();	
			}			
		}
		
		public function structureChange(event:FormPropertyEvent):void{
			if(event.target == this.formEntityModel){
				this.formEntityEditPartViewer.refreshVisual();	
			}			
		}

	}
}