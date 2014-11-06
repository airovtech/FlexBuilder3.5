package com.maninsoft.smart.modeler.toolTipMenu.event
{
	import flash.events.Event;

	public class ToolTipMenuEvent extends Event
	{
		public static var PROPERTY:String = "property";
		public static var RENAME:String = "rename";
		public static var REMOVE:String = "remove";
		public static var ACTIVITYADD:String = "activityAdd";
		public static var DEPTADD:String = "deptAdd";
		public static var PROCESSCREATE:String = "processCreate";
		public static var FORMADD:String = "formAdd";
		public static var EDITOR:String = "editor";
		public static var CHECKIN:String = "checkIn";
		public static var CHECKOUT:String = "checkOut";
		
		public function ToolTipMenuEvent(type:String){
			super(type);
		}
		
		 override public function clone() :Event {
            return new ToolTipMenuEvent(type);
        }
	}
}