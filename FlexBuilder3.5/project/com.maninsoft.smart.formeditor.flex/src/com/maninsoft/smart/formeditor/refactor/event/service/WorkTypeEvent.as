package com.maninsoft.smart.formeditor.refactor.event.service
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWWorkType;
	
	public class WorkTypeEvent extends ServiceEvent
	{
		public static const SUCESS_SAVE:String = "sucessWorkTypeSave";
		public static const SUCESS_LOAD:String = "sucessWorkTypeLoad";
		
		public function WorkTypeEvent(type:String){
			super(type);
		}
		// 워크타입 정보
		public var swWorkType:SWWorkType;
	}
}