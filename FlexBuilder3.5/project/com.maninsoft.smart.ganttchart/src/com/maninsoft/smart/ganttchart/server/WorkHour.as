package com.maninsoft.smart.ganttchart.server
{
	import com.maninsoft.smart.modeler.common.ObjectBase;

	public class WorkHour extends ObjectBase
	{
		public var start: int;		//분단위 시작시간 
		public var end: int;		//분단위 종료시간
		public var workTime: int;	//분단위 업무시간
		private const hourUnit:Number = 60;
		
		public function WorkHour(start: int=0, end: int=0, workTime: int=0){
			super();
			this.start = start;
			this.end = end;
			this.workTime = workTime;
		}
		
		public function get startInHour(): Number{
			return start/hourUnit;
		}

		public function get endInHour(): Number{
			return end/hourUnit;
		}
		
		public function get workTimeInHour(): Number{
			return workTime/hourUnit;
		}		
	}
}