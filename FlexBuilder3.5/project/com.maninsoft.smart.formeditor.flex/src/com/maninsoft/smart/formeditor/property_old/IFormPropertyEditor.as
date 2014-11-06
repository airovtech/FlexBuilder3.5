package com.maninsoft.smart.formeditor.property
{
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	import com.maninsoft.smart.formeditor.view.IGraphicalView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	
	public interface IFormPropertyEditor extends IGraphicalView
	{
		function set editDomain(editDomain:FormEditDomain):void;
		function get editDomain():FormEditDomain;
			
		function set selectModel(selectModel:ISelectableModel):void;
		function get selectModel():ISelectableModel;
	}
}