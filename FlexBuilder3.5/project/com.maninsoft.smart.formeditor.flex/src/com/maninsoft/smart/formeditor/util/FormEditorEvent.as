package com.maninsoft.smart.formeditor.util
{
	import com.maninsoft.smart.formeditor.model.FormRef;
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.view.ISelectableView;
	
	import flash.events.Event;

	public class FormEditorEvent extends Event
	{
		public static const SEARCH:String = "search";
		public var searchWord:String;
		
		public static const SELECTFORM:String = "selectForm";
		public var formRef:FormRef;
		
		public static const SELECTSERVICE:String = "selectService";
		public var systemServiceRef:SystemService;
		
		public static const SELECTPAGE:String = "selectPage";
		public var pageNo:int;
		
		public static const SELECTVIEW:String = "selectView";
		public static const UNSELECTVIEW:String = "unselectView";
		public var view:ISelectableView;
		public var x:Number = 0;
		public var y:Number = 0;
		
		public static const OK:String = "ok";
		public static const SELECT:String = "select";
		public static const UNSELECT:String = "unselect";
		public var model:Object;
		
		public function FormEditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var event:FormEditorEvent = new FormEditorEvent(type, bubbles, cancelable);
			event.searchWord = searchWord;
			event.formRef = formRef;
			event.systemServiceRef = systemServiceRef;
			event.pageNo = pageNo;
			event.model = model;
			return event;
		}
	}
}