package com.maninsoft.smart.workbench.event
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWGanttProcess;
	
	import flash.events.Event;
	
	public dynamic class MISGanttProcessEvent extends Event
	{
		public static const OPEN:String = "openProcess";
		public static const UPDATE:String = "updateProcess";
		
		public var prcMetaModel:SWGanttProcess;
		
		public function MISGanttProcessEvent(type:String, prcMetaModel:SWGanttProcess = null){
			super(type);
			
			if(prcMetaModel != null)
				this.prcMetaModel = prcMetaModel;
		}
	}
}