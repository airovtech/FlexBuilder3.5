package com.maninsoft.smart.formeditor.model
{
	public class ArrayObject
	{
		public var id:String;
		public var name:String;
		
		public function ArrayObject(id:String, name:String){
			super();
			this.id = id;
			this.name = name;
		}
		
		public function get label():String{
			return this.name;
		}		
	}
}