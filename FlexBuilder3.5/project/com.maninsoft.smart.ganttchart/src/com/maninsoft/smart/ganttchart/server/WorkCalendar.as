package com.maninsoft.smart.ganttchart.server
{
	import com.maninsoft.smart.ganttchart.editor.GanttChart;
	import com.maninsoft.smart.ganttchart.model.GanttChartGrid;
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.xpdl.server.User;

	public class WorkCalendar extends ObjectBase
	{
		private var _ganttChart:GanttChart;
		private var _holidays: Array = new Array(); 
		private var _eventDays: Array = new Array();
		private var _workHourPolicies: Array = new Array(new WorkHourPolicy());

		public function WorkCalendar(ganttChart:GanttChart)
		{
			super();
			_ganttChart = ganttChart;
		}
	
		public function get holidays(): Array{
			return _holidays;
		}
		public function set holidays(value: Array): void{
			_holidays = value;
		}
		
		public function get eventDays(): Array{
			return _eventDays;
		}
		public function set eventDays(value: Array): void{
			_eventDays = value;
		}
		
		public function get workHourPolicies(): Array{
			return _workHourPolicies;
		}
		public function set workHourPolicies(value: Array): void{
			_workHourPolicies = value;
		}

		public function get dayOff(): WorkHour{
			return new WorkHour(0, 0, 0);
		}
		
		public function getCalendarDay(date: Date): String{
			var calendarDay: String ="";
			if(_workHourPolicies && date){
				for each(var holiday: Holiday in holidays){
					if(holiday.startDay.time<=date.time && holiday.endDay.time>=date.time){
						calendarDay += " " + holiday.label;
					}
				}
				
				for each(var eventDay: EventDay in eventDays){
					if(eventDay.startDay.time<=date.time && eventDay.endDay.time>=date.time){
						calendarDay += " " + eventDay.label;
					}
				}
			}
			return calendarDay;
			
		}

		public function getWorkHour(date: Date): WorkHour{
			if(_workHourPolicies && date){
				for each(var holiday: Holiday in holidays){
					if(holiday.startDay.time<=date.time && holiday.endDay.time>=date.time){
						return dayOff;
					}
				}
				
				for each(var eventDay: EventDay in eventDays){
					if(eventDay.isHoliday && eventDay.startDay.time<=date.time && eventDay.endDay.time>=date.time){
						return dayOff;
					}
				}
				
				var myWorkHourPolicy:WorkHourPolicy = workHourPolicies[0];
				for each(var workHourPolicy: WorkHourPolicy in workHourPolicies){
					if(workHourPolicy.validFrom && workHourPolicy.validFrom.time<=date.time){
						if(workHourPolicy.validFrom.time>myWorkHourPolicy.validFrom.time) myWorkHourPolicy = workHourPolicy;
					}
				}
				
				if(myWorkHourPolicy && myWorkHourPolicy.workHours && myWorkHourPolicy.workHours.length>date.getDay()){
					return myWorkHourPolicy.workHours[date.getDay()];
				}
			}
			return dayOff;
		}
		
		public function isWorkHour(date: Date): Boolean{
			var workHour: WorkHour = getWorkHour(date);
			if(workHour.workTime==0)
				return false;
			else if(workHour && workHour.start<=getTimeByMinute(date) && workHour.end>=getTimeByMinute(date))
				return true;
			return false;
		}
		
		public function isWorkDay(date: Date): Boolean{
			var workHour: WorkHour = getWorkHour(date);
			if(workHour && workHour.workTime>0)
				return true;
			return false;
		}
				
		public function getEndOfThisWeek(date: Date): Date{
			if(date){
				var day: int=date.getDay();
				return new Date(date.time+(CalendarInfo.DAYS_OF_WEEK-(day+1))*24*60*60*1000);
			}
			
			return null;
		}
		
		public function fullDayToString(date:Date): String{
			return CalendarInfo.fullDayToString(date, GanttChartGrid.DEPLOY_MODE);			

		}
		
		public function fullDayToStringShort(date:Date): String{
			return CalendarInfo.fullDayToStringShort(date, GanttChartGrid.DEPLOY_MODE);
		
		}

		public function fullDayToDateShort(dateString:String): Date{
			return CalendarInfo.fullDayToDateShort(dateString, GanttChartGrid.DEPLOY_MODE);
		}

		public function fullMonthToString(date:Date): String{
			return CalendarInfo.fullMonthToString(date, GanttChartGrid.DEPLOY_MODE);
			
		}
		
		public function fullYearToString(date:Date): String{
			return CalendarInfo.fullYearToString(date, GanttChartGrid.DEPLOY_MODE);
			
		}
		
		public function dateDayToString(date: Date): String{
			return CalendarInfo.dateDayToString(date);
			
		}

		public function hourToString(hour: int): String{
			return CalendarInfo.hourToString(hour);
			
		}

		public function hourToStringShort(hour: int): String{
			return CalendarInfo.hourToStringShort(hour);
			
		}
		
		public function dayToString(day: int): String{
			return CalendarInfo.dateToString(day);
			
		}

		public function dayToStringShort(day: int): String{
			return CalendarInfo.dateToStringShort(day);

		}
		
		public function dateToString(date: int): String{
			return CalendarInfo.dateToString(date);

		}

		public function dateToStringShort(date: int): String{
			return CalendarInfo.dateToStringShort(date);

		}

		public function monthToString(month: int): String{
			return CalendarInfo.monthToString(month);

		}

		public function monthToStringShort(month: int): String{
			return CalendarInfo.monthToStringShort(month);

		}

		public function quarterToString(quarter: int): String{
			return CalendarInfo.quarterToString(quarter);
			
		}

		public function quarterToStringShort(quarter: int): String{
			return CalendarInfo.quarterToStringShort(quarter);
			
		}

		internal function getTimeByMinute(date: Date): int{
			return date.getHours()*60+date.getMinutes();
		}
	}
}