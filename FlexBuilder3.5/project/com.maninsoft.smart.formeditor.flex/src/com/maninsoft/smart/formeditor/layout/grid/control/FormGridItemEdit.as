package com.maninsoft.smart.formeditor.layout.grid.control
{
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridCell;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridItemView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	
	public class FormGridItemEdit
	{
		public function FormGridItemEdit()
		{
		}
		public var editDomain:FormEditDomain;
		public var formGridItemView:FormGridItemView;
		
		public var _formGridCell:FormGridCell;
		
		public function set formGridCell(formGridCell:FormGridCell):void{
			if(formGridCell != null) {
				if (this._formGridCell != null) {
					this._formGridCell.removeEventListener(FormLayoutEvent.UPDATE_LAYOUT_INFO, propertyChange);
					this._formGridCell.removeEventListener(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE, structureChange);
					this._formGridCell.removeEventListener(FormEditorEvent.SELECT, selectChange);
					this._formGridCell.removeEventListener(FormEditorEvent.UNSELECT, unSelectChange);
				}
				
				if (this._formGridCell != formGridCell) {
					this._formGridCell = formGridCell;
					
					this._formGridCell.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_INFO, propertyChange);
					this._formGridCell.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE, structureChange);
					this._formGridCell.addEventListener(FormEditorEvent.SELECT, selectChange);
					this._formGridCell.addEventListener(FormEditorEvent.UNSELECT, unSelectChange);
				}
			}
		}
		
		public function get formGridCell():FormGridCell{
			return this._formGridCell;
		}
		
		public function propertyChange(event:FormLayoutEvent):void{
			if(event.target == this.formGridCell){
				this.formGridItemView.refreshVisual();	
			}			
		}
		
		public function structureChange(propertyChangeEvent:FormLayoutEvent):void{
			if(propertyChangeEvent.target == this.formGridCell){
				this.formGridItemView.refreshVisual();		
			}			
		}
		
		public function columnChange(propertyChangeEvent:FormLayoutEvent):void{
			this.formGridItemView.refreshVisual();			
		}
		
		public function selectChange(event:FormEditorEvent):void {
			if (event.target == this.formGridCell && event.type == FormEditorEvent.SELECT)
				this.formGridItemView.select();
		}
		
		public function unSelectChange(event:FormEditorEvent):void {
			if (event.target == this.formGridCell)
				this.formGridItemView.unSelect();
		}
	}
}