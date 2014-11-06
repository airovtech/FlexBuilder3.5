////////////////////////////////////////////////////////////////////////////////
//  GetProcessInfoByPackageService.as
//  2008.04.26, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.ProcessInfo;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * package id로 프로세스 정보 가져오는 서비스
	 */
	public class GetProcessInfoByPackageService extends ServiceBase {
		
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
		
		private var _process: ProcessInfo;
		

		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetProcessInfoByPackageService() {
			super("getProcessInfoByPackage");
		}


		//----------------------------------------------------------------------
		// Properties 
		//----------------------------------------------------------------------

		public function get process(): ProcessInfo {
			return _process;
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
		
		override protected function doResult(event: ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			
			if (xml.Process.length() > 0) {
				_process = new ProcessInfo(); 

				_process.processId = xml.Process.processId.toString();	
				_process.packageId = xml.Process.packageId.toString();	
				_process.version = xml.Process.version.toString();	
				_process.name = xml.Process.name.toString();	
				_process.status = xml.Process.status.toString();	
				_process.creator = xml.Process.creator.toString();	
				_process.categoryPath = xml.Process.categoryPath.toString();	
			}
			else
				_process = null;
			
			super.doResult(event);
		}
		
		override protected function doFault(event: FaultEvent): void {
			trace("GetProcessInfoByPackageService: " + event);
			
			super.doFault(event);
		}
	}
}