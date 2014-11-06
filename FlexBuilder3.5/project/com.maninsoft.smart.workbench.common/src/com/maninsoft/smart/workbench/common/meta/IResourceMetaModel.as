package com.maninsoft.smart.workbench.common.meta
{
	import flash.events.IEventDispatcher;
	
	public interface IResourceMetaModel extends IEventDispatcher
	{
		function get id():String;
		function set id(id:String):void;
		
		function get name():String;
		function set name(name:String):void;
		
		function get type():String;
		function set type(type:String):void;

		function get icon():Class;
		
		function toXML():XML;
	}
}