package com.maninsoft.smart.formeditor.model
{
	import com.maninsoft.smart.formeditor.model.ISelectableModel;
	
	public interface IFormResource extends ISelectableModel
	{
		function get id():String;
		function set id(id:String):void;

		function set name(name:String):void;		
		function get name():String;
		
		function get icon():Class;
		
		function set root(root:FormDocument):void;
		function get root():FormDocument;
	}
}