package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.workbench.common.meta.impl.SWPackage;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * 작업 폼 목록을 내려받는 서비스
	 */
	public class GetFullPackageService extends ServiceBase
	{
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		public var packageId: String;
		public var version: String;
		
		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _swPackage: SWPackage;

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetFullPackageService(packageId:String, version:String) {
			super("loadFullPackage");
			this.packageId = packageId;
			this.version = version;
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		public function get swPackage(): SWPackage{
			return _swPackage;
		}

		//----------------------------------------------------------------------
		// Overriden methods
		//----------------------------------------------------------------------

		override protected function get params(): Object {
			var obj: Object = new Object();
			
			obj.compId = compId;
			obj.userId = userId;
			obj.packageId = packageId;
			obj.version = version;
			
			return obj;
		}
		
		override protected function doResult(event:ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			_swPackage = new SWPackage();
			_swPackage = SWPackage.parseXML(xml.fullPackage[0]);
			super.doResult(event);
		}
		
		override protected function doFault(event:FaultEvent): void {
			trace("GetFullPackageServce: " + event);
			
			super.doFault(event);
		}
	}
}