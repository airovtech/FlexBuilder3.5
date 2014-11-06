package com.maninsoft.smart.formeditor.controller
{
	import com.maninsoft.smart.formeditor.model.IGraphicalModel;
	import com.maninsoft.smart.formeditor.refactor.event.FormPropertyEvent;
	import com.maninsoft.smart.formeditor.view.FieldView;
	import com.maninsoft.smart.formeditor.view.IGraphicalView;
	
	public class GraphicalController
	{
		private var _model:IGraphicalModel;
		public var view:IGraphicalView;
		
		public function GraphicalController()
		{
			super();
		}
		
		public function get model():IGraphicalModel{
			return this._model;
		}
		public function set model(model:IGraphicalModel):void{
			if(this._model != null){
				this._model.removeEventListener(FormPropertyEvent.UPDATE_FORM_INFO, checkAndRefreshView);
				this._model.removeEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, checkAndRefreshView);
			}
			this._model = model;
			if(this._model != null){
				this._model.addEventListener(FormPropertyEvent.UPDATE_FORM_INFO, checkAndRefreshView);
				this._model.addEventListener(FormPropertyEvent.UPDATE_FORM_STRUCTURE, checkAndRefreshView);
			}
		}
		
		private function checkAndRefreshView(event:FormPropertyEvent):void {
			if (this.view == null || event.target != this.model)
				return;
			this.view.refreshVisual();
			if(event.type == FormPropertyEvent.UPDATE_FORM_STRUCTURE && this.view is FieldView){
				FieldView(this.view).refreshPropertyPage();
			}
		}
	}
}