package com.maninsoft.smart.formeditor.view
{
	import com.maninsoft.smart.formeditor.view.ISelectableView;
	import com.maninsoft.smart.formeditor.layout.IFormContainerLayoutView;
	import com.maninsoft.smart.formeditor.model.IFormContainer;
	
	public interface IFormContainerView extends ISelectableView
	{
		function get formContainer():IFormContainer;

		function get layoutView():IFormContainerLayoutView;
		
		function refreshLayout():void;
	}
}