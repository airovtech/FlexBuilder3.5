package com.maninsoft.smart.ganttchart.server
{
	import com.maninsoft.smart.modeler.common.ObjectBase;

	public class Holiday extends ObjectBase
	{

		public var name: String;
		public var description: String;
		public var startDay: Date;
		public var endDay: Date;

		public function Holiday(name: String=null, description: String=null, startDay: Date=null, endDay: Date=null)
		{
			super();
			this.name = name;
			this.description = description;
			this.startDay = startDay;
			this.endDay = endDay; 
		}
		
		public function get label(): String{
			if(this.name)
				return this.name;
			return "";
		}
	}
}