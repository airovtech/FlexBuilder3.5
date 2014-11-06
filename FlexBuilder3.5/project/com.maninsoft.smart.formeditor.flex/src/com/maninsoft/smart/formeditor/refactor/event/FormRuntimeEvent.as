package com.maninsoft.smart.formeditor.refactor.event
{
	import flash.events.Event;
	
	public class FormRuntimeEvent extends Event
	{
		public static const TYPE_WORKITEM_EXECUTE:String = "formExecute";
		public static const CHANGE_FIELD_DATA:String = "changeFieldData";
		
		public function FormRuntimeEvent(type:String){
			super(type);
		}
		
		public var formFieldId:String;
	}
}