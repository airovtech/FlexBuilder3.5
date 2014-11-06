package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.formeditor.model.SystemService;
	import com.maninsoft.smart.formeditor.model.SystemServiceParameter;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 모든 사용자를 가져오는 서비스
	 */
	public class GetSystemServiceDefsService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _systemServices: Array /* of User */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetSystemServiceDefsService() {
			super("webServiceList");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * approvalLines
		 */
		public function get systemServices(): Array /* of SystemService */ {
			return _systemServices;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_systemServices = [];
			
			for each (var x: XML in xml.webServiceList.webService) {
				var systemService: SystemService = new SystemService();

				systemService.id			= x.@objId;
				systemService.name			= x.@webServiceName;
				systemService.wsdlUli		= x.@wsdlAddress;
				systemService.port			= x.@portName;
				systemService.operation		= x.@operationName;
				systemService.messageIn 	= [];
				for each(var i:XML in x.webServiceInputParameters.webServiceInputParameter){
					var systemServiceParameter: SystemServiceParameter = new SystemServiceParameter();
					systemServiceParameter.id 			= i.@inputName;
					systemServiceParameter.name 		= i.@inputVariableName;
					systemServiceParameter.serviceId 	= systemService.id;
					systemServiceParameter.elementName 	= i.@inputName;
					systemServiceParameter.elementType 	= i.@inputType;
					systemService.messageIn.push(systemServiceParameter);
				}
				systemService.messageOut	= [];
				for each(var o:XML in x.webServiceOutputParameters.webServiceOutputParameter){
					systemServiceParameter = new SystemServiceParameter();
					systemServiceParameter.id 			= o.@outputName;
					systemServiceParameter.name 		= o.@outputVariableName;
					systemServiceParameter.serviceId 	= systemService.id;
					systemServiceParameter.elementName 	= o.@outputName;
					systemServiceParameter.elementType 	= o.@outputType;
					systemService.messageOut.push(systemServiceParameter);
				}
				systemService.description 	= x.description;
				_systemServices.push(systemService);	
			}
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetSystemServiceDefsService: " + event);
			
			super.doFault(event);
		}
	}
}