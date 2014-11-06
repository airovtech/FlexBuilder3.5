package com.maninsoft.smart.workbench.event
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	
	import flash.events.Event;
	
	public dynamic class MISProcessEvent extends Event
	{
		public static const OPEN:String = "openProcess";
		public static const UPDATE:String = "updateProcess";
		
		public var prcMetaModel:SWProcess;
		
		public function MISProcessEvent(type:String, prcMetaModel:SWProcess = null){
			super(type);
			
			if(prcMetaModel != null)
				this.prcMetaModel = prcMetaModel;
		}
	}
}