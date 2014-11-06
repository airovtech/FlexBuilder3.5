package com.maninsoft.smart.workbench.event.service
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	
	import flash.events.Event;
	
	public class RepositoryServiceEvent extends Event
	{
		public static const RETRIEVE:String = "savePackage";
		public static const SAVE:String = "savePackage";
		
		public static const FAIL:String = "failPackage";
		
		public function RepositoryServiceEvent(type:String)
		{
			super(type);
		}

		public var swPack:SWPackage;
		
		public var msg:String;
	}
}