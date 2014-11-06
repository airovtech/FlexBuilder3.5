/**
 * 
 *  Package: 		com.maninsoft.smart.formeditor.refactor.service.impl
 *  Class: 			ServerWorkTypeService
 * 					extends None
 * 					implements None
 *  Author:			Maninsoft, Inc.
 *  Description:	Form Editor에서 Work Type에 관하여  서버에 요청하는 모든 서비스들을 구현한 클래스
 * 				
 *  History:		Created by Maninsoft, Inc.
 * 					2010.3.2 Modified by Y.S. Jung for SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
 * 
 *  Copyright (C) 2007-2010 Maninsoft, Inc. All Rights Reserved.
 *  
 */

package com.maninsoft.smart.formeditor.refactor.service.impl
{
	import com.maninsoft.smart.formeditor.refactor.event.service.ServiceEvent;
	import com.maninsoft.smart.formeditor.refactor.event.service.WorkTypeEvent;
	import com.maninsoft.smart.workbench.common.meta.impl.SWWorkType;
	import com.maninsoft.smart.workbench.common.meta.impl.SWWorkTypeMapping;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.http.HTTPService;
	
	public class ServerWorkTypeService
	{
		// 폼 서비스를 하는 url
		private var serviceUrl:String;
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		// 현재 사용자의 회사이름
		private var compId:String;
		// 현재 사용자의 아이디
		private var userId:String;
		
		// 저장을 위하여 서버의 서비스를 호출하는 서비스
		private var saveWorkTypeMappingReq:HTTPService;
		// 폼 저장이 완료되면 callback 되는 함수
		private var saveWorkTypeMappingCallback:Function;
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadCallback:Function;		
		
		// 로드를 위하여 서버의 서비스를 요청하는 변수
		private var loadMappingReq:URLRequest;
		// 폼이 로드되는 변수
		private var loadMappingLoader:URLLoader;
		// 폼 로드가완료되면 callback 되는 함수
		private var loadMappingCallback:Function;	
		
		// 폼 서비스가 실패하면 callback 되는 함수
		private var faultCallback:Function;
		
		private var formId:String;
		private var version:int;
		
		private var swWorkType:SWWorkType;
		
		/**
		 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
		 * 	2010.3.2 Added by Y.S. Jung
		 */
		public function ServerWorkTypeService(serviceUrl:String, compId:String, userId:String)
		{
			this.serviceUrl = serviceUrl;
			this.compId = compId;
			this.userId = userId;
			
			this.saveWorkTypeMappingReq = new HTTPService();
			this.saveWorkTypeMappingReq.url = this.serviceUrl;
			this.saveWorkTypeMappingReq.method = "POST";
			
			this.loadReq = new URLRequest();
			this.loadLoader = new URLLoader();
			this.loadLoader.addEventListener(Event.COMPLETE, loadResult);
			this.loadLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
			
			this.loadMappingReq = new URLRequest();
			this.loadMappingLoader = new URLLoader();
			this.loadMappingLoader.addEventListener(Event.COMPLETE, loadMappingResult);
			this.loadMappingLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceFault);
			this.loadMappingLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, serviceFault);
		}
		
		public function load(formId:String, version:int, callBack:Function, fault:Function):void{
			this.loadCallback = callBack;
			this.faultCallback = fault;
			
			this.formId = formId;
			this.version = version;

			this.loadReq.url = this.serviceUrl + "?method=loadWorkType&userId=" + this.userId + "&formId=" + formId + "&version=" + version;
			this.loadLoader.load(this.loadReq);
		}
		
		public function loadMapping(swWorkType:SWWorkType, callBack:Function, fault:Function):void{
			this.loadMappingCallback = callBack;
			this.faultCallback = fault;
			
			this.swWorkType = swWorkType;

			this.loadMappingReq.url = this.serviceUrl + "?method=getWorkTypeMappingList&userId=" + this.userId + "&workTypeId=" + swWorkType.id;
			this.loadMappingLoader.load(this.loadMappingReq);
		}
		
		public function saveMapping(swWorkType:SWWorkType, callBack:Function, fault:Function):void{
			this.saveWorkTypeMappingCallback = callBack;
			this.faultCallback = fault;
						
			var reqParameter:Object = new Object();

			reqParameter["method"] = "saveWorkTypeMappingList";
			/**
			 *  SWV20002: SAAS버전을 위해 모든 서비스호출에 compId 추가
			 * 	2010.3.2 Added by Y.S. Jung
			 */
			reqParameter["compId"] = this.compId;			
			reqParameter["userId"] = this.userId;			
			reqParameter["workTypeId"] = swWorkType.id;
			
			var workTypeMappingListContent:XML = <WorkTypeMappingList></WorkTypeMappingList>;
			for each(var workTypeMapping:SWWorkTypeMapping in swWorkType.mappings){
				workTypeMappingListContent.appendChild(workTypeMapping.toXML());
			}
			reqParameter["workTypeMappingListContent"] = workTypeMappingListContent.toXMLString();
			
			
			this.saveWorkTypeMappingReq.send(reqParameter);	
		}
		
				// 폼을 불러올 때 결과처리
		private function loadResult(event:Event):void{
			var workTypeXML:XML = XML(this.loadLoader.data);
			var resultEvent:WorkTypeEvent;	
			if(workTypeXML.@status == "Failed"){
				resultEvent = new WorkTypeEvent(ServiceEvent.FAIL);
				resultEvent.msg = "워크타입 불러오기에 실패했습니다.\n (" + workTypeXML.message + ")";
				this.faultCallback(resultEvent);
			}else{
				resultEvent = new WorkTypeEvent(WorkTypeEvent.SUCESS_LOAD);
				resultEvent.msg = "워크타입 불러오기를 완료했습니다.\n (" + workTypeXML.message + ")";
				if(workTypeXML.WorkType[0].id.toString() != ""){
					resultEvent.swWorkType = SWWorkType.parseXML(workTypeXML.WorkType[0]);
				}
				this.loadCallback(resultEvent);
			}	
		}
		
		private function loadMappingResult(event:Event):void{
			var mappingXML:XML = XML(this.loadMappingLoader.data);
			var resultEvent:WorkTypeEvent;	
			if(mappingXML.@status == "Failed"){
				resultEvent = new WorkTypeEvent(ServiceEvent.FAIL);
				resultEvent.msg = "맵핑 불러오기에 실패했습니다.\n (" + mappingXML.message + ")";
				this.faultCallback(resultEvent);
			}else{
				resultEvent = new WorkTypeEvent(WorkTypeEvent.SUCESS_LOAD);
				resultEvent.msg = "맵핑 불러오기를 완료했습니다.\n (" + mappingXML.message + ")";
				this.swWorkType.mappings.removeAll();
				for each(var workTypeMappingXML:XML in mappingXML.WorkTypeMapping){
					var mapping:SWWorkTypeMapping = SWWorkTypeMapping.parseXML(workTypeMappingXML);
					this.swWorkType.mappings.addItem(mapping);
				}
				resultEvent.swWorkType = this.swWorkType;
				this.loadMappingCallback(resultEvent);
			}	
		}
		
		// 서비스가 실패한 경우에 처리
		private function serviceFault(event:Event):void{
			var resultEvent:WorkTypeEvent = new WorkTypeEvent(ServiceEvent.FAIL);
			if(event.type == IOErrorEvent.IO_ERROR){
				resultEvent.msg = "인터넷이 연결되어 있지 않거나 Smart BPMS 서버가 정상적으로 작동하지 않고 있습니다.\n 인터넷 연결을 확인한 후에 이상이 없으면 IT운영부서로 연락바랍니다.";
			}else{
				resultEvent.msg = "Smart BPMS 서버와 연결하던 중 보안문제가 발생했습니다. IT운영부서로 연락바랍니다.";
			}
			this.faultCallback(resultEvent);
		}	

	}
}