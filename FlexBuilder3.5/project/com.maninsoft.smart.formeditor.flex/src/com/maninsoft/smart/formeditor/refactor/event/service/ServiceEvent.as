package com.maninsoft.smart.formeditor.refactor.event.service
{
	import flash.events.Event;
	
	public class ServiceEvent extends Event
	{
		public static const FAIL:String = "failService";
		
		public function ServiceEvent(type:String){
			super(type);
		}
		
		// 메세지
		public var msg:String;
	}
}