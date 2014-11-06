package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;
	
	public class FormEditorEvent extends Event
	{
		public static const FORM_RENAME:String = "renameForm";
		public static const FORM_FIELD_RENAME:String = "renameFormField";
		public static const FORM_FIELD_ADD:String = "addFormField";
		public static const FORM_FIELD_REMOVE:String = "removeFormField";
		
		public function FormEditorEvent(type:String){
			super(type);
		}

		public var formId:String;
		public var formFieldId:String;
		
		public var newName:String;
	}
}