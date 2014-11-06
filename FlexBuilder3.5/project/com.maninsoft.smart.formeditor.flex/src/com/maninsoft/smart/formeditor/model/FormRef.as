package com.maninsoft.smart.formeditor.model
{
	public class FormRef
	{
		public var id:String;
		public var name:String;
		public var categoryName:String;
		public var groupName:String;
		public function get label():String{
			return categoryName + ">" + (groupName? groupName + ">" : "") + name; 
		}
	}
}