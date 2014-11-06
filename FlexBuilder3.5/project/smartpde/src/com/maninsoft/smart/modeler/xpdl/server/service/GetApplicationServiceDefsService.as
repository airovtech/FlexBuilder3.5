package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.model.process.FormalParameter;
	import com.maninsoft.smart.modeler.xpdl.server.ApplicationService;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 모든 사용자를 가져오는 서비스
	 */
	public class GetApplicationServiceDefsService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _applicationServices: Array /* of User */;


		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetApplicationServiceDefsService() {
			super("webAppServiceList");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * approvalLines
		 */
		public function get applicationServices(): Array /* of SystemService */ {
			return _applicationServices;
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
			_applicationServices = [];
			
			var applicationService:ApplicationService;
			for each (var x: XML in xml.webAppServiceList.webAppService) {
				applicationService = new ApplicationService();

				applicationService.id			= x.@objId;
				applicationService.name			= x.@webAppServiceName;
				applicationService.url			= x.@webAppServiceUrl;
				applicationService.editMethod	= x.@modifyMethod;
				applicationService.viewMethod	= x.@viewMethod;
				applicationService.editParams 	= [];
				for each(var e:XML in x.webAppServiceModifyParameters.webAppServiceModifyParameter){
					var editParam: FormalParameter = new FormalParameter(applicationService);
					editParam.id 		= e.@modifyName;
					editParam.name 		= e.@modifyVariableName;
					editParam.dataType 	= e.@modifyType;
					applicationService.editParams.push(editParam);
				}
				applicationService.viewParams 	= [];
				for each(var v:XML in x.webAppServiceViewParameters.webAppServiceViewParameter){
					var viewParam: FormalParameter = new FormalParameter(applicationService);
					viewParam.id 		= v.@viewName;
					viewParam.name 		= v.@viewVariableName;
					viewParam.dataType 	= v.@viewType;
					applicationService.viewParams.push(viewParam);
				}
				applicationService.returnParams 	= [];
				for each(var r:XML in x.webAppServiceReturnParameters.webAppServiceReturnParameter){
					var returnParam: FormalParameter = new FormalParameter(applicationService);
					returnParam.id 		= r.@returnName;
					returnParam.name 	= r.@returnVariableName;
					returnParam.dataType= r.@returnType;
					applicationService.returnParams.push(returnParam);
				}
				applicationService.description 	= x.description;
				_applicationServices.push(applicationService);	
			}
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetApplicationServiceDefsService: " + event);
			
			super.doFault(event);
		}
	}
}