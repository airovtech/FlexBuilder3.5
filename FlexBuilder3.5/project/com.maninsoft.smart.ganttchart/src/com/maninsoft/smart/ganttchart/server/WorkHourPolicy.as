package com.maninsoft.smart.ganttchart.server
{
	import com.maninsoft.smart.modeler.common.ObjectBase;

	public class WorkHourPolicy extends ObjectBase
	{
		public static const DEFAULT_WORKHOURS: Array = new Array(new WorkHour(0, 0, 0),
														new WorkHour(9*60, 18*60, 9*60),
														new WorkHour(9*60, 18*60, 9*60),
														new WorkHour(9*60, 18*60, 9*60),
														new WorkHour(9*60, 18*60, 9*60),
														new WorkHour(9*60, 18*60, 9*60),
														new WorkHour(0, 0, 0));		

		public var startDayOfWeek: int=CalendarInfo.DAY_SUNDAY;
		public var workingDays: int=5;
		public var validFrom: Date = new Date(0);
		public var validTo: Date;
		private var _workHours: Array = DEFAULT_WORKHOURS;
		
		public function WorkHourPolicy(){
			super();
		}
		
		public function get workHours(): Array{
			return _workHours;
		}
		public function set workHours(value: Array): void{
			if(value && value.length != CalendarInfo.DAYS_OF_WEEK)
				_workHours = DEFAULT_WORKHOURS;
			else
				_workHours = value;
		}
	}
}