package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class PageViewEvent extends Event
	{
		public static const SELECTITEM:String = "selectItem";
		public var selectItem:Object;
		
		public static const SELECTPAGE:String = "selectPage";
		public var pageNo:int;
				
		public function PageViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			var event:PageViewEvent = new PageViewEvent(type, bubbles, cancelable);
			event.selectItem = selectItem;
			event.pageNo = pageNo;
			return event;
		}
	}
}