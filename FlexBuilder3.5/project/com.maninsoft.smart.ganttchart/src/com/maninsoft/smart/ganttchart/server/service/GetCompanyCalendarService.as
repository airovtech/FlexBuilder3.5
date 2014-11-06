////////////////////////////////////////////////////////////////////////////////
//  GetAllUsersService.as
//  2008.04.08, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.ganttchart.server.service
{
	import com.maninsoft.smart.ganttchart.server.EventDay;
	import com.maninsoft.smart.ganttchart.server.Holiday;
	import com.maninsoft.smart.ganttchart.server.WorkCalendar;
	import com.maninsoft.smart.ganttchart.server.WorkHour;
	import com.maninsoft.smart.ganttchart.server.WorkHourPolicy;
	import com.maninsoft.smart.ganttchart.util.CalendarUtil;
	import com.maninsoft.smart.modeler.xpdl.server.User;
	import com.maninsoft.smart.modeler.xpdl.server.service.ServiceBase;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 모든 사용자를 가져오는 서비스
	 */
	public class GetCompanyCalendarService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var fromDay: String;
		public var toDay: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _workCalendar: WorkCalendar;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetCompanyCalendarService(workCalendar:WorkCalendar, fromDay:Date=null, toDay:Date=null) {
			super("getWorkCalendar");
			_workCalendar = workCalendar;
			if(fromDay)
				this.fromDay = CalendarUtil.dateToStringYYYYmmDD(fromDay);
			if(toDay)
				this.toDay = CalendarUtil.dateToStringYYYYmmDD(toDay);
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * users
		 */
		public function get workCalendar(): WorkCalendar{
			return _workCalendar;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.CompId 	= compId;
			obj.userId = userId;
			obj.FromDay= fromDay;
			obj.ToDay	= toDay;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			
			_workCalendar.holidays = [];			
			_workCalendar.eventDays = [];
			for each (var eventDayXML: XML in xml.Eventdays.eventday) {
				if(eventDayXML.@type == 1){
					var holiday: Holiday = new Holiday();				
					holiday.name		= eventDayXML.@name;
					holiday.description	= eventDayXML.description;
					holiday.startDay	= CalendarUtil.getWorkDay(eventDayXML.@startDay);
					holiday.endDay		= CalendarUtil.getWorkDay(eventDayXML.@endDay);
					_workCalendar.holidays.push(holiday);	
				}else if(eventDayXML.@type == 2){
					var eventDay: EventDay = new EventDay();				
					eventDay.name		= eventDayXML.@name;
					eventDay.description= eventDayXML.description;
					eventDay.isHoliday	= false;
					eventDay.startDay	= CalendarUtil.getWorkDay(eventDayXML.@startDay);
					eventDay.endDay		= CalendarUtil.getWorkDay(eventDayXML.@endDay);
					eventDay.persons = [];
					var index:int=-1, pos:int=0;
					var reltdPerson:String = eventDayXML.@reltdPerson;
					index = reltdPerson.indexOf(";", pos);
					while(index!=-1){						 
						var person: User = new User();
						person.id		= reltdPerson.substring(pos,index);;
						eventDay.persons.push(person);
						pos = index+1;
						reltdPerson = reltdPerson.substring(pos, reltdPerson.length-1);
						index = reltdPerson.indexOf(";", pos); 	
					}
					_workCalendar.eventDays.push(eventDay);
				}
			}
			
			_workCalendar.workHourPolicies = [];
			_workCalendar.workHourPolicies.push(new WorkHourPolicy);
			var startTime:Date, endTime:Date, workHour:WorkHour;
			for each (var workHourPolicyXML: XML in xml.WorkHours.workhour) {
				var workHourPolicy: WorkHourPolicy = new WorkHourPolicy();	
				workHourPolicy.startDayOfWeek 	= parseInt(workHourPolicyXML.@startDayOfWeek)-1;
				workHourPolicy.workingDays 		= workHourPolicyXML.@workingDays;
				workHourPolicy.validFrom 		= CalendarUtil.getWorkDay(workHourPolicyXML.@validFromDate);
				
				var workHourArray:Array = [];
				function addToWorkHourArray(startTime:Date, endTime:Date):void{
					workHour = new WorkHour();
					if(startTime) workHour.start = startTime.getHours()*60+startTime.getMinutes();
					if(endTime) workHour.end = endTime.getHours()*60+endTime.getMinutes();
					workHour.workTime = workHour.end-workHour.start;
					workHourArray.push(workHour);
				}
								
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@sunStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@sunEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@monStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@monEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@tueStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@tueEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@wedStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@wedEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@thuStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@thuEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@friStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@friEndTime);
				addToWorkHourArray(startTime, endTime);
				
				startTime = CalendarUtil.getTaskDate(workHourPolicyXML.@satStartTime);
				endTime = CalendarUtil.getTaskDate(workHourPolicyXML.@satEndTime);
				addToWorkHourArray(startTime, endTime);
								
				workHourPolicy.workHours = workHourArray;
				_workCalendar.workHourPolicies.push(workHourPolicy);	
			}

			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetCompanyCalendarService: " + event);
			
			super.doFault(event);
		}
	}
}