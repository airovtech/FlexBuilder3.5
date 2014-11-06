package com.maninsoft.smart.modeler.xpdl.utils
{
	import flash.events.Event;
	
	public class XPDLEditorEvent extends Event
	{
		public static const OK:String = "ok";
		public var value:Object;
		
		public function XPDLEditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}