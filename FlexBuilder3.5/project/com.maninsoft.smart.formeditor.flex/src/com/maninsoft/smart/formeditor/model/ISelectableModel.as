package com.maninsoft.smart.formeditor.model
{
	import flash.events.IEventDispatcher;
	
	public interface ISelectableModel extends IGraphicalModel
	{
		function select(selection:Boolean = true):void;
//		function set selection(selection:Boolean):void;
//		function get selection():Boolean;
	}
}