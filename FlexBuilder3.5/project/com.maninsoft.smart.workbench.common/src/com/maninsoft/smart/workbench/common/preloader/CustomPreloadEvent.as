package com.maninsoft.smart.workbench.common.preloader
{
	import flash.events.Event;

	public class CustomPreloadEvent extends Event
	{
		public static const OPEN_PROGRESS_IMG:String = "openProgressImg";
		public static const CLOSE_PROGRESS_IMG:String = "closeProgressImg";
		public static const SAVE_PROGRESS_IMG:String = "saveProgressImg";
		
		public function CustomPreloadEvent(type:String = "openProgressImg", bubbles:Boolean = false)
		{
			super(type);
		}
	}
}