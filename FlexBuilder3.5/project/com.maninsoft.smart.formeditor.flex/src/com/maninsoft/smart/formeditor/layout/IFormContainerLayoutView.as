package com.maninsoft.smart.formeditor.layout
{
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.formeditor.layout.grid.ISelectableContainerView;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	
	public interface IFormContainerLayoutView extends ISelectableContainerView
	{
		function get container():IFormContainer;
		function set container(container:IFormContainer):void;
		
		function set editDomain(editDomain:FormEditDomain):void;
		function get editDomain():FormEditDomain;
		
		function set formView(formView:IFormContainerView):void;
		function get formView():IFormContainerView;
		
		function set mode(mode:String):void;
		function get mode():String;
	}
}