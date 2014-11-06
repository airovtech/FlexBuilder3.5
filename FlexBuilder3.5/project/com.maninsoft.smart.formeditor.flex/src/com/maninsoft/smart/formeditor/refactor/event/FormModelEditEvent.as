package com.maninsoft.smart.formeditor.refactor.event
{
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class FormModelEditEvent extends Event
	{
//		public static const UPDATE_FORM_INFO:String = "updateFormInfo";
//		public static const UPDATE_FORM_STRUCTURE:String = "updateFormStructure";
		
		public function FormModelEditEvent(type:String){
			super(type);
		}
		
		public var formItem:FormEntity;
		public var formItems:ArrayCollection = new ArrayCollection();
	}
}