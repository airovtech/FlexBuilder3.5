package com.maninsoft.smart.formeditor.model.type
{
	public class FormatType
	{
		public var icon:Class;
		public var label:String;
		[Bindable]
		public var type:String;
		
		public var labelWidth:int;
		public var contentWidth:int;
		public var height:int;
		
		public var weight:int;
		
		public var id:int;
		
		public var className:String;
		public var formatClass:Class;
		
		public var systemType:String;
		
		public function FormatType(icon:Class, label:String, type:String, id:int, formatClass:Class, systemType:String = "string", labelWidth:int = 100, contentWidth:int = 500, height:int = 25, weight:int = 1){
			this.icon = icon;
			this.label = label;
			this.type = type;
			
			this.id = id;
			
//			this.className = className;
			this.formatClass = formatClass;
			
			this.systemType = systemType;
			
			this.labelWidth = labelWidth;
			this.contentWidth = contentWidth;
			this.height = height;
			
			this.weight = weight;
		}
	}
}