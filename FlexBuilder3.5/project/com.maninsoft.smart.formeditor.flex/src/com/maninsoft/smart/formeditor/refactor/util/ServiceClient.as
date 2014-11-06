/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.refactor.util
 *  Class: 			ServiceClient
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 서버에 서비스들을 요청하는 클라이언트 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.refactor.util
{
	import com.maninsoft.smart.formeditor.refactor.service.IFormPersistenceService;
	import com.maninsoft.smart.formeditor.refactor.service.IWorklistService;
	import com.maninsoft.smart.formeditor.refactor.service.impl.ServerFormPersistenceService;
	import com.maninsoft.smart.formeditor.refactor.service.impl.ServerWorkTypeService;
	import com.maninsoft.smart.formeditor.refactor.service.impl.ServerWorklistServiceImpl;
	import com.maninsoft.smart.formeditor.util.FormEditorConfig;
	
	public class ServiceClient
	{
		public var _serviceUrl:String;
		
		public function ServiceClient(serviceUrl:String){
			this._serviceUrl = serviceUrl;
		}
		
		private var _formService:IFormPersistenceService;
		private var _worklistService:IWorklistService;
		private var _workTypeService:ServerWorkTypeService;
			
		public function get formService():IFormPersistenceService{
        	if(_formService == null){
				/**
			 	 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 	 * 	2010.3.2 Modified by Y.S. Jung
			 	 */
        		_formService = new ServerFormPersistenceService(_serviceUrl, FormEditorConfig.compId, FormEditorConfig.userId);
        	}
        		
        	return _formService;	        	
		}
		
		public function get worklistService():IWorklistService{
        	if(_worklistService == null)
			/**
		 	 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 	 * 	2010.3.2 Modified by Y.S. Jung
		 	 */
       		_worklistService = new ServerWorklistServiceImpl(_serviceUrl, FormEditorConfig.compId, FormEditorConfig.userId);
        		
        	return _worklistService;	        	
		}
		
		public function get workTypeService():ServerWorkTypeService{
        	if(_workTypeService == null)
				/**
			 	 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 	 * 	2010.3.2 Modified by Y.S. Jung
			 	 */
        		_workTypeService = new ServerWorkTypeService(_serviceUrl, FormEditorConfig.compId, FormEditorConfig.userId);
        		
        	return _workTypeService;	        	
		}

	}
}