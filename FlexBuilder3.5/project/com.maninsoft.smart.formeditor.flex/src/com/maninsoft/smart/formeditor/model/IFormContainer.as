package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.layout.model.FormLayout;
	
	public interface IFormContainer extends IFormResource
	{
		function get layout():FormLayout;
		function set layout(layout:FormLayout):void;
		function get layoutType():String;
		function set layoutType(layoutType:String):void;
		
		function addField(child:FormEntity, index:int = -1):void;
		function removeField(child:FormEntity):void;
		function getFieldAt(index:int):FormEntity;
		
		function get length():int;
		function contain(child:FormEntity):Boolean;
	}
}