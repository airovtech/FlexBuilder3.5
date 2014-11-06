package com.maninsoft.smart.formeditor.property.part
{
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.property.IFormPropertyEditor;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	
	public class FormCommonPropController
	{
		public var editDomain:FormEditDomain;
		private var _selectModel:ISelectableModel;
		public var formView:IFormPropertyEditor;
		
		public function get selectModel():ISelectableModel{
			return this._selectModel;
		}
		public function set selectModel(selectModel:ISelectableModel):void{
			if(this._selectModel != null){
				this._selectModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
				this._selectModel.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
			}
			this._selectModel = selectModel;
			
			this._selectModel.addEventListener(FormPropertyEvent.UPDATE_FORM_INFO, propertyChange);
			this._selectModel.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, structureChange);
		}
		
		public function propertyChange(event:FormPropertyEvent):void{
			if(event.target == this.selectModel){
				this.formView.refreshVisual();	
			}			
		}
		public function structureChange(event:FormPropertyEvent):void{
			if(event.target == this.selectModel){
//				this.formView.formViewer.refreshVisual();
				this.formView.refreshVisual();	
			}			
		}
	}
}