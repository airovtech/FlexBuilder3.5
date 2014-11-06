package com.maninsoft.smart.formeditor.refactor.event.service
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	
	public class WorklistServiceEvent extends ServiceEvent
	{
		public static const SUCESS_EXECUTE:String = "sucessWorkitemExecute";
		public static const SUCESS_ASSIGN:String = "sucessWorkitemAssign";
		public static const SUCESS_SAVE:String = "sucessWorkitemSave";
		public static const FAIL_EXECUTE:String = "failWorkitemExecute";
		public static const SUCESS_LOAD:String = "sucessWorkitemLoad";
		public static const SUCESS_LOAD_REF:String = "sucessRefWorkitemLoad";
		public static const SUCESS_LOAD_LIST:String = "sucessWorklistLoad";
		public static const SUCESS_LOAD_FORM:String = "sucessWorkFormLoad";
		public static const SUCESS_LOAD_MAPPING:String = "sucessMappingDataLoad";
		
		public static const FAIL:String = "fail";
		
		public function WorklistServiceEvent(type:String){
			super(type);
		}
		// 작업 XML
		public var workitemXML:XML;
		// 작업 리스트 XML
		public var worklistXML:XML;
		// 작업 용 폼정보
		public var formModel:FormDocument;
	}
}