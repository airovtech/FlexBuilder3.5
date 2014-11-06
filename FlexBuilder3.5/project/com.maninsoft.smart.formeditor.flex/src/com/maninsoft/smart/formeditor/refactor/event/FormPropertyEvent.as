package com.maninsoft.smart.formeditor.refactor.event
{
	import flash.events.Event;
	
	public class FormPropertyEvent extends Event
	{
		public static const UPDATE_FORM_INFO:String = "updateFormInfo";
		public static const UPDATE_FORM_STRUCTURE:String = "updateFormStructure";
		
		public function FormPropertyEvent(type:String){
			super(type);
		}
	}
}