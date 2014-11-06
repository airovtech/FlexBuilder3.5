package com.maninsoft.smart.formeditor.layout
{
	import com.maninsoft.smart.formeditor.view.IFormContainerView;
	import com.maninsoft.smart.formeditor.layout.grid.view.FormGridCanvas;
	import com.maninsoft.smart.formeditor.layout.model.FormLayout;
	import com.maninsoft.smart.formeditor.refactor.editor.FormEditDomain;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	
	public class FormLayoutFactory
	{
		public function FormLayoutFactory()
		{
		}
	
		public static function getLayoutContainer(container:IFormContainer, editDomain:FormEditDomain, formView:IFormContainerView):IFormContainerLayoutView{
			if(container.layoutType == FormLayout.GRID){
	        		var layoutContatier:IFormContainerLayoutView = new FormGridCanvas(container, formView, editDomain);
	        		return layoutContatier;
	        }
	        // auto 반환
	        return null;
		}
	}
}