package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class PagingCallbackEvent extends Event
	{
		public static const PAGING_CALLBACK:String = "pagingCallback";
		
		public var totalPages:String;
		public var currentPage:String;
		
		public function PagingCallbackEvent(type:String, totalPages: String, currentPage: String)
		{
			super(type);
			this.totalPages = totalPages;
			this.currentPage = currentPage;
		}
	}
}