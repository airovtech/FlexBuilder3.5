package com.maninsoft.smart.formeditor.layout.grid.control
{
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridRow;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridRowView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	
	public class FormGridRowEdit
	{
		public function FormGridRowEdit()
		{
		}
		
		public var editDomain:FormEditDomain;
		public var formGridRowView:FormGridRowView;
		
		public var _formGridRow:FormGridRow;
		
		public function set formGridRow(formGridRow:FormGridRow):void{
			this._formGridRow = formGridRow;
			
			if(this._formGridRow != null){
				this._formGridRow.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_INFO, propertyChange);
				this._formGridRow.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE, structureChange);				
			}
		}
		
		public function get formGridRow():FormGridRow{
			return this._formGridRow;
		}
		
		public function propertyChange(event:FormLayoutEvent):void{
			if(event.target == this.formGridRow){
				this.formGridRowView.refreshVisual();	
			}			
		}
		
		public function structureChange(propertyChangeEvent:FormLayoutEvent):void{
			if(propertyChangeEvent.target == this.formGridRow){
				this.formGridRowView.refreshVisual();		
			}			
		}
	}
}