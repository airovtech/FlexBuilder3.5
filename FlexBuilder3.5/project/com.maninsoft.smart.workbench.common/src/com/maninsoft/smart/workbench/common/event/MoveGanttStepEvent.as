package com.maninsoft.smart.workbench.common.event
{
	import flash.events.Event;

	public class MoveGanttStepEvent extends Event
	{
		public static const MOVE_GANTTSTEP:String = "moveGanttStep";
		public static const GANTT_MOVE_LEFT:String = "MOVE_LEFT";
		public static const GANTT_MOVE_RIGHT:String = "MOVE_RIGHT";
		
		public var direction:String;
		
		public function MoveGanttStepEvent(type:String, direction: String){
			super(type);
			this.direction = direction;
		}
	}
}