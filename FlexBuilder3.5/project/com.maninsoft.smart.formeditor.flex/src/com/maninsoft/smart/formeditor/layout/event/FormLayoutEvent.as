package com.maninsoft.smart.formeditor.layout.event
{
	import flash.events.Event;
	
	public class FormLayoutEvent extends Event
	{
		public static const UPDATE_LAYOUT_INFO:String = "updateLayoutInfo";
		public static const UPDATE_LAYOUT_STRUCTURE:String = "updateLayoutStructure";
		
		public function FormLayoutEvent(type:String){
			super(type);
		}
	}
}