package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class LoadCallbackEvent extends Event
	{
		public static const LOAD_CALLBACK:String = "loadCallback";
		public static const STAGENAME_FORM:String = "formEditorStage";
		public static const STAGENAME_PROCESS:String = "processEditorStage";
		public static const STAGENAME_GANTT:String = "ganttChartStage";
		
		public var stageName:String;
		public var contentHeight:Number=0;
		
		public function LoadCallbackEvent(type:String, stageName:String, contentHeight:Number)
		{
			super(type);
			this.stageName = stageName;
			this.contentHeight = contentHeight;
		}
	}
}