package com.maninsoft.smart.formeditor.layout.grid.control
{
	import com.maninsoft.smart.formeditor.layout.event.FormLayoutEvent;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridColumn;
	import com.maninsoft.smart.formeditor.layout.grid.model.FormGridLayout;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridContainer;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.util.FormEditorEvent;
	
	public class FormGridContainerEdit
	{
		public function FormGridContainerEdit()
		{
		}
		public var editDomain:FormEditDomain;
		public var formGridContainer:FormGridContainer;
		
		public var _formGridLayout:FormGridLayout;
		
		public function set formGridLayout(formGridLayout:FormGridLayout):void{
			this._formGridLayout = formGridLayout;
			
			if(this._formGridLayout != null){
				this._formGridLayout.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_INFO, propertyChange);
				this._formGridLayout.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE, structureChange);	
				this._formGridLayout.addEventListener(FormEditorEvent.SELECT, selectChange);
				this._formGridLayout.addEventListener(FormEditorEvent.UNSELECT, unSelectChange);		
			}
		}
		
		
		public function registerColumn():void{
			if(this._formGridLayout != null){
				if(this._formGridLayout.columnLength > 0){
					for(var i:int = 0 ; i < this._formGridLayout.columnLength ; i++){
						var gridCol:FormGridColumn = this._formGridLayout.getColumnByIndex(i);
						gridCol.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_INFO, columnChange);
						gridCol.addEventListener(FormLayoutEvent.UPDATE_LAYOUT_STRUCTURE, columnChange);
					}
				}	
			}
		}
		
		public function get formGridLayout():FormGridLayout{
			return this._formGridLayout;
		}
		
		public function propertyChange(event:FormLayoutEvent):void{
			if(event.target == this.formGridLayout){
				this.formGridContainer.refreshVisual();	
			}			
		}
		
		public function structureChange(propertyChangeEvent:FormLayoutEvent):void{
			if(propertyChangeEvent.target == this.formGridLayout){
				this.formGridContainer.refreshVisual();		
			}			
		}
		
		public function columnChange(propertyChangeEvent:FormLayoutEvent):void{
			this.formGridContainer.refreshVisual();				
		}
		
		public function selectChange(event:FormEditorEvent):void {
			if (event.target == this.formGridLayout)
				this.formGridContainer.select();
		}
		
		public function unSelectChange(event:FormEditorEvent):void {
			if (event.target == this.formGridLayout)
				this.formGridContainer.unSelect();
		}
	}
}