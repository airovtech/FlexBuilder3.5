package com.maninsoft.smart.workbench.util
{
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	import com.maninsoft.smart.workbench.service.IRepositoryService;
	import com.maninsoft.smart.workbench.service.impl.ServerRepositoryServiceImpl;
	
	public class WorkbenchConfig
	{
		[Bindable]
		public static var basePath:String;
		[Bindable]
		public static var serviceUrl:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		[Bindable]
		public static var compId:String;
		[Bindable]
		public static var userId:String;
		[Bindable]
		public static var userName:String;
		[Bindable]
		public static var toDay:String;
		[Bindable]
		public static var contentHeight:Number=0;
		[Bindable]
		public static var dueDate:String;
		[Bindable]
		public static var readOnly:Boolean=false;
		
		public static var PROCESS_NAME:String;
		public static var GANTTPROCESS_NAME:String;
		public static var FORM_NAME_PREFIX:String;
		public static const INTERNAL_PROCESS_NAME_PREFIX:String = "INTERNAL_PROCESS";
		
		private static var _repoService:IRepositoryService;		
		// 파라미터를 받아서 config 생성
		public static function config(parameter:Object):void
		{
			userId = parameter.sessionUserId;
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			compId = parameter.sessionCompId;
			serviceUrl = parameter.serviceUrl;
			userName = parameter.userName;
			toDay = parameter.toDay;
		}		
		// 리파지토리 서비스 제공
		public static function get repoService():IRepositoryService{
        	if(_repoService == null){
 			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
 	      		_repoService = new ServerRepositoryServiceImpl(WorkbenchConfig.serviceUrl, WorkbenchConfig.compId, WorkbenchConfig.userId);
        	}
        		
        	return _repoService;	        	
		}

	}
}