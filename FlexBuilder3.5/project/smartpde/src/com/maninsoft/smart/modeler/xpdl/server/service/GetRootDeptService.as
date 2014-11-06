////////////////////////////////////////////////////////////////////////////////
//  GetRootDeptService.as
//  2008.04.24, created by gslim
//
//  ============================================================================
//  Copyright (C) 2007-2008 ManInSoft Corp.
//  All Rights Reserved. 
////////////////////////////////////////////////////////////////////////////////

package com.maninsoft.smart.modeler.xpdl.server.service
{
	import com.maninsoft.smart.modeler.xpdl.server.Department;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	/**
	 * Root 부서를 가져오는 서비스
	 */
	public class GetRootDeptService extends ServiceBase {
		
		//----------------------------------------------------------------------
		// Service parameters
		//----------------------------------------------------------------------

		public var compId: String;
		public var userId: String;
		

		//----------------------------------------------------------------------
		// Variables
		//----------------------------------------------------------------------

		private var _dept: Department;
		
		
		//----------------------------------------------------------------------
		// Initialization & Finalization
		//----------------------------------------------------------------------

		/** Constructor */
		public function GetRootDeptService() {
			super("getRootDept");
		}


		//----------------------------------------------------------------------
		// Properties
		//----------------------------------------------------------------------

		/**
		 * dept
		 */
		public function get dept(): Department {
			return _dept;
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
		
		override protected function doResult(event: ResultEvent): void {
			trace(event);
			
			var xml: XML = new XML(StringUtil.trim(event.message.body.toString()));
			
			if (xml.item.length() > 0) {
				_dept = new Department();

				_dept.id	= xml.item.@id;
				_dept.name	= xml.item.@name;
			}
			else
				_dept = null;
			
			super.doResult(event);
		}
		
		override protected function doFault(event: FaultEvent): void {
			trace("GetRootDeptService: " + event);
			
			super.doFault(event);
		}
	}
}