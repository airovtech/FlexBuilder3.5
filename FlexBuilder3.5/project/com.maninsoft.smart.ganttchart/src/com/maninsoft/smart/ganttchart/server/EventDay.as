package com.maninsoft.smart.ganttchart.server
{
	import com.maninsoft.smart.modeler.common.ObjectBase;
	import com.maninsoft.smart.modeler.xpdl.server.User;

	public class EventDay extends ObjectBase
	{

		public var name: String;
		public var description: String;
		public var isHoliday: Boolean;
		public var startDay: Date;
		public var endDay: Date;
		public var persons: Array;

		public function EventDay(name: String=null, description: String=null, isHoliday: Boolean=false, startDay: Date=null, endDay: Date=null, persons: Array=null)
		{
			super();
			this.name = name;
			this.description = description;
			this.isHoliday = isHoliday;
			this.startDay = startDay;
			this.endDay = endDay;
			this.persons = persons;
		}
		public function get label(): String{
			if(this.name)
				 return this.name;
			return "";
		}
	}
}