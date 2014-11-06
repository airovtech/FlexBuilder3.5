/**
 * 
 *  Package: 		com.maninsoft.smart.workbench.service.impl
 *  Class: 			ServerRepositoryServiceImpl
 * 					Implements IRepositoryService
 *  Author:			Maninsoft, Inc.
 *  Description:	Process Diagram Editor에서 서버로 요청하는 모든 서비스들을 구현한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
 * 
 *  Copyright (C) 2007-2009 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.workbench.service.impl
{
	import com.maninsoft.smart.modeler.xpdl.server.service.ServiceBase;
	import com.maninsoft.smart.workbench.common.meta.impl.SWForm;
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	import com.maninsoft.smart.workbench.common.meta.impl.SWProcess;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	import com.maninsoft.smart.workbench.event.MISPackageEvent;
	import com.maninsoft.smart.workbench.service.IRepositoryService;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ServerRepositoryServiceImpl implements IRepositoryService
	{
		private var serviceUrl:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		private var compId:String;
		private var userId:String;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadCallback:Function;
		
		// 폼 서비스가 실패하면 callback 되는 함수
		private var faultCallback:Function;
		
		// 프로세스 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var addPrcReq:HTTPService;
		// 프로세스 추가가 완료되면 callback 되는 함수
		private var addPrcCallback:Function;
		
		// 폼 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var addFormReq:HTTPService;
		// 폼 추가가 완료되면 callback 되는 함수
		private var addFormCallback:Function;
		
		// 프로세스 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var removePrcReq:HTTPService;
		// 프로세스 추가가 완료되면 callback 되는 함수
		private var removePrcCallback:Function;
		
		// 폼 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var removeFormReq:HTTPService;
		// 폼 추가가 완료되면 callback 되는 함수
		private var removeFormCallback:Function;
		
		// 프로세스 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var savePrcReq:HTTPService;
		// 프로세스 추가가 완료되면 callback 되는 함수
		private var savePrcCallback:Function;
		// 프로세스 이름을 변경하는 서비스
		private var renameProcessReq:HTTPService;
		
		// 프로세스 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var deployReq:HTTPService;
		// 프로세스 추가가 완료되면 callback 되는 함수
		private var deployCallback:Function;
		
		// 폼 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var saveFormReq:HTTPService;
		// 폼 추가가 완료되면 callback 되는 함수
		private var saveFormCallback:Function;

		// 폼 추가를 위하여 서버의 서비스를 호출하는 서비스
		private var renameFormReq:HTTPService;
		// 폼 추가가 완료되면 callback 되는 함수
		private var renameFormCallback:Function;
		
		// 폼 복사를 위하여 서버의 서비스를 호출하는 서비스
		private var cloneFormReq:HTTPService;
		// 폼 복사가 완료되면 callback 되는 함수
		private var cloneFormCallback:Function;
		
		//폼의 타입을 변경하기 위한 서비스
		private var formTypeChangeReq:HTTPService;
				
		private var swPack:SWPackage;
		private var swProcess:SWProcess;
		private var swForm:SWForm;
		
		//패키지 체크인 위한 서비스
		private var packCheckIn:HTTPService;
		
		//패키지 체크인 위한 서비스
		private var packCheckInCallBack:Function;
		
		//패키지 체크아웃 위한 서비스
		private var packCheckOut:HTTPService;
		
		//패키지 체크인 위한 서비스
		private var packCheckOutCallBack:Function;
		
		private var resourceManager:IResourceManager = ResourceManager.getInstance();
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function ServerRepositoryServiceImpl(serviceUrl:String, compId:String, userId:String){
			
			this.serviceUrl = serviceUrl;
			this.compId = compId;
			this.userId = userId;
			
			this.loadReq = new URLRequest();
			this.loadLoader = new URLLoader();
			
			this.loadLoader.addEventListener(Event.COMPLETE, loadResult);
			this.loadLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.addPrcReq = new HTTPService();
			this.addPrcReq.method = "POST";
			this.addPrcReq.url = this.serviceUrl;
			this.addPrcReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.addPrcReq.addEventListener(ResultEvent.RESULT, addProcessResult);
			
			this.addFormReq = new HTTPService();
			this.addFormReq.method = "POST";
			this.addFormReq.url = this.serviceUrl;
			this.addFormReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.addFormReq.addEventListener(ResultEvent.RESULT, addFormResult);
			
			this.removePrcReq = new HTTPService();
			this.removePrcReq.method = "POST";
			this.removePrcReq.url = this.serviceUrl;
			this.removePrcReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.removePrcReq.addEventListener(ResultEvent.RESULT, removeProcessResult);
			
			this.removeFormReq = new HTTPService();
			this.removeFormReq.method = "POST";
			this.removeFormReq.url = this.serviceUrl;
			this.removeFormReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.removeFormReq.addEventListener(ResultEvent.RESULT, removeFormResult);
			
			this.savePrcReq = new HTTPService();
			this.savePrcReq.method = "POST";
			this.savePrcReq.url = this.serviceUrl;
			this.savePrcReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.savePrcReq.addEventListener(ResultEvent.RESULT, saveProcessResult);
			
			this.renameProcessReq = new HTTPService();
			this.renameProcessReq.method = "POST";
			this.renameProcessReq.url = this.serviceUrl;
			this.renameProcessReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.renameProcessReq.addEventListener(ResultEvent.RESULT, renameProcessResult);
			
			this.deployReq = new HTTPService();
			this.deployReq.method = "POST";
			this.deployReq.url = this.serviceUrl;
			this.deployReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.deployReq.addEventListener(ResultEvent.RESULT, deployResult);
			
			this.saveFormReq = new HTTPService();
			this.saveFormReq.method = "POST";
			this.saveFormReq.url = this.serviceUrl;
			this.saveFormReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.saveFormReq.addEventListener(ResultEvent.RESULT, saveFormResult);		
			
			this.renameFormReq = new HTTPService();
			this.renameFormReq.method = "POST";
			this.renameFormReq.url = this.serviceUrl;
			this.renameFormReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.renameFormReq.addEventListener(ResultEvent.RESULT, renameFormResult);	
			
			this.cloneFormReq = new HTTPService();
			this.cloneFormReq.method = "POST";
			this.cloneFormReq.url = this.serviceUrl;
			this.cloneFormReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;
			
			this.cloneFormReq.addEventListener(ResultEvent.RESULT, cloneFormResult);	
			
			this.formTypeChangeReq = new HTTPService();
			this.formTypeChangeReq.method = "POST";
			this.formTypeChangeReq.url = this.serviceUrl;
			this.formTypeChangeReq.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;

			this.formTypeChangeReq.addEventListener(ResultEvent.RESULT, formTypeChangeResult);	
			
			this.packCheckIn = new HTTPService();
			this.packCheckIn.method = "POST";
			this.packCheckIn.url = this.serviceUrl;
			this.packCheckIn.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;

			this.packCheckIn.addEventListener(ResultEvent.RESULT, checkInResult);		
			
			this.packCheckOut = new HTTPService();
			this.packCheckOut.method = "POST";
			this.packCheckOut.url = this.serviceUrl;
			this.packCheckOut.requestTimeout = ServiceBase.HTTP_REQUEST_TIMEOUT;

			this.packCheckOut.addEventListener(ResultEvent.RESULT, checkOutResult);			
		}

		// 패키지를 로드 
		public function retrievePackage(packId:String, packVer:int, resultHandler:Function, faultHandler:Function):void{
			this.loadCallback = resultHandler;
			this.faultCallback = faultHandler;
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			this.loadReq.url = this.serviceUrl + "?method=loadFullPackage&compId=" + this.compId + "&userId=" + this.userId + "&packageId=" + packId + "&version=" + packVer;
			this.loadLoader.load(this.loadReq);
		}
		// 구조까지 포함한 모든 패키지 정보를 저장
		public function savePackage(pack:SWPackage, resultHandler:Function, faultHandler:Function):void{
		}
		
		// 프로세스 추가
		public function addProcess(swPack:SWPackage, processName:String, resultHandler:Function, faultHandler:Function):void{
			this.addPrcCallback = resultHandler;
			this.faultCallback = faultHandler;

			var reqParameter:Object = new Object();

			reqParameter["method"] = "createProcess";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = swPack.id;
			reqParameter["version"] = swPack.version;
			reqParameter["processName"] = processName;
			
			this.addPrcReq.send(reqParameter);
		}
		// 폼 추가
		public function addForm(swPack:SWPackage, formName:String, resultHandler:Function, faultHandler:Function):void{
			this.addFormCallback = resultHandler;
			this.faultCallback = faultHandler;

			var reqParameter:Object = new Object();

			reqParameter["method"] = "createForm";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = swPack.id;
			reqParameter["version"] = swPack.version;
			reqParameter["formName"] = formName;
			
			this.addFormReq.send(reqParameter);
		}
		
		// 프로세스 삭제
		public function removeProcess(swPack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void{
			this.removePrcCallback = resultHandler;
			this.faultCallback = faultHandler;
			
			this.swPack = swPack;
			this.swProcess = swProcess;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "deleteProcess";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = swPack.id;
			reqParameter["version"] = swPack.version;
			reqParameter["processId"] = swProcess.id;
			
			this.removePrcReq.send(reqParameter);
		}
		// 폼 삭제
		public function removeForm(swPack:SWPackage, swForm:SWForm, resultHandler:Function, faultHandler:Function):void{
			this.removeFormCallback = resultHandler;
			this.faultCallback = faultHandler;

			this.swPack = swPack;
			this.swForm = swForm;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "deleteForm";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = swPack.id;
			reqParameter["version"] = swPack.version;
			reqParameter["formId"] = swForm.id;
			
			this.removeFormReq.send(reqParameter);
		}

		// 프로세스 저장
		public function saveProcess(pack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void{
			this.savePrcCallback = resultHandler;
			this.faultCallback = faultHandler;
			
			this.swPack = swPack;
			this.swProcess = swProcess;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "saveProcessMeta";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["processId"] = swProcess.id;
			reqParameter["version"] = swProcess.version;
			reqParameter["name"] = swProcess.name;
			reqParameter["keyword"] = swProcess.keyword;
			reqParameter["ownerDept"] = swProcess.ownerDept;
			reqParameter["owner"] = swProcess.owner;
			reqParameter["description"] = swProcess.description;
			
			this.savePrcReq.send(reqParameter);
		}
		
		// 프로세스 삭제
		public function renameProcess(pack:SWPackage, swProcess:SWProcess, resultHandler:Function, faultHandler:Function):void{
			this.savePrcCallback = resultHandler;
			this.faultCallback = faultHandler;
			
			this.swPack = swPack;
			this.swProcess = swProcess;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "renameProcess";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["processId"] = swProcess.id;
			reqParameter["version"] = swProcess.version;
			reqParameter["processName"] = swProcess.name;
			
			this.renameProcessReq.send(reqParameter);
		}

		// 폼 저장
		public function saveForm(pack:SWPackage, swForm:SWForm, resultHandler:Function, faultHandler:Function):void{
			this.saveFormCallback = resultHandler;
			this.faultCallback = faultHandler;

			this.swPack = swPack;
			this.swForm = swForm;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "saveForm";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["formId"] = swForm.id;
			reqParameter["version"] = swForm.version;
			reqParameter["name"] = swForm.name;
			reqParameter["keyword"] = swForm.keyword;
			reqParameter["ownerDept"] = swForm.ownerDept;
			reqParameter["owner"] = swForm.owner;
			reqParameter["description"] = swForm.description;
			reqParameter["type"] = swForm.formType;
			
			this.saveFormReq.send(reqParameter);
		}	
		
		private var formName:String;
		// 폼 이름변경
		public function renameForm(swForm:SWForm, formName:String, resultHandler:Function, faultHandler:Function):void{
			this.renameFormCallback = resultHandler;
			this.faultCallback = faultHandler;

			var reqParameter:Object = new Object();

			reqParameter["method"] = "renameForm";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["formId"] = swForm.id;
			reqParameter["version"] = swForm.version;
			reqParameter["formName"] = formName;
			
			this.swForm = swForm;
			this.formName = formName;
			
			this.renameFormReq.send(reqParameter);
		}
		
		public function cloneForm(pack:SWPackage, swForm:SWForm, newFormName:String, resultHandler:Function, faultHandler:Function):void{
			this.cloneFormCallback = resultHandler;
			this.faultCallback = faultHandler;

			var reqParameter:Object = new Object();

			reqParameter["method"] = "cloneForm";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["toPackageId"] = pack.id;
			reqParameter["toVersion"] = swForm.version;
			reqParameter["formId"] = swForm.id;
			reqParameter["version"] = swForm.version;
			reqParameter["newFormName"] = newFormName;
			
			this.swForm = swForm;
			this.swPack = pack;
			
			this.cloneFormReq.send(reqParameter);
		}
		
		// 폼 타입변경
		public function formTypeChange(formId:String, version:String, type:String, resultHandler:Function, faultHandler:Function):void{
			this.saveFormCallback = resultHandler;
			this.faultCallback = faultHandler;
			var reqParameter:Object = new Object();

			reqParameter["method"] = "changeFormType";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["formId"] = formId;
			reqParameter["version"] = version;
			reqParameter["type"] = type;
			
			this.formTypeChangeReq.send(reqParameter);
		}	
		
		// 디플로이
		public function deploy(pack:SWPackage, resultHandler:Function, faultHandler:Function):void{
			this.deployCallback = resultHandler;
			this.faultCallback = faultHandler;
			
			this.swPack = pack;
			
			var reqParameter:Object = new Object();

			reqParameter["method"] = "deployPackage";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = pack.id;
			reqParameter["version"] = pack.version;
			
			this.deployReq.send(reqParameter);
		}
		
		public function checkIn(packId:String, packVer:int, resultHandler:Function):void{
			this.packCheckInCallBack = resultHandler;
			var reqParameter:Object = new Object();
			reqParameter["method"] = "checkInPackage";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = packId;
			reqParameter["version"] = packVer+"";
			
			this.packCheckIn.send(reqParameter);
		}
		
		public function checkOut(packId:String, packVer:int, resultHandler:Function):void{
			this.packCheckOutCallBack = resultHandler;
			var reqParameter:Object = new Object();
			reqParameter["method"] = "checkOutPackage";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = compId;
			reqParameter["userId"] = userId;
			reqParameter["packageId"] = packId;
			reqParameter["version"] = packVer+"";
			
			this.packCheckOut.send(reqParameter);
		}
				
		// 폼을 불러올 때 결과처리
		private function loadResult(event:Event):void{
			var packXML:XML = XML(this.loadLoader.data);
			var packEvent:MISPackageEvent;	
			if(packXML.@status == "Failed"){
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE004" );
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}else{
				try{
					packEvent = new MISPackageEvent(MISPackageEvent.LOAD_PACKAGE, SWPackage.parseXML(packXML.fullPackage[0]));
					this.loadCallback(packEvent);
				}catch(e:Error){}
			}	
		}
		
		// 프로세스를 추가했을 때 결과처리
		private function addProcessResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				var swProcess:SWProcess = SWProcess.parseXML(XML(event.message.body).Process[0]);
				packEvent.swProcess = swProcess;
				this.addPrcCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE005" );
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}

		// 프로세스를 추가했을 때 결과처리
		private function addFormResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				var swForm:SWForm = SWForm.parseXML(XML(event.message.body).Form[0]);
				packEvent.swForm = swForm;
				this.addFormCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE006");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}

		// 프로세스를 추가했을 때 결과처리
		private function renameFormResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				swForm.name = formName;
				this.renameFormCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE007");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}
				
		// 화면 복사를했을 때 결과처리
		private function cloneFormResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				var swForm:SWForm = SWForm.parseXML(XML(event.message.body).Form[0]);
				packEvent.swForm = swForm;
				this.cloneFormCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE008");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}
				
		// 프로세스를 추가했을 때 결과처리
		private function removeProcessResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				swPack.clearProcessResource();
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				packEvent.swProcess = swProcess;
				this.removePrcCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE009");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}

		// 프로세스를 추가했을 때 결과처리
		private function removeFormResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				swPack.removeFormResource(swForm);
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				this.removeFormCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE010");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}	
		}
		
		// 프로세스를 추가했을 때 결과처리
		private function saveProcessResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				packEvent.swProcess = swProcess;
				this.savePrcCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE011");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}	
		}
		
		// 프로세스를 추가했을 때 결과처리
		private function renameProcessResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				packEvent.swProcess = swProcess;
				this.savePrcCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE012");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}
		
		private function deployResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				this.deployCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE013");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}				
		}

		// 프로세스를 추가했을 때 결과처리
		private function saveFormResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				this.saveFormCallback(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE014");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}	
		}	
		
		// 체크인 했을 때 결과처리
		private function checkInResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				this.packCheckInCallBack(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE015");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}
		}	
		
		// 체크아웃 했을 때 결과처리
		private function checkOutResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
			if(event.result["Result"]["status"] == "OK"){
				packEvent = new MISPackageEvent(MISPackageEvent.SUCESS, null);				
				this.packCheckOutCallBack(packEvent);
			}else{
				packEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE016");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}	
		}			
				
		// 프로세스를 추가했을 때 결과처리
		private function formTypeChangeResult(event:ResultEvent):void{
			var packEvent:MISPackageEvent;
		}	
				
		// 서비스가 실패한 경우에 처리
		private function serviceFault(event:Event):void{
			MsgUtil.showMsg(event.toString());
			var packEvent:MISPackageEvent = new MISPackageEvent(MISPackageEvent.FAULT, null);
			if(event.type == IOErrorEvent.IO_ERROR){
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE017");
				this.faultCallback(packEvent);
			}else{
				packEvent.msg = resourceManager.getString("WorkbenchMessages", "WBE018");
				if(this.faultCallback != null)
					this.faultCallback(packEvent);
				else
					MsgUtil.showError(packEvent.msg);
			}			
		}
	}
}