package com.maninsoft.smart.workbench.event
{
	import com.maninsoft.smart.workbench.common.meta.IFormMetaModel;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	
	import flash.events.Event;
	
	public class MISFormEvent extends Event
	{
		public static const OPEN:String = "openForm";
		public static const UPDATE:String = "updateForm";
		
		public var formMetaModel:SWForm;
		
		public function MISFormEvent(type:String, formMetaModel:SWForm = null){
			super(type);
			
			if(formMetaModel != null)
				this.formMetaModel = formMetaModel;
		}
	}
}