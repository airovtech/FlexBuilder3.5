/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.refactor.service.impl
 *  Class: 			ServerFormPersistenceService 
 * 					implements IFormPersistenceService
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Form에 관하여 서버에 요청하는 모든 서비스들을 구현한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.refactor.service.impl
{
	import com.maninsoft.smart.formeditor.model.FormDocument;
	import com.maninsoft.smart.formeditor.refactor.event.service.FormPersistenceEvent;
	import com.maninsoft.smart.formeditor.refactor.event.service.ServiceEvent;
	import com.maninsoft.smart.formeditor.refactor.service.IFormPersistenceService;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ServerFormPersistenceService implements IFormPersistenceService
	{
		// 폼 서비스를 하는 url
		private var serviceUrl:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		// 현재 사용자의 회사명
		private var compId:String;
		// 현재 사용자의 아이디
		private var userId:String;
		
		// 저장을 위하여 서버의 서비스를 호출하는 서비스
		private var saveReq:HTTPService;
		// 폼 저장이 완료되면 callback 되는 함수
		private var saveCallback:Function;

		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadListReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadListLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadListCallback:Function;

		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadAllSingleListReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadAllSingleListLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadAllSingleListCallback:Function;

		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadSingleFormFieldListReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadSingleFormFieldListLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadSingleFormFieldListCallback:Function;
						
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadByWorkTypeReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadByWorkTypeLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadByWorkTypeCallback:Function;		
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadListByPrcReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadListByPrcLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadListByPrcCallback:Function;

		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadListByFormReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadListByFormLoader:URLLoader;		
		// 폼 리스트 로드가완료되면 callback 되는 함수
		private var loadListByFormCallback:Function;
		
		// 인스턴스 저장을 위하여 서버의 서비스를 호출하는 서비스
		private var saveInstanceReq:HTTPService;
		// 인스턴스 저장이 완료되면 callback 되는 함수
		private var saveInstanceCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadInstanceListReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadInstanceListLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadInstanceListCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadInstanceReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadInstanceLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadInstanceCallback:Function;
		
		//루트카테고리를 찾기위한 서비스
		private var retrieveRootCategory:URLRequest;
		private var retrieveRootCategoryLoader:URLLoader;
		private var retrieveRootCategoryCallback:Function;
		
		//부모카테고리를 찾기위한 서비스
		private var retrieveParentCategory:URLRequest;
		private var retrieveParentCategoryLoader:URLLoader;
		private var retrieveParentCategoryCallback:Function;
		
		//카테고리를 찾기위한 서비스
		private var retrieveCategory:URLRequest;
		private var retrieveCategoryLoader:URLLoader;
		private var retrieveCategoryCallback:Function;
		
		//자식 카테고리 리스트 를 가져오기 위한 서비스
		private var retrieveChildrenByCategoryId:URLRequest;
		private var retrieveChildrenByCategoryIdLoader:URLLoader;
		private var retrieveChildrenByCategoryIdCallback:Function;
		
		//루트카테고리를 찾기위한 서비스
		private var retrievePackageByCategoryId:URLRequest;
		private var retrievePackageByCategoryIdLoader:URLLoader;
		private var retrievePackageByCategoryIdCallback:Function;
		
		// 폼 서비스가 실패하면 callback 되는 함수
		private var faultCallback:Function;

		private var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		public function ServerFormPersistenceService(serviceUrl:String, compId:String, userId:String)
		{
			this.serviceUrl = serviceUrl;
			this.compId = compId;
			this.userId = userId;
			
			this.saveReq = new HTTPService();
			this.saveReq.url = this.serviceUrl;
			this.saveReq.method = "POST";
			
			this.saveReq.addEventListener(ResultEvent.RESULT, saveResult);
			this.saveReq.addEventListener(FaultEvent.FAULT, serviceFault);

			this.loadReq = new URLRequest();
			this.loadLoader = new URLLoader();
			this.loadLoader.addEventListener(Event.COMPLETE, loadResult);
			this.loadLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.loadListReq = new URLRequest();
			this.loadListLoader = new URLLoader();
			this.loadListLoader.addEventListener(Event.COMPLETE, loadListResult);
			this.loadListLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadListLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.loadAllSingleListReq = new URLRequest();
			this.loadAllSingleListLoader = new URLLoader();
			this.loadAllSingleListLoader.addEventListener(Event.COMPLETE, loadAllSingleListResult);
			this.loadAllSingleListLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadAllSingleListLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.loadSingleFormFieldListReq = new URLRequest();
			this.loadSingleFormFieldListLoader = new URLLoader();
			this.loadSingleFormFieldListLoader.addEventListener(Event.COMPLETE, loadSingleFormFieldListResult);
			this.loadSingleFormFieldListLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadSingleFormFieldListLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
						
			this.loadByWorkTypeReq = new URLRequest();
			this.loadByWorkTypeLoader = new URLLoader();
			this.loadByWorkTypeLoader.addEventListener(Event.COMPLETE, loadByWorkTypeResult);
			this.loadByWorkTypeLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadByWorkTypeLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
						
			this.loadListByPrcReq = new URLRequest();
			this.loadListByPrcLoader = new URLLoader();
			this.loadListByPrcLoader.addEventListener(Event.COMPLETE, loadListByPrcResult);
			this.loadListByPrcLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadListByPrcLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.loadListByFormReq = new URLRequest();
			this.loadListByFormLoader = new URLLoader();
			this.loadListByFormLoader.addEventListener(Event.COMPLETE, loadListByFormResult);
			this.loadListByFormLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadListByFormLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
						
			this.saveInstanceReq = new HTTPService();
			this.saveInstanceReq.url = this.serviceUrl;
			this.saveInstanceReq.method = "POST";
			
			this.saveInstanceReq.addEventListener(ResultEvent.RESULT, saveInstanceResult);
			this.saveInstanceReq.addEventListener(FaultEvent.FAULT, serviceFault);
			
			this.loadInstanceListReq = new URLRequest();
			this.loadInstanceListLoader = new URLLoader();
			this.loadInstanceListLoader.addEventListener(Event.COMPLETE, loadInstanceListResult);
			this.loadInstanceListLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadInstanceListLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.loadInstanceReq = new URLRequest();
			this.loadInstanceLoader = new URLLoader();
			this.loadInstanceLoader.addEventListener(Event.COMPLETE, loadInstanceResult);
			this.loadInstanceLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadInstanceLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.retrieveRootCategory = new URLRequest();
			this.retrieveRootCategoryLoader = new URLLoader();
			this.retrieveRootCategoryLoader.addEventListener(Event.COMPLETE, retrieveRootCategoryResult);
			this.retrieveRootCategoryLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.retrieveRootCategoryLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.retrieveParentCategory = new URLRequest();
			this.retrieveParentCategoryLoader = new URLLoader();
			this.retrieveParentCategoryLoader.addEventListener(Event.COMPLETE, retrieveParentCategoryResult);
			this.retrieveParentCategoryLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.retrieveParentCategoryLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.retrieveCategory = new URLRequest();
			this.retrieveCategoryLoader = new URLLoader();
			this.retrieveCategoryLoader.addEventListener(Event.COMPLETE, retrieveCategoryResult);
			this.retrieveCategoryLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.retrieveCategoryLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.retrieveChildrenByCategoryId = new URLRequest();
			this.retrieveChildrenByCategoryIdLoader = new URLLoader();
			this.retrieveChildrenByCategoryIdLoader.addEventListener(Event.COMPLETE, retrieveChildrenByCategoryIdResult);
			this.retrieveChildrenByCategoryIdLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.retrieveChildrenByCategoryIdLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.retrievePackageByCategoryId = new URLRequest();
			this.retrievePackageByCategoryIdLoader = new URLLoader();
			this.retrievePackageByCategoryIdLoader.addEventListener(Event.COMPLETE, retrievePackageByCategoryIdResult);
			this.retrievePackageByCategoryIdLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.retrievePackageByCategoryIdLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

		}

		public function save(id:String, version:int, contents:XML, callBack:Function, fault:Function):void{
			this.saveCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "saveFormContent";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;	
			reqParameter["userId"] = this.userId;	
			reqParameter["formId"] = id;
			reqParameter["version"] = version;
			reqParameter["formContent"] = contents;
			
			this.saveReq.send(reqParameter);	
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function load(id:String, version:int, callBack:Function, fault:Function):void{
			this.loadCallback = callBack;
			this.faultCallback = fault;

			this.loadReq.url = this.serviceUrl + "?method=loadFormContent&compId=" + this.compId + "&userId=" + this.userId + "&formId=" + id + "&version=" + version;
			this.loadLoader.load(this.loadReq);
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadList(callBack:Function, fault:Function):void{
			this.loadListCallback = callBack;
			this.faultCallback = fault;
			
			this.loadListReq.url = this.serviceUrl + "?method=getFormList&compId=" + this.compId + "&userId=" + this.userId;
			this.loadListLoader.load(this.loadListReq);							
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadListByProcess(processId:String, version:int, callBack:Function, fault:Function):void{
			this.loadListByPrcCallback = callBack;
			this.faultCallback = fault;
			
			this.loadListByPrcReq.url = this.serviceUrl + "?method=getProcessFormList&compId=" + this.compId + "&userId=" + this.userId + "&processId=" + processId + "&version=" + version;
			this.loadListByPrcLoader.load(this.loadListByPrcReq);							
		}

		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadListByForm(formId:String, version:int, callBack:Function, fault:Function):void{
			this.loadListByFormCallback = callBack;
			this.faultCallback = fault;
			
			this.loadListByFormReq.url = this.serviceUrl + "?method=getProcessFormListByForm&compId=" + this.compId + "&userId=" + this.userId + "&formId=" + formId + "&version=" + version;
			this.loadListByFormLoader.load(this.loadListByFormReq);							
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadAllSingleList(callBack:Function, fault:Function):void{
			this.loadAllSingleListCallback = callBack;
			this.faultCallback = fault;
			
			this.loadAllSingleListReq.url = this.serviceUrl + "?method=searchSingleFormList&compId=" + this.compId + "&userId=" + this.userId;
			this.loadAllSingleListLoader.load(this.loadAllSingleListReq);							
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadByWorkType(workTypeId:String, callBack:Function, fault:Function):void{
			this.loadByWorkTypeCallback = callBack;
			this.faultCallback = fault;
			
			this.loadByWorkTypeReq.url = this.serviceUrl + "?method=getFormByWorkType&compId=" + this.compId + "&userId=" + this.userId + "&workTypeId=" + workTypeId;
			this.loadByWorkTypeLoader.load(this.loadByWorkTypeReq);							
		}
				
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadInstanceListByForm(id:String, version:int, callBack:Function, fault:Function):void{
			this.loadInstanceListCallback = callBack;
			this.faultCallback = fault;
			
			this.loadInstanceListReq.url = this.serviceUrl + "?method=searchDomainRecord&compId=" + this.compId + "&userId=" + this.userId + "&formId=" + id + "&version=" + version;
			this.loadInstanceListLoader.load(this.loadInstanceListReq);	
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadInstance(instanceId:String, callBack:Function, fault:Function):void{
			this.loadInstanceCallback = callBack;
			this.faultCallback = fault;
			
			this.loadInstanceReq.url = this.serviceUrl + "?method=findDomainRecordByRecordId&compId=" + this.compId + "&userId=" + this.userId + "&recordId=" + instanceId;;
			this.loadInstanceLoader.load(this.loadInstanceReq);	
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadSingleFormFieldList(formId:String, callBack:Function, fault:Function):void{
			this.loadSingleFormFieldListCallback = callBack;
			this.faultCallback = fault;
			
			this.loadSingleFormFieldListReq.url = this.serviceUrl + "?method=getSingleFormFieldList&compId=" + this.compId + "&formId=" + formId + "&userId=" + this.userId;
			this.loadSingleFormFieldListLoader.load(this.loadSingleFormFieldListReq);		
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function saveInstance(instanceId:String, contents:XML, callBack:Function, fault:Function):void{
			this.saveInstanceCallback = callBack;
			this.faultCallback = fault;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "updateDomainRecord";
			reqParameter["recordId"] = instanceId;			
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["data"] = contents;
			
			this.saveInstanceReq.send(reqParameter);	
		}
		
		public function getRootCategory(resultHandler:Function):void{
			this.retrieveRootCategoryCallback = resultHandler;

			this.retrieveRootCategory.url = this.serviceUrl + "?method=retrieveRootCategory&compId=" + this.compId + "&userId=" + this.userId;
			this.retrieveRootCategoryLoader.load(this.retrieveRootCategory);		
		}
		
		public function getParentCategory(categoryId:String, resultHandler:Function):void{
			this.retrieveParentCategoryCallback = resultHandler;

			this.retrieveParentCategory.url = this.serviceUrl + "?method=retrieveParentCategory&compId=" + this.compId + "&userId=" + this.userId + "&categoryId=" + categoryId;
			this.retrieveParentCategoryLoader.load(this.retrieveParentCategory);		
		}
		
		public function getCategoryById(categoryId:String, resultHandler:Function):void{
			this.retrieveCategoryCallback = resultHandler;

			this.retrieveCategory.url = this.serviceUrl + "?method=retrieveCategory&compId=" + this.compId + "&userId=" + this.userId + "&categoryId=" + categoryId;
			this.retrieveCategoryLoader.load(this.retrieveCategory);		
		}
		
		public function getChildrenByCategoryId(categoryId:String, resultHandler:Function):void{
			this.retrieveChildrenByCategoryIdCallback = resultHandler;

			this.retrieveChildrenByCategoryId.url = this.serviceUrl + "?method=retrieveChildrenByCategoryId&compId=" + this.compId + "&userId=" + this.userId + "&categoryId=" + categoryId;
			this.retrieveChildrenByCategoryIdLoader.load(this.retrieveChildrenByCategoryId);		
		}
		
		public function getPackagesByCategoryId(categoryId:String, resultHandler:Function):void{
			this.retrievePackageByCategoryIdCallback = resultHandler;

			this.retrievePackageByCategoryId.url = this.serviceUrl + "?method=retrievePackageByCategoryId&compId=" + this.compId + "&userId=" + this.userId + "&categoryId=" + categoryId;
			this.retrievePackageByCategoryIdLoader.load(this.retrievePackageByCategoryId);		
		}

		// 폼을 저장올 때 결과처리
		private function saveResult(event:ResultEvent):void{
			var formSaveEvent:FormPersistenceEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_SAVE);
			
			if(event.result["Result"]["status"] == "OK"){				
				this.saveCallback(formSaveEvent);		
			}else{
				formSaveEvent.msg = resourceManager.getString("FormEditorMessages", "FEE001") +  "\n (" + event.result["Result"]["message"] + ")";
				this.faultCallback(formSaveEvent);		
			}	
		}
		// 폼을 불러올 때 결과처리
		private function loadListResult(event:Event):void{
			var formListXML:XML = XML(this.loadListLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE002") +  "\n (" + formListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_LIST);
				formLoadEvent.formListXML = formListXML;	
				this.loadListCallback(formLoadEvent);
			}	
		}

		// 폼을 불러올 때 결과처리
		private function loadAllSingleListResult(event:Event):void{
			var formListXML:XML = XML(this.loadAllSingleListLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE002") +  "\n (" + formListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_LIST);
				formLoadEvent.formListXML = formListXML;	
				this.loadAllSingleListCallback(formLoadEvent);
			}	
		}
		
				// 폼을 불러올 때 결과처리
		private function loadSingleFormFieldListResult(event:Event):void{
			var formListXML:XML = XML(this.loadSingleFormFieldListLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE003") +  "\n (" + formListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_FIELD_LIST);
				formLoadEvent.resultXML = formListXML;	
				this.loadSingleFormFieldListCallback(formLoadEvent);
			}	
		}
				
		// 폼을 불러올 때 결과처리
		private function loadListByPrcResult(event:Event):void{
			var prcFormListXML:XML = XML(this.loadListByPrcLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(prcFormListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE002") +  "\n (" + prcFormListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_LIST);
				formLoadEvent.formListXML = prcFormListXML;	
				this.loadListByPrcCallback(formLoadEvent);
			}	
		}

		// 폼을 불러올 때 결과처리
		private function loadListByFormResult(event:Event):void{
			var formFormListXML:XML = XML(this.loadListByFormLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formFormListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE002") +  "\n (" + formFormListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_LIST);
				formLoadEvent.formListXML = formFormListXML;	
				this.loadListByFormCallback(formLoadEvent);
			}	
		}
				
		// 폼을 불러올 때 결과처리
		private function loadByWorkTypeResult(event:Event):void{
			var formXML:XML = XML(this.loadByWorkTypeLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE002") +  "\n (" + formXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_LIST);
				if(formXML.@id.toString() != "")
					formLoadEvent.formModel = FormDocument.parseXML(formXML)
				this.loadByWorkTypeCallback(formLoadEvent);
			}	
		}
		
		// 폼을 불러올 때 결과처리
		private function loadResult(event:Event):void{
			var formXML:XML = XML(this.loadLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE004") +  "\n (" + formXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD);
				if(formXML.@id.toString() != ""){
					trace( formXML.toXMLString());
					formLoadEvent.formModel = FormDocument.parseXML(formXML)
				}
				this.loadCallback(formLoadEvent);
			}	
		}
		
		// 폼 인스턴스을 저장올 때 결과처리
		private function saveInstanceResult(event:ResultEvent):void{
			var formSaveEvent:FormPersistenceEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_SAVE_INSTANCE);
			
			if(event.result["Result"]["status"] != "OK"){				
				formSaveEvent.msg = resourceManager.getString("FormEditorMessages", "FEE005") +  "\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.saveInstanceCallback(formSaveEvent);			
		}
		
		// 폼의 인스턴스 정보 리스트를 불러올 때 결과처리
		private function loadInstanceListResult(event:Event):void{
			var formInstanceListXML:XML = XML(this.loadInstanceListLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formInstanceListXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE006") +  "\n (" + formInstanceListXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_INSTANCE_LIST);
				formLoadEvent.formInstanceListXML = formInstanceListXML;	
				this.loadInstanceListCallback(formLoadEvent);
			}	
		}
		
		// 폼의 인스턴스 정보를 불러올 때 결과처리
		private function loadInstanceResult(event:Event):void{
			var formInstanceXML:XML = XML(this.loadLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(formInstanceXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE007") +  "\n (" + formInstanceXML.message + ")";
				this.faultCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCESS_LOAD_INSTANCE);
				formLoadEvent.formInstanceXML = formInstanceXML;
				this.loadInstanceCallback(formLoadEvent);
			}	
		}

		private function retrieveRootCategoryResult(event:Event):void{
			var resultXML:XML = XML(this.retrieveRootCategoryLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(resultXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE008") +  "\n (" + resultXML.message + ")";
				this.retrieveRootCategoryCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCCESS_GET_ROOTCATEGORY);
				formLoadEvent.resultXML = resultXML;
				this.retrieveRootCategoryCallback(formLoadEvent);
			}	
		}			
		
		private function retrieveParentCategoryResult(event:Event):void{
			var resultXML:XML = XML(this.retrieveParentCategoryLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(resultXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE009") +  "\n (" + resultXML.message + ")";
				this.retrieveParentCategoryCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCCESS_GET_PARENTCATEGORY);
				formLoadEvent.resultXML = resultXML;
				this.retrieveParentCategoryCallback(formLoadEvent);
			}	
		}			
		
		private function retrieveCategoryResult(event:Event):void{
			var resultXML:XML = XML(this.retrieveCategoryLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(resultXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE010") +  "\n (" + resultXML.message + ")";
				this.retrieveCategoryCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCCESS_GET_CATEGORY);
				formLoadEvent.resultXML = resultXML;
				this.retrieveCategoryCallback(formLoadEvent);
			}	
		}			
		
		private function retrieveChildrenByCategoryIdResult(event:Event):void{
			var resultXML:XML = XML(this.retrieveChildrenByCategoryIdLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(resultXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE011") +  "\n (" + resultXML.message + ")";
				this.retrieveChildrenByCategoryIdCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCCESS_GET_CHILDRENBYCATEGORYID);
				formLoadEvent.resultXML = resultXML;
				this.retrieveChildrenByCategoryIdCallback(formLoadEvent);
			}	
		}			
		
		private function retrievePackageByCategoryIdResult(event:Event):void{
			var resultXML:XML = XML(this.retrievePackageByCategoryIdLoader.data);
			var formLoadEvent:FormPersistenceEvent		
			if(resultXML.@status == "Failed"){
				formLoadEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
				formLoadEvent.msg = resourceManager.getString("FormEditorMessages", "FEE012") +  "\n (" + resultXML.message + ")";
				this.retrievePackageByCategoryIdCallback(formLoadEvent);
			}else{
				formLoadEvent = new FormPersistenceEvent(FormPersistenceEvent.SUCCESS_GET_PACKAGEBYCATEGORYID);
				formLoadEvent.resultXML = resultXML;
				this.retrievePackageByCategoryIdCallback(formLoadEvent);
			}	
		}			

		// 서비스가 실패한 경우에 처리
		private function serviceFault(event:Event):void{
			var formEvent:FormPersistenceEvent = new FormPersistenceEvent(ServiceEvent.FAIL);
			if(event.type == IOErrorEvent.IO_ERROR){
				formEvent.msg = resourceManager.getString("FormEditorMessages", "FEE013");
			}else{
				formEvent.msg = resourceManager.getString("FormEditorMessages", "FEE014");
			}
			this.faultCallback(formEvent);
		}	
	}
}