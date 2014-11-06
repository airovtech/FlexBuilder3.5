package com.maninsoft.smart.workbench.event
{
	import flash.events.Event;

	public class MISLoadCallbackEvent extends Event
	{
		public var contentHeight:Number=0;
		
		public function MISLoadCallbackEvent(type:String, contentHeight:Number)
		{
			super(type);
			this.contentHeight = contentHeight;
		}
	}
}