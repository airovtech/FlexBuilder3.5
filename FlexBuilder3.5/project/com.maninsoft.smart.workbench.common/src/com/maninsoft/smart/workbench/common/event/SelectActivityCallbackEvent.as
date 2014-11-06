package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class SelectActivityCallbackEvent extends Event
	{
		public static const SELECT_ACTIVITY_CALLBACK:String = "selectActivityCallback";
		
		public var taskId: String;
		
		public function SelectActivityCallbackEvent(type:String, taskId: String)
		{
			super(type);
			this.taskId = taskId;
		}
	}
}