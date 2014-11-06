package com.maninsoft.smart.formeditor.refactor.event.service
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	
	public class FormPersistenceEvent extends ServiceEvent
	{
		public static const SUCESS_SAVE:String = "sucessFormSave";
		public static const SUCESS_LOAD:String = "sucessFormLoad";
		public static const SUCESS_LOAD_LIST:String = "sucessFormListLoad";
		public static const SUCESS_LOAD_FIELD_LIST:String = "sucessFormFieldListLoad";
		
		public static const SUCESS_SAVE_INSTANCE:String = "sucessFormInstanceSave";		
		public static const SUCESS_LOAD_INSTANCE:String = "sucessFormInstanceLoad";
		public static const SUCESS_LOAD_INSTANCE_LIST:String = "sucessFormInstanceListLoad";
		
		public static const SUCCESS_GET_ROOTCATEGORY:String = "successGetRootCategory";
		public static const SUCCESS_GET_PARENTCATEGORY:String = "successGetParentCategory";
		public static const SUCCESS_GET_CATEGORY:String = "sucessGetCategory";
		public static const SUCCESS_GET_CHILDRENBYCATEGORYID:String = "successGetChildrenByCategoryId";
		public static const SUCCESS_GET_PACKAGEBYCATEGORYID:String = "successGetPackageByCategoryId";
		
		public function FormPersistenceEvent(type:String){
			super(type);
		}
		// 폼 로드시 폼 모델 정보
		public var formModel:FormDocument;
		// 폼 리스트 로드시 폼 리스트 정보
		public var formListXML:XML;
		// 폼 인스턴스 로드시 폼 인스턴스 정보
		public var formInstanceXML:XML;
		// 폼 인스턴스 리스트 로드시 폼 인스턴스 정보
		public var formInstanceListXML:XML;
		
		// 결과 정보
		public var resultXML:XML;	
	}
}