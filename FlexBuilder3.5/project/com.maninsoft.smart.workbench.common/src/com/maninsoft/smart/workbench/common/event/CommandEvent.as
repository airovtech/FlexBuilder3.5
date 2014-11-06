package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;
	
	public class CommandEvent extends Event
	{
		public static const EXECUTE_COMMAND:String = "executeCommand";
		public static const UNDO_COMMAND:String = "undoCommand";
		public static const REDO_COMMAND:String = "redoCommand";
		
		public function CommandEvent(type:String, debugStr:String = null){
			super(type);
			this.debugStr = debugStr;
		}
		
		public var debugStr:String;

	}
}