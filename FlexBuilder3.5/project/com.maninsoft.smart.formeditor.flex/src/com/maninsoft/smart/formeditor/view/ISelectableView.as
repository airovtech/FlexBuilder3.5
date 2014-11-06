package com.maninsoft.smart.formeditor.view
{
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	
	public interface ISelectableView extends IGraphicalView
	{
		function set selection(selection:Boolean):void;
		function get selection():Boolean;
		
		function get selectableModel():ISelectableModel;
	}
}