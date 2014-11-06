package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class DateCallbackEvent extends Event
	{
		public static const DATE_CALLBACK:String = "dateCallback";
		
		public var startDate:String;
		public var endDate:String;
		
		public function DateCallbackEvent(type:String, startDate: String, endDate: String)
		{
			super(type);
			this.startDate = startDate;
			this.endDate = endDate;
		}
	}
}