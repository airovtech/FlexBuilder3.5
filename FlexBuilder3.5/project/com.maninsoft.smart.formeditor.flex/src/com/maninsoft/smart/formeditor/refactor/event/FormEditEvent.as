package com.maninsoft.smart.formeditor.refactor.event
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.model.FormEntity;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class FormEditEvent extends Event
	{
		public static const SELECT_FORM_ITEM:String = "selectFormItem";
		public static const SELECT_FORM_ITEMS:String = "selectFormItems";
		public static const SELECT_FORM_DOCUMENT:String = "selectFormDocument";
		
		public static const LOAD_FORM_DOCUMENT:String = "loadFormDocument";
		
		public static const OPEN_PROP_FORM_ITEM:String = "openPropFormItem";
		public static const OPEN_PROP_FORM_DOCUMENT:String = "openPropFormDocument";
		
		public function FormEditEvent(type:String){
			super(type);
		}
		
		public var formItem:FormEntity;
		public var formItems:ArrayCollection = new ArrayCollection();
		
		public var formDocument:FormDocument
//		public var selectionFormEntityViewers:ArrayCollection = new ArrayCollection();
	}
}