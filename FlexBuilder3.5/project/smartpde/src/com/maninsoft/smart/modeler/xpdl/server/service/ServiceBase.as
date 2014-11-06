////////////////////////////////////////////////////////////////////////////////
//  ServiceBase.as
//  2008.01.30, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.common.AlertUtils;
	import com.maninsoft.smart.workbench.common.util.MsgUtil;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	import mx.utils.StringUtil;
	
	
	/**
	 * SeriveBase
	 */
	public class ServiceBase {
		
		public static const HTTP_REQUEST_TIMEOUT:int = 30;
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------
		
		private var _resourceManager:IResourceManager;

		private var _serviceUrl: String;
		private var _method: String;
		private var _resultHandler: Function;
		private var _faultHandler: Function;
		private var _data: Object;
		private var _service: HTTPService;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function ServiceBase(method: String)	{
			super();

			this._resourceManager = ResourceManager.getInstance();
			
			_method = method;
		}

		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------
		
		public function get resourceManager():IResourceManager{
			if(_resourceManager==null)
				_resourceManager = ResourceManager.getInstance();
			return _resourceManager;
		}

		/**
		 * serviceUrl
		 */
		public function get serviceUrl(): String {
			return _serviceUrl;
		}
		
		public function set serviceUrl(value: String): void {
			_serviceUrl = value;
		}
		
		/**
		 * method
		 */
		public function get method(): String {
			return _method;
		}
		
		public function set method(value: String): void {
			_method = value;
		}
		
		/**
		 * resultHandler
		 */
		public function get resultHandler(): Function {
			return _resultHandler;
		}
		
		public function set resultHandler(value: Function): void {
			_resultHandler = value;
		}
		
		/**
		 * faultHandler
		 */
		public function get faultHandler(): Function {
			return _faultHandler;
		}
		
		public function set faultHandler(value: Function): void {
			_faultHandler = value;
		}
		
		/**
		 * 서비스 호출후 비동기 결과 핸들러에서 참조할 수 있도록 
		 * 호출 전에 설정할 수 있는 임의의 데이터
		 */
		public function get data(): Object {
			return _data;
		}
		
		public function set data(value: Object): void {
			_data = value;
		}
		
		/**
		 * resultString
		 */
		public function get resultString(): String {
			return _service ? _service.lastResult.toString() : "";
		}
		
		/**
		 * resultXml
		 */
		public function get resultXml(): XML {
			return _service ? new XML(_service.lastResult.toString()) : null;
		}

		//----------------------------------------------------------------------
		// Methods
		//----------------------------------------------------------------------
		
		public function send(): void {
			_service = new HTTPService();
			_service.url = serviceUrl + "?method=" + method;
			_service.method = "POST";
			_service.contentType = "application/x-www-form-urlencoded"; //HTTPService.CONTENT_TYPE_FORM;
			_service.resultFormat = "text"; //HTTPService.RESULT_FORMAT_TEXT
			_service.requestTimeout = HTTP_REQUEST_TIMEOUT;
			_service.showBusyCursor = true;
			
			_service.addEventListener(ResultEvent.RESULT, doResult);
			_service.addEventListener(FaultEvent.FAULT, doFault);
			_service.send(params);
		}
		

		//----------------------------------------------------------------------
		// Virtutal properties
		//----------------------------------------------------------------------
		
		/**
		 * 서비스 호출 시 전달될 매개변수를 지정한다.
		 * 매개변수가 존재하면 override해야 한다.
		 * 
		 * ex) var obj: Object = new Object();
		 *     obj.key = value;
		 * 	   return obj;
		 */
		protected function get params(): Object {
			return null;
		}

		
		//----------------------------------------------------------------------
		// Virtutal methods
		//----------------------------------------------------------------------

		/**
		 * override해야 한다.
		 */
		protected function doResult(event: ResultEvent): void {
			if (resultHandler != null)
				resultHandler(this);
		}

		protected function doFault(event: FaultEvent): void {
			if (faultHandler != null)
				faultHandler(this, event);
			else
				MsgUtil.showError( resourceManager.getString("WorkbenchMessages", "WBE003") + "[FAULT:" + event.fault.faultString + "]");
		}

		
		//----------------------------------------------------------------------
		// Internal methods
		//----------------------------------------------------------------------

		/**
		 * 서버로부터의 결과 응답 xml의 루트 엘리먼트의 status 속성이 'OK' 가 아니면
		 * 서버쪽 로직 에러이다. 간단한 메시지는 message 엘리먼트에 담겨온다.
		 * 
		 * <result status="OK"/>
		 * <result status="Failed">
		 * 	<message>message</message>
		 *  <trace><![CDATA[trace]]></trace>
		 * </result>
		 */ 		
		protected function checkOK(event: ResultEvent): void {
			trace(event);
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			
			if (xml.@status != "OK") {
				throw Error(xml.message);
			}
		}
		
		protected function checkResultAndShow(event: ResultEvent, title: String = null, msg: String = null): void {
			try {
				checkOK(event);
				
				if (title || msg) {
					AlertUtils.info(msg, title);
				}
				
			} catch (err: Error) {
				AlertUtils.error(err.message, resourceManager.getString("WorkbenchETC", "errorText") + (title ? ("- " + title) : ""));
			}
		}
	}
}