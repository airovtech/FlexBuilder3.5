/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.refactor.service.impl
 *  Class: 			ServerWorklistServiceImpl
 * 					implements IWorklistService
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Work List에 관하여  서버에 요청하는 모든 서비스들을 구현한 클래스
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
	import com.maninsoft.smart.formeditor.refactor.event.service.ServiceEvent;
	import com.maninsoft.smart.formeditor.refactor.event.service.WorklistServiceEvent;
	import com.maninsoft.smart.formeditor.refactor.service.IWorklistService;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ServerWorklistServiceImpl implements IWorklistService
	{
		// 작업서비스를 하는 url
		private var serviceUrl:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		// 현재 사용자의 회사이름
		private var compId:String;
		// 현재 사용자의 아이디
		private var userId:String;
		
		// 작업 실행을 위하여 서버의 서비스를 호출하는 서비스
		private var executeReq:HTTPService;
		// 작업 실행이 완료되면 callback 되는 함수
		private var executeCallback:Function;

		// 작업 실행을 위하여 서버의 서비스를 호출하는 서비스
		private var executeStartReq:HTTPService;
		// 작업 실행이 완료되면 callback 되는 함수
		private var executeStartCallback:Function;

		// 작업을 할당하는 서비스
		private var assignReq:HTTPService;
		// 작업을 할당하면 callback 되는 함수
		private var assignCallback:Function;
				
		// 작업 실행을 위하여 서버의 서비스를 호출하는 서비스
		private var creteRecordReq:HTTPService;
		// 작업 실행이 완료되면 callback 되는 함수
		private var creteRecordCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadReq:URLRequest;
		// 작업이 로드되는 변수
		private var loadLoader:URLLoader;
		// 작업로드가완료되면 callback 되는 함수
		private var loadCallback:Function;

		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadRecordReq:URLRequest;
		// 작업이 로드되는 변수
		private var loadRecordLoader:URLLoader;
		// 작업로드가완료되면 callback 되는 함수
		private var loadRecordCallback:Function;
				
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadFormReq:URLRequest;
		// 작업이 로드되는 변수
		private var loadFormLoader:URLLoader;
		// 작업로드가완료되면 callback 되는 함수
		private var loadFormCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadFormByWorkItemIdReq:URLRequest;
		// 작업이 로드되는 변수
		private var loadFormByWorkItemIdLoader:URLLoader;
		// 작업로드가완료되면 callback 되는 함수
		private var loadFormByWorkItemIdCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadListReq:URLRequest;
		// 작업목록이 로드되는 변수
		private var loadListLoader:URLLoader;		
		// 작업목록 로드가 완료되면 callback 되는 함수
		private var loadListCallback:Function;

		// 참조 작업를 위하여 서버의 서비스를 요청하는 변수
		private var loadRefReq:URLRequest;
		// 참조 작업이 로드되는 변수
		private var loadRefLoader:URLLoader;
		// 참조 작업 로드가완료되면 callback 되는 함수
		private var loadRefCallback:Function;
		
		// 폼 서비스가 실패하면 callback 되는 함수
		private var faultCallback:Function;
		
		// 작업 저장을 위하여 서버의 서비스를 호출하는 서비스
		private var saveWorkReq:HTTPService;
		
		// 작업 위을 임위하여 서버의 서비스를 호출하는 서비스
		private var entrustWorkReq:HTTPService;
		
		// 작업 반려을 위하여 서버의 서비스를 호출하는 서비스
		private var returnWorkReq:HTTPService;
		
		
		// 작업 실행을 위하여 서버의 서비스를 호출하는 서비스
		private var loadMappingReq:HTTPService;
		// 작업 실행이 완료되면 callback 되는 함수
		private var loadMappingCallback:Function;
				
		// 작업 중단을 위하여 서버의 서비스를 호출하는 서비스
		private var terminateWorkReq:HTTPService;
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function ServerWorklistServiceImpl(serviceUrl:String, compId:String, userId:String)
		{
			this.serviceUrl = serviceUrl;
			this.compId = compId;			
			this.userId = userId;			

			this.executeReq = new HTTPService();
			this.executeReq.url = this.serviceUrl;
			this.executeReq.method = "POST";
			this.executeReq.addEventListener(ResultEvent.RESULT, executeResult);
			this.executeReq.addEventListener(FaultEvent.FAULT, serviceFault);

			this.assignReq = new HTTPService();
			this.assignReq.url = this.serviceUrl;
			this.assignReq.method = "POST";
			this.assignReq.addEventListener(ResultEvent.RESULT, assignResult);
			this.assignReq.addEventListener(FaultEvent.FAULT, serviceFault);
						
			this.saveWorkReq = new HTTPService();
			this.saveWorkReq.url = this.serviceUrl;
			this.saveWorkReq.method = "POST";
			this.saveWorkReq.addEventListener(ResultEvent.RESULT, saveWorkResult);
			this.saveWorkReq.addEventListener(FaultEvent.FAULT, serviceFault);
			
			this.entrustWorkReq = new HTTPService();
			this.entrustWorkReq.url = this.serviceUrl;
			this.entrustWorkReq.method = "POST";
			this.entrustWorkReq.addEventListener(ResultEvent.RESULT, entrustWorkResult);
			this.entrustWorkReq.addEventListener(FaultEvent.FAULT, serviceFault);
			
			this.returnWorkReq = new HTTPService();
			this.returnWorkReq.url = this.serviceUrl;
			this.returnWorkReq.method = "POST";
			this.returnWorkReq.addEventListener(ResultEvent.RESULT, returnWorkResult);
			this.returnWorkReq.addEventListener(FaultEvent.FAULT, serviceFault);
			
			this.terminateWorkReq = new HTTPService();
			this.terminateWorkReq.url = this.serviceUrl;
			this.terminateWorkReq.method = "POST";
			this.terminateWorkReq.addEventListener(ResultEvent.RESULT, terminateWorkResult);
			this.terminateWorkReq.addEventListener(FaultEvent.FAULT, serviceFault);
			
			this.executeStartReq = new HTTPService();
			this.executeStartReq.url = this.serviceUrl;
			this.executeStartReq.method = "POST";
			this.executeStartReq.addEventListener(ResultEvent.RESULT, executeStartResult);
			this.executeStartReq.addEventListener(FaultEvent.FAULT, serviceFault);			
//			this.executeStartReq.addEventListener(InvokeEvent.INVOKE, serviceInvoke);	

			this.creteRecordReq = new HTTPService();
			this.creteRecordReq.url = this.serviceUrl;
			this.creteRecordReq.method = "POST";
			this.creteRecordReq.addEventListener(ResultEvent.RESULT, creteRecordResult);
			this.creteRecordReq.addEventListener(FaultEvent.FAULT, serviceFault);		
			
			this.loadReq = new URLRequest();
			this.loadLoader = new URLLoader();
			this.loadLoader.addEventListener(Event.COMPLETE, loadResult);
			this.loadLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.loadRecordReq = new URLRequest();
			this.loadRecordLoader = new URLLoader();
			this.loadRecordLoader.addEventListener(Event.COMPLETE, loadRecordResult);
			this.loadRecordLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadRecordLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
						
			this.loadFormReq = new URLRequest();
			this.loadFormLoader = new URLLoader();
			this.loadFormLoader.addEventListener(Event.COMPLETE, loadFormResult);
			this.loadFormLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadFormLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);

			this.loadFormByWorkItemIdReq = new URLRequest();
			this.loadFormByWorkItemIdLoader = new URLLoader();
			this.loadFormByWorkItemIdLoader.addEventListener(Event.COMPLETE, loadFormByWorkItemIdResult);
			this.loadFormByWorkItemIdLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadFormByWorkItemIdLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.loadListReq = new URLRequest();
			this.loadListLoader = new URLLoader();
			this.loadListLoader.addEventListener(Event.COMPLETE, loadListResult);
			this.loadListLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadListLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
	
			this.loadRefReq = new URLRequest();
			this.loadRefLoader = new URLLoader();	
			this.loadRefLoader.addEventListener(Event.COMPLETE, loadRefResult);
			this.loadRefLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadRefLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.loadMappingReq = new HTTPService();
			this.loadMappingReq.method = "POST";
			this.loadMappingReq.url = this.serviceUrl;
			
			this.loadMappingReq.addEventListener(ResultEvent.RESULT, loadMappingDataResult);
		}
		
		public function execute(workitemId:String, contents:XML, nextDuration:String, nextPerformer:String, callBack:Function, fault:Function):void{
			this.executeCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "executeWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["workItemId"] = workitemId;
			reqParameter["workItemData"] = contents;
			if(nextDuration!=null && nextDuration!=""){
				reqParameter["nextDuration"] = nextDuration;
			}
			if(nextPerformer!=null && nextPerformer!=""){
				reqParameter["nextPerformer"] = nextPerformer;
			}
				
			this.executeReq.send(reqParameter);	
		}
		
		public function assign(formId:String, version:int, title:String, assignee:String, relatedWorkItemId:String, contents:XML, nextDuration:String, callBack:Function, fault:Function):void{
			this.assignCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "createWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["formId"] = formId;
			reqParameter["version"] = version;
			reqParameter["title"] = title;
			reqParameter["assignee"] = assignee;
			reqParameter["relatedWorkItemId"] = relatedWorkItemId;
			reqParameter["nextDuration"] = nextDuration;
			reqParameter["workItemData"] = contents;
				
			this.assignReq.send(reqParameter);	
		}
		
		public function executeStart(formId:String, prcId:String, version:int, prcTitle:String, keyword:String, description:String, nextPerformer:String, contents:XML, callBack:Function, fault:Function):void{
			this.executeStartCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "executeStartWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["title"] = prcTitle;
			reqParameter["formId"] = formId;			
			reqParameter["processId"] = prcId;
			reqParameter["version"] = version;
			reqParameter["keyword"] = keyword;
			reqParameter["description"] = description;
			if(nextPerformer != null)
				reqParameter["nextPerformer"] = nextPerformer;
			reqParameter["workItemData"] = contents;
				
			this.executeStartReq.send(reqParameter);	
		}		
		
		public function creteRecord(contents:XML, callBack:Function, fault:Function):void{
			this.creteRecordCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "createSingleFormRecord";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["data"] = contents;
				
			this.creteRecordReq.send(reqParameter);	
		}	
		
		public function saveWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void{
			this.executeCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "saveWorkItemData";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["workItemId"] = workitemId;
			reqParameter["workItemData"] = contents;
			
			this.saveWorkReq.send(reqParameter);	
		}
		
		public function entrustWork(workitemId:String, contents:XML, entruster:String, callBack:Function, fault:Function):void{
			this.executeCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "entrustWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["workItemId"] = workitemId;
			reqParameter["entruster"] = entruster;
				
			this.entrustWorkReq.send(reqParameter);	
		}
		
		public function returnWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void{
			this.executeCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "returnWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["workItemId"] = workitemId;
			reqParameter["workItemData"] = contents;
				
			this.returnWorkReq.send(reqParameter);	
		}
		
		public function terminateWork(workitemId:String, contents:XML, callBack:Function, fault:Function):void{
			this.executeCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "terminateWorkItem";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["workItemId"] = workitemId;
				
			this.terminateWorkReq.send(reqParameter);	
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function load(workitemId:String, callBack:Function, fault:Function):void{
			this.loadCallback = callBack;
			this.faultCallback = fault;

			this.loadReq.url = this.serviceUrl + "?method=getWorkItemData&compId=" + this.compId + "&userId=" + this.userId + "&workItemId=" + workitemId;
			this.loadLoader.load(this.loadReq);
		}

		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadRecord(recordId:String, formId:String, callBack:Function, fault:Function):void{
			this.loadRecordCallback = callBack;
			this.faultCallback = fault;

			this.loadRecordReq.url = this.serviceUrl + "?method=getSingleFormRecord&compId=" + this.compId + "&userId=" + this.userId + "&recordId=" + recordId + "&formId=" + formId;
			this.loadRecordLoader.load(this.loadRecordReq);
		}
				
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadFormByWorkItemId(workitemId:String, callBack:Function, fault:Function):void{
			this.loadFormByWorkItemIdCallback = callBack;
			this.faultCallback = fault;

			this.loadFormByWorkItemIdReq.url = this.serviceUrl + "?method=getFormByWorkItemId&compId=" + this.compId + "&userId=" + this.userId + "&workItemId=" + workitemId;
			this.loadFormByWorkItemIdLoader.load(this.loadFormByWorkItemIdReq);
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadForm(formId:String, version:int, callBack:Function, fault:Function):void{
			this.loadFormCallback = callBack;
			this.faultCallback = fault;

			this.loadFormReq.url = this.serviceUrl + "?method=getForm&compId=" + this.compId + "&userId=" + this.userId + "&formId=" + formId + "&version=" + version;
			this.loadFormLoader.load(this.loadFormReq);
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadRef(workitemId:String, formId:String, callBack:Function, fault:Function):void{
			this.loadRefCallback = callBack;
			this.faultCallback = fault;

			this.loadRefReq.url = this.serviceUrl + "?method=findReferenceDomainRecord&compId=" + this.compId + "&userId=" + this.userId + "&refFormId=" + formId + "&workItemId=" + workitemId;
			this.loadRefLoader.load(this.loadRefReq);
		}
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function loadList(callBack:Function, fault:Function):void{
			this.loadListCallback = callBack;
			this.faultCallback = fault;
			
			this.loadListReq.url = this.serviceUrl + "?method=loadWorklist&compId=" + this.compId + "&userId=" + this.userId;
			this.loadListLoader.load(this.loadListReq);							
		}
		
		public function loadMappingData(formId:String, version:int, mappingId:String, parameterXml:XML, callBack:Function, fault:Function):void{
			this.loadMappingCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "findMappingRecord";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;
			reqParameter["userId"] = this.userId;
			reqParameter["formId"] = formId;
			reqParameter["version"] = version;
			reqParameter["mappingId"] = mappingId;
			
			reqParameter["parameter"] = parameterXml.toString();
				
			this.loadMappingReq.send(reqParameter);	
		}

		// 작업을 실행할 때 결과처리
		private function executeResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 실행되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeCallback(formSaveEvent);			
		}


		// 작업을 실행할 때 결과처리
		private function assignResult(event:ResultEvent):void{
			var assignEvent:ServiceEvent;
			
			if(event.result["Result"]["status"] == "OK"){		
				assignEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_ASSIGN);		
				assignEvent.msg = "정상적으로 작업이지시되었습니다.";
				this.assignCallback(assignEvent);	
			}else{
				assignEvent = new WorklistServiceEvent(WorklistServiceEvent.FAIL);	
				assignEvent.msg = "작업 지시에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
				this.faultCallback(assignEvent);	
			}	
		}
				
		private function saveWorkResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 저장되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeCallback(formSaveEvent);			
		}
		
		private function entrustWorkResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 위임되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeCallback(formSaveEvent);			
		}
		
		private function terminateWorkResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 반려되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeCallback(formSaveEvent);			
		}
		
		private function returnWorkResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 중단되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeCallback(formSaveEvent);			
		}
		
		// 작업을 실행할 때 결과처리
		private function executeStartResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 작업이 실행되었습니다.";
			}else{
				formSaveEvent.msg = "작업 실행에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.executeStartCallback(formSaveEvent);			
		}
		// 작업을 실행할 때 결과처리
		private function creteRecordResult(event:ResultEvent):void{
			var formSaveEvent:WorklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_EXECUTE);
			
			if(event.result["Result"]["status"] == "OK"){				
				formSaveEvent.msg = "정상적으로 데이타가 생성되었습니다.";
			}else{
				formSaveEvent.msg = "데이타 생성에 실패했습니다.\n (" + event.result["Result"]["message"] + ")";
			}	
			
			this.creteRecordCallback(formSaveEvent);			
		}
		// 작업 리스트를 불러올 때 결과처리
		private function loadListResult(event:Event):void{
			var worklistXML:XML = XML(this.loadListLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;
			if(worklistXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 리스트 불러오기에 실패했습니다.\n (" + worklistXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD_LIST);
				worklistServiceEvent.msg = "작업 리스트 불러오기를 완료했습니다.\n (" + worklistXML.message + ")";
				worklistServiceEvent.worklistXML = worklistXML;	
				this.loadListCallback(worklistServiceEvent);
			}	
		}
		// 작업 리스트를 불러올 때 결과처리
		private function loadMappingDataResult(event:ResultEvent):void{
			var worklistXML:XML = XML(event.message.body);
			var worklistServiceEvent:WorklistServiceEvent;
			if(worklistXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "맵핑 데이타  리스트 불러오기에 실패했습니다.\n (" + worklistXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD_MAPPING);
				worklistServiceEvent.msg = "맵핑 데이타  불러오기를 완료했습니다.\n (" + worklistXML.message + ")";
				worklistServiceEvent.worklistXML = worklistXML;	
				this.loadMappingCallback(worklistServiceEvent);
			}	
		}
		
		// 작업을 불러올 때 결과처리
		private function loadResult(event:Event):void{
			var workitemXML:XML = XML(this.loadLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;		
			if(workitemXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 불러오기에 실패했습니다.\n (" + workitemXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD);
				worklistServiceEvent.msg = "작업 불러오기를 완료했습니다.\n (" + workitemXML.message + ")";
				worklistServiceEvent.workitemXML = workitemXML.DataRecord[0];
				this.loadCallback(worklistServiceEvent);
			}	
		}
		
		// 작업을 불러올 때 결과처리
		private function loadRecordResult(event:Event):void{
			var workitemXML:XML = XML(this.loadRecordLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;		
			if(workitemXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 불러오기에 실패했습니다.\n (" + workitemXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD);
				worklistServiceEvent.msg = "작업 불러오기를 완료했습니다.\n (" + workitemXML.message + ")";
				worklistServiceEvent.workitemXML = workitemXML;
				this.loadRecordCallback(worklistServiceEvent);
			}	
		}
		
		// 작업을 불러올 때 결과처리
		private function loadFormByWorkItemIdResult(event:Event):void{
			var formXML:XML = XML(this.loadFormByWorkItemIdLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;		
			if(formXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 폼 불러오기에 실패했습니다.\n (" + formXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD_FORM);
				worklistServiceEvent.msg = "작업 폼 불러오기를 완료했습니다.\n (" + formXML.message + ")";
				if(formXML.id != null && formXML.id != ""){
					worklistServiceEvent.formModel = FormDocument.parseXML(formXML);
				}				
				this.loadFormByWorkItemIdCallback(worklistServiceEvent);
			}	
		}
		
		// 작업을 불러올 때 결과처리
		private function loadFormResult(event:Event):void{
			var formXML:XML = XML(this.loadFormLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;		
			if(formXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 폼 불러오기에 실패했습니다.\n (" + formXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD_FORM);
				worklistServiceEvent.msg = "작업 폼 불러오기를 완료했습니다.\n (" + formXML.message + ")";
				if(formXML.id != null && formXML.id != ""){
					worklistServiceEvent.formModel = FormDocument.parseXML(formXML);
				}				
				this.loadFormCallback(worklistServiceEvent);
			}	
		}
		
		// 작업을 불러올 때 결과처리
		private function loadRefResult(event:Event):void{
			var workitemXML:XML = XML(this.loadRefLoader.data);
			var worklistServiceEvent:WorklistServiceEvent;		
			if(workitemXML.@status == "Failed"){
				worklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
				worklistServiceEvent.msg = "작업 불러오기에 실패했습니다.\n (" + workitemXML.message + ")";
				this.faultCallback(worklistServiceEvent);
			}else{
				worklistServiceEvent = new WorklistServiceEvent(WorklistServiceEvent.SUCESS_LOAD_REF);
				worklistServiceEvent.msg = "작업 불러오기를 완료했습니다.\n (" + workitemXML.message + ")";
				worklistServiceEvent.workitemXML = workitemXML;
				this.loadRefCallback(worklistServiceEvent);
			}	
		}
		
		// 서비스가 실패한 경우에 처리
		private function serviceFault(event:Event):void{
			var worklistServiceEvent:WorklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
			if(event.type == IOErrorEvent.IO_ERROR){
				worklistServiceEvent.msg = "인터넷이 연결되어 있지 않거나 Smart BPMS 서버가 정상적으로 작동하지 않고 있습니다.\n 인터넷 연결을 확인한 후에 이상이 없으면 IT운영부서로 연락바랍니다.";
			}else{
				worklistServiceEvent.msg = "Smart BPMS 서버와 연결하던 중 보안문제가 발생했습니다. IT운영부서로 연락바랍니다.";
			}
			this.faultCallback(worklistServiceEvent);
		}
		
				// 서비스가 실패한 경우에 처리
		private function serviceInvoke(event:Event):void{
			var worklistServiceEvent:WorklistServiceEvent = new WorklistServiceEvent(ServiceEvent.FAIL);
			if(event.type == IOErrorEvent.IO_ERROR){
				worklistServiceEvent.msg = "인터넷이 연결되어 있지 않거나 Smart BPMS 서버가 정상적으로 작동하지 않고 있습니다.\n 인터넷 연결을 확인한 후에 이상이 없으면 IT운영부서로 연락바랍니다.";
			}else{
				worklistServiceEvent.msg = "Smart BPMS 서버와 연결하던 중 보안문제가 발생했습니다. IT운영부서로 연락바랍니다.";
			}
			this.faultCallback(worklistServiceEvent);
		}
	}
}