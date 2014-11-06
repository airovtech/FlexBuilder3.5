package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.workbench.common.model.WorkCategory;
	import com.maninsoft.smart.workbench.common.model.WorkPackage;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 작업 폼 목록을 내려받는 서비스
	 */
	public class GetPackageListService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var categoryId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _packages: Array;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetPackageListService(parentId:String) {
			super("retrievePackageByCategoryId");
			this.categoryId = parentId;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * forms
		 */
		public function get packages(): Array{
			return _packages;
		}


		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.categoryId = categoryId;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_packages = [];
			
			for each (var x: XML in xml.workPackage) {
				var workPackage: WorkPackage = new WorkPackage();
				workPackage.parseXML(x);
				_packages.push(workPackage);	
			}
			
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetPackageListServce: " + event);
			
			super.doFault(event);
		}
	}
}